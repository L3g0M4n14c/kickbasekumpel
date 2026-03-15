#!/bin/sh
# Xcode Cloud Post-Clone Script
# Runs after Xcode Cloud clones the repository.
# Installs Flutter, generates Dart code, and installs CocoaPods dependencies.
#
# Required Xcode Cloud environment variable (set in App Store Connect → Xcode Cloud → Workflow → Environment):
#   FLUTTER_VERSION  – exact Flutter release, e.g. "3.32.2"
#                      Must match flutter-version in .github/workflows/deploy.yml.

set -e

FLUTTER_VERSION="${FLUTTER_VERSION:-3.32.2}"
FLUTTER_HOME="$HOME/flutter"

echo "=== Installing Flutter $FLUTTER_VERSION ==="
curl -L --progress-bar \
  "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${FLUTTER_VERSION}-stable.tar.xz" \
  -o /tmp/flutter.tar.xz

tar -xf /tmp/flutter.tar.xz -C "$HOME"
rm /tmp/flutter.tar.xz

export PATH="$FLUTTER_HOME/bin:$PATH"

echo "Flutter ready:"
flutter --version --no-version-check

echo "=== Installing Dart dependencies ==="
# pub get also writes Generated.xcconfig with FLUTTER_ROOT so Xcode's
# Run Script build phase can locate the Flutter SDK during xcodebuild.
flutter pub get

echo "=== Generating code (Freezed / build_runner) ==="
flutter pub run build_runner build --delete-conflicting-outputs

echo "=== Installing CocoaPods dependencies ==="
cd ios
pod install
cd ..

echo "=== ci_post_clone.sh complete ==="
