import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';

/// Repro-Test mit realistischen Kickbase-Daten (Feldwerte wie in der echten API).
void main() {
  late TransferPlannerService service;

  setUp(() {
    service = TransferPlannerService();
  });

  Player p(
    String id,
    int position,
    double ap,
    int mv, {
    int prc = -1,
  }) {
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
      userOwnsPlayer: false,
    );
  }

  test('REALISTIC: full legal squad + rich market + small budget', () {
    final squad = [
      // 2 GK
      p('gk-1', 1, 8.2, 12000000),
      p('gk-2', 1, 1.5, 2000000),
      // 5 DEF
      p('def-1', 2, 7.0, 15000000),
      p('def-2', 2, 6.2, 10000000),
      p('def-3', 2, 5.5, 8000000),
      p('def-4', 2, 4.8, 5000000),
      p('def-5', 2, 2.0, 2000000),
      // 5 MID
      p('mid-1', 3, 9.5, 20000000),
      p('mid-2', 3, 8.0, 12000000),
      p('mid-3', 3, 6.5, 7000000),
      p('mid-4', 3, 3.5, 3000000),
      p('mid-5', 3, 1.8, 1500000),
      // 4 FWD
      p('fwd-1', 4, 11.0, 25000000),
      p('fwd-2', 4, 7.5, 14000000),
      p('fwd-3', 4, 4.0, 6000000),
      p('fwd-4', 4, 1.2, 1000000),
    ];

    final market = [
      // teure Upgrades
      p('m-def-top', 2, 8.5, 18000000),
      p('m-mid-top', 3, 10.5, 30000000),
      p('m-fwd-top', 4, 12.5, 28000000),
      // bezahlbare Upgrades
      p('m-def-cheap', 2, 6.0, 6000000),
      p('m-mid-cheap', 3, 7.5, 9000000),
      p('m-fwd-cheap', 4, 8.5, 10000000),
      // Abschläge
      p('m-def-down', 2, 3.0, 2000000),
      p('m-mid-down', 3, 2.0, 1500000),
      p('m-fwd-down', 4, 1.0, 800000),
    ];

    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: market,
        currentBudget: 5000000,
      ),
    );

    // ignore: avoid_print
    print('scenarios: ${result.scenarios.length}');
    // ignore: avoid_print
    print('noPlanReason: ${result.noPlanReason}');
    for (final s in result.scenarios) {
      // ignore: avoid_print
      print('  - ${s.title} | gain=${s.score.startingElevenGain} | budgetAfter=${s.budgetAfter}');
    }

    expect(result.scenarios, isNotEmpty);
  });

  test('REALISTIC B: squad without goalkeeper (illegal lineup path)', () {
    final squad = [
      // KEIN GK!
      p('def-1', 2, 7.0, 15000000),
      p('def-2', 2, 6.2, 10000000),
      p('def-3', 2, 5.5, 8000000),
      p('def-4', 2, 4.8, 5000000),
      p('mid-1', 3, 9.5, 20000000),
      p('mid-2', 3, 8.0, 12000000),
      p('mid-3', 3, 6.5, 7000000),
      p('mid-4', 3, 3.5, 3000000),
      p('fwd-1', 4, 11.0, 25000000),
      p('fwd-2', 4, 7.5, 14000000),
      p('fwd-3', 4, 4.0, 6000000),
    ];

    final market = [
      p('m-gk', 1, 5.5, 3000000),
      p('m-def-cheap', 2, 6.0, 6000000),
      p('m-mid-cheap', 3, 7.5, 9000000),
      p('m-fwd-cheap', 4, 8.5, 10000000),
    ];

    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: market,
        currentBudget: 5000000,
      ),
    );

    // ignore: avoid_print
    print('B scenarios: ${result.scenarios.length} / noPlanReason: ${result.noPlanReason}');
    for (final s in result.scenarios) {
      // ignore: avoid_print
      print('  - ${s.title} | gain=${s.score.startingElevenGain}');
    }

    expect(result.scenarios, isNotEmpty);
  });

  test('REALISTIC C: squad avg points scale like real API (large values)', () {
    // Kickbase `ap` kann auch deutlich größere Werte haben
    final squad = [
      p('gk-1', 1, 250.0, 12000000),
      p('def-1', 2, 200.0, 15000000),
      p('def-2', 2, 180.0, 10000000),
      p('def-3', 2, 150.0, 8000000),
      p('mid-1', 3, 220.0, 20000000),
      p('mid-2', 3, 190.0, 12000000),
      p('mid-3', 3, 120.0, 7000000),
      p('fwd-1', 4, 300.0, 25000000),
      p('fwd-2', 4, 160.0, 14000000),
      p('fwd-3', 4, 90.0, 6000000),
    ];

    final market = [
      p('m-def', 2, 210.0, 6000000),
      p('m-mid', 3, 250.0, 9000000),
      p('m-fwd', 4, 280.0, 10000000),
    ];

    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: market,
        currentBudget: 5000000,
      ),
    );

    // ignore: avoid_print
    print('C scenarios: ${result.scenarios.length} / noPlanReason: ${result.noPlanReason}');
    expect(result.scenarios, isNotEmpty);
  });

  test('REALISTIC D: market players with position=0 (pos parse failure)', () {
    final squad = [
      p('gk-1', 1, 8.2, 12000000),
      p('def-1', 2, 7.0, 15000000),
      p('def-2', 2, 6.2, 10000000),
      p('def-3', 2, 5.5, 8000000),
      p('def-4', 2, 4.8, 5000000),
      p('mid-1', 3, 9.5, 20000000),
      p('mid-2', 3, 8.0, 12000000),
      p('mid-3', 3, 6.5, 7000000),
      p('mid-4', 3, 3.5, 3000000),
      p('fwd-1', 4, 11.0, 25000000),
      p('fwd-2', 4, 7.5, 14000000),
      p('fwd-3', 4, 4.0, 6000000),
    ];

    final market = [
      // position=0 wie bei fehlgeschlagenem pos-Parsing
      p('m-def-unknown', 0, 8.5, 6000000),
      p('m-mid-unknown', 0, 10.5, 9000000),
    ];

    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: market,
        currentBudget: 5000000,
      ),
    );

    // ignore: avoid_print
    print(
      'D scenarios: ${result.scenarios.length} / noPlanReason: ${result.noPlanReason}',
    );
    expect(result.scenarios, isEmpty);
    expect(
      result.noPlanReason,
      'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
    );
  });

  test('REALISTIC E: squad with only 2 defenders (no legal formation)', () {
    final squad = [
      p('gk-1', 1, 8.2, 12000000),
      // nur 2 DEF -> keine Formation passt
      p('def-1', 2, 7.0, 15000000),
      p('def-2', 2, 6.2, 10000000),
      // viele MIDs
      p('mid-1', 3, 9.5, 20000000),
      p('mid-2', 3, 8.0, 12000000),
      p('mid-3', 3, 6.5, 7000000),
      p('mid-4', 3, 3.5, 3000000),
      p('mid-5', 3, 1.8, 1500000),
      // viele FWDs
      p('fwd-1', 4, 11.0, 25000000),
      p('fwd-2', 4, 7.5, 14000000),
      p('fwd-3', 4, 4.0, 6000000),
      p('fwd-4', 4, 1.2, 1000000),
    ];

    final market = [
      p('m-def-cheap', 2, 6.0, 6000000),
      p('m-mid-cheap', 3, 7.5, 9000000),
      p('m-fwd-cheap', 4, 8.5, 10000000),
    ];

    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: market,
        currentBudget: 5000000,
      ),
    );

    // ignore: avoid_print
    print('E scenarios: ${result.scenarios.length} / noPlanReason: ${result.noPlanReason}');
    for (final s in result.scenarios) {
      // ignore: avoid_print
      print('  - ${s.title} | gain=${s.score.startingElevenGain}');
    }
  });
}
