import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/http_client_wrapper.dart';

// ============================================================================
// HTTP Client Wrapper Provider
// ============================================================================

/// HTTP Client Provider (raw client)
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();

  // Cleanup on dispose
  ref.onDispose(() {
    client.close();
  });

  return client;
});

/// HTTP Client Wrapper Provider (with retry logic)
final httpClientWrapperProvider = Provider<HttpClientWrapper>((ref) {
  final httpClient = ref.watch(httpClientProvider);

  final wrapper = HttpClientWrapper(
    httpClient: httpClient,
    timeout: const Duration(seconds: 30),
    maxRetries: 3,
    initialRetryDelay: const Duration(seconds: 1),
  );

  // Note: Don't call wrapper.dispose() here since it would close the shared httpClient
  // The httpClientProvider handles disposal

  return wrapper;
});
