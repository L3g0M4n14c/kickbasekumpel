#!/bin/zsh
# Xcode Cloud Post-Clone Script
# Runs after Xcode Cloud clones the repository.
# Installs Flutter, generates Dart code, and installs CocoaPods dependencies.
#
# Required Xcode Cloud environment variable (set in App Store Connect → Xcode Cloud → Workflow → Environment):
#   FLUTTER_VERSION  – Flutter release, exact (e.g. "3.32.2") or wildcard (e.g. "3.38.x")
#                      Wildcard is resolved to the latest stable patch from the Flutter releases API.
#                      Default 3.47.x: pubspec.yaml requires Dart ^3.9.2 (Flutter 3.35+),
#                      und 3.47.x = die lokal verifizierte Version (CocoaPods-Setup).

set -e

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.x}"
FLUTTER_HOME="$HOME/flutter"
MACHINE_ARCH="$(uname -m)"   # arm64 or x86_64

# ── Resolve download URL from Flutter releases JSON ──────────────────────────
# Picks the correct architecture-specific archive from the official releases JSON,
# avoiding both manual URL construction and CPU-type mismatches.
echo "=== Resolving Flutter download URL for ${FLUTTER_VERSION} (arch: ${MACHINE_ARCH}) ==="

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
arch = os.environ["MACHINE_ARCH"]  # "arm64" or "x86_64"

# Filter by channel + version pattern
if version_input.endswith(".x"):
    prefix = version_input[:-2] + "."
    candidates = [r for r in data["releases"]
                  if r["channel"] == "stable" and r["version"].startswith(prefix)]
else:
    candidates = [r for r in data["releases"]
                  if r["channel"] == "stable" and r["version"] == version_input]

if not candidates:
    print(f"ERROR: No stable macOS release found for '{version_input}'", file=sys.stderr)
    sys.exit(1)

# Pick the latest patch version first
candidates.sort(key=lambda r: [int(x) for x in r["version"].split(".")])
latest_version = candidates[-1]["version"]
candidates = [r for r in candidates if r["version"] == latest_version]

# Prefer architecture-specific archive; fall back to any if not found
if arch == "arm64":
    arch_matches = [r for r in candidates if "arm64" in r["archive"]]
else:
    arch_matches = [r for r in candidates if "arm64" not in r["archive"]]

release = (arch_matches or candidates)[0]
print(f"  Resolved version : {release['version']}", file=sys.stderr)
print(f"  Archive          : {release['archive']}", file=sys.stderr)
print(f"{base_url}/{release['archive']}")
PYEOF

FLUTTER_URL=$(RELEASES_JSON="$RELEASES_JSON" FLUTTER_VERSION="$FLUTTER_VERSION" \
              MACHINE_ARCH="$MACHINE_ARCH" python3 "$RESOLVER_PY")

rm -f "$RELEASES_JSON" "$RESOLVER_PY"

# ── Download & extract ────────────────────────────────────────────────────────
echo "=== Installing Flutter ==="
echo "  URL: $FLUTTER_URL"

FLUTTER_ARCHIVE="/tmp/flutter_sdk_download"
curl -fL --progress-bar "$FLUTTER_URL" -o "$FLUTTER_ARCHIVE"

if [[ "$FLUTTER_URL" == *.zip ]]; then
  unzip -q "$FLUTTER_ARCHIVE" -d "$HOME"
else
  tar -xf "$FLUTTER_ARCHIVE" -C "$HOME"
fi
rm -f "$FLUTTER_ARCHIVE"

export PATH="$FLUTTER_HOME/bin:$PATH"

echo "Flutter ready:"
flutter --version --no-version-check

# Wichtig: CocoaPods-basiertes Build-Setup erzwingen. Das Flutter-Tool migriert
# neue Projekte sonst automatisch zu Swift Package Manager (SPM) – in Kombi
# mit Firebase-Pods entstehen dann Duplicate-Symbol-Links und Xcode 27+
# macht niedrige Package-Deployment-Targets in Xcode Cloud zu harten Fehlern.
# Der Podfile-post_install-Bump (iOS 15.0) regelt die Targets stattdessen.
flutter config --no-enable-swift-package-manager

# ci_post_clone.sh runs from ios/ci_scripts/ – all project commands need repo root.
REPO_ROOT="${CI_PRIMARY_REPOSITORY_PATH:-$(cd "$(dirname "$0")/../.." && pwd)}"
echo "Repo root: $REPO_ROOT"
cd "$REPO_ROOT"

echo "=== Installing Dart dependencies ==="
# pub get also writes Generated.xcconfig with FLUTTER_ROOT so Xcode's
# Run Script build phase can locate the Flutter SDK during xcodebuild.
flutter pub get

# ── Eindeutige Build-Nummer für App Store Connect ─────────────────────────────
# Xcode Cloud registriert jeden Archiv-Build in App Store Connect (Schritt
# "Preparing build for App Store Connect"). Steht in pubspec.yaml eine feste
# Build-Nummer (z.B. 1.0.0+1), hat jeder Build dieselbe CFBundleVersion ("1")
# und kollidiert mit dem bereits registrierten Build 1.0.0(1). Der Schritt
# schlägt dann ohne klare Log-Meldung fehl ("Preparing build for App Store
# Connect failed"). → Build-Nummer pro Xcode-Cloud-Build auf CI_BUILD_NUMBER
# setzen und Generated.xcconfig (FLUTTER_BUILD_NUMBER) neu generieren.
if [ -n "${CI_BUILD_NUMBER:-}" ]; then
  echo "=== Setze Flutter Build-Nummer auf CI_BUILD_NUMBER=${CI_BUILD_NUMBER} ==="
  sed -i '' -E \
    "s/^(version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+)[0-9]+/\1${CI_BUILD_NUMBER}/" \
    "$REPO_ROOT/pubspec.yaml"
  grep '^version:' "$REPO_ROOT/pubspec.yaml"
  flutter pub get
fi

# HINWEIS: build_runner wird hier NICHT ausgeführt. Die generierten Dateien
# (*/\*.freezed.dart, */\*.g.dart) sind committed. Ein build_runner-Lauf mit
# neueren Flutter-SDKs (Dart ≥ 3.10) crasht, weil der von freezed 2.x gepinnte
# Analyzer die Dot-Shorthand-Syntax im Flutter-Framework nicht parsen kann.
# → Bei Modell-Änderungen build_runner LOKAL ausführen und Results committen.

echo "=== Installing CocoaPods dependencies ==="
cd ios
pod install

echo "=== ci_post_clone.sh complete ==="
