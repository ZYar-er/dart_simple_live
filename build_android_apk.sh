#!/bin/bash

# Android APK Compilation Script for Simple Live App
# This script sets up the environment and compiles the Android APK

set -e

echo "🚀 Starting Android APK compilation for Simple Live App..."

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Java version
if java -version 2>&1 | grep -q "17"; then
    echo "✅ Java 17 found"
else
    echo "❌ Java 17 required but not found"
    echo "Please install Java 17"
    exit 1
fi

# Set up Flutter if not already available
if ! command -v flutter &> /dev/null; then
    echo "📦 Setting up Flutter..."
    
    # Clone Flutter from GitHub
    if [ ! -d "flutter" ]; then
        echo "Cloning Flutter from GitHub..."
        git clone https://github.com/flutter/flutter.git -b stable --depth 1
    fi
    
    # Add Flutter to PATH
    export PATH="$PATH:$(pwd)/flutter/bin"
    
    # Check Flutter version
    flutter --version
    
    # Configure Flutter for Android
    flutter config --android-sdk $ANDROID_HOME
else
    echo "✅ Flutter found"
fi

# Navigate to the app directory
cd /home/runner/work/dart_simple_live/dart_simple_live/simple_live_app

echo "📦 Installing Flutter dependencies..."
flutter pub get

echo "🔧 Setting up Android build configuration..."

# Ensure Android SDK is available
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  ANDROID_HOME not set. Attempting to detect Android SDK..."
    # Common Android SDK locations
    for path in "$HOME/Android/Sdk" "/usr/lib/android-sdk" "/opt/android-sdk"; do
        if [ -d "$path" ]; then
            export ANDROID_HOME="$path"
            echo "📍 Found Android SDK at: $ANDROID_HOME"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        echo "❌ Android SDK not found. Please install Android SDK"
        echo "You can download it from: https://developer.android.com/studio"
        exit 1
    fi
fi

# Add Android tools to PATH
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

echo "🔨 Building Android APK..."

# Check if signing keys are available for release build
if [ -f "android/key.properties" ]; then
    echo "🔐 Found signing configuration, building signed release APK..."
    flutter build apk --release --split-per-abi
else
    echo "⚠️  No signing configuration found, building debug APK..."
    flutter build apk --debug --split-per-abi
fi

echo "✅ APK compilation completed!"

# List generated APKs
echo "📱 Generated APK files:"
find build/app/outputs/flutter-apk -name "*.apk" -type f

echo "🎉 Android APK compilation finished successfully!"
echo ""
echo "APK files are located in: $(pwd)/build/app/outputs/flutter-apk/"
echo ""
echo "Available APK variants:"
echo "  - app-armeabi-v7a-release.apk (32-bit ARM)"
echo "  - app-arm64-v8a-release.apk (64-bit ARM)"  
echo "  - app-x86_64-release.apk (64-bit x86)"