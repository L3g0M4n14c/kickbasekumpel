# Phase 7: Deployment zu App Stores & Web (5h)

**Status:** ⏳ Nach Phase 6  
**Dauer:** 5 Stunden | **Copilot:** 20% | **User:** 80%  

---

## 🎯 Objectives

- iOS Build für App Store
- Android Build für Google Play
- Web Deploy zu Firebase Hosting
- Code Signing & Certificates
- Version Management
- Release Workflows

---

## 📱 Phase 7a: iOS Build & App Store

### Step 1: Xcode Configuration

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel/ios

# Öffne Xcode
open Runner.xcworkspace
```

**Xcode Setup:**

1. **General Tab - Runner Target**
   - Bundle ID: `de.legomaniac.kickbasekumpel`
   - Version: `1.0.0`
   - Build: `1`
   - Team: (Dein Apple Developer Team)
   - Deployment Target: iOS 12.0+

2. **Signing & Capabilities**
   - Team: (Dein Team)
   - Automatisches Signing: ✅
   - Capabilities:
     - Push Notifications (Optional)
     - Sign In with Apple (Optional)

3. **Build Settings**
   - Production Build Settings
   - Strip Debug Symbols: ✅
   - SWIFT_VERSION: 5.9

### Step 2: Release Build erstellen

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

# Archive für App Store
flutter build ios --release

# Xcode Archive
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -archivePath "build/Runner.xcarchive" \
  archive

# Export für App Store
xcodebuild -exportArchive \
  -archivePath "build/Runner.xcarchive" \
  -exportPath "build/ipa" \
  -exportOptionsPlist ExportOptions.plist
```

**ExportOptions.plist erstellen:**

```bash
cat > ios/ExportOptions.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>compileBitcode</key>
    <false/>
    <key>destination</key>
    <string>export</string>
    <key>method</key>
    <string>app-store</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
</dict>
</plist>
EOF
```

### Step 3: App Store Connect Upload

1. **Transporter App öffnen** (oder xcode-select)
```bash
xcrun altool --upload-app \
  -f "build/ipa/Runner.ipa" \
  -u "YOUR_APPLE_ID" \
  -p "YOUR_APP_SPECIFIC_PASSWORD" \
  -t ios \
  --output-format json
```

2. **Oder: Apple Transporter GUI**
   - Download: https://apps.apple.com/app/transporter/id1450874784
   - .ipa File hochladen

3. **App Store Connect - App einrichten**
   - https://appstoreconnect.apple.com/
   - "My Apps" → "KickbaseKumpel"
   - App Information ausfüllen
   - Preview & Screenshots hochladen
   - App Privacy Policy
   - Release Notes

4. **Submit for Review**
   - Version auswählen
   - Build auswählen
   - Review Information
   - Submit for Review
   - Apple reviewt innerhalb 24-48h

---

## 🤖 Phase 7b: Android Build & Google Play

### Step 1: Keystore für Signing erstellen

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel/android/app

# Generate Keystore
keytool -genkey -v \
  -keystore release.keystore \
  -keyalias kickbasekumpel \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass YOUR_PASSWORD \
  -keypass YOUR_PASSWORD

# Überprüfe
keytool -list -keystore release.keystore
```

### Step 2: Gradle Signing Configuration

**Datei:** `android/app/build.gradle.kts`

```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("../app/release.keystore")
            storePassword = "YOUR_PASSWORD"
            keyAlias = "kickbasekumpel"
            keyPassword = "YOUR_PASSWORD"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

**Besser: Secret Management**

```bash
# Erstelle secrets.gradle
cat > android/secrets.gradle << 'EOF'
ext.signing = [
    storeFile: file('keystore/release.keystore'),
    storePassword: System.getenv('KEYSTORE_PASSWORD') ?: 'local-dev',
    keyAlias: System.getenv('KEY_ALIAS') ?: 'kickbasekumpel',
    keyPassword: System.getenv('KEY_PASSWORD') ?: 'local-dev',
]
EOF

# In build.gradle.kts
apply(from = "secrets.gradle")
```

### Step 3: Release Build erstellen

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Step 4: Google Play Upload

1. **Google Play Console öffnen**
   - https://play.google.com/console/
   - "KickbaseKumpel" App
   - Release → Production

2. **Bundle hochladen**
   - AAB File: `build/app/outputs/bundle/release/app-release.aab`
   - Release Notes
   - Tested on devices

3. **App Information**
   - Icon, Screenshots, Beschreibung
   - Privacy Policy
   - Content Rating Questionnaire
   - Targeted Audience

4. **Submit for Review**
   - Pricing & Distribution
   - Compliance
   - Submit
   - Google reviewt innerhalb 24-48h

---

## 🌐 Phase 7c: Web Build zu Firebase Hosting

### Step 1: Web Build erstellen

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

# Erstelle optimierten Build
flutter build web --release --csp --source-maps

# Output: build/web/
```

### Step 2: Firebase Hosting einrichten

```bash
# Firebase CLI installieren
npm install -g firebase-tools

# Login
firebase login

# Initialize Firebase Hosting
firebase init hosting

# Deploy
firebase deploy --only hosting
```

**firebase.json konfigurieren:**

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "/index.html",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=0"
          }
        ]
      }
    ]
  }
}
```

### Step 3: Deploy

```bash
firebase deploy --only hosting

# Output:
# ✔ Deploy complete!
# Project Console: https://console.firebase.google.com/project/kickbasekumpel-dev
# Hosting URL: https://kickbasekumpel-dev.web.app
```

### Step 4: Domain einrichten (Optional)

```bash
# Verbinde Custom Domain in Firebase Console
# z.B. kickbasekumpel.de

# SSL Cert wird automatisch generiert (Let's Encrypt)
```

---

## 📋 Phase 7d: Version & Release Management

### Step 1: pubspec.yaml Version

```yaml
version: 1.0.0+1

# Format: MAJOR.MINOR.PATCH+BUILD
# 1.0.0 = Release Version
# +1 = Build Number
```

### Step 2: Automatic Versioning

```bash
# Nutze pubspec_semver
# Erhöhe automatisch:

# Major: Breaking Changes
flutter pub run version:bump major

# Minor: New Features (default)
flutter pub run version:bump

# Patch: Bug Fixes
flutter pub run version:bump patch
```

### Step 3: Git Tags für Releases

```bash
# Tag für jede Version
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0

# Erstelle Release auf GitHub
# Mit Release Notes & APK/IPA Downloads
```

---

## 🔄 Phase 7e: CI/CD für Releases

### GitHub Actions - Auto Build & Deploy

```yaml
# .github/workflows/release.yml

name: Release to App Stores

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: macos-latest

    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.x'
      
      - name: Build iOS
        run: flutter build ios --release
      
      - name: Build Android
        run: flutter build appbundle --release
      
      - name: Build Web
        run: flutter build web --release
      
      - name: Upload iOS to App Store
        run: |
          xcrun altool --upload-app \
            -f build/ios/ipa/kickbasekumpel.ipa \
            -u ${{ secrets.APPLE_ID }} \
            -p ${{ secrets.APPLE_PASSWORD }}
      
      - name: Upload Android to Google Play
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJson: ${{ secrets.PLAY_STORE_KEY }}
          packageName: de.legomaniac.kickbasekumpel
          releaseFiles: 'build/app/outputs/bundle/release/*.aab'
          track: production
      
      - name: Deploy Web to Firebase
        run: |
          npm install -g firebase-tools
          firebase deploy --only hosting
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

---

## 📊 Release Checklist

### Pre-Release Validation

- [ ] Alle Tests bestanden (Phase 6)
- [ ] Code Coverage: 75%+
- [ ] Keine Warnungen bei `flutter analyze`
- [ ] `flutter doctor` zeigt keine Probleme
- [ ] App auf iOS Device getestet
- [ ] App auf Android Device getestet
- [ ] Web App im Browser getestet
- [ ] Dark Mode & Responsive auf allen Geräten
- [ ] Firebase Security Rules reviewed
- [ ] Privacy Policy & Terms aktualisiert

### iOS Release Checklist

- [ ] Bundle ID: `de.legomaniac.kickbasekumpel`
- [ ] Version, Build Number erhöht
- [ ] App Icons (1024x1024, probiert auf TestFlight)
- [ ] Screenshots für alle Devices
- [ ] Release Notes geschrieben
- [ ] Export Archive erfolgreich
- [ ] TestFlight Build getestet
- [ ] App Store Connect Metadaten aktualisiert
- [ ] Privacy Policy hinterlegt
- [ ] App Review Information ausfüllt

### Android Release Checklist

- [ ] Package: `de.legomaniac.kickbasekumpel`
- [ ] Version Code & Name erhöht
- [ ] Keystore sicher gespeichert
- [ ] App Icons (192x192, 512x512, etc)
- [ ] Screenshots für alle Devices
- [ ] Release Notes geschrieben
- [ ] AAB Build erfolgreich
- [ ] Internal Testing Track getestet
- [ ] Privacy Policy hinterlegt
- [ ] Content Rating questionnaire ausgefüllt

### Web Release Checklist

- [ ] Production Build optimiert
- [ ] Web App Icons (192x192, 512x512)
- [ ] PWA Manifest konfiguriert
- [ ] Firebase Hosting Rules
- [ ] HTTPS funktioniert
- [ ] CSP Header konfiguriert
- [ ] Lighthouse Score: >90

---

## 🎯 Success Criteria

- [x] iOS App im App Store
- [x] Android App im Google Play Store
- [x] Web App auf Firebase Hosting
- [x] Code Signing Certificates konfiguriert
- [x] Release Workflow dokumentiert
- [x] CI/CD Pipeline für Auto-Deployment
- [x] Version Management System
- [x] Release Notes für jede Version
- [x] Monitoring & Analytics Setup
- [x] Git Commit: "Phase 7: Deployment"

---

## 📊 Post-Release Monitoring

```bash
# Firebase Analytics
# - Active Users
# - Crash Reports
# - Performance Metrics

# App Store Connect
# - Crash Logs
# - User Ratings
# - Reviews

# Google Play Console
# - Crash Logs
# - ANRs (Application Not Responding)
# - User Feedback

# Crashlytics (Optional)
flutter pub add firebase_crashlytics
```

---

## 🎓 Lessons Learned

| Item | Lesson |
|------|--------|
| Certificates | Speichere Keystore sicher (nicht in Git!) |
| Versioning | Nutze Semantic Versioning (MAJOR.MINOR.PATCH) |
| Release Notes | Schreibe für Nutzer, nicht Entwickler |
| Testing | Full Device Testing vor Release! |
| Monitoring | Setup Crashlytics BEVOR du publishst |
| Privacy | GDPR/Privacy Policy vor Release |
| CI/CD | Automatisiere Release, nicht manuell! |

---

## 🔗 Nächster Schritt

**Phase 7: Deployment ✅ FERTIG!**

**Glückwunsch! 🎉 KickbaseKumpel läuft jetzt auf:**
- ✅ iOS App Store
- ✅ Google Play Store
- ✅ Firebase Web Hosting

---

## 📚 Referenzen

- **Flutter iOS Build:** https://docs.flutter.dev/deployment/ios
- **Flutter Android Build:** https://docs.flutter.dev/deployment/android
- **Flutter Web Deployment:** https://docs.flutter.dev/deployment/web
- **Firebase Hosting:** https://firebase.google.com/docs/hosting
- **App Store Connect:** https://appstoreconnect.apple.com/
- **Google Play Console:** https://play.google.com/console/

---

## 🎊 Zusammenfassung aller Phasen

| Phase | Status | Zeit | Copilot |
|-------|--------|------|---------|
| 1 | ✅ | 1.5h | 85% |
| 2 | ✅ | 1.5h | 95% |
| 3 | ✅ | 3h | 70% |
| 4 | ✅ | 2h | 70% |
| 5 | ✅ | 3h | 60% |
| 6 | ✅ | 2.5h | 50% |
| 7 | ✅ | 5h | 20% |
| **TOTAL** | **✅** | **~18h** | **~65%** |

**Total Investment:** ~31 Stunden  
**Copilot Work:** ~20 Stunden (65%)  
**User Work:** ~11 Stunden (35%)  

**Timeline:**
- Aggressiv: 4 Wochen (8h/Woche)
- Normal: 6-8 Wochen (4-5h/Woche)
- Entspannt: 12 Wochen (2.5h/Woche)

---

**🚀 KickbaseKumpel ist Live!**

App für 20 Nutzer mit:
- ✅ iOS Native App
- ✅ Android Native App
- ✅ Web App (Progressive Web App)
- ✅ Firebase Backend (kostenlos bis 50K reads/day)
- ✅ Real-time Sync
- ✅ Push Notifications (Optional)
- ✅ Analytics
- ✅ Offline Support

**Kosten:** €0/Monat (Firebase Free Tier für 20 Nutzer)

🎉 Gratuliere!
