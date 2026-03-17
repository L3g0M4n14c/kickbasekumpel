import admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { LigainsiderScraperService } from './ligainsider-scraper.js';
import { LigainsiderLineupScraper } from './ligainsider-lineup-scraper.js';
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

// ============================================================================
// Cache-TTL für Aufstellungen: 2 Stunden
// ============================================================================
const LINEUP_CACHE_TTL_MS = 2 * 60 * 60 * 1000;

/**
 * Liest gecachte Lineup-Daten aus Firestore (wenn frisch genug).
 * Returns null wenn kein Cache vorhanden oder veraltet.
 */
async function getCachedLineups(): Promise<object[] | null> {
    try {
        const doc = await firestore.collection('system').doc('ligainsider-lineups-cache').get();
        if (!doc.exists) return null;

        const data = doc.data();
        if (!data || !data.matches || !data.scrapedAt) return null;

        const scrapedAt = new Date(data.scrapedAt as string).getTime();
        if (Date.now() - scrapedAt > LINEUP_CACHE_TTL_MS) {
            logger.info('Lineup-Cache veraltet (> 2h), wird neu gescraped');
            return null;
        }

        logger.info({ scrapedAt: data.scrapedAt }, 'Lineup-Cache trifft (frisch)');
        return data.matches as object[];
    } catch (err) {
        logger.warn({ err }, 'Fehler beim Lesen des Lineup-Cache');
        return null;
    }
}

/**
 * Speichert Lineup-Daten im Firestore-Cache.
 */
async function saveLineupsToCache(matches: object[], errors: string[]): Promise<void> {
    try {
        await firestore.collection('system').doc('ligainsider-lineups-cache').set({
            matches,
            scrapedAt: new Date().toISOString(),
            matchCount: matches.length,
            errors,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        logger.info({ matchCount: matches.length }, 'Lineup-Cache gespeichert');
    } catch (err) {
        logger.warn({ err }, 'Fehler beim Speichern des Lineup-Cache');
    }
}

/**
 * Cloud Function: Voraussichtliche Aufstellungen von Ligainsider (HTTP GET)
 *
 * Wird aufgerufen wenn der User die Aufstellungs-View öffnet.
 *
 * - Bei frischem Cache (< 2h): sofortige Rückgabe der gecachten Daten
 * - Bei veraltetem Cache: Ligainsider scrapen, cachen und zurückgeben
 *
 * Öffentlicher Endpunkt – die Aufstellungsdaten sind öffentliche Infos von ligainsider.de.
 * Kein Auth nötig. Der 2h-Cache schützt vor übermäßigen Scraping-Aufrufen.
 *
 * Response: `{ matches: LigainsiderMatch[], scrapedAt: string, fromCache: boolean }`
 */
export const getLigainsiderLineups = onRequest(
    {
        timeoutSeconds: 300,
        memory: '512MiB',
        region: 'us-central1',
        invoker: 'public',
    },
    async (req, res) => {
        // CORS für Flutter Web
        res.set('Access-Control-Allow-Origin', '*');
        res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
        res.set('Access-Control-Allow-Headers', 'Content-Type');
        if (req.method === 'OPTIONS') {
            res.status(204).send('');
            return;
        }

        try {
            // Schritt 1: Cache prüfen
            const cached = await getCachedLineups();
            if (cached !== null) {
                const cacheDoc = await firestore
                    .collection('system')
                    .doc('ligainsider-lineups-cache')
                    .get();
                res.status(200).json({
                    matches: cached,
                    scrapedAt: cacheDoc.data()?.scrapedAt ?? '',
                    fromCache: true,
                });
                return;
            }

            // Schritt 2: Frisch scrapen
            logger.info('Starte frisches Lineup-Scraping von ligainsider.de/bundesliga/spieltage/');
            const scraper = new LigainsiderLineupScraper();
            const result = await scraper.scrapeLineups();

            // Matches als plain objects serialisieren (für Firestore)
            const matchesPlain = JSON.parse(JSON.stringify(result.matches));

            // Schritt 3: Cachen (auch wenn leer, um Thundering-Herd zu vermeiden)
            await saveLineupsToCache(matchesPlain, result.errors);

            // Schritt 4: Antwort
            if (result.errors.length > 0) {
                logger.warn({ errors: result.errors }, 'Lineup-Scraping mit Fehlern abgeschlossen');
            }

            res.status(200).json({
                matches: matchesPlain,
                scrapedAt: result.scrapedAt,
                fromCache: false,
                ...(result.errors.length > 0 && { warnings: result.errors }),
            });
        } catch (error) {
            logger.error({ error }, 'Kritischer Fehler in getLigainsiderLineups');
            res.status(500).json({
                error: error instanceof Error ? error.message : 'Unbekannter Fehler',
                matches: [],
            });
        }
    }
);
