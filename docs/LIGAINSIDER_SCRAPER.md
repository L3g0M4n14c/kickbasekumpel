<!-- markdownlint-disable MD033 -->
# Ligainsider Scraper Service

















































































(Erste 2 Millionen Requests/Monat kostenlos)- **Total**: ~$1.00/Monat- Cloud Scheduler: ~$0.10/Monat (30 Runs)- Cloud Functions: ~$0.80/Monat (1 Lauf/Tag)## Kosten**Runtime**: Node.js 20 + TypeScript**Region**: `europe-west1`  **Projekt**: `kickbasekumpel`  - Cloud Logging (Monitoring)- Cloud Scheduler (Automation)- Firestore Database (Storage)- Cloud Functions (Compute)Die Function verwendet folgende Google Cloud Services:## Environment```    -H "X-CloudScheduler: true"curl -X POST http://localhost:5001/kickbasekumpel/europe-west1/updateLigainsiderPhotos \# In neuem Terminal: Function aufrufenfirebase emulators:start --only functions# Lokal mit Emulator testen```bash## EntwicklungSiehe [CLOUD_FUNCTIONS_SETUP.md](../docs/CLOUD_FUNCTIONS_SETUP.md) für vollständige Anleitung.## Setup & Deployment- **Funktionalität**: Gibt Status und Metadaten vom letzten Scrapingf-Lauf- **Trigger**: HTTP GET### `getLigainsiderScraperStatus`- **Runtime**: ~5-9 Minuten- **Funktionalität**: Scraped Ligainsider.de, updated Player-Fotos in Firestore- **Trigger**: Cloud Scheduler (täglich 02:00 UTC) oder HTTP POST### `updateLigainsiderPhotos`## Cloud Functions```firebase functions:log# Logs anschauenfirebase deploy --only functions# Cloud Functions deployennpm run build# TypeScript kompilierennpm install# Dependencies installieren```bash## Schnelleinstieg```└── logger.ts                   # Logging Utility├── types.ts                    # Typen und Interfaces├── ligainsider-scraper.ts      # Scraper Service (TypeScript)├── index.ts                    # Cloud Functions Haupteintragsrc/```## Struktur- 📝 **Comprehensive Logging**: Mit Pino Logger- 📊 **Firestore Integration**: Direkte Datenspeicherung im Backend- ⏱️ **Cloud Scheduler**: Tägliche automatische Ausführung- 🌐 **Ligainsider Scraper**: Automatisches Scraping von Spielerfotos## FeaturesGoogle Cloud Functions für die KickbaseKumpel Flutter App.
> **Automatische Spielerfoto-Beschaffung von Ligainsider.de**

> ⚠️ **Migration in Progress**: Der Service wird von der Flutter App in eine Google Cloud Function migriert. Siehe [CLOUD_FUNCTIONS_SETUP.md](./CLOUD_FUNCTIONS_SETUP.md) für die neue Architektur.

---

## Überblick

Der `LigainsiderScraperService` ist ein spezialisierter Service, der automatisch Team-Rosters und Spielerfotos von [ligainsider.de](https://www.ligainsider.de) abfrage und diese mit den Spielerdaten in Kickbase Kumpel synchronisiert.

### Hauptmerkmale

- 🌐 **HTML-Parsing**: Extrahiert Informationen direkt von Ligainsider.de
- 🎯 **Intelligente Namensabstimmung**: Nutzt Unicode-Normalisierung für zuverlässiges Matching
- 🔄 **Batch-Verarbeitung**: Aktualisiert mehrere Spieler gleichzeitig
- ⚠️ **Robust**: Fehlerbehandlung bei jedes Schritt des Prozesses
- 📝 **Vollständig dokumentiert**: Mit ausführlichen Logs für Debugging

---

## Voraussichtliche Aufstellungen — Lade-Strategie (App-Start-Preload)

Die Ligainsider-Rollen (Stammspieler / 1. Option / 2. Option / Bank) kommen aus
`lib/data/services/ligainsider_service.dart`.

**Datenquelle (wichtig):** Die Spieltags-Übersicht
(`https://www.ligainsider.de/bundesliga/spieltage/`) enthält **keine**
Spieler-Links, sondern den Spielplan mit zwei Team-Links pro Spiel
(`/bundesliga/team/{slug}/{id}/saison-{jahr}/{spiel-id}`). Dort steht die
„VORAUSSICHTLICHE AUFSTELLUNG“ (11 Slots pro Team, je Slot der Starter und –
falls vorhanden – die Alternative) inklusive Spielerfotos. Ein Parsen der
Übersicht selbst lieferte nur News-Links → wenige Pseudo-Spieler im Cache →
jeder echte Spieler galt als „nicht in der Startelf“ („Fehlt“).

**Problem vorher:** Geladen wurde erst beim Öffnen der Aufstellung,
sequenziell und mit dem falschen Ziel.

**Jetzt:**

| Ebene | Verhalten |
|---|---|
| Statusquelle | `ligainsiderLineupIndexProvider` – primär die Cloud Function `getLigainsiderLineups` (Firestore-Cache 2 h, scraped serverseitig, funktioniert auch im Web), nur bei unvollständigen Daten der lokale Scrape. |
| App-Start | `KickbaseKumpelApp` (`lib/main.dart`) liest `ligainsiderPreloadProvider` direkt beim Start → Index wird im Hintergrund gebaut, der Start blockiert nicht; Badges bauen sich neu, sobald die Daten da sind. |
| Namens-Matching | `LigainsiderLineupIndex` matcht über die Slugs (voller Name) statt nur über Anzeigenamen: kompletter Name → Nachname (letztes Segment) → Kurznamen-Fuzzy für Alternativen. Widgets übergeben `lastName: player.name` (voller Name) – das wird korrekt aufgelöst (z. B. „Min-jae Kim“). |
| Lokaler Scrape (Fallback) | `ligainsiderServiceFutureProvider` lädt cache-first (`ensureLoaded()`): 1 Übersichts-Request + 18 Team-Seiten parallel (max. 6, ~4–5 s). Übersicht 20 s Timeout, Team-Seiten 15 s. Spielerfotos kommen direkt mit der Aufstellungsseite. |
| Cache (persistent) | `ligainsider_cache` + `…_timestamp` (Spieler), `ligainsider_cache_s11` + `ligainsider_cache_alternatives` (Rollen). Frischer Cache (< 10 min) → **kein** Netzwerk-Request. Älterer Cache (< 1 h) → sofort nutzbare Daten + Hintergrund-Refresh. |
| Datenlücke ≠ Ausfall | `hasCoverage` (≥ 170 von 198 S11-Spielern). Darunter liefert der Index `null` statt `out`: Badge zeigt nichts, die Aufstellungs-Empfehlung bleibt neutral. |

Manuelles Neuladen (überspringt den Frische-Check): `ligainsiderReloadProvider`
(z. B. Refresh-Button im Live-Screen).

---

## Neue Architektur (Cloud Functions Backend)

```
┌─────────────────────┐
│   Flutter App       │
│  (KickbaseKumpel)   │
└────────┬────────────┘
         │ (HTTP POST)
         │ triggerPhotoUpdate()
         ↓
   ┌──────────────────────┐
   │   Cloud Function     │
   │  updateLigainsider   │
   │     Photos           │
   └────────┬─────────────┘
         ↓
   ┌──────────────────────┐
   │  Ligainsider.de      │
   │  (HTML Scraping)     │
   └────────┬─────────────┘
         ↓
   ┌──────────────────────┐
   │   Firestore DB       │
   │  (Player Profiles)   │
   └──────────────────────┘

┌──────────────────────────────┐
│   Cloud Scheduler            │
│ (Täglich 02:00 UTC)          │
│ Trigger: HTTP POST →         │
│          Cloud Function      │
└──────────────────────────────┘
```

**Vorteile dieser Architektur:**
- ✅ Server-seitige Verarbeitung (nicht Client)
- ✅ Automatisches Scheduling ohne App-Beteiligung
- ✅ Sichere Rate-Limiting (1 IP statt 1000e IPs)
- ✅ Einfaches Debugging und Logging zentral
- ✅ Wartbar ohne App-Updates

---

## Architektur (Legacy - für Referenz)

### 1. Service Layer (`LigainsiderScraperService`) - Dart

#### Hauptmethoden

```dart
// 1. Team-Links extrahieren
Future<Map<String, String>> fetchTeamKaderLinks()

// 2. Spielerfotos für Team abrufen
Future<Map<String, String>> fetchPlayerPhotosForTeam(String kaderUrl)

// 3. Namen normalisieren (für Matching)
String normalizePlayerName(String name)
```

### 2. Data Access (`PlayerRepository`)

Integriert den Scraper mit der Firestore-Datenbank:

```dart
// Legacy Methode - nur noch für Referenz
Future<Result<void>> updatePlayerPhotosFromLigainsider(
  LigainsiderScraperService scraperService,
)

// Neue Methode - triggert Cloud Function
Future<Result<void>> triggerLigainsiderPhotoUpdate()
```

### 3. State Management (`ligainsider_photo_provider.dart`)

Triggert die Cloud Function:

```dart
// FutureProvider für Cloud Function Trigger
final triggerPhotoUpdateProvider = FutureProvider<void>((ref) async {
  final result = await ref.watch(playerRepositoryProvider)
      .triggerLigainsiderPhotoUpdate();
  
  if (result is Failure) {
    throw Exception(result.message);
  }
});
```

---

## HTML-Struktur auf Ligainsider.de

### Homepage: Team-Links extrahieren

```html
<!-- BEGINNNING TEAM MENU -->
<div class="team-menu">
  <ul>
    <li>
      <a href="/fc-bayern-muenchen/1/kader/">FC Bayern München</a>
    </li>
    <li>
      <a href="/borussia-dortmund/2/kader/">Borussia Dortmund</a>
    </li>
    <!-- ... -->
  </ul>
</div>
<!-- END TEAM MENU -->
```

**Extrahiertes Format**: `Map<teamName, kaderUrl>`

```dart
{
  'FC Bayern München': 'https://www.ligainsider.de/fc-bayern-muenchen/1/kader/',
  'Borussia Dortmund': 'https://www.ligainsider.de/borussia-dortmund/2/kader/',
  // ...
}
```

### Team Kader-Seite: Spielerfotos extrahieren

```html
<div class="player_img">
  <div class="img-circle">
    <img 
      src="https://cdn.ligainsider.de/player/.../manuel-neuer.jpg"
      alt="Manuel Neuer"
      class="player-image"
    />
  </div>
</div>
```

**Selektoren**:
- `div[class*="player_img"]` - Player Container (mit Variant-Support wie "player_img_variant")
- `div[class*="img-circle"]` - Bild-Container (mit Variant-Support wie "img-circle-v2")
- `img` - Bild-Element mit `src` (URL) und `alt` (Name)

**Extrahiertes Format**: `Map<normalizedPlayerName, photoUrl>`

```dart
{
  'manuel neuer': 'https://cdn.ligainsider.de/player/.../manuel-neuer.jpg',
  'thomas mueller': 'https://cdn.ligainsider.de/player/.../thomas-mueller.jpg',
  // ...
}
```

---

## Unicode-Normalisierung

Der Service verwendet **Character Decomposition** um internationale Spielernamen korrekt zu vergleichen.

### Unterstützte Diakritika

| Original | Normalisiert | Beispiele |
|----------|-----|----------|
| `á à ä â` | `a` | José → jose, Müller → muller |
| `é è ë ê` | `e` | Manuel → manuel |
| `í ì ï î` | `i` | Ignacio → ignacio |
| `ó ò ö ô` | `o` | Sørensen → sorensen |
| `ú ù ü û` | `u` | Müller → muller, Süle → sule |
| `ñ` | `n` | Peña → pena |
| `ç` | `c` | François → francois |

### Normalisierungs-Schritte

1. **Diakritika entfernen**: `José Peña` → `Jose Pena`
2. **Whitespace normalisieren**: Mehrfache Leerzeichen → einzeln
3. **Zu Lowercase**: `Jose Pena` → `jose pena`

```dart
final name = 'Manuel Müller';
final normalized = scraperService.normalizePlayerName(name);
// Result: 'manuel muller'
```

---

## Backend — TypeScript / Cloud Functions (neu: Implementation & Verhalten)

Kurz: der Scraper läuft jetzt als Node.js/TypeScript Cloud Function. Wichtige Ergänzungen, die gerade eingebaut wurden:

- **Neue Cloud Functions**
  - `updateLigainsiderPhotos` — HTTP POST (Scheduler + manuell, siehe Auth)
  - `getLigainsiderScraperStatus` — HTTP GET (Status & Metadaten)
  - `initializeLigainsiderScraperMetadata` — Firestore `players/{playerId}` onCreate (automatische Initialisierung)

- **Authentifizierung & Sicherheit**
  - Akzeptierte Trigger: `X-CloudScheduler: true` **oder** `Authorization: Bearer <Firebase ID Token>`.
  - Manuelle Requests werden serverseitig mit `admin.auth().verifyIdToken()` validiert — fehlender/ungültiger Token → **401** (`Unauthorized` / `Invalid token`).

- **Firestore / Player‑Updates**
  - `updateLigainsiderPhotos` **schreibt nur**, wenn `player.profileBigUrl` leer ist — bestehende Player‑Bilder werden **nicht** überschrieben.
  - Bei erfolgreichem Update wird zusätzlich `ligainsiderPhotoUpdatedAt` (ISO‑String) am Player‑Dokument gesetzt.
  - Updates werden als **Firestore batch** ausgeführt (Commit nur wenn `totalPlayersUpdated > 0`). Achtung: 500 writes pro Batch.

- **Initialisierung (kein manuelles Setup mehr nötig)**
  - `initializeLigainsiderScraperMetadata` legt beim ersten `players/{playerId}` die Dokumente unter `system/ligainsider-scraper` an (status: `ready`, counters = 0, errors = []).

- **Robustheit & Netzwerk**
  - HTTP‑Requests verwenden einen **Retry‑Wrapper** mit Exponential‑Backoff (MAX_RETRIES = 3, initial delay = 2000ms).
  - Cloud Function Limit: `timeoutSeconds: 540` (9 min), `memory: 512MB`.

- **Normalization / Matching (Implementation‑Detail)**
  - Node‑Scraper nutzt eine `DECOMPOSITION_MAP` + Entfernen von Unicode Combining Marks, dann `toLowerCase()` und Trim — dadurch sehr robustes Matching internationaler Namen.

- **ScraperResult & Metadaten**
  - `ScraperResult` (TypeScript) = { teamPhotos: Map<normalizedName, photoUrl>, totalTeams, totalPhotos, errors }
  - `system/ligainsider-scraper` enthält: `lastRun`, `lastRunDate`, `totalTeamsScraped`, `totalPhotosFound`, `totalPlayersUpdated`, `totalPlayersProcessed`, `status`, `errors`.

- **Fehler-/Edge‑Cases**
  - Wenn keine Fotos gefunden werden → Function antwortet mit `success: false` und `message: 'No photos scraped'`.
  - Wenn keine Spieler in Firestore existieren → `success: false`, `message: 'No players found in Firestore'`.

---

## Verwendung in der Flutter App

### ⚠️ Migration zur Cloud Function

Die Scraper-Logik läuft jetzt im Backend. Die Flutter App triggert nur noch die Cloud Function:

```dart
// Neue Methode im Repository
Future<Result<void>> triggerLigainsiderPhotoUpdate() async {
  try {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (idToken == null) {
      return Failure('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('https://europe-west1-kickbasekumpel.cloudfunctions.net/updateLigainsiderPhotos'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Success(null);
    } else {
      return Failure('Failed to trigger photo update: ${response.statusCode}');
    }
  } catch (e) {
    return Failure('Error: $e', exception: e as Exception?);
  }
}
```

### 1. UI Trigger für Photo-Updates

```dart
class PhotoUpdateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        try {
          final result = await ref.read(playerRepositoryProvider)
              .triggerLigainsiderPhotoUpdate();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.when(
                success: (_) => 'Foto-Update gestartet...',
                failure: (msg) => 'Fehler: $msg',
              )),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: $e')),
          );
        }
      },
      child: const Icon(Icons.refresh),
    );
  }
}
```

### 2. Status anzeigen

Die Cloud Function speichert Metadaten in Firestore. Diese können abgerufen werden:

```dart
// Provider für Scraper-Status
final scraperStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final doc = await FirebaseFirestore.instance
      .collection('system')
      .doc('ligainsider-scraper')
      .get();
  
  if (!doc.exists) {
    throw Exception('Scraper status not found');
  }
  
  return doc.data()!;
});

// In Widget
class ScraperStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(scraperStatusProvider);
    
    return status.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
      data: (data) => Column(
        children: [
          Text('Letzter Update: ${data['lastRunDate'] ?? 'nie'}'),
          Text('Status: ${data['status'] ?? 'unknown'}'),
          Text('Spieler aktualisiert: ${data['totalPlayersUpdated'] ?? 0}'),
        ],
      ),
    );
  }
}
```

### 3. Automatische Updates (Cloud Scheduler)

Cloud Scheduler führt die Cloud Function täglich um 02:00 UTC aus. Nutzer müssen nichts tun.

**Für Details zur Einrichtung → [CLOUD_FUNCTIONS_SETUP.md](./CLOUD_FUNCTIONS_SETUP.md)**

---

## Datenfluss

```
┌─────────────────────────────────────────────────────────┐
│   updatePlayerPhotosFromLigainsiderProvider             │
│   (Riverpod FutureProvider)                             │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│  PlayerRepository.updatePlayerPhotosFromLigainsider    │
│  (Koordiniert Service + Firestore Updates)             │
└──────────┬───────────────────────────────┬──────────────┘
           │                               │
           ▼                               ▼
┌──────────────────────┐         ┌─────────────────────┐
│ LigainsiderScraperS. │         │  Firestore Cache    │
│                      │         │                     │
│ 1. fetchTeamLinks()  │         │  Batch Update       │
│ 2. fetchPhotoPerTeam │         │  profileBigUrl      │
│ 3. normalizeNames    │         │                     │
└──────────┬───────────┘         └─────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────┐
│   Ligainsider.de                                        │
│   - Homepage (TEAM MENU)                               │
│   - Team Kader Pages                                   │
└─────────────────────────────────────────────────────────┘
```

---

## Error Handling

Der Service implementiert robustes Error Handling mit Logger-Integration:

### Fehlerszenarien

| Szenario | Handling | Log-Level |
|----------|----------|-----------|
| HTTP 404 bei Homepage | Rückgabe leere Map | ⚠️ WARN |
| Kein TEAM MENU gefunden | Rückgabe leere Map | ⚠️ WARN |
| Fehlende `img` Tags | Skip Player, continue | ℹ️ INFO |
| Leere `src` oder `alt` | Skip Player, continue | ℹ️ INFO |
| Netzwerk-Fehler | Exception mit Details | ❌ ERROR |

### Beispiel: Exception Handling

```dart
try {
  final teamLinks = await scraperService.fetchTeamKaderLinks();
} catch (e, stackTrace) {
  logger.e('Error fetching team links', error: e, stackTrace: stackTrace);
  // Graceful Degradation: Rückgabe leere Map
  return {};
}
```

---

## Testing

### Unit Tests

Tests für Name-Normalisierung mit realen Spielernamen:

```dart
group('LigainsiderScraperService', () {
  test('normalizePlayerName handles real player names', () {
    expect(
      scraperService.normalizePlayerName('José María Peña'),
      'jose maria pena',
    );
    expect(
      scraperService.normalizePlayerName('Müller'),
      'muller',
    );
  });
});
```

**Test Count**: 15 assertions across name normalization, HTML parsing edge cases

### Integration Tests

Da die Service HTTP-Anfragen macht, sollten Integration Tests mit echtem Netzwerk nur bei Bedarf laufen:

```dart
// Mock werden unterstützt via HttpClientWrapper
final mockHttpClient = MockHttpClientWrapper();
final service = LigainsiderScraperService(httpClient: mockHttpClient);
```

---

## Performance

### Ladezeiten (Benchmark)

- **Homepage-Parsing**: ~500ms (TEAM MENU extraction)
- **Pro Team-Kader**: ~300-800ms (abhängig von Spieleranzahl)
- **Pro Spieler Name Match**: <1ms (normalization + lookup)
- **Firestore Batch Update**: ~100-200ms (pro 50 Spieler)

### Optimierungen

- ✅ Lazy Loading pro Team (nicht alle auf einmal)
- ✅ CSS Selektoren optimiert für Performance
- ✅ Name-Normalisierung gecacht in Map-Lookup
- ✅ Early Returns bei Fehler-Szenarien

### Skalierbarkeit

**Für volle Bundesliga (~18 Teams × ~25 Spieler ≈ 450 Spieler)**:
- Geschätz gesamt Time: 30-60 Sekunden
- Empfehlung: Einmalig bei App-Start im Background laufen lassen

---

## Zusammenfassung

| Aspekt | Details |
|--------|---------|
| **Service** | `LigainsiderScraperService` |
| **Location** | `lib/data/services/ligainsider_scraper_service.dart` |
| **Provider** | `lib/data/providers/ligainsider_photo_provider.dart` |
| **Repository Method** | `PlayerRepository.updatePlayerPhotosFromLigainsider()` |
| **Datenquelle** | https://www.ligainsider.de |
| **Zielfeld** | `Player.profileBigUrl` |
| **Matching-Strategie** | Unicode-normalisierte Namen |
| **Tests** | 15 unit tests, all passing ✅ |
| **Error Handling** | Comprehensive mit Logger |
| **Performance** | ~30-60s für 450 Spieler |
| **Dependencies** | `html: ^0.15.6`, `characters: ^1.3.1`, `logger: ^2.4.0` |

---

## Nächste Schritte

- [ ] Integration in App Initialization Flow
- [ ] Fallback-Strategien wenn Ligainsider offline ist
- [ ] Caching von Photo-URLs im lokalen Storage
- [ ] Periodic Updates (z.B. täglich)
- [ ] UI Feedback während Update läuft
