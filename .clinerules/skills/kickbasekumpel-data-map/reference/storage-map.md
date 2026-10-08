# Persistenz-Landkarte – wo Daten liegen

Kickbase-Daten sind **live** (nur User-Cache lokal). Persistiert wird nur:
eigene App-Daten (Firestore), LigaInsider-Scraped-Daten (Firestore via Cloud
Functions) und Tokens/Flags (Local Storage).

## Firestore-Collections (App, `firestore_repositories.dart`)

| Collection | Repository | Inhalt | Konsumenten |
|---|---|---|---|
| `users/{userId}` | `UserRepository` | Eigenes User-Profil | `user_providers` |
| `leagues` | `LeagueRepository` | Ligen (Cache/Sync von Kickbase) | `league_providers` |
| `players` | `PlayerRepository` | Spieler (Cache/Sync, `toFirestore` mit Lang-Keys + `tfhmvt`/`prlo`/`stl`) | `player_providers` |
| `transfers` | `TransferRepository` | Transfers | `transfer_providers` |
| `recommendations` | `RecommendationRepository` | Lokal generierte KI-Empfehlungen | `recommendation_providers` |

Basis: `BaseRepository<T>` (`base_repository.dart`) mit `Result<T>`-Typ.

**⚠️ Bekannte Inkonsistenz:** `firestore.rules` erlaubt nur `users`, `players`
(nur lesen!), `ligainsider_photos`, `scraper_metadata`, `recommendations` – für
`leagues`/`transfers` greift die Catch-All-Regel `deny`. Schreibzugriffe der App
auf `leagues`/`transfers`/`players` würden in Production abgelehnt. Vor Nutzung
dieser Collections Rules prüfen/angleichen!

## Firestore (Cloud Functions, `functions/src/`)

| Doc | Schreiber | Inhalt | Leser |
|---|---|---|---|
| `ligainsider_photos/{normalizedName}` | `index.ts` (Scraper) | Name → Foto-URL | `ligainsider_photo_provider` (Lookup via `lookupLigainsiderPhoto`) |
| `system/ligainsider-scraper` | Scraper | Scraper-Status/-Metadaten | Scraper (Readiness-Check) |
| `system/ligainsider-lineups-cache` | Lineup-Scraper | Gecachte Aufstellungen | Lineup-Scraper |

Name→Doc-ID-Mapping: `normalizeForLigainsider` (Dart) == `normalizePlayerName`
(TS) – beides MUSS identisch bleiben.

## Local Storage

| Speicher | Key | Inhalt | Wer |
|---|---|---|---|
| FlutterSecureStorage | `kickbase_token` | Auth-Token (`tkn` vom Login) | `token_storage.dart` |
| SharedPreferences | `kickbase_user_data` | User-Cache (JSON von `User.toJson`) | `kickbase_api_client.dart` |
| SharedPreferences | `is_demo_mode` | Demo-Modus-Flag | `demo_mode_provider.dart` |

## Cloud Functions (kein eigener Daten-Store)

| Funktion | Zweck | Datenberührung |
|---|---|---|
| `kickbaseProxy` | Web-CORS-Proxy für alle Kickbase-Requests (`kIsWeb`) | keine Persistenz |
| LigaInsider-Scraper | Verletzungen/Status | schreibt `ligainsider_photos`, `system/*` |
| LigaInsider-Lineup-Scraper | Aufstellungen | `system/ligainsider-lineups-cache` |

## Demo-Modus

`DemoKickbaseAPIClient extends KickbaseAPIClient` – statische Daten, **gleiche
Modelle/Keys** wie die echte API. Neues Feature mit API-Daten → auch Demo-Daten
in `demo_kickbase_api_client.dart` ergänzen (Test: `demo_kickbase_api_client_test.dart`).
