import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kickbasekumpel/data/services/token_storage.dart';

import 'package:kickbasekumpel/data/services/kickbase_api_client.dart';
import 'package:kickbasekumpel/domain/exceptions/kickbase_exceptions.dart';
import 'package:kickbasekumpel/data/models/user_model.dart';
import 'package:kickbasekumpel/data/models/league_model.dart';

import 'kickbase_api_client_test.mocks.dart';

@GenerateMocks([http.Client, TokenStorage])
void main() {
  late MockClient mockHttpClient;
  late MockTokenStorage mockTokenStorage;
  late KickbaseAPIClient apiClient;

  setUp(() {
    mockHttpClient = MockClient();
    mockTokenStorage = MockTokenStorage();
    apiClient = KickbaseAPIClient(
      httpClient: mockHttpClient,
      tokenStorage: mockTokenStorage,
    );
  });

  tearDown(() {
    apiClient.dispose();
  });

  group('Token Management', () {
    const testToken = 'test_token_12345';

    test('setAuthToken should store token', () async {
      when(mockTokenStorage.setToken(testToken)).thenAnswer((_) async {});

      await apiClient.setAuthToken(testToken);

      verify(mockTokenStorage.setToken(testToken)).called(1);
    });

    test('getAuthToken should retrieve stored token', () async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);

      final token = await apiClient.getAuthToken();

      expect(token, testToken);
      verify(mockTokenStorage.getToken()).called(1);
    });

    test('hasAuthToken should return true when token exists', () async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);

      final hasToken = await apiClient.hasAuthToken();

      expect(hasToken, true);
    });

    test('hasAuthToken should return false when token is null', () async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => null);

      final hasToken = await apiClient.hasAuthToken();

      expect(hasToken, false);
    });

    test('clearAuthToken should delete token', () async {
      when(mockTokenStorage.clearToken()).thenAnswer((_) async => {});

      await apiClient.clearAuthToken();

      verify(mockTokenStorage.clearToken()).called(1);
    });
  });

  group('Error Handling', () {
    const testToken = 'test_token';

    setUp(() async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);
      await apiClient.setAuthToken(testToken);
    });

    test('should throw AuthenticationException on 401', () async {
      final mockResponse = http.Response('Unauthorized', 401);
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 401),
      );

      expect(
        () => apiClient.getUser(),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test('should throw NotFoundException on 404', () async {
      final mockResponse = http.Response('Not Found', 404);
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 404),
      );

      expect(() => apiClient.getUser(), throwsA(isA<NotFoundException>()));
    });

    test('should throw RateLimitException on 429', () async {
      final mockResponse = http.Response(
        'Too Many Requests',
        429,
        headers: {'retry-after': '60'},
      );
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(
          Stream.value(mockResponse.bodyBytes),
          429,
          headers: mockResponse.headers,
        ),
      );

      expect(() => apiClient.getUser(), throwsA(isA<RateLimitException>()));
    });

    test('should throw ServerException on 500', () async {
      final mockResponse = http.Response('Internal Server Error', 500);
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 500),
      );

      expect(() => apiClient.getUser(), throwsA(isA<ServerException>()));
    });

    test('should throw NetworkException on SocketException', () async {
      when(
        mockHttpClient.send(any),
      ).thenThrow(const SocketException('No internet connection'));

      expect(() => apiClient.getUser(), throwsA(isA<NetworkException>()));
    });

    test('should throw ParsingException on invalid JSON', () async {
      final mockResponse = http.Response('invalid json{', 200);
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 200),
      );

      expect(() => apiClient.getUser(), throwsA(isA<ParsingException>()));
    });
  });

  group('API Methods', () {
    const testToken = 'test_token';

    setUp(() async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);
      await apiClient.setAuthToken(testToken);
    });

    test('getUser should return User on success', () async {
      final userJson = {
        'i': 'user123',
        'n': 'Test User',
        'tn': 'Team Test',
        'em': 'test@test.com',
        'b': 50000000,
        'tv': 75000000,
        'p': 500,
        'pl': 1,
        'f': 0,
      };
      final mockResponse = http.Response(jsonEncode(userJson), 200);

      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 200),
      );

      final user = await apiClient.getUser();

      expect(user, isA<User>());
      expect(user.i, 'user123');
      expect(user.n, 'Test User');
    });

    test('getLeagues should return list of leagues on success', () async {
      final leaguesJson = {
        'leagues': [
          {
            'i': 'league1',
            'cpi': '1',
            'n': 'Test League',
            'cn': 'Admin',
            'an': 'Admin Nick',
            'c': 'default',
            's': 'active',
            'md': 10,
            'cu': {
              'id': 'user1',
              'name': 'User 1',
              'teamName': 'Team 1',
              'budget': 50000000,
              'teamValue': 75000000,
              'points': 500,
              'placement': 1,
              'won': 5,
              'drawn': 2,
              'lost': 3,
              'se11': 11,
              'ttm': 18,
              'lp': [],
            },
          },
        ],
      };
      final mockResponse = http.Response(jsonEncode(leaguesJson), 200);

      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 200),
      );

      final leagues = await apiClient.getLeagues();

      expect(leagues, isA<List<League>>());
      expect(leagues.length, 1);
      expect(leagues.first.i, 'league1');
    });

    test('getLeaguePlayers supports compact player keys', () async {
      final playersJson = {
        'players': [
          {
            'id': 'player-1',
            'fn': 'Max',
            'ln': 'Mustermann',
            'tn': 'Team A',
            'position': 3,
            'number': 8,
            'averagePoints': 4.5,
            'totalPoints': 45,
            'marketValue': 1500000,
            'marketValueTrend': 1,
            'profileBigUrl': 'https://example.com/p1.png',
            'userOwnsPlayer': false,
          },
        ],
      };

      final mockResponse = http.Response(jsonEncode(playersJson), 200);
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 200),
      );

      final players = await apiClient.getLeaguePlayers('league-1');

      expect(players, isA<List>());
      expect(players.length, 1);
      expect(players.first.firstName, 'Max');
      expect(players.first.lastName, 'Mustermann');
    });

    test('getLeaguePlayers supports expanded player keys', () async {
      final playersJson = {
        'players': [
          {
            'id': 'player-2',
            'firstName': 'John',
            'lastName': 'Doe',
            'teamName': 'Team B',
            'position': 2,
            'number': 5,
            'averagePoints': '3.2',
            'totalPoints': '32',
            'marketValue': '1200000',
            'marketValueTrend': '0',
            'profileBigUrl': 'https://example.com/p2.png',
            'userOwnsPlayer': 'false',
          },
        ],
      };

      final mockResponse = http.Response(jsonEncode(playersJson), 200);
      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 200),
      );

      final players = await apiClient.getLeaguePlayers('league-1');

      expect(players, isA<List>());
      expect(players.length, 1);
      expect(players.first.firstName, 'John');
      expect(players.first.totalPoints, 32);
    });

    test('should include Bearer token in request headers', () async {
      final mockResponse = http.Response('{"i":"user1"}', 200);
      http.BaseRequest? capturedRequest;

      when(mockHttpClient.send(any)).thenAnswer((invocation) async {
        capturedRequest = invocation.positionalArguments[0] as http.BaseRequest;
        return http.StreamedResponse(Stream.value(mockResponse.bodyBytes), 200);
      });

      try {
        await apiClient.getUser();
      } catch (_) {}

      expect(capturedRequest, isNotNull);
      expect(capturedRequest!.headers['Authorization'], 'Bearer $testToken');
    });

    test('should throw AuthenticationException when no token', () async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => null);
      await apiClient.clearAuthToken();

      expect(
        () => apiClient.getUser(),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });

  group('Retry Logic', () {
    const testToken = 'test_token';

    setUp(() async {
      when(mockTokenStorage.getToken()).thenAnswer((_) async => testToken);
      await apiClient.setAuthToken(testToken);
    });

    test('should retry on 500 error with exponential backoff', () async {
      var callCount = 0;
      when(mockHttpClient.send(any)).thenAnswer((_) async {
        callCount++;
        if (callCount < 3) {
          return http.StreamedResponse(Stream.value([]), 500);
        }
        return http.StreamedResponse(
          Stream.value(http.Response('{"i":"user1"}', 200).bodyBytes),
          200,
        );
      });

      // Note: This test will take some time due to retry delays
      // In a real scenario, you might want to inject a mock timer
      try {
        await apiClient.getUser();
      } catch (_) {}

      expect(callCount, greaterThan(1));
    });
  });

  group('Network Connectivity', () {
    test('testNetworkConnectivity should return true on success', () async {
      when(
        mockHttpClient.head(any),
      ).thenAnswer((_) async => http.Response('', 200));

      final result = await apiClient.testNetworkConnectivity();

      expect(result, true);
    });

    test('testNetworkConnectivity should return false on error', () async {
      when(mockHttpClient.head(any)).thenThrow(Exception('Network error'));

      final result = await apiClient.testNetworkConnectivity();

      expect(result, false);
    });
  });
}
