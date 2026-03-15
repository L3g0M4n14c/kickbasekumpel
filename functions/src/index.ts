import admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { LigainsiderScraperService } from './ligainsider-scraper.js';
import logger from './logger.js';

// Initialisiere Firebase Admin SDK
admin.initializeApp();
const firestore = admin.firestore();

/**
 * Kerlogik für den Ligainsider Photo Update.
 * Wird sowohl vom HTTP-Trigger als auch vom Scheduler aufgerufen.
 */
async function runLigainsiderPhotoUpdate(): Promise<{
    success: boolean;
    message: string;
    stats?: object;
    errors: string[];
}> {
    // 1. Scrape Ligainsider
    const scraper = new LigainsiderScraperService();
    const scraperResult = await scraper.scrapeAllPlayerPhotos();

    if (scraperResult.teamPhotos.size === 0) {
        logger.warn('No photos scraped');
        return { success: false, message: 'No photos scraped', errors: scraperResult.errors };
    }

    // 2. Schreibe Fotos in eigene `ligainsider_photos`-Collection
    //    Document-ID = normalisierter Spielername, dadurch kein Abhängigkeit
    //    von der (möglicherweise leeren) `players`-Collection.
    logger.info(`Writing ${scraperResult.teamPhotos.size} photos to ligainsider_photos...`);

    const BATCH_LIMIT = 500;
    let batchCount = 0;
    let batch = firestore.batch();

    for (const [normalizedName, photoUrl] of scraperResult.teamPhotos) {
        const docRef = firestore.collection('ligainsider_photos').doc(normalizedName);
        batch.set(docRef, {
            photoUrl,
            normalizedName,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        batchCount++;
        if (batchCount >= BATCH_LIMIT) {
            await batch.commit();
            batch = firestore.batch();
            batchCount = 0;
        }
    }

    if (batchCount > 0) {
        await batch.commit();
    }

    const totalPhotos = scraperResult.teamPhotos.size;

    // 3. Speichere Update-Metadaten
    await firestore.collection('system').doc('ligainsider-scraper').set({
        lastRun: admin.firestore.FieldValue.serverTimestamp(),
        lastRunDate: new Date().toISOString(),
        totalTeamsScraped: scraperResult.totalTeams,
        totalPhotosFound: totalPhotos,
        status: 'success',
        errors: scraperResult.errors,
    }, { merge: true });

    logger.info(
        { totalPhotos, totalTeams: scraperResult.totalTeams },
        'Ligainsider photo update completed successfully'
    );

    return {
        success: true,
        message: `Successfully stored ${totalPhotos} player photos`,
        stats: {
            totalTeamsScraped: scraperResult.totalTeams,
            totalPhotosFound: totalPhotos,
        },
        errors: scraperResult.errors,
    };
}

/**
 * Cloud Function: Aktualisiere Spielerfotos von Ligainsider (HTTP Trigger)
 *
 * Triggered:
 * - Manuell oder aus der App via HTTP mit Firebase ID Token
 */
export const updateLigainsiderPhotos = onRequest(
    {
        timeoutSeconds: 540,
        memory: '512MiB',
        region: 'us-central1',
    },
    async (req, res) => {
        try {
            const isScheduled = req.headers['x-cloudscheduler'] === 'true';
            const isBearerToken = req.headers.authorization?.startsWith('Bearer ');

            if (!isScheduled && !isBearerToken) {
                logger.warn('Unauthorized access attempt to updateLigainsiderPhotos');
                res.status(401).json({ error: 'Unauthorized' });
                return;
            }

            if (isBearerToken) {
                try {
                    const token = req.headers.authorization!.split(' ')[1];
                    await admin.auth().verifyIdToken(token);
                } catch (error) {
                    logger.warn({ error }, 'Invalid authentication token');
                    res.status(401).json({ error: 'Invalid token' });
                    return;
                }
            }

            logger.info('Starting Ligainsider photo update (HTTP)...');
            const result = await runLigainsiderPhotoUpdate();
            res.status(200).json(result);
        } catch (error) {
            logger.error({ error }, 'Critical error in updateLigainsiderPhotos');
            res.status(500).json({
                success: false,
                error: error instanceof Error ? error.message : 'Unknown error',
            });
        }
    }
);

/**
 * Cloud Function: Täglicher Scheduler für Ligainsider Photo Update
 *
 * Läuft täglich um 02:00 UTC
 */
export const scheduledLigainsiderPhotoUpdate = onSchedule(
    {
        schedule: '0 2 * * *',
        timeZone: 'UTC',
        timeoutSeconds: 540,
        memory: '512MiB',
        region: 'us-central1',
    },
    async (_event) => {
        logger.info('Starting scheduled Ligainsider photo update...');
        try {
            await runLigainsiderPhotoUpdate();
        } catch (error) {
            logger.error({ error }, 'Critical error in scheduledLigainsiderPhotoUpdate');
        }
    }
);

/**
 * Cloud Function: GET Ligainsider Scraper Status
 *
 * Gibt Informationen über den letzten erfolgreichen Scraping-Lauf zurück
 */
export const getLigainsiderScraperStatus = onRequest(
    { region: 'us-central1' },
    async (req, res) => {
        try {
            const doc = await firestore.collection('system').doc('ligainsider-scraper').get();

            if (!doc.exists) {
                res.status(200).json({
                    status: 'never_run',
                    message: 'Scraper has not been run yet',
                });
                return;
            }

            const data = doc.data();
            res.status(200).json({
                status: 'success',
                ...data,
            });
        } catch (error) {
            logger.error({ error }, 'Error fetching scraper status');
            res.status(500).json({
                error: error instanceof Error ? error.message : 'Unknown error',
            });
        }
    }
);

/**
 * Cloud Function: Firestore Trigger für initiales Setup
 *
 * Erstelle initiales "system" Dokument für Scraper-Tracking
 */
export const initializeLigainsiderScraperMetadata = onDocumentCreated(
    { document: 'players/{playerId}', region: 'us-central1' },
    async (_event) => {
        try {
            const scraperDoc = await firestore.collection('system').doc('ligainsider-scraper').get();

            // Erstelle Dokument nur beim ersten Spieler
            if (!scraperDoc.exists) {
                logger.info('Initializing ligainsider-scraper metadata...');
                await firestore.collection('system').doc('ligainsider-scraper').set({
                    status: 'ready',
                    lastRun: null,
                    lastRunDate: null,
                    totalTeamsScraped: 0,
                    totalPhotosFound: 0,
                    totalPlayersUpdated: 0,
                    totalPlayersProcessed: 0,
                    errors: [],
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }
        } catch (error) {
            logger.error({ error }, 'Error initializing scraper metadata');
        }
    }
);
