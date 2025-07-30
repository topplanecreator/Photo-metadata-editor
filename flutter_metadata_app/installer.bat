@echo off
title Photo Metadata Editor - Installer
color 0A

echo.
echo ========================================
echo    📸 Photo Metadata Editor Installer
echo ========================================
echo.

:: Check if Flutter is installed
echo 🔍 Checking if Flutter is installed...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed!
    echo.
    echo 📥 Please install Flutter first:
    echo    1. Go to: https://flutter.dev/docs/get-started/install
    echo    2. Download Flutter for Windows
    echo    3. Extract to C:\flutter
    echo    4. Add C:\flutter\bin to your PATH
    echo    5. Restart this installer
    echo.
    pause
    exit /b 1
)

echo ✅ Flutter is installed!
echo.

:: Install dependencies
echo 📦 Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies!
    pause
    exit /b 1
)

echo ✅ Dependencies installed successfully!
echo.

:: Build the app
echo 🔨 Building the app...
flutter build windows --release
if %errorlevel% neq 0 (
    echo ❌ Failed to build the app!
    pause
    exit /b 1
)

echo ✅ App built successfully!
echo.

:: Create desktop shortcut
echo 📋 Creating desktop shortcut...
set "DESKTOP=%USERPROFILE%\Desktop"
set "EXE_PATH=%CD%\build\windows\runner\Release\flutter_metadata_app.exe"
set "SHORTCUT=%DESKTOP%\Photo Metadata Editor.lnk"

:: Create VBS script to make shortcut
echo Set oWS = WScript.CreateObject("WScript.Shell") > CreateShortcut.vbs
echo sLinkFile = "%SHORTCUT%" >> CreateShortcut.vbs
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> CreateShortcut.vbs
echo oLink.TargetPath = "%EXE_PATH%" >> CreateShortcut.vbs
echo oLink.WorkingDirectory = "%CD%\build\windows\runner\Release" >> CreateShortcut.vbs
echo oLink.Description = "Photo Metadata Editor" >> CreateShortcut.vbs
echo oLink.Save >> CreateShortcut.vbs

cscript //nologo CreateShortcut.vbs
del CreateShortcut.vbs

echo ✅ Desktop shortcut created!
echo.

echo ========================================
echo 🎉 Installation Complete!
echo ========================================
echo.
echo 📱 You can now:
echo    • Double-click the desktop shortcut
echo    • Or run: flutter run
echo.
echo 📖 For help, see the README.md file
echo.
pause 