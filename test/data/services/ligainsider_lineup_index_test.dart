import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kickbasekumpel/data/models/ligainsider_match_model.dart';
import 'package:kickbasekumpel/data/models/ligainsider_model.dart';
import 'package:kickbasekumpel/data/services/ligainsider_lineup_index.dart';
import 'package:kickbasekumpel/data/services/ligainsider_service.dart';

class _MockLigainsiderService extends Mock implements LigainsiderService {}

/// Erzeugt `count` Startelf-Spieler mit eindeutigen Slugs.
List<LineupPlayer> _dummies(int count, {int start = 0}) {
  return [
    for (var i = start; i < start + count; i++)
      LineupPlayer(
        name: 'Spieler$i',
        ligainsiderId: 'dummy-spieler$i_${9000 + i}',
      ),
  ];
}

LigainsiderMatch _match(List<LineupPlayer> starters, {List<LineupRow>? away}) {
  return LigainsiderMatch(
    id: 'match-1',
    homeTeam: 'Heim',
    awayTeam: 'Gast',
    homeLineup: [LineupRow(rowName: 'Startelf', players: starters)],
    awayLineup: away ?? const [],
  );
}

void main() {
  group('LigainsiderLineupIndex.fromMatches', () {
    test('ohne Daten: keine Abdeckung, keine Aussage', () {
      final index = LigainsiderLineupIndex.fromMatches(const []);

      expect(index.hasCoverage, false);
      expect(index.statusFor('Jamal', 'Musiala'), isNull);
    });

    test('erkennt Startelf-Spieler (Slug-Name, Vor- und Nachname)', () {
      final index = LigainsiderLineupIndex.fromMatches([
        _match([
          ..._dummies(170),
          const LineupPlayer(
            name: 'Musiala',
            ligainsiderId: 'jamal-musiala_24149',
          ),
        ]),
      ]);

      expect(index.hasCoverage, true);
      expect(
        index.statusFor('Jamal', 'Musiala'),
        LigainsiderPlayerStatus.likelyStart,
      );
      expect(
        index.statusFor('', 'Musiala'),
        LigainsiderPlayerStatus.likelyStart,
      );
    });

    test('matcht auch, wenn der volle Name als Nachname kommt', () {
      final index = LigainsiderLineupIndex.fromMatches([
        _match([
          ..._dummies(170),
          // Ligainsider-Slug ohne Bindestrich im Vornamen, Kickbase-Name mit
          const LineupPlayer(
            name: 'Minjae',
            ligainsiderId: 'minjae-kim_27022',
          ),
        ]),
      ]);

      // Widgets übergeben `lastName: player.name` = "Min-jae Kim"
      expect(
        index.statusFor('', 'Min-jae Kim'),
        LigainsiderPlayerStatus.likelyStart,
      );
    });

    test('unterscheidet 1. und 2. Option', () {
      final index = LigainsiderLineupIndex.fromMatches([
        _match([
          ..._dummies(170),
          const LineupPlayer(
            name: 'Neuer',
            ligainsiderId: 'manuel-neuer_114',
            alternative: 'Urbig',
          ),
        ]),
      ]);

      expect(
        index.statusFor('', 'Neuer'),
        LigainsiderPlayerStatus.startWithAlternative,
      );
      expect(
        index.statusFor('', 'Urbig'),
        LigainsiderPlayerStatus.isAlternative,
      );
    });

    test('Kurzname der Alternative wird erkannt (Min-jae Kim)', () {
      // Ligainsider liefert bei Alternativen teils nur den Kurznamen
      // ("Minjae"), Kickbase führt "Min-jae Kim".
      final index = LigainsiderLineupIndex.fromMatches([
        _match([
          ..._dummies(170),
          const LineupPlayer(
            name: 'Tah',
            ligainsiderId: 'jonathan-tah_2385',
            alternative: 'Minjae',
          ),
        ]),
      ]);

      expect(
        index.statusFor('', 'Min-jae Kim'),
        LigainsiderPlayerStatus.isAlternative,
      );
      expect(
        index.statusFor('Min-jae', 'Kim'),
        LigainsiderPlayerStatus.isAlternative,
      );
    });

    test('mehrdeutige Nachnamen liefern keine Aussage', () {

      final index = LigainsiderLineupIndex.fromMatches([
        _match([
          ..._dummies(170),
          const LineupPlayer(
            name: 'Kim',
            ligainsiderId: 'minjae-kim_27022',
          ),
          const LineupPlayer(
            name: 'Kim',
            ligainsiderId: 'seongsu-kim_27023',
          ),
        ]),
      ]);

      expect(index.statusFor('', 'Kim'), isNull);
    });

    test('unbekannter Spieler ist out – aber nur bei voller Abdeckung', () {
      final complete = LigainsiderLineupIndex.fromMatches([
        _match(_dummies(170)),
      ]);
      expect(
        complete.statusFor('Unbekannt', 'Unbekannt'),
        LigainsiderPlayerStatus.out,
      );

      final incomplete = LigainsiderLineupIndex.fromMatches([
        _match(_dummies(10)),
      ]);
      expect(incomplete.hasCoverage, false);
      expect(incomplete.statusFor('Unbekannt', 'Unbekannt'), isNull);
    });

    test('leerer Name liefert keine Aussage', () {
      final index = LigainsiderLineupIndex.fromMatches([
        _match([..._dummies(170)]),
      ]);

      expect(index.statusFor('', ''), isNull);
    });
  });

  group('LigainsiderLineupIndex.fromService', () {
    test('delegiert an den lokalen Service', () {
      final service = _MockLigainsiderService();
      when(() => service.hasLineupCoverage).thenReturn(true);
      when(() => service.getPlayerStatus('Max', 'Mustermann')).thenReturn(
        LigainsiderPlayerStatus.likelyStart,
      );

      final index = LigainsiderLineupIndex.fromService(service);

      expect(index.hasCoverage, true);
      expect(
        index.statusFor('Max', 'Mustermann'),
        LigainsiderPlayerStatus.likelyStart,
      );
    });

    test('ohne Abdeckung wird out zu "keine Aussage"', () {
      final service = _MockLigainsiderService();
      when(() => service.hasLineupCoverage).thenReturn(false);
      when(() => service.getPlayerStatus(any(), any())).thenReturn(
        LigainsiderPlayerStatus.out,
      );

      final index = LigainsiderLineupIndex.fromService(service);

      expect(index.hasCoverage, false);
      expect(index.statusFor('Max', 'Mustermann'), isNull);
    });
  });
}
