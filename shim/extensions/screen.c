/* pinball.screen — cutout handling. A desktop window has no display cutout,
 * so all four insets are zero.
 */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"setLayoutInDisplayCutoutMode", R_BOOL, 1},
    {"resetFullscreen", R_BOOL, 1},
    {"setFullscreen", R_BOOL, 1},
    {"setKeepScreenOn", R_BOOL, 1},
    {"setOnTop", R_BOOL, 1},
    {"getDisplayCutoutInsets", R_VOID}, /* dynamic: Vector.<Number> of 4 zeros */
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

FREObject shim_custom_dispatch(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]) {
    (void)ctx; (void)argc; (void)argv;
    if (strcmp(sp->name, "getDisplayCutoutInsets") == 0) {
        static const double noInsets[4] = {0, 0, 0, 0};
        return retNumVec(noInsets, 4);
    }
    return NULL;
}
