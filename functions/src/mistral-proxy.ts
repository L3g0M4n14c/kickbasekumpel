import { onRequest } from 'firebase-functions/v2/https';
import { Request, Response } from 'express';
import * as admin from 'firebase-admin';
import axios from 'axios';
import logger from './logger.js';

// Interface für die Request-Daten
interface MistralRequest {
    prompt: string;
    model?: string;
    temperature?: number;
    top_p?: number;
}

// Interface für die Mistral API Response
interface MistralChoice {
    message: {
        content: string;
    };
}

interface MistralResponse {
    choices: MistralChoice[];
}

/**
 * Cloud Function: Mistral API Proxy
 * 
 * Empfängt Anfragen von der App und leitet sie an die Mistral API weiter.
 * Der Mistral API-Key bleibt serverseitig und wird nie an den Client gesendet.
 * 
 * Security:
 * - Nur authentifizierte Nutzer (Firebase Auth) können die Funktion aufrufen
 * - Der Mistral API-Key kommt aus Firebase Functions Config
 * 
 * Request Body:
 * {
 *   "prompt": "Analysiere diesen Spieler...",
 *   "model": "mistral-small-latest",
 *   "temperature": 0.2,
 *   "top_p": 0.9
 * }
 * 
 * Response:
 * {
 *   "score": 75.5,
 *   "action": "buy",
 *   "reason": "Der Spieler hat...",
 *   "confidence": 0.85,
 *   "estimatedValue": 1500000,
 *   "category": "buy"
 * }
 */
export const callMistral = onRequest(
    {
        timeoutSeconds: 60,
        memory: '256MiB',
        region: 'us-central1',
        maxInstances: 10, // Begrenze Anzahl der Instanzen
    },
    async (request: Request, response: Response) => {
        logger.info('Mistral Proxy: Request erhalten');

        // 1. Authentication prüfen
        if (!request.headers.authorization) {
            logger.warn('Mistral Proxy: Kein Authorization Header');
            response.status(401).json({
                error: 'Unauthorized',
                message: 'Firebase ID Token erforderlich',
            });
            return;
        }

        // 2. Firebase ID Token verifizieren
        const idToken = request.headers.authorization.split('Bearer ')[1];

        try {
            // In Firebase Admin SDK v11+ ist verifyIdToken nicht mehr direkt verfügbar
            // Wir verwenden stattdessen das Auth-Modul
            const auth = admin.auth();
            const decodedToken = await auth.verifyIdToken(idToken);

            if (!decodedToken) {
                logger.warn('Mistral Proxy: Ungültiger ID Token');
                response.status(401).json({
                    error: 'Unauthorized',
                    message: 'Ungültiger Firebase ID Token',
                });
                return;
            }

            logger.info(`Mistral Proxy: Authentifiziert als UID: ${decodedToken.uid}`);
        } catch (authError) {
            logger.error(`Mistral Proxy: Auth-Fehler: ${authError}`);
            response.status(401).json({
                error: 'Unauthorized',
                message: 'Authentifizierung fehlgeschlagen',
            });
            return;
        }

        // 3. Mistral API-Key aus Config laden
        const mistralApiKey = process.env.MISTRAL_API_KEY;

        if (!mistralApiKey) {
            logger.error('Mistral Proxy: MISTRAL_API_KEY nicht in Environment Variables gesetzt!');
            response.status(500).json({
                error: 'Server Configuration Error',
                message: 'Mistral API-Key nicht konfiguriert',
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

        // 5. Mistral API aufrufen
        try {
            logger.info('Mistral Proxy: Rufe Mistral API auf...');

            const mistralResponse = await axios.post(
                'https://api.mistral.ai/v1/chat/completions',
                {
                    model: requestBody.model || 'mistral-small-latest',
                    messages: [
                        {
                            role: 'user',
                            content: requestBody.prompt,
                        },
                    ],
                    response_format: { type: 'json_object' },
                    temperature: requestBody.temperature || 0.2,
                    top_p: requestBody.top_p || 0.9,
                },
                {
                    headers: {
                        'Authorization': `Bearer ${mistralApiKey}`,
                        'Content-Type': 'application/json',
                    },
                    timeout: 30000, // 30 Sekunden Timeout
                }
            );

            // 6. Antwort verarbeiten
            const data: MistralResponse = mistralResponse.data;

            if (!data.choices || data.choices.length === 0) {
                logger.warn('Mistral Proxy: Keine Choices in der Antwort');
                response.status(500).json({
                    error: 'Empty Response',
                    message: 'Mistral hat keine Antwort zurückgegeben',
                });
                return;
            }

            const content = data.choices[0].message.content;

            // 7. JSON-Content zurückgeben
            logger.info('Mistral Proxy: Antwort erfolgreich erhalten');
            response.set('Content-Type', 'application/json');
            response.status(200).send(content);

        } catch (mistralError: any) {
            logger.error(`Mistral Proxy: Mistral API Fehler: ${mistralError.message}`);

            if (mistralError.response) {
                const status = mistralError.response.status;
                const data = mistralError.response.data;

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
                        message: `Mistral Fehler: ${status} - ${JSON.stringify(data)}`,
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

// HTTP Function für GET-Anfragen (falls benötigt)
export const callMistralGet = onRequest(
    {
        timeoutSeconds: 60,
        memory: '256MiB',
        region: 'us-central1',
    },
    async (request: Request, response: Response) => {
        // Nur für Debug-Zwecke, Haupt-Funktion ist callMistral (POST)
        response.status(405).json({
            error: 'Method Not Allowed',
            message: 'Bitte nutze POST /callMistral',
        });
    }
);
