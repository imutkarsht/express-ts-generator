@echo off
echo Installing Express-TS Generator...

:: Set target directory
set TARGET_DIR=%USERPROFILE%\bin
if not exist "%TARGET_DIR%" (
  mkdir "%TARGET_DIR%"
  setx PATH "%PATH%;%TARGET_DIR%"
  echo Added %TARGET_DIR% to your PATH
)

:: Download script
echo Downloading generator...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/imutkarsht/express-ts-generator/main/create-express-app.sh', '%TARGET_DIR%\create-express-app')"

:: Make executable (Windows doesn't need chmod)
echo Installation complete!
echo.
echo Run: create-express-app to start a new project
echo Note: You may need to restart your command prompt