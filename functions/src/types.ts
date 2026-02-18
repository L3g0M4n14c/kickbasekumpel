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
