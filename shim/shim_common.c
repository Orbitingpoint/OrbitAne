/* Shared runtime for the World Flipper FRE shim: logging, FRE value
 * construction, the tiny settings/defaults store, and the table-driven
 * dispatcher. Extension-specific tables live in extensions/.
 */
#include <stdlib.h>
#include <stdarg.h>
#include "shim_common.h"

#define WF_LOGNAME2(t) "wfshim_" #t ".log"
#define WF_LOGNAME(t) WF_LOGNAME2(t)
static const char *WF_LOG = WF_LOGNAME(EXT_TAG);

void shimlog(const char *func, uint32_t argc) {
    char path[MAX_PATH];
    if (!GetTempPathA(MAX_PATH, path)) return;
    if (strlen(path) + 32 >= MAX_PATH) return;
    strcat(path, WF_LOG);
    FILE *f = NULL;
    fopen_s(&f, path, "a");
    if (f) { fprintf(f, "CALL %s argc=%u\n", func, (unsigned)argc); fclose(f); }
}

FREObject retBool(uint32_t v) {
    FREObject o = NULL;
    FRENewObjectFromBool(v, &o);
    return o;
}
FREObject retInt(int32_t v) {
    FREObject o = NULL;
    FRENewObjectFromInt32(v, &o);
    return o;
}
FREObject retDouble(double v) {
    FREObject o = NULL;
    FRENewObjectFromDouble(v, &o);
    return o;
}
FREObject retStr(const char *s) {
    FREObject o = NULL;
    if (!s) return NULL;
    FRENewObjectFromUTF8((uint32_t)strlen(s), (const uint8_t *)s, &o);
    return o;
}

void wfNote(const char *fmt, ...) {
    char path[MAX_PATH];
    FILE *f = NULL;
    va_list ap;
    if (!GetTempPathA(MAX_PATH, path)) return;
    if (strlen(path) + 32 >= MAX_PATH) return;
    strcat(path, WF_LOG);
    fopen_s(&f, path, "a");
    if (!f) return;
    va_start(ap, fmt);
    vfprintf(f, fmt, ap);
    va_end(ap);
    fputc('\n', f);
    fclose(f);
}

/* A Vector.<Number> the ActionScript side can assign to its declared type. */
FREObject retNumVec(const double *vals, int count) {
    FREObject o = NULL;
    int i;
    if (FRENewObject((const uint8_t *)"Vector.<Number>", 0, NULL, &o, NULL) != FRE_OK || !o) {
        o = NULL;
        if (FRENewObject((const uint8_t *)"Array", 0, NULL, &o, NULL) != FRE_OK || !o) return NULL;
    }
    for (i = 0; i < count; i++) {
        FREObject d = retDouble(vals[i]);
        if (d) FRESetArrayElementAt(o, (uint32_t)i, d);
    }
    return o;
}

FREObject retObj(const Prop *props) {
    FREObject o = NULL;
    if (FRENewObject((const uint8_t *)"Object", 0, NULL, &o, NULL) != FRE_OK || !o)
        return NULL;
    for (; props->key; props++) {
        FREObject v = NULL;
        if (props->kind == 0) v = retStr(props->s);
        else if (props->kind == 1) v = retInt((int32_t)props->n);
        else if (props->kind == 2) v = retDouble(props->n);
        else v = retBool((uint32_t)props->n);
        if (v) FRESetObjectProperty(o, (const uint8_t *)props->key, v, NULL);
    }
    return o;
}

/* ---- tiny in-memory string store for defaults/settings ---- */
#define STORE_MAX 128
typedef struct { char key[128]; char val[512]; int used; } StoreEntry;
static StoreEntry g_store[STORE_MAX];

const char *storeGet(const char *ns, const char *key) {
    char full[160];
    _snprintf_s(full, sizeof(full), _TRUNCATE, "%s|%s", ns, key);
    for (int i = 0; i < STORE_MAX; i++)
        if (g_store[i].used && strcmp(g_store[i].key, full) == 0)
            return g_store[i].val;
    return NULL;
}
void storeSet(const char *ns, const char *key, const char *val) {
    char full[160];
    _snprintf_s(full, sizeof(full), _TRUNCATE, "%s|%s", ns, key);
    for (int i = 0; i < STORE_MAX; i++)
        if (g_store[i].used && strcmp(g_store[i].key, full) == 0) {
            strncpy_s(g_store[i].val, sizeof(g_store[i].val), val ? val : "", _TRUNCATE);
            return;
        }
    for (int i = 0; i < STORE_MAX; i++)
        if (!g_store[i].used) {
            strncpy_s(g_store[i].key, sizeof(g_store[i].key), full, _TRUNCATE);
            strncpy_s(g_store[i].val, sizeof(g_store[i].val), val ? val : "", _TRUNCATE);
            g_store[i].used = 1;
            return;
        }
}

int getArgStr(FREObject arg, char *out, int outlen) {
    uint32_t len = 0;
    const uint8_t *s = NULL;
    if (FREGetObjectAsUTF8(arg, &len, &s) != FRE_OK || !s) return 0;
    if (len >= (uint32_t)outlen) len = (uint32_t)outlen - 1;
    memcpy(out, s, len);
    out[len] = 0;
    return 1;
}

FREObject dispatchSpec(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]) {
    (void)argc; (void)argv;
    if (sp->broadcast) {
        FREDispatchStatusEventAsync(ctx, (const uint8_t *)"battery:info", (const uint8_t *)"100|2");
        return NULL;
    }
    switch (sp->ret) {
    case R_BOOL: return retBool(sp->b);
    case R_INT:  return retInt(sp->i);
    case R_DBL:  return retDouble(sp->d);
    case R_STR:  return retStr(sp->s);
    case R_OBJ:  return retObj(sp->props);
    case R_STORE_STR: {
        char key[128] = {0};
        if (argc > 0 && getArgStr(argv[0], key, sizeof(key))) {
            const char *v = storeGet(sp->storeNs, key);
            if (sp->s && !v) v = sp->s; /* default */
            /* setter form: called as set with 2 args -> store argv[1] */
            if (argc > 1 && (strstr(sp->name, "_set") || strstr(sp->name, "save"))) {
                char val[512] = {0};
                if (getArgStr(argv[1], val, sizeof(val))) { storeSet(sp->storeNs, key, val); }
                return retBool(1);
            }
            return retStr(v ? v : "");
        }
        return retStr(sp->s ? sp->s : "");
    }
    case R_STORE_BOOL: {
        char key[128] = {0};
        if (argc > 1 && getArgStr(argv[0], key, sizeof(key))) {
            uint32_t bv = 0;
            FREGetObjectAsBool(argv[1], &bv);
            char tmp[2] = {(char)('0' + (bv ? 1 : 0)), 0};
            storeSet(sp->storeNs, key, tmp);
            return retBool(1);
        }
        if (argc > 0 && getArgStr(argv[0], key, sizeof(key))) {
            const char *v = storeGet(sp->storeNs, key);
            if (v) return retBool((uint32_t)(v[0] == '1'));
            return retBool(sp->b);
        }
        return retBool(sp->b);
    }
    case R_STORE_INT: {
        char key[128] = {0};
        if (argc > 1 && getArgStr(argv[0], key, sizeof(key))) {
            int32_t iv = 0;
            if (FREGetObjectAsInt32(argv[1], &iv) == FRE_OK) {
                char tmp[32];
                _snprintf_s(tmp, sizeof(tmp), _TRUNCATE, "%d", (int)iv);
                storeSet(sp->storeNs, key, tmp);
            }
            return retBool(1);
        }
        if (argc > 0 && getArgStr(argv[0], key, sizeof(key))) {
            const char *v = storeGet(sp->storeNs, key);
            return retInt(v ? atoi(v) : sp->i);
        }
        return retInt(sp->i);
    }
    case R_STORE_DBL: {
        char key[128] = {0};
        if (argc > 1 && getArgStr(argv[0], key, sizeof(key))) {
            double dv = 0;
            if (FREGetObjectAsDouble(argv[1], &dv) == FRE_OK) {
                char tmp[64];
                _snprintf_s(tmp, sizeof(tmp), _TRUNCATE, "%f", dv);
                storeSet(sp->storeNs, key, tmp);
            }
            return retBool(1);
        }
        if (argc > 0 && getArgStr(argv[0], key, sizeof(key))) {
            const char *v = storeGet(sp->storeNs, key);
            return retDouble(v ? atof(v) : sp->d);
        }
        return retDouble(sp->d);
    }
    default: return NULL;
    }
}
