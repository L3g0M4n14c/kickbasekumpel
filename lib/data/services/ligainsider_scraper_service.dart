/// ⚠️ DEPRECATED: Dieser Service ist veraltet
///
/// Version: ARCHIVED (nicht mehr in Verwendung)
/// Migration: Februar 2026
///
/// Die Scraper-Logik wurde zur Google Cloud Function migriert:
/// - **Backend Location**: `functions/src/ligainsider-scraper.ts` (Node.js/TypeScript)
/// - **Trigger**: Cloud Scheduler (täglich 02:00 UTC)
/// - **Dokumentation**: [CLOUD_FUNCTIONS_SETUP.md](../../docs/CLOUD_FUNCTIONS_SETUP.md)
///
/// Die Flutter App triggert nur noch die Cloud Function über:
/// ```dart
/// final result = await playerRepository.triggerCloudFunctionPhotoUpdate();
/// ```
///
/// Siehe auch:
/// - [CLOUD_FUNCTIONS_MIGRATION.md](../../CLOUD_FUNCTIONS_MIGRATION.md) - Migrations-Übersicht
/// - [lib/data/providers/ligainsider_photo_provider.dart](../providers/ligainsider_photo_provider.dart) - Neuer Provider
/// - [lib/data/repositories/firestore_repositories.dart](../repositories/firestore_repositories.dart) - Neue Methode
///
/// Diese Datei bleibt zur Referenz, wird aber nicht mehr verwendet.
library deprecated_ligainsider_scraper;

// ============================================================================
// ARCHIVIERTE KLASSE - NICHT MEHR IN VERWENDUNG
// ============================================================================

/// @deprecated Verwende stattdessen `PlayerRepository.triggerCloudFunctionPhotoUpdate()`
@Deprecated(
  'Migrated to Cloud Functions. Use PlayerRepository.triggerCloudFunctionPhotoUpdate() instead. '
  'Siehe CLOUD_FUNCTIONS_MIGRATION.md für Details.',
)
class LigainsiderScraperService {
  @Deprecated('Not used anymore')
  final dummy = null;
}
