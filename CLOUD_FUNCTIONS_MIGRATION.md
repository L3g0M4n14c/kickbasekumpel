# Migration: Ligainsider Scraper auf Google Cloud Functions

## Status: ✅ Implementiert

Die Ligainsider Scraper Logik wurde erfolgreich von der Flutter App auf Google Cloud Functions migriert.

---

## Was wurde gemacht?

### 1. ✅ Cloud Functions Setup
- **Verzeichnis**: `functions/`
- **Runtime**: Node.js 20 + TypeScript
- **Build Tool**: TypeScript Compiler
- **Package Manager**: npm

### 2. ✅ Scraper Service (TypeScript)
- **Datei**: `functions/src/ligainsider-scraper.ts`
- **Logik**: Identisch mit Dart-Version
  - HTML Parsing mit Cheerio
  - Unicode-Normalisierung (Diakritika-Handling)
  - Team-Link Extraktion
  - Spielerfoto-Matching
- **Error Handling**: Retry-Logik mit Exponential Backoff

### 3. ✅ Cloud Functions
- **`updateLigainsiderPhotos`**: Scraper Orchestration
  - Scraped Ligainsider.de
  - Updated Firestore mit Foto-URLs
  - Speichert Metadaten (Timestamp, Fehler, etc.)
  - Authentifizierung (Cloud Scheduler + Firebase IdToken)

- **`getLigainsiderScraperStatus`**: Status-API
  - Gibt Infos vom letzten erfolgreichen Lauf
  - Für UI-Anzeige nutzbar

- **`initializeLigainsiderScraperMetadata`**: Setup-Trigger
  - Erstellt initiales Metadaten-Dokument
  - Triggered beim ersten Player in Firestore

### 4. ✅ Dokumentation
- **CLOUD_FUNCTIONS_SETUP.md**: Vollständige Setup-Anleitung
- **LIGAINSIDER_SCRAPER.md**: Updated für neue Architektur
- **functions/README.md**: Functions-spezifische Dokumentation

### 5. ✅ Deployment-Tools
- **deploy-functions.sh**: Automated Deployment Script
- **firebase.json**: Updated mit Functions Config
- **.env.example**: Umgebungsvariablen Vorlage

---

## Architektur (Neu)

```
┌────────────────────┐
│   Flutter App      │
│  (KickbaseKumpel)  │
└────────┬───────────┘
         │
         │ HTTP POST + Bearer Token
         │ (Cloud Function Trigger)
         ↓
┌────────────────────────────┐
│  Google Cloud Platform     │
│                            │
│  Cloud Functions           │ ← updateLigainsiderPhotos
│  (Node.js 20 + TypeScript) │
│                            │
│  - HTML Scraping           │
│  - Unicode Normalization   │
│  - Firestore Updates       │
│  - Error Handling          │
│                            │
└────────┬───────────────────┘
         │
         ├─────────────────────────────┐
         │                             │
         ↓                             ↓
   ┌──────────────┐          ┌─────────────────┐
   │Ligainsider.de│          │ Firestore DB    │
   │(HTML Scraping)         │ (Photo Storage) │
   └──────────────┘          └─────────────────┘
         
       ┌──────────────────────────────┐
       │  Cloud Scheduler             │
       │  Trigger: täglich 02:00 UTC  │
       │  (Automated Execution)       │
       └──────────────────────────────┘
```

---

## 🚀 Nächste Schritte für Deploy

### Phase 1: Setup (15 Min)

1. **Stelle sicher, dass Firebase CLI installiert ist**
   ```bash
   npm install -g firebase-tools@latest
   cd /Users/marcocorro/Documents/vscode/kickbasekumpel
   ```

2. **Verifiziere GCP Projekt**
   ```bash
   gcloud projects describe kickbasekumpel
   # Sollte Project Details zeigen
   ```

3. **Initialisiere gcloud für Region**
   ```bash
   gcloud config set run/region europe-west1
   ```

### Phase 2: Deployment (5-10 Min)

**Option A: Automated Script**
```bash
chmod +x deploy-functions.sh
./deploy-functions.sh
```

**Option B: Manuell**
```bash
# 1. Build Functions
cd functions
npm install
npm run build

# 2. Deploy
firebase deploy --only functions --project kickbasekumpel

# 3. Create Cloud Scheduler Job
gcloud scheduler jobs create http update-ligainsider-photos-daily \
    --location=europe-west1 \
    --schedule="0 2 * * *" \
    --uri="https://europe-west1-kickbasekumpel.cloudfunctions.net/updateLigainsiderPhotos" \
    --http-method=POST \
    --headers="X-CloudScheduler=true" \
    --project=kickbasekumpel
```

### Phase 3: Validierung (10 Min)

```bash
# 1. Prüfe ob Functions deployed sind
firebase list functions --project=kickbasekumpel

# 2. Teste Function manuell (Cloud Scheduler Header)
curl -X POST https://europe-west1-kickbasekumpel.cloudfunctions.net/updateLigainsiderPhotos \
    -H "X-CloudScheduler: true"

# 3. Prüfe Firestore für Metadaten
# → Navigate to Firebase Console
# → Firestore → collection: system → doc: ligainsider-scraper

# 4. Schaue Logs an
firebase functions:log --project=kickbasekumpel | tail -50
```

### Phase 4: Flutter App Update (10 Min)

**Optional**: Neue `triggerLigainsiderPhotoUpdate()` Methode im Repository hinzufügen für manuellen Trigger von der App.

Der aktuelle Code funktioniert weiterhin, aber ihr könnt optional auch einen UI-Button for manual triggering hinzufügen.

---

## ⚙️ Konfiguration

### Cloud Scheduler Schedule

Die Function wird automatisch täglich um **02:00 UTC** ausgeführt (Server-seitig).

Um das zu ändern:
```bash
# Aktualisiere Schedule
gcloud scheduler jobs update http update-ligainsider-photos-daily \
    --schedule="0 1 * * *" \
    --location=europe-west1 \
    --project=kickbasekumpel
# ☝️ Ändert zu 01:00 UTC
```

### Environment Variables

Aktuell keine Konfiguration nötig. Falls in Zukunft nötig:
1. Kopie `.env.example` zu `.env`
2. Fülle Werte aus
3. Update `functions/src/index.ts` um Variablen zu lesen
4. Redeploy

---

## 📊 Monitoring

### Logs anschauen

```bash
# Echtzeit-Logs
firebase functions:log --project=kickbasekumpel

# Letzten N Logs
firebase functions:log --project=kickbasekumpel | tail -100

# Mit Filtering (nur Fehler)
firebase functions:log --project=kickbasekumpel | grep -i error
```

### Cloud Logging (Advanced)

```bash
# Detaillierte Logs in Google Cloud Console
gcloud functions logs read updateLigainsiderPhotos \
    --region=europe-west1 \
    --project=kickbasekumpel \
    --limit=100 \
    --stream
```

### Metadaten in Firestore

Navigate zu [Firebase Console](https://console.firebase.google.com):
- Project: `kickbasekumpel`
- Firestore Database
- Collection: `system`
- Document: `ligainsider-scraper`

Zeigt:
- `lastRunDate`: Letzter erfolgreicher Lauf
- `totalPlayersUpdated`: Spieler in diesem Lauf aktualisiert
- `status`: "success" oder "error"
- `errors`: Array von Fehlermeldungen

---

## 🧪 Testing

### Lokal testen (mit Emulator)

```bash
# Terminal 1: Starte Emulator
firebase emulators:start --only functions

# Terminal 2: Teste Function
curl -X POST http://localhost:5001/kickbasekumpel/europe-west1/updateLigainsiderPhotos \
    -H "X-CloudScheduler: true" \
    -H "Content-Type: application/json"

# Beobachte Logs in Terminal 1
```

### Production Test (Live Function)

```bash
# Führe Function manuell aus
curl -X POST https://europe-west1-kickbasekumpel.cloudfunctions.net/updateLigainsiderPhotos \
    -H "X-CloudScheduler: true"

# Prüfe Logs
firebase functions:log --project=kickbasekumpel

# Prüfe Metadaten in Firestore
# → Console → system/ligainsider-scraper
```

---

## 📋 Checkliste für Go-Live

- [ ] **Voraussetzungen prüfen**
  - [ ] Node.js 20+ installiert
  - [ ] Firebase CLI aktuell
  - [ ] Google Cloud SDK installiert
  - [ ] Authentifiziert bei gcloud + Firebase

- [ ] **Code Deployment**
  - [ ] `functions/` Code ist vollständig
  - [ ] Dependencies installiert (`npm install`)
  - [ ] TypeScript kompiliert (`npm run build`)
  - [ ] Functions deployed (`firebase deploy --only functions`)

- [ ] **Cloud Scheduler Setup**
  - [ ] Job erstellt mit korrektem Schedule
  - [ ] Korrekte Cloud Function URL
  - [ ] Header `X-CloudScheduler: true` gesetzt

- [ ] **Validierung**
  - [ ] Function testet erfolgreich manuell
  - [ ] Firestore Metadaten werden aktualisiert
  - [ ] Logs sind verfügbar und verständlich
  - [ ] Player-Fotos werden aktualisiert

- [ ] **Dokumentation**
  - [ ] Team kennt neue Architektur
  - [ ] Deployment-Docs sind verfügbar
  - [ ] Support weiß, wo Logs sind

---

## 🐛 Troubleshooting

### "Function antwortet mit 500"
→ Prüfe Logs: `firebase functions:log`  
→ Hat `LIGAINSIDER_SCRAPER.md` noch gültige HTML-Selektoren?

### "Keine Fotos werden aktualisiert"
→ Prüfe ob Firestore Players existieren  
→ Prüfe ob Namen korrekt normalisiert werden  
→ Test mit einfachen ASCII-Namen zuerst

### "Cloud Scheduler Job läuft nicht"
→ Prüfe IAM Permissions für Cloud Scheduler Service Account  
→ Prüfe ob Cloud Scheduler API aktiviert ist

### "TypeScript Kompilierung fehlgeschlagen"
```bash
cd functions
npm run build
# Output sollte `lib/index.js`, `lib/ligainsider-scraper.js` etc. zeigen
```

---

## 📚 Weitere Ressourcen

- [CLOUD_FUNCTIONS_SETUP.md](docs/CLOUD_FUNCTIONS_SETUP.md) - Detaillierte Setup-Anleitung
- [LIGAINSIDER_SCRAPER.md](docs/LIGAINSIDER_SCRAPER.md) - Scraper-Logik Dokumentation
- [functions/README.md](functions/README.md) - Functions-spezifische Info
- [Firebase Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [Google Cloud Scheduler Docs](https://cloud.google.com/scheduler/docs)

---

## 💬 Support

Bei Fragen zur Implementation:
1. Prüfe Logs: `firebase functions:log`
2. Prüfe Metadaten in Firestore: `system/ligainsider-scraper`
3. Teste manuell: `curl https://...updateLigainsiderPhotos`
4. Schaue Deployment-Script Ausgabe an

**Version**: 1.0  
**Datum**: Februar 2026  
**Status**: Ready for Deployment
