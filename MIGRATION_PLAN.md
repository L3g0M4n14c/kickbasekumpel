# 🔄 Migrationsplan: Swift → Flutter Feature-Parität

## Ausgangslage

Das **Swift-Projekt** (L3g0M4n14c/Kickbasehelper) hat einen voll funktionalen Kickbase-Manager mit folgenden Features:
- Dashboard mit Liga-Übersicht, Rangliste, Live-Punkte
- Spieler-Kader mit Detail-Ansicht, Performance-Charts, Marktwert-Verlauf
- Transfermarkt mit Kauf/Verkauf, Angebote annehmen/ablehnen
- Transfer-Empfehlungen (algorithmisch basiert)
- Verkaufs-Empfehlungen
- Liga-Tabelle (Bundesliga-Tabelle)
- Aufstellungs-Vergleich
- Liga Insider Integration (Web-Scraping)
- Live-Spieltag mit Echtzeit-Punkten
- Spieler-Match-Details
- Bonus-Sammlung
- User-Profil mit Squad-Ansicht
- Beobachtungsliste (Scouted Players)
- Aktivitäten-Feed

Das **Flutter-Projekt** (kickbasekumpel) hat bisher nur:
- ✅ Login bei Kickbase API
- ✅ Basis-User-Daten anzeigen
- ✅ Ligen auflisten (teilweise)
- ⚠️ Viele UI-Screens existieren als Skelett/Placeholder

---

## 📋 Schritt-für-Schritt Migrationsplan

Der Plan ist in **10 Schritte** unterteilt. Jeder Schritt ist ein eigenständiges, abgeschlossenes Arbeitspaket mit einem Copilot-Agent-Prompt.

---

### Schritt 1: API-Client vervollständigen — Liga & User Endpoints

**Ziel:** Alle fehlenden Liga- und User-bezogenen API-Endpoints im `KickbaseAPIClient` implementieren.

**Fehlende Endpoints:**
- `GET /v4/user/settings` — User-Einstellungen
- `GET /v4/leagues/{leagueId}/me` — Eigene Stats in der Liga
- `GET /v4/leagues/{leagueId}/me/budget` — Aktuelles Budget
- `GET /v4/leagues/{leagueId}/squad` — Eigener Kader
- `GET /v4/leagues/{leagueId}/ranking` — Liga-Rangliste (mit optionalem `dayNumber` Parameter)
- `GET /v4/bonus/collect` — Täglichen Bonus abholen

**Copilot-Agent-Prompt:**
```
Öffne die Datei lib/data/services/kickbase_api_client.dart im Repository kickbasekumpel.

Füge folgende neue API-Methoden hinzu, analog zum bestehenden Muster (mit _makeRequestWithRetry und _processResponse):

1. getUserSettings() — GET /v4/user/settings
   Gibt Map<String, dynamic> zurück (raw JSON).

2. getLeagueMe(String leagueId) — GET /v4/leagues/{leagueId}/me
   Gibt Map<String, dynamic> zurück.

3. getMyBudget(String leagueId) — GET /v4/leagues/{leagueId}/me/budget
   Gibt Map<String, dynamic> zurück.

4. getMySquad(String leagueId) — GET /v4/leagues/{leagueId}/squad
   Gibt Map<String, dynamic> zurück. Die Spieler-Daten stehen im Feld "it" als Array.

5. getLeagueRanking(String leagueId, {int? matchDay}) — GET /v4/leagues/{leagueId}/ranking
   Wenn matchDay != null, hänge "?dayNumber={matchDay}" an die URL. Gibt Map<String, dynamic> zurück.

6. collectBonus() — GET /v4/bonus/collect
   Gibt Map<String, dynamic> zurück.

Verwende die bestehenden Hilfsmethoden _makeRequestWithRetry und _parseJson.
Alle Methoden benötigen Authentifizierung (requiresAuth: true, ist der Default).
Halte dich an den bestehenden Code-Stil mit Logging (print-Statements mit Emojis).
```

---

### Schritt 2: API-Client vervollständigen — Spieler-Detail-Endpoints

**Ziel:** Alle fehlenden spieler-bezogenen API-Endpoints ergänzen.

**Fehlende Endpoints:**
- `GET /v4/leagues/{leagueId}/players/{playerId}` — Spieler-Details
- `GET /v4/leagues/{leagueId}/players/{playerId}/marketvalue/{timeframe}` — Marktwert-Historie
- `GET /v4/leagues/{leagueId}/players/{playerId}/transferHistory` — Transfer-Historie eines Spielers
- `GET /v4/leagues/{leagueId}/players/{playerId}/transfers` — Spieler-Transfers

**Copilot-Agent-Prompt:**
```
Öffne die Datei lib/data/services/kickbase_api_client.dart im Repository kickbasekumpel.

Füge folgende Spieler-Detail-API-Methoden hinzu:

1. getPlayerDetails(String leagueId, String playerId) — GET /v4/leagues/{leagueId}/players/{playerId}
   Gibt Map<String, dynamic> zurück mit den kompletten Spieler-Details.

2. getPlayerMarketValue(String leagueId, String playerId, {int timeframe = 365}) — GET /v4/leagues/{leagueId}/players/{playerId}/marketvalue/{timeframe}
   Gibt Map<String, dynamic> zurück. Der timeframe-Parameter ist die Anzahl Tage (Standard: 365).

3. getPlayerTransferHistory(String leagueId, String playerId, {int? matchDay}) — GET /v4/leagues/{leagueId}/players/{playerId}/transferHistory
   Wenn matchDay != null, hänge "?matchDay={matchDay}" an. Gibt Map<String, dynamic> zurück.

4. getPlayerTransfers(String leagueId, String playerId) — GET /v4/leagues/{leagueId}/players/{playerId}/transfers
   Gibt Map<String, dynamic> zurück.

Verwende _makeRequestWithRetry und _parseJson wie bei den bestehenden Methoden.
Halte dich an den bestehenden Code-Stil.
```

---

### Schritt 3: API-Client vervollständigen — Manager & Transfermarkt-Endpoints

**Ziel:** Manager-Profil-Endpoints und erweiterte Transfermarkt-Operationen ergänzen.

**Fehlende Endpoints:**
- `GET /v4/leagues/{leagueId}/managers/{userId}/dashboard` — Manager-Profil
- `GET /v4/leagues/{leagueId}/managers/{userId}/performance` — Manager-Performance
- `GET /v4/leagues/{leagueId}/managers/{userId}/squad` — Manager-Kader
- `DELETE /v4/leagues/{leagueId}/market/{playerId}` — Spieler vom Markt nehmen
- `DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}` — Angebot zurückziehen
- `DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/accept` — Angebot annehmen
- `DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/decline` — Angebot ablehnen
- `DELETE /v4/leagues/{leagueId}/market/{playerId}/sell` — An Kickbase verkaufen

**Copilot-Agent-Prompt:**
```
Öffne die Datei lib/data/services/kickbase_api_client.dart im Repository kickbasekumpel.

Füge folgende API-Methoden hinzu:

Manager-Endpoints:
1. getManagerDashboard(String leagueId, String userId) — GET /v4/leagues/{leagueId}/managers/{userId}/dashboard
   Gibt Map<String, dynamic> zurück.

2. getManagerPerformance(String leagueId, String userId) — GET /v4/leagues/{leagueId}/managers/{userId}/performance
   Gibt Map<String, dynamic> zurück.

3. getManagerSquad(String leagueId, String userId) — GET /v4/leagues/{leagueId}/managers/{userId}/squad
   Gibt Map<String, dynamic> zurück.

Erweiterte Transfermarkt-Endpoints:
4. removePlayerFromMarket(String leagueId, String playerId) — DELETE /v4/leagues/{leagueId}/market/{playerId}
   Gibt Map<String, dynamic> zurück.

5. withdrawOffer(String leagueId, String playerId, String offerId) — DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}
   Gibt Map<String, dynamic> zurück.

6. acceptOffer(String leagueId, String playerId, String offerId) — DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/accept
   Gibt void zurück (kein Response-Body).

7. declineOffer(String leagueId, String playerId, String offerId) — DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/decline
   Gibt void zurück.

8. acceptKickbaseOffer(String leagueId, String playerId) — DELETE /v4/leagues/{leagueId}/market/{playerId}/sell
   Gibt void zurück.

Für die DELETE-Methoden: Verwende method: 'DELETE' im _makeRequest-Aufruf.
Für Methoden die void zurückgeben, prüfe nur den Status-Code (200-299 = OK).
Halte dich an den bestehenden Code-Stil.
```

---

### Schritt 4: API-Client vervollständigen — Live, Beobachtungsliste & Wettbewerb

**Ziel:** Live-Spieltag, Scouted Players und Competition-Endpoints ergänzen.

**Fehlende Endpoints:**
- `GET /v4/leagues/{leagueId}/teamcenter/myeleven` — Live Spieltag / Meine Elf
- `GET /v4/live/eventtypes` — Live Event-Typen
- `GET /v4/leagues/{leagueId}/scoutedplayers` — Beobachtungsliste anzeigen
- `POST /v4/leagues/{leagueId}/scoutedplayers/{playerId}` — Spieler beobachten
- `DELETE /v4/leagues/{leagueId}/scoutedplayers/{playerId}` — Spieler nicht mehr beobachten
- `GET /v4/competitions/{competitionId}/table` — Bundesliga-Tabelle
- `GET /v4/competitions/{competitionId}/matchdays` — Spieltage
- `GET /v4/competitions/{competitionId}/playercenter/{playerId}` — Spieler-Match-Detail

**Copilot-Agent-Prompt:**
```
Öffne die Datei lib/data/services/kickbase_api_client.dart im Repository kickbasekumpel.

Füge folgende API-Methoden hinzu:

Live-Endpoints:
1. getMyEleven(String leagueId) — GET /v4/leagues/{leagueId}/teamcenter/myeleven
   Gibt Map<String, dynamic> zurück.

2. getLiveEventTypes() — GET /v4/live/eventtypes
   Gibt Map<String, dynamic> zurück.

Beobachtungsliste (Scouted Players):
3. getScoutedPlayers(String leagueId) — GET /v4/leagues/{leagueId}/scoutedplayers
   Gibt Map<String, dynamic> zurück.

4. addScoutedPlayer(String leagueId, String playerId) — POST /v4/leagues/{leagueId}/scoutedplayers/{playerId}
   Gibt void zurück. Kein Body nötig.

5. removeScoutedPlayer(String leagueId, String playerId) — DELETE /v4/leagues/{leagueId}/scoutedplayers/{playerId}
   Gibt void zurück.

Wettbewerb/Competition-Endpoints:
6. getCompetitionTable(String competitionId) — GET /v4/competitions/{competitionId}/table
   Gibt Map<String, dynamic> zurück.

7. getCompetitionMatchdays(String competitionId) — GET /v4/competitions/{competitionId}/matchdays
   Gibt Map<String, dynamic> zurück.

8. getPlayerEventHistory(String competitionId, String playerId, {int? matchDay}) — GET /v4/competitions/{competitionId}/playercenter/{playerId}
   Wenn matchDay != null, hänge "?day={matchDay}" an. Gibt Map<String, dynamic> zurück.

Für POST-Methoden ohne Body: Sende einen leeren Body oder keinen Body.
Halte dich an den bestehenden Code-Stil.
```

---

### Schritt 5: Riverpod-Provider für neue Endpoints erstellen

**Ziel:** Für alle neuen API-Methoden Riverpod-Provider erstellen, damit die UI darauf zugreifen kann.

**Copilot-Agent-Prompt:**
```
Im Repository kickbasekumpel, erstelle oder erweitere folgende Provider-Dateien unter lib/data/providers/:

1. Erstelle lib/data/providers/league_detail_providers.dart:
   - leagueMeProvider(String leagueId) — FutureProvider.family, ruft kickbaseApiClient.getLeagueMe() auf
   - myBudgetProvider(String leagueId) — FutureProvider.family, ruft getMyBudget() auf
   - mySquadProvider(String leagueId) — FutureProvider.family, ruft getMySquad() auf
   - leagueRankingProvider((String leagueId, int? matchDay)) — FutureProvider.family, ruft getLeagueRanking() auf

2. Erstelle lib/data/providers/player_detail_providers.dart:
   - playerDetailsProvider((String leagueId, String playerId)) — FutureProvider.family, ruft getPlayerDetails() auf
   - playerMarketValueProvider((String leagueId, String playerId, int timeframe)) — FutureProvider.family
   - playerTransferHistoryProvider((String leagueId, String playerId)) — FutureProvider.family

3. Erstelle lib/data/providers/manager_providers.dart:
   - managerDashboardProvider((String leagueId, String userId)) — FutureProvider.family
   - managerPerformanceProvider((String leagueId, String userId)) — FutureProvider.family
   - managerSquadProvider((String leagueId, String userId)) — FutureProvider.family

4. Erstelle lib/data/providers/live_providers.dart:
   - myElevenProvider(String leagueId) — FutureProvider.family, ruft getMyEleven() auf
   - liveEventTypesProvider — FutureProvider, ruft getLiveEventTypes() auf

5. Erstelle lib/data/providers/scouted_players_providers.dart:
   - scoutedPlayersProvider(String leagueId) — FutureProvider.family, ruft getScoutedPlayers() auf

6. Erstelle lib/data/providers/competition_providers.dart:
   - competitionTableProvider(String competitionId) — FutureProvider.family
   - competitionMatchdaysProvider(String competitionId) — FutureProvider.family

Jeder Provider soll den kickbaseApiClientProvider verwenden (ref.watch(kickbaseApiClientProvider)).
Verwende das bestehende Provider-Muster aus lib/data/providers/league_providers.dart als Vorlage.
Exportiere alle neuen Provider auch in lib/data/providers/providers.dart (barrel file).
```

---

### Schritt 6: Liga-Dashboard & Rangliste UI implementieren

**Ziel:** Das Dashboard soll nach Login die Liga-Übersicht zeigen mit Rangliste, Budget und Kader-Zusammenfassung — wie im Swift-Projekt.

**Copilot-Agent-Prompt:**
```
Im Repository kickbasekumpel, überarbeite die Home-Seite und Liga-Screens:

1. Überarbeite lib/presentation/pages/home_page.dart:
   - Nach Login soll eine Liga-Auswahl angezeigt werden (Dropdown oder Karten)
   - Für die ausgewählte Liga: Budget, Teamwert, Punktestand anzeigen
   - Daten kommen aus den Providern leagueMeProvider und myBudgetProvider
   - Zeige eine Kurzübersicht des eigenen Kaders (Anzahl Spieler, Durchschnittspunkte)

2. Überarbeite lib/presentation/pages/league_standings_page.dart:
   - Zeige die Liga-Rangliste (leagueRankingProvider)
   - Tabelle mit: Platz, Manager-Name, Teamwert, Punkte
   - Füge Spieltag-Auswahl hinzu (Dropdown), um die Rangliste für einen bestimmten Spieltag zu sehen
   - Aktueller User soll farblich hervorgehoben sein

3. Verwende ConsumerWidget oder ConsumerStatefulWidget mit ref.watch() für die Provider
4. Zeige Loading-Indikator während Daten geladen werden (verwende bestehendes LoadingWidget)
5. Zeige Fehlermeldung bei API-Fehlern (verwende bestehendes ErrorWidget)
6. Halte dich an das bestehende Material Design 3 Theme
```

---

### Schritt 7: Kader-Ansicht (Squad/Team) UI implementieren

**Ziel:** Der eigene Kader soll angezeigt werden mit allen Spielern, sortiert nach Position — wie im Swift TeamManagementViews.

**Copilot-Agent-Prompt:**
```
Im Repository kickbasekumpel, implementiere die Kader-Ansicht:

1. Überarbeite lib/presentation/screens/home_screen.dart oder erstelle einen neuen Screen lib/presentation/screens/squad_screen.dart:
   - Lade den eigenen Kader über mySquadProvider(leagueId)
   - Zeige Spieler gruppiert nach Position: Torwart (pos=1), Abwehr (pos=2), Mittelfeld (pos=3), Sturm (pos=4)
   - Jeder Spieler zeigt: Name, Team, Position-Badge, Marktwert, Durchschnittspunkte, Gesamtpunkte
   - Marktwert-Trend anzeigen (grüner Pfeil hoch / roter Pfeil runter)
   - Tipp auf Spieler → Navigation zu PlayerDetailScreen

2. Überarbeite lib/presentation/screens/player_detail_screen.dart:
   - Lade Spieler-Details über playerDetailsProvider
   - Tab 1 "Übersicht": Name, Team, Position, Marktwert, Status, Profilbild
   - Tab 2 "Performance": Lade Performance über getPlayerStats() — zeige PerformanceLineChart
   - Tab 3 "Marktwert": Lade Marktwert-Historie über playerMarketValueProvider — zeige PriceChart
   - Verwende bestehende Chart-Widgets aus lib/presentation/widgets/charts/

3. Zeige Budget-Info oben auf der Kader-Seite
4. Verwende bestehende Widgets: PlayerListTile, PositionBadge, LoadingWidget, ErrorWidget
```

---

### Schritt 8: Transfermarkt erweitern

**Ziel:** Der Transfermarkt soll vollständig funktionieren — wie im Swift-Projekt mit Angeboten, Rücknahmen, Verkauf an Kickbase.

**Copilot-Agent-Prompt:**
```
Im Repository kickbasekumpel, erweitere den Transfermarkt:

1. Überarbeite lib/presentation/screens/market_screen.dart:
   - Tab "Verfügbar": Zeige Spieler auf dem Markt (bereits implementiert — prüfen und verbessern)
   - Tab "Meine Angebote": Zeige eigene Spieler auf dem Markt mit Angeboten
     - Button "Vom Markt nehmen" → removePlayerFromMarket()
     - Button "An Kickbase verkaufen" → acceptKickbaseOffer()
   - Tab "Erhaltene Angebote": Zeige eingegangene Angebote
     - Button "Annehmen" → acceptOffer()
     - Button "Ablehnen" → declineOffer()
   - Tab "Beobachtungsliste": Zeige beobachtete Spieler
     - Lade über scoutedPlayersProvider
     - Button "Entfernen" → removeScoutedPlayer()

2. Verbessere lib/presentation/widgets/market/buy_player_bottom_sheet.dart:
   - Angebot-Eingabe mit Preis
   - Button "Angebot abgeben" → buyPlayer()
   - Button "Beobachten" → addScoutedPlayer()
   - Zeige Marktwert als Referenz

3. Füge Bestätigungs-Dialoge hinzu für:
   - Spieler kaufen (mit Preisanzeige)
   - Spieler verkaufen
   - Angebot annehmen/ablehnen
   Verwende das bestehende ConfirmationDialog-Widget.

4. Nach jeder Aktion: Provider invalidieren und Liste aktualisieren (ref.invalidate).
```

---

### Schritt 9: Live-Spieltag & Bonus-Sammlung implementieren

**Ziel:** Live-Punkte während eines Spieltags anzeigen und täglichen Bonus sammeln — wie im Swift LiveView und BonusCollectionSettingsView.

**Copilot-Agent-Prompt:**
```
Im Repository kickbasekumpel, implementiere Live-Spieltag und Bonus:

1. Erstelle lib/presentation/screens/live_screen.dart:
   - Lade "Meine Elf" über myElevenProvider(leagueId)
   - Zeige alle aufgestellten Spieler mit Live-Punkten
   - Für jeden Spieler: Name, Team, Position, aktuelle Punkte des Spieltags
   - Gesamtpunktzahl des Spieltags oben anzeigen
   - Auto-Refresh alle 60 Sekunden (Timer oder Stream)
   - Farbkodierung: Grün für positive Punkte, Rot für negative

2. Füge den Live-Screen als Tab im Dashboard hinzu:
   - Überarbeite lib/presentation/pages/dashboard_shell.dart
   - Füge "Live" Tab zwischen "Home" und "Kader" ein
   - Icon: Icons.sports_soccer oder Icons.live_tv

3. Implementiere Bonus-Sammlung:
   - In lib/presentation/pages/settings_page.dart oder home_page.dart:
   - Button "Täglichen Bonus sammeln" → collectBonus()
   - Zeige Erfolgs-/Fehler-Nachricht nach dem Aufruf
   - Zeige wann der letzte Bonus gesammelt wurde (falls API das zurückgibt)

4. Verwende bestehende Widgets und das Material Design 3 Theme.
```

---

### Schritt 10: Manager-Profile & Liga-Tabelle implementieren

**Ziel:** Andere Manager in der Liga ansehen können (Squad, Performance) und die Bundesliga-Tabelle anzeigen.

**Copilot-Agent-Prompt:**
```
Im Repository kickbasekumpel, implementiere Manager-Profile und Liga-Tabelle:

1. Erstelle lib/presentation/screens/manager_detail_screen.dart:
   - Zeige Manager-Profil: Name, Teamwert, Budget, Punkte
   - Daten über managerDashboardProvider(leagueId, userId)
   - Tab "Kader": Zeige Spieler des Managers über managerSquadProvider
   - Tab "Transfers": Zeige Transfer-Geschichte des Managers
   - Tab "Performance": Zeige Punkteverlauf über managerPerformanceProvider
   - Navigation: Von der Liga-Rangliste → Tipp auf Manager → ManagerDetailScreen

2. Erstelle lib/presentation/screens/league_table_screen.dart:
   - Lade Bundesliga-Tabelle über competitionTableProvider
   - Zeige: Platz, Verein, Spiele, Siege, Unentschieden, Niederlagen, Tore, Punkte
   - CompetitionId ist "1" für die Bundesliga (oder aus der Liga-Response entnehmen)
   - Standard-Tabellen-Layout

3. Füge Navigation hinzu:
   - In der Liga-Rangliste: Tipp auf Manager → ManagerDetailScreen
   - In der Dashboard-Navigation: Neuer Tab oder Menüpunkt "Tabelle" → LeagueTableScreen

4. Überarbeite lib/config/router.dart:
   - Füge Routen hinzu für /manager/:leagueId/:userId und /table/:competitionId
   - Verwende das bestehende GoRouter-Setup
```

---

## 📊 Übersicht: Feature-Vergleich Swift vs. Flutter

| Feature | Swift | Flutter (aktuell) | Flutter (nach Migration) |
|---------|-------|-------------------|-------------------------|
| Login | ✅ | ✅ | ✅ |
| User-Profil | ✅ | ⚠️ Basis | ✅ |
| Liga-Auswahl | ✅ | ⚠️ Teilweise | ✅ |
| Liga-Rangliste | ✅ | ❌ | ✅ (Schritt 6) |
| Budget-Anzeige | ✅ | ❌ | ✅ (Schritt 6) |
| Eigener Kader | ✅ | ❌ | ✅ (Schritt 7) |
| Spieler-Details | ✅ | ⚠️ Skelett | ✅ (Schritt 7) |
| Marktwert-Chart | ✅ | ❌ | ✅ (Schritt 7) |
| Performance-Chart | ✅ | ⚠️ Skelett | ✅ (Schritt 7) |
| Transfermarkt Kauf | ✅ | ⚠️ Basis | ✅ (Schritt 8) |
| Transfermarkt Verkauf | ✅ | ⚠️ Basis | ✅ (Schritt 8) |
| Angebote annehmen/ablehnen | ✅ | ❌ | ✅ (Schritt 8) |
| Beobachtungsliste | ✅ | ❌ | ✅ (Schritt 8) |
| Live-Punkte | ✅ | ❌ | ✅ (Schritt 9) |
| Bonus-Sammlung | ✅ | ❌ | ✅ (Schritt 9) |
| Manager-Profile | ✅ | ❌ | ✅ (Schritt 10) |
| Bundesliga-Tabelle | ✅ | ❌ | ✅ (Schritt 10) |
| Transfer-Empfehlungen | ✅ | ❌ | 🔮 Phase 2 |
| Verkaufs-Empfehlungen | ✅ | ❌ | 🔮 Phase 2 |
| Aufstellungs-Vergleich | ✅ | ❌ | 🔮 Phase 2 |
| Liga Insider | ✅ | ⚠️ Basis-Scraping | 🔮 Phase 2 |
| Aktivitäten-Feed | ✅ | ❌ | 🔮 Phase 2 |

---

## ⏱️ Geschätzte Aufwände

| Schritt | Beschreibung | Geschätzte Dauer |
|---------|-------------|-----------------|
| 1 | API: Liga & User Endpoints | 30 min |
| 2 | API: Spieler-Detail-Endpoints | 30 min |
| 3 | API: Manager & Transfermarkt | 45 min |
| 4 | API: Live, Scouting, Wettbewerb | 30 min |
| 5 | Riverpod-Provider erstellen | 45 min |
| 6 | UI: Dashboard & Rangliste | 60 min |
| 7 | UI: Kader & Spieler-Details | 90 min |
| 8 | UI: Transfermarkt erweitern | 90 min |
| 9 | UI: Live-Spieltag & Bonus | 60 min |
| 10 | UI: Manager-Profile & Tabelle | 60 min |
| **Gesamt** | | **~8-9 Stunden** |

---

## 🚀 So verwendest du die Prompts

1. **Schritt für Schritt abarbeiten** — Beginne mit Schritt 1 und gehe der Reihe nach vor
2. **Copilot Agent öffnen** — Kopiere den Prompt in den Copilot Agent Chat
3. **Ergebnis prüfen** — Nach jeder Schritt: `flutter analyze` und ggf. `flutter test`
4. **Commit machen** — Jeder Schritt sollte ein eigener Commit sein
5. **Weiter zum nächsten Schritt**

### Empfohlene Reihenfolge:
```
Schritte 1-4 (API-Client)  →  Schritt 5 (Provider)  →  Schritte 6-10 (UI)
```

Die API-Schritte (1-4) sind unabhängig voneinander und können auch parallel bearbeitet werden.
Die UI-Schritte (6-10) bauen auf den Providern (Schritt 5) auf.

---

## 🔮 Phase 2: Erweiterte Features (nach Feature-Parität)

Nachdem die Basis-Features implementiert sind, können folgende erweiterte Features aus dem Swift-Projekt übernommen werden:

1. **Transfer-Empfehlungen** — Algorithmische Kauf-Empfehlungen basierend auf Marktwert-Trends und Performance
2. **Verkaufs-Empfehlungen** — Wann Spieler verkauft werden sollten
3. **Aufstellungs-Vergleich** — Eigene Aufstellung mit der des Gegners vergleichen
4. **Liga Insider Integration** — Erweiterte Web-Scraping-Daten (Verletzungen, Aufstellungen)
5. **Aktivitäten-Feed** — Liga-Feed mit Kommentaren
6. **Achievements** — Erfolge und Badges
7. **Spieler-Match-Detail** — Detaillierte Ansicht der Events pro Spieltag

Diese Features sind komplexer und sollten als eigenständige Arbeitspakete geplant werden.
