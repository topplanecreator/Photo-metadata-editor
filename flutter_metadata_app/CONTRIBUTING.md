# Contributing to Photo Metadata Editor

Thank you for your interest in contributing to the Photo Metadata Editor! This document provides guidelines for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature
4. Make your changes
5. Test your changes on multiple platforms
6. Submit a pull request

## Development Setup

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Git

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flutter_metadata_app.git
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

## Code Style

- Follow the Dart style guide: https://dart.dev/guides/language/effective-dart/style
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Use proper error handling

## Testing

Before submitting a pull request, please ensure:

- [ ] The app builds successfully on all target platforms
- [ ] All existing functionality still works
- [ ] New features are tested thoroughly
- [ ] No console errors or warnings
- [ ] UI is responsive and accessible

### Testing Checklist

- [ ] Windows desktop
- [ ] macOS desktop
- [ ] Linux desktop
- [ ] Android mobile
- [ ] iOS mobile (if possible)

## Pull Request Guidelines

1. **Title**: Use a clear, descriptive title
2. **Description**: Explain what the PR does and why
3. **Testing**: Describe how you tested the changes
4. **Screenshots**: Include screenshots for UI changes
5. **Breaking Changes**: Note any breaking changes

### PR Template

```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on Windows
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Tested on Android
- [ ] Tested on iOS

## Screenshots
Add screenshots if applicable.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

## Feature Requests

If you have a feature request:

1. Check if it's already been requested
2. Create a new issue with the "enhancement" label
3. Provide a clear description of the feature
4. Explain the use case and benefits

## Bug Reports

When reporting bugs:

1. Use the bug report template
2. Include steps to reproduce
3. Add screenshots if applicable
4. Specify your platform and Flutter version
5. Include error messages or logs

## Platform-Specific Development

### Windows
- Requires Visual Studio Build Tools
- Test with `flutter build windows --release`

### macOS
- Requires Xcode Command Line Tools
- Test with `flutter build macos --release`

### Linux
- May require additional dependencies
- Test with `flutter build linux --release`

### Android
- Requires Android Studio or Android SDK
- Test with `flutter build apk --release`

### iOS
- Requires Xcode and iOS development setup
- Test with `flutter build ios --release`

## Code of Conduct

- Be respectful and inclusive
- Help others learn and grow
- Provide constructive feedback
- Follow the project's coding standards

## Questions?

If you have questions about contributing:

1. Check the existing issues and discussions
2. Create a new issue with the "question" label
3. Join our community discussions

Thank you for contributing to Photo Metadata Editor! 🎉 