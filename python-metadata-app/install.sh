#!/bin/bash

APP_NAME="photo-metadata"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
BIN_NAME="photo-metadata"
DESKTOP_FILE="$HOME/.local/share/applications/$BIN_NAME.desktop"

echo "📸 Installing Photo Metadata Tool..."

# Create install directory
mkdir -p "$INSTALL_DIR"
cp main.py metadata_handler.py icon.png "$INSTALL_DIR"

# Create launcher
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Photo Metadata Tool
Comment=Edit EXIF metadata in JPEG images
Exec=python3 $INSTALL_DIR/main.py
Icon=$INSTALL_DIR/icon.png
Terminal=false
Type=Application
Categories=Graphics;Photography;
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Installed! You can now launch 'Photo Metadata Tool' from your app menu."
