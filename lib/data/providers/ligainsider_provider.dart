import 'package:connectivity_plus/connectivity_plus.dart';
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
/// This will automatically fetch lineups when first accessed.
///
/// Verwendung:
/// ```dart
/// ref.watch(ligainsiderInitProvider); // Triggers fetch
/// ```
final ligainsiderInitProvider = FutureProvider<void>((ref) async {
  // Use the async provider that initializes SharedPreferences internally
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  await service.fetchLineups();
  // Also try to fetch match lineups in background
  service.fetchMatchLineups();
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
