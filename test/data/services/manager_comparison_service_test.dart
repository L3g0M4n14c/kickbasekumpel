import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/manager_comparison_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/manager_comparison_service.dart';

ManagerTransferHistoryEntry _transfer({
  required String id,
  required String playerId,
  required int price,
  int transferType = 1,
  int? marketValueAtTransfer,
}) {
  return ManagerTransferHistoryEntry(
    id: id,
    leagueId: 'l1',
    managerId: 'm1',
    managerName: 'Anna',
    playerId: playerId,
    playerName: 'Spieler $id',
    price: price,
    transferType: transferType,
    timestamp: DateTime.utc(2026, 8, 21),
    marketValueAtTransfer: marketValueAtTransfer,
  );
}

void main() {
  late ManagerComparisonService service;

  setUp(() {
    service = ManagerComparisonService();
  });

  group('ManagerComparisonService.transferStats', () {
    test('berechnet Käufe, Investition und Ø Deal-Qualität', () {
      final stats = service.transferStats(
        transfers: [
          _transfer(
            id: 't1',
            playerId: 'p1',
            price: 10000000,
            marketValueAtTransfer: 12000000,
          ),
          _transfer(
            id: 't2',
            playerId: 'p2',
            price: 5000000,
            marketValueAtTransfer: 4000000,
          ),
        ],
      );

      expect(stats.purchaseCount, 2);
      expect(stats.totalInvested, 15000000);
      // Ø ((12M − 10M) + (4M − 5M)) / 2 = 500.000
      expect(stats.avgDealQuality, 500000);
    });

    test('berechnet den Kursgewinn noch gehaltener Käufe', () {
      final stats = service.transferStats(
        transfers: [
          _transfer(
            id: 't1',
            playerId: 'p1',
            price: 10000000,
            marketValueAtTransfer: 10000000,
          ),
          _transfer(
            id: 't2',
            playerId: 'p2',
            price: 5000000,
            marketValueAtTransfer: 5000000,
          ),
        ],
        currentPlayerValues: {'p1': 11000000, 'p2': 6000000},
      );

      // (11M − 10M) + (6M − 5M)
      expect(stats.valueGain, 2000000);
    });

    test('ignoriert Verkäufe (transferType != 1)', () {
      final stats = service.transferStats(
        transfers: [
          _transfer(id: 't1', playerId: 'p1', price: 7000000, transferType: 2),
        ],
      );

      expect(stats.purchaseCount, 0);
      expect(stats.hasPurchaseData, isFalse);
    });

    test('liefert leere Kennzahlen ohne Käufe, behält aber die Einnahmen', () {
      final stats = service.transferStats(transfers: [], totalIncome: 3000000);

      expect(stats.purchaseCount, 0);
      expect(stats.totalInvested, 0);
      expect(stats.avgDealQuality, 0);
      expect(stats.totalIncome, 3000000);
    });

    test('lässt Käufe ohne Marktwert beim Kauf unberücksichtigt', () {
      final stats = service.transferStats(
        transfers: [
          _transfer(id: 't1', playerId: 'p1', price: 10000000),
          _transfer(
            id: 't2',
            playerId: 'p2',
            price: 2000000,
            marketValueAtTransfer: 4000000,
          ),
        ],
      );

      // Ø nur über t2: 4M − 2M
      expect(stats.avgDealQuality, 2000000);
    });
  });

  group('ManagerComparisonService.positionPoints', () {
    test('aggregiert Marktwert, Punkte und Anzahl je Position', () {
      final positions = service.positionPoints([
        {'pos': 1, 'mv': 5000000, 'p': 100},
        {'pos': 1, 'mv': 3000000, 'p': 50},
        {'pos': 2, 'mv': 2000000, 'p': 20},
      ]);

      expect(positions, hasLength(4));

      final torwart = positions.firstWhere((p) => p.position == 1);
      expect(torwart.label, 'Torwart');
      expect(torwart.points, 150);
      expect(torwart.marketValue, 8000000);
      expect(torwart.playerCount, 2);

      final sturm = positions.firstWhere((p) => p.position == 4);
      expect(sturm.points, 0);
      expect(sturm.playerCount, 0);
    });
  });

  group('ManagerComparisonService.buildSide', () {
    test('filtert die letzten 5 Spieltage und summiert die Punkte', () {
      final side = service.buildSide(
        managerId: 'm1',
        managerName: 'Anna',
        matchdayPoints: [
          for (final day in [1, 2, 3, 4, 5, 6, 7])
            MatchdayPoints(matchDay: day, points: day * 10),
        ],
      );

      expect(side.lastMatchdayPoints.map((m) => m.matchDay), [7, 6, 5, 4, 3]);
      expect(side.pointsLast5, 250);
    });

    test('übernimmt Budget und Teamwert', () {
      final side = service.buildSide(
        managerId: 'm1',
        managerName: 'Anna',
        teamValue: 42000000,
        budget: 7500000,
      );

      expect(side.teamValue, 42000000);
      expect(side.budget, 7500000);
      expect(side.pointsLast5, 0);
      expect(side.lastMatchdayPoints, isEmpty);
    });
  });

  group('ManagerComparisonService.compare', () {
    ManagerComparisonSide sideA({int? budget = 10000000}) {
      return service.buildSide(
        managerId: 'a',
        managerName: 'Anna',
        teamValue: 50000000,
        budget: budget,
        matchdayPoints: [
          MatchdayPoints(matchDay: 1, points: 30),
          MatchdayPoints(matchDay: 2, points: 45),
        ],
        positionPoints: const [
          PositionPoints(position: 1, points: 100, marketValue: 8000000),
          PositionPoints(position: 2, points: 200, marketValue: 12000000),
        ],
        transferStats: const TransferComparisonStats(
          purchaseCount: 3,
          totalInvested: 21000000,
          avgDealQuality: 1200000,
        ),
      );
    }

    ManagerComparisonSide sideB() {
      return service.buildSide(
        managerId: 'b',
        managerName: 'Ben',
        teamValue: 48000000,
        budget: 9000000,
        matchdayPoints: [
          MatchdayPoints(matchDay: 1, points: 20),
          MatchdayPoints(matchDay: 2, points: 40),
        ],
        positionPoints: const [
          PositionPoints(position: 1, points: 112, marketValue: 6000000),
          PositionPoints(position: 2, points: 198, marketValue: 14000000),
        ],
        transferStats: const TransferComparisonStats(
          purchaseCount: 2,
          totalInvested: 9000000,
          avgDealQuality: -400000,
        ),
      );
    }

    test('stellt alle Kern-Kennzahlen gegenüber', () {
      final comparison = service.compare(a: sideA(), b: sideB());

      expect(comparison.rows, hasLength(4));
      final metrics = comparison.rows.map((r) => r.metric).toList();
      expect(
        metrics,
        containsAll([
          ComparisonMetric.squadValue,
          ComparisonMetric.pointsLast5,
          ComparisonMetric.transferSuccess,
          ComparisonMetric.budget,
        ]),
      );

      final squadRow = comparison.rows.firstWhere(
        (r) => r.metric == ComparisonMetric.squadValue,
      );
      expect(squadRow.valueA, 50000000);
      expect(squadRow.valueB, 48000000);
      expect(squadRow.aIsBetter, isTrue);

      final pointsRow = comparison.rows.firstWhere(
        (r) => r.metric == ComparisonMetric.pointsLast5,
      );
      expect(pointsRow.valueA, 75);
      expect(pointsRow.valueB, 60);
    });

    test('lässt die Budget-Zeile weg, wenn Budget nicht berechenbar ist', () {
      final comparison = service.compare(a: sideA(budget: null), b: sideB());

      expect(
        comparison.rows.map((r) => r.metric),
        isNot(contains(ComparisonMetric.budget)),
      );
    });

    test('vergleicht die Kader positionsweise', () {
      final comparison = service.compare(a: sideA(), b: sideB());

      expect(comparison.positionComparisons, hasLength(2));
      final torwart = comparison.positionComparisons.firstWhere(
        (p) => p.position == 1,
      );
      expect(torwart.pointsDelta, -12);
      expect(torwart.label, 'Torwart');
    });

    test('formuliert Stärken und Schwächen als Klartext', () {
      final comparison = service.compare(
        a: sideA(),
        b: sideB(),
        aLabel: 'Du',
        bLabel: 'Ben',
      );

      // A stärker: Kaderwert, Punkte, Transfer-Erfolg, Budget.
      expect(comparison.strengths, contains('Dein Kaderwert ist 2.0M€ höher'));
      expect(
        comparison.strengths,
        contains('Deine Punkte der letzten 5 Spieltage sind 15 besser'),
      );
      expect(
        comparison.strengths,
        contains('Dein Transfer-Erfolg ist besser (Ø +1.2M€ pro Kauf)'),
      );
      expect(comparison.strengths, contains('Dein Budget ist 1.0M€ höher'));

      // B stärker: Torwart (+12 Punkte) – genau wie im Issue-Beispiel.
      expect(
        comparison.weaknesses,
        contains('Bens Torwart ist 12 Punkte stärker'),
      );
      // Abwehr: nur 2 Punkte Unterschied → unterhalb der Schwelle.
      expect(comparison.weaknesses.join(' | '), isNot(contains('Abwehr')));
    });

    test('formuliert das Fazit aus Sicht der zweiten Seite umgekehrt', () {
      final comparison = service.compare(
        a: sideB(),
        b: sideA(),
        aLabel: 'Ben',
        bLabel: 'Du',
      );

      expect(
        comparison.strengths,
        contains('Bens Torwart ist 12 Punkte stärker'),
      );
      expect(comparison.weaknesses, contains('Dein Kaderwert ist 2.0M€ höher'));
    });

    test('erzeugt keine Zeilen bei ausgeglichenen Kategorien', () {
      final a = service.buildSide(
        managerId: 'a',
        managerName: 'Anna',
        teamValue: 50000000,
        budget: 10000000,
      );
      final b = service.buildSide(
        managerId: 'b',
        managerName: 'Ben',
        teamValue: 50000000,
        budget: 10000000,
      );

      final comparison = service.compare(a: a, b: b);

      expect(comparison.strengths, isEmpty);
      expect(comparison.weaknesses, isEmpty);
    });
  });
}
