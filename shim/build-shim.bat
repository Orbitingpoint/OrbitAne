@echo off
REM Build every FRE shim DLL (x64 + x86).
REM
REM Usage:  build-shim.bat
REM Env:    AIRSDK  = AIR SDK root            (default C:\AIRSDK\AIRSDK_51.4.1)
REM         VCVARS64/VCVARS32 = override the VS build environment scripts
REM
REM Each line pairs an EXT_* extension (extensions/<name>.c) with the file
REM name that extension.xml declares, and the tag used for
REM %TEMP%\wfshim_<tag>.log.
setlocal enabledelayedexpansion
set SHIMDIR=%~dp0
cd /d "%SHIMDIR%"
if "%AIRSDK%"=="" set AIRSDK=%AIR_HOME%
if "%AIRSDK%"=="" set AIRSDK=%~dp0..\tools\air
if not exist "%AIRSDK%\include\FlashRuntimeExtensions.h" if exist "C:\AIRSDK\AIRSDK_51.4.1\include\FlashRuntimeExtensions.h" set AIRSDK=C:\AIRSDK\AIRSDK_51.4.1
set INCL=%AIRSDK%\include
set LIB64=%AIRSDK%\lib\win64\FlashRuntimeExtensions.lib
set LIB86=%AIRSDK%\lib\win\FlashRuntimeExtensions.lib
set SRC="%SHIMDIR%shim.c" "%SHIMDIR%shim_common.c" "%SHIMDIR%extensions\select.c"

if not exist "%INCL%\FlashRuntimeExtensions.h" (
  echo ERROR: %INCL%\FlashRuntimeExtensions.h not found.
  echo Set AIRSDK to your Harman AIR SDK folder.
  exit /b 1
)

if not defined VCVARS64 goto :find_vcvars
goto :have_vcvars

:find_vcvars
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" goto :default_vcvars
set "VSDIR="
for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSDIR=%%i"
if not defined VSDIR goto :default_vcvars
set "VCVARS64=%VSDIR%\VC\Auxiliary\Build\vcvars64.bat"
set "VCVARS32=%VSDIR%\VC\Auxiliary\Build\vcvars32.bat"
goto :have_vcvars

:default_vcvars
set "VCVARS64=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set "VCVARS32=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"

:have_vcvars
if exist "%VCVARS64%" goto :vcvars_ok
echo ERROR: vcvars64.bat not found:
echo   "%VCVARS64%"
echo Set VCVARS64/VCVARS32 to your Visual Studio build scripts.
exit /b 1

:vcvars_ok

mkdir "%SHIMDIR%x64" 2>nul
mkdir "%SHIMDIR%x86" 2>nul

call "%VCVARS64%" >NUL
cl /nologo /LD /I"%INCL%" /DEXT_APP      /DEXT_TAG=app       %SRC% /Fe"%SHIMDIR%x64\dqapp.dll"     /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_BATTERY  /DEXT_TAG=batt      %SRC% /Fe"%SHIMDIR%x64\dqbatt.dll"    /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_CORE     /DEXT_TAG=core      %SRC% /Fe"%SHIMDIR%x64\dqcore.dll"    /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_GAMESVC  /DEXT_TAG=game      %SRC% /Fe"%SHIMDIR%x64\dqgame.dll"    /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_BILLING  /DEXT_TAG=iap       %SRC% /Fe"%SHIMDIR%x64\dqiap.dll"     /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_KAKAO    /DEXT_TAG=kakao     %SRC% /Fe"%SHIMDIR%x64\kakao.dll"     /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_GETBUILD /DEXT_TAG=getbuild  %SRC% /Fe"%SHIMDIR%x64\getbuild.dll"  /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_PUSH     /DEXT_TAG=push      %SRC% /Fe"%SHIMDIR%x64\push.dll"      /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_SINGULAR /DEXT_TAG=singular  %SRC% /Fe"%SHIMDIR%x64\singular.dll"  /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_CHECKAPP /DEXT_TAG=checkapp  %SRC% /Fe"%SHIMDIR%x64\checkapp.dll"  /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_SCREEN   /DEXT_TAG=screen    %SRC% /Fe"%SHIMDIR%x64\screen.dll"    /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_VIBRATION /DEXT_TAG=vibration %SRC% /Fe"%SHIMDIR%x64\vibration.dll" /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_ASSETDL  /DEXT_TAG=assetdl   %SRC% /Fe"%SHIMDIR%x64\assetdl.dll"   /link "%LIB64%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_GXSHIELD /DEXT_TAG=gxshield  %SRC% /Fe"%SHIMDIR%x64\gxshield.dll"  /link "%LIB64%" || exit /b 1

call "%VCVARS32%" >NUL
cl /nologo /LD /I"%INCL%" /DEXT_APP      /DEXT_TAG=app       %SRC% /Fe"%SHIMDIR%x86\dqapp.dll"     /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_BATTERY  /DEXT_TAG=batt      %SRC% /Fe"%SHIMDIR%x86\dqbatt.dll"    /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_CORE     /DEXT_TAG=core      %SRC% /Fe"%SHIMDIR%x86\dqcore.dll"    /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_GAMESVC  /DEXT_TAG=game      %SRC% /Fe"%SHIMDIR%x86\dqgame.dll"    /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_BILLING  /DEXT_TAG=iap       %SRC% /Fe"%SHIMDIR%x86\dqiap.dll"     /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_KAKAO    /DEXT_TAG=kakao     %SRC% /Fe"%SHIMDIR%x86\kakao.dll"     /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_GETBUILD /DEXT_TAG=getbuild  %SRC% /Fe"%SHIMDIR%x86\getbuild.dll"  /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_PUSH     /DEXT_TAG=push      %SRC% /Fe"%SHIMDIR%x86\push.dll"      /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_SINGULAR /DEXT_TAG=singular  %SRC% /Fe"%SHIMDIR%x86\singular.dll"  /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_CHECKAPP /DEXT_TAG=checkapp  %SRC% /Fe"%SHIMDIR%x86\checkapp.dll"  /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_SCREEN   /DEXT_TAG=screen    %SRC% /Fe"%SHIMDIR%x86\screen.dll"    /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_VIBRATION /DEXT_TAG=vibration %SRC% /Fe"%SHIMDIR%x86\vibration.dll" /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_ASSETDL  /DEXT_TAG=assetdl   %SRC% /Fe"%SHIMDIR%x86\assetdl.dll"   /link "%LIB86%" || exit /b 1
cl /nologo /LD /I"%INCL%" /DEXT_GXSHIELD /DEXT_TAG=gxshield  %SRC% /Fe"%SHIMDIR%x86\gxshield.dll"  /link "%LIB86%" || exit /b 1

echo ALL SHIM DLLS BUILT

