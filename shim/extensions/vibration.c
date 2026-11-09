/* pinball.vibration — no vibration hardware is assumed. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"vibrate", R_BOOL, 1},
    {"cancel", R_BOOL, 1},
    {"hasVibrator", R_BOOL, 0},
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
