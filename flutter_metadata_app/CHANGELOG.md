# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-27

### Added
- Initial release of Photo Metadata Editor
- Cross-platform support for Windows, macOS, Linux, Android, and iOS
- Image selection and preview functionality
- EXIF metadata reading (Title, Subject, Tags, Comments, Authors, Copyright)
- File renaming (individual and batch)
- Template management (save, load, delete)
- Modern Material Design 3 UI with dark/light theme support
- Platform detection and appropriate feature limitations
- Comprehensive documentation and setup scripts

### Features
- **Image Selection**: Pick multiple images for batch processing
- **Metadata Viewing**: View existing EXIF metadata from images
- **File Operations**: Rename individual files or batch rename all selected images
- **Template Management**: Save, load, and delete metadata templates for reuse
- **Image Preview**: View selected images with navigation controls
- **Cross-Platform**: Works on Windows, macOS, Linux, Android, and iOS

### Platform Support
- **Windows**: Full support for viewing metadata and file operations
- **macOS**: Full support for viewing metadata and file operations
- **Linux**: Full support for viewing metadata and file operations
- **Android**: Full support for viewing metadata and file operations
- **iOS**: Full support for viewing metadata and file operations

### Technical Notes
- EXIF metadata writing is currently limited to mobile platforms due to Flutter package limitations
- Desktop platforms show appropriate error messages when attempting to write metadata
- All file operations and template management work across all platforms
- Built with Flutter 3.0+ and Dart 3.0+

### Dependencies
- `file_picker: ^6.1.1` - For selecting image files
- `path: ^1.8.3` - For file path operations
- `exif: ^3.1.2` - For reading EXIF metadata
- `shared_preferences: ^2.2.2` - For template storage

## [Unreleased]

### Planned Features
- EXIF metadata writing for desktop platforms
- Drag-and-drop file selection
- Batch processing progress indicators
- Support for more image formats
- Export/import metadata templates
- Keyboard shortcuts for common operations
- Advanced metadata editing capabilities 