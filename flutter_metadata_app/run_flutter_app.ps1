Write-Host "Checking Flutter installation..." -ForegroundColor Green
try {
    flutter --version
} catch {
    Write-Host "Flutter is not installed. Please install Flutter first." -ForegroundColor Red
    Write-Host "Visit: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`nInstalling Flutter dependencies..." -ForegroundColor Green
flutter pub get

Write-Host "`nStarting Flutter Photo Metadata Editor..." -ForegroundColor Green
flutter run

Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 