#!/bin/bash

# Photo Metadata Editor - GUI Installer for macOS/Linux
# This script provides a user-friendly installation process

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

# Clear screen and show header
clear
echo "========================================"
echo "   📸 Photo Metadata Editor Installer"
echo "========================================"
echo

# Check if Flutter is installed
print_status "🔍 Checking if Flutter is installed..."
if ! command -v flutter &> /dev/null; then
    print_error "❌ Flutter is not installed!"
    echo
    print_warning "📥 Please install Flutter first:"
    echo "   1. Go to: https://flutter.dev/docs/get-started/install"
    echo "   2. Download Flutter for your platform"
    echo "   3. Extract to a folder (e.g., ~/flutter)"
    echo "   4. Add flutter/bin to your PATH"
    echo "   5. Restart this installer"
    echo
    read -p "Press Enter to exit..."
    exit 1
fi

print_success "✅ Flutter is installed!"
echo

# Check Flutter version
print_status "🔍 Checking Flutter version..."
flutter --version
echo

# Install dependencies
print_status "📦 Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    print_error "❌ Failed to install dependencies!"
    read -p "Press Enter to exit..."
    exit 1
fi

print_success "✅ Dependencies installed successfully!"
echo

# Build the app
print_status "🔨 Building the app..."
flutter build windows --release
if [ $? -ne 0 ]; then
    print_error "❌ Failed to build the app!"
    read -p "Press Enter to exit..."
    exit 1
fi

print_success "✅ App built successfully!"
echo

# Create desktop shortcut (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "📋 Creating desktop shortcut..."
    DESKTOP="$HOME/Desktop"
    EXE_PATH="$PWD/build/windows/runner/Release/flutter_metadata_app.exe"
    
    # Create a simple launcher script
    LAUNCHER="$DESKTOP/Photo Metadata Editor.command"
    echo "#!/bin/bash" > "$LAUNCHER"
    echo "cd \"$PWD\"" >> "$LAUNCHER"
    echo "flutter run" >> "$LAUNCHER"
    chmod +x "$LAUNCHER"
    
    print_success "✅ Desktop shortcut created!"
    echo
fi

# Create desktop shortcut (Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_status "📋 Creating desktop shortcut..."
    DESKTOP="$HOME/Desktop"
    LAUNCHER="$DESKTOP/Photo Metadata Editor.desktop"
    
    # Create .desktop file
    echo "[Desktop Entry]" > "$LAUNCHER"
    echo "Version=1.0" >> "$LAUNCHER"
    echo "Type=Application" >> "$LAUNCHER"
    echo "Name=Photo Metadata Editor" >> "$LAUNCHER"
    echo "Comment=Edit photo metadata" >> "$LAUNCHER"
    echo "Exec=cd \"$PWD\" && flutter run" >> "$LAUNCHER"
    echo "Icon=applications-graphics" >> "$LAUNCHER"
    echo "Terminal=true" >> "$LAUNCHER"
    echo "Categories=Graphics;" >> "$LAUNCHER"
    
    chmod +x "$LAUNCHER"
    print_success "✅ Desktop shortcut created!"
    echo
fi

echo "========================================"
print_success "🎉 Installation Complete!"
echo "========================================"
echo
print_status "📱 You can now:"
echo "   • Double-click the desktop shortcut"
echo "   • Or run: flutter run"
echo
print_status "📖 For help, see the README.md file"
echo
read -p "Press Enter to exit..." 