---
name: kickbasekumpel-backend
description: KickbaseKumpel Firebase-Backend - Auth, Firestore-Collections, Repositories, Cloud Functions (LigaInsider-Scraper, Kickbase-Proxy), Demo-Modus. Verwenden bei Backend-, Firestore-, Functions- oder Auth-Fragen.
---

# KickbaseKumpel – Firebase-Backend

**Stack**: Firebase Auth + Cloud Firestore (Flutter-SDK: firebase_core ^4.4.0, firebase_auth ^6.1.4, cloud_firestore ^6.1.2). Configs: `firebase.json`, `.firebaserc`, `firestore.rules`, `storage.rules`, `firestore.indexes.json`.

## Repositories (`lib/data/repositories/`)

- `base_repository.dart` – `BaseRepository<T>`: generisches CRUD + Watch-Streams + Queries + Transaktionen (siehe kickbasekumpel-architecture)
- `firestore_repositories.dart` – `UserRepository`, `LeagueRepository`, `PlayerRepository`, `TransferRepository`, `RecommendationRepository` (alle extends BaseRepository<T>)
- `auth_repository.dart` – E-Mail/Auth-Flow

**Firestore-Collections**: `users`, `players`, `leagues`, Sub-Collections `leagues/{id}/ownedPlayers`, Transfer-Dokumente unter `users/{id}`. Gesehen in firestore_repositories.dart: 1013+ (users), 667/1060 (leagues/ownedPlayers), 1543 (players).

## Auth (`lib/data/sources/auth_source.dart`, `lib/domain/repositories/auth_repository_interface.dart`)

E-Mail/Passwort + Passwort-Reset + E-Mail-Bestätigung. Tokens: `lib/data/services/token_storage.dart` (flutter_secure_storage). Provider: `lib/data/providers/auth_provider.dart`, `kickbase_auth_provider.dart`.

## Demo-Modus (`lib/data/services/demo_kickbase_api_client.dart`)

- `DemoKickbaseAPIClient extends KickbaseAPIClient` – liefert statische Demodaten, kontaktiert nie Kickbase
- Zugangsdaten: `demo@kickbasekumpel.de` / `demo1234`, Marker-Token `__KICKBASE_KUMPEL_DEMO__`
- Zustand: `lib/data/providers/demo_mode_provider.dart` (`DemoModeNotifier extends Notifier<bool>`)

## Cloud Functions (`functions/` – TypeScript, Node 22)

Quelle `functions/src/`: `index.ts`, `ligainsider-scraper.ts`, `ligainsider-lineup-scraper.ts`, `logger.ts` (pino), `types.ts`. Abhängigkeiten: axios, cheerio, firebase-admin, firebase-functions, @google-cloud/secret-manager.

Exportierte Functions (`functions/src/index.ts`):

| Function | Typ | Zweck |
|---|---|---|
| `kickbaseProxy` | onRequest | CORS-Proxy für Kickbase-API auf Web (Ziel des `_webProxyUrl` im API-Client) |
| `getLigainsiderLineups` | onRequest | LigenInsider-Aufstellungen |
| `updateLigainsiderPhotos` | onRequest | Foto-Update |
| `scheduledLigainsiderPhotoUpdate` | onSchedule | Foto-Update Cron |
| `getLigainsiderScraperStatus` | onRequest | Scraper-Status |
| `initializeLigainsiderScraperMetadata` | onDocumentCreated | Metadata-Init |

## Deploy

```bash
# Functions
cd functions && npm run build   # tsc
firebase deploy --only functions
# Oder: ./deploy-functions.sh
# Logs: npm run logs  /  firebase functions:log
```

Weitere Docs: docs/FIRESTORE_REPOSITORIES.md, docs/CLOUD_FUNCTIONS_SETUP.md, CLOUD_FUNCTIONS_MIGRATION.md
