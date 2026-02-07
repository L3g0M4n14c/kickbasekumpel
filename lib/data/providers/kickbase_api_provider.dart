import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/kickbase_api_client.dart';

// ============================================================================
// Kickbase API Client Provider
// ============================================================================

/// Provider für HTTP Client (shared instance)
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Provider für KickbaseAPIClient
///
/// Der API Client verwaltet alle HTTP-Anfragen an die Kickbase API v4.
/// Nutzt SharedPreferences für Token-Storage.
///
/// Verwendung:
/// ```dart
/// final apiClient = ref.watch(kickbaseApiClientProvider);
/// final user = await apiClient.getUser();
/// ```
final kickbaseApiClientProvider = Provider<KickbaseAPIClient>((ref) {
  final httpClient = ref.watch(httpClientProvider);

  final client = KickbaseAPIClient(httpClient: httpClient);

  // Cleanup when provider is disposed
  ref.onDispose(() {
    client.dispose();
  });

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
