/* com.sesisoft.KakaoGameSdk — minimal Kakao (zinny3) SDK client.
 *
 * The game's title scene talks to the Kakao SDK ANE before it ever calls
 * the game server (pinball.scene.title.TitleScene):
 *
 *   KGSESSION_LOADAPPINFOS -> app infos (server + CDN addresses, app id)
 *   KGSESSION_START        -> device login -> accessToken (zat) + playerId
 *   KGAPPOPTION_GET*       -> addresses/options used to build the game API
 *
 * This shim implements that against a private server:
 *   - base URL from WF_SERVER, <exe dir>\wfshim_server.txt,
 *     %TEMP%\wfshim_server.txt, else http://127.0.0.1:8000
 *   - LOADAPPINFOS answers with a synthetic app-info list for that base
 *   - START/LOGIN/CONNECT POST /openapi/service/v4/auth/loginDevice (JSON)
 *     and return the zat + playerId from the response
 *   - app options answer from the same base (game / CDN / friend servers)
 */
#include "../shim_common.h"

#include <winhttp.h>
#include <time.h>
#pragma comment(lib, "winhttp.lib")

#define WF_APPID     "561429"                                     /* World Flipper (NA) */
#define WF_APPSECRET "8a4421148b884608bb96862f3988d832"
#define WF_APPADMIN  "c14e19deb5c734b93a5e65c4d2099e0c"
#define WF_DEVICEID  "WFPC-2026-0001"
#define WF_SERIALNO  "WFPC-2026-0001"
#define WF_WHITEKEY  "WFPC-2026-0001-device"
#define WF_FAIL      "{\"isSuccess\":\"false\",\"resultCode\":\"-1\"}"

static char g_server[512] = "";
static char g_cdn[640] = "";
static int  g_serverLoaded = 0;
static char g_lastResult[8192] = WF_FAIL;

/* ---- server URL config --------------------------------------------- */
static int wfReadLine(const char *path, char *out, int cap) {
    FILE *f = NULL;
    char buf[512];
    char *s, *e;
    if (fopen_s(&f, path, "r") != 0 || !f) return 0;
    buf[0] = 0;
    if (!fgets(buf, sizeof(buf), f)) { fclose(f); return 0; }
    fclose(f);
    s = buf;
    while (*s == ' ' || *s == '\t') s++;
    e = s + strlen(s);
    while (e > s && (e[-1] == '\n' || e[-1] == '\r' || e[-1] == ' ' || e[-1] == '\t')) *--e = 0;
    if (!*s) return 0;
    strncpy_s(out, (size_t)cap, s, _TRUNCATE);
    return 1;
}

static void wfServerInit(void) {
    char path[MAX_PATH];
    char exe[MAX_PATH];
    char envbuf[512] = "";
    size_t envlen = 0;
    size_t n;
    if (g_serverLoaded) return;
    g_serverLoaded = 1;
    if (getenv_s(&envlen, envbuf, sizeof(envbuf), "WF_SERVER") == 0 && envlen > 0 && envbuf[0])
        strncpy_s(g_server, sizeof(g_server), envbuf, _TRUNCATE);
    if (!g_server[0] && GetModuleFileNameA(NULL, exe, MAX_PATH)) {
        char *slash = strrchr(exe, '\\');
        if (slash) {
            *slash = 0;
            _snprintf_s(path, sizeof(path), _TRUNCATE, "%s\\wfshim_server.txt", exe);
            if (wfReadLine(path, g_server, sizeof(g_server))) wfNote("shim: server from %s", path);
        }
    }
    if (!g_server[0] && GetTempPathA(MAX_PATH, path)) {
        strcat_s(path, sizeof(path), "wfshim_server.txt");
        if (wfReadLine(path, g_server, sizeof(g_server))) wfNote("shim: server from %s", path);
    }
    if (!g_server[0]) strncpy_s(g_server, sizeof(g_server), "http://127.0.0.1:8000", _TRUNCATE);
    n = strlen(g_server);
    while (n > 0 && g_server[n - 1] == '/') g_server[--n] = 0;
    _snprintf_s(g_cdn, sizeof(g_cdn), _TRUNCATE, "%s/patch/Live/2.0.0", g_server);
    wfNote("shim: server=%s cdn=%s", g_server, g_cdn);
}

/* ---- tiny HTTP POST (WinHTTP) -------------------------------------- */
typedef struct {
    int secure;
    wchar_t host[256];
    INTERNET_PORT port;
    char path[1024];
} WfUrl;

static int wfParseUrl(const char *url, WfUrl *u) {
    const char *p = url;
    const char *slash;
    char hostA[256];
    char *colon;
    size_t hl;
    memset(u, 0, sizeof(*u));
    if (_strnicmp(p, "https://", 8) == 0) { u->secure = 1; p += 8; }
    else if (_strnicmp(p, "http://", 7) == 0) { p += 7; }
    else return 0;
    slash = strchr(p, '/');
    hl = slash ? (size_t)(slash - p) : strlen(p);
    if (hl == 0 || hl >= sizeof(hostA)) return 0;
    memcpy(hostA, p, hl);
    hostA[hl] = 0;
    u->port = (INTERNET_PORT)(u->secure ? 443 : 80);
    colon = strrchr(hostA, ':');
    if (colon && colon[1]) { u->port = (INTERNET_PORT)atoi(colon + 1); *colon = 0; }
    if (MultiByteToWideChar(CP_UTF8, 0, hostA, -1, u->host, 256) <= 0) return 0;
    strncpy_s(u->path, sizeof(u->path), slash ? slash : "/", _TRUNCATE);
    return 1;
}

static int wfHttpPost(const char *url, const char *body, char *out, int outCap) {
    WfUrl u;
    wchar_t wpath[1200];
    HINTERNET hS = NULL, hC = NULL, hR = NULL;
    DWORD status = 0, slen = sizeof(status), len;
    int n = 0, ok = 0;
    if (!wfParseUrl(url, &u)) { wfNote("shim: bad server url '%s'", url); return 0; }
    if (MultiByteToWideChar(CP_UTF8, 0, u.path, -1, wpath, 1200) <= 0) return 0;
    hS = WinHttpOpen(L"WFShim/1.0", WINHTTP_ACCESS_TYPE_NO_PROXY,
                     WINHTTP_NO_PROXY_NAME, WINHTTP_NO_PROXY_BYPASS, 0);
    if (!hS) goto done;
    WinHttpSetTimeouts(hS, 4000, 4000, 4000, 8000);
    hC = WinHttpConnect(hS, u.host, u.port, 0);
    if (!hC) goto done;
    hR = WinHttpOpenRequest(hC, L"POST", wpath, NULL, WINHTTP_NO_REFERER,
                            WINHTTP_DEFAULT_ACCEPT_TYPES, u.secure ? WINHTTP_FLAG_SECURE : 0);
    if (!hR) goto done;
    len = (DWORD)strlen(body);
    if (!WinHttpSendRequest(hR, L"Content-Type: application/json\r\n", (DWORD)-1L,
                            (LPVOID)body, len, len, 0)) goto done;
    if (!WinHttpReceiveResponse(hR, NULL)) goto done;
    WinHttpQueryHeaders(hR, WINHTTP_QUERY_STATUS_CODE | WINHTTP_QUERY_FLAG_NUMBER,
                        WINHTTP_HEADER_NAME_BY_INDEX, &status, &slen, WINHTTP_NO_HEADER_INDEX);
    for (;;) {
        DWORD avail = 0, read = 0;
        if (!WinHttpQueryDataAvailable(hR, &avail) || avail == 0) break;
        if (n >= outCap - 1) break;
        if (avail > (DWORD)(outCap - 1 - n)) avail = (DWORD)(outCap - 1 - n);
        if (!WinHttpReadData(hR, out + n, avail, &read) || read == 0) break;
        n += (int)read;
    }
    out[n] = 0;
    wfNote("shim: POST %s -> HTTP %lu (%d bytes)", u.path, (unsigned long)status, n);
    ok = (status == 200 && n > 0);
done:
    if (hR) WinHttpCloseHandle(hR);
    if (hC) WinHttpCloseHandle(hC);
    if (hS) WinHttpCloseHandle(hS);
    if (!ok) wfNote("shim: POST %s failed", url);
    return ok;
}

/* ---- tiny JSON helpers --------------------------------------------- */
static int wfJsonStr(const char *json, const char *key, char *out, int cap) {
    char pat[160];
    const char *p;
    int n = 0;
    if (!json || !key) return 0;
    _snprintf_s(pat, sizeof(pat), _TRUNCATE, "\"%s\"", key);
    p = strstr(json, pat);
    if (!p) return 0;
    p += strlen(pat);
    while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') p++;
    if (*p != ':') return 0;
    p++;
    while (*p == ' ' || *p == '\t' || *p == '\r' || *p == '\n') p++;
    if (*p != '"') return 0;
    p++;
    while (*p && *p != '"' && n < cap - 1) {
        if (*p == '\\' && p[1]) p++;
        out[n++] = *p++;
    }
    out[n] = 0;
    return 1;
}

static void wfJsonEsc(const char *in, char *out, int cap) {
    int n = 0;
    if (!in) in = "";
    while (*in && n < cap - 2) {
        if (*in == '"' || *in == '\\') { out[n++] = '\\'; out[n++] = *in++; }
        else if (*in == '\n') { out[n++] = '\\'; out[n++] = 'n'; in++; }
        else if (*in == '\r') in++;
        else out[n++] = *in++;
    }
    out[n] = 0;
}

/* ---- SDK operations ------------------------------------------------ */
static void wfLoadAppInfos(void) {
    static const char *infos =
        "[{\"appId\":\"" WF_APPID "\",\"dataMap\":{"
        "\"countryCodes\":\"us\","
        "\"countryCodeList\":\"us,ca,mx,br,ar,cl,co,pe,ec,uy,py,bo,ve,cr,pa,do,gt,hn,ni,sv\","
        "\"displayName\":\"World Flipper (NA)\","
        "\"isServiceAvailable\":\"true\","
        "\"bannedCountryCodeList\":\"-\","
        "\"forceServerSelectDeviceList\":\"\""
        "}}]";
    char esc[1024];
    wfServerInit();
    wfJsonEsc(infos, esc, sizeof(esc));
    _snprintf_s(g_lastResult, sizeof(g_lastResult), _TRUNCATE,
                "{\"isSuccess\":\"true\",\"serverInfos\":\"%s\"}", esc);
    wfNote("shim: loadAppInfos ok");
}

static int wfLogin(void) {
    char url[1024];
    char body[2048];
    char resp[32768];
    char zat[2048];
    char pid[64];
    char zatE[2400];
    char pidE[160];
    long long now;
    wfServerInit();
    _snprintf_s(url, sizeof(url), _TRUNCATE,
                "%s/openapi/service/v4/auth/loginDevice", g_server);
    now = (long long)time(NULL) * 1000;
    _snprintf_s(body, sizeof(body), _TRUNCATE,
        "{\"adid\":\"%s\",\"appId\":\"%s\",\"appSecret\":\"%s\",\"appAdmin\":\"%s\","
        "\"appVer\":\"0.0.81\",\"clientTime\":%lld,\"country\":\"us\",\"deviceId\":\"%s\","
        "\"deviceModel\":\"WindowsPC\",\"fields\":[],\"gsiToken\":false,\"idpId\":\"%s\","
        "\"lang\":\"en\",\"loginType\":\"zd3\",\"market\":\"google\",\"network\":\"wifi\","
        "\"os\":\"a\",\"osVer\":\"13\",\"referrer\":\"\",\"resume\":false,\"retryNo\":\"0\","
        "\"sdkVer\":\"3.0\",\"serialNo\":\"%s\",\"telecom\":\"\",\"timezoneOffset\":0,"
        "\"usimCountry\":\"\",\"whiteKey\":\"%s\"}",
        WF_DEVICEID, WF_APPID, WF_APPSECRET, WF_APPADMIN, now,
        WF_DEVICEID, WF_WHITEKEY, WF_SERIALNO, WF_WHITEKEY);
    zat[0] = 0;
    pid[0] = 0;
    if (!wfHttpPost(url, body, resp, sizeof(resp))) {
        strncpy_s(g_lastResult, sizeof(g_lastResult), WF_FAIL, _TRUNCATE);
        return 0;
    }
    if (!wfJsonStr(resp, "zat", zat, sizeof(zat)) ||
        !wfJsonStr(resp, "playerId", pid, sizeof(pid))) {
        wfNote("shim: login response missing zat/playerId");
        strncpy_s(g_lastResult, sizeof(g_lastResult), WF_FAIL, _TRUNCATE);
        return 0;
    }
    wfJsonEsc(zat, zatE, sizeof(zatE));
    wfJsonEsc(pid, pidE, sizeof(pidE));
    _snprintf_s(g_lastResult, sizeof(g_lastResult), _TRUNCATE,
        "{\"isSuccess\":\"true\",\"isLoggedIn\":\"true\",\"playerId\":\"%s\","
        "\"accessToken\":\"%s\",\"idpProfile\":\"{\\\"idpCode\\\":\\\"zd3\\\","
        "\\\"idpUserId\\\":\\\"%s\\\",\\\"idpAccessToken\\\":\\\"\\\"}\"}",
        pidE, zatE, pidE);
    wfNote("shim: login ok playerId=%s zat=%u chars", pid, (unsigned)strlen(zat));
    return 1;
}

static const char *wfAppOption(const char *key) {
    wfServerInit();
    if (!key) return "";
    if (strcmp(key, "gameServerAddr") == 0 || strcmp(key, "urlFriendFollowServer") == 0)
        return g_server;
    if (strcmp(key, "cdnAddr") == 0) return g_cdn;
    if (strcmp(key, "useCoupon") == 0) return "true";
    if (strcmp(key, "useGoogleGame") == 0) return "FALSE";
    if (strcmp(key, "hideFacebook") == 0) return "false";
    if (strcmp(key, "isReproduceS3UploadOpen") == 0) return "false";
    if (strcmp(key, "isServiceAvailable") == 0) return "true";
    if (strcmp(key, "refreshInfodeskIntervalMin") == 0) return "60";
    return "";
}

const Spec g_specs[] = {
    {"GETLASTRESULT", R_STR, 0, 0, 0, NULL}, /* dynamic: returns g_lastResult */
    {"KGSESSION_LOGIN", R_BOOL, 1},
    {"KGSESSION_LOGOUT", R_BOOL, 1},
    {"KGSESSION_PAUSE", R_BOOL, 1},
    {"KGSESSION_RESUME", R_BOOL, 1},
    {"KGSESSION_UNREGISTER", R_BOOL, 1},
    {"KGSESSION_CONNECT", R_BOOL, 1},
    {"KGSESSION_START", R_BOOL, 1},
    {"KGSESSION_INITIALIZESDK", R_BOOL, 1},
    {"KGSESSION_LOADAPPINFOS", R_BOOL, 1},
    {"KGSESSIONFORCUSTOMUI_LOGIN", R_BOOL, 0},
    {"KGSESSIONFORCUSTOMUI_LOGOUT", R_BOOL, 1},
    {"KGSESSIONFORCUSTOMUI_CONNECT", R_BOOL, 0},
    {"KGSESSIONFORCUSTOMUI_UNREGISTER", R_BOOL, 1},
    {"KGSYSTEM_GETDEVICEID", R_STR, 0, 0, 0, "WFPC-2026-0001"},
    {"KGSYSTEM_GETDEVICEMODEL", R_STR, 0, 0, 0, "WindowsPC"},
    {"KGSYSTEM_GETOSNAME", R_STR, 0, 0, 0, "Windows"},
    {"KGSYSTEM_GETLANGUAGECODE", R_STR, 0, 0, 0, "en"},
    {"KGSYSTEM_GETCOUNTRYCODE", R_STR, 0, 0, 0, "US"},
    {"KGSYSTEM_GETGEOCOUNTRYCODE", R_STR, 0, 0, 0, "US"},
    {"KGSYSTEM_GETNETWORKTYPE", R_STR, 0, 0, 0, "WIFI"},
    {"KGSYSTEM_ISNETWORKCONNECTED", R_BOOL, 1},
    {"KGAPPOPTION_GETVALUE", R_STR, 0, 0, 0, ""},
    {"KGAPPOPTION_GETGAMESERVERADDRESS", R_STR, 0, 0, 0, ""},
    {"KGAPPOPTION_GETCDNADDRESS", R_STR, 0, 0, 0, ""},
    {"KGAPPOPTION_ISINREVIEW", R_BOOL, 0},
    {"KGAPPOPTION_SHOWUPDATERECOMMENDEDPOPOUP", R_BOOL, 0},
    {"KGPUSH_ENABLEPUSH", R_BOOL, 0},
    {"KGPUSH_ISENABLEPUSH", R_BOOL, 0},
    {"KGLOG_WRITEACTIONLOG", R_BOOL, 1},
    {"KGLOG_WRITEITEMLOG", R_BOOL, 1},
    {"KGLOG_WRITENETWORKLOG", R_BOOL, 1},
    {"KGLOG_WRITERESOURCELOG", R_BOOL, 1},
    {"KGLOG_WRITEROUNDLOG", R_BOOL, 1},
    {"KGCOUPON_SHOWCOUPONPOPUP", R_BOOL, 0},
    {"KGGOOGLEGAMESACHIEVEMENTS_SHOWACHIEVEMENTVIEW", R_BOOL, 0},
    {"KGGOOGLEGAMESACHIEVEMENTS_UNLOCK", R_BOOL, 0},
    {"KGGOOGLEGAMES_ISLOGGEDIN", R_BOOL, 0},
    {"KGGOOGLEGAMES_LOGIN", R_BOOL, 0},
    {"KGGOOGLEGAMES_LOGOUT", R_BOOL, 1},
    {"KGIDPPROFILE_REFRESHLOCALIDPPROFILE", R_BOOL, 0},
    {"KGLOCALPLAYER_GETCURRENTPLAYER", R_STR, 0, 0, 0, ""},
    {"KGPLAYER_LOADFRIENDPLAYERS", R_STR, 0, 0, 0, "[]"},
    {"KGPROMOTION_SHOWENDINGPROMOTIONPOPUPS", R_BOOL, 0},
    {"KGPROMOTION_SHOWSTARTINGPROMOTIONPOPUPS", R_BOOL, 0},
    {"KGSUPPORT_SHOWCWVIEW", R_BOOL, 0},
    {"KGSUPPORT_SHOWDAUMCAFEVIEW", R_BOOL, 0},
    {"KGSUPPORT_SHOWEVENTPROGRESSWALL", R_BOOL, 0},
    {"KGSUPPORT_SHOWEVENTWALL", R_BOOL, 0},
    {"KGSUPPORT_SHOWGACHAODDSVIEW", R_BOOL, 0},
    {"KGSUPPORT_SHOWINAPPWEBVIEW", R_BOOL, 0},
    {"KGSUPPORT_SHOWNOTICEONLYVIEW", R_BOOL, 0},
    {"KGSUPPORT_SHOWNOTICEVIEW", R_BOOL, 0},
    {"KGSUPPORT_SHOWNOTICEVIEWFORONEDAY", R_BOOL, 0},
    {"SESISOFT_GETTELEPHONYCOUNTRY", R_STR, 0, 0, 0, "US"},
    {"SESISOFT_OPENGOOGLEPLAY", R_VOID},
    {"isSupported", R_BOOL, 0},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

FREObject shim_custom_dispatch(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]) {
    if (strcmp(sp->name, "GETLASTRESULT") == 0)
        return retStr(g_lastResult[0] ? g_lastResult : WF_FAIL);
    if (strcmp(sp->name, "KGAPPOPTION_GETGAMESERVERADDRESS") == 0) {
        wfServerInit();
        return retStr(g_server);
    }
    if (strcmp(sp->name, "KGPROMOTION_SHOWSTARTINGPROMOTIONPOPUPS") == 0 ||
        strcmp(sp->name, "KGPROMOTION_SHOWENDINGPROMOTIONPOPUPS") == 0) {
        /* The game's home startup waits for a status event after these calls.
           Return a valid "no promotion" JSON result and dispatch the event,
           otherwise HomeScene keeps startup input locked forever. */
        strncpy_s(g_lastResult, sizeof(g_lastResult), "{\"isSuccess\":\"false\"}", _TRUNCATE);
        FREDispatchStatusEventAsync(ctx, (const uint8_t *)sp->name,
                                         (const uint8_t *)g_lastResult);
        return retBool(1);
    }
    if (strcmp(sp->name, "KGAPPOPTION_GETCDNADDRESS") == 0) {
        wfServerInit();
        return retStr(g_cdn);
    }
    if (strcmp(sp->name, "KGAPPOPTION_GETVALUE") == 0) {
        char key[128];
        key[0] = 0;
        if (argc > 0) getArgStr(argv[0], key, sizeof(key));
        return retStr(wfAppOption(key));
    }
    if (strncmp(sp->name, "KGSESSION_", 10) == 0 ||
        strncmp(sp->name, "KGSESSIONFORCUSTOMUI_", 22) == 0) {
        /* every session call must answer with a status event so the game
           clears its _isWaitingResponse flag and pulls the JSON result */
        if (strcmp(sp->name, "KGSESSION_LOADAPPINFOS") == 0)
            wfLoadAppInfos();
        else if (strcmp(sp->name, "KGSESSION_START") == 0 ||
                 strcmp(sp->name, "KGSESSION_LOGIN") == 0 ||
                 strcmp(sp->name, "KGSESSION_CONNECT") == 0 ||
                 strcmp(sp->name, "KGSESSIONFORCUSTOMUI_LOGIN") == 0 ||
                 strcmp(sp->name, "KGSESSIONFORCUSTOMUI_CONNECT") == 0)
            wfLogin();
        else
            strncpy_s(g_lastResult, sizeof(g_lastResult), "{\"isSuccess\":\"true\"}", _TRUNCATE);
        FREDispatchStatusEventAsync(ctx, (const uint8_t *)sp->name,
                                         (const uint8_t *)g_lastResult);
        return retBool(1);
    }
    return NULL;
}
