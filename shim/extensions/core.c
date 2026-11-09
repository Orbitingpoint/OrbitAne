/* com.distriqt.Core — required by the other distriqt ANEs. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"isSupported", R_BOOL, 1},
    {"version", R_STR, 0, 0, 0, "4.0.269.0"},
    {"implementation", R_STR, 0, 0, 0, "windows"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
