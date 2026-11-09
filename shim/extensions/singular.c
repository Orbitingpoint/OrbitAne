/* com.sesisoft.SingularSdk — no-op analytics table. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"GETLASTRESULT", R_STR, 0, 0, 0, ""},
    {"SINGULAR_INIT", R_BOOL, 1},
    {"SINGULAR_STARTSESSION", R_BOOL, 1},
    {"SINGULAR_START", R_BOOL, 1},
    {"SINGULAR_SETCUSTOMUSERID", R_BOOL, 1},
    {"SINGULAR_UNSETCUSTOMUSERID", R_BOOL, 1},
    {"SINGULAR_EVENT", R_BOOL, 1},
    {"SINGULAR_EVENTWITHARGS", R_BOOL, 1},
    {"SINGULAR_EVENTJSON", R_BOOL, 1},
    {"SINGULAR_REVENUE", R_BOOL, 1},
    {"SINGULAR_CUSTOMREVENUE", R_BOOL, 1},
    {"SINGULAR_INITWITHSINGULARLINK", R_BOOL, 1},
    {"SINGULAR_STARTSESSIONANDLAUNCHURL", R_BOOL, 1},
    {"isSupported", R_BOOL, 0},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
