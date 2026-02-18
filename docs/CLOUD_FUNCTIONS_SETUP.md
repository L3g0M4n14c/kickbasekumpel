# Cloud Functions Setup für Ligainsider Scraper

## Überblick

Der Ligainsider Scraper wurde von der Flutter App auf eine Google Cloud Function migriert. Das bietet diese Vorteile:

- ✅ **Zentrale Verwaltung**: Code läuft nicht in der App, sondern im Backend
- ✅ **Automatisches Scheduling**: Cloud Scheduler führt täglich aus (02:00 UTC)
- ✅ **Rate-Limiting sicher**: Eine Server-IP statt viele Client-IPs
- ✅ **Skalierbar**: Auch mit vielen Nutzern optimal
- ✅ **Wartbar**: Updates ohne App-Release

---

## Projektstruktur

```
functions/
├── src/
│   ├── index.ts                    # Cloud Functions Einstiegspunkt
│   ├── ligainsider-scraper.ts      # Scraper Logik (TypeScript)
│   ├── types.ts                    # TypeScript Typen
│   ├── logger.ts                   # Logging Utility
├── package.json                    # Node.js Dependencies
├── tsconfig.json                   # TypeScript Konfiguration
├── .gitignore                      # Git Ignore
└── lib/                            # (Auto-generated) Compiled JS
```

---

## Installation & Deployment

### 1. Voraussetzungen

```bash
# Node.js 20+ installieren
node --version  # v20.0.0 oder höher

# Firebase CLI installieren
npm install -g firebase-tools@latest

# Google Cloud SDK installieren (für gcloud commands)
curl https://sdk.cloud.google.com | bash

# Bei Firebase anmelden
firebase login
gcloud auth login
```

### 2. Deployment (Bash Script)

```bash
# Mache Deploy-Script ausführbar
chmod +x deploy-functions.sh

# Führe Deployment aus
./deploy-functions.sh
```

Das Script macht folgendes:
1. ✅ Kompiliert TypeScript zu JavaScript
2. ✅ Deployt Cloud Functions
3. ✅ Erstellt Cloud Scheduler Job (täglich 02:00 UTC)

### 3. Manueller Deployment (falls Script nicht funktioniert)

```bash
# Gehe zu functions Verzeichnis
cd functions

# Installiere Dependencies
npm install

# Kompiliere TypeScript
npm run build

# Deploye Cloud Functions
firebase deploy --only functions --project=kickbasekumpel

# Erstelle Cloud Scheduler Job
gcloud scheduler jobs create http update-ligainsider-photos-daily \
    --location=europe-west1 \
    --schedule="0 2 * * *" \
    --uri="https://europe-west1-kickbasekumpel.cloudfunctions.net/updateLigainsiderPhotos" \
    --http-method=POST \
    --headers="X-CloudScheduler=true" \
    --project=kickbasekumpel
```

---

## Cloud Functions API

### 1. `updateLigainsiderPhotos` (HTTP POST)

**Triggers:**
- Cloud Scheduler täglich (02:00 UTC)
- Manuelle Anfrage mit Authentication

**Header (für Cloud Scheduler):**
```
X-CloudScheduler: true
```

**Header (für manuelle Requests):**
```
Authorization: Bearer <Firebase ID Token>
```

**Response:**
```json
{
  "success": true,
  "message": "Successfully updated 45 player photos",
  "stats": {
    "totalTeamsScraped": 18,
    "totalPhotosFound": 450,
    "totalPlayersUpdated": 45,
    "totalPlayersProcessed": 600
  },
  "errors": []
}
```

**Firestore Struktur (gespeichert in `system/ligainsider-scraper`):**
```dart
{
  lastRun: Timestamp,
  lastRunDate: "2026-02-17T02:00:00Z",
  totalTeamsScraped: 18,
  totalPhotosFound: 450,
  totalPlayersUpdated: 45,
  totalPlayersProcessed: 600,
  status: "success",
  errors: []
}
```

### 2. `getLigainsiderScraperStatus` (HTTP GET)

**Returns:** Metadaten vom letzten erfolgreichen Lauf

```bash
curl https://europe-west1-kickbasekumpel.cloudfunctions.net/getLigainsiderScraperStatus
```

---

## Verwendung in der Flutter App

### 1. Manueller Trigger (Optional)

Nutzer können in der UI einen "Fotos aktualisieren" Button haben:

```dart
// Im Repository
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
      return Failure('Failed to trigger photo update');
    }
  } catch (e) {
    return Failure('Error: $e', exception: e as Exception?);
  }
}

// Im Provider
final triggerPhotoUpdateProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(playerRepositoryProvider);
  final result = await repository.triggerLigainsiderPhotoUpdate();
  
  if (result is Failure) {
    throw Exception(result.message);
  }
});

// Im Widget
class PhotoUpdateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        await ref.read(triggerPhotoUpdateProvider.future);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotos werden aktualisiert...')),
        );
      },
      child: const Icon(Icons.refresh),
    );
  }
}
```

### 2. Sichere den `updatePlayerPhotosFromLigainsider` Provider

Der ursprüngliche Provider ruft nur noch die Cloud Function auf (statt lokal zu scrapen):

```dart
// VERALTET - Bitte nicht mehr verwenden
final updatePlayerPhotosFromLigainsiderProvider = FutureProvider<void>((ref) async {
  final result = await ref.watch(playerRepositoryProvider)
      .triggerLigainsiderPhotoUpdate();
  
  if (result is Failure) {
    throw Exception(result.message);
  }
});
```

### 3. Status anzeigen

```dart
final scraperStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final response = await http.get(
    Uri.parse('https://europe-west1-kickbasekumpel.cloudfunctions.net/getLigainsiderScraperStatus'),
  );
  
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  throw Exception('Failed to fetch scraper status');
});

// Im Widget
class ScraperStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(scraperStatusProvider);
    
    return status.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
      data: (data) => Column(
        children: [
          Text('Letzter Update: ${data['lastRunDate']}'),
          Text('Spieler aktualisiert: ${data['totalPlayersUpdated']}'),
        ],
      ),
    );
  }
}
```

---

## Debugging & Logs

### Cloud Logs anschauen

```bash
# Alle Logs der Cloud Function
firebase functions:log --project=kickbasekumpel

# Mit zusätzlichem Filter (z.B. nur Fehler)
gcloud functions logs read updateLigainsiderPhotos \
    --region europe-west1 \
    --project kickbasekumpel \
    --limit 50
```

### Cloud Scheduler Job testen

```bash
# Führe den Job manuell aus (ohne warten auf zeitplan)
gcloud scheduler jobs run update-ligainsider-photos-daily \
    --location=europe-west1 \
    --project=kickbasekumpel

# Beobachte die Logs
firebase functions:log --project=kickbasekumpel
```

### Lokales Testen (Emulator)

```bash
# Starte Firebase Emulator
firebase emulators:start --only functions

# In einem anderen Terminal: Function testen
curl -X POST http://localhost:5001/kickbasekumpel/europe-west1/updateLigainsiderPhotos \
    -H "X-CloudScheduler: true"
```

---

## Kosten & Performance

### Geschätzter Kostenaufwand pro Monat

| Service | Nutzung | Geschätzte Kosten |
| --- | --- | --- |
| Cloud Functions | 1 Lauf/Tag * 30 Tage * 9 Min = 270 Min | ~$0.80 |
| Cloud Scheduler | 30 Jobs/Monat | ~$0.10 |
| **Total** | | **~$1.00** |

*Hinweis: Erste 2 Millionen Requests/Monat sind kostenlos*

### Performance-Charakteristiken

- **Duration**: ~5-9 Minuten (abhängig von Ligainsider Performance)
- **Memory**: 512 MB (ausreichend)
- **Timeout**: 540 Sekunden (9 Minuten)
- **Parallel Requests**: Sequential (1 Team nach dem anderen)

---

## Troubleshooting

### ❌ "Cloud Function nicht erreichbar"

```bash
# Prüfe ob Function deployed ist
firebase list functions --project=kickbasekumpel

# Prüfe IAM Permissions
gcloud projects get-iam-policy kickbasekumpel
```

### ❌ "Scheduler Job antwortet nicht"

```bash
# Prüfe Job-Details
gcloud scheduler jobs describe update-ligainsider-photos-daily \
    --location=europe-west1 \
    --project=kickbasekumpel

# Prüfe Execution Logs
gcloud scheduler jobs describe update-ligainsider-photos-daily \
    --location=europe-west1 \
    --project=kickbasekumpel \
    --format=json | jq .lastExecution
```

### ❌ "Keine Fotos werden aktualisiert"

1. **Prüfe HTML-Struktur**: Ligainsider könnte seine Seite geändert haben
   ```bash
   # Kopiere aktuellen HTML
   curl -s https://www.ligainsider.de | head -200
   # Prüfe auf "BEGINNNING TEAM MENU" Kommentar
   ```

2. **Aktualisiere Scraper**: Passe `functions/src/ligainsider-scraper.ts` an

3. **Redeploy**:
   ```bash
   npm run build && firebase deploy --only functions
   ```

---

## Zukünftige Verbesserungen

- [ ] Paralleles Fetching von mehreren Teams (beschleunigt Scraping)
- [ ] Caching für Team-Links (falls sich URL nie ändert)
- [ ] Webhook für manuelle Trigger aus Admin-Panel
- [ ] Foto-Deduplizierung (verhindert doppelte Updates)
- [ ] Email-Notification bei Fehlern

---

**Siehe auch:**
- [ARCHITECTURE.md](../ARCHITECTURE.md) - Gesamte Architektur Übersicht
- [LIGAINSIDER_SCRAPER.md](../docs/LIGAINSIDER_SCRAPER.md) - Original Scraper Dokumentation
