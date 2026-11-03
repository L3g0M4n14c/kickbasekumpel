---
name: kickbasekumpel-dev-workflow
description: KickbaseKumpel Dev-Workflow - alle Build-, Test-, Lint-, Codegen- und Deploy-Commands, Abhängigkeiten, CI/CD, Fastlane. Verwenden wenn Befehle ausgeführt oder Konfiguration geändert werden soll.
---

# KickbaseKumpel – Dev-Workflow

## Kern-Commands

```bash
flutter pub get

# Nach JEDER @freezed-/json_serializable-Änderung (Pflicht!):
flutter pub run build_runner build --delete-conflicting-outputs
# Watch-Modus:
flutter pub run build_runner watch --delete-conflicting-outputs

dart format lib/
flutter analyze
flutter test                       # NUR bei breitem/unklarem Scope; sonst gezielt
                                   # nur betroffene Testdateien (siehe kickbasekumpel-testing)
flutter test test/data/repositories/   # gezielt
flutter test --coverage
flutter run
```

## Builds

```bash
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release
```

Icons nach Änderung von `assets/images/logo/icon-1024.png`: `dart run flutter_launcher_icons` (Config in pubspec.yaml).

## Cloud Functions

```bash
cd functions && npm run build    # tsc
npm run start                    # Emulator
npm run deploy                   # firebase deploy --only functions
npm run logs
```
Alternativ `./deploy-functions.sh` im Projektwurzelverzeichnis.

## CI/CD (`.github/workflows/`)

| Workflow | Trigger | Inhalt |
|---|---|---|
| `flutter_tests.yml` | push, PR | pub get → **build_runner build** → `flutter test --coverage` → Codecov-Upload |
| `deploy.yml` | push auf `main`, workflow_dispatch | 3 Jobs: (1) Flutter Web → Firebase Hosting, (2) `firebase deploy --only functions,firestore,storage,hosting` (Projekt `kickbasekumpel`; räumt vorher 2 Functions weg), (3) Android APK → Firebase App Distribution; iOS-Variant mit Pod-Install |

⚠️ CI nutzt **Flutter 3.47.x**, pubspec verlangt Dart SDK **^3.13.0** – bei Versionskonflikten beide Stellen prüfen.

## Fastlane (iOS)

`fastlane/Fastfile`: Lane `setup_signing` (Match Ad Hoc + ExportOptions.plist; aufgerufen von `ios/ci_scripts/ci_post_xcodebuild.sh`). Die Lane `upload` ist ungenutzt (Upload per Firebase CLI im Skript). Siehe docs/CI_CD_SETUP.md.

CI/CD für neue Flutter-Projekte nach diesem Muster: Skill `flutter-cicd-scaffold` (Templates + iOS-Tester-Optionen).

## Wichtige Abhängigkeiten (pubspec.yaml)

- riverpod/flutter_riverpod **^3.2.1**, go_router **^18.0.2**, freezed_annotation **^3.1.0** + json_annotation
- firebase_core 4.4.0, firebase_auth 6.1.4, cloud_firestore 6.1.2, firebase_vertexai 2.1.1
- fl_chart (Charts), cached_network_image, connectivity_plus, shared_preferences, flutter_secure_storage, logger, html (Scraping), intl
- Dev: build_runner ^2.4.0, freezed **^4.0.2** (Syntax: `abstract class X with _$X`), json_serializable ^6.8.0, mockito, mocktail, fake_cloud_firestore ^4, flutter_lints ^6
- SDK: Dart ^3.13.0

## Teststruktur (`test/`)

Spiegelt lib/: `test/data/{models,repositories,services,providers,utils}`, `test/presentation/{providers,utils}`. Firestore-Tests mit `fake_cloud_firestore`, Mocks mit mockito/mocktail. Doku: test/README.md.

## CI/CD

GitHub Actions: `.github/workflows/`. Doku: docs/CI_CD_SETUP.md.
