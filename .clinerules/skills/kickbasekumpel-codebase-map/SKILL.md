---
name: kickbasekumpel-codebase-map
description: KickbaseKumpel Datei- und Ordnerkarte - welche Datei wofür zuständig ist, wo Modelle/Services/Provider/Routes/Screens liegen. Verwenden um schnellen Zugriff auf konkrete Dateien zu bekommen, bevor Code erkundet wird.
---

# KickbaseKumpel – Codebase-Karte

## Einstieg

> Daten-Wo-ist-was-Fragen (Endpunkte, JSON-Kurzkeys, Modelle, Persistenz): Skill **kickbasekumpel-data-map** – nicht hier suchen.

| Datei | Inhalt |
|---|---|
| `lib/main.dart` | Startup, ProviderScope (Auto-Retry aus), Fallback-FirebaseErrorApp |
| `lib/firebase_options.dart` | FlutterFire-Config |
| `lib/config/router.dart` | Alle GoRouter-Routen + `goRouterProvider` |
| `lib/config/theme.dart`, `app_theme.dart` | AppTheme.lightTheme/darkTheme |
| `lib/config/screen_size.dart` | Responsive-Breakpoints |

## Models (`lib/data/models/` – alle Freezed, Barrel: `models_barrel.dart`)

`user_model`, `league_model`, `player_model`, `transfer_model`, `market_model`, `market_value_model`, `lineup_model`, `optimal_lineup_model`, `match_model`, `leaderboard_model`, `performance_model`, `achievement_model`, `budget_calculation_model`, `sales_recommendation_model`, `squad_benchmark_model`, `team_player_counts_model`, `transfer_planner_model`, `ligainsider_model`, `ligainsider_match_model`, `common_models`, `achievement_model`. Generiert: `*.freezed.dart`, `*.g.dart`.

## Services (`lib/data/services/`)

| Service | Zweck |
|---|---|
| `kickbase_api_client.dart` | Kickbase REST v4 (Kern) |
| `demo_kickbase_api_client.dart` | Demo-Modus (statische Daten) |
| `http_client_wrapper.dart` | HTTP-Wrapper mit Retry |
| `token_storage.dart` | Secure Storage für Tokens |
| `bid_recommendation_service.dart` | Gebots-Empfehlungen |
| `budget_calculation_service.dart`, `achievement_budget_service.dart`, `achievement_derivation_service.dart`, `auto_sale_budget_service.dart` | Budget-Logik, Erfolgs-Ableitung |
| `deterministic_recommendation_service.dart` | Verkaufsempfehlungen |
| `squad_benchmark_service.dart`, `transfer_planner_service.dart` | Kader-Benchmark, Transferplanung |
| `manager_transfer_history_service.dart` | Transferhistorie |
| `ligainsider_service.dart`, `ligainsider_scraper_service.dart` | LigaInsider-Daten/Scraping |

## Repositories

`lib/data/repositories/base_repository.dart` (generisch), `firestore_repositories.dart` (User/League/Player/Transfer/Recommendation), `auth_repository.dart`. Interfaces: `lib/domain/repositories/repository_interfaces.dart` (Result<T>), `auth_repository_interface.dart`.

## Provider

- **Data** (`lib/data/providers/`): `auth_provider`, `kickbase_api_provider`, `kickbase_auth_provider`, `repository_providers`, `service_providers`, `providers.dart` (Barrel), `league_providers`, `league_detail_providers`, `player_providers`, `player_detail_providers`, `market…` → `presentation/providers/market_providers`, `transfer_providers`, `recommendation_providers`, `bid_recommendation_providers`, `budget_calculation_providers`, `scouted_players_providers`, `squad_benchmark_providers`, `manager_transfer_history_providers`, `achievement_providers`, `competition_providers`, `live_providers`, `ligainsider_provider`, `ligainsider_photo_provider`, `user_providers`, `demo_mode_provider`, `http_client_wrapper_provider`
- **UI** (`lib/presentation/providers/`): `dashboard_providers`, `market_providers`, `transfer_planner_provider`

## Screens/Pages (Auswahl)

`presentation/screens/`: `dashboard/`, `league/` (+ `league_table_screen`), `player/`, `ligainsider/`, `live_screen`, `squad_screen`, `manager_detail_screen`, `auth/`, `charts_demo_screen`, `widget_gallery_screen`.
`presentation/pages/`: `auth/`, `dashboard/`, `league/`, `player/`, `home_page`, `loading_screen`, `error_page`.

## Wichtige Widgets

`presentation/widgets/responsive_layout.dart`, `error_widget.dart`, `loading_widget.dart`, Unterverzeichnisse nach Typ (cards, charts, market, team, transfers, forms, buttons, app_bars, common). Katalog aller Widgets: `presentation/widgets/README.md` (Widget Gallery).

## Tests & Docs

- `test/` spiegelt lib/; `test/README.md`
- `docs/`: RIVERPOD_PROVIDERS, ROUTER_SETUP/QUICKSTART, FIRESTORE_REPOSITORIES, REPOSITORY_USAGE_EXAMPLES, AUTH_USAGE_EXAMPLES, HTTP_CLIENT_WRAPPER_USAGE, MARKET_VIEW_DOCUMENTATION, RESPONSIVE_DESIGN, LIGAINSIDER_SCRAPER, CLOUD_FUNCTIONS_SETUP, CI_CD_SETUP, UI_MIGRATION
- `docs/api-endpoints.json` – Swagger-Spezifikation Kickbase v4 (siehe kickbasekumpel-api)
- `docs/superpowers/plans/` + `specs/` – Feature-Pläne/Designs (z. B. Transfer-Planner)
- Root: `ARCHITECTURE.md` (Haupt-Doku), `.github/copilot-instructions.md`, `DOCUMENTATION_GUIDELINES.md`, `Ideen.md` (Roadmap)
