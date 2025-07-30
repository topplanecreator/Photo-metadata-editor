Write-Host "Installing Python dependencies..." -ForegroundColor Green
pip install pillow piexif

Write-Host "`nStarting Photo Metadata Editor..." -ForegroundColor Green
python main.py

Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 