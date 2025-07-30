# 📸 Photo Metadata Editor - Easy Installation Guide

This guide will help you install the Photo Metadata Editor on your computer, even if you don't know programming!

## 🚀 Quick Start (For Non-Technical Users)

### Windows Users

1. **Download Flutter** (if you don't have it):
   - Go to: https://flutter.dev/docs/get-started/install
   - Click "Get Flutter SDK"
   - Download the Windows version
   - Extract to `C:\flutter`

2. **Add Flutter to PATH**:
   - Press `Win + R`, type `sysdm.cpl`, press Enter
   - Click "Environment Variables"
   - Under "System Variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\flutter\bin`
   - Click OK on all windows

3. **Install the App**:
   - Double-click `installer.bat`
   - Follow the on-screen instructions
   - The app will be installed and a desktop shortcut created

### macOS Users

1. **Install Flutter** (if you don't have it):
   - Open Terminal
   - Run: `brew install flutter` (if you have Homebrew)
   - Or download from: https://flutter.dev/docs/get-started/install

2. **Install the App**:
   - Open Terminal
   - Navigate to the app folder
   - Run: `chmod +x installer.sh && ./installer.sh`
   - Follow the on-screen instructions

### Linux Users

1. **Install Flutter** (if you don't have it):
   - Open Terminal
   - Run: `sudo snap install flutter --classic`
   - Or download from: https://flutter.dev/docs/get-started/install

2. **Install the App**:
   - Open Terminal
   - Navigate to the app folder
   - Run: `chmod +x installer.sh && ./installer.sh`
   - Follow the on-screen instructions

## 📱 How to Use the App

### First Time Setup

1. **Double-click the desktop shortcut** (created by the installer)
2. **Wait for the app to start** (first time may take longer)
3. **You're ready to use it!**

### Using the App

1. **Select Images**:
   - Click "Select Images" button
   - Choose your photo files (JPG, PNG, etc.)

2. **View Metadata**:
   - The app will show existing metadata from your photos
   - You can see Title, Subject, Tags, Comments, Authors, Copyright

3. **Rename Files**:
   - Use "Rename Current" to rename one file
   - Use "Batch Rename" to rename all files at once

4. **Save Templates**:
   - Fill in metadata fields
   - Click "Save Template" to save for later use

## 🔧 Troubleshooting

### "Flutter not found" Error

**Windows:**
1. Make sure Flutter is in `C:\flutter\bin`
2. Restart your computer after adding to PATH
3. Open Command Prompt and type: `flutter --version`

**macOS/Linux:**
1. Open Terminal
2. Type: `flutter --version`
3. If not found, install Flutter first

### "Build failed" Error

1. Make sure you have enough disk space (at least 2GB free)
2. Try running: `flutter doctor`
3. Install any missing dependencies it suggests

### App won't start

1. Try running: `flutter run` in the app folder
2. Check if any error messages appear
3. Make sure your antivirus isn't blocking the app

## 📞 Getting Help

If you're still having trouble:

1. **Check the README.md** file for detailed instructions
2. **Look at the error messages** - they often tell you what's wrong
3. **Ask for help** - share the error message with someone who knows programming

## 🎯 What the App Does

- **View Photo Metadata**: See information stored in your photos
- **Rename Files**: Change file names easily
- **Save Templates**: Store metadata for reuse
- **Cross-Platform**: Works on Windows, Mac, and Linux

## ⚠️ Important Notes

- **EXIF Writing**: Currently only works on mobile devices (Android/iOS)
- **Desktop**: You can view metadata and rename files, but not write new metadata
- **File Types**: Supports JPG, PNG, GIF, BMP images
- **Safety**: The app never deletes your original files

## 🆘 Still Stuck?

If nothing else works:

1. **Install Flutter manually** following the official guide
2. **Run the app in development mode**: `flutter run`
3. **Ask a friend who knows programming** for help

---

**Happy photo editing! 📸** 