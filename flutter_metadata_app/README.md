# 📸 Photo Metadata Editor (Flutter)

A modern Flutter application for viewing and editing photo metadata with batch operations and template management.

## Features

- **Image Selection**: Pick multiple images for batch processing
- **Metadata Viewing**: View Title, Subject, Tags, Comments, Authors, and Copyright from EXIF data
- **File Operations**: Rename individual files or batch rename all selected images
- **Template Management**: Save, load, and delete metadata templates for reuse
- **Image Preview**: View selected images with navigation controls
- **Cross-Platform**: Works on Windows, macOS, Linux, Android, and iOS
- **Modern UI**: Beautiful Material Design 3 interface with dark/light theme support

## Platform Support

| Feature | Windows | macOS | Linux | Android | iOS |
|---------|---------|-------|-------|---------|-----|
| View EXIF Metadata | ✅ | ✅ | ✅ | ✅ | ✅ |
| Write EXIF Metadata | ❌ | ❌ | ❌ | ⚠️ | ⚠️ |
| File Renaming | ✅ | ✅ | ✅ | ✅ | ✅ |
| Template Management | ✅ | ✅ | ✅ | ✅ | ✅ |

> **Note**: EXIF metadata writing is currently only available on mobile platforms (Android/iOS) and requires additional setup with the `native_exif` package.

## 🚀 Quick Installation (For Non-Technical Users)

### Windows Users
1. **Install Flutter** (if needed): Download from https://flutter.dev/docs/get-started/install
2. **Run the installer**: Double-click `installer.bat`
3. **Follow the prompts**: The installer will handle everything automatically
4. **Use the app**: Double-click the desktop shortcut that gets created

### macOS/Linux Users
1. **Install Flutter** (if needed): `brew install flutter` (macOS) or `sudo snap install flutter --classic` (Linux)
2. **Run the installer**: `chmod +x installer.sh && ./installer.sh`
3. **Follow the prompts**: The installer will handle everything automatically
4. **Use the app**: Double-click the desktop shortcut that gets created

### 📖 Detailed Installation Guide
For step-by-step instructions with screenshots, see [INSTALL.md](INSTALL.md)

## 🛠️ Manual Installation (For Developers)

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- A supported platform (Windows, macOS, Linux, Android, iOS)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/topplanecreator/photo-metadata-app.git
   cd flutter_metadata_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Quick Start Scripts

### Windows
- Double-click `installer.bat` for automatic installation
- Double-click `start.bat` to run the app
- Or run `flutter run` in Command Prompt

### macOS/Linux
- Run `./installer.sh` for automatic installation
- Run `./run.sh` to run the app
- Or run `flutter run` directly

## Usage

### Selecting Images
1. Click the "Select Images" button
2. Choose one or more image files (JPG, PNG, GIF, BMP)
3. The selected images will appear in the preview area

### Viewing Metadata
1. Select images to view their existing EXIF metadata
2. The metadata form will display current values (if any)
3. You can view Title, Subject, Tags, Comments, Authors, and Copyright

### File Operations
- **Rename Current**: Rename the currently selected image
- **Batch Rename**: Rename all selected images with a base name and sequential numbering
- **Navigation**: Use Previous/Next buttons to navigate between selected images

### Template Management
- **Save Template**: Save current metadata as a reusable template
- **Load Template**: Load a previously saved template
- **Delete Template**: Remove unwanted templates

### Metadata Operations (Mobile Only)
- **Apply Metadata**: Apply the current metadata to all selected images (Android/iOS only)
- **Clear Metadata**: Remove all metadata from selected images (Android/iOS only)

## Architecture

The app is built with a clean architecture:

- **Models**: `MetadataModel` for data structure
- **Services**: `MetadataService` for business logic
- **Screens**: Main editor screen
- **Widgets**: Reusable UI components
  - `MetadataForm`: Metadata input fields
  - `ImagePreview`: Image display with navigation
  - `TemplateManager`: Template operations
  - `FileControls`: File operations

## Dependencies

- `file_picker`: For selecting image files
- `path`: For file path operations
- `exif`: For reading EXIF metadata
- `shared_preferences`: For template storage

## Building for Distribution

### Windows
```bash
flutter build windows --release
```
The executable will be in `build/windows/runner/Release/`

### macOS
```bash
flutter build macos --release
```
The app will be in `build/macos/Build/Products/Release/`

### Linux
```bash
flutter build linux --release
```
The executable will be in `build/linux/x64/release/bundle/`

### Android
```bash
flutter build apk --release
```
The APK will be in `build/app/outputs/flutter-apk/`

### iOS
```bash
flutter build ios --release
```
Requires Xcode and iOS development setup.

## Troubleshooting

### Common Issues

1. **Flutter not found**: Install Flutter from https://flutter.dev/docs/get-started/install
2. **Dependencies not found**: Run `flutter pub get`
3. **Build errors**: Make sure you have the latest Flutter version
4. **EXIF writing not working**: This feature is only available on mobile platforms

### Platform-Specific Notes

- **Windows**: Make sure you have Visual Studio Build Tools installed
- **macOS**: Requires Xcode Command Line Tools
- **Linux**: May need additional dependencies for desktop support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple platforms
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Future Enhancements

- Add proper EXIF metadata writing for desktop platforms
- Implement drag-and-drop file selection
- Add batch processing progress indicators
- Support for more image formats
- Export/import metadata templates
- Keyboard shortcuts for common operations 