/* pinball.ane.getbuild — device/build queries used by the Starling check. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"getModel", R_STR, 0, 0, 0, "WindowsPC"},
    {"getVersionRelease", R_STR, 0, 0, 0, "13"},
    {"getBuild", R_STR, 0, 0, 0, "81"},
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
