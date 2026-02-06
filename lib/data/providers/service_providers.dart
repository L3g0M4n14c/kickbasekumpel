import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/http_client_wrapper.dart';
import '../services/kickbase_api_client.dart';
import '../services/ligainsider_service.dart';
import 'kickbase_api_provider.dart';

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
/// Nutzt httpClientProvider und secureStorageProvider für Token-Management.
/// Separater Token-Key 'kickbase_token', unabhängig von Firebase Auth.
///
/// Verwendung:
/// ```dart
/// final apiClient = ref.watch(kickbaseApiClientProvider);
/// final user = await apiClient.getUser();
/// ```
final kickbaseApiClientProvider = Provider<KickbaseAPIClient>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  final client = KickbaseAPIClient(
    httpClient: httpClient,
    secureStorage: secureStorage,
  );

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
/// Verwendung:
/// ```dart
/// final service = ref.watch(ligainsiderServiceProvider);
/// await service.fetchLineups();
/// final status = service.getPlayerStatus('Max', 'Mustermann');
/// ```
final ligainsiderServiceProvider = Provider<LigainsiderService>((ref) {
  final httpClient = ref.watch(httpClientProvider);

  return LigainsiderService(httpClient: httpClient);
});

// ============================================================================
// Services Provider Barrel Export
// ============================================================================

/// Barrel Provider für alle Services
///
/// Ermöglicht einfachen Zugriff auf alle Service Provider über einen
/// einzigen Import. Ideal für Riverpod.watch() in UI Components.
///
/// Verwendung:
/// ```dart
/// final services = ref.watch(servicesProvider);
/// final apiClient = services.kickbaseApiClient;
/// final ligainsider = services.ligainsider;
/// ```
final servicesProvider = Provider<Services>((ref) {
  return Services(
    httpClient: ref.watch(httpClientProvider),
    httpClientWrapper: ref.watch(httpClientWrapperProvider),
    kickbaseApiClient: ref.watch(kickbaseApiClientProvider),
    ligainsiderService: ref.watch(ligainsiderServiceProvider),
  );
});

/// Services Container Class
///
/// Container für alle Services, ermöglicht gebündelten Zugriff.
class Services {
  final http.Client httpClient;
  final HttpClientWrapper httpClientWrapper;
  final KickbaseAPIClient kickbaseApiClient;
  final LigainsiderService ligainsiderService;

  const Services({
    required this.httpClient,
    required this.httpClientWrapper,
    required this.kickbaseApiClient,
    required this.ligainsiderService,
  });
}
