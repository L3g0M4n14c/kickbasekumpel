import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/services/squad_benchmark_service.dart';

Player _player({
  required String id,
  required int position,
  required int marketValue,
  required int totalPoints,
}) {
  return Player(
    id: id,
    firstName: 'Vor',
    lastName: id,
    profileBigUrl: '',
    teamName: 'Team',
    teamId: 't1',
    position: position,
    number: 1,
    averagePoints: 0,
    totalPoints: totalPoints,
    marketValue: marketValue,
    marketValueTrend: 0,
    tfhmvt: 0,
    prlo: 0,
    stl: 0,
    status: 0,
    userOwnsPlayer: true,
  );
}

void main() {
  late SquadBenchmarkService service;

  setUp(() {
    service = SquadBenchmarkService();
  });

  group('SquadBenchmarkService.aggregate', () {
    test('berechnet positionsweise Ligen-Durchschnitt und eigenen Kader', () {
      // Eigener Kader: 1 TW (5 Mio, 100 Pkt), 2 ABW (je 3 Mio, 80 Pkt)
      final own = [
        _player(id: 'tw', position: 1, marketValue: 5000000, totalPoints: 100),
        _player(id: 'abw1', position: 2, marketValue: 3000000, totalPoints: 80),
        _player(id: 'abw2', position: 2, marketValue: 3000000, totalPoints: 80),
      ];

      // Fremd-Manager A: TW 7 Mio, ABW 1 Mio
      final squadA = [
        {'pos': 1, 'mv': 7000000, 'p': 60},
        {'pos': 2, 'mv': 1000000, 'p': 40},
      ];
      // Fremd-Manager B: TW 3 Mio, ABW 3 Mio
      final squadB = [
        {'pos': 1, 'mv': 3000000, 'p': 120},
        {'pos': 2, 'mv': 3000000, 'p': 80},
      ];

      final benchmark = service.aggregate(
        ownPlayers: own,
        managerSquads: {'a': squadA, 'b': squadB},
      );

      expect(benchmark.managerCount, 2);

      // TW: eigen 5 Mio vs. Ø (7+3)/2 = 5 Mio → Delta 0
      final tw = benchmark.positions.firstWhere((p) => p.position == 1);
      expect(tw.ownMarketValue, 5000000);
      expect(tw.leagueAvgMarketValue, 5000000);
      expect(tw.marketValueDelta, 0);
      expect(tw.ownAvgPoints, 100);
      expect(tw.leagueAvgPoints, 90); // (60 + 120) / 2

      // ABW: eigen 6 Mio vs. Ø (1+3)/2 = 2 Mio → Delta +4 Mio
      final abw = benchmark.positions.firstWhere((p) => p.position == 2);
      expect(abw.ownMarketValue, 6000000);
      expect(abw.leagueAvgMarketValue, 2000000);
      expect(abw.marketValueDelta, 4000000);
      expect(abw.ownCount, 2);
      expect(abw.leagueAvgCount, 1);

      // Gesamt: eigen 11 Mio vs. Ø (8 + 6) / 2 = 7 Mio
      expect(benchmark.ownTotalMarketValue, 11000000);
      expect(benchmark.leagueAvgTotalMarketValue, 7000000);
      expect(benchmark.totalMarketValueDelta, 4000000);
    });

    test('Positionen ohne Spieler liefern Nullen statt zu crashen', () {
      final benchmark = service.aggregate(
        ownPlayers: const [],
        managerSquads: {},
      );

      expect(benchmark.managerCount, 0);
      expect(benchmark.positions, hasLength(4));
      expect(benchmark.positions.every((p) => p.leagueAvgMarketValue == 0), isTrue);
    });

    test('Spieler ohne gültige Positions-Code werden ignoriert', () {
      final squad = [
        {'pos': 9, 'mv': 9999999, 'p': 999},
      ];

      final benchmark = service.aggregate(
        ownPlayers: const [],
        managerSquads: {'a': squad},
      );

      expect(benchmark.managerCount, 1);
      expect(benchmark.ownTotalMarketValue, 0);
      expect(
        benchmark.positions.every((p) => p.leagueAvgMarketValue == 0),
        isTrue,
      );
    });

    test('Liga-Ø-Punkte sind Ø pro Spieler, nicht Summe pro Manager', () {
      // Zwei Manager mit je 2 MF-Spielern: (100+50+60+90)/4 = 75.
      // Die Summe-pro-Manager-Rechnung fälschlich: 300/2 = 150.
      final squadA = [
        {'pos': 3, 'mv': 1000000, 'p': 100},
        {'pos': 3, 'mv': 1000000, 'p': 50},
      ];
      final squadB = [
        {'pos': 3, 'mv': 1000000, 'p': 60},
        {'pos': 3, 'mv': 1000000, 'p': 90},
      ];

      final benchmark = service.aggregate(
        ownPlayers: const [],
        managerSquads: {'a': squadA, 'b': squadB},
      );

      final mf = benchmark.positions.firstWhere((p) => p.position == 3);
      expect(mf.leagueAvgPoints, 75);
      expect(mf.leagueAvgCount, 2);
    });
  });
}
