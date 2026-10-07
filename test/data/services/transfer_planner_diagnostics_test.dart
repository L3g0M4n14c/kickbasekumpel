import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';

/// Regressionstests für die Diagnose-Ausgabe des Transferplaners:
/// Wenn kein Szenario gefunden wird, muss [TransferPlannerResult.noPlanDetails]
/// die konkrete Ursache nennen (leerer Kader, leerer Markt, Ablehnungsgründe).
void main() {
  late TransferPlannerService service;

  setUp(() {
    service = TransferPlannerService();
  });

  Player p(String id, int position, double ap, int mv) {
    return Player(
      id: id,
      firstName: 'First',
      lastName: 'Last-$id',
      profileBigUrl: '',
      teamName: 'FC Team',
      teamId: 't1',
      position: position,
      number: 1,
      averagePoints: ap,
      totalPoints: (ap * 10).round(),
      marketValue: mv,
      marketValueTrend: 0,
      tfhmvt: 0,
      prlo: 0,
      stl: 0,
      status: 0,
      userOwnsPlayer: true,
    );
  }

  /// Exakt 11 Spieler (4-4-2 ist die einzig legale Formation) – damit
  /// Cross-Position-Fallbacks die Formation zerstören und verworfen werden.
  List<Player> legalSquad() => [
    p('gk-1', 1, 8.0, 8000000),
    p('def-1', 2, 7.0, 12000000),
    p('def-2', 2, 6.5, 10000000),
    p('def-3', 2, 6.0, 9000000),
    p('def-4', 2, 5.5, 8000000),
    p('mid-1', 3, 9.0, 15000000),
    p('mid-2', 3, 8.5, 14000000),
    p('mid-3', 3, 8.0, 13000000),
    p('mid-4', 3, 7.5, 11000000),
    p('fwd-1', 4, 10.0, 18000000),
    p('fwd-2', 4, 9.5, 16000000),
  ];

  test('leerer Kader: noPlanDetails nennt Kader als Ursache', () {
    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: const [],
        marketPlayers: [p('m-1', 2, 9.0, 5000000)],
        currentBudget: 10000000,
      ),
    );

    expect(result.scenarios, isEmpty);
    expect(
      result.noPlanReason,
      'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
    );
    expect(result.noPlanDetails, isNotNull);
    expect(result.noPlanDetails!, contains('Kader ist leer'));
  });

  test('leerer Markt: noPlanDetails nennt Markt als Ursache', () {
    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: legalSquad(),
        marketPlayers: const [],
        currentBudget: 10000000,
      ),
    );

    expect(result.scenarios, isEmpty);
    expect(
      result.noPlanReason,
      'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
    );
    expect(result.noPlanDetails, isNotNull);
    expect(result.noPlanDetails!, contains('Markt liefert aktuell 0'));
  });

  test('Positions-Mismatch: noPlanDetails nennt fehlende Position', () {
    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: legalSquad(),
        // position=0 wie bei fehlgeschlagenem pos-Parsing
        marketPlayers: [
          p('m-unknown-pos', 0, 99.0, 5000000),
          p('m-unknown-pos-2', 0, 98.0, 4000000),
        ],
        currentBudget: 10000000,
      ),
    );

    expect(result.scenarios, isEmpty);
    expect(
      result.noPlanReason,
      'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
    );
    expect(result.noPlanDetails, contains('ohne passende Position'));
    expect(result.noPlanDetails, contains('2 von 2'));
  });

  test('keine Verbesserung: noPlanDetails nennt fehlenden Punktegewinn', () {
    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: legalSquad(),
        // Schwächer als der schwächste Starter jeder Position UND schwächer
        // als jeder Cross-Position-Fallback-Verkauf – also ohne Formation-
        // Shift einen positiven Gewinn möglich.
        marketPlayers: [
          p('m-def-barely', 2, 5.3, 500000),
          p('m-mid-barely', 3, 5.4, 500000),
          p('m-fwd-barely', 4, 5.4, 500000),
        ],
        currentBudget: 10000000,
      ),
    );

    expect(result.scenarios, isEmpty);
    expect(
      result.noPlanReason,
      'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
    );
    expect(result.noPlanDetails, contains('ohne Punktegewinn'));
    expect(result.noPlanDetails, contains('Untersucht: 3 Marktspieler'));
  });

  test('Szenarien gefunden: noPlanDetails bleibt null', () {
    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: legalSquad(),
        marketPlayers: [p('m-upgrade', 4, 15.0, 20000000)],
        currentBudget: 30000000,
      ),
    );

    expect(result.scenarios, isNotEmpty);
    expect(result.noPlanReason, isNull);
    expect(result.noPlanDetails, isNull);
  });
}
