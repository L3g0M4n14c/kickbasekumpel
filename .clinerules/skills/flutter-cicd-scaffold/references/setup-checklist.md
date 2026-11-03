# Einmaliges Setup – Checkliste und Secrets

Platzhalter wie `<REPO>` (z.B. `owner/app`), `<PROJECT>` (Firebase-Projekt-ID) ersetzen.
Secrets nie in Chat/Commits ausgeben; Dateien nach dem Hochladen lokal löschen.

## 1. Firebase
1. Service Account (Console → Projekteinstellungen → Dienstkonten → neuer Schlüssel) →
   `gh secret set FIREBASE_SERVICE_ACCOUNT_JSON --repo <REPO> < sa.json`
2. IAM: Bei `onSchedule`-Functions zusätzlich `roles/cloudscheduler.admin` für den SA
   (sonst HTTP 403 `cloudscheduler.jobs.update`). Für App Distribution:
   `roles/firebaseappdistro.admin`.
3. App Distribution: Tester-Gruppe (Name = `__TESTER_GROUP__`) je Plattform anlegen.
4. Hosting aktivieren (nur Console-Wizard). `firebase.json` + `.firebaserc` committen.
5. App-IDs: `gh secret set FIREBASE_APP_ID_ANDROID` / `FIREBASE_APP_ID_IOS`.

## 2. Android
```bash
keytool -genkey -v -keystore release.jks -alias <ALIAS> -keyalg RSA -keysize 2048 \
  -validity 10000 -storepass <PW> -keypass <PW> -dname "CN=<App>, O=<Org>, C=DE"
gh secret set ANDROID_KEYSTORE_BASE64 --repo <REPO> --body "$(base64 -w0 release.jks)"  # macOS: base64 -i
gh secret set ANDROID_KEY_ALIAS / ANDROID_KEY_PASSWORD / ANDROID_STORE_PASSWORD
```
Keystore zusätzlich im Passwortmanager sichern – ohne ihn keine Updates im Play Store.

## 3. iOS (Xcode Cloud + Ad Hoc + Fastlane Match) – nur bei Option A
1. App Store Connect → Benutzer und Zugriff → Integrationen → API-Key (.p8) → Key ID, Issuer ID.
2. Privates Repo für Zertifikate (`<app>-certificates`), PAT mit `repo`-Scope.
3. Einmalig lokal: `fastlane match adhoc --app_identifier <BUNDLE_ID> --git_url <URL>`.
4. App Store Connect → Xcode Cloud → Workflow anlegen: Start-Bedingung "Branch Changes: main",
   Aktion Archive (iOS), Environment-Variablen (siehe Tabelle). `ios/ci_scripts/*.sh` müssen
   ausführbar sein (`chmod +x`, committen).
5. Bei Option B stattdessen Post-Action "TestFlight Internal/External Testing" wählen;
   Schritte 1–3 und die Match-Variablen entfallen.

Xcode-Cloud-Variablen (in App Store Connect, NICHT in GitHub):

| Variable | Secret | Zweck |
|---|---|---|
| `FLUTTER_VERSION` | – | optional, überschreibt Default in ci_post_clone.sh |
| `FIREBASE_APP_ID_IOS` | – | Ziel in App Distribution |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | ✅ | Upload-Berechtigung |
| `APPLE_TEAM_ID` | – | ExportOptions/Signing |
| `APP_STORE_CONNECT_API_KEY_ID` / `_ISSUER_ID` | – | Match/Spaceship |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | ✅ | .p8-Inhalt |
| `MATCH_GIT_URL` | – | Zertifikate-Repo |
| `MATCH_PASSWORD` | ✅ | Match-Verschlüsselung |
| `MATCH_GIT_BASIC_AUTHORIZATION` | ✅ | `base64("user:PAT")` |

GitHub-Secrets (Web/Android-Jobs): `FIREBASE_SERVICE_ACCOUNT_JSON`, `FIREBASE_APP_ID_ANDROID`,
`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `ANDROID_STORE_PASSWORD`
(+ optional `CODECOV_TOKEN`). Prüfen: `gh secret list --repo <REPO>`.

## 4. Verifizieren
- PR öffnen → `flutter_tests.yml` grün.
- `workflow_dispatch` von deploy.yml → Web-URL erreichbar, Android-Build in App Distribution.
- Push auf main → Xcode-Cloud-Build startet, IPA erscheint in Firebase (Option A) bzw. TestFlight (B).
