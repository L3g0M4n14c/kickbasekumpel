# 💡 Ideen & Roadmap

> Sammlung der Feature-Ideen aus der Analyse vom 01.10.2026.
> Umgesetzt: Ligainsider-Status-Badge, Kader-Benchmark, Achievements im Budget
> (seit 07.10.2026 deterministisch abgeleitet für alle Manager).

---

## 🚀 Feature-Ideen aus noch ungenutzten API-Endpunkten

Die Kickbase-v4-API bietet mehr Endpunkte, als die App aktuell nutzt
(siehe `docs/api-endpoints.json`):

### 1. Liga-Einstellungen — `GET /leagues/{id}/settings` ⭐ (höchster Nutzen/Aufwand)
Die App rät aktuell: Steuersatz, Mindestgebot-Schritte und die Punkt-Schwelle
der 250er-Regel sind teils hartkodiert/berechnet. Mit den echten Liga-Settings:
- **Gebotsempfehlung präzisieren** (echte Transfer-Steuer + Mindestgebot einrechnen)
- den **Auto-Verkauf korrekt** konfigurieren (echte Punkteschwelle statt `ptspf`-Annahme)
- einen „Liga-Regeln"-Info-Bereich anzeigen

### 2. Aktivitäten-Feed als Social/Strategie-Feature — `GET /leagues/{id}/activitiesFeed`
Der Feed enthält laut Live-Verifikation (07.10.2026) nur die **eigenen**
Erfolge/Transfers und wird für die Achievements-Budget-Berechnung NICHT
genutzt (die läuft deterministisch, siehe `AchievementDerivationService`).
Weitere Möglichkeiten:
- **Mitbieter-Identifikation**: Wer kauft/wen verkauft gerade → Gegenreaktionen antizipieren
- Das ist genau die Lücke, die der `BidRecommendationService` in seinem
  Docstring selbst benennt („Konkurrenz auf dem Markt ist über die API nicht
  beobachtbar")
- Feed-UI mit Kommentaren (`/activitiesFeed/{id}/comments`)

### 3. Live-Spielereignisse — `GET /matches/{matchId}/details` + `/live/eventtypes`
Der Live-Screen zeigt bisher nur Gesamt-Punkte. Mit den Match-Details:
- pro Spieler **aufschlüsseln, wofür er Punkte bekommt** (Tor, Vorlage, Karte…)
- Push/Warnung, wenn ein eigener Spieler vom Feld fliegt oder trifft

### 4. Spieler-Suche über Wettbewerbe — `GET /competitions/{id}/players/search`
- **Globale Spielersuche** („Ist Spieler X eigentlich günstig?") mit MV-Chart
  vor dem Gebot
- Kombinierbar mit `competitions/{id}/players/{playerId}/marketvalue/{timeframe}`

### 5. Bundesliga-Kontext — `GET /competitions/{id}/table`, `/overview`, `/matchdays`
- **Spieltags-Countdown** auf dem Home-Screen (nächster Spieltag, Transferfenster-Ende)
- Bundesliga-Tabelle + aktuelle Form der Teams als Kontext für Spielerbewertungen
  („Gegner nächste Woche: Bayern" = eher Bank)

### 6. Daily Bonus — `GET /base/overview` + `GET /bonus/collect`
Dezentes Erinnerungs-Banner „Tagesbonus verfügbar" mit Tap-to-Collect.

### 7. Battles & Achievements als Anzeige — `GET /leagues/{id}/battles/{type}/users`, `/user/achievements`
Nice-to-have: 1v1-Duelle und Erfolge für die Liga-Übersichtsseite –
mehr Motivation als taktischer Nutzen.

---

## 💡 Feature-Ideen aus bereits vorhandenen Daten

### A. Aufstellungs-Optimierung mit Ligainsider
Kombiniere Ligainsider-Startelf-Wahrscheinlichkeiten mit Ø-Punkten:
- „💡 Tausche X gegen Y: +8,5 Punkte erwartet" im Aufstellungs-Screen
- Drag & Drop / Tap-to-Swap in der Aufstellung

### B. Verkaufsfenster-Timing
Aus der Transfer-Historie ableiten, **wann in der Liga die meisten Käufe
stattfinden** (z.B. direkt nach dem Spieltag) → Hinweis „Verkaufe jetzt,
Nachfrage ist hoch".

### C. Marktwert-Trend-Momentum als Marktsignal
- **„Aufstrebende Spieler"-Filter** im Markt (MV steigt + Punkte-Momentum der
  letzten 3 Spieltage) → Schnäppchen vor dem Preissprung finden
- Sparkline der MV-Entwicklung (30 Tage) in der Markt-Liste
  (Daten via `marketvalue/{timeframe}`, einmalig cachen)

### D. Konkurrenz-Budget in der Gebotsempfehlung
Die `BudgetCalculationService`-Ergebnisse kennen die Budgets aller Manager.
In der Bid-Empfehlung anzeigen: „Dein Gebot 4,2 M€ – 3 Manager haben mehr
Budget, max. Konkurrenz-Budget: 6,8 M€" → Abschätzung, wie realistisch der
Zuschlag ist.

---

## 🎨 UI-Verbesserungen

### Home-Screen
- **Matchday-Countdown-Card oben**: Spieltag, Kickoff, Transferfenster-Ende
- Mini-Widget „Deine Liga-Position ↑2" statt nur Welcome-Card
- **Liveticker-Zeile**, wenn Spiele laufen (Live-Screen fehlt in der Hauptnavigation)

### Markt-Screen
- Filter-Chips als horizontale Scroll-Zeile **über** der Liste statt versteckt
- Skeleton-Loading statt Spinners (wirkt flüssiger)
- Dark-Mode-Toggle prüfen/ergänzen (Settings-Screen vorhanden)

### Navigation
- Bottom-Nav zeigt während laufender Spiele automatisch ein Live-Banner

---

## 💰 Budget-Berechnung: offene Punkte

### 1. Punktgeld (Spieltagsprämie) — noch NICHT im Budget
Kickbase vergütet Spieltagspunkte mit Budget (Trading-Advisor-Ansatz:
`totalPoints × 1000 €` aus `managers/{userId}/performance`). Da ein Großteil
des Budgetwachstums daraus resultiert, ist das vermutlich die größte
verbleibende Ungenauigkeit der Budget-Berechnung.
→ Nächster Schritt: `managerPerformanceProvider` (Feld `tp`) × 1000 € in
`managerBudgetCalculationProvider` aufrechnen und gegen das echte eigene
Budget (`me/budget`) kalibrieren.

### 2. Achievements aller Manager — deterministische Ableitung (in Umsetzung)
Erfolge fremder Manager zeigt die API nirgends – sie werden im
`AchievementDerivationService` aus Spieltags-Ranking (`mdp`), Lineup-Punkten
und Transfer-Historie abgeleitet (14 von 16 Typen; Tormaschine fehlt bewusst).
Offen: **Kalibrierung** – `ac` ist eine Karriere-Summe (alle Saisons), die
Ableitung zählt nur die aktuelle. Der Check läuft daher als Schranken-
Vergleich (Log „🧭 Achievement-Kalibrierung"): Minimum = per `dt` in dieser
Saison nachweislich erreicht, Maximum = Karriere-`ac`. Fällt eine Ableitung
aus den Schranken, die Regel-Annahmen justieren
(`AchievementDerivationRules`: Gleichstand Spieltagssieger, kumulative Boni,
MVP-Regel „bester Lineup-Spieler", Händchen-Gewinn = VK − EK).

**Live-Katalog (Dump 07.10.2026) ist umgesetzt:** API-Namen sind englisch,
Serien mit `t`-Bereichen (1–5 Match day winner, 100er Match day points,
200er Season points, 300er Spieler-Punkte, 400er Team value, 500er Transfers,
700er Händchen = „… hand", 2001/2002 Champion/Runner-up). Der Katalog in
`AchievementBudgetService.knownAchievementRewards` enthält die `er`-Beträge
(* = Schätzung für ac = 0-Typen). Offene Punkte für die nächste Kalibrierung:
- **„Match day winner" (t=5) ist verdächtig:** ac = 0 trotz 137× „Match day
  points silver" – entweder Battle-Bezug (dann Ableitung streichen) oder du
  warst wirklich nie Spieltagssieger. Die Kalibrierung meldet „abgeleitet N,
  erwartet 0…0", falls die Punkt-Max-Regel nicht zum Typ passt.
- Schwellen für Series-Spitzen unbekannt (Match day winner bronze/silver/gold,
  Season points silver+, Team value gold+, Transfer King silver+, The Special
  One, The Galactics, F. Magath) – per Detail-Endpoint sichtbar, sobald ac > 0.
- „Champion" `er` unbestätigt (Schätzung 2 Mio. aus Help-Center).
- **Keine Dopplungen (Live-Beweis):** pro Ereignis zählt nur die höchste
  Stufe – `Match day points bronze` ac=1 neben `silver` ac=137 zeigt, dass
  Silber-Spieltage KEIN Bronze zahlen; analog `The right touch` ac=1 neben
  `Bronze hand` ac=102. Entstapelt in `AchievementDerivationRules`
  (Defaults `stackPointBonuses/stackPlayerBonuses/handThresholdsStack =
  false`; Team value ebenso nur höchste Stufe).

### 3. Anmeldebonus anderer Manager
Der Anmeldebonus wird aktuell für alle Manager gleich angenommen (Annahme:
tägliches Einloggen). Ein Manager, der Tage auslässt, hat real weniger Budget.
