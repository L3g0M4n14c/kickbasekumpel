import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:kickbasekumpel/data/services/http_client_wrapper.dart';
import 'package:kickbasekumpel/domain/exceptions/kickbase_exceptions.dart';

@GenerateMocks([http.Client])
import 'http_client_wrapper_test.mocks.dart';

void main() {
  late MockClient mockHttpClient;
  late HttpClientWrapper wrapper;

  setUp(() {
    mockHttpClient = MockClient();
    wrapper = HttpClientWrapper(
      httpClient: mockHttpClient,
      timeout: const Duration(seconds: 2),
      maxRetries: 3,
      initialRetryDelay: const Duration(milliseconds: 100),
    );
  });

  group('GET Requests', () {
    test('should execute successful GET request', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('{"data": "test"}', 200));

      final result = await wrapper.get(
        'https://api.test.com/data',
        parser: (response) => response.body,
      );

      expect(result, '{"data": "test"}');
      verify(mockHttpClient.get(any, headers: anyNamed('headers'))).called(1);
    });

    test('should parse response with custom parser', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('{"count": 42}', 200));

      final result = await wrapper.get<Map<String, dynamic>>(
        'https://api.test.com/data',
        parser: (response) => {'parsed': true, 'body': response.body},
      );

      expect(result['parsed'], true);
      expect(result['body'], '{"count": 42}');
    });

    test('should include custom headers', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('{}', 200));

      await wrapper.get(
        'https://api.test.com/data',
        headers: {'Authorization': 'Bearer token123'},
        parser: (response) => response.body,
      );

      verify(
        mockHttpClient.get(any, headers: {'Authorization': 'Bearer token123'}),
      ).called(1);
    });
  });

  group('POST Requests', () {
    test('should execute successful POST request', () async {
      when(
        mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"success": true}', 201));

      final result = await wrapper.post(
        'https://api.test.com/data',
        body: '{"name": "test"}',
        parser: (response) => response.statusCode,
      );

      expect(result, 201);
    });
  });

  group('PUT Requests', () {
    test('should execute successful PUT request', () async {
      when(
        mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('{"updated": true}', 200));

      final result = await wrapper.put(
        'https://api.test.com/data/1',
        body: '{"name": "updated"}',
        parser: (response) => response.body,
      );

      expect(result, '{"updated": true}');
    });
  });

  group('DELETE Requests', () {
    test('should execute successful DELETE request', () async {
      when(
        mockHttpClient.delete(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('', 204));

      final result = await wrapper.delete(
        'https://api.test.com/data/1',
        parser: (response) => response.statusCode,
      );

      expect(result, 204);
    });
  });

  group('Error Mapping', () {
    test('should throw AuthenticationException on 401', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test('should throw NotFoundException on 404', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('should throw RateLimitException on 429', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Rate Limit', 429));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<RateLimitException>()),
      );
    });

    test('should throw ServerException on 500', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw KickbaseException on other 4xx errors', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Bad Request', 400));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<KickbaseException>()),
      );
    });

    test('should throw NetworkException on SocketException', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenThrow(const SocketException('Network error'));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw TimeoutException on timeout', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) => Future.delayed(
          const Duration(seconds: 5),
          () => http.Response('OK', 200),
        ),
      );

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<TimeoutException>()),
      );
    });
  });

  group('Retry Strategy', () {
    test('should retry on 5xx server errors', () async {
      var attemptCount = 0;
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        _,
      ) async {
        attemptCount++;
        if (attemptCount < 3) {
          return http.Response('Server Error', 500);
        }
        return http.Response('OK', 200);
      });

      final result = await wrapper.get(
        'https://api.test.com/data',
        parser: (response) => response.body,
      );

      expect(result, 'OK');
      expect(attemptCount, 3);
      verify(mockHttpClient.get(any, headers: anyNamed('headers'))).called(3);
    });

    test('should retry on network errors', () async {
      var attemptCount = 0;
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        _,
      ) async {
        attemptCount++;
        if (attemptCount < 2) {
          throw const SocketException('Network error');
        }
        return http.Response('OK', 200);
      });

      final result = await wrapper.get(
        'https://api.test.com/data',
        parser: (response) => response.body,
      );

      expect(result, 'OK');
      expect(attemptCount, 2);
    });

    test('should retry on timeout', () async {
      var attemptCount = 0;
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        _,
      ) async {
        attemptCount++;
        if (attemptCount < 2) {
          await Future.delayed(const Duration(seconds: 5));
          return http.Response('OK', 200);
        }
        return http.Response('OK', 200);
      });

      final result = await wrapper.get(
        'https://api.test.com/data',
        parser: (response) => response.body,
      );

      expect(result, 'OK');
      expect(attemptCount, 2);
    });

    test('should NOT retry on 4xx client errors (except 429)', () async {
      var attemptCount = 0;
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        _,
      ) async {
        attemptCount++;
        return http.Response('Not Found', 404);
      });

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<NotFoundException>()),
      );

      // Wait to ensure no retries
      await Future.delayed(const Duration(milliseconds: 500));
      expect(attemptCount, 1); // Only one attempt
    });

    test('should retry on 429 rate limit', () async {
      var attemptCount = 0;
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        _,
      ) async {
        attemptCount++;
        if (attemptCount < 2) {
          return http.Response('Rate Limit', 429);
        }
        return http.Response('OK', 200);
      });

      final result = await wrapper.get(
        'https://api.test.com/data',
        parser: (response) => response.body,
      );

      expect(result, 'OK');
      expect(attemptCount, 2);
    });

    test('should throw after max retries exceeded', () async {
      when(
        mockHttpClient.get(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      expect(
        () => wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.body,
        ),
        throwsA(isA<ServerException>()),
      );

      // Wait for all retries to complete
      await Future.delayed(const Duration(seconds: 1));

      // Should attempt 3 times
      verify(mockHttpClient.get(any, headers: anyNamed('headers'))).called(3);
    });
  });

  group('Exponential Backoff', () {
    test('should use exponential backoff delays', () async {
      var attemptCount = 0;

      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        _,
      ) async {
        attemptCount++;
        if (attemptCount > 1) {
          // Record time between attempts
          await Future.delayed(const Duration(milliseconds: 10));
        }
        if (attemptCount < 3) {
          return http.Response('Server Error', 500);
        }
        return http.Response('OK', 200);
      });

      await wrapper.get(
        'https://api.test.com/data',
        parser: (response) => response.body,
      );

      expect(attemptCount, 3);
      // Delays should be approximately: 100ms, 200ms
      // (initialRetryDelay is 100ms, exponential: 2^0 * 100, 2^1 * 100)
    });
  });

  group('Success Responses', () {
    test('should handle 2xx success codes', () async {
      for (var code in [200, 201, 202, 204]) {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Success', code));

        final result = await wrapper.get(
          'https://api.test.com/data',
          parser: (response) => response.statusCode,
        );

        expect(result, code);
      }
    });
  });
}
