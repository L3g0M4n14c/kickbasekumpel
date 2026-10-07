# 2026-10-07 – Zielbasierte Verkaufsempfehlungen (Sales-Goals)

## Ziel

Die Verkaufen-Seite bekommt die 3 Ziele aus `docs/UI_MIGRATION.md` (Screen 3):
„Budget ins Plus", „Maximaler Profit", „Beste Spieler behalten" – mit
Prioritäten (Hoch/Mittel/Niedrig), Budget-Header und Spieleranzahl nach
Verkauf. **Ohne Ersatzspieler** (Markt-Ersatz liegen in den Transfertipps).

## Umgesetzt

| Datei | Inhalt |
|---|---|
| `lib/data/services/sales_goal_service.dart` | NEU: `SaleGoal`, `SalePriority`, `SaleAdvice`, `SalesGoalOutcome`, `rankForGoal` (rein deterministisch) |
| `lib/data/providers/recommendation_providers.dart` | `upcomingFixtures` (bis 3 kommende Spiele) pro Spieler, `_isPlayerUnavailable` delegiert an `DeterministicRecommendationService.isUnavailable` |
| `lib/presentation/providers/dashboard_providers.dart` | `saleGoalProvider` (Notifier, Default `keepBest`), `saleAdvicesProvider` (FutureProvider.family) |
| `lib/presentation/pages/dashboard/sales_recommendation_page.dart` | Ziel-Auswahl (SegmentedButton), `TeamBudgetHeader` (Budget + Erlös-Summe), Spieleranzahl nach Verkauf, Prioritäts-Chip, „Behalten"-ExpansionTile |
| `lib/data/services/deterministic_recommendation_service.dart` | Status 3/4 aufgenommen, `isUnavailable`, Fixture-Mittelung über bis zu 3 Spiele (`FixtureInfo`) |
| `lib/presentation/utils/player_status_helper.dart` | Status 3 (Gesperrt) + 8 (Sperre) für Emoji/Name/Farbe |

## Regeln

- Basis-Signale unverändert aus `DeterministicRecommendationService` (Score/Action).
- **Alle Ziele**: Verkauft wird nur, was für einen Spieltag entbehrlich ist –
  es müssen mindestens 11 Spieler und eine spielbare Formation
  (`Formation.allFormations`, z. B. 4-4-2/4-5-1) übrig bleiben. Damit bleiben
  u. a. der einzige Torwart und Stürmer immer im Kader, während schwache
  Überzahl-Spieler verkäuflich sind. Überschreibbar via `formations`
  (leer = keine Anforderung, z. B. in Tests).
- **Budget ins Plus**: nur bei Budget < 0 (sonst Info). Reihenfolge: kritische
  Spieler zuerst, dann die schwächsten Spieler (Score aufsteigend) – die
  Besten bleiben im Kader, lieber zwei schwächere Verkäufe als ein starker.
  Abbruch, sobald die Budget-Lücke gedeckt ist
  (nur so viele Verkäufe wie nötig). Priorität: kritisch → Hoch; sonst
  `proceeds ≥ Rest-Lücke` → Hoch, `≥ halbe Lücke` → Mittel, sonst Niedrig.
  Info-Hinweis, wenn die Lücke mit den möglichen Verkäufen nicht gedeckt
  werden kann.
- **Maximaler Profit**: nur sell/strong-sell über der Startelf, nach Erlös
  absteigend; Score < 20 → Hoch, sonst Mittel.
- **Beste Spieler behalten**: Kandidaten sind alle Spieler über der Startelf
  sowie kritische Spieler. Sortierung: Priorität, dann Score aufsteigend.
- Kritisch = `DeterministicRecommendationService.isUnavailable(status)`.

## Status-Abgleich Swift ↔ Flutter

| Code | Swift (Kickbasehelper) | Flutter (vorher) | Flutter (jetzt) |
|---|---|---|---|
| 0 | Verfügbar | Fit | Fit |
| 1 | Verletzt | Verletzt (Logik+Anzeige) | = |
| 2 | Angeschlagen | Angeschlagen | = |
| 3 | Gesperrt | – | Gesperrt (Sperre-Set, Anzeige) |
| 4 | Aufbautraining | nur Anzeige | + Logik (`recoveryStatuses`, kritisch) |
| 8 | Sperre (Markt-Filter) | nur Logik | + Anzeige |
| 16 | nur Markt-Filter, Semantik unbekannt | – | bewusst NICHT übernommen |
| 32 / 256 | – | Gelbsperre / Abwesend | = |

## Gegnerstärke (Fixture-Analyse)

Vorher: nur der nächste Gegner (Tabellenposition + Heim/Auswärts, ±6 Punkte).
Jetzt wie in der Vorgänger-App: bis zu **3 kommende Spiele**, gemittelt
(Ø-Schwierigkeit), Text nennt alle Gegner. Offen/Abweichung zu Swift: dessen
Einzel-Signale „Top-Team-Gegner-Anzahl" und „schwere Auswärtsspiele" (nur
Text-Begründungen im Kauf-Bereich) sind nicht übernommen.

## Tests

- `test/data/services/sales_goal_service_test.dart` (NEU, 8 Tests)
- `test/data/services/deterministic_recommendation_service_test.dart` (+4)
- `test/presentation/utils/player_status_helper_test.dart` (+4)
- `test/presentation/pages/dashboard/sales_recommendation_page_test.dart` (+1 Widget-Test)

## Annahmen

- Die Startelf-Grenze (11 + Formation) und die Prioritäts-Schwellen sind
  dokumentierte Konstanten – `formations` lässt sich pro Aufruf überschreiben
  (z. B. für Liga-Regeln, sobald `GET /leagues/{id}/settings` angebunden ist).
- `generateForPlayer` (Einzel-Spieler-Pfad) nutzt weiter den
  Single-Fixture-Fallback; nur `generateForPlayers` liefert die 3 Fixtures.