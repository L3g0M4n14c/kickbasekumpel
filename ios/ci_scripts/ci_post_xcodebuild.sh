#!/bin/sh
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
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadBitcode</key>
    <false/>
</dict>
</plist>
EOF

  xcodebuild -exportArchive \
    -archivePath "${CI_ARCHIVE_PATH}" \
    -exportPath "${EXPORT_DIR}" \
    -exportOptionsPlist /tmp/ExportOptions.plist \
    -allowProvisioningUpdates

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
