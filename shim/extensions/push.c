/* com.sesisoft.PushService — no-op push table. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"IS_PUSH_INITIALIZED", R_BOOL, 0},
    {"TRY_INITIALIZE_PUSH", R_BOOL, 0},
    {"focus", R_BOOL, 1},
    {"scheduleLocalNotificationByMsec", R_BOOL, 1},
    {"cancelLocalNotification", R_BOOL, 1},
    {"cancelAllLocalNotification", R_BOOL, 1},
    {"isSupported", R_BOOL, 0},
    {"version", R_STR, 0, 0, 0, "1.0.0-win"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
