import admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { LigainsiderScraperService } from './ligainsider-scraper.js';
import logger from './logger.js';
import type { FirestorePlayer } from './types.js';

// Initialisiere Firebase Admin SDK
admin.initializeApp();
const firestore = admin.firestore();

/**
 * Cloud Function: Aktualisiere Spielerfotos von Ligainsider
 *
 * Triggered:
 * - Via Cloud Scheduler täglich um 02:00 UTC
 * - Oder manuell via HTTP Trigger (mit Authentication)
 *
 * Ablauf:
 * 1. Scrape alle Spielerfotos von Ligainsider.de
 * 2. Vergleiche mit existierenden Spielern in Firestore
 * 3. Update Firestore mit neuen Foto-URLs
 * 4. Speichere Metadaten (letztes Update, etc.)
 */
export const updateLigainsiderPhotos = onRequest(
    {
        timeoutSeconds: 540, // 9 Minuten für vollständigen Scraping-Prozess
        memory: '512MiB',
        region: 'us-central1',
    },
    async (req, res) => {
        try {
            // Authentifizierung: Nur vom Cloud Scheduler oder authentifizierten Requests
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

            logger.info('Starting Ligainsider photo update...');

            // 1. Scrape Ligainsider
            const scraper = new LigainsiderScraperService();
            const scraperResult = await scraper.scrapeAllPlayerPhotos();

            if (scraperResult.teamPhotos.size === 0) {
                logger.warn('No photos scraped');
                res.status(200).json({
                    success: false,
                    message: 'No photos scraped',
                    errors: scraperResult.errors,
                });
                return;
            }

            // 2. Lade alle Spieler aus Firestore
            logger.info('Fetching players from Firestore...');
            const playersSnapshot = await firestore.collection('players').get();

            if (playersSnapshot.empty) {
                logger.warn('No players found in Firestore');
                res.status(200).json({
                    success: false,
                    message: 'No players found in Firestore',
                });
                return;
            }

            // 3. Aktualisiere Spieler mit neuen Fotos
            let totalUpdated = 0;
            let totalProcessed = 0;
            const batch = firestore.batch();
            const updates: Array<{ playerName: string; photoUrl: string }> = [];

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
                    // Nur updaten, wenn wir noch kein Foto haben
                    if (!player.profileBigUrl || player.profileBigUrl === '') {
                        const photoUrl = scraperResult.teamPhotos.get(normalizedPlayerName)!;
                        const playerRef = firestore.collection('players').doc(player.id);

                        batch.update(playerRef, {
                            profileBigUrl: photoUrl,
                            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                            ligainsiderPhotoUpdatedAt: new Date().toISOString(),
                        });

                        updates.push({
                            playerName: `${player.firstName} ${player.lastName}`,
                            photoUrl,
                        });
                        totalUpdated++;

                        logger.debug(
                            { playerId: player.id, playerName: `${player.firstName} ${player.lastName}`, photoUrl },
                            'Scheduled photo update'
                        );
                    }
                }
            }

            // 4. Committe Batch Update (max 500 writes per batch)
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

            res.status(200).json({
                success: true,
                message: `Successfully updated ${totalUpdated} player photos`,
                stats: {
                    totalTeamsScraped: scraperResult.totalTeams,
                    totalPhotosFound: scraperResult.totalPhotos,
                    totalPlayersUpdated: totalUpdated,
                    totalPlayersProcessed: totalProcessed,
                },
                errors: scraperResult.errors,
            });
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
    { document: 'players/{playerId}', region: 'europe-west3' },
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
