import admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { LigainsiderScraperService } from './ligainsider-scraper.js';
import { LigainsiderLineupScraper } from './ligainsider-lineup-scraper.js';
import { Request, Response } from 'express';
import axios from 'axios';
import logger from './logger.js';

// Interfaces für Mistral
interface MistralRequest {
    prompt: string;
    model?: string;
    temperature?: number;
    top_p?: number;
    agent_id?: string;
    agent_version?: number;
}

interface MistralChoice {
    message: { content: string };
}

interface MistralResponse {
    choices: MistralChoice[];
    outputs?: Array<{
        content?: string | Array<{
            text?: string;
            content?: string;
        }>;
    }>;
    output_text?: string;
}

function extractMistralContent(data: MistralResponse): string | null {
    const choiceContent = data.choices?.[0]?.message?.content;
    if (typeof choiceContent === 'string' && choiceContent.trim().length > 0) {
        return choiceContent;
    }

    if (typeof data.output_text === 'string' && data.output_text.trim().length > 0) {
        return data.output_text;
    }

    const outputContent = data.outputs?.[0]?.content;
    if (typeof outputContent === 'string' && outputContent.trim().length > 0) {
        return outputContent;
    }

    if (Array.isArray(outputContent)) {
        const text = outputContent
            .map((part) => {
                if (typeof part.text === 'string' && part.text.trim().length > 0) {
                    return part.text;
                }

                if (typeof part.content === 'string' && part.content.trim().length > 0) {
                    return part.content;
                }

                return '';
            })
            .join('')
            .trim();

        if (text.length > 0) {
            return text;
        }
    }

    return null;
}

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

        // Weitergeleitete Header aufbauen
        const forwardedHeaders: Record<string, string> = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        };
        if (req.headers.authorization) {
            forwardedHeaders['Authorization'] = req.headers.authorization;
        }

        try {
            const fetchOptions: RequestInit = {
                method: req.method,
                headers: forwardedHeaders,
            };

            // Body nur bei POST/PUT/PATCH mitschicken
            if (req.method !== 'GET' && req.method !== 'HEAD' && req.body) {
                fetchOptions.body = JSON.stringify(req.body);
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

// ============================================================================
// Mistral AI Proxy Function
// ============================================================================

/**
 * Cloud Function: Mistral API Proxy
 * 
 * Empfängt Anfragen von der App und leitet sie an die Mistral API weiter.
 * Der Mistral API-Key bleibt serverseitig und wird nie an den Client gesendet.
 * 
 * Security:
 * - Funktion ist öffentlich (invoker: 'public') - keine Nutzer-Authentifizierung
 * - Der Mistral API-Key kommt aus Google Cloud Secret Manager
 */
export const callMistral = onRequest(
    {
        timeoutSeconds: 60,
        memory: '256MiB',
        region: 'us-central1',
        maxInstances: 10,
        invoker: 'public',
    },
    async (request: Request, response: Response) => {
        // CORS für Flutter Web
        response.set('Access-Control-Allow-Origin', '*');
        response.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
        response.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

        // Preflight-Request beantworten
        if (request.method === 'OPTIONS') {
            response.status(204).send('');
            return;
        }

        logger.info('Mistral Proxy: Request erhalten');

        // Mistral API-Key aus Secret Manager laden
        let mistralApiKey: string;
        try {
            const { SecretManagerServiceClient } = await import('@google-cloud/secret-manager');
            const secretManagerClient = new SecretManagerServiceClient();

            const secretName = `projects/kickbasekumpel/secrets/mistral-api-key/versions/latest`;
            const [version] = await secretManagerClient.accessSecretVersion({
                name: secretName,
            });

            const payload = version.payload?.data;
            mistralApiKey = payload ? Buffer.from(payload).toString('utf8') : '';
            logger.info('Mistral Proxy: API-Key aus Secret Manager geladen');
        } catch (error) {
            logger.error(`Mistral Proxy: Fehler beim Laden des API-Keys: ${error}`);
            response.status(500).json({
                error: 'Server Configuration Error',
                message: 'Mistral API-Key nicht verfügbar',
            });
            return;
        }

        if (!mistralApiKey) {
            logger.error('Mistral Proxy: API-Key ist leer');
            response.status(500).json({
                error: 'Server Configuration Error',
                message: 'Mistral API-Key ist leer',
            });
            return;
        }

        // 4. Request Body parsen
        let requestBody: MistralRequest;
        try {
            requestBody = request.body as MistralRequest;

            if (!requestBody.prompt) {
                response.status(400).json({
                    error: 'Invalid Request',
                    message: 'prompt ist erforderlich',
                });
                return;
            }
        } catch (parseError) {
            logger.error(`Mistral Proxy: Ungültiges Request-Format: ${parseError}`);
            response.status(400).json({
                error: 'Invalid Request',
                message: 'Ungültiges JSON-Format',
            });
            return;
        }

        // 5. Mistral API aufrufen (Conversations API für Agenten)
        try {
            logger.info('Mistral Proxy: Rufe Mistral Conversations API auf...');

            // Baue den Request Body für Conversations API
            const requestBodyFinal: any = {
                inputs: [
                    {
                        role: 'user',
                        content: requestBody.prompt,
                    },
                ],
            };

            // Falls Agent-ID mitgesendet wird, verwende Conversations API
            if (requestBody.agent_id) {
                requestBodyFinal.agent_id = requestBody.agent_id;
                if (requestBody.agent_version !== undefined) {
                    requestBodyFinal.agent_version = requestBody.agent_version;
                }
            } else {
                // Fallback zur Chat Completions API für Kompatibilität
                requestBodyFinal.model = requestBody.model || 'mistral-small-latest';
                requestBodyFinal.messages = requestBodyFinal.inputs;
                requestBodyFinal.response_format = { type: 'json_object' };
                delete requestBodyFinal.inputs;

                // Temperatur und Top-P nur für Chat Completions hinzufügen
                if (requestBody.temperature !== undefined) {
                    requestBodyFinal.temperature = requestBody.temperature;
                }
                if (requestBody.top_p !== undefined) {
                    requestBodyFinal.top_p = requestBody.top_p;
                }
            }

            // Endpoint basierend auf Agent-ID wählen
            const endpoint = requestBody.agent_id
                ? 'https://api.mistral.ai/v1/conversations'
                : 'https://api.mistral.ai/v1/chat/completions';

            const mistralResponse = await axios.post(
                endpoint,
                requestBodyFinal,
                {
                    headers: {
                        'Authorization': `Bearer ${mistralApiKey}`,
                        'Content-Type': 'application/json',
                    },
                    timeout: 30000,
                }
            );

            // 6. Antwort verarbeiten
            const data: MistralResponse = mistralResponse.data;

            const content = extractMistralContent(data);

            if (!content) {
                logger.warn('Mistral Proxy: Keine Choices in der Antwort');
                response.status(500).json({
                    error: 'Empty Response',
                    message: 'Mistral hat keine Antwort zurückgegeben',
                });
                return;
            }

            // 7. JSON-Content zurückgeben
            logger.info('Mistral Proxy: Antwort erfolgreich erhalten');
            response.set('Content-Type', 'application/json');
            response.status(200).send(content);

        } catch (mistralError: any) {
            logger.error(`Mistral Proxy: Mistral API Fehler: ${mistralError.message}`);

            if (mistralError.response) {
                const status = mistralError.response.status;
                const errorData = mistralError.response.data;

                if (status === 401) {
                    response.status(500).json({
                        error: 'Mistral API Error',
                        message: 'Ungültiger Mistral API-Key',
                    });
                } else if (status === 429) {
                    response.status(429).json({
                        error: 'Rate Limit',
                        message: 'Mistral Rate Limit erreicht - bitte warte',
                    });
                } else {
                    response.status(500).json({
                        error: 'Mistral API Error',
                        message: `Mistral Fehler: ${status} - ${JSON.stringify(errorData)}`,
                    });
                }
            } else if (mistralError.code === 'ECONNABORTED') {
                response.status(504).json({
                    error: 'Timeout',
                    message: 'Mistral API timeout nach 30 Sekunden',
                });
            } else {
                response.status(500).json({
                    error: 'Unknown Error',
                    message: mistralError.message || 'Unbekannter Fehler',
                });
            }
        }
    }
);
