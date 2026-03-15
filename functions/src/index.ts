import admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { LigainsiderScraperService } from './ligainsider-scraper.js';
import logger from './logger.js';
import type { FirestorePlayer } from './types.js';

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

    // 2. Lade alle Spieler aus Firestore
    logger.info('Fetching players from Firestore...');
    const playersSnapshot = await firestore.collection('players').get();

    if (playersSnapshot.empty) {
        logger.warn('No players found in Firestore');
        return { success: false, message: 'No players found in Firestore', errors: [] };
    }

    // 3. Aktualisiere Spieler mit neuen Fotos
    let totalUpdated = 0;
    let totalProcessed = 0;
    const batch = firestore.batch();

    const players: FirestorePlayer[] = [];
    playersSnapshot.forEach(doc => {
        players.push({ id: doc.id, ...doc.data() } as FirestorePlayer);
    });

    for (const player of players) {
        totalProcessed++;
        const normalizedPlayerName = scraper.normalizePlayerName(
            `${player.firstName} ${player.lastName}`
        );

        if (scraperResult.teamPhotos.has(normalizedPlayerName)) {
            const photoUrl = scraperResult.teamPhotos.get(normalizedPlayerName)!;
            const playerRef = firestore.collection('players').doc(player.id);

            batch.update(playerRef, {
                ligainsiderPhotoUrl: photoUrl,
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                ligainsiderPhotoUpdatedAt: new Date().toISOString(),
            });

            totalUpdated++;
            logger.debug(
                { playerId: player.id, playerName: `${player.firstName} ${player.lastName}`, photoUrl },
                'Scheduled photo update'
            );
        }
    }

    // 4. Committe Batch Update
    if (totalUpdated > 0) {
        logger.info(`Committing ${totalUpdated} photo updates...`);
        await batch.commit();
    }

    // 5. Speichere Update-Metadaten
    await firestore.collection('system').doc('ligainsider-scraper').update({
        lastRun: admin.firestore.FieldValue.serverTimestamp(),
        lastRunDate: new Date().toISOString(),
        totalTeamsScraped: scraperResult.totalTeams,
        totalPhotosFound: scraperResult.totalPhotos,
        totalPlayersUpdated: totalUpdated,
        totalPlayersProcessed: totalProcessed,
        status: 'success',
        errors: scraperResult.errors,
    });

    logger.info(
        { totalUpdated, totalTeams: scraperResult.totalTeams, totalPhotos: scraperResult.totalPhotos },
        'Ligainsider photo update completed successfully'
    );

    return {
        success: true,
        message: `Successfully updated ${totalUpdated} player photos`,
        stats: {
            totalTeamsScraped: scraperResult.totalTeams,
            totalPhotosFound: scraperResult.totalPhotos,
            totalPlayersUpdated: totalUpdated,
            totalPlayersProcessed: totalProcessed,
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
        region: 'europe-west1',
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
        region: 'europe-west1',
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
    { region: 'europe-west1' },
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
    { document: 'players/{playerId}', region: 'europe-west1' },
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
