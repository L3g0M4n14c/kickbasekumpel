import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/ligainsider_service.dart';
import 'kickbase_api_provider.dart';

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
  final service = ref.watch(ligainsiderServiceProvider);
  await service.fetchLineups();
});
