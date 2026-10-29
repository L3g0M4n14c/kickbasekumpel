import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ligainsider_lineup_index.dart';
import '../services/ligainsider_service.dart';
import '../models/ligainsider_match_model.dart';
import '../repositories/firestore_repositories.dart';
import '../../domain/repositories/repository_interfaces.dart';

import 'service_providers.dart';

// ============================================================================
// Ligainsider Service Provider
// ============================================================================

/// Provider for Connectivity
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider for LigainsiderService
///
/// Scrapes ligainsider.de for player injury and lineup data.
/// Provides caching and offline support.
///
/// Verwendung:
/// ```dart
/// final serviceAsync = await ref.watch(ligainsiderServiceFutureProvider.future);
/// await serviceAsync.fetchLineups();
/// final player = serviceAsync.getLigainsiderPlayer('Max', 'Mustermann');
/// final status = serviceAsync.getPlayerStatus('Max', 'Mustermann');
/// ```
///
/// Note: This provider uses async initialization. Use ligainsiderServiceFutureProvider instead.
@Deprecated(
  'Use ligainsiderServiceFutureProvider for proper async initialization',
)
final ligainsiderServiceProvider = Provider<LigainsiderService>((ref) {
  throw UnimplementedError(
    'Use ligainsiderServiceFutureProvider instead for proper async initialization',
  );
});

/// Provider to check if Ligainsider service is ready
///
/// Verwendung:
/// ```dart
/// final isReadyAsync = ref.watch(ligainsiderReadyProvider);
/// isReadyAsync.when(
///   data: (isReady) => ...,
///   loading: () => ...,
///   error: (err, stack) => ...,
/// );
/// ```
final ligainsiderReadyProvider = FutureProvider<bool>((ref) async {
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  return service.isReady;
});

/// Provider to get player cache count (for debugging)
final ligainsiderCacheCountProvider = FutureProvider<int>((ref) async {
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  return service.playerCacheCount;
});

/// FutureProvider to initialize cached Ligainsider data
///
/// Lädt ausschließlich den persistenten Cache (kein Netzwerk). Der aktuelle
/// Stand kommt über [ligainsiderLineupIndexProvider] (Cloud Function); der
/// lokale Scrape ist nur Fallback.
///
/// Verwendung:
/// ```dart
/// ref.watch(ligainsiderInitProvider); // Triggers cache load
/// ```
final ligainsiderInitProvider = FutureProvider<void>((ref) async {
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  await service.loadCached();
});

/// Baut den Status-Index der voraussichtlichen Aufstellungen.
///
/// Primär aus der Cloud Function (`getLigainsiderLineups`, Firestore-Cache
/// 2 h) – die scraped serverseitig und funktioniert auch im Web. Nur wenn dort
/// keine vollständigen Daten vorliegen, wird der lokale Scrape genutzt.
final ligainsiderLineupIndexProvider =
    FutureProvider<LigainsiderLineupIndex>((ref) async {
      // 1) Cloud Function – schnell, wenn der Firestore-Cache warm ist.
      try {
        final matches = await ref.watch(ligainsiderMatchesProvider.future);
        final index = LigainsiderLineupIndex.fromMatches(matches);
        if (index.hasCoverage) {
          debugPrint(
            '✅ Ligainsider: Cloud-Aufstellungen geladen '
            '(${matches.length} Spiele)',
          );
          return index;
        }
        debugPrint(
          'ℹ️ Ligainsider: Cloud-Aufstellungen unvollständig '
          '(${matches.length} Spiele) – nutze lokalen Fallback',
        );
      } catch (e) {
        debugPrint('⚠️ Ligainsider: Cloud-Aufstellungen fehlgeschlagen: $e');
      }

      // 2) Fallback: lokaler Scrape (cache-first, siehe ensureLoaded).
      try {
        final service = await ref.watch(ligainsiderServiceFutureProvider.future);
        await service.ensureLoaded();
        return LigainsiderLineupIndex.fromService(service);
      } catch (e) {
        debugPrint('⚠️ Ligainsider: Lokale Aufstellungen fehlgeschlagen: $e');
      }

      return LigainsiderLineupIndex.empty();
    });

/// Lädt die Ligainsider-Aufstellungen beim App-Start im Hintergrund vor.
///
/// Wird in `main.dart` direkt beim App-Start gelesen. Damit liegen die
/// voraussichtlichen Aufstellungen bereits vor, wenn der Nutzer die
/// Aufstellungs-Empfehlung öffnet – vorher fehlten die Daten dort komplett
/// („Fehlt“ bei allen Spielern), weil erst beim Öffnen des Screens geladen
/// wurde.
///
/// Läuft bewusst nicht blockierend und schluckt Fehler: der Preload ist ein
/// Komfort-Feature und darf den App-Start nie stören.
final ligainsiderPreloadProvider = FutureProvider<void>((ref) async {
  try {
    final index = await ref.watch(ligainsiderLineupIndexProvider.future);
    debugPrint(
      index.hasCoverage
          ? '✅ Ligainsider-Preload: Aufstellungen geladen'
          : 'ℹ️ Ligainsider-Preload: keine vollständigen Aufstellungen',
    );
  } catch (e) {
    debugPrint('⚠️ Ligainsider-Preload fehlgeschlagen: $e');
  }
});

/// Erzwingt ein Neuladen der Ligainsider-Aufstellungen.
///
/// Für manuelle Refresh-Buttons (z. B. Live-Screen). Im Unterschied zu
/// [ligainsiderPreloadProvider] wird der Cache-Frischecheck übersprungen und
/// die Cloud-Function-Aufstellungen werden neu geladen.
final ligainsiderReloadProvider = FutureProvider<void>((ref) async {
  ref.invalidate(ligainsiderMatchesProvider);

  try {
    final service = await ref.watch(ligainsiderServiceFutureProvider.future);
    await service.ensureLoaded(forceRefresh: true);
  } catch (e) {
    debugPrint('⚠️ Ligainsider: lokales Neuladen fehlgeschlagen: $e');
  }

  ref.invalidate(ligainsiderLineupIndexProvider);
});

/// Provider exposing parsed match lineups
///
/// Ruft die `getLigainsiderLineups` Cloud Function auf.
/// Die Function cached Ergebnisse 2 Stunden in Firestore – sofortige Rückgabe
/// bei frischem Cache, ansonsten wird Ligainsider.de neu gescraped.
///
/// Verwendung:
/// ```dart
/// final matchesAsync = ref.watch(ligainsiderMatchesProvider);
/// matchesAsync.when(
///   data: (matches) => ...,
///   loading: () => ...,
///   error: (err, _) => ...,
/// );
/// ```
final ligainsiderMatchesProvider = FutureProvider<List<LigainsiderMatch>>((
  ref,
) async {
  final playerRepository = ref.watch(playerRepositoryProvider);
  final result = await playerRepository.fetchLigainsiderLineups();
  return switch (result) {
    Success(data: final matches) => matches,
    Failure(message: final msg) => throw Exception(msg),
  };
});
