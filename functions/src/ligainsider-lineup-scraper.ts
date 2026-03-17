import axios, { AxiosInstance } from 'axios';
import * as cheerio from 'cheerio';
import logger from './logger.js';
import type { LineupMatch, LineupRow, LineupPlayer, LineupScraperResult } from './types.js';

/** Strukturierter Match-Eintrag aus der Übersichtstabelle (leg_column-Struktur) */
interface MatchEntry {
    homeTeam: string;
    awayTeam: string;
    homeLineupUrl: string | null;
    awayLineupUrl: string | null;
}

/**
 * Ligainsider Lineup Scraper
 *
 * Scraped voraussichtliche Aufstellungen von ligainsider.de/bundesliga/spieltage/
 * und geht dabei Spiel für Spiel durch.
 *
 * Ablauf:
 * 1. Spieltage-Übersichtsseite laden → alle Spiel-Detail-Links extrahieren
 * 2. Für jedes Spiel die Detail-Seite laden
 * 3. Heim- und Gastaufstellung parsen (Zeile für Zeile)
 * 4. Strukturierte `LineupMatch`-Daten zurückgeben
 */
export class LigainsiderLineupScraper {
    private static readonly BASE_URL = 'https://www.ligainsider.de';
    private static readonly SPIELTAGE_URL = `${LigainsiderLineupScraper.BASE_URL}/bundesliga/spieltage/`;
    private static readonly MAX_RETRIES = 3;
    private static readonly RETRY_DELAY_MS = 1500;

    private httpClient: AxiosInstance;

    constructor() {
        this.httpClient = axios.create({
            timeout: 20000,
            headers: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
                Accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'de-DE,de;q=0.9,en;q=0.7',
                'Accept-Encoding': 'gzip, deflate, br',
            },
        });
    }

    // =========================================================================
    // Public API
    // =========================================================================

    /**
     * Haupt-Einstiegspunkt: scraped alle Spielpaarungen des aktuellen Spieltags.
     */
    async scrapeLineups(): Promise<LineupScraperResult> {
        const errors: string[] = [];

        logger.info(
            { url: LigainsiderLineupScraper.SPIELTAGE_URL },
            'Ligainsider Lineup Scraper: Starte Spieltage-Scraping...'
        );

        try {
            // Schritt 1: Spieltage-Übersicht laden
            const overviewHtml = await this.fetchHtml(LigainsiderLineupScraper.SPIELTAGE_URL);
            const $ = cheerio.load(overviewHtml);

            // Debug: Seitentitel loggen
            logger.info({ title: $('title').text() }, 'Spieltage-Seite geladen');

            // Schritt 2: Match-Einträge via leg_column-Tabellenstruktur extrahieren (primäre Strategie)
            const matchEntries = this.extractMatchEntriesFromTable($);
            const matches: LineupMatch[] = [];

            if (matchEntries.length > 0) {
                logger.info(`Match-Einträge aus Tabelle gefunden: ${matchEntries.length}`);

                // Schritt 3a: Pro Match-Eintrag Heim- und Gastaufstellung über separate Team-Links scrapen
                for (const entry of matchEntries) {
                    try {
                        logger.info(
                            { homeTeam: entry.homeTeam, awayTeam: entry.awayTeam },
                            'Scrape Match-Aufstellungen...'
                        );
                        const match = await this.scrapeMatchFromEntry(entry);
                        if (match) {
                            matches.push(match);
                            logger.info(
                                {
                                    homeTeam: match.homeTeam,
                                    awayTeam: match.awayTeam,
                                    homeRows: match.homeLineup.length,
                                    awayRows: match.awayLineup.length,
                                },
                                'Spiel erfolgreich gescraped'
                            );
                        } else {
                            errors.push(`Kein Match-Ergebnis für ${entry.homeTeam} vs ${entry.awayTeam}`);
                        }
                    } catch (err) {
                        const msg = `Fehler bei ${entry.homeTeam} vs ${entry.awayTeam}: ${err instanceof Error ? err.message : String(err)}`;
                        logger.warn(msg);
                        errors.push(msg);
                    }
                }
            } else {
                // Schritt 3b: Fallback – Swift-Methode: alle /bundesliga/team/.../saison-... Links
                // in Reihenfolge sammeln und als Paare (Heim, Gast) behandeln
                const teamLinks = this.extractMatchLinks($);

                if (teamLinks.length === 0) {
                    const allLinks: string[] = [];
                    $('a[href]').each((_, el) => {
                        const href = $(el).attr('href') ?? '';
                        if (href && !href.startsWith('#') && !href.startsWith('mailto:')) {
                            allLinks.push(href);
                        }
                    });
                    logger.warn(
                        { sample: allLinks.slice(0, 60) },
                        'Keine Team-Links gefunden. Alle Links (erste 60) zur Diagnose:'
                    );
                    errors.push('Keine Team-Links auf Spieltage-Seite gefunden');
                    return { matches: [], matchday: null, scrapedAt: new Date().toISOString(), errors };
                }

                logger.info(`Gefundene Team-Links (Fallback, paare werden gebildet): ${teamLinks.length}`);

                // Immer 2er-Paare bilden (Heim, Gast)
                for (let i = 0; i < teamLinks.length; i += 2) {
                    const homeUrl = teamLinks[i];
                    const awayUrl = teamLinks[i + 1] ?? null;
                    const entry: MatchEntry = {
                        homeTeam: '',   // wird durch scrapeMatchFromEntry aus der Seite gelesen
                        awayTeam: '',
                        homeLineupUrl: homeUrl,
                        awayLineupUrl: awayUrl,
                    };
                    try {
                        const match = await this.scrapeMatchFromEntry(entry);
                        if (match) {
                            matches.push(match);
                            logger.info(
                                {
                                    homeTeam: match.homeTeam,
                                    awayTeam: match.awayTeam,
                                    homeRows: match.homeLineup.length,
                                    awayRows: match.awayLineup.length,
                                },
                                'Spiel erfolgreich gescraped (Fallback)'
                            );
                        }
                    } catch (err) {
                        const msg = `Fehler bei ${homeUrl}: ${err instanceof Error ? err.message : String(err)}`;
                        logger.warn(msg);
                        errors.push(msg);
                    }

                    await this.sleep(400);
                }
            }

            logger.info(
                { matchCount: matches.length, errorCount: errors.length },
                'Lineup-Scraping abgeschlossen'
            );

            return {
                matches,
                matchday: null,
                scrapedAt: new Date().toISOString(),
                errors,
            };
        } catch (err) {
            const msg = `Kritischer Fehler beim Lineup-Scraping: ${err instanceof Error ? err.message : String(err)}`;
            logger.error(msg);
            errors.push(msg);
            return { matches: [], matchday: null, scrapedAt: new Date().toISOString(), errors };
        }
    }

    // =========================================================================
    // Schritt 2: Spiel-Links aus der Übersichtsseite extrahieren
    // =========================================================================

    private extractMatchLinks($: cheerio.CheerioAPI): string[] {
        const links = new Set<string>();

        // Strategie A: Team-Saison-Links mit /bundesliga/team/.../saison-...
        // Dieses Muster wird von Ligainsider für Spieler-/Aufstellungsseiten verwendet.
        // Die Übersichtsseite enthält pro Spiel 2 Links (Heim, Gast).
        $('a[href]').each((_, el) => {
            const href = $(el).attr('href') ?? '';
            if (!href || href.startsWith('#') || href.startsWith('mailto:')) return;

            const absolute = this.toAbsolute(href);

            // Ligainsider-Muster: /bundesliga/team/{team-slug}/{team-id}/saison-{year}/
            if (absolute.includes('/bundesliga/team/') && absolute.includes('/saison-')) {
                links.add(absolute);
            }
        });

        // Strategie B: Links in Match-Container-Elementen suchen (wenn Strategie A leer)
        if (links.size === 0) {
            const containerSelectors = [
                '.match a[href]',
                '.spiel a[href]',
                '.game a[href]',
                '.matchday-item a[href]',
                'article a[href]',
                '[class*="match"] a[href]',
                '[class*="spiel"] a[href]',
                '[class*="game"] a[href]',
            ];

            for (const sel of containerSelectors) {
                $(sel).each((_, el) => {
                    const href = $(el).attr('href') ?? '';
                    if (!href || href.startsWith('#')) return;
                    links.add(this.toAbsolute(href));
                });
                if (links.size > 0) {
                    logger.info(`Strategie B erfolgreich mit Selektor: ${sel}`);
                    break;
                }
            }
        }

        // Strategie C: Alle ligainsider.de-Links die nicht Navigation/Kader/etc. sind
        if (links.size === 0) {
            $('a[href]').each((_, el) => {
                const href = $(el).attr('href') ?? '';
                if (!href || href.startsWith('#')) return;
                const absolute = this.toAbsolute(href);
                // Nur interne Links, keine bekannten Non-Match-Pfade
                if (
                    absolute.startsWith(LigainsiderLineupScraper.BASE_URL) &&
                    !absolute.includes('/kader/') &&
                    !absolute.includes('/news/') &&
                    !absolute.includes('/forum/') &&
                    !absolute.includes('/login') &&
                    !absolute.includes('/registrier') &&
                    absolute !== LigainsiderLineupScraper.SPIELTAGE_URL &&
                    absolute !== LigainsiderLineupScraper.BASE_URL + '/'
                ) {
                    // Nur Links die wie eine Match- oder Spieler-Seite aussehen
                    const path = absolute.replace(LigainsiderLineupScraper.BASE_URL, '');
                    const segments = path.split('/').filter(Boolean);
                    // Match-Seiten haben typischerweise ≥ 2 Segmente und enthalten '-'
                    if (segments.length >= 2 && segments.some(s => s.includes('-'))) {
                        links.add(absolute);
                    }
                }
            });
            if (links.size > 0) {
                logger.info(`Strategie C: ${links.size} Links gefunden (unter Vorbehalt)`);
            }
        }

        return Array.from(links);
    }

    // =========================================================================
    // Schritt 3: Einzelne Spiel-Seite scrapen
    // =========================================================================

    private async scrapeMatchPage(matchUrl: string): Promise<LineupMatch | null> {
        const html = await this.fetchHtml(matchUrl);
        const $ = cheerio.load(html);

        // Teamnamen extrahieren
        const { homeTeam, awayTeam } = this.extractTeamNames($, matchUrl);

        if (!homeTeam || !awayTeam) {
            logger.warn({ matchUrl, title: $('title').text() }, 'Teamnamen nicht gefunden');
            // Debug: alle gefundenen Textinhalte von Headlines
            const headlines: string[] = [];
            $('h1, h2, h3').each((_, el) => { headlines.push($(el).text().trim()); });
            logger.debug({ headlines }, 'Gefundene Headlines auf Match-Seite');
            return null;
        }

        // Logos
        const homeLogo = this.extractLogo($, 'home');
        const awayLogo = this.extractLogo($, 'away');

        // Aufstellungen parsen
        const homeLineup = this.extractLineup($, 'home');
        const awayLineup = this.extractLineup($, 'away');

        // Debug: Lineup-Rohdaten loggen falls leer
        if (homeLineup.length === 0 || awayLineup.length === 0) {
            const aufstellungEls: string[] = [];
            $('[class*="aufstellung"], [class*="lineup"], [class*="formation"]').each((_, el) => {
                aufstellungEls.push(`${el.tagName}.${$(el).attr('class')}`);
            });
            logger.debug({ matchUrl, aufstellungEls }, 'Aufstellungs-Elemente auf Seite');
        }

        return {
            id: matchUrl,
            homeTeam,
            awayTeam,
            homeLogo: homeLogo ?? undefined,
            awayLogo: awayLogo ?? undefined,
            homeLineup,
            awayLineup,
        };
    }

    // =========================================================================
    // Hilfsmethoden: Teamnamen
    // =========================================================================

    private extractTeamNames(
        $: cheerio.CheerioAPI,
        matchUrl: string
    ): { homeTeam: string | null; awayTeam: string | null } {
        // Strategie 1: Explizite Home/Away Klassen
        const homeSelectors = [
            '.team-home .team-name',
            '.team-home span',
            '.home-team .name',
            '.home-team span',
            '.heim .team-name',
            '.heim span',
            '[class*="team-home"] span',
            '[class*="home"] .name',
        ];
        const awaySelectors = [
            '.team-away .team-name',
            '.team-away span',
            '.away-team .name',
            '.away-team span',
            '.gast .team-name',
            '.gast span',
            '[class*="team-away"] span',
            '[class*="away"] .name',
        ];

        const homeTeam = this.findText($, homeSelectors);
        const awayTeam = this.findText($, awaySelectors);
        if (homeTeam && awayTeam) return { homeTeam, awayTeam };

        // Strategie 2: Versus-Container
        const vsSelectors = [
            '.match-header',
            '.spiel-header',
            '.versus',
            '[class*="vs"]',
            '[class*="match-info"]',
        ];
        for (const sel of vsSelectors) {
            const container = $(sel).first();
            if (!container.length) continue;
            const teams = container.find('[class*="team"], .name, span, strong');
            if (teams.length >= 2) {
                const t1 = $(teams[0]).text().trim();
                const t2 = $(teams[1]).text().trim();
                if (t1 && t2 && t1 !== t2) return { homeTeam: t1, awayTeam: t2 };
            }
        }

        // Strategie 3: H1 / Seitentitel parsen (z.B. "FC Bayern vs. Bayer Leverkusen")
        const titleCandidates = [
            $('h1').first().text().trim(),
            $('title').text().trim(),
        ];
        for (const text of titleCandidates) {
            const match = text.match(/^(.+?)\s+(?:vs\.?|gegen|-|–)\s+(.+?)(?:\s*[-|]|$)/i);
            if (match) {
                return { homeTeam: match[1].trim(), awayTeam: match[2].trim() };
            }
        }

        // Strategie 4: URL-Slug parsen (letztmöglicher Fallback)
        // Beispiel: /bundesliga/spieltage/28-spieltag/bayer-leverkusen-vs-fc-augsburg/
        const urlMatch = matchUrl.match(/\/([a-z0-9-]+)\/?$/);
        if (urlMatch) {
            const slug = urlMatch[1];
            const vsSplit = slug.split(/-vs-|-gegen-/);
            if (vsSplit.length === 2) {
                const toName = (s: string) =>
                    s.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
                return { homeTeam: toName(vsSplit[0]), awayTeam: toName(vsSplit[1]) };
            }
        }

        return { homeTeam: null, awayTeam: null };
    }

    // =========================================================================
    // Hilfsmethoden: Logos
    // =========================================================================

    private extractLogo($: cheerio.CheerioAPI, side: 'home' | 'away'): string | null {
        const selectors =
            side === 'home'
                ? ['.team-home img', '.home-team img', '.heim img', '[class*="home"] img']
                : ['.team-away img', '.away-team img', '.gast img', '[class*="away"] img'];

        for (const sel of selectors) {
            const img = $(sel).first();
            const src = img.attr('src') ?? img.attr('data-src');
            if (src) return this.toAbsolute(src);
        }
        return null;
    }

    // =========================================================================
    // Hilfsmethoden: Aufstellung
    // =========================================================================

    private extractLineup($: cheerio.CheerioAPI, side: 'home' | 'away'): LineupRow[] {
        const containerSelectors =
            side === 'home'
                ? [
                    '.aufstellung.home',
                    '.lineup.home',
                    '.heim-aufstellung',
                    '.home-lineup',
                    '.heim .aufstellung',
                    '[class*="aufstellung"][class*="home"]',
                    '[class*="lineup"][class*="home"]',
                    '[class*="heim"][class*="aufstellung"]',
                ]
                : [
                    '.aufstellung.away',
                    '.lineup.away',
                    '.gast-aufstellung',
                    '.away-lineup',
                    '.gast .aufstellung',
                    '[class*="aufstellung"][class*="away"]',
                    '[class*="lineup"][class*="away"]',
                    '[class*="gast"][class*="aufstellung"]',
                ];

        for (const sel of containerSelectors) {
            const container = $(sel).first();
            if (!container.length) continue;
            const rows = this.parseLineupRows($, container);
            if (rows.length > 0) return rows;
        }

        // Fallback: Wenn beide Teams in generischen Containers sitzen,
        // den N-ten nehmen (home=0, away=1)
        const genericContainers = $(
            '.aufstellung, .lineup, [class*="aufstellung"], [class*="lineup"]'
        );
        const idx = side === 'home' ? 0 : 1;
        if (genericContainers.length > idx) {
            const rows = this.parseLineupRows($, $(genericContainers[idx]));
            if (rows.length > 0) return rows;
        }

        return [];
    }

    private parseLineupRows($: cheerio.CheerioAPI, container: cheerio.Cheerio<any>): LineupRow[] {
        const rows: LineupRow[] = [];

        // Reihen-Elemente suchen
        const rowSelectors = [
            '.row',
            '.lineup-row',
            '.aufstellung-row',
            '.reihe',
            '[class*="row"]',
            '[class*="reihe"]',
            'li',
            'ul > li',
        ];

        let rowEls: cheerio.Cheerio<any> | null = null;
        for (const sel of rowSelectors) {
            const found = container.find(sel);
            if (found.length > 0) {
                rowEls = found;
                break;
            }
        }

        // Fallback: direkte Kinder als Reihen
        if (!rowEls || rowEls.length === 0) {
            rowEls = container.children();
        }

        const defaultRowNames = ['Tor', 'Abwehr', 'Mittelfeld', 'Sturm', 'Mittelfeld 2'];

        rowEls.each((rowIdx, rowEl) => {
            const row$ = $(rowEl);
            const players = this.parsePlayers($, row$);
            if (players.length === 0) return;

            const rowName =
                row$.attr('data-position') ??
                (row$.find('[class*="position-label"], [class*="row-label"], [class*="reihe-label"]')
                    .first()
                    .text()
                    .trim() ||
                    defaultRowNames[rowIdx] ||
                    `Reihe ${rowIdx + 1}`);

            rows.push({ rowName, players });
        });

        return rows;
    }

    private parsePlayers($: cheerio.CheerioAPI, row$: cheerio.Cheerio<any>): LineupPlayer[] {
        const players: LineupPlayer[] = [];

        // Spieler-Elemente finden: Links mit Spieler-ID-Muster oder Spieler-Klassen
        const playerEls = row$.find(
            'a[href*="_"], .player, [class*="player"], [class*="spieler"]'
        );

        playerEls.each((_, el) => {
            const el$ = $(el);
            const href = el$.attr('href') ?? '';

            // Ligainsider Spieler-ID aus URL extrahieren (z.B. /manuel-neuer_1234/)
            const idMatch = href.match(/_(\d+)\/?(?:[?#].*)?$/);
            const ligainsiderId = idMatch ? idMatch[1] : undefined;

            // Spielername extrahieren
            const name =
                el$.find('.name, .player-name, span.name, span').first().text().trim() ||
                el$.text().trim();

            if (!name || name.length < 2) return;

            // Bild
            const img = el$.find('img').first();
            const rawSrc = img.attr('src') ?? img.attr('data-src');
            const imageUrl = rawSrc ? this.toAbsolute(rawSrc) : undefined;

            // Alternative (zweiter Spieler im selben Slot)
            const siblings = el$.siblings('a[href*="_"]');
            const alternative =
                siblings.length > 0 ? siblings.first().text().trim() || undefined : undefined;

            players.push({ name, ligainsiderId, imageUrl, alternative });
        });

        return players;
    }

    // =========================================================================
    // Utility
    // =========================================================================

    private findText($: cheerio.CheerioAPI, selectors: string[]): string | null {
        for (const sel of selectors) {
            const text = $(sel).first().text().trim();
            if (text) return text;
        }
        return null;
    }

    private toAbsolute(href: string): string {
        if (href.startsWith('http')) return href;
        if (href.startsWith('//')) return `https:${href}`;
        const path = href.startsWith('/') ? href : `/${href}`;
        return `${LigainsiderLineupScraper.BASE_URL}${path}`;
    }

    private sleep(ms: number): Promise<void> {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    private async fetchHtml(url: string): Promise<string> {
        let lastError: Error | null = null;

        for (let attempt = 1; attempt <= LigainsiderLineupScraper.MAX_RETRIES; attempt++) {
            try {
                const response = await this.httpClient.get<string>(url);
                return response.data;
            } catch (err) {
                lastError = err instanceof Error ? err : new Error(String(err));
                logger.warn(
                    { url, attempt, error: lastError.message },
                    `Fetch-Versuch ${attempt} fehlgeschlagen`
                );
                if (attempt < LigainsiderLineupScraper.MAX_RETRIES) {
                    await this.sleep(LigainsiderLineupScraper.RETRY_DELAY_MS * attempt);
                }
            }
        }

        throw lastError ?? new Error(`Konnte ${url} nicht laden`);
    }

    // =========================================================================
    // Neue primäre Extraktion: Match-Einträge aus leg_column-Tabellenstruktur
    // =========================================================================

    /**
     * Liest Match-Einträge direkt aus der Tabelle der Spieltage-Übersicht.
     *
     * Struktur pro Zeile:
     * - leg_column2: Heimteam-Link (href = Team-Saison-Seite mit Aufstellung)
     * - leg_column4: Auswärtsteam-Link (href = Team-Saison-Seite mit Aufstellung)
     * - leg_column6: Alternative Lineup-Links (Fallback)
     *
     * Die Team-Links in leg_column2 / leg_column4 folgen dem Muster:
     * /bundesliga/team/{slug}/{id}/saison-{year}/{match-id}/
     * und sind dieselben Seiten, die die Swift-App zum Scrapen der Aufstellung nutzt.
     */
    private extractMatchEntriesFromTable($: cheerio.CheerioAPI): MatchEntry[] {
        const entries: MatchEntry[] = [];
        const processed = new Set<string>();

        $('[class*="leg_column2"]').each((_, el) => {
            const el$ = $(el);
            const row$ = el$.parent();

            // Header-Zeile überspringen
            const homeLink = el$.find('a[href]').first();
            const homeTeamRaw = homeLink.text().trim() || el$.text().trim();
            if (!homeTeamRaw || homeTeamRaw === 'Heimteam') return;

            // Doppelten Teamnamen normalisieren ("RB Leipzig RB Leipzig" → "RB Leipzig")
            const homeTeam = this.deduplicateTeamName(homeTeamRaw);
            const homeLineupUrl = homeLink.attr('href')
                ? this.toAbsolute(homeLink.attr('href')!)
                : null;

            // Auswärtsteam aus leg_column4
            const awayEl = row$.find('[class*="leg_column4"]');
            const awayLink = awayEl.find('a[href]').first();
            const awayTeamRaw = awayLink.text().trim() || awayEl.text().trim();
            if (!awayTeamRaw || awayTeamRaw === 'Auswärtsteam') return;

            const awayTeam = this.deduplicateTeamName(awayTeamRaw);
            const awayLineupUrl = awayLink.attr('href')
                ? this.toAbsolute(awayLink.attr('href')!)
                : null;

            // Fallback: leg_column6 für alternative Lineup-Links
            let finalHomeUrl = homeLineupUrl;
            let finalAwayUrl = awayLineupUrl;
            const linksEl = row$.find('[class*="leg_column6"]');
            if (!finalHomeUrl || !finalAwayUrl) {
                const col6hrefs: string[] = [];
                linksEl.find('a[href]').each((_, linkEl) => {
                    const href = $(linkEl).attr('href');
                    if (href) col6hrefs.push(this.toAbsolute(href));
                });
                if (!finalHomeUrl && col6hrefs[0]) finalHomeUrl = col6hrefs[0];
                if (!finalAwayUrl && col6hrefs[1]) finalAwayUrl = col6hrefs[1];
            }

            const key = `${homeTeam}|${awayTeam}`;
            if (processed.has(key)) return;
            processed.add(key);

            logger.debug(
                { homeTeam, awayTeam, homeLineupUrl: finalHomeUrl, awayLineupUrl: finalAwayUrl },
                'Match-Eintrag aus Tabelle extrahiert'
            );

            entries.push({
                homeTeam,
                awayTeam,
                homeLineupUrl: finalHomeUrl,
                awayLineupUrl: finalAwayUrl,
            });
        });

        if (entries.length === 0) {
            const legCols: string[] = [];
            $('[class*="leg_column"]').each((_, el) => {
                legCols.push(`${el.tagName}.${$(el).attr('class')}`);
            });
            logger.warn(
                { sample: legCols.slice(0, 30) },
                'Keine Match-Einträge via leg_column gefunden. Gefundene leg_column-Elemente zur Diagnose:'
            );
        }

        return entries;
    }

    /** Entfernt doppelten Teamnamen ("RB Leipzig RB Leipzig" → "RB Leipzig") */
    private deduplicateTeamName(raw: string): string {
        const trimmed = raw.trim();
        const half = Math.floor(trimmed.length / 2);
        const first = trimmed.slice(0, half).trim();
        const second = trimmed.slice(half).trim();
        if (first && second && (first === second || second.startsWith(first))) {
            return first;
        }
        return trimmed;
    }

    // =========================================================================
    // Match-Scraping aus strukturiertem Eintrag (per-Team-Links)
    // =========================================================================

    /**
     * Scraped Heim- und Gastaufstellung über die per-Team-URLs aus dem MatchEntry
     * und kombiniert beides zu einem LineupMatch.
     */
    private async scrapeMatchFromEntry(entry: MatchEntry): Promise<LineupMatch | null> {
        let homeLineup: LineupRow[] = [];
        let awayLineup: LineupRow[] = [];
        let homeLogo: string | undefined;
        let awayLogo: string | undefined;
        let homeTeam = entry.homeTeam;
        let awayTeam = entry.awayTeam;

        if (entry.homeLineupUrl) {
            try {
                const result = await this.scrapeTeamLineupPage(entry.homeLineupUrl);
                homeLineup = result.lineup;
                homeLogo = result.logo;
                if (!homeTeam && result.teamName) homeTeam = result.teamName;
                logger.info(
                    { url: entry.homeLineupUrl, team: homeTeam, rows: homeLineup.length },
                    'Heimaufstellung gescraped'
                );
            } catch (err) {
                logger.warn(
                    { url: entry.homeLineupUrl, err: String(err) },
                    'Fehler beim Scrapen der Heimaufstellung'
                );
            }
        }

        await this.sleep(400);

        if (entry.awayLineupUrl) {
            try {
                const result = await this.scrapeTeamLineupPage(entry.awayLineupUrl);
                awayLineup = result.lineup;
                awayLogo = result.logo;
                if (!awayTeam && result.teamName) awayTeam = result.teamName;
                logger.info(
                    { url: entry.awayLineupUrl, team: awayTeam, rows: awayLineup.length },
                    'Gastaufstellung gescraped'
                );
            } catch (err) {
                logger.warn(
                    { url: entry.awayLineupUrl, err: String(err) },
                    'Fehler beim Scrapen der Gastaufstellung'
                );
            }
        }

        return {
            id: entry.homeLineupUrl ?? entry.awayLineupUrl ?? `${homeTeam}-${awayTeam}`,
            homeTeam,
            awayTeam,
            homeLogo,
            awayLogo,
            homeLineup,
            awayLineup,
        };
    }

    /**
     * Scraped die Aufstellung von einer Team-spezifischen Ligainsider-Seite.
     *
     * Basiert auf der bewährten Swift-Implementierung:
     * 1. Suche nach "VORAUSSICHTLICHE AUFSTELLUNG" / "Voraussichtliche Aufstellung" als Marker
     * 2. Splitte danach nach `player_position_row` (eine Zeile pro Reihe)
     * 3. Pro Reihe splitte nach `player_position_column` (eine Spalte pro Spieler)
     * 4. Spieler-Slugs via href="/name_12345/" Pattern extrahieren
     */
    private async scrapeTeamLineupPage(
        url: string
    ): Promise<{ lineup: LineupRow[]; logo: string | undefined; teamName: string | undefined }> {
        const html = await this.fetchHtml(url);

        logger.debug({ url, title: html.match(/<title[^>]*>([^<]*)<\/title>/i)?.[1] ?? '' }, 'Team-Lineup-Seite geladen');

        // Teamnamen extrahieren: <h2 ... itemprop="name">Team Name</h2>
        let teamName: string | undefined;
        const nameComponents = html.split('itemprop="name"');
        if (nameComponents.length > 1) {
            const afterMarker = nameComponents[1];
            const nameMatch = afterMarker.match(/>([^<]+)<\/h[1-3]>/);
            if (nameMatch) teamName = nameMatch[1].trim();
        }
        // Fallback: Seitentitel
        if (!teamName) {
            const titleMatch = html.match(/<title[^>]*>([^<|]+)/);
            if (titleMatch) teamName = titleMatch[1].trim();
        }

        // Team-Logo: Bild innerhalb des Vereins-Links auf der Team-Seite.
        // Die Team-URL hat die Form: /bundesliga/team/{slug}/{id}/saison-.../
        // Der Vereins-Link auf der Seite lautet: href="/{slug}/{id}/"
        // Wir halten uns an diesen Ansatz statt nach "wappen" zu suchen,
        // damit immer das richtige Vereinslogo geholt wird.
        let logo: string | undefined;
        const teamPathMatch = url.match(/\/bundesliga\/team\/([a-z0-9-]+\/\d+)\//);
        if (teamPathMatch) {
            const teamHref = `/${teamPathMatch[1]}/`;
            // Suche <a href="{teamHref}"> oder <a href="{teamHref}"  (mit Attributen)
            const linkIdx = html.indexOf(`href="${teamHref}"`);
            if (linkIdx !== -1) {
                // Nimm das HTML-Stück ab dem Link-Öffner bis zum </a>
                const linkStart = html.lastIndexOf('<a ', linkIdx);
                const linkEnd = html.indexOf('</a>', linkIdx);
                if (linkStart !== -1 && linkEnd !== -1) {
                    const linkHtml = html.slice(linkStart, linkEnd + 4);
                    const srcMatch = linkHtml.match(/src="([^"]+)"/);
                    if (srcMatch) logo = srcMatch[1];
                }
            }
        }
        // Fallback: erstes Wappen-Bild das ligainsider.de enthält
        if (!logo) {
            const wappenMatch = html.match(/src="([^"]*ligainsider\.de[^"]*(wappen|images\/teams)[^"]*)"/i);
            if (wappenMatch) logo = wappenMatch[1];
        }

        // Abschnitts-Marker für die voraussichtliche Aufstellung
        const headerMarkers = ['VORAUSSICHTLICHE AUFSTELLUNG', 'Voraussichtliche Aufstellung'];
        let contentStart: string | null = null;
        for (const marker of headerMarkers) {
            const idx = html.indexOf(marker);
            if (idx !== -1) {
                contentStart = html.slice(idx + marker.length);
                logger.debug({ url, marker }, 'Aufstellungsmarker gefunden');
                break;
            }
        }

        if (!contentStart) {
            logger.warn({ url }, 'Kein "VORAUSSICHTLICHE AUFSTELLUNG" Marker gefunden');
            return { lineup: [], logo, teamName };
        }

        // Auf 100 000 Zeichen begrenzen; Legende abschneiden
        let searchArea = contentStart.slice(0, 100_000);
        const legendIdx = searchArea.indexOf('Spieler stand in der Startelf');
        if (legendIdx !== -1) searchArea = searchArea.slice(0, legendIdx);

        const formationRows: LineupRow[] = [];

        // Nach player_position_row splitten
        const rowParts = searchArea.split('player_position_row');

        if (rowParts.length <= 1) {
            // Fallback: gesamten Bereich nach Spieler-Links scannen
            logger.info({ url }, 'player_position_row nicht gefunden – Fallback auf Link-Scan');
            const fallbackPlayers = this.parsePlayersFromHtml(searchArea);
            if (fallbackPlayers.length > 0) {
                formationRows.push({ rowName: 'Aufstellung', players: fallbackPlayers });
            }
        } else {
            const defaultRowNames = ['Tor', 'Abwehr', 'Mittelfeld', 'Sturm', 'Mittelfeld 2'];

            for (let i = 1; i < rowParts.length; i++) {
                const rowHtml = rowParts[i];
                if (!rowHtml.includes('player_position_column')) continue;

                const colParts = rowHtml.split('player_position_column');
                const currentRowPlayers: LineupPlayer[] = [];

                for (let j = 1; j < colParts.length; j++) {
                    const colHtml = colParts[j];
                    const playersInCol = this.parsePlayersFromColumnHtml(colHtml);
                    if (playersInCol.length === 0) continue;

                    const mainPlayer = playersInCol[0];
                    if (playersInCol.length > 1) {
                        mainPlayer.alternative = playersInCol[1].name;
                    }
                    currentRowPlayers.push(mainPlayer);
                }

                if (currentRowPlayers.length > 0) {
                    formationRows.push({
                        rowName: defaultRowNames[i - 1] ?? `Reihe ${i}`,
                        players: currentRowPlayers,
                    });
                }
            }
        }

        logger.info({ url, teamName, rows: formationRows.length }, 'Team-Lineup gescraped');
        return { lineup: formationRows, logo, teamName };
    }

    /**
     * Extrahiert Spieler aus dem HTML einer `player_position_column`.
     * Entspricht der Swift-Logik: href="/name_12345/" → Slug + Name + Bild.
     */
    private parsePlayersFromColumnHtml(colHtml: string): LineupPlayer[] {
        const players: LineupPlayer[] = [];
        const seen = new Set<string>();

        // Alle Bild-URLs in dieser Spalte sammeln (für späteres Matching)
        const imageUrls: string[] = [];
        const imgSrcRegex = /src="([^"]*ligainsider\.de[^"]*\/player\/team\/[^"]*)"/g;
        let imgMatch: RegExpExecArray | null;
        while ((imgMatch = imgSrcRegex.exec(colHtml)) !== null) {
            imageUrls.push(imgMatch[1]);
        }

        // Links splitten und parsen
        const linkParts = colHtml.split('<a ');
        const usedImageIndices = new Set<number>();

        for (let k = 1; k < linkParts.length; k++) {
            const linkPart = linkParts[k];

            // Slug extrahieren: href="/name_12345/" oder href="/name_12345"
            const hrefMatch = linkPart.match(/href="\/([^"?\/][^"]*?)(?:\/)?"/);
            if (!hrefMatch) continue;
            const slug = hrefMatch[1];

            // Slug muss Underscore + Zahl-Suffix haben
            if (!slug.includes('_')) continue;
            if (slug.includes('/')) continue;
            if (!/\d$/.test(slug)) continue;

            // Name extrahieren: zwischen > und </a>
            const nameEndIdx = linkPart.indexOf('</a>');
            if (nameEndIdx === -1) continue;
            const startIdx = linkPart.indexOf('>');
            if (startIdx === -1 || startIdx >= nameEndIdx) continue;
            const rawName = linkPart.slice(startIdx + 1, nameEndIdx);
            const name = this.stripHtmlTags(rawName).trim();
            if (!name || name.length > 50 || seen.has(name)) continue;
            seen.add(name);

            // Bild suchen: erst exaktes Slug-Matching, dann Index-Fallback
            let imageUrl: string | undefined;
            let matchedIndex: number | undefined;
            let firstAvailableIndex: number | undefined;
            const slugNamePart = slug.split('_')[0];

            for (let idx = 0; idx < imageUrls.length; idx++) {
                if (usedImageIndices.has(idx)) continue;
                if (firstAvailableIndex === undefined) firstAvailableIndex = idx;
                if (imageUrls[idx].includes(slugNamePart)) {
                    imageUrl = imageUrls[idx];
                    matchedIndex = idx;
                    break;
                }
            }
            if (imageUrl === undefined && firstAvailableIndex !== undefined) {
                imageUrl = imageUrls[firstAvailableIndex];
                matchedIndex = firstAvailableIndex;
            }
            if (matchedIndex !== undefined) usedImageIndices.add(matchedIndex);

            players.push({ name, ligainsiderId: slug, imageUrl });
        }

        return players;
    }

    /**
     * Fallback: Scannt einen beliebigen HTML-Bereich nach Spieler-Links.
     */
    private parsePlayersFromHtml(html: string): LineupPlayer[] {
        const players: LineupPlayer[] = [];
        const seen = new Set<string>();
        const linkParts = html.split('<a ');

        for (let k = 1; k < linkParts.length; k++) {
            const linkPart = linkParts[k];
            const hrefMatch = linkPart.match(/href="\/([^"?\/][^"]*?)(?:\/)?"/);
            if (!hrefMatch) continue;
            const slug = hrefMatch[1];
            if (!slug.includes('_') || slug.includes('/') || !/\d$/.test(slug)) continue;

            const nameEndIdx = linkPart.indexOf('</a>');
            if (nameEndIdx === -1) continue;
            const startIdx = linkPart.indexOf('>');
            if (startIdx === -1 || startIdx >= nameEndIdx) continue;
            const name = this.stripHtmlTags(linkPart.slice(startIdx + 1, nameEndIdx)).trim();
            if (!name || name.length > 50 || seen.has(name)) continue;
            seen.add(name);

            players.push({ name, ligainsiderId: slug });
        }

        return players;
    }

    private stripHtmlTags(html: string): string {
        let result = '';
        let insideTag = false;
        for (const char of html) {
            if (char === '<') insideTag = true;
            else if (char === '>') insideTag = false;
            else if (!insideTag) result += char;
        }
        return result;
    }
}
