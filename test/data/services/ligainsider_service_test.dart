import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kickbasekumpel/data/models/ligainsider_model.dart';
import 'package:kickbasekumpel/data/services/ligainsider_service.dart';

import 'ligainsider_service_test.mocks.dart';

/// Baut eine Team-Aufstellungsseite im Ligainsider-Markup.
///
/// Pro Slot (Starter + optionale Alternative) entsteht eine
/// `player_position_column` mit den entsprechenden `sub_child`-Blöcken – so
/// wie auf ligainsider.de/bundesliga/team/.../saison-.../.
String _teamPageHtml(List<(String, String?)> slots) {
  final columns = StringBuffer();

  void writePlayer(String slug, String displayStyle) {
    columns.write('''
      <div class="sub_child" style="$displayStyle">
        <div class="player_position_photo">
          <div class="sub_pic">
            <a href="/$slug/"><img src="https://cdn.ligainsider.de/images/player/$slug.jpg" alt=""></a>
          </div>
        </div>
        <div class="player_name"><a href="/$slug/" itemprop="athlete">Kurzname</a></div>
      </div>
    ''');
  }

  for (final (starter, alternative) in slots) {
    columns.write('<div class="player_position_column">');
    writePlayer(starter, 'display: block;');
    if (alternative != null) {
      writePlayer(alternative, 'display: none;');
    }
    columns.write('</div>');
  }

  return '''<html><body>
    <div class="player_position_row text-center">$columns</div>
  </body></html>''';
}

/// Baut die Spieltags-Übersicht mit den Team-Links (2 pro Spiel).
String _overviewHtml(List<String> teamPaths) {
  final links = teamPaths
      .map((path) => '<a href="$path">Team</a>')
      .join('\n');
  return '<html><body>$links</body></html>';
}

const _bayernPath =
    '/bundesliga/team/fc-bayern-muenchen/1/saison-2026-2027/111';
const _dortmundPath =
    '/bundesliga/team/borussia-dortmund/14/saison-2026-2027/112';

/// 11 Startelf-Slots; der erste zusätzlich mit Alternative.
List<(String, String?)> _slots(String prefix, {bool withAlternative = true}) {
  return [
    for (var i = 0; i < 11; i++)
      (
        '$prefix-spieler$i_${1000 + i}',
        withAlternative && i == 0 ? '$prefix-ersatz$i_${2000 + i}' : null,
      ),
  ];
}

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

  /// Standard-Routing: Übersicht + zwei Team-Seiten.
  void stubOverviewsAndTeamPages() {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);

    final overview = _overviewHtml([_bayernPath, _dortmundPath]);
    final bayern = _teamPageHtml(_slots('bayern'));
    final dortmund = _teamPageHtml(_slots('dortmund', withAlternative: false));

    when(mockHttpClient.get(any)).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments[0] as Uri;
      if (uri.path.contains('/team/')) {
        if (uri.path.contains('bayern')) return http.Response(bayern, 200);
        if (uri.path.contains('dortmund')) return http.Response(dortmund, 200);
        return http.Response('', 404);
      }
      if (uri.path.contains('spieltage')) {
        return http.Response(overview, 200);
      }
      return http.Response('', 404);
    });
  }

  group('Initialization', () {
    test('should start with empty cache and not ready', () {
      expect(service.isReady, false);
      expect(service.playerCacheCount, 0);
      expect(service.hasLineupCoverage, false);
    });
  });

  group('HTML Parsing', () {
    test('parst Startelf-Slots von den Team-Seiten', () async {
      stubOverviewsAndTeamPages();

      await service.fetchLineups();

      expect(service.isReady, true);
      // 22 Startelf-Spieler + 1 Alternative
      expect(service.playerCacheCount, 23);
    });

    test('ohne Team-Links auf der Übersicht bleibt der Cache leer', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('<html></html>', 200));

      await service.fetchLineups();

      expect(service.playerCacheCount, 0);
      expect(service.isReady, false);
    });

    test('ignoriert Links ohne Spieler-ID', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final overview = _overviewHtml([_bayernPath]);
      final page = '''<html><body>
        <div class="player_position_row">
          <div class="player_position_column">
            <a href="/no-id/">Invalid</a>
          </div>
        </div>
      </body></html>''';

      when(mockHttpClient.get(any)).thenAnswer((invocation) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('/team/')) return http.Response(page, 200);
        return http.Response(overview, 200);
      });

      await service.fetchLineups();

      expect(service.playerCacheCount, 0);
    });

    test('übernimmt das Spielerfoto aus der Aufstellungsseite', () async {
      stubOverviewsAndTeamPages();

      await service.fetchLineups();

      final player = service.getLigainsiderPlayer('', 'Spieler0');
      expect(player, isNotNull);
      expect(
        player!.imageUrl,
        contains('cdn.ligainsider.de/images/player/'),
      );
    });
  });

  group('Player Status', () {
    setUp(() async {
      stubOverviewsAndTeamPages();
      await service.fetchLineups();
    });

    test('Startelf-Spieler ohne Alternative ist likelyStart', () {
      expect(
        service.getPlayerStatus('', 'Spieler3'),
        LigainsiderPlayerStatus.likelyStart,
      );
    });

    test('Startelf-Spieler mit Alternative ist startWithAlternative', () {
      expect(
        service.getPlayerStatus('', 'Spieler0'),
        LigainsiderPlayerStatus.startWithAlternative,
      );
    });

    test('Alternative ist isAlternative', () {
      expect(
        service.getPlayerStatus('', 'Ersatz0'),
        LigainsiderPlayerStatus.isAlternative,
      );
    });

    test('unbekannter Spieler ist out', () {
      expect(
        service.getPlayerStatus('Unbekannt', 'Unbekannt'),
        LigainsiderPlayerStatus.out,
      );
    });

    test('leerer Name matched nie (kein contains-False-Positive)', () {
      expect(service.getPlayerStatus('', ''), LigainsiderPlayerStatus.out);
    });

    test('Namens-Substring matched nicht (Contains → Segment-Match)', () {
      expect(service.getPlayerStatus('', 'Spie'), LigainsiderPlayerStatus.out);
      expect(
        service.getPlayerStatus('', 'Spieler3'),
        LigainsiderPlayerStatus.likelyStart,
      );
    });

    test('hasLineupCoverage erst ab voller S11-Abdeckung', () {
      // Nur 22 S11-Spieler → noch keine volle Abdeckung.
      expect(service.hasLineupCoverage, false);
    });
  });

  group('Player Matching', () {
    setUp(() async {
      stubOverviewsAndTeamPages();
      await service.fetchLineups();
    });

    test('findet Spieler über den vollen Namen', () {
      final player = service.getLigainsiderPlayer('', 'Spieler3');

      expect(player, isNotNull);
      expect(player!.ligainsiderId, 'bayern-spieler3_1003');
      expect(player.name, 'Bayern Spieler3');
    });

    test('liefert null für unbekannte Spieler', () {
      expect(service.getLigainsiderPlayer('Unknown', 'Player'), isNull);
    });
  });

  group('Caching', () {
    test('speichert Spieler, Startelf und Timestamp', () async {
      stubOverviewsAndTeamPages();

      await service.fetchLineups();

      verify(mockPrefs.setString('ligainsider_cache', any)).called(1);
      verify(mockPrefs.setInt('ligainsider_cache_timestamp', any)).called(1);
      verify(mockPrefs.setString('ligainsider_cache_s11', any)).called(1);
      verify(
        mockPrefs.setString('ligainsider_cache_alternatives', any),
      ).called(1);
    });

    test('lädt Startelf-Status aus dem Cache (offline)', () async {
      final cachedPlayer = LigainsiderPlayer(
        id: 'cached-player_999',
        name: 'Cached Player',
        shortName: 'Cached Player',
        teamName: 'Unknown',
        teamId: 'unknown',
        position: 0,
        injuryStatus: InjuryStatus.fit,
        lastUpdate: DateTime.now(),
        ligainsiderId: 'cached-player_999',
      );

      when(
        mockPrefs.getString('ligainsider_cache'),
      ).thenReturn(jsonEncode([cachedPlayer.toJson()]));
      when(
        mockPrefs.getString('ligainsider_cache_s11'),
      ).thenReturn(jsonEncode(['cached-player_999']));
      when(
        mockPrefs.getInt('ligainsider_cache_timestamp'),
      ).thenReturn(DateTime.now().millisecondsSinceEpoch);

      await service.fetchLineups();

      expect(service.isReady, true);
      expect(service.playerCacheCount, 1);
      expect(
        service.getPlayerStatus('Cached', 'Player'),
        LigainsiderPlayerStatus.likelyStart,
      );
    });

    test('ignoriert abgelaufenen Cache', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      when(
        mockPrefs.getString('ligainsider_cache'),
      ).thenReturn(jsonEncode([]));
      when(mockPrefs.getInt('ligainsider_cache_timestamp')).thenReturn(
        DateTime.now()
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch,
      );

      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('<html></html>', 200));

      await service.fetchLineups();

      expect(service.playerCacheCount, 0);
    });

    test('löscht den Cache vollständig', () async {
      stubOverviewsAndTeamPages();
      await service.fetchLineups();
      expect(service.playerCacheCount, greaterThan(0));

      await service.clearCache();

      expect(service.playerCacheCount, 0);
      expect(service.isReady, false);
      verify(mockPrefs.remove('ligainsider_cache')).called(1);
      verify(mockPrefs.remove('ligainsider_cache_timestamp')).called(1);
    });
  });

  group('Error Handling', () {
    test('behandelt HTTP-Fehler ohne Exception', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Error', 500));

      await service.fetchLineups();

      expect(service.isReady, false);
      expect(service.playerCacheCount, 0);
    });

    test('behandelt Netzwerkfehler ohne Exception', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(mockHttpClient.get(any)).thenThrow(Exception('Network error'));

      await service.fetchLineups();

      expect(service.isReady, false);
    });

    test('lädt bei fehlender Verbindung aus dem Cache', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final cachedPlayer = LigainsiderPlayer(
        id: 'offline-player_1',
        name: 'Offline Player',
        shortName: 'Offline Player',
        teamName: 'Unknown',
        teamId: 'unknown',
        position: 0,
        injuryStatus: InjuryStatus.fit,
        lastUpdate: DateTime.now(),
        ligainsiderId: 'offline-player_1',
      );

      when(
        mockPrefs.getString('ligainsider_cache'),
      ).thenReturn(jsonEncode([cachedPlayer.toJson()]));
      when(
        mockPrefs.getString('ligainsider_cache_s11'),
      ).thenReturn(jsonEncode(['offline-player_1']));
      when(
        mockPrefs.getInt('ligainsider_cache_timestamp'),
      ).thenReturn(DateTime.now().millisecondsSinceEpoch);

      await service.fetchLineups();

      expect(service.isReady, true);
      expect(
        service.getPlayerStatus('Offline', 'Player'),
        LigainsiderPlayerStatus.likelyStart,
      );
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
