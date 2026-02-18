import axios, { AxiosInstance } from 'axios';
import * as cheerio from 'cheerio';
import logger from './logger.js';
import type { TeamKaderLink, ScraperResult } from './types.js';

/**
 * Character Decomposition Map für Diakritika-Entfernung
 */
const DECOMPOSITION_MAP: Record<string, string> = {
    á: 'a', à: 'a', ä: 'a', â: 'a', ã: 'a', å: 'a',
    é: 'e', è: 'e', ë: 'e', ê: 'e',
    í: 'i', ì: 'i', ï: 'i', î: 'i',
    ó: 'o', ò: 'o', ö: 'o', ô: 'o', õ: 'o', ø: 'o',
    ú: 'u', ù: 'u', ü: 'u', û: 'u',
    ñ: 'n', ň: 'n',
    ç: 'c', č: 'c', ć: 'c',
    š: 's', ş: 's',
    ž: 'z', ź: 'z', ż: 'z',
};

/**
 * Ligainsider Scraper Service für Node.js / Cloud Functions
 *
 * Extrahiert:
 * 1. Team-Kader-Links von der Ligainsider-Startseite
 * 2. Spielerfotos und -namen von den Kaderseiten
 * 3. Normalisiert Namen für zuverlässiges Matching (Unicode-aware)
 */
export class LigainsiderScraperService {
    private static readonly BASE_URL = 'https://www.ligainsider.de';
    private static readonly TEAM_MENU_COMMENT = '<!-- BEGINNNING TEAM MENU -->';
    private static readonly PLAYER_IMG_SELECTOR = 'player_img';
    private static readonly IMG_CIRCLE_SELECTOR = 'img-circle';
    private static readonly MAX_RETRIES = 3;
    private static readonly RETRY_DELAY_MS = 2000;

    private httpClient: AxiosInstance;

    constructor() {
        this.httpClient = axios.create({
            timeout: 15000,
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            },
        });
    }

    /**
     * Extrahiert alle Team-Kader-Links von der Ligainsider-Startseite
     *
     * @returns Array mit Team-Namen und Kader-URLs
     */
    async fetchTeamKaderLinks(): Promise<TeamKaderLink[]> {
        try {
            logger.info('Fetching Ligainsider homepage...');

            const response = await this.retryFetch(LigainsiderScraperService.BASE_URL);
            const html = response.data;

            // Finde TEAM MENU Sektion
            const teamMenuIndex = html.indexOf(LigainsiderScraperService.TEAM_MENU_COMMENT);
            if (teamMenuIndex === -1) {
                logger.warn('TEAM MENU comment not found in HTML');
                return [];
            }

            // Parse HTML ab TEAM MENU
            const teamMenuHtml = html.substring(teamMenuIndex);
            const $ = cheerio.load(teamMenuHtml);

            const teamLinks: TeamKaderLink[] = [];
            const links = $('a[href*="/kader/"]');

            links.each((_, element) => {
                const href = $(element).attr('href');
                const teamName = $(element).text().trim();

                if (href && teamName) {
                    const absoluteUrl = href.startsWith('http')
                        ? href
                        : `${LigainsiderScraperService.BASE_URL}${href}`;

                    teamLinks.push({ teamName, kaderUrl: absoluteUrl });
                    logger.debug(`Found team: ${teamName} → ${absoluteUrl}`);
                }
            });

            logger.info(`Successfully extracted ${teamLinks.length} team kader links`);
            return teamLinks;
        } catch (error) {
            logger.error(
                { error },
                'Error fetching team kader links'
            );
            return [];
        }
    }

    /**
     * Extrahiert Spielerfotos von einer Team-Kaderseite
     *
     * @param kaderUrl - URL der Team-Kaderseite
     * @returns Map mit normalisierten Namen -> Foto-URL
     */
    async fetchPlayerPhotosForTeam(kaderUrl: string): Promise<Map<string, string>> {
        try {
            logger.info({ kaderUrl }, 'Fetching player photos...');

            const response = await this.retryFetch(kaderUrl);
            const html = response.data;
            const $ = cheerio.load(html);

            const playerPhotos = new Map<string, string>();

            // Suche nach allen player_img divs
            const playerElements = $(
                `div[class*="${LigainsiderScraperService.PLAYER_IMG_SELECTOR}"]`
            );

            playerElements.each((_, playerDiv) => {
                try {
                    const imgCircle = $(playerDiv).find(
                        `div[class*="${LigainsiderScraperService.IMG_CIRCLE_SELECTOR}"]`
                    );
                    const imgTag = imgCircle.find('img');

                    if (imgTag.length === 0) {
                        logger.debug('Skipping player div: no img tag found');
                        return;
                    }

                    const photoUrl = imgTag.attr('src');
                    const playerName = imgTag.attr('alt');

                    if (!photoUrl || !playerName) {
                        logger.debug('Skipping player: missing URL or name');
                        return;
                    }

                    const normalizedName = this.normalizePlayerName(playerName);
                    playerPhotos.set(normalizedName, photoUrl);
                    logger.debug(
                        { playerName, normalizedName, photoUrl },
                        'Added player photo'
                    );
                } catch (error) {
                    logger.warn({ error }, 'Error parsing individual player element');
                }
            });

            logger.info(
                { teamUrl: kaderUrl, photosCount: playerPhotos.size },
                'Successfully extracted player photos'
            );
            return playerPhotos;
        } catch (error) {
            logger.error(
                { error, kaderUrl },
                'Error fetching player photos'
            );
            return new Map();
        }
    }

    /**
     * Normalisiert einen Spielernamen für zuverlässiges Matching
     *
     * - Decomposiert Diakritika (ñ → n, é → e, etc.)
     * - Konvertiert zu Lowercase
     * - Entfernt extra Whitespace
     *
     * @param name - Originaler Player Name
     * @returns Normalisierter Name
     */
    normalizePlayerName(name: string): string {
        try {
            // 1. Zu Lowercase
            let normalized = name.toLowerCase();

            // 2. Decomposiere Diakritika
            normalized = this.decomposeCharacters(normalized);

            // 3. Entferne Combining Marks (Unicode Range U+0300-U+036F)
            normalized = normalized.replace(/[\u0300-\u036f]/g, '');

            // 4. Entferne extra Whitespace
            normalized = normalized.replace(/\s+/g, ' ').trim();

            logger.debug({ original: name, normalized }, 'Normalized player name');
            return normalized;
        } catch (error) {
            logger.warn({ error, name }, 'Error normalizing player name');
            return name.toLowerCase();
        }
    }

    /**
     * Dekomponiert Zeichen mit Diakritika zu Base-Zeichen
     *
     * @param input - Input String
     * @returns String ohne Diakritika
     */
    private decomposeCharacters(input: string): string {
        let result = input;
        Object.entries(DECOMPOSITION_MAP).forEach(([accented, base]) => {
            result = result.replaceAll(accented, base);
        });
        return result;
    }

    /**
     * Retry-Wrapper für HTTP Requests mit Exponential Backoff
     *
     * @param url - URL zu fetchen
     * @param retries - Aktuelle Retry-Nummer
     */
    private async retryFetch(
        url: string,
        retries: number = 0
    ): Promise<any> {
        try {
            return await this.httpClient.get(url);
        } catch (error) {
            if (retries < LigainsiderScraperService.MAX_RETRIES) {
                const delayMs = LigainsiderScraperService.RETRY_DELAY_MS * Math.pow(2, retries);
                logger.warn(
                    { url, retries, delayMs, error },
                    'Request failed, retrying...'
                );
                await new Promise(resolve => setTimeout(resolve, delayMs));
                return this.retryFetch(url, retries + 1);
            }
            throw error;
        }
    }

    /**
     * Führt vollständigen Scraping-Prozess aus
     *
     * @returns ScraperResult mit allen gescrapten Daten
     */
    async scrapeAllPlayerPhotos(): Promise<ScraperResult> {
        const result: ScraperResult = {
            teamPhotos: new Map(),
            totalTeams: 0,
            totalPhotos: 0,
            errors: [],
        };

        try {
            // 1. Hole alle Team-Links
            const teamLinks = await this.fetchTeamKaderLinks();
            if (teamLinks.length === 0) {
                result.errors.push('No team links found');
                return result;
            }

            result.totalTeams = teamLinks.length;
            logger.info({ teamCount: teamLinks.length }, 'Starting to fetch player photos...');

            // 2. Für jedes Team, hole Spielerfotos
            for (const { teamName, kaderUrl } of teamLinks) {
                try {
                    const playerPhotos = await this.fetchPlayerPhotosForTeam(kaderUrl);
                    playerPhotos.forEach((photoUrl, normalizedName) => {
                        result.teamPhotos.set(normalizedName, photoUrl);
                    });
                    logger.info(
                        { teamName, photoCount: playerPhotos.size },
                        'Team processed successfully'
                    );
                } catch (error) {
                    const errorMsg = `Error processing team "${teamName}": ${error instanceof Error ? error.message : String(error)}`;
                    logger.error({ error, teamName }, errorMsg);
                    result.errors.push(errorMsg);
                }
            }

            result.totalPhotos = result.teamPhotos.size;
            logger.info(
                { totalPhotos: result.totalPhotos, errors: result.errors.length },
                'Scraping completed'
            );

            return result;
        } catch (error) {
            const errorMsg = `Critical error during scraping: ${error instanceof Error ? error.message : String(error)}`;
            logger.error({ error }, errorMsg);
            result.errors.push(errorMsg);
            return result;
        }
    }
}
