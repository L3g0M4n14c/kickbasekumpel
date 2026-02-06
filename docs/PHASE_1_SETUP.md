# Phase 1: Setup & Infrastruktur (1.5h)

**Status:** ✅ 100% Fertig | 🎉 Alle Tasks erledigt!  
**Dauer:** 1.5 Stunden | **Copilot:** 85% | **User:** 15%  

---

## 🎯 Objectives

- [x] Flutter Projekt erstellen (de.legomaniac.kickbasekumpel)
- [x] Dependencies konfigurieren (Riverpod, Firebase, GoRouter)
- [x] .devcontainer für GitHub Codespaces
- [x] GitHub Repository erstellen
- [x] Firebase Projekt + Credentials
- [x] Credentials lokal integrieren

---

## ✅ Was bereits erledigt ist

### 1. Flutter Projekt Struktur
```
✅ lib/main.dart - Riverpod ProviderScope + Firebase init
✅ lib/config/firebase_config.dart
✅ lib/config/firebase_options.dart (Platzhalter)
✅ lib/config/router.dart - GoRouter Setup
✅ lib/config/theme.dart - Material Design 3
✅ lib/presentation/pages/home_page.dart - Starter Page
```

### 2. Dependencies (pubspec.yaml)
```yaml
✅ riverpod: ^2.6.0
✅ flutter_riverpod: ^2.6.0
✅ go_router: ^14.2.0
✅ firebase_core: ^3.5.0
✅ firebase_auth: ^5.2.0
✅ cloud_firestore: ^5.2.0
✅ freezed_annotation: ^2.4.4
✅ json_annotation: ^4.9.0
✅ http: ^1.2.2
✅ html: ^0.15.4
```

### 3. .devcontainer Config
```
✅ .devcontainer/devcontainer.json
   - Flutter 3.9 Image
   - Post-create: flutter pub get + build_runner
   - Extensions: Flutter, Dart, Copilot
```

### 4. Firebase Credentials
```
✅ lib/config/firebase_options.dart
   - Web: apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId, measurementId
   - Android: Mit angepassten Credentials
   - iOS: Mit angepassten Credentials
✅ iOS Deployment Target auf 15.0 erhöht (Podfile)
```

### 5. Riverpod Router Integration
```
✅ lib/config/router.dart
   - GoRouter als Riverpod Provider
   - Correct ProviderListenable type
```

---

## ✅ Phase 1b: GitHub + Firebase Setup (Fertig!)

### Schritt 1: GitHub Repository erstellen

**Ort:** https://github.com/new

```
Repository name: kickbasekumpel-flutter
Description: KickbaseKumpel - Kickbase Fantasy League Manager
Private: ✅ Ja
Add .gitignore: ✅ Dart
Add license: ⚪ (optional)
```

**Nach Erstellung:**

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

# Git initialisieren
git init
git add .
git commit -m "Initial: Flutter + Firebase + Riverpod Setup (Phase 1)"
git branch -M main

# Remote hinzufügen (USERNAME durch GitHub Username ersetzen)
git remote add origin https://github.com/USERNAME/kickbasekumpel-flutter.git
git push -u origin main
```

---

### Schritt 2: Firebase Projekt erstellen

**Ort:** https://console.firebase.google.com/

1. **Klick "Projekt erstellen"**
   - Projektname: `kickbasekumpel-dev`
   - Analytics: ⚪ (optional für MVP)
   - Kostenlos Plan: ✅

2. **iOS App registrieren**
   - Bundle ID: `de.legomaniac.kickbasekumpel`
   - Team ID: (dein Apple Team ID aus Xcode)
   - Download: `GoogleService-Info.plist`

3. **Android App registrieren**
   - Package name: `de.legomaniac.kickbasekumpel`
   - Download: `google-services.json`

4. **Web App registrieren** (für Firebase Hosting)
   - Nickname: `kickbasekumpel-web`
   - Copy: Firebase Config (für web später)

---

### Schritt 3: Credentials integrieren

**Android Credentials:**
```bash
# google-services.json von Firebase Console kopieren
cp ~/Downloads/google-services.json \
   /Users/marcocorro/Documents/vscode/kickbasekumpel/android/app/

# Überprüfen
cat android/app/google-services.json | head -20
```

**iOS Credentials:**
```bash
# GoogleService-Info.plist von Firebase Console kopieren
cp ~/Downloads/GoogleService-Info.plist \
   /Users/marcocorro/Documents/vscode/kickbasekumpel/ios/Runner/

# Xcode: GoogleService-Info.plist zu Runner Target hinzufügen
# - Xcode öffnen: ios/Runner.xcworkspace
# - Target "Runner" → Build Phases → Copy Bundle Resources
# - Prüfe: GoogleService-Info.plist ist dort
```

---

### Schritt 4: Firebase Options Datei aktualisieren

**Datei:** `lib/config/firebase_options.dart`

**Schritt 4.1: API Key finden**
1. Firebase Console: Project Settings → (dein Projekt)
2. "Service accounts" Tab
3. "Generatener Private Key" (falls benötigt)

**Schritt 4.2: Web Config kopieren**
```javascript
// Firebase Console: Web App Settings
const firebaseConfig = {
  apiKey: "AIzaSyDOCAbC1234567890",
  authDomain: "kickbasekumpel-dev.firebaseapp.com",
  projectId: "kickbasekumpel-dev",
  storageBucket: "kickbasekumpel-dev.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123def456",
  measurementId: "G-ABC123DEF456"
};
```

**Schritt 4.3: In Dart konvertieren**
```bash
# Öffne: lib/config/firebase_options.dart
# Ersetze Platzhalter mit echten Werten von Firebase Console

# Android & iOS: Project Settings → Scroll down für beide Configs
```

---

### Schritt 5: Flutter Pub Get

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel
flutter clean
flutter pub get

# Überprüfung
flutter doctor
```

**Erwartet:**
```
✓ Flutter SDK
✓ Android toolchain
✓ Xcode
✓ Dart
```

---

## 🧪 Validierung: Phase 1 erfolgreich? ✅ JA!

**Prüfliste:**

- [x] GitHub Repo existiert & main branch gepusht
- [x] Firebase Projekt existiert unter https://console.firebase.google.com
- [x] `android/app/google-services.json` liegt vor (bereit zum Herunterladen)
- [x] `ios/Runner/GoogleService-Info.plist` liegt vor (bereit zum Herunterladen)
- [x] `lib/config/firebase_options.dart` mit echten Keys ✅ (Web, Android, iOS)
- [x] `flutter pub get` läuft ohne Fehler ✅
- [x] App erfolgreich auf echtem iPhone deployed! 🎉

**Test starten:**
```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel
flutter run -d web

# Erwartet: Browser öffnet sich mit "Phase 1: Setup erfolgreich! 🚀"
```

---

## 🔗 Nächster Schritt

Wenn alle Checks grün sind: → **[Phase 2: Dart Modelle](./PHASE_2_MODELS.md)**

---

## 🐛 Troubleshooting

### Problem: "Unable to boot simulator"
```bash
xcrun simctl erase all
open -a Simulator
```

### Problem: Firebase Credentials nicht akzeptiert
- Prüfe: Richtige Bundle ID / Package in Firebase Console?
- Prüfe: APIKey in firebase_options.dart von Console kopiert?

### Problem: .devcontainer lädt nicht in Codespaces
- Prüfe: File Encoding UTF-8?
- Prüfe: JSON Syntax valid?

---

## 📋 Zusammenfassung

| Item | Status |
|------|--------|
| Flutter Projekt | ✅ |
| Dependencies | ✅ |
| .devcontainer | ✅ |
| GitHub Repo | ✅ |
| Firebase Projekt | ✅ |
| Credentials | ✅ |
| iOS Deployment Target | ✅ |
| Riverpod Router Integration | ✅ |
| Validierung | ✅ |

**Phase 1b Dauer:** 30-45 Minuten (manuell)  
**Geschätzte Total Phase 1:** 1.5h (incl. GitHub + Firebase Setup)

---

**Fortschritt:** Phase 1 → 100% ✅ **FERTIG!**  
**Nächstes:** → **[Phase 2: Dart Modelle](./PHASE_2_MODELS.md)** 🚀
