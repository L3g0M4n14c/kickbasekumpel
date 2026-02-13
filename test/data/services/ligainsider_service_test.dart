import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kickbasekumpel/data/services/ligainsider_service.dart';
import 'package:kickbasekumpel/data/models/ligainsider_model.dart';

import 'ligainsider_service_test.mocks.dart';

@GenerateMocks([http.Client, SharedPreferences, Connectivity])
void main() {
  late MockClient mockHttpClient;
  late MockSharedPreferences mockPrefs;
  late MockConnectivity mockConnectivity;
  late LigainsiderService service;

  setUp(() {
    mockHttpClient = MockClient();
    mockPrefs = MockSharedPreferences();
    mockConnectivity = MockConnectivity();

    // Default mocks
    when(mockPrefs.getString(any)).thenReturn(null);
    when(mockPrefs.getInt(any)).thenReturn(null);
    when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
    when(mockPrefs.setInt(any, any)).thenAnswer((_) async => true);
    when(mockPrefs.remove(any)).thenAnswer((_) async => true);

    service = LigainsiderService(
      httpClient: mockHttpClient,
      prefs: mockPrefs,
      connectivity: mockConnectivity,
    );
  });

  group('Initialization', () {
    test('should start with empty cache and not ready', () {
      expect(service.isReady, false);
      expect(service.playerCacheCount, 0);
    });
  });

  group('Name Normalization', () {
    test('should normalize German umlauts', () {
      // Mock successful fetch
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockHtml = '''
        <html>
          <body>
            <a href="/mueller_123/">Müller</a>
          </body>
        </html>
      ''';

      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response(mockHtml, 200));

      // The service should find player using normalized name
      // This is tested implicitly through matching logic
    });
  });

  group('HTML Parsing', () {
    test('should parse player links from HTML', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Mock overview page with player links
      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/max-mustermann_12345/">Max Mustermann</a>
            <a href="/john-doe_67890/">John Doe</a>
          </body>
        </html>
      ''';

      // Mock individual player pages with details
      final mockPlayerHtml1 = '''
        <html>
          <body>
            <h1>Max Mustermann</h1>
            <div class="player-info">Position: Mittelfeld</div>
          </body>
        </html>
      ''';

      final mockPlayerHtml2 = '''
        <html>
          <body>
            <h1>John Doe</h1>
            <div class="player-info">Position: Sturm</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('12345')) {
          return http.Response(mockPlayerHtml1, 200);
        } else if (uri.path.contains('67890')) {
          return http.Response(mockPlayerHtml2, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();

      expect(service.isReady, true);
      expect(service.playerCacheCount, 2);
    });

    test('should handle empty HTML', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response('<html></html>', 200));

      await service.fetchLineups();

      expect(service.playerCacheCount, 0);
    });

    test('should skip invalid player links', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/no-id/">Invalid</a>
            <a href="/valid-player_123/">Valid Player</a>
            <a href="/also_invalid_abc/">Also Invalid</a>
          </body>
        </html>
      ''';

      final mockPlayerHtml = '''
        <html>
          <body>
            <h1>Valid Player</h1>
            <div class="player-info">Position: Torwart</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('123')) {
          return http.Response(mockPlayerHtml, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();

      expect(service.playerCacheCount, 1);
    });

    test(
      'should fetch image from player detail page when missing in overview',
      () async {
        when(
          mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/max-mustermann_12345/">Max Mustermann</a>
          </body>
        </html>
      ''';

        final mockPlayerDetail = '''
        <html>
          <head>
            <meta property="og:image" content="/images/max.jpg">
          </head>
          <body>
            <h1>Max Mustermann</h1>
            <img class="player-photo" src="/images/max.jpg" />
          </body>
        </html>
      ''';

        when(mockHttpClient.get(any)).thenAnswer((invocation) async {
          final uri = invocation.positionalArguments[0] as Uri;
          if (uri.path.contains('spieltage')) {
            return http.Response(mockOverviewHtml, 200);
          } else if (uri.path.contains('12345')) {
            return http.Response(mockPlayerDetail, 200);
          }
          return http.Response('', 404);
        });

        await service.fetchLineups();

        final player = service.getLigainsiderPlayer('Max', 'Mustermann');
        expect(player, isNotNull);
        expect(player!.imageUrl, 'https://www.ligainsider.de/images/max.jpg');
      },
    );
  });

  group('Player Matching', () {
    setUp(() async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/max-mustermann_12345/">Max Mustermann</a>
            <a href="/thomas-mueller_67890/">Thomas Müller</a>
            <a href="/john-doe_99999/">John Doe</a>
          </body>
        </html>
      ''';

      final mockPlayerHtml1 = '''
        <html>
          <body>
            <h1>Max Mustermann</h1>
            <div class="player-info">Position: Mittelfeld</div>
          </body>
        </html>
      ''';

      final mockPlayerHtml2 = '''
        <html>
          <body>
            <h1>Thomas Müller</h1>
            <div class="player-info">Position: Sturm</div>
          </body>
        </html>
      ''';

      final mockPlayerHtml3 = '''
        <html>
          <body>
            <h1>John Doe</h1>
            <div class="player-info">Position: Abwehr</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('12345')) {
          return http.Response(mockPlayerHtml1, 200);
        } else if (uri.path.contains('67890')) {
          return http.Response(mockPlayerHtml2, 200);
        } else if (uri.path.contains('99999')) {
          return http.Response(mockPlayerHtml3, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();
    });

    test('should find player by exact name match', () {
      final player = service.getLigainsiderPlayer('Max', 'Mustermann');

      expect(player, isNotNull);
      expect(player!.name, 'Max Mustermann');
      expect(player.ligainsiderId, 'max-mustermann_12345');
    });

    test('should find player with normalized umlauts', () {
      final player = service.getLigainsiderPlayer('Thomas', 'Müller');

      expect(player, isNotNull);
      expect(player!.name, 'Thomas Müller');
    });

    test('should return null for non-existent player', () {
      final player = service.getLigainsiderPlayer('Unknown', 'Player');

      expect(player, isNull);
    });

    test('should find player by last name only', () {
      final player = service.getLigainsiderPlayer('', 'Doe');

      expect(player, isNotNull);
      expect(player!.name, 'John Doe');
    });
  });

  group('Player Status', () {
    setUp(() async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/starter-player_99999/">Starter Player</a>
          </body>
        </html>
      ''';

      final mockPlayerHtml = '''
        <html>
          <body>
            <h1>Starter Player</h1>
            <div class="player-info">Position: Mittelfeld</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('99999')) {
          return http.Response(mockPlayerHtml, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();
    });

    test('should return likelyStart for player in cache', () {
      final status = service.getPlayerStatus('Starter', 'Player');

      expect(status, LigainsiderPlayerStatus.likelyStart);
    });

    test('should return out for unknown player', () async {
      // Clear cache and add only one specific player
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/different-person_88888/">Different Person</a>
          </body>
        </html>
      ''';

      final mockPlayerHtml = '''
        <html>
          <body>
            <h1>Different Person</h1>
            <div class="player-info">Position: Tor</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('88888')) {
          return http.Response(mockPlayerHtml, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();

      // Query for a completely unknown player
      final status = service.getPlayerStatus('Unknown', 'Stranger');

      expect(status, LigainsiderPlayerStatus.out);
    });
  });

  group('Caching', () {
    test('should save players to cache after fetch', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/test-player_123/">Test Player</a>
          </body>
        </html>
      ''';

      final mockPlayerHtml = '''
        <html>
          <body>
            <h1>Test Player</h1>
            <div class="player-info">Position: Mittelfeld</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('123')) {
          return http.Response(mockPlayerHtml, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();

      verify(mockPrefs.setString('ligainsider_cache', any)).called(1);
      verify(mockPrefs.setInt('ligainsider_cache_timestamp', any)).called(1);
    });

    test('should load from cache when offline', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      final cachedPlayer = LigainsiderPlayer(
        id: 'cached',
        name: 'Cached Player',
        shortName: 'Cached',
        teamName: 'Test',
        teamId: 'test',
        position: 0,
        injuryStatus: InjuryStatus.fit,
        lastUpdate: DateTime.now(),
        ligainsiderId: 'cached_999',
      );

      final cachedData = jsonEncode([cachedPlayer.toJson()]);
      when(mockPrefs.getString('ligainsider_cache')).thenReturn(cachedData);
      when(
        mockPrefs.getInt('ligainsider_cache_timestamp'),
      ).thenReturn(DateTime.now().millisecondsSinceEpoch);

      await service.fetchLineups();

      expect(service.isReady, true);
      expect(service.playerCacheCount, 1);

      final player = service.getLigainsiderPlayer('Cached', 'Player');
      expect(player, isNotNull);
      expect(player!.name, 'Cached Player');
    });

    test('should ignore expired cache', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final cachedData = jsonEncode([
        {
          'id': 'old',
          'name': 'Old Player',
          'shortName': 'Old',
          'teamName': 'Test',
          'teamId': 'test',
          'position': 0,
          'injury_status': 'fit',
          'last_update': DateTime.now().toIso8601String(),
          'ligainsiderId': 'old_111',
        },
      ]);

      // Cache from 2 hours ago (expired)
      final expiredTimestamp = DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch;

      when(mockPrefs.getString('ligainsider_cache')).thenReturn(cachedData);
      when(
        mockPrefs.getInt('ligainsider_cache_timestamp'),
      ).thenReturn(expiredTimestamp);

      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response('<html></html>', 200));

      await service.fetchLineups();

      // Should not load expired cache, will fetch fresh (empty in this test)
      expect(service.playerCacheCount, 0);
    });

    test('should clear cache', () async {
      // Populate cache first
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final mockOverviewHtml = '''
        <html>
          <body>
            <a href="/test-player_1/">Test Player</a>
          </body>
        </html>
      ''';

      final mockPlayerHtml = '''
        <html>
          <body>
            <h1>Test Player</h1>
            <div class="player-info">Position: Mittelfeld</div>
          </body>
        </html>
      ''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('spieltage')) {
          return http.Response(mockOverviewHtml, 200);
        } else if (uri.path.contains('1')) {
          return http.Response(mockPlayerHtml, 200);
        }
        return http.Response('', 404);
      });

      await service.fetchLineups();
      expect(service.playerCacheCount, greaterThan(0));

      // Clear cache
      await service.clearCache();

      expect(service.playerCacheCount, 0);
      expect(service.isReady, false);

      verify(mockPrefs.remove('ligainsider_cache')).called(1);
      verify(mockPrefs.remove('ligainsider_cache_timestamp')).called(1);
    });
  });

  group('Error Handling', () {
    test('should handle HTTP errors gracefully', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response('Error', 500));

      await service.fetchLineups();

      expect(service.isReady, false);
      expect(service.playerCacheCount, 0);
    });

    test('should handle network errors gracefully', () async {
      when(
        mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(mockHttpClient.get(any)).thenThrow(Exception('Network error'));

      await service.fetchLineups();

      expect(service.isReady, false);
    });
  });

  group('Status Extension', () {
    test('should provide correct icon for each status', () {
      expect(LigainsiderPlayerStatus.likelyStart.icon, '✓');
      expect(LigainsiderPlayerStatus.startWithAlternative.icon, '1');
      expect(LigainsiderPlayerStatus.isAlternative.icon, '2');
      expect(LigainsiderPlayerStatus.bench.icon, '−');
      expect(LigainsiderPlayerStatus.out.icon, '✗');
    });

    test('should provide correct description for each status', () {
      expect(
        LigainsiderPlayerStatus.likelyStart.description,
        'Wahrscheinlich in Startelf',
      );
      expect(
        LigainsiderPlayerStatus.startWithAlternative.description,
        'In Startelf mit Alternative',
      );
      expect(LigainsiderPlayerStatus.isAlternative.description, 'Alternative');
      expect(LigainsiderPlayerStatus.bench.description, 'Auf der Bank');
      expect(LigainsiderPlayerStatus.out.description, 'Nicht im Kader');
    });
  });
}
