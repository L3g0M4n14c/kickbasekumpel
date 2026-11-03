# iOS-Tester-Verteilung – Optionen und Automatisierungsgrad

Stand der Recherche: 2026-11 (Kickbase-Projekt). Quellen: bestehende Repo-Konfiguration
(verifiziert) und Apple-/Fastlane-Wissen (NICHT in der Sitzung gegen Live-Docs geprüft –
vor Umsetzung gegen aktuelle Docs verifizieren; Host firebase.google.com war gesperrt).

## Was sich nie ganz automatisieren lässt (einmalig, manuell)

- Apple-Developer-Account, App-ID/Bundle-ID, App-Eintrag in App Store Connect anlegen.
- App-Store-Connect-API-Key (.p8) erzeugen (Rolle "Developer" reicht für Match/Devices;
  Xcode-Cloud-Zugriff braucht ggf. "App Manager").
- Xcode-Cloud-Workflow (Start-Bedingung, Environment-Variablen, Post-Actions) in
  Xcode/App Store Connect klicken. Die ciWorkflows-API (POST/PATCH /v1/ciWorkflows) existiert,
  ist aber schlecht dokumentiert → nicht empfohlen.
- Neue Tester: Einladung/Annahme (E-Mail) bleibt ein menschlicher Schritt.

## Option A – Firebase App Distribution mit Ad-Hoc-IPA (Ist-Zustand im Kickbase-Projekt)

Ablauf: Push auf main → Xcode Cloud → `ci_post_clone.sh` → Archive → `ci_post_xcodebuild.sh`
(Ad-Hoc-Export, Fastlane Match) → `firebase appdistribution:distribute`.
Build + Upload sind damit vollautomatisch.

**Manueller Rest:** Jedes neue Tester-Gerät muss mit UDID im Apple-Developer-Portal registriert
und das Ad-Hoc-Profil neu erzeugt werden (`fastlane match adhoc --force_for_new_devices`).
Ohne das lässt sich die App auf dem neuen Gerät nicht installieren.

**Automatisierbar (Sketch, ungetestet):** geplanter Job (z.B. wöchentlich/`workflow_dispatch`),
der neue UDIDs aus Firebase holt und in Apple registriert:

```ruby
# Gemfile: gem "fastlane-plugin-firebase_app_distribution"  (bereits im Template)
lane :sync_devices do
  api_key = app_store_connect_api_key(
    key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
    issuer_id: ENV["APP_STORE_CONNECT_API_KEY_ISSUER_ID"],
    key_content: ENV["APP_STORE_CONNECT_API_KEY_CONTENT"],
  )
  firebase_app_distribution_get_udids(
    app: ENV["FIREBASE_PROJECT_NUMBER_AND_APP_ID"], # Format laut Plugin-Doku prüfen
    service_credentials_file: "firebase-sa.json",
    output_file: "udids.txt",       # Tab-getrennt: Device ID / Name / Platform
  )
  register_devices(devices_file: "udids.txt", api_key: api_key)
  match(type: "adhoc", force_for_new_devices: true, api_key: api_key)  # Profil neu erzeugen
end
```

Zu klären/Grenzen:
- Apple erlaubt max. **100 iPhones pro Mitgliedschaftsjahr**; registrierte Geräte lassen sich
  bis zur Jahres-Verlängerung nicht "freigeben" (nur deaktivieren, zählt trotzdem).
- Nutzt der Xcode-Cloud-Ad-Hoc-Export Cloud-Managed-Signing, genügt `register_devices`
  (Profil wird von Xcode Cloud selbst erneuert); Match nur für den Fallback-Pfad.
- Match-Lauf mit Schreibrechten (nicht `readonly`) braucht Zugriff auf das Zertifikate-Repo;
  auf macOS-Runner ausführen (Keychain-Zugriff), Linux-Runner nicht verifiziert.
- Tester müssen das Firebase-Tester-Profil auf dem Gerät installieren, damit die UDID
  überhaupt in Firebase erscheint – der Erst-Schritt bleibt manuell.

## Option B – TestFlight über Xcode-Cloud-Post-Action (empfohlen, wenn UDID-Pflege nervt)

Xcode Cloud kann nach dem Archive automatisch an TestFlight verteilen
(Post-Action "TestFlight Internal Testing", ggf. auch External Testing).
- **Intern:** bis 100 Tester, müssen App-Store-Connect-Nutzer sein; kein Beta-Review,
  Build in Minuten verfügbar.
- **Extern:** bis 10.000 Tester via öffentlichem Link oder E-Mail, keine UDIDs, kein
  Gerätelimit. Erster Build je Versionsnummer geht durch Beta App Review (meist < 1 Tag).
- Keine Match-/Firebase-/UDID-Logik nötig → `ci_post_xcodebuild.sh` entfällt für iOS.
- Nachteile: Tester brauchen die TestFlight-App, Builds laufen nach 90 Tagen ab,
  Release-Notes/Testergruppen werden in App Store Connect gepflegt (oder per
  Fastlane `pilot`/ASC-API).
- `ci_post_clone.sh` (eindeutige `CI_BUILD_NUMBER`, MinimumOSVersion-Fix) bleibt nötig.

## Entscheidungshilfe

| Situation | Empfehlung |
|---|---|
| Wenige, feste Tester, Firebase soll Android+iOS bündeln | A + `sync_devices`-Job |
| Wechselnde/viele Tester, geringe Wartung | B (extern, öffentlicher Link) |
| Nur Entwickler/Team (≤100, ASC-Nutzer) | B (intern) |
