import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/http_client_wrapper.dart';
import '../services/kickbase_api_client.dart';
import '../services/ligainsider_service.dart';

// ============================================================================
// Service Providers - Central Export
// ============================================================================

/// HTTP Client Provider (Singleton)
///
/// Stellt einen shared http.Client für alle Services bereit.
/// Wird automatisch beim Dispose geschlossen.
///
/// Verwendung:
/// ```dart
/// final client = ref.watch(httpClientProvider);
/// ```
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();

  ref.onDispose(() {
    client.close();
  });

  return client;
});

/// HTTP Client Wrapper Provider (with retry logic)
///
/// Wraps http.Client mit Retry-Logik, Timeout und Error Handling.
/// Nutzt httpClientProvider als Basis.
///
/// Verwendung:
/// ```dart
/// final wrapper = ref.watch(httpClientWrapperProvider);
/// final response = await wrapper.get(Uri.parse('https://...'));
/// ```
final httpClientWrapperProvider = Provider<HttpClientWrapper>((ref) {
  final httpClient = ref.watch(httpClientProvider);

  return HttpClientWrapper(
    httpClient: httpClient,
    timeout: const Duration(seconds: 30),
    maxRetries: 3,
    initialRetryDelay: const Duration(seconds: 1),
  );
});

/// Kickbase API Client Provider (Lazy Loading)
///
/// Verwaltet alle HTTP-Anfragen an die Kickbase API v4.
/// Nutzt SharedPreferences für Token-Storage (einfacher als Keychain).
/// Token-Key 'kickbase_token'.
///
/// Verwendung:
/// ```dart
/// final apiClient = ref.watch(kickbaseApiClientProvider);
/// final user = await apiClient.getUser();
/// ```
final kickbaseApiClientProvider = Provider<KickbaseAPIClient>((ref) {
  final httpClient = ref.watch(httpClientProvider);

  final client = KickbaseAPIClient(httpClient: httpClient);

  ref.onDispose(() {
    client.dispose();
  });

  return client;
});

/// Ligainsider Service Provider (Lazy Loading)
///
/// Scraped ligainsider.de für Spieler Verletzungen und Aufstellungen.
/// Bietet Caching und Offline-Support.
/// Nutzt httpClientProvider für HTTP-Anfragen.
///
/// WICHTIG: Verwende ligainsiderServiceFutureProvider für async initialization
///
/// Verwendung:
/// ```dart
/// final serviceAsync = ref.watch(ligainsiderServiceFutureProvider);
/// serviceAsync.when(
///   data: (service) => service.getPlayerStatus('Max', 'Mustermann'),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => Text('Error: $err'),
/// );
/// ```
final ligainsiderServiceFutureProvider = FutureProvider<LigainsiderService>((
  ref,
) async {
  final httpClient = ref.watch(httpClientProvider);
  final prefs = await SharedPreferences.getInstance();

  return LigainsiderService(httpClient: httpClient, prefs: prefs);
});

// ============================================================================
// Services Provider Barrel Export
// ============================================================================

/// Barrel Provider für synchrone Services
///
/// Ermöglicht einfachen Zugriff auf synchron verfügbare Services.
/// Für LigainsiderService verwende ligainsiderServiceFutureProvider separat.
///
/// Verwendung:
/// ```dart
/// final services = ref.watch(syncServicesProvider);
/// final apiClient = services.kickbaseApiClient;
///
/// // Für LigainsiderService separat:
/// final ligainsider = await ref.read(ligainsiderServiceFutureProvider.future);
/// ```
final syncServicesProvider = Provider<SyncServices>((ref) {
  return SyncServices(
    httpClient: ref.watch(httpClientProvider),
    httpClientWrapper: ref.watch(httpClientWrapperProvider),
    kickbaseApiClient: ref.watch(kickbaseApiClientProvider),
  );
});

/// Services Container Class für synchrone Services
///
/// Container für alle synchron verfügbaren Services.
class SyncServices {
  final http.Client httpClient;
  final HttpClientWrapper httpClientWrapper;
  final KickbaseAPIClient kickbaseApiClient;

  const SyncServices({
    required this.httpClient,
    required this.httpClientWrapper,
    required this.kickbaseApiClient,
  });
}
