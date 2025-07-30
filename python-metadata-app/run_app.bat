@echo off
echo Installing Python dependencies...
pip install pillow piexif
echo.
echo Starting Photo Metadata Editor...
python main.py
pause 