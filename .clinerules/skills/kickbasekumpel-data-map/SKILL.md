---
name: kickbasekumpel-data-map
description: KickbaseKumpel Daten-Landkarte - wo sich welche Daten befinden: Kickbase-v4-Endpunkte → Client-Methoden → JSON-Kurzkeys → Modelle → Provider → UI, plus Firestore/Storage/Cloud-Functions. Verwenden IMMER wenn ein neues Feature Daten braucht, bei Parsing-Fragen, oder wenn unklar ist wo ein Datenpunkt/Feld zu finden ist.
---

# KickbaseKumpel – Daten-Landkarte

**Zweck:** Beantwortet „Wo befindet sich welche Daten?" in einem Blick – damit nicht
jede Session neu die API-Struktur erkunden muss. Die Kickbase-v4-API liefert
abgekürzte JSON-Keys, deren Schreibweise **je Endpunkt variiert** (`id`/`i`/`pi`,
`fn`+`ln`/`n`/`pn` …). Ratendes Parsen ist die häufigste Fehlerquelle.

## Die 5 Datenquellen

| Quelle | Wo | Persistenz |
|---|---|---|
| **Kickbase API v4** | `KickbaseAPIClient` (`lib/data/services/kickbase_api_client.dart`), Spezifikation: `docs/api-endpoints.json` | nein (live), nur User-Cache |
| **Eigene Firestore-Collections** | `firestore_repositories.dart` (users/leagues/players/transfers/recommendations) | ja |
| **Cloud Functions** | `functions/src/` – LigaInsider-Scraper + `kickbaseProxy` (Web-CORS) | `ligainsider_photos`, `system/*` |
| **Local Storage** | Secure Storage (`kickbase_token`), SharedPreferences (`kickbase_user_data`, `is_demo_mode`) | geräte-lokal |
| **Demo-Modus** | `demo_kickbase_api_client.dart` – statische Daten, gleiche Modelle | nein |

## Kanonischer Datenfluss

```
Kickbase-Endpoint → KickbaseAPIClient (Map<String,dynamic> oder Modell)
  → normalizePlayerJson / normalizeLeagueJson / normalizeMarketPlayerJson (lib/data/utils/parsing_utils.dart)
  → Model.fromJson (Freezed, lib/data/models/)
  → Data-Provider (lib/data/providers/) → UI-Provider/Screen (lib/presentation/)
```

## Lookup-Workflow (Reihenfolge!)

1. **Datenbegriff → Domain** (Spieler, Markt, Liga, Manager, Wettbewerb, Live, Budget).
2. **`reference/endpoint-map.md`** – Welcher Endpunkt liefert die Daten, welche
   Client-Methode, welcher Provider, welche UI. Ungenutzte Endpunkte sind dort
   ebenfalls gelistet (nicht neu erfinden – oft existiert schon eine Methode).
3. **`reference/kickbase-keys.md`** – Wie heißen die Felder im Roh-JSON (Kurzkeys,
   Varianten je Endpunkt) und wie mappt das Modell sie.
4. **`reference/storage-map.md`** – Wird etwas persistiert (Firestore/Storage), oder
   ist alles live von der API?

## Goldene Regeln

- **Niemals Roh-JSON in UI/Providern ratend parsen.** Erst `reference/kickbase-keys.md`
  prüfen, dann über Modell + `normalize*Json`-Helfer lesen. Neue Key-Varianten
  NUR in `parsing_utils.dart` ergänzen (eine Stelle!), nicht inline.
- **Listen-Container `it`**: Kickbase-Antworten verstecken Listen fast immer
  hinter `it` (Item). Models mappen `@JsonKey(name: 'it') → players/items`.
- **`Map<String, dynamic>`-Rückgaben sind Absicht**: Der Client gibt viele Endpunkte
  roh zurück – das Parsing liegt beim Konsumenten (Provider). Wer ein Feld braucht,
  sucht in `reference/kickbase-keys.md` statt ein neues Modell zu erfinden.
- **Feld-Bedeutungen nicht raten.** Unbekannte Kurzkeys sind in
  `reference/kickbase-keys.md` als „unklar" markiert – dann aus
  `docs/api-endpoints.json` (Swagger) oder einer Beispielantwort ableiten,
  KEINE Vermutung als Fakt dokumentieren.
- **`dt` = Datum**, aber drei Formate (ISO-String, Sekunden, Millisekunden;
  teils Tage seit 1970) – `_seasonStartDateFromJson` in `league_model.dart` und
  `_asDateTime` in Providern sind die autoritativen Parser.
- **Web-Requests** laufen über die Cloud Function `kickbaseProxy` (CORS), nicht
  direkt gegen api.kickbase.com.
- **Models sind Freezed** – Feld hinzufügen → `dart run build_runner build`.

## Pflege (Pflicht bei Änderungen)

| Änderung | Updaten |
|---|---|
| Neuer/geänderter Endpunkt oder Client-Methode | `reference/endpoint-map.md` |
| Neue JSON-Key-Variante oder Modellfeld | `reference/kickbase-keys.md` + `parsing_utils.dart` |
| Neue Collection/Storage-Key/Cloud-Function-Daten | `reference/storage-map.md` |
| Swagger-Update | `docs/api-endpoints.json` + `reference/endpoint-map.md` |

Siehe auch: kickbasekumpel-api (Client-Internas), kickbasekumpel-features
(Business-Logik), kickbasekumpel-codebase-map (Dateien), kickbasekumpel-backend
(Cloud Functions).
