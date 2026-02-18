#!/bin/bash

# Deployment script für KickbaseKumpel Cloud Functions und Scheduler
# Verwendung: ./deploy-functions.sh

set -e

PROJECT_ID="kickbasekumpel"
FUNCTION_NAME="updateLigainsiderPhotos"
REGION="europe-west1"  # Nächstgelegene Region zu Deutschland
SCHEDULE="0 2 * * *"   # Täglich um 02:00 UTC
JOB_NAME="update-ligainsider-photos-daily"

echo "🚀 Deployment von KickbaseKumpel Cloud Functions..."
echo "Project: $PROJECT_ID"
echo "Region: $REGION"

# 1. Stelle sicher, dass Firebase CLI installiert ist
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI nicht installiert. Installiere mit: npm install -g firebase-tools"
    exit 1
fi

# 2. Initialisiere Firebase Projekt (falls nicht geschehen)
firebase init --project="$PROJECT_ID" 2>/dev/null || true

# 3. Deploye Cloud Functions
echo ""
echo "📦 Installiere Dependencies..."
cd functions
npm install
npm run build
cd ..

echo "🔧 Deploye Cloud Functions..."
firebase deploy --only functions --project="$PROJECT_ID"

# 4. Erstelle Cloud Scheduler Job
echo ""
echo "⏱️  Erstelle Cloud Scheduler Job..."

FUNCTION_URL="https://${REGION}-${PROJECT_ID}.cloudfunctions.net/${FUNCTION_NAME}"

echo "Cloud Function URL: $FUNCTION_URL"

# Prüfe ob Job bereits existiert
if gcloud scheduler jobs describe "$JOB_NAME" --location="$REGION" --project="$PROJECT_ID" &>/dev/null; then
    echo "Job existiert bereits, aktualisiere..."
    gcloud scheduler jobs update http "$JOB_NAME" \
        --location="$REGION" \
        --schedule="$SCHEDULE" \
        --uri="$FUNCTION_URL" \
        --http-method=POST \
        --headers="X-CloudScheduler=true" \
        --project="$PROJECT_ID"
else
    echo "Erstelle neuen Job..."
    gcloud scheduler jobs create http "$JOB_NAME" \
        --location="$REGION" \
        --schedule="$SCHEDULE" \
        --uri="$FUNCTION_URL" \
        --http-method=POST \
        --headers="X-CloudScheduler=true" \
        --project="$PROJECT_ID"
fi

echo ""
echo "✅ Deployment abgeschlossen!"
echo ""
echo "📋 Nächste Schritte:"
echo "1. Cloud Scheduler Job prüfen:"
echo "   gcloud scheduler jobs list --location=$REGION --project=$PROJECT_ID"
echo ""
echo "2. Logs anschauen:"
echo "   firebase functions:log --project=$PROJECT_ID"
echo ""
echo "3. Manuelle Ausführung testen:"
echo "   gcloud scheduler jobs run $JOB_NAME --location=$REGION --project=$PROJECT_ID"
