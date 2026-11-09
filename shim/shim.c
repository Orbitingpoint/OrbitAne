/* Windows FRE shim for World Flipper ANEs.
 *
 * This file is only the FRE entry point and the dispatcher. The per-extension
 * function tables and any custom call handling live in extensions/, one file
 * per ANE. Build one DLL per extension with a different EXT_* define:
 *
 *   cl /LD /I<airsdk>\include /DEXT_APP /DEXT_TAG=app ^
 *      shim.c shim_common.c extensions\select.c /Fe:dqapp.dll
 *
 * Every call is logged to %TEMP%\wfshim_<tag>.log so missing methods can be
 * discovered iteratively.
 */
#include "shim_common.h"

static FREObject callDispatch(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[]) {
    const Spec *sp = (const Spec *)funcData;
    FREObject handled;

    shimlog(sp->name, argc);

    /* Extension-specific behaviour (Kakao session/HTTP, screen insets,
       assetDownload status events, ...). */
    handled = shim_custom_dispatch(ctx, sp, argc, argv);
    if (handled) return handled;

    /* Generic path handling used by the distriqt Application shim. */
    if ((strcmp(sp->name, "device_getFilesDir") == 0 ||
         strcmp(sp->name, "device_getExternalFilesDir") == 0)) {
        char path[MAX_PATH];
        if (GetTempPathA(MAX_PATH, path)) return retStr(path);
        return retStr("C:\\Temp\\");
    }

    return dispatchSpec(ctx, sp, argc, argv);
}

#define MAXFUNCS 160
static FRENamedFunction g_funcs[MAXFUNCS];

void contextInitializer(void *extData, const uint8_t *ctxType,
                        FREContext ctx, uint32_t *numFunctionsToTest,
                        const FRENamedFunction **functionsToSet) {
    (void)extData; (void)ctxType; (void)ctx;
    uint32_t n = 0;
    for (const Spec *sp = g_specs; sp->name && n < MAXFUNCS; sp++, n++) {
        g_funcs[n].name = (const uint8_t *)sp->name;
        g_funcs[n].functionData = (void *)sp;
        g_funcs[n].function = &callDispatch;
    }
    *numFunctionsToTest = n;
    *functionsToSet = g_funcs;
}

void contextFinalizer(FREContext ctx) {
    (void)ctx;
}

__declspec(dllexport) void ExtInitializer(void **extDataToSet,
        FREContextInitializer *ctxInitializerToSet,
        FREContextFinalizer *ctxFinalizerToSet) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &contextInitializer;
    *ctxFinalizerToSet = &contextFinalizer;
}

__declspec(dllexport) void ExtFinalizer(void *extData) {
    (void)extData;
}

BOOL APIENTRY DllMain(HINSTANCE h, DWORD r, LPVOID x) {
    (void)h; (void)r; (void)x;
    return TRUE;
}
