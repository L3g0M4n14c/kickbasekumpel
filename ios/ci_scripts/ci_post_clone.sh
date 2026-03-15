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

# ── Resolve download URL from Flutter releases JSON ──────────────────────────
# Uses the official 'archive' field to avoid guessing filename patterns
# (arm64 vs universal, naming changes across Flutter versions).
echo "=== Resolving Flutter download URL for ${FLUTTER_VERSION} ==="

RELEASES_JSON="/tmp/flutter_releases.json"
RESOLVER_PY="/tmp/flutter_resolve.py"

curl -fsSL \
  "https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json" \
  -o "$RELEASES_JSON"

cat > "$RESOLVER_PY" << 'PYEOF'
import sys, json, os

data = json.load(open(os.environ["RELEASES_JSON"]))
base_url = data["base_url"]
version_input = os.environ["FLUTTER_VERSION"]

if version_input.endswith(".x"):
    prefix = version_input[:-2] + "."
    releases = [r for r in data["releases"]
                if r["channel"] == "stable" and r["version"].startswith(prefix)]
else:
    releases = [r for r in data["releases"]
                if r["channel"] == "stable" and r["version"] == version_input]

if not releases:
    print(f"ERROR: No stable macOS release found for '{version_input}'", file=sys.stderr)
    sys.exit(1)

releases.sort(key=lambda r: [int(x) for x in r["version"].split(".")])
release = releases[-1]
print(f"  Resolved version : {release['version']}", file=sys.stderr)
print(f"  Archive          : {release['archive']}", file=sys.stderr)
print(f"{base_url}/{release['archive']}")
PYEOF

FLUTTER_URL=$(RELEASES_JSON="$RELEASES_JSON" python3 "$RESOLVER_PY")

rm -f "$RELEASES_JSON" "$RESOLVER_PY"

echo "=== Installing Flutter ==="
echo "  URL: $FLUTTER_URL"
curl -fL --progress-bar "$FLUTTER_URL" -o /tmp/flutter.tar.xz

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
