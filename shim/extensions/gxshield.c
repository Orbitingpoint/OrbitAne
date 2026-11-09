/* com.sesisoft.gxshield — anti-cheat scanner. Returning null from
 * GXSHIELD_GET_DETECTED means "nothing detected" and the game stops asking.
 */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"GXSHIELD_GET_DETECTED", R_STR, 0, 0, 0, NULL},
    {"GXSHIELD_START", R_BOOL, 1},
    {"GXSHIELD_STOP", R_BOOL, 1},
    {"GXSHIELD_SCAN", R_BOOL, 1},
    {"GXSHIELD_SETCUSTOMUSERID", R_BOOL, 1},
    {"GXSHIELD_GET_RESULT", R_STR, 0, 0, 0, NULL},
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
