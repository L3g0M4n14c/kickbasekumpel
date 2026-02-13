import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../domain/exceptions/kickbase_exceptions.dart';

/// Generic HTTP Client Wrapper for consistent error handling and retry logic
class HttpClientWrapper {
  final http.Client _httpClient;
  final Duration _timeout;
  final int _maxRetries;
  final Duration _initialRetryDelay;
  final Logger _logger = Logger();

  HttpClientWrapper({
    required http.Client httpClient,
    Duration timeout = const Duration(seconds: 30),
    int maxRetries = 3,
    Duration initialRetryDelay = const Duration(seconds: 1),
  }) : _httpClient = httpClient,
       _timeout = timeout,
       _maxRetries = maxRetries,
       _initialRetryDelay = initialRetryDelay;

  // MARK: - Public Request Methods

  /// Execute GET request with retry logic
  Future<T> get<T>(
    String url, {
    Map<String, String>? headers,
    required T Function(http.Response) parser,
  }) async {
    return _executeWithRetry<T>(
      requestBuilder: () => _httpClient.get(Uri.parse(url), headers: headers),
      parser: parser,
      method: 'GET',
      url: url,
    );
  }

  /// Execute POST request with retry logic
  Future<T> post<T>(
    String url, {
    Map<String, String>? headers,
    Object? body,
    required T Function(http.Response) parser,
  }) async {
    return _executeWithRetry<T>(
      requestBuilder: () =>
          _httpClient.post(Uri.parse(url), headers: headers, body: body),
      parser: parser,
      method: 'POST',
      url: url,
    );
  }

  /// Execute PUT request with retry logic
  Future<T> put<T>(
    String url, {
    Map<String, String>? headers,
    Object? body,
    required T Function(http.Response) parser,
  }) async {
    return _executeWithRetry<T>(
      requestBuilder: () =>
          _httpClient.put(Uri.parse(url), headers: headers, body: body),
      parser: parser,
      method: 'PUT',
      url: url,
    );
  }

  /// Execute DELETE request with retry logic
  Future<T> delete<T>(
    String url, {
    Map<String, String>? headers,
    required T Function(http.Response) parser,
  }) async {
    return _executeWithRetry<T>(
      requestBuilder: () =>
          _httpClient.delete(Uri.parse(url), headers: headers),
      parser: parser,
      method: 'DELETE',
      url: url,
    );
  }

  // MARK: - Request Execution with Retry

  /// Execute request with exponential backoff retry strategy
  Future<T> _executeWithRetry<T>({
    required Future<http.Response> Function() requestBuilder,
    required T Function(http.Response) parser,
    required String method,
    required String url,
  }) async {
    int attempts = 0;
    final startTime = DateTime.now();

    while (attempts < _maxRetries) {
      try {
        _logRequest(method, url, attempts + 1);

        // Execute request with timeout
        final response = await requestBuilder().timeout(
          _timeout,
          onTimeout: () {
            throw TimeoutException(
              'Request timeout after ${_timeout.inSeconds}s',
            );
          },
        );

        final duration = DateTime.now().difference(startTime);
        _logResponse(method, url, response.statusCode, duration);

        // Map HTTP status codes to exceptions
        _validateResponse(response);

        // Parse and return response
        return parser(response);
      } on TimeoutException catch (e) {
        _logError(method, url, 'TimeoutException', e.message);

        if (attempts >= _maxRetries - 1) {
          rethrow;
        }

        // Retry on timeout
        final delay = _calculateExponentialDelay(attempts);
        _logRetry(method, url, attempts + 1, delay);
        await Future.delayed(delay);
        attempts++;
      } on SocketException catch (e) {
        _logError(method, url, 'NetworkException', e.message);

        if (attempts >= _maxRetries - 1) {
          throw NetworkException(e.message);
        }

        // Retry on network error
        final delay = _calculateExponentialDelay(attempts);
        _logRetry(method, url, attempts + 1, delay);
        await Future.delayed(delay);
        attempts++;
      } on ServerException catch (e) {
        _logError(method, url, 'ServerException', e.message);

        if (attempts >= _maxRetries - 1) {
          rethrow;
        }

        // Retry on 5xx server errors
        final delay = _calculateExponentialDelay(attempts);
        _logRetry(method, url, attempts + 1, delay);
        await Future.delayed(delay);
        attempts++;
      } on RateLimitException catch (e) {
        _logError(method, url, 'RateLimitException', e.message);

        if (attempts >= _maxRetries - 1) {
          rethrow;
        }

        // Retry on rate limit with longer delay
        final delay = _calculateExponentialDelay(attempts) * 2;
        _logRetry(method, url, attempts + 1, delay);
        await Future.delayed(delay);
        attempts++;
      } on KickbaseException {
        // Don't retry on 4xx client errors (except 429 which is handled above)
        rethrow;
      } catch (e) {
        _logError(method, url, 'UnknownException', e.toString());
        rethrow;
      }
    }

    throw ServerException('Max retries exceeded', statusCode: 503);
  }

  // MARK: - Response Validation

  /// Validate HTTP response and map status codes to exceptions
  void _validateResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Success codes (2xx)
    if (statusCode >= 200 && statusCode < 300) {
      return;
    }

    // Client errors (4xx)
    if (statusCode == 401) {
      throw AuthenticationException('Unauthorized');
    }

    if (statusCode == 404) {
      throw NotFoundException('Resource not found');
    }

    if (statusCode == 429) {
      throw RateLimitException('Rate limit exceeded');
    }

    if (statusCode >= 400 && statusCode < 500) {
      throw KickbaseException(
        'Client error: ${response.reasonPhrase ?? 'Unknown error'}',
        code: statusCode.toString(),
      );
    }

    // Server errors (5xx)
    if (statusCode >= 500) {
      throw ServerException(
        'Server error: ${response.reasonPhrase ?? 'Unknown error'}',
        statusCode: statusCode,
      );
    }
  }

  // MARK: - Retry Logic

  /// Calculate exponential backoff delay
  Duration _calculateExponentialDelay(int attempt) {
    final multiplier = 1 << attempt; // 2^attempt
    return _initialRetryDelay * multiplier;
  }

  // MARK: - Logging

  /// Log outgoing request
  void _logRequest(String method, String url, int attempt) {
    final attemptInfo = attempt > 1 ? ' (Attempt $attempt)' : '';
    _logger.d('🌐 HTTP $method: $url$attemptInfo');
  }

  /// Log response with status and duration
  void _logResponse(
    String method,
    String url,
    int statusCode,
    Duration duration,
  ) {
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '⚠️';
    _logger.d(
      '$emoji HTTP $method: $url → $statusCode (${duration.inMilliseconds}ms)',
    );
  }

  /// Log error
  void _logError(String method, String url, String errorType, String message) {
    _logger.e('❌ HTTP $method: $url → $errorType: $message');
  }

  /// Log retry attempt
  void _logRetry(String method, String url, int attempt, Duration delay) {
    _logger.w(
      '🔄 HTTP $method: $url → Retrying (attempt $attempt) after ${delay.inSeconds}s',
    );
  }

  /// Dispose HTTP client
  void dispose() {
    _httpClient.close();
  }
}
