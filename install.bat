@echo off
SETLOCAL
echo [1/4] Installing Express-TS Generator...

:: Set target directory
set "TARGET_DIR=%USERPROFILE%\.express-ts-generator\bin"
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
)

:: Download main script
echo [2/4] Downloading generator script...
powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/imutkarsht/express-ts-generator/main/create-express-app.js', '%TARGET_DIR%\create-express-app.js')"

:: Create Windows launcher
echo [3/4] Creating launcher...
(
  echo @echo off
  echo node "%%~dp0create-express-app.js" %%*
) > "%TARGET_DIR%\create-express-app.bat"

:: Add to PATH
echo [4/4] Configuring PATH...
for /f "skip=2 tokens=3*" %%a in ('reg query HKCU\Environment /v PATH') do set "CURRENT_PATH=%%a %%b"
echo %CURRENT_PATH% | find /i "%TARGET_DIR%" > nul || (
  setx PATH "%CURRENT_PATH%;%TARGET_DIR%" > nul
)

echo.
echo Installation complete!
echo PLEASE CLOSE AND REOPEN ALL TERMINAL WINDOWS
echo Then run: create-express-app
echo.
ENDLOCAL