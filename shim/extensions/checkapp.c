/* pinball.checkapp — before the title screen the game asks whether the
 * device is rooted and refuses to run if it is. On Windows it never is.
 */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"isRootUser", R_BOOL, 0},
    {"isDebuggerConnected", R_BOOL, 0},
    {"isEmulator", R_BOOL, 0},
    {"isTampered", R_BOOL, 0},
    {"getModel", R_STR, 0, 0, 0, "WindowsPC"},
    {"getPackageName", R_STR, 0, 0, 0, "com.kakaogames.wdfp"},
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
