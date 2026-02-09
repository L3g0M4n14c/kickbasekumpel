import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ligainsider_service.dart';
import '../models/ligainsider_match_model.dart';

import 'service_providers.dart';
// 'kickbase_api_provider.dart' is not required here and would conflict with imports

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
final ligainsiderMatchesProvider = FutureProvider<List<LigainsiderMatch>>((
  ref,
) async {
  // Use async service provider to ensure SharedPreferences is available
  final service = await ref.watch(ligainsiderServiceFutureProvider.future);
  // Ensure initial player fetch is triggered
  await ref.watch(ligainsiderInitProvider.future);

  // Try to fetch matches (may be cached)
  await service.fetchMatchLineups();
  return service.matches;
});
