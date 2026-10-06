---
name: kickbasekumpel-features
description: KickbaseKumpel Feature-Übersicht - welches Feature wo implementiert ist (Service, Provider, Screen), Business-Logik der Empfehlungs-/Budget-Services, Roadmap aus Ideen.md. Verwenden um Features zu verstehen, zu erweitern oder Fehler zu lokalisieren.
---

# KickbaseKumpel – Features & Business-Logik

Feature → Einstiegspunkte (Logik in `lib/data/services/`, State in Provider, UI in `lib/presentation/`):

## Empfehlungen & Transfermarkt

| Feature | Kern-Dateien |
|---|---|
| Gebots-Empfehlung | `bid_recommendation_service.dart` (Methoden: minimum/median/quartile, confidence, premium, sampleSize) + `bid_recommendation_providers.dart` |
| Verkaufsempfehlungen | `deterministic_recommendation_service.dart` + `recommendation_providers.dart` (Ziele: Budgetausgleich, Gewinnmaximierung) |
| Transfer-Planner | `transfer_planner_service.dart` (deterministische Szenarien, Rejection-Gründe: unaffordable/illegalLineup/notInXI/noGain) + `transfer_planner_provider.dart`; Spec: docs/superpowers/specs/2026-05-17-transfer-planner-design.md |
| Auto-Verkauf/Budget | `auto_sale_budget_service.dart` |
| Kader-Benchmark | `squad_benchmark_service.dart` + `squad_benchmark_providers.dart` |

## Budget & Achievements

- `budget_calculation_service.dart` + `budget_calculation_providers.dart` – Gesamtbudget
- `achievement_budget_service.dart` + `achievement_providers.dart` – Achievements fließen ins Budget ein
- Aktivitäten-Feed (`GET /leagues/{id}/activitiesFeed`) wird bereits für Achievements-Budget genutzt

## Liga & Spieler

- Liga-Details/Tabelle: `league_providers.dart`, `league_detail_providers.dart`, Screens `league/`, `league_table_screen`
- Spieler-Statistiken/Historie: `player_providers.dart`, `player_detail_providers.dart`, `manager_transfer_history_service.dart`
- Live: `live_providers.dart`, `live_screen.dart`
- Transferhistorie-Mitbieter: `manager_transfer_history_providers.dart`

## LigaInsider

- App: `ligainsider_service.dart`, Screens `ligainsider/`, Route `/dashboard/ligainsider` + `/ligainsider/lineups`
- Scraper (Cloud Functions, siehe kickbasekumpel-backend); Status-Badge im UI

## Demo-Modus

`demo_kickbase_api_client.dart` + `demo_mode_provider.dart` – siehe kickbasekumpel-backend.

## Roadmap (`Ideen.md`)

Ungenutzte Kickbase-v4-Endpunkte (Doku: `docs/api-endpoints.json`, Swagger):
1. `GET /leagues/{id}/settings` ⭐ – echte Liga-Regeln (Steuersatz, Mindestgebot, 250er-Regel) statt hartkodierter Annahmen
2. `activitiesFeed` – Social-Feed, Mitbieter-Identifikation (Lücke im BidRecommendationService)
3. `GET /matches/{matchId}/details` + `/live/eventtypes` – Live-Spielereignisse

Umsetzung von Ideen.md ist noch OFFEN – vor Implementierung dort und in docs/superpowers/ (plans/specs) nach aktuellen Stand suchen.
