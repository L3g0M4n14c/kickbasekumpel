#!/bin/zsh
# Xcode Cloud Post-Clone Script
# Runs after Xcode Cloud clones the repository.
# Installs Flutter, generates Dart code, and installs CocoaPods dependencies.
#
# Required Xcode Cloud environment variable (set in App Store Connect → Xcode Cloud → Workflow → Environment):
#   FLUTTER_VERSION  – Flutter release, exact (e.g. "3.32.2") or wildcard (e.g. "3.38.x")
#                      Wildcard is resolved to the latest stable patch from the Flutter releases API.

set -e

FLUTTER_VERSION="${FLUTTER_VERSION:-3.32.2}"
FLUTTER_HOME="$HOME/flutter"

# Resolve "3.38.x" wildcard to the latest stable patch version.
if [[ "$FLUTTER_VERSION" == *".x" ]]; then
  PREFIX="${FLUTTER_VERSION%.x}"
  echo "=== Resolving latest stable Flutter ${PREFIX}.* ==="
  FLUTTER_VERSION=$(curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json" | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)
prefix = '${PREFIX}.'
versions = [r['version'] for r in data['releases'] if r['channel'] == 'stable' and r['version'].startswith(prefix)]
versions.sort(key=lambda v: [int(x) for x in v.split('.')])
print(versions[-1]) if versions else sys.exit(1)
")
  echo "Resolved: $FLUTTER_VERSION"
fi

echo "=== Installing Flutter $FLUTTER_VERSION ==="
curl -fL --progress-bar \
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
