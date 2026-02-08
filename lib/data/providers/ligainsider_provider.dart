import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
/// final service = ref.watch(ligainsiderServiceProvider);
/// await service.fetchLineups();
/// final player = service.getLigainsiderPlayer('Max', 'Mustermann');
/// final status = service.getPlayerStatus('Max', 'Mustermann');
/// ```
final ligainsiderServiceProvider = Provider<LigainsiderService>((ref) {
  // Reuse shared providers
  final httpClient = ref.watch(httpClientProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  final connectivity = ref.watch(connectivityProvider);

  return LigainsiderService(
    httpClient: httpClient,
    prefs: sharedPrefs,
    connectivity: connectivity,
  );
});

/// Provider for SharedPreferences (shared instance)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a real instance',
  );
});

/// Provider to check if Ligainsider service is ready
///
/// Verwendung:
/// ```dart
/// final isReady = ref.watch(ligainsiderReadyProvider);
/// if (isReady) {
///   // Use service
/// }
/// ```
final ligainsiderReadyProvider = Provider<bool>((ref) {
  final service = ref.watch(ligainsiderServiceProvider);
  return service.isReady;
});

/// Provider to get player cache count (for debugging)
final ligainsiderCacheCountProvider = Provider<int>((ref) {
  final service = ref.watch(ligainsiderServiceProvider);
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
