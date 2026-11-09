/* Selects exactly one extension translation unit for this DLL.
 * The build passes one of the EXT_* defines (see build-shim.bat).
 */
#if defined(EXT_APP)
#include "app.c"
#elif defined(EXT_BATTERY)
#include "battery.c"
#elif defined(EXT_CORE)
#include "core.c"
#elif defined(EXT_GAMESVC)
#include "gameservices.c"
#elif defined(EXT_BILLING)
#include "iap.c"
#elif defined(EXT_KAKAO)
#include "kakao.c"
#elif defined(EXT_GETBUILD)
#include "getbuild.c"
#elif defined(EXT_PUSH)
#include "push.c"
#elif defined(EXT_SINGULAR)
#include "singular.c"
#elif defined(EXT_CHECKAPP)
#include "checkapp.c"
#elif defined(EXT_SCREEN)
#include "screen.c"
#elif defined(EXT_VIBRATION)
#include "vibration.c"
#elif defined(EXT_ASSETDL)
#include "assetdl.c"
#elif defined(EXT_GXSHIELD)
#include "gxshield.c"
#else
#error "Define exactly one EXT_* (EXT_APP, EXT_BATTERY, ...) before compiling extensions/select.c."
#endif
