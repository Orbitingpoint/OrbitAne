/* com.distriqt.GameServices — offline stub: nothing is signed in. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"isSupported", R_BOOL, 0},
    {"isServiceSupported", R_BOOL, 0},
    {"isSignedIn", R_BOOL, 0},
    {"version", R_STR, 0, 0, 0, "0"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {"initialiseService", R_BOOL, 0},
    {"disconnect", R_VOID},
    {"signIn", R_VOID},
    {"signOut", R_VOID},
    {"getPlayer", R_VOID},
    {"loadPlayer", R_VOID},
    {"loadPlayerIcon", R_VOID},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
