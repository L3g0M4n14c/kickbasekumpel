# CI/CD Setup – KickbaseKumpel

Diese Anleitung beschreibt alle manuellen Schritte, die du **einmalig** ausführen musst,
damit die automatische Deployment-Pipeline funktioniert. Danach läuft alles selbstständig
bei jedem Push auf `main`.

**Was automatisiert passiert (nach diesem Setup):**
- Firebase Functions, Firestore Rules, Storage Rules deployen
- Flutter Web App auf Firebase Hosting deployen
- Android APK via Firebase App Distribution an Tester verteilen
- iOS IPA via Firebase App Distribution an Tester verteilen

**Voraussetzungen:**
- [Firebase CLI](https://firebase.google.com/docs/cli) installiert: `npm install -g firebase-tools`
- [GitHub CLI](https://cli.github.com/) installiert: `brew install gh`
- [Fastlane](https://fastlane.tools/) installiert: `brew install fastlane`
- Eingeloggt bei Firebase: `firebase login`
- Eingeloggt bei GitHub CLI: `gh auth login`
- Apple Developer Account: [developer.apple.com](https://developer.apple.com)
- Google Play Console Zugang: [play.google.com/console](https://play.google.com/console)

---

## Schritt 1: Firebase Service Account erstellen

1. Öffne die [Firebase Console](https://console.firebase.google.com/project/kickbasekumpel/settings/serviceaccounts/adminsdk)
2. Klicke auf **"Neuen privaten Schlüssel generieren"**
3. Speichere die heruntergeladene JSON-Datei als `firebase-service-account.json`
4. Füge sie als GitHub Secret hinzu:

```bash
gh secret set FIREBASE_SERVICE_ACCOUNT_JSON \
  --repo L3g0M4n14c/kickbasekumpel \
  < firebase-service-account.json
```

5. Lösche die JSON-Datei danach lokal (Sicherheit!):

```bash
rm firebase-service-account.json
```

---

## Schritt 2: Firebase App Distribution – Tester-Gruppe anlegen

1. Öffne [Firebase App Distribution](https://console.firebase.google.com/project/kickbasekumpel/appdistribution)
2. Wähle die **Android-App** aus
3. Klicke auf **"Tester und Gruppen"** → **"Gruppe hinzufügen"**
4. Gruppenname: `internal-testers`
5. Füge die E-Mail-Adressen deiner Tester hinzu
6. Wiederhole Schritt 2–5 für die **iOS-App**

---

## Schritt 3: Firebase Hosting aktivieren

1. Öffne die [Firebase Hosting Console](https://console.firebase.google.com/project/kickbasekumpel/hosting)
2. Klicke auf **"Jetzt starten"** und folge dem Wizard (du brauchst nichts lokal deployen – nur aktivieren)
3. Den öffentlichen URL notieren: `https://kickbasekumpel.web.app`

---

## Schritt 4: Android Release Keystore erstellen

Führe diesen Befehl aus und ersetze `SICHERES_PASSWORT` durch ein eigenes starkes Passwort
(mindestens 8 Zeichen, merke es dir gut – du brauchst es für die Secrets):

```bash
keytool -genkey -v \
  -keystore kickbasekumpel-release.jks \
  -alias kickbasekumpel \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass SICHERES_PASSWORT \
  -keypass SICHERES_PASSWORT \
  -dname "CN=KickbaseKumpel, OU=Development, O=LegomaniacDev, L=Munich, S=Bavaria, C=DE"
```

Dann die Keystore-Datei als GitHub Secrets hinterlegen:

```bash
# Keystore Base64-kodiert als Secret speichern
gh secret set ANDROID_KEYSTORE_BASE64 \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "$(base64 -i kickbasekumpel-release.jks)"

# Key Alias
gh secret set ANDROID_KEY_ALIAS \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "kickbasekumpel"

# Passwörter (ersetze SICHERES_PASSWORT mit deinem gewählten Passwort)
gh secret set ANDROID_KEY_PASSWORD \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "SICHERES_PASSWORT"

gh secret set ANDROID_STORE_PASSWORD \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "SICHERES_PASSWORT"
```

Keystore-Datei sicher aufbewahren (z.B. in 1Password) und lokal löschen:

```bash
# WICHTIG: Backup machen, dann löschen!
rm kickbasekumpel-release.jks
```

> ⚠️ **Den Keystore und das Passwort niemals verlieren!** Ohne denselben Keystore können
> keine App-Updates mehr veröffentlicht werden.

---

## Schritt 5: Firebase App-IDs als Secrets hinterlegen

Diese IDs werden für Firebase App Distribution benötigt:

```bash
# Android App ID
gh secret set FIREBASE_APP_ID_ANDROID \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "1:843006606880:android:c7556d45dde367fcde0645"

# iOS App ID
gh secret set FIREBASE_APP_ID_IOS \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "1:843006606880:ios:ace0cffa4a7c702ede0645"
```

---

## Schritt 6: Apple App Store Connect API Key erstellen

Dieser Key wird von Fastlane benötigt, um Zertifikate und Provisioning Profiles zu verwalten.

1. Öffne [App Store Connect → Benutzer und Zugriff → Integrationen](https://appstoreconnect.apple.com/access/integrations/api)
2. Klicke auf **"+"** um einen neuen API Key zu erstellen
3. Name: `CI/CD Fastlane`, Zugriff: **Developer**
4. Lade die `.p8`-Datei herunter (sie kann nur einmal heruntergeladen werden!)
5. Notiere **Key ID** und **Issuer ID** von der Seite

Die Werte als Secrets hinterlegen (Platzhalter ersetzen):

```bash
# Key ID (10-stellig, z.B. "ABC1234DEF")
gh secret set APP_STORE_CONNECT_API_KEY_ID \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "DEINE_KEY_ID"

# Issuer ID (UUID-Format, z.B. "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
gh secret set APP_STORE_CONNECT_API_KEY_ISSUER_ID \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "DEINE_ISSUER_ID"

# Inhalt der .p8-Datei (ersetze Pfad zur heruntergeladenen Datei)
gh secret set APP_STORE_CONNECT_API_KEY_CONTENT \
  --repo L3g0M4n14c/kickbasekumpel \
  < AuthKey_DEINE_KEY_ID.p8
```

---

## Schritt 7: Fastlane Match – Privates Repository erstellen

Fastlane Match speichert deine iOS-Zertifikate und Provisioning Profiles verschlüsselt in
einem privaten GitHub-Repository.

1. Erstelle ein neues privates Repository auf GitHub (z.B. `kickbasekumpel-certificates`)
2. Notiere die URL: `https://github.com/L3g0M4n14c/kickbasekumpel-certificates.git`

Ein sicheres Passwort für die Verschlüsselung wählen und als Secret speichern:

```bash
gh secret set MATCH_PASSWORD \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "SICHERES_MATCH_PASSWORT"

gh secret set MATCH_GIT_URL \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "https://github.com/L3g0M4n14c/kickbasekumpel-certificates.git"
```

---

## Schritt 8: Fastlane Match initialisieren (einmalig)

> Dieser Schritt wird ausgeführt, **nachdem Copilot die Fastlane-Dateien erstellt hat**.
> Die Dateien `fastlane/Matchfile` und `fastlane/Appfile` müssen bereits im Repo vorhanden sein.

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

# AdHoc-Profil für App Distribution erstellen und im privaten Repo speichern
MATCH_PASSWORD="SICHERES_MATCH_PASSWORT" fastlane match adhoc \
  --app_identifier "de.legomaniac.kickbasekumpel" \
  --git_url "https://github.com/L3g0M4n14c/kickbasekumpel-certificates.git" \
  --type "adhoc"
```

Du wirst nach Apple ID und Passwort gefragt. Nach Abschluss sind die Zertifikate im
privaten Repo gespeichert und der CI/CD Runner kann sie abrufen.

---

## Schritt 9: Verifizierung

Nachdem alle Schritte abgeschlossen sind, überprüfe ob alle Secrets korrekt gesetzt sind:

```bash
gh secret list --repo L3g0M4n14c/kickbasekumpel
```

Folgende Secrets sollten in der Liste erscheinen:

| Secret | Beschreibung |
|--------|-------------|
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Firebase Admin SDK JSON |
| `FIREBASE_APP_ID_ANDROID` | Firebase Android App ID |
| `FIREBASE_APP_ID_IOS` | Firebase iOS App ID |
| `ANDROID_KEYSTORE_BASE64` | Base64-kodierter Android Keystore |
| `ANDROID_KEY_ALIAS` | Android Key Alias (`kickbasekumpel`) |
| `ANDROID_KEY_PASSWORD` | Android Key Passwort |
| `ANDROID_STORE_PASSWORD` | Android Store Passwort |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect Key ID |
| `APP_STORE_CONNECT_API_KEY_ISSUER_ID` | App Store Connect Issuer ID |
| `APP_STORE_CONNECT_API_KEY_CONTENT` | App Store Connect .p8 Key Inhalt |
| `MATCH_PASSWORD` | Fastlane Match Verschlüsselungs-Passwort |
| `MATCH_GIT_URL` | URL des privaten Certificates-Repos |

---

## Was danach automatisch passiert

Nach jedem Push auf `main`:

1. **Firebase Deploy Job** (ca. 3–5 Min.): Functions, Firestore Rules, Storage Rules, Web App
2. **Android Build & Distribute Job** (ca. 8–12 Min.): APK gebaut und an `internal-testers` verteilt
3. **iOS Build & Distribute Job** (ca. 15–20 Min.): IPA gebaut, signiert und an `internal-testers` verteilt

Tester erhalten automatisch eine E-Mail mit Download-Anweisungen.

---

## Troubleshooting

**Firebase Deploy schlägt fehl mit "file not found"**
→ `firestore.rules` und `storage.rules` müssen im Root existieren (werden von Copilot angelegt)

**Android Build schlägt fehl mit Signing-Fehler**
→ Prüfe ob `ANDROID_KEYSTORE_BASE64` korrekt Base64-kodiert ist: `echo "$SECRET" | base64 -d | file -`

**iOS Build schlägt fehl mit "No matching provisioning profile"**
→ Fastlane Match erneut ausführen: `fastlane match adhoc --force_for_new_devices`

**Match fragt nach GitHub-Credentials im CI**
→ Ein Personal Access Token (PAT) muss als `MATCH_GIT_BASIC_AUTHORIZATION` Secret hinterlegt werden:
```bash
echo -n "L3g0M4n14c:DEIN_GITHUB_PAT" | base64
gh secret set MATCH_GIT_BASIC_AUTHORIZATION \
  --repo L3g0M4n14c/kickbasekumpel \
  --body "BASE64_OUTPUT_VOM_BEFEHL_OBEN"
```
