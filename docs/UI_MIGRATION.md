📋 Zusammenfassung für zukünftige Entwicklung
✅ Was wurde bereits implementiert
Models & Data-Layer
✅ sales_recommendation_model.dart - Verkaufsempfehlungen (Priority, Impact, Ziele)
✅ optimal_lineup_model.dart - Aufstellungsoptimierung (Formation, Lineups)
✅ team_player_counts_model.dart - Spieleranzahlen nach Position
UI-Navigation & Shell
✅ dashboard_shell.dart - Responsive Navigation für 8 Screens
Mobile: BottomNavigationBar mit horizontalem Scroll
Tablet: NavigationDrawer
Desktop: NavigationRail (Sidebar)
State Management
✅ dashboard_providers.dart - NotifierProvider-Pattern (Riverpod 3.x)
selectedDashboardTabProvider - Tab-Auswahl
selectedTeamPlayersForSaleProvider - Toggle für Verkauf
salesOptimizationGoalProvider - 3 Verkaufsziele
lineupOptimizationTypeProvider - Punkte-Typ Auswahl
lineupRespectBudgetProvider - Budget-Respekt
selectedFormationIndexProvider - Formation-Index
Team Screen (Screen 1/8)
✅ team_page.dart - Vollständig

Spielerliste mit Sortierung (Name, Marktwert, Punkte, Trend, Position)
Budget-Header zeigt aktuelles + Verkaufs-Budget
Spieleranzahl-Übersicht (Gesamt, TW, ABW, MF, ST)
Verkaufs-Toggle für jeden Spieler
RefreshIndicator
✅ Widgets im team:

team_budget_header.dart - Budget-Anzeige
player_count_overview.dart - Position-Übersicht
player_row_with_sale.dart - Spieler-Zeile mit erweiterten Infos:
  - Spalte 1: Vor-/Nachname + Teamname
  - Spalte 2: Status-Emoji (✅ Fit, ⚠️ Fraglich, 🚑 Verletzt)
  - Spalte 3: Durchschnittspunkte + Gesamtpunkte
  - Spalte 4: Marktwert + Trend (↑ grün / ↓ rot)
  - Toggle zum Verkaufen (Checkbox)
position_badge.dart - TW/ABW/MF/ST farbig
Router
✅ router.dart - 8 Tabs statt 7 konfiguriert
❌ Was noch implementiert werden muss (7/8 Screens)
Screen 2: MarketPage (lib/presentation/pages/dashboard/market_page.dart)
Anforderungen aus Swift:

Spieler-Suchefeld
Filter + Sortierung (Preis, Marktwert, Punkte, Position, Ablaufdatum, Gebote)
Spieler-Listen mit:
Foto/Position-Badge
Name + Status-Icons (verletzt, einzweifelhaft, etc.)
Team + Owner-Info (mit Verifizierungs-Badge)
Durchschnittspunkte + Gesamtpunkte
Verkaufspreis + Marktwert
Klick → PlayerDetailView (existiert schon)
Neue Widgets nötig:

lib/presentation/widgets/market/market_player_row.dart
lib/presentation/widgets/market/search_and_filter_bar.dart
Provider nötig:

marketPlayersProvider (FutureProvider) - aus player_providers.dart nutzen
marketSortOptionProvider (NotifierProvider)
marketSearchQueryProvider (NotifierProvider)
Screen 3: SalesRecommendationPage (lib/presentation/pages/dashboard/sales_recommendation_page.dart)
Anforderungen aus Swift:

3 Optimierungsziele: "Budget ins Plus" | "Maximaler Profit" | "Beste Spieler behalten"
Header zeigt Budget + empfohlene Verkäufe
Spieleranzahl nach Verkauf
Intelligente Empfehlungslogik:
Kritisch: Verletzte (Status 1), Gesperrte (Status 8), Aufbautraining (Status 4)
Performance: Letzte 5 Spiele analysieren (schwache Form?)
Fixture: Kommende 3 Spiele Gegner-Schwierigkeit
Position: Redundanz-Check (schwächste pro Position)
Budget: Bei negativ teure Spieler zuerst
Detaillierte Liste mit Toggle
Prioritäten-Übersicht (Hoch/Mittel/Niedrig)
Reservebank mit Best-Alts
Neue Widgets:

lib/presentation/widgets/sales/sales_recommendation_header.dart
lib/presentation/widgets/sales/sales_recommendation_row.dart
lib/presentation/widgets/sales/sales_recommendation_summary.dart
lib/presentation/widgets/sales/reserve_players_view.dart
Provider nötig:

salesRecommendationsProvider (AsyncNotifier mit Debouncing)
Performance-Daten laden (existiert schon?)
Fixture-Analyse für kommende Spiele implement
Ranking nach Priorität + Impact
Screen 4: LineupPage (lib/presentation/pages/dashboard/lineup_page.dart)
Anforderungen aus Swift:

Optimierungstyp: Durchschnittspunkte | Gesamtpunkte
Budget-Respekt Toggle
Auto-Formation (4-4-2, 4-3-3, 3-4-3, etc.)
Visuelle Formation Display (TW oben, MF, ABW unten)
Aufstellungs-Stats: Gesamt-/Durchschnittspunkte, Teamwert, Spieler-Count
Reservebank mit Positionsgrupierung + Best-Alts
"Mit Marktspieler" Button → LineupComparisonSheet
Formation-Buttons für manuelle Auswahl
Neue Widgets:

lib/presentation/widgets/lineup/lineup_stats_view.dart
lib/presentation/widgets/lineup/lineup_formation_view.dart
lib/presentation/widgets/lineup/lineup_player_card.dart
lib/presentation/widgets/lineup/reserve_bench_stats.dart
lib/presentation/widgets/lineup/reserve_player_row.dart
Provider nötig:

optimalLineupProvider (AsyncNotifier)
Formation-Berechnung (passende Formation basierend auf Spielern)
Optimale Spieler-Auswahl nach Punkte-Type
Screen 5: TransferTipsPage (lib/presentation/pages/dashboard/transfers_page.dart)
Anforderungen aus Swift:

Ähnlich Sales-Recommendation aber für Käufe
"Spieler zu verkaufen" + "Spieler zu kaufen" Tabs
KI-Tipps basierend auf:
Gute Performers auf dem Markt
Budget-verfügbarkeit
Team-Schwachstellen
Klick → Kauf-Dialog (BottomSheet)
Neue Widgets:

lib/presentation/widgets/transfers/transfer_recommendation_card.dart
lib/presentation/widgets/transfers/buy_player_bottom_sheet.dart (existiert evtl. schon?)
Provider nötig:

transferRecommendationsProvider (AsyncNotifier)
Screen 6: LigainsiderPage (lib/presentation/screens/ligainsider/ligainsider_screen.dart)
Anforderungen aus Swift:

Kommenden Spieltag anzeigen
Team-Match Info + Aufstellungen
Wahrscheinlichkeiten für Spieler
Spieler-Status Icons (verletzt, fraglich, etc.)
Match-Timeline
Neue Widgets:

lib/presentation/widgets/ligainsider/match_lineup_card.dart
lib/presentation/widgets/ligainsider/player_probability_indicator.dart
Provider nötig:

ligainsiderMatchesProvider (await existiert wahrscheinlich)
Screen 7: LeagueTablePage (lib/presentation/screens/league_table_screen.dart)
Anforderungen aus Swift:

Bundesliga-Tabelle mit:
Platzierungen
Team-Namen
Punkte
Spiele
Differenz
Klick auf Platzierung → Manager-Profil
Filter nach Liga/Saison
Neue Widgets:

lib/presentation/widgets/table/league_table_row.dart
Provider nötig:

leagueTableProvider (FutureProvider) - wahrscheinlich aus competition_providers.dart
Screen 8: LivePage (lib/presentation/screens/live_screen.dart)
Anforderungen aus Swift:

Aktuelle & kommende Spieltage
Match-Ergebnisse Live-Update
Spieler in aktuellem Match (Echtzeit-Punkte)
RefreshIndicator für Re-Load
Neue Widgets:

lib/presentation/widgets/live/live_match_card.dart
lib/presentation/widgets/live/live_score_display.dart
Provider nötig:

liveMatchesProvider (StreamProvider für Echtzeit-Updates)
🏗️ Architektur-Richtlinien
Pattern für neue Screens:
Widget-Struktur:
Alle Widgets in lib/presentation/widgets/{screen_name}/
Größere Components → view.dart oder card.dart
Wiederverwendbare → common
Provider-Pattern:
UI-State: NotifierProvider (Riverpod 3.x)
Async-Daten: FutureProvider oder AsyncNotifier
Real-time: StreamProvider
Family für Parameter: .family<ResultType, ParamType>
🔗 Abhängigkeiten zwischen Screens
Screen	Abhängig von	Benötigt
Team (✅)	-	-
Market	Team (für Budget)	teamPlayersProvider
Sales	Team + Market	Recommendation-Engine
Lineup	Team	Performance-Data
Transfers	Lineup + Market	Transfer-Engine
Ligainsider	-	Live-Match-Daten
Table	-	Competition-Daten
Live	Ligainsider	Stream-Updates
📦 To-Do für nächsten Agent
Market Screen - Einfachste (basiert auf Team, keine Logik)
Ligainsider + Live - Medium (UI-only, Daten wahrsch. vorhanden)
League Table - Medium (UI + Filter)
Transfer Tips - Schwer (benötigt Recommendation-Engine)
Sales Recommendation - Schwer (benötigt KI-Logik aus Swift-Code)
Lineup Optimizer - Schwer (Formation-Berechnung, Performance-Analyse)
Empfohlene Reihenfolge: Market → Ligainsider → Live → Table → Transfer-Tips → Sales → Lineup

🎨 Design-Konsistenz
Material Design 3 (nutze Theme.of(context))
Farben aus app_theme.dart
Icons aus material/Icons
Platform: Flutter (Auto-responsive auf Mobile/Tablet/Desktop)
Keine native Swift/Objective-C Code nötig
🧪 Testing-Checklist
Vor dem Merge jedes Screens:

 App kompiliert ohne Fehler
 Screen wird auf iPhone/iPad/Desktop angezeigt
 Navigation funktioniert
 Daten laden korrekt
 Interaktionen (Toggle, Filter, Sortierung) funktionieren
 Dark Mode getestet