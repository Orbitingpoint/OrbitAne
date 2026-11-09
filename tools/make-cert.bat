@echo off
REM Create the self-signed code-signing certificate used for ANE packaging.
REM Change the password here and in build-anes.py (or use --storepass).
setlocal
if "%AIRSDK%"=="" set AIRSDK=%AIR_HOME%
if "%AIRSDK%"=="" set AIRSDK=%~dp0..\tools\air
set OUT=%~dp0..\cert.p12
if exist "%OUT%" (
  echo %OUT% already exists - delete it first if you want to regenerate.
  exit /b 1
)
"%AIRSDK%\bin\adt.bat" -certificate -cn WFLocal -ou "World Flipper" -o Local -c US -validityPeriod 25 2048-RSA "%OUT%" password
if errorlevel 1 exit /b 1
echo Created %OUT% (password: password)
