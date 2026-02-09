import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/http_client_wrapper.dart';
import '../services/ligainsider_service.dart';

// ============================================================================
// Service Providers - Central Export
// ============================================================================

/// SharedPreferences Provider (Singleton)
///
/// Stellt eine shared SharedPreferences-Instanz für alle Services bereit.
///
/// Verwendung:
/// ```dart
/// final prefs = await ref.watch(sharedPreferencesProvider.future);
/// ```
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// HTTP Client Provider (Singleton)
///
/// Stellt einen shared http.Client für alle Services bereit.
/// Wird automatisch beim Dispose geschlossen.
///
/// Verwendung:
/// ```dart
/// final client = ref.watch(httpClientProvider);
/// final response = await client.get(Uri.parse('https://...'));
/// ```
final httpClientProvider = Provider<http.Client>((ref) {
  final httpClient = http.Client();

  ref.onDispose(() {
    httpClient.close();
  });

  return httpClient;
});

/// HTTP Client Wrapper Provider (Singleton)
///
/// Stellt einen shared HttpClientWrapper für alle Services bereit.
/// Bietet zusätzliches Error-Handling und Retry-Logik.
/// Wird automatisch beim Dispose geschlossen.
///
/// Verwendung:
/// ```dart
/// final wrapper = ref.watch(httpClientWrapperProvider);
/// final response = await wrapper.get(Uri.parse('https://...'));
/// ```
final httpClientWrapperProvider = Provider<HttpClientWrapper>((ref) {
  final httpClient = http.Client();

  ref.onDispose(() {
    httpClient.close();
  });

  return HttpClientWrapper(
    httpClient: httpClient,
    timeout: const Duration(seconds: 30),
    maxRetries: 3,
    initialRetryDelay: const Duration(seconds: 1),
  );
});

/// Ligainsider Service Provider (Lazy Loading)
///
/// Scraped ligainsider.de für Spieler Verletzungen und Aufstellungen.
/// Bietet Caching und Offline-Support.
/// Nutzt shared preferences für Basis-Services.
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
  final httpClient = http.Client();
  final prefs = await ref.watch(sharedPreferencesProvider.future);

  ref.onDispose(() {
    httpClient.close();
  });

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
/// final httpClientWrapper = services.httpClientWrapper;
///
/// // Für LigainsiderService separat:
/// final ligainsider = await ref.read(ligainsiderServiceFutureProvider.future);
/// ```
final syncServicesProvider = Provider<SyncServices>((ref) {
  return SyncServices(
    httpClient: http.Client(),
    httpClientWrapper: ref.watch(httpClientWrapperProvider),
  );
});

/// Services Container Class für synchrone Services
///
/// Container für alle synchron verfügbaren Services.
class SyncServices {
  final http.Client httpClient;
  final HttpClientWrapper httpClientWrapper;

  const SyncServices({
    required this.httpClient,
    required this.httpClientWrapper,
  });
}
