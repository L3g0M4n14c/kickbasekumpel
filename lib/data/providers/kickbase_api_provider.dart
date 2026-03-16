import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/demo_kickbase_api_client.dart';
import '../services/kickbase_api_client.dart';
import 'demo_mode_provider.dart';
import 'service_providers.dart';

// ============================================================================
// Kickbase API Client Provider
// ============================================================================

/// Provider für KickbaseAPIClient
///
/// Gibt im Demo-Modus einen [DemoKickbaseAPIClient] zurück, der statische
/// Demodaten liefert, ohne die echte Kickbase-API zu kontaktieren.
/// Im Normalbetrieb wird der echte [KickbaseAPIClient] verwendet.
///
/// Verwendung:
/// ```dart
/// final apiClient = ref.watch(kickbaseApiClientProvider);
/// final user = await apiClient.getUser();
/// ```
final kickbaseApiClientProvider = Provider<KickbaseAPIClient>((ref) {
  final isDemoMode = ref.watch(demoModeProvider);

  if (isDemoMode) {
    return DemoKickbaseAPIClient();
  }

  final httpClient = ref.watch(httpClientProvider);
  final client = KickbaseAPIClient(httpClient: httpClient);
  ref.onDispose(() => client.dispose());
  return client;
});

// ============================================================================
// Helper Providers
// ============================================================================

/// Provider to check if Kickbase token exists
///
/// Verwendung:
/// ```dart
/// final hasToken = await ref.watch(hasKickbaseTokenProvider.future);
/// ```
final hasKickbaseTokenProvider = FutureProvider<bool>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.hasAuthToken();
});

/// Provider to get current Kickbase token
///
/// Verwendung:
/// ```dart
/// final token = await ref.watch(kickbaseTokenProvider.future);
/// ```
final kickbaseTokenProvider = FutureProvider<String?>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.getAuthToken();
});
