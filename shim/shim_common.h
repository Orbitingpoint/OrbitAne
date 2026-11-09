/* Shared declarations for the World Flipper FRE shim.
 *
 * One DLL is compiled per extension. The extension-specific tables and
 * custom dispatch live in extensions/<name>.c; extensions/select.c pulls in
 * exactly the one selected by the EXT_* define used on the compiler command
 * line. Everything in this file is shared by all of them.
 */
#ifndef WF_SHIM_COMMON_H
#define WF_SHIM_COMMON_H

#include <windows.h>
#include <stdio.h>
#include <string.h>
#include "FlashRuntimeExtensions.h"

#ifndef EXT_TAG
#define EXT_TAG unknown
#endif

/* ---- property objects (Object returned by a native call) ---- */
typedef struct { const char *key; int kind; const char *s; double n; } Prop;
#define P_STR(k, v)  { k, 0, v, 0 }
#define P_INT(k, v)  { k, 1, NULL, (double)(v) }
#define P_DBL(k, v)  { k, 2, NULL, (v) }
#define P_BOOL(k, v) { k, 3, NULL, (double)(v) }
#define P_END        { NULL, 0, NULL, 0 }

/* ---- return kinds used by the Spec tables ---- */
enum {
    R_VOID = 0, R_BOOL, R_INT, R_DBL, R_STR, R_OBJ,
    R_STORE_STR, R_STORE_BOOL, R_STORE_INT, R_STORE_DBL
};

typedef struct {
    const char *name;
    int ret;
    uint32_t b;
    int32_t i;
    double d;
    const char *s;
    const Prop *props;
    const char *storeNs; /* for R_STORE_* */
    int broadcast;       /* nonzero: dispatch battery-style event then NULL */
} Spec;

/* Defined by the selected extensions/<name>.c. */
extern const Spec g_specs[];

/* ---- diagnostics ---- */
void shimlog(const char *func, uint32_t argc);
void wfNote(const char *fmt, ...);

/* ---- FRE value helpers ---- */
FREObject retBool(uint32_t v);
FREObject retInt(int32_t v);
FREObject retDouble(double v);
FREObject retStr(const char *s);
FREObject retNumVec(const double *vals, int count);
FREObject retObj(const Prop *props);

/* ---- in-memory defaults/settings store ---- */
const char *storeGet(const char *ns, const char *key);
void storeSet(const char *ns, const char *key, const char *val);
int getArgStr(FREObject arg, char *out, int outlen);

/* ---- standard table-driven dispatch ---- */
FREObject dispatchSpec(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]);

/* ---- extension-specific dispatch ----
 * Return a value to short-circuit the standard dispatch, or NULL to let the
 * caller fall through to dispatchSpec().  Every extensions/<name>.c defines
 * this, either with real logic or with SHIM_CUSTOM_NONE().
 */
FREObject shim_custom_dispatch(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]);

#define SHIM_CUSTOM_NONE() \
    FREObject shim_custom_dispatch(FREContext ctx, const Spec *sp, uint32_t argc, FREObject argv[]) { \
        (void)ctx; (void)sp; (void)argc; (void)argv; \
        return NULL; \
    }

#endif /* WF_SHIM_COMMON_H */
