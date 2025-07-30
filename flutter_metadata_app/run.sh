#!/bin/bash

# Photo Metadata Editor - Run Script for Linux/macOS
# This script sets up and runs the Flutter app

echo "📸 Photo Metadata Editor"
echo "========================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
echo "🔍 Checking Flutter installation..."
flutter --version

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Check if we're on a supported platform
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🐧 Running on Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Running on macOS"
else
    echo "⚠️  Unsupported platform: $OSTYPE"
    echo "This app is designed for Linux and macOS"
fi

# Run the app
echo "🚀 Starting Photo Metadata Editor..."
flutter run

if [ $? -ne 0 ]; then
    echo "❌ Failed to run the app"
    echo "Try running 'flutter doctor' to check your setup"
    exit 1
fi 