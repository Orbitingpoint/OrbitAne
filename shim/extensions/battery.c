/* com.distriqt.Battery — one shot of battery info via a status event. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "3.0.003.0"},
    {"implementation", R_STR, 0, 0, 0, "windows"},
    {"getBatteryInfo", R_VOID, 0, 0, 0, NULL, NULL, NULL, 1},
    {"cancel", R_VOID},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
