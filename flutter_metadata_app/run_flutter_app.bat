@echo off
echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo Flutter is not installed. Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo.
echo Installing Flutter dependencies...
flutter pub get

echo.
echo Starting Flutter Photo Metadata Editor...
flutter run
pause 