/**
 * TypeScript Type Definitions für Ligainsider Scraper
 */

export interface TeamKaderLink {
    teamName: string;
    kaderUrl: string;
}

export interface PlayerPhoto {
    normalizedName: string;
    name: string;
    photoUrl: string;
}

export interface FirestorePlayer {
    id: string;
    firstName: string;
    lastName: string;
    profileBigUrl: string;
    [key: string]: any;
}

export interface ScraperResult {
    teamPhotos: Map<string, string>; // normalizedName -> photoUrl
    totalTeams: number;
    totalPhotos: number;
    errors: string[];
}

// ============================================================================
// Lineup / Match Aufstellung Types
// ============================================================================

/** Einzelner Spieler in einer Aufstellungszeile */
export interface LineupPlayer {
    name: string;
    ligainsiderId?: string;
    imageUrl?: string;
    alternative?: string;
}

/** Aufstellungszeile (z.B. Tor, Abwehr, Mittelfeld, Sturm) */
export interface LineupRow {
    rowName: string;
    players: LineupPlayer[];
}

/** Einzelnes Spiel mit Heim- und Gastaufstellung */
export interface LineupMatch {
    id: string;
    homeTeam: string;
    awayTeam: string;
    homeLogo?: string;
    awayLogo?: string;
    homeLineup: LineupRow[];
    awayLineup: LineupRow[];
}

/** Ergebnis des Lineup-Scrapers */
export interface LineupScraperResult {
    matches: LineupMatch[];
    matchday: number | null;
    scrapedAt: string;
    errors: string[];
}
