---
name: flutter-cicd-scaffold
description: Richtet CI/CD für eine Flutter-App (Android, iOS, Web) nach bewährtem Muster ein - GitHub Actions (Tests, Web→Firebase Hosting, Firebase-Backend, Android→App Distribution), Xcode Cloud für iOS (ci_scripts, Fastlane Match, Ad-Hoc→Firebase oder TestFlight). Enthält parametrisierte Templates, Setup-Checkliste, bekannte Stolperfallen. Verwenden wenn ein neues oder bestehendes Flutter-Projekt Build-/Deploy-Automatisierung oder Tester-Verteilung bekommen soll.
---

# Flutter CI/CD Scaffold

Wiederverwendbares Muster aus dem Projekt KickbaseKumpel. Alles Verifizierte stammt aus
dessen laufender Pipeline; Unverifiziertes ist in `references/` ausdrücklich markiert.

## Architektur

| Plattform | Wo gebaut | Verteilung |
|---|---|---|
| Tests | GitHub Actions (`flutter_tests.yml`, push + PR) | Codecov (optional) |
| Web | GitHub Actions → Artefakt | Firebase Hosting (im Job `firebase-deploy`) |
| Backend (Functions/Firestore/Storage Rules) | GitHub Actions | `firebase deploy` |
| Android | GitHub Actions (Ubuntu, Java 17) | Firebase App Distribution (APK) |
| iOS | **Xcode Cloud** (nicht GitHub macOS-Runner: Apple Silicon, Signing, Preis) | **TestFlight (Standard, Option B)**; Firebase Ad Hoc (Option A) nur bei Bedarf – im Ursprungsprojekt Altlast |

Warum Xcode Cloud: Apple-Silicon-Maschinen, 25 h/Monat kostenlos mit Developer-Account,
integrierte Signing-Verwaltung, Trigger direkt aus dem Repo.

## Vorgehen

1. **Bestand erfassen** (nicht raten): `pubspec.yaml` (Name, `environment.sdk`, Version),
   Bundle-ID (`ios/Runner.xcodeproj`), Application-ID (`android/app/build.gradle*`),
   `firebase.json`/`.firebaserc`, vorhandene `.github/workflows`, `functions/`, `ios/Podfile`.
2. **Offene Entscheidungen beim Nutzer klären** (Bundle-ID/Team-ID/Firebase-Projekt nie erfinden):
   Firebase-Projekt-ID, Apple Team-ID, Tester-Gruppenname, iOS-Option A (Firebase/Ad-Hoc)
   oder B (TestFlight, Standard) – siehe `references/ios-tester-distribution.md`. Hat das Projekt Cloud Functions?
3. **Templates kopieren** und Platzhalter ersetzen:

   | Template | Ziel |
   |---|---|
   | `templates/github-workflows/*.yml` | `.github/workflows/` |
   | `templates/ios-ci_scripts/*.sh` | `ios/ci_scripts/` (`chmod +x`!) |
   | `templates/fastlane/*` | `fastlane/` (nur Option A) |
   | `templates/android/signing.gradle.kts.snippet` | in `android/app/build.gradle.kts` einarbeiten |

   Platzhalter: `__FLUTTER_VERSION__` (z.B. `3.47.x`, zu `environment.sdk` passend),
   `__FIREBASE_PROJECT__`, `__TESTER_GROUP__`, `__BUNDLE_ID__`, `__TEAM_ID__`.
   Prüfen mit `grep -rn "__[A-Z_]*__" .github ios/ci_scripts fastlane`.
   Nicht benötigte Jobs/Steps entfernen (kein Backend → `firebase-deploy` raus). Standard ist
   Option B: nur `ci_post_clone.sh` übernehmen, `ci_post_xcodebuild.sh` und `fastlane/` weglassen
   und im Xcode-Cloud-Workflow die TestFlight-Post-Action wählen.
4. **Dokumentation** ins Projekt: `references/setup-checklist.md` als `docs/CI_CD_SETUP.md`
   anpassen (Secrets-Tabelle, einmalige Schritte). Die Schritte mit Konsole/Apple-Login kann
   nur der Nutzer ausführen – als Checkliste übergeben, `gh secret set`-Befehle vorbereiten,
   aber keine Secrets selbst anfassen.
5. **Verifizieren, soweit lokal möglich:** `actionlint` (falls vorhanden) bzw. YAML-Parse,
   `zsh -n`/`bash -n` für Skripte, `ruby -c fastlane/Fastfile`. Echte Pipeline-Läufe kann nur
   der Nutzer anstoßen (workflow_dispatch / Push) – das klar sagen, nichts als "läuft" melden.
6. Projekt-Doku pflegen (CLAUDE.md/Skills nennen Workflows und Flutter-Version).

## Stolperfallen (alle im Ursprungsprojekt aufgetreten)

- **Flutter-/Dart-Version an 3 Orten synchron halten:** `pubspec.yaml` (`environment.sdk`),
  GitHub-Workflows (`flutter-version`), `ci_post_clone.sh` (`FLUTTER_VERSION`).
  `subosito/flutter-action` mit `x`-Patch (`3.47.x`) + `cache: true`.
- **Codegen (build_runner/Freezed):** entweder generierte Dateien committen oder in *jedem*
  Job vor Test/Build ausführen – auch in `ci_post_clone.sh`. Neue Analyzer/SDK-Kombinationen
  können build_runner brechen; dann lokal generieren und committen.
- **Xcode Cloud + Swift Package Manager:** `flutter config --no-enable-swift-package-manager`
  im Post-Clone, sonst Duplicate-Symbols mit Firebase-Pods bzw. harte Deployment-Target-Fehler.
  Podfile `post_install` hebt Pod-Deployment-Targets an.
- **Eindeutige Build-Nummer:** Feste `version: 1.0.0+1` → "Preparing build for App Store Connect
  failed". Post-Clone setzt `+N` per `sed` auf `CI_BUILD_NUMBER` und führt `flutter pub get` erneut aus.
  (BSD-`sed -i ''` auf macOS!)
- **MinimumOSVersion** in `ios/Flutter/AppFrameworkInfo.plist` erzwingen (`plutil -insert`),
  sonst ITMS-90530/90360/90208 bei der Validierung.
- **Export-Verschlüsselung:** `ITSAppUsesNonExemptEncryption=false` in `Info.plist`
  (sonst fragt App Store Connect pro Build).
- **Nur Ad-Hoc/Development-IPAs sind via Firebase installierbar**, keine App-Store-IPA –
  `ci_post_xcodebuild.sh` sucht daher `adhocexport` vor `appstoreexport`.
- **Post-Xcodebuild:** bei `CI_XCODEBUILD_EXIT_CODE != 0` und ohne `CI_ARCHIVE_PATH`
  (Test-Aktionen) sauber überspringen (`exit 0`).
- **Fastlane Match in CI:** `readonly: true`; Git-Zugriff via `MATCH_GIT_BASIC_AUTHORIZATION`
  (base64 `user:PAT`). Neue Geräte → `match adhoc --force_for_new_devices`.
- **Android:** Keystore nur als Base64-Secret, im Job dekodieren und mit `if: always()` löschen.
- **Firebase Deploy:** `--non-interactive --force`; Gen‑1→Gen‑2-Functions brauchen vorheriges
  `firebase functions:delete ... || true`. Bei Scheduler-Triggern IAM-Rolle `cloudscheduler.admin`.
- **Docs vs. Realität:** Nach Wechsel von Plattformen (z.B. GitHub-iOS-Job → Xcode Cloud)
  Doku, Fastlane-Lanes und Secrets-Listen mitziehen – tote Lanes/Secrets entfernen.
- Xcode-Cloud-Variablen leben in App Store Connect, **nicht** in GitHub-Secrets.

## Grenzen

Im Ursprungsprojekt wurde Option A zuerst gebaut und später durch TestFlight ersetzt; die
A-Templates blieben als Altlast zurück. Neue Projekte also mit B starten.

Nicht automatisierbar: Apple-/Firebase-Konto-Anlage, API-Key-Erzeugung, Xcode-Cloud-Workflow-
Erstkonfiguration, Tester-Einladungs-Annahme. Alles andere (Build, Signing, Upload,
Build-Nummern, ggf. Geräte-Registrierung) siehe `references/ios-tester-distribution.md`.
