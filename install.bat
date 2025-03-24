@echo off
echo [1/3] Installing Express-TS Generator...

:: Set target directory
set TARGET_DIR=%USERPROFILE%\AppData\Local\express-ts-generator
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
)

:: Download script
echo [2/3] Downloading generator...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/imutkarsht/express-ts-generator/main/create-express-app.bat', '%TARGET_DIR%\create-express-app.bat')"

:: Add to PATH
echo [3/3] Configuring PATH...
setx PATH "%PATH%;%TARGET_DIR%" > nul

echo Installation complete!
echo.
echo Please CLOSE and REOPEN your command prompt
echo Then run: create-express-app