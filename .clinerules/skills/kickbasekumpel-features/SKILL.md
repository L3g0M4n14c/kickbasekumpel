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
| Verkaufs-Timing (Nachfrage-Hinweis) | `manager_transfer_history_service.dart` (`purchasesByTimeWindow`, `demandProfile`: Käufe pro Wochentag/6h-Zeitfenster, Intensität hoch/mittel/niedrig, `null` bei < 4 Wochen Daten) + `leagueTransferDemandProvider` in `manager_transfer_history_providers.dart` + `demand_hint_card.dart` in der Verkaufsempfehlung |
| Transfer-Planner | `transfer_planner_service.dart` (deterministische Szenarien, Rejection-Gründe: unaffordable/illegalLineup/notInXI/noGain) + `transfer_planner_provider.dart`; Spec: docs/superpowers/specs/2026-05-17-transfer-planner-design.md |
| Auto-Verkauf/Budget | `auto_sale_budget_service.dart` |
| Kader-Benchmark | `squad_benchmark_service.dart` + `squad_benchmark_providers.dart` |

## Budget & Achievements

- `budget_calculation_service.dart` + `budget_calculation_providers.dart` – Gesamtbudget (Startbudget + Transfers + Punktgeld/Spieltagsprämie (`tp` × 1000 €) + Anmeldebonus + Auto-Verkauf + Erfolge). Anmeldebonus für den eigenen Manager exakt aus dem Aktivitäten-Feed (Typ 22, `data.bn`), sonst Formel-Obergrenze; Kalibrierung: eigenes Budget = echtes `me/budget` (Log „🧭 Budget-Kalibrierung", `budgetDeviation` im Ergebnis)
- `achievement_budget_service.dart` – exakte Summe des eigenen Managers (`ac × er`) + Erfolgs-Katalog
- `achievement_derivation_service.dart` + `achievement_providers.dart` – **deterministische Ableitung der Erfolge aller Manager** (Spieltags-Ranking `mdp`, Lineup-Punkte, Transfer-Historie), Kalibrierung gegen die eigenen `ac`-Werte (Log „🧭 Achievement-Kalibrierung"). Der Aktivitäten-Feed zeigt nur eigene Erfolge und wird NICHT genutzt.
- **Tagesbonus (Story #17)** – `daily_bonus_service.dart` (Status-/Parsing-Logik: `GET /base/overview` Bonus-Status defensiv – nur explizite Bonus-Einträge (`it` mit `v`/`day`) gelten als Hinweis, `GET /bonus/collect` → `BonusCollectResult`) + `daily_bonus_providers.dart` (`dailyBonusProvider`, Tap-to-Collect, Persistenz `daily_bonus_last_collected` in SharedPreferences) + `daily_bonus_banner.dart` auf `team_page` (Startseite unter `/dashboard`); der gespeicherte Einsammel-Tag sorgt für „Banner bis zum nächsten Tag aus"

## Liga & Spieler

- Liga-Details/Tabelle: `league_providers.dart`, `league_detail_providers.dart`, Screens `league/`, `league_table_screen`
- **Manager-Direktvergleich (Du vs. Rivale)**: `manager_comparison_service.dart` + `manager_comparison_providers.dart` – Gegenüberstellung von Kaderwert, Punkten der letzten 5 Spieltage, Transfer-Erfolg (Ø Deal-Qualität, Kursgewinn) und Budget plus Stärken/Schwächen-Kurzfazit als Klartext. Screen `manager_comparison_screen.dart`, Auswahl (max. 2 Manager, Long-Press oder AppBar-Icon) in der Rangliste `league_standings_page.dart`, Route `/manager/:leagueId/compare?a=<id>&b=<id>` (Seite A = „Du")
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

Umsetzung von Ideen.md: Feature-Idee B (Verkaufs-Timing) ist umgesetzt
(Story #15, Nachfrage-Hinweis in der Verkaufsempfehlung), der Rest ist noch
OFFEN – vor Implementierung dort und in docs/superpowers/ (plans/specs) nach
aktuellen Stand suchen.
