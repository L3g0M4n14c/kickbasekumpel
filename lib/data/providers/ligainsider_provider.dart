import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// FutureProvider to fetch and initialize Ligainsider data
///
/// Lädt die Aufstellungsdaten cache-first (siehe
/// `LigainsiderService.ensureLoaded`).
///
/// Verwendung:
/// ```dart
/// ref.watch(ligainsiderInitProvider); // Triggers fetch
/// ```
final ligainsiderInitProvider = FutureProvider<void>((ref) async {
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  await service.ensureLoaded();
});

/// Lädt die Ligainsider-Daten beim App-Start im Hintergrund vor.
///
/// Wird in `main.dart` direkt beim App-Start gelesen. Damit liegen die
/// voraussichtlichen Aufstellungen bereits vor, wenn der Nutzer die
/// Aufstellungs-Empfehlung öffnet – vorher fehlten die Daten dort komplett
/// („Fehlt“ bei allen Spielern), weil erst beim Öffnen des Screens gescraped
/// wurde.
///
/// Läuft bewusst nicht blockierend und schluckt Fehler: der Preload ist ein
/// Komfort-Feature und darf den App-Start nie stören.
final ligainsiderPreloadProvider = FutureProvider<void>((ref) async {
  // Service-Future einmalig auflösen – kein `ref` mehr nach einem möglichen
  // Dispose des Providers verwenden.
  final serviceFuture = ref.watch(ligainsiderServiceFutureProvider.future);

  try {
    final service = await serviceFuture;
    await service.ensureLoaded();
  } catch (e) {
    debugPrint('⚠️ Ligainsider-Preload (Aufstellungen) fehlgeschlagen: $e');
  }

  // Cloud-Function-Aufstellungen (Firestore-Cache, 2 h) im Hintergrund wärmen.
  try {
    unawaited(
      _prefetchCloudLineups(ref.read(ligainsiderMatchesProvider.future)),
    );
  } catch (e) {
    debugPrint('⚠️ Ligainsider: Cloud-Aufstellungen nicht verfügbar: $e');
  }
});

/// Erzwingt ein Neuladen der Ligainsider-Aufstellungen.
///
/// Für manuelle Refresh-Buttons (z. B. Live-Screen). Im Unterschied zu
/// [ligainsiderPreloadProvider] wird der Cache-Frischecheck übersprungen und
/// die Cloud-Function-Aufstellungen werden neu geladen.
final ligainsiderReloadProvider = FutureProvider<void>((ref) async {
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  await service.ensureLoaded(forceRefresh: true);
  ref.invalidate(ligainsiderMatchesProvider);
});

/// Wärmt die Cloud-Function-Aufstellungen (Fehler werden geschluckt).
Future<void> _prefetchCloudLineups(
  Future<List<LigainsiderMatch>> matchesFuture,
) async {
  try {
    await matchesFuture;
  } catch (e) {
    debugPrint('⚠️ Ligainsider: Cloud-Aufstellungen fehlgeschlagen: $e');
  }
}

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
