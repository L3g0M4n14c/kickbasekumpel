# Kickbase-v4 JSON-Key-Dictionary

Kickbase-Antworten nutzen **abgekürzte Keys**, deren Schreibweise **je Endpunkt
variiert**. Autoritative Normalisierung: `lib/data/utils/parsing_utils.dart`
(`normalizePlayerJson`, `normalizeLeagueJson`, `normalizeMarketPlayerJson`).
Neue Varianten DORT ergänzen, nicht inline parsen.

## Container (gilt überall)

| Key | Bedeutung |
|---|---|
| `it` | Item-Listen-Container – praktisch jede Liste steckt hinter `it` |
| `cu` | Current User (League-Kontext) → `LeagueUser` |
| `ph` | Performance-History-Liste (Lineup wie Saison) |
| `srvl` | Server-League-Liste im LoginResponse → `List<League>` |
| `u` | User-Objekt (LoginResponse) bzw. Owner (Market) |

## Spieler – Key-Varianten je Endpunkt

| Bedeutung | Lang | Player-Detail | Squad | Manager-Squad | Market | Lineup |
|---|---|---|---|---|---|---|
| Spieler-ID | `id` | `id` | `id` | `pi` | `id`/`i` | `i` |
| Vorname | `firstName` | `fn` | `fn` | – (in `pn`) | `fn` | – |
| Nachname | `lastName` | `ln` | `n` | – (in `pn`) | `n` | – |
| Vollname | – | – | – | `pn` | – | `n` |
| Team-ID | `teamId` | `tid`/`team` | `tid` | ? | `tid` | `tid` |
| Teamname | `teamName` | `tn` | `tn` | ? | `tn` | – |
| Bild-URL | `profileBigUrl` | `i` (http…)/`pbu`/`pim`/`plpt` | `pbu`/`pim`/`plpt` | ? | `pbu`/`pim` | – |
| Position (1=TW,2=AB,3=MF,4=ST) | `position` | `pos` | `pos` | ? | `pos` | `pos` |
| Rückennummer | `number` | `shn` | – | – | – | – |
| Ø-Punkte | `averagePoints` | `ap` | `ap` | ? | `ap` | `ap` |
| Gesamtpunkte | `totalPoints` | `tp`/`p` | `tp`/`p` | ? | `p` | `st` (!) |
| Marktwert | `marketValue` | `mv` | `mv` | ? | `mv` | – |
| MW-Trend | `marketValueTrend` | `mvt` | `mvt` | ? | `mvt` | – |
| Status | `status` | `st` | `st` | ? | `st` | – |
| Besitzt-Selbst | `userOwnsPlayer` | `sl` | – | – | – | – |

Achtung: `st` ist je Kontext **Status** (Player/Market) oder **Punkte** (Lineup)!
`n` ist je Kontext **Vollname** (Lineup) oder **Nachname** (Squad/Market).
`i` ist je Kontext **ID** (Lineup/Market) oder **Bild-URL** (Player-Detail).

## Spieler – einzelne Keys

| Key | Bedeutung | Quelle |
|---|---|---|
| `mdst` | Spieltags-Status (0=fit, 1=verletzt, 2=gesperrt, …) | lineup_model, performance_model |
| `os` | Original-Status (Verletzungs-/Sperren-Text) | lineup_model |
| `lo` | Lineup-Reihenfolge (0 = Bank) | lineup_model |
| `lst` | Letzte Gesamtpunkte | lineup_model |
| `ht` | Spielt heute | lineup_model |
| `tfhmvt` | MW-Trend-Flag (unklar) | – |
| `prlo` | unklar (Player & MarketValue-Response) | – |
| `stl` | unklar (Player & Market) | – |
| `exs` | **Sekunden bis Ablauf** (relativ zu jetzt!) → `expiry` wird berechnet | Market |
| `prc` | Startpreis am Markt (`price` in anderen Kontexten) | Market |
| `ofc` | Anzahl Gebote (`offers`) | Market |
| `uoid` | User-Offer-ID = Verkäufer-ID → `seller` | Market |
| `sl` | self-listed → `userOwnsPlayer` | Player-Detail |

## League (`/leagues/selection`, `/overview`)

| Key | Bedeutung | Key | Bedeutung |
|---|---|---|---|
| `i` | Liga-ID (teils **int**, toString in `normalizeLeagueJson`) | `b` | Budget (cu) |
| `n` | Ligname (`name` in manchen Antworten) | `tv` | Teamwert (cu) |
| `cpi` | Competition-ID (Default „1") | `pl` | Platzierung (cu) |
| `cn` | Competition-Name (wahrscheinlich) | `adm` | Ist Admin |
| `md` | Aktueller Spieltag | `lim` | Liga-Bild |
| `dt` | **Ligastart-Datum** – ISO-String ODER Sekunden/Ms/Tage (Parser: `_seasonStartDateFromJson`) | `cpim` | Competition-Bild |
| `f` | Bild/Flag | `an`, `c`, `s`, `un`, `lpc`, `bs`, `vr`, `idf`, `gpm`, `rnkm` | **unklar** – nicht raten, aus Spec/Beispielantwort ableiten |

`cu` (LeagueUser) Short→Long (Mapping in `normalizeLeagueJson`):
`i`→id, `n`→name, `tn`→teamName, `b`→budget, `tv`→teamValue, `p`→points,
`pl`→placement, `w`→won, `d`→drawn, `l`→lost, `lp`→Lineup-Player-IDs
(teils **int-Liste**, wird zu Strings normalisiert), `se11`/`ttm`/`mpst` = unklar.

## User / Login

| Key | Bedeutung |
|---|---|
| `i`, `n`, `tn`, `em`, `b`, `tv`, `p`, `pl`, `f` | User (ID, Name, Teamname, E-Mail, Budget, Teamwert, Punkte, Platzierung, Bild) |
| `tkn` | **Auth-Token** (→ Secure Storage `kickbase_token`) |
| `u` | LoginUser (Lang-Keys: id, name, email, cover, proExpiry, sfb, efb, profile, uim, mfacp) |
| `userId` | Eigene User-ID im LoginResponse |
| `em`, `pass`, `loy` | LoginRequest |

## Performance (`/players/{id}/performance`)

`it` → Saisons (`sid` = Saison-ID „28" = aktuell!, `ti`, `n`, `ph`);
Match: `day`, `p` (Punkte), `mp` (Match-Performance?), `md`, `t1`/`t2` (Teams),
`t1g`/`t2g` (Tore), `pt` (Punkte-Text?), `k` (Key-Events?), `st`, `cur` (aktuell),
`mdst`, `ap`, `tp`, `asp` – einzelne Bedeutungen teils unklar.

## MarketValue (`/players/{id}/marketvalue/{timeframe}`)

`it` → Einträge (`dt` = **Datum** (Zahl!), `mv` = Marktwert), Response-Level `prlo`.

## Achievements

`ac` × `er` = Anzahl × Erfolgs-Budget pro Achievement-Typ (Budget-Anteil des
Managers; siehe `achievement_budget_service.dart`).

## Normalisierungs-Helfer (`lib/data/utils/parsing_utils.dart`)

| Funktion | Aufgabe |
|---|---|
| `normalizePlayerJson` | Alle Player-Key-Varianten → Lang-Keys (id, firstName, lastName, team*, profileBigUrl, position, number, averagePoints, totalPoints, marketValue, marketValueTrend, status, userOwnsPlayer) |
| `normalizeLeagueJson` | `i`/`n` robust, `cu` Short→Long, `lp` int→String |
| `normalizeMarketPlayerJson` | Market-Varianten + `exs`→`expiry` (relativ→absolut), `uoid`→`seller` |
| `normalizeForLigainsider` / `lookupLigainsiderPhoto` | Name→Firestore-Doc-ID für `ligainsider_photos` (MUSS zur TS `normalizePlayerName` passen) |

**Merke:** Modelle erwarten gemischte Welten – `Player`/`MarketPlayer` nutzen
Lang-Keys (erst normalisieren!), `League`/`LineupPlayer`/`Performance` nutzen die
Kurzkeys direkt per `@JsonKey`. Vor jedem Parsing-Bug zuerst hier nachschauen.
