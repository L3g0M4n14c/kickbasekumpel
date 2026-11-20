import admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { LigainsiderScraperService } from './ligainsider-scraper.js';
import { LigainsiderLineupScraper } from './ligainsider-lineup-scraper.js';
import logger from './logger.js';

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
// Voraussichtliche Aufstellungen (Ligainsider)
// ============================================================================

const LINEUP_CACHE_DOC = 'ligainsider-lineups-cache';

/**
 * Ab diesem Alter gilt der Cache als veraltet. Der Scheduler läuft tagsüber
 * alle 15 Minuten, nachts stündlich – das hier ist nur die Grenze für das
 * `stale`-Flag in der Antwort.
 */
const LINEUP_STALE_AFTER_MS = 90 * 60 * 1000;

interface CachedLineups {
    matches: object[];
    scrapedAt: string;
}

/**
 * Liest den Lineup-Cache aus Firestore – unabhängig vom Alter.
 * Returns null nur, wenn noch gar kein Cache existiert.
 */
async function readLineupCache(): Promise<CachedLineups | null> {
    try {
        const doc = await firestore.collection('system').doc(LINEUP_CACHE_DOC).get();
        const data = doc.data();
        if (!data || !Array.isArray(data.matches) || !data.scrapedAt) return null;
        return { matches: data.matches as object[], scrapedAt: data.scrapedAt as string };
    } catch (err) {
        logger.warn({ err }, 'Fehler beim Lesen des Lineup-Cache');
        return null;
    }
}

/**
 * Scraped ligainsider.de und schreibt das Ergebnis in den Firestore-Cache.
 *
 * Ein leeres Ergebnis (z. B. Seitenstruktur geändert, Ligainsider down)
 * überschreibt einen vorhandenen Cache NICHT – lieber etwas ältere Daten
 * als gar keine.
 */
async function refreshLineupCache(): Promise<CachedLineups> {
    const scraper = new LigainsiderLineupScraper();
    const result = await scraper.scrapeLineups();
    const matches = JSON.parse(JSON.stringify(result.matches)) as object[];

    if (result.errors.length > 0) {
        logger.warn({ errors: result.errors }, 'Lineup-Scraping mit Fehlern abgeschlossen');
    }

    if (matches.length === 0) {
        const existing = await readLineupCache();
        if (existing) {
            logger.warn('Lineup-Scraping leer – vorhandener Cache bleibt erhalten');
            return existing;
        }
    }

    await firestore.collection('system').doc(LINEUP_CACHE_DOC).set({
        matches,
        scrapedAt: result.scrapedAt,
        matchCount: matches.length,
        errors: result.errors,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    logger.info({ matchCount: matches.length }, 'Lineup-Cache gespeichert');

    return { matches, scrapedAt: result.scrapedAt };
}

/**
 * Cloud Function: Scheduler für die voraussichtlichen Aufstellungen.
 *
 * Tagsüber (07–23 Uhr deutscher Zeit) alle 15 Minuten, damit kurzfristige
 * Änderungen vor dem Spieltag zeitnah in der App landen. Nachts reicht der
 * stündliche Lauf von [scheduledLigainsiderLineupUpdateNight].
 */
export const scheduledLigainsiderLineupUpdate = onSchedule(
    {
        schedule: '*/15 7-23 * * *',
        timeZone: 'Europe/Berlin',
        timeoutSeconds: 300,
        memory: '512MiB',
        region: 'us-central1',
        retryCount: 0,
    },
    async (_event) => {
        logger.info('Starte geplantes Lineup-Scraping (tagsüber)...');
        await refreshLineupCache();
    }
);

/** Nachtlauf: stündlich 00–06 Uhr deutscher Zeit. */
export const scheduledLigainsiderLineupUpdateNight = onSchedule(
    {
        schedule: '0 0-6 * * *',
        timeZone: 'Europe/Berlin',
        timeoutSeconds: 300,
        memory: '512MiB',
        region: 'us-central1',
        retryCount: 0,
    },
    async (_event) => {
        logger.info('Starte geplantes Lineup-Scraping (nachts)...');
        await refreshLineupCache();
    }
);

/**
 * Cloud Function: Voraussichtliche Aufstellungen von Ligainsider (HTTP GET)
 *
 * Liefert immer sofort den Firestore-Cache aus – aktuell gehalten wird er
 * vom Scheduler. Nur wenn noch nie gescraped wurde, wird synchron gescraped.
 *
 * Öffentlicher Endpunkt – die Aufstellungsdaten sind öffentliche Infos von ligainsider.de.
 *
 * Response: `{ matches: LigainsiderMatch[], scrapedAt: string, fromCache: boolean, stale: boolean }`
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
            let fromCache = true;
            let data = await readLineupCache();
            if (data === null) {
                logger.info('Kein Lineup-Cache vorhanden – scrape synchron');
                data = await refreshLineupCache();
                fromCache = false;
            }

            const ageMs = Date.now() - new Date(data.scrapedAt).getTime();
            const stale = ageMs > LINEUP_STALE_AFTER_MS;
            if (stale) {
                logger.warn({ scrapedAt: data.scrapedAt }, 'Lineup-Cache veraltet – läuft der Scheduler?');
            }

            res.status(200).json({
                matches: data.matches,
                scrapedAt: data.scrapedAt,
                fromCache,
                stale,
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

// ============================================================================
// Kickbase API Proxy für Flutter Web (CORS-Umgehung)
// ============================================================================

const KICKBASE_BASE_URL = 'https://api.kickbase.com';

/**
 * Cloud Function: Kickbase API Proxy für Flutter Web.
 *
 * Browser-Requests an api.kickbase.com werden durch CORS blockiert, da die
 * Kickbase-API keine `Access-Control-Allow-Origin`-Header sendet.
 * Diese Funktion leitet Requests serverseitig weiter und fügt CORS-Header hinzu.
 *
 * Verwendung (Flutter Web):
 *   URL: https://us-central1-kickbasekumpel.cloudfunctions.net/kickbaseProxy
 *   Header: X-Kickbase-Endpoint: /v4/user
 *   Header: Authorization: Bearer <kickbase_token>   (optional beim Login)
 *   Body: gleich wie der ursprüngliche Kickbase-Request
 *
 * Sicherheit:
 *   - Erlaubt nur Zugriff auf /v4/* Endpunkte der Kickbase-API (Whitelist)
 *   - Kickbase-Token selbst ist die Authentifizierung
 */
export const kickbaseProxy = onRequest(
    {
        timeoutSeconds: 30,
        memory: '256MiB',
        region: 'us-central1',
        invoker: 'public',
    },
    async (req, res) => {
        // CORS-Header für alle Antworten setzen
        res.set('Access-Control-Allow-Origin', '*');
        res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Kickbase-Endpoint');

        // Preflight-Request sofort beantworten
        if (req.method === 'OPTIONS') {
            res.status(204).send('');
            return;
        }

        // Kickbase-Endpunkt aus Header lesen
        const endpoint = req.headers['x-kickbase-endpoint'];
        if (!endpoint || typeof endpoint !== 'string') {
            res.status(400).json({ error: 'Fehlender Header: X-Kickbase-Endpoint' });
            return;
        }

        // Nur Kickbase v4-Endpunkte erlauben (Sicherheits-Whitelist)
        if (!endpoint.startsWith('/v4/')) {
            res.status(400).json({ error: 'Ungültiger Endpunkt: nur /v4/* erlaubt' });
            return;
        }

        const kickbaseUrl = `${KICKBASE_BASE_URL}${endpoint}`;

        // Weitergeleitete Header aufbauen – Content-Type des Clients übernehmen
        // (z. B. text/plain für POST /lineup), Fallback ist JSON.
        const contentType = req.headers['content-type'];
        const forwardedHeaders: Record<string, string> = {
            'Accept': 'application/json',
            'Content-Type': typeof contentType === 'string' ? contentType : 'application/json',
        };
        if (req.headers.authorization) {
            forwardedHeaders['Authorization'] = req.headers.authorization;
        }

        try {
            const fetchOptions: RequestInit = {
                method: req.method,
                headers: forwardedHeaders,
            };

            // Body nur bei POST/PUT/PATCH mitschicken – unverändert (roh),
            // damit auch text/plain-Bodies (z. B. POST /lineup) korrekt
            // weitergeleitet werden.
            if (req.method !== 'GET' && req.method !== 'HEAD') {
                if (req.rawBody && req.rawBody.length > 0) {
                    fetchOptions.body = req.rawBody;
                } else if (typeof req.body === 'string' && req.body.length > 0) {
                    fetchOptions.body = req.body;
                } else if (req.body && typeof req.body === 'object' && Object.keys(req.body).length > 0) {
                    fetchOptions.body = JSON.stringify(req.body);
                }
            }

            logger.info({ endpoint, method: req.method }, '🔀 Forwarding to Kickbase API');

            const kickbaseResponse = await fetch(kickbaseUrl, fetchOptions);
            const responseBody = await kickbaseResponse.text();

            logger.info(
                { endpoint, status: kickbaseResponse.status },
                '✅ Kickbase API response received'
            );

            res
                .status(kickbaseResponse.status)
                .set('Content-Type', 'application/json')
                .send(responseBody);
        } catch (error) {
            logger.error({ error, endpoint }, '❌ Kickbase proxy error');
            res.status(502).json({
                error: 'Kickbase API nicht erreichbar',
                details: error instanceof Error ? error.message : 'Unbekannter Fehler',
            });
        }
    }
);
