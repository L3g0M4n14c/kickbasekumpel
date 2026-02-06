# 🏆 KickbaseKumpel - Implementierungshandbuch

> **KickbaseKumpel** - Dein persönlicher Kickbase-Manager für iOS, Android & Web mit Firebase Backend

---

## 📊 Projektübersicht

| Aspekt | Details |
|--------|---------|
| **App Name** | KickbaseKumpel |
| **Package** | de.legomaniac.kickbasekumpel |
| **Platforms** | iOS 12+, Android 6+, Web |
| **Framework** | Flutter + Dart |
| **Backend** | Firebase (Firestore + Auth + Functions) |
| **State Management** | Riverpod |
| **Status** | 🚧 Phase 2 abgeschlossen, Phase 3 bereit |

---

## 📚 Dokumentation

Jede Phase hat ihre eigene detaillierte Dokumentation:

### Phase-Guides (in docs/ Ordner)

1. **[PHASE_1_SETUP.md](./docs/PHASE_1_SETUP.md)** - Setup & GitHub (1.5h) ✅ **FERTIG**
   - Flutter Projekt Struktur ✅
   - Dependencies ✅
   - .devcontainer ✅

2. **[PHASE_2_MODELS.md](./docs/PHASE_2_MODELS.md)** - Dart Modelle (1.5h) ✅ **FERTIG**
   - 12 Modell-Dateien erstellt ✅
   - 40+ Freezed Modelle ✅
   - JSON Serialization ✅
   - Build Runner ✅
   - GitHub Repo erstellen ✅
   - Firebase Projekt ✅
   - App deployed auf iPhone ✅

2. **[PHASE_2_MODELS.md](./docs/PHASE_2_MODELS.md)** - Dart Modelle (1.5h)
   - Swift → Dart Conversion
   - Freezed + JSON Serializable
   - build_runner Setup
   - 20+ Modelle migrieren

3. **[PHASE_3_FIREBASE.md](./docs/PHASE_3_FIREBASE.md)** - Firebase Backend (3h)
   - Auth Integration
   - Firestore Repositories
   - Riverpod Providers
   - Security Rules

4. **[PHASE_4_SERVICES.md](./docs/PHASE_4_SERVICES.md)** - Services & API (2h)
   - KickbaseAPIClient
   - LigainsiderService (Web Scraper)
   - HTTP Client Wrapper
   - Error Handling

5. **[PHASE_5_UI.md](./docs/PHASE_5_UI.md)** - UI Screens (3h)
   - GoRouter Navigation
   - 6+ Flutter Screens
   - Shared Widgets
   - Material Design 3

6. **[PHASE_6_TESTING.md](./docs/PHASE_6_TESTING.md)** - Testing & QA (2.5h)
   - Unit Tests
   - Widget Tests
   - Integration Tests
   - Coverage Reports

7. **[PHASE_7_DEPLOYMENT.md](./docs/PHASE_7_DEPLOYMENT.md)** - Deployment (5h)
   - iOS App Store
   - Google Play Store
   - Firebase Hosting (Web)
   - Release Management

---

## 🚀 Quick Start

### Lokal starten

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

# Dependencies
flutter pub get

# Run
flutter run -d web    # Browser
flutter run -d ios    # iOS Simulator
flutter run -d android # Android Emulator
```

### GitHub Codespaces

1. Repo in Codespaces öffnen
2. Warten bis .devcontainer konfiguriert (automatisch)
3. Terminal:
   ```bash
   flutter pub get
   flutter run -d web
   ```

---

## 📁 Verzeichnisstruktur

```
lib/
├── main.dart                    # Entry Point mit Riverpod
├── config/
│   ├── firebase_config.dart
│   ├── firebase_options.dart    # Platzhalter für Secrets
│   ├── router.dart              # GoRouter
│   └── theme.dart               # Material Design 3
├── data/                        # (Phase 2-4)
│   ├── models/                  # Freezed Models
│   ├── repositories/            # Firestore
│   ├── services/                # API Clients
│   └── providers/               # Riverpod
├── domain/                      # (Phase 3-4)
│   ├── repositories/            # Interfaces
│   └── providers/               # Use Cases
└── presentation/                # (Phase 5)
    ├── pages/
    ├── screens/
    └── widgets/

test/                           # (Phase 6)
docs/                           # Phase-Guides
pubspec.yaml                    # Dependencies
.devcontainer/                  # GitHub Codespaces
```

---

## 🛠️ Tech Stack Summary

| Layer | Tech |
|-------|------|
| **UI Framework** | Flutter + Material Design 3 |
| **Language** | Dart 3.0+ |
| **State Mgmt** | Riverpod |
| **Navigation** | GoRouter |
| **Models** | Freezed + JSON Serializable |
| **Backend** | Firebase (Firestore + Auth) |
| **HTTP** | http + html (Scraping) |
| **Testing** | Flutter Test + Mockito |
| **Deployment** | App Store, Google Play, Firebase Hosting |

---

## 📋 Phase-Übersicht

| Phase | Titel | Dauer | Copilot | Link |
|-------|-------|-------|---------|------|
| 1 | Setup | 1.5h | 85% | [Guide](./docs/PHASE_1_SETUP.md) |
| 2 | Modelle | 1.5h | 95% | [Guide](./docs/PHASE_2_MODELS.md) |
| 3 | Firebase | 3h | 70% | [Guide](./docs/PHASE_3_FIREBASE.md) |
| 4 | Services | 2h | 70% | [Guide](./docs/PHASE_4_SERVICES.md) |
| 5 | UI | 3h | 60% | [Guide](./docs/PHASE_5_UI.md) |
| 6 | Tests | 2.5h | 50% | [Guide](./docs/PHASE_6_TESTING.md) |
| 7 | Deploy | 5h | 20% | [Guide](./docs/PHASE_7_DEPLOYMENT.md) |
| **Total** | - | **~18h** | **65%** | [Plan](./IMPLEMENTATION_PLAN.md) |

---

## ⚡ Next Steps

1. **Aktuell: Phase 1b (GitHub + Firebase)**
   - Repository auf GitHub erstellen
   - Firebase Projekt erstellen
   - Credentials herunterladen
   - google-services.json & GoogleService-Info.plist integrieren

2. **Danach: Phase 2 (Dart Modelle)**
   - öffne PHASE_2_MODELS.md
   - Kopiere Copilot Prompt
   - Lasse Copilot die Modelle generieren

3. **Fortschritt: Phase 3-7**
   - Jede Phase hat Copilot-Prompts ready
   - ~65% wird automatisiert
   - User fokussiert auf Design & Testing

---

## 💡 GitHub Copilot Workflow

**Jede Phase hat Copy-Paste Prompts!**

Beispiel Phase 2:

```
1. Öffne: docs/PHASE_2_MODELS.md
2. Scrolla zu: "GitHub Copilot Prompt (COPY-PASTE)"
3. Kopiere den kompletten Prompt
4. In GitHub Codespaces → Copilot Chat → Paste
5. Copilot schreibt automatisch alle Modelle!
6. Prüfe Output & Commit
```

---

## 🔐 Firebase Setup Required

### Vor Phase 2 erforderlich!

1. **Firebase Projekt** (console.firebase.google.com)
   - Name: kickbasekumpel-dev
   - Region: europe-west1 (schneller in Deutschland)

2. **Apps registrieren**
   - iOS: Bundle ID `de.legomaniac.kickbasekumpel`
   - Android: Package `de.legomaniac.kickbasekumpel`
   - Web: (für Phase 7)

3. **Credentials**
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
   - API Keys → `lib/config/firebase_options.dart`

[Detailliert in PHASE_1_SETUP.md](./docs/PHASE_1_SETUP.md#schritt-2-firebase-projekt-erstellen)

---

## 🧪 Testing & Validation

```bash
# Unit Tests (Phase 6)
flutter test test/data/ --coverage

# Widget Tests
flutter test test/presentation/ --coverage

# Analysis
flutter analyze

# All checks
flutter doctor
```

---

## 🚀 Deployment

**Phase 7 Coverage:**

| Platform | Store | Status |
|----------|-------|--------|
| iOS | App Store | Phase 7 |
| Android | Google Play | Phase 7 |
| Web | Firebase Hosting | Phase 7 |

Siehe [PHASE_7_DEPLOYMENT.md](./docs/PHASE_7_DEPLOYMENT.md)

---

## 💻 Dev Workflow

```bash
# Feature entwickeln
git checkout -b feature/phase-2-models

# Code schreiben + Tests
flutter test

# Commit & Push
git add .
git commit -m "feat: Dart models with Freezed"
git push origin feature/phase-2-models

# Pull Request → Review → Merge
```

---

## 📊 Fortschritt

```
Insgesamt: ~31 Stunden
├── Copilot Work: ~20h (65%)
└── User Work: ~11h (35%)

Timeline:
- Schnell: 4 Wochen (8h/Woche)
- Normal: 6-8 Wochen (4-5h/Woche)
- Entspannt: 12 Wochen (2.5h/Woche)
```

---

## 🎯 Project Status

| Item | Status |
|------|--------|
| Projektstruktur | ✅ Fertig |
| Dependencies | ✅ Fertig |
| .devcontainer | ✅ Fertig |
| GitHub Repo | ⏳ Pending |
| Firebase Projekt | ⏳ Pending |
| Phase 1 | ✅ 70% |
| Phase 2-7 | 📋 Documented |

---

## 📖 More Info

- **[Complete Implementation Plan](./IMPLEMENTATION_PLAN.md)**
- **Flutter Docs:** https://docs.flutter.dev
- **Firebase Docs:** https://firebase.flutter.dev
- **Riverpod:** https://riverpod.dev
- **GoRouter:** https://pub.dev/packages/go_router

---

**🚀 Los geht's mit Phase 1b!**

[→ PHASE_1_SETUP.md](./docs/PHASE_1_SETUP.md)
