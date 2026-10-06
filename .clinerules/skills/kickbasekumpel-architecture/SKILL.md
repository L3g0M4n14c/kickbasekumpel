---
name: kickbasekumpel-architecture
description: KickbaseKumpel Clean Architecture - Schichten, Datenfluss, Result-Typ, Projektstruktur unter lib/. Verwenden bei jeder Code-Änderung, Fragen zu Architektur, Schichten-Trennung oder wo Code gehört.
---

# KickbaseKumpel – Architektur

Flutter-App (SDK ^3.9.2) für Kickbase Fantasy Football. **Modifizierte Clean Architecture**, drei Schichten mit Dependency-Rule (Abhängigkeiten zeigen nach innen):

```
Presentation (lib/presentation) → Data (lib/data) → Domain (lib/domain)
```

## Schichten-Regeln

- UI-Code → `lib/presentation/`, Business-Logik → `lib/data/`, Interfaces/Exceptions → `lib/domain/`
- Widgets rufen NICHT Services direkt auf – nur über Provider
- `lib/domain/` bleibt pure: keine Flutter/Firebase-Imports
- State Management ausschließlich **Riverpod 3.x** (kein setState/ChangeNotifier/BLoC für State)

## Verzeichnis-Layout

- `lib/main.dart` – Startup-Reihenfolge: SharedPreferences → globale Error-Handler → `Firebase.initializeApp` → `ProviderScope(retry: _noAutoRetry, ...)`. Riverpod-Auto-Retry ist absichtlich DEAKTIVIERT (Retries übernimmt HTTP-Layer `_makeRequestWithRetry` + manueller Retry-Button).
- `lib/config/` – `router.dart` (GoRouter-Provider), `theme.dart`/`app_theme.dart` (AppTheme.lightTheme/darkTheme), `screen_size.dart`, `firebase_config.dart`
- `lib/domain/` – `repositories/repository_interfaces.dart` (**sealed class Result<T>**), `repositories/auth_repository_interface.dart`, `exceptions/kickbase_exceptions.dart`
- `lib/data/` – `models/` (Freezed, Barrel: models_barrel.dart), `repositories/` (base_repository.dart, firestore_repositories.dart, auth_repository.dart), `services/` (KickbaseAPIClient etc.), `providers/` (Data-Provider), `sources/auth_source.dart`, `utils/parsing_utils.dart`
- `lib/presentation/` – `pages/` (auth, dashboard, home_page, loading, error), `screens/` (Feature-Screens: league_table, live, squad, ligainsider, player...), `widgets/` (app_bars, buttons, cards, charts, common, forms, market, team, transfers, responsive_layout), `providers/` (UI-Provider: dashboard, market, transfer_planner), `utils/player_status_helper.dart`
- `lib/firebase_options.dart` – generiert von FlutterFire

## Datenfluss

API/Firestore → Service/Repository (gibt `Result<T>` zurück) → Data-Provider (Riverpod) → UI-Provider → Widget (ref.watch)

## Result-Typ (Pflicht in Repositories)

```dart
// lib/domain/repositories/repository_interfaces.dart
sealed class Result<T> {}
class Success<T> extends Result<T> { final T data; }
class Failure<T> extends Result<T> { final String message; final String? code; final Exception? exception; }
```

Verwendung: `switch (result) { Success(:final data) => ..., Failure(:final message) => ... }`

`BaseRepository<T>` (lib/data/repositories/base_repository.dart) bietet: getAll, getById, create, createWithId, update, updateFields, delete, watchAll, watchById, queryWhere, queryOrderBy, complexQuery, batchWrite, runTransaction + QueryCondition/BatchOperation.

## Routing

GoRouter 17 in `lib/config/router.dart` (`goRouterProvider`): `/loading`, `/`, `/auth/signin`, StatefulShellRoute mit `/dashboard[/market|sales|lineup|transfers|ligainsider|table|live|settings]`, `/league/:leagueId`, `/ligainsider/lineups`, `/manager/:leagueId/:userId`.

## Neues Feature (Reihenfolge)

1. Model (Freezed) in `lib/data/models/` → 2. build_runner → 3. API-Client-Methode → 4. Repository → 5. Data-Provider (`lib/data/providers/`) → 6. Widget/Screen → 7. Route → 8. Tests in `test/`.

Details: ARCHITECTURE.md, .github/copilot-instructions.md
