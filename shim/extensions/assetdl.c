/* pinball.assetDownload — the game fetches its asset archives through this
 * extension. A local bundle.zip already carries the base assets, so a
 * download reports itself finished and the game keeps the local data.
 */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"startDownload", R_VOID}, /* dynamic: emits progress/completed status */
    {"setTimeout", R_BOOL, 1},
    {"setMessageTexts", R_BOOL, 1},
    {"setDebugOauthKey", R_BOOL, 1},
    {"finishDownload", R_BOOL, 1},
    {"cancel", R_BOOL, 1},
    {"getProgressRatio", R_DBL, 0, 0, 1.0},
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

FREObject shim_custom_dispatch(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]) {
    (void)argv;
    if (strcmp(sp->name, "startDownload") == 0) {
        wfNote("shim: startDownload argc=%u -> reporting complete", (unsigned)argc);
        FREDispatchStatusEventAsync(ctx, (const uint8_t *)"progress", (const uint8_t *)"1");
        FREDispatchStatusEventAsync(ctx, (const uint8_t *)"completed", (const uint8_t *)"");
        return retBool(1);
    }
    return NULL;
}
