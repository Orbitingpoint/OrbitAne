/* com.distriqt.InAppBilling — offline stub: no payments are possible. */
#include "../shim_common.h"

const Spec g_specs[] = {
    {"isSupported", R_BOOL, 0},
    {"isServiceSupported", R_BOOL, 0},
    {"canMakePayments", R_BOOL, 0},
    {"version", R_STR, 0, 0, 0, "0"},
    {"implementation", R_STR, 0, 0, 0, "windows-stub"},
    {"setup", R_BOOL, 0},
    {"cleanup", R_VOID},
    {"getProducts", R_VOID},
    {"getPurchases", R_VOID},
    {"getPendingPurchases", R_VOID},
    {"makePurchase", R_VOID},
    {"finishPurchase", R_VOID},
    {"consumePurchase", R_VOID},
    {"restorePurchases", R_VOID},
    {"getUserData", R_VOID},
    {NULL, 0}
};

SHIM_CUSTOM_NONE()
