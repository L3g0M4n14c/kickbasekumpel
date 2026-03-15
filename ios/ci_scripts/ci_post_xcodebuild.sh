#!/bin/zsh
# Xcode Cloud Post-Xcodebuild Script
# Runs after every xcodebuild invocation (build & archive).
# Exports the IPA via Ad Hoc and uploads it to Firebase App Distribution.
#
# Required Xcode Cloud environment variables (set in App Store Connect → Xcode Cloud → Workflow → Environment):
#   FIREBASE_APP_ID_IOS             – Firebase iOS App ID  (e.g. 1:123456789:ios:abc123)
#   FIREBASE_SERVICE_ACCOUNT_JSON   – Contents of the Firebase service-account JSON (mark as Secret)
#   APPLE_TEAM_ID                   – Apple Developer Team ID (e.g. 894UP99QHD)
#
# Optional:
#   FIREBASE_TESTER_GROUPS          – Comma-separated tester group names (default: internal-testers)
#   FLUTTER_VERSION                 – Same value as in ci_post_clone.sh (needed for PATH)

set -e

# ── 1. Skip when the build itself failed ──────────────────────────────────────
if [ "${CI_XCODEBUILD_EXIT_CODE}" != "0" ]; then
  echo "Build failed (exit code ${CI_XCODEBUILD_EXIT_CODE}). Skipping distribution."
  exit 0
fi

# ── 2. Skip non-archive actions (e.g. test runs) ─────────────────────────────
if [ -z "${CI_ARCHIVE_PATH}" ]; then
  echo "No CI_ARCHIVE_PATH set – this is not an archive action. Skipping."
  exit 0
fi

echo "Archive: ${CI_ARCHIVE_PATH}"

# ── 3. Find or export the IPA ─────────────────────────────────────────────────
IPA_PATH=""

# Xcode Cloud sets CI_EXPORT_PATH when the workflow has a distribution step.
if [ -n "${CI_EXPORT_PATH}" ]; then
  IPA_PATH="$(find "${CI_EXPORT_PATH}" -name "*.ipa" | head -1)"
fi

# If Xcode Cloud didn't export (no distribution step configured), do it here.
if [ -z "${IPA_PATH}" ]; then
  echo "=== Exporting IPA (Ad Hoc) from archive ==="

  EXPORT_DIR="/tmp/ipa-adhoc-export"
  mkdir -p "${EXPORT_DIR}"

  # CI_WORKSPACE is set by Xcode Cloud to the root of the cloned repository.
  REPO_ROOT="${CI_WORKSPACE:-/Volumes/workspace/repository}"

  # ── Signing: prefer Fastlane Match when API-key env vars are present ────────
  # Required Xcode Cloud environment variables (App Store Connect → Xcode Cloud →
  # Workflow → Environment):
  #   APP_STORE_CONNECT_API_KEY_ID         – App Store Connect API Key ID
  #   APP_STORE_CONNECT_API_KEY_ISSUER_ID  – App Store Connect Issuer ID
  #   APP_STORE_CONNECT_API_KEY_CONTENT    – Contents of the .p8 file (mark as Secret)
  #   MATCH_GIT_URL                        – HTTPS URL of the private certificates repo
  #   MATCH_PASSWORD                       – Fastlane Match encryption password (Secret)
  #   MATCH_GIT_BASIC_AUTHORIZATION        – base64("username:PAT") for git repo access (Secret)

  REQUIRED_SIGNING_VARS=(
    "APP_STORE_CONNECT_API_KEY_ID"
    "APP_STORE_CONNECT_API_KEY_ISSUER_ID"
    "APP_STORE_CONNECT_API_KEY_CONTENT"
    "MATCH_GIT_URL"
    "MATCH_PASSWORD"
  )

  ALL_SIGNING_VARS_SET=true
  for VAR in "${REQUIRED_SIGNING_VARS[@]}"; do
    if [ -z "${(P)VAR}" ]; then
      ALL_SIGNING_VARS_SET=false
      break
    fi
  done

  if [ "${ALL_SIGNING_VARS_SET}" = true ]; then
    echo "=== Setting up code signing via Fastlane Match ==="
    pushd "${REPO_ROOT}" > /dev/null

    # Install Bundler if missing, then install gems from fastlane/Gemfile.
    gem install bundler --no-document --quiet 2>/dev/null || true
    BUNDLE_GEMFILE="${REPO_ROOT}/fastlane/Gemfile" bundle install --quiet

    # Fetch Match certificates and generate ios/ExportOptions.plist.
    BUNDLE_GEMFILE="${REPO_ROOT}/fastlane/Gemfile" bundle exec fastlane setup_signing

    popd > /dev/null
    EXPORT_OPTIONS="${REPO_ROOT}/ios/ExportOptions.plist"
  else
    echo "WARNING: One or more signing env vars are missing."
    echo "  Required: APP_STORE_CONNECT_API_KEY_ID, APP_STORE_CONNECT_API_KEY_ISSUER_ID,"
    echo "            APP_STORE_CONNECT_API_KEY_CONTENT, MATCH_GIT_URL, MATCH_PASSWORD"
    echo "  → Add these in App Store Connect → Xcode Cloud → Workflow → Environment."
    echo "    See docs/CI_CD_SETUP.md, section 'Xcode Cloud: iOS-Deploy konfigurieren'."
    echo ""
    echo "Falling back to automatic signing."

    TEAM_ID="${APPLE_TEAM_ID:-894UP99QHD}"
    cat > /tmp/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>${TEAM_ID}</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>signingCertificate</key>
    <string>Apple Distribution</string>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
EOF
    EXPORT_OPTIONS="/tmp/ExportOptions.plist"
  fi

  xcodebuild -exportArchive \
    -archivePath "${CI_ARCHIVE_PATH}" \
    -exportPath "${EXPORT_DIR}" \
    -exportOptionsPlist "${EXPORT_OPTIONS}"

  IPA_PATH="$(find "${EXPORT_DIR}" -name "*.ipa" | head -1)"
fi

if [ -z "${IPA_PATH}" ]; then
  echo "ERROR: Could not locate IPA file."
  exit 1
fi
echo "IPA: ${IPA_PATH}"

# ── 4. Install Firebase CLI ───────────────────────────────────────────────────
echo "=== Installing Firebase CLI ==="
npm install -g firebase-tools --quiet --loglevel=error

# ── 5. Write service-account credentials ─────────────────────────────────────
CREDS_FILE="/tmp/firebase-service-account.json"
echo "${FIREBASE_SERVICE_ACCOUNT_JSON}" > "${CREDS_FILE}"
export GOOGLE_APPLICATION_CREDENTIALS="${CREDS_FILE}"

# ── 6. Upload to Firebase App Distribution ───────────────────────────────────
GROUPS="${FIREBASE_TESTER_GROUPS:-internal-testers}"
RELEASE_NOTES="Xcode Cloud Build ${CI_BUILD_NUMBER:-?} – ${CI_COMMIT_MESSAGE:-auto}"

echo "=== Uploading to Firebase App Distribution (groups: ${GROUPS}) ==="
firebase appdistribution:distribute "${IPA_PATH}" \
  --app "${FIREBASE_APP_ID_IOS}" \
  --groups "${GROUPS}" \
  --release-notes "${RELEASE_NOTES}"

# ── 7. Cleanup ────────────────────────────────────────────────────────────────
rm -f "${CREDS_FILE}"

echo "=== Distribution complete ==="
