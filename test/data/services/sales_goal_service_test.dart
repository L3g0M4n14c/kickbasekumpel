import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/sales_goal_service.dart';

void main() {
  const service = SalesGoalService();

  Player buildPlayer({
    required String id,
    int position = 3,
    int status = 0,
    int marketValue = 10000000,
    int tfhmvt = 0,
  }) {
    return Player(
      id: id,
      firstName: 'Max',
      lastName: 'Spieler $id',
      profileBigUrl: '',
      teamName: 'FC Test',
      teamId: 'team-1',
      position: position,
      number: 1,
      averagePoints: 5,
      totalPoints: 100,
      marketValue: marketValue,
      marketValueTrend: 0,
      tfhmvt: tfhmvt,
      prlo: 0,
      stl: 0,
      status: status,
      userOwnsPlayer: true,
    );
  }

  Recommendation buildRec({
    required String id,
    required int estimatedValue,
    double score = 50,
    String action = 'hold',
  }) {
    return Recommendation(
      id: 'rec-$id',
      leagueId: 'league-1',
      playerId: id,
      playerName: 'Spieler $id',
      score: score,
      reason: 'Form schwach.',
      action: action,
      currentMarketValue: 10000000,
      estimatedValue: estimatedValue,
      confidence: 0.5,
      timestamp: DateTime(2026, 6, 10),
      category: 'sell',
    );
  }

  /// Empfehlungen für einen ganzen Kader; [scores], [values] und [actions]
  /// überschreiben die Standardwerte pro Spieler-ID.
  List<Recommendation> buildRecs(
    List<Player> squad, {
    Map<String, double> scores = const {},
    Map<String, int> values = const {},
    Map<String, String> actions = const {},
  }) => [
    for (final player in squad)
      buildRec(
        id: player.id,
        estimatedValue: values[player.id] ?? player.marketValue,
        score: scores[player.id] ?? 50,
        action: actions[player.id] ?? 'hold',
      ),
  ];

  group('SalesGoalService.rankForGoal', () {
    group('Budget ins Plus', () {
      test('ohne Budget-Lücke gibt es keine Verkäufe', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: [buildPlayer(id: 'a')],
          recommendations: [buildRec(id: 'a', estimatedValue: 5000000)],
          budget: 2500000,
        );

        expect(outcome.sales, isEmpty);
        expect(outcome.info, contains('Plus'));
      });

      test('kritische Spieler zuerst, dann die schwächsten Spieler', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: [
            buildPlayer(id: 'critical', status: 1, marketValue: 2000000),
            buildPlayer(id: 'strong', marketValue: 20000000),
            buildPlayer(id: 'weak', marketValue: 3000000),
          ],
          recommendations: [
            buildRec(id: 'critical', estimatedValue: 2000000, score: 50),
            buildRec(id: 'strong', estimatedValue: 20000000, score: 80),
            buildRec(id: 'weak', estimatedValue: 3000000, score: 20),
          ],
          budget: -10000000,
          formations: const [],
        );

        // Der starke Spieler bleibt – verkauft wird zuerst, wer am
        // wenigsten wehtut (niedrigster Score).
        expect(outcome.sales.map((s) => s.playerId), [
          'critical',
          'weak',
          'strong',
        ]);
      });

      test('bricht ab, sobald die Budget-Lücke gedeckt ist', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: [
            buildPlayer(id: 'strong', marketValue: 30000000),
            buildPlayer(id: 'weakA', marketValue: 6000000),
            buildPlayer(id: 'weakB', marketValue: 5000000),
          ],
          recommendations: [
            buildRec(id: 'strong', estimatedValue: 30000000, score: 90),
            buildRec(id: 'weakA', estimatedValue: 6000000, score: 10),
            buildRec(id: 'weakB', estimatedValue: 5000000, score: 15),
          ],
          budget: -10000000,
          formations: const [],
        );

        // 6M + 5M decken die Lücke – der starke Spieler bleibt im Kader.
        expect(outcome.sales.map((s) => s.playerId), ['weakA', 'weakB']);
      });

      test('verkauft nie unter die Startelf (11 + Formation)', () {
        // Spielbare Startelf 4-4-2 plus zwei schwache Mittelfeld-Überzahl.
        final squad = [
          buildPlayer(id: 'tw', position: 1, marketValue: 20000000),
          for (var i = 1; i <= 4; i++)
            buildPlayer(id: 'abw$i', position: 2, marketValue: 15000000),
          for (var i = 1; i <= 4; i++)
            buildPlayer(id: 'm$i', position: 3, marketValue: 15000000),
          for (var i = 1; i <= 2; i++)
            buildPlayer(id: 'st$i', position: 4, marketValue: 15000000),
          buildPlayer(id: 'weakA', position: 3, marketValue: 3000000),
          buildPlayer(id: 'weakB', position: 3, marketValue: 3000000),
        ];
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: squad,
          recommendations: buildRecs(
            squad,
            scores: {'weakA': 10, 'weakB': 15},
            values: {'weakA': 3000000, 'weakB': 3000000},
          ),
          budget: -6000000,
        );

        // Nur die Überzahl geht – die Startelf bleibt komplett.
        expect(outcome.sales.map((s) => s.playerId), ['weakA', 'weakB']);
        expect(outcome.info, isNull);
      });

      test('schützt den einzigen Torwart und den einzigen Stürmer', () {
        final squad = [
          buildPlayer(id: 'tw', position: 1, marketValue: 1000000),
          buildPlayer(id: 'st', position: 4, marketValue: 1000000),
          for (var i = 1; i <= 6; i++)
            buildPlayer(id: 'abw$i', position: 2, marketValue: 5000000),
          for (var i = 1; i <= 4; i++)
            buildPlayer(id: 'm$i', position: 3, marketValue: 5000000),
        ];
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: squad,
          recommendations: buildRecs(
            squad,
            // TW und ST haben die schwächsten Scores – sind aber unverkäuflich.
            scores: {'tw': 3, 'st': 5, 'abw1': 20},
            values: {'tw': 1000000, 'st': 1000000},
          ),
          budget: -1000000,
        );

        expect(outcome.sales.map((s) => s.playerId), ['abw1']);
      });

      test('Info, wenn die Lücke nicht gedeckt werden kann', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: [
            buildPlayer(id: 'tw', position: 1),
            buildPlayer(id: 'st', position: 4),
          ],
          recommendations: [
            buildRec(id: 'tw', estimatedValue: 1000000),
            buildRec(id: 'st', estimatedValue: 1000000),
          ],
          budget: -5000000,
        );

        expect(outcome.sales, isEmpty);
        expect(outcome.info, contains('nicht'));
      });

      test('Priorität folgt der Rest-Lücke', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: [
            buildPlayer(id: 'critical', status: 1, marketValue: 2000000),
            buildPlayer(id: 'strong', marketValue: 20000000),
            buildPlayer(id: 'weak', marketValue: 3000000),
          ],
          recommendations: [
            buildRec(id: 'critical', estimatedValue: 2000000, score: 50),
            buildRec(id: 'strong', estimatedValue: 20000000, score: 80),
            buildRec(id: 'weak', estimatedValue: 3000000, score: 20),
          ],
          budget: -10000000,
          formations: const [],
        );

        final byId = {for (final s in outcome.sales) s.playerId: s};
        // Kritische Spieler sind immer Hoch.
        expect(byId['critical']!.priority, SalePriority.high);
        // 3M reißen an der Rest-Lücke von 8M wenig -> Niedrig.
        expect(byId['weak']!.priority, SalePriority.low);
        // 20M decken die Rest-Lücke von 5M.
        expect(byId['strong']!.priority, SalePriority.high);
      });

      test('Erlös über der halben Rest-Lücke ergibt Mittel', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.budgetBoost,
          squad: [buildPlayer(id: 'a', marketValue: 6000000)],
          recommendations: [buildRec(id: 'a', estimatedValue: 6000000)],
          budget: -10000000,
          formations: const [],
        );

        expect(outcome.sales.single.priority, SalePriority.medium);
      });
    });

    group('Maximaler Profit', () {
      test('nur Verkaufskandidaten, nach Erlös sortiert', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.maxProfit,
          squad: [
            buildPlayer(id: 'a', marketValue: 12000000),
            buildPlayer(id: 'b', marketValue: 6000000),
            buildPlayer(id: 'c', marketValue: 20000000),
          ],
          recommendations: [
            buildRec(
              id: 'a',
              estimatedValue: 12000000,
              score: 30,
              action: 'sell',
            ),
            buildRec(
              id: 'b',
              estimatedValue: 6000000,
              score: 50,
              action: 'hold',
            ),
            buildRec(
              id: 'c',
              estimatedValue: 20000000,
              score: 10,
              action: 'strong-sell',
            ),
          ],
          budget: 0,
          formations: const [],
        );

        expect(outcome.sales.map((s) => s.playerId), ['c', 'a']);
      });

      test('strong-sell (Score < 20) ist Hoch, sell ist Mittel', () {
        final outcome = service.rankForGoal(
          goal: SaleGoal.maxProfit,
          squad: [
            buildPlayer(id: 'a', marketValue: 12000000),
            buildPlayer(id: 'c', marketValue: 20000000),
          ],
          recommendations: [
            buildRec(
              id: 'a',
              estimatedValue: 12000000,
              score: 30,
              action: 'sell',
            ),
            buildRec(
              id: 'c',
              estimatedValue: 20000000,
              score: 10,
              action: 'strong-sell',
            ),
          ],
          budget: 0,
          formations: const [],
        );

        final byId = {for (final s in outcome.sales) s.playerId: s};
        expect(byId['c']!.priority, SalePriority.high);
        expect(byId['a']!.priority, SalePriority.medium);
      });
    });

    group('Beste Spieler behalten', () {
      test('Überbestand: der schwächste Überzahl-Spieler geht zuerst', () {
        // Startelf 4-4-2 (11 Spieler) plus ein schwacher Mittelfeld-Ersatz.
        final squad = [
          buildPlayer(id: 'tw', position: 1),
          for (var i = 1; i <= 4; i++) buildPlayer(id: 'abw$i', position: 2),
          for (var i = 1; i <= 5; i++) buildPlayer(id: 'm$i', position: 3),
          for (var i = 1; i <= 2; i++) buildPlayer(id: 'st$i', position: 4),
        ];
        final outcome = service.rankForGoal(
          goal: SaleGoal.keepBest,
          squad: squad,
          recommendations: buildRecs(squad, scores: {'m5': 10}),
          budget: 0,
        );

        expect(outcome.sales.map((s) => s.playerId), ['m5']);
        expect(outcome.sales.single.priority, SalePriority.medium);
      });

      test(
        'kritische Spieler sind Kandidaten, solange die Startelf bleibt',
        () {
          final squad = [
            buildPlayer(id: 'tw', position: 1),
            for (var i = 1; i <= 4; i++) buildPlayer(id: 'abw$i', position: 2),
            for (var i = 1; i <= 5; i++)
              buildPlayer(id: 'm$i', position: 3, status: i == 3 ? 4 : 0),
            for (var i = 1; i <= 2; i++) buildPlayer(id: 'st$i', position: 4),
          ];
          final outcome = service.rankForGoal(
            goal: SaleGoal.keepBest,
            squad: squad,
            recommendations: buildRecs(squad),
            budget: 0,
          );

          expect(outcome.sales.map((s) => s.playerId), ['m3']);
          expect(outcome.sales.single.priority, SalePriority.high);
        },
      );

      test('Sortierung: Priorität zuerst, dann Score aufsteigend', () {
        // 13 Spieler -> 2 verkäuflich: der kritische m1 und der schwache m5.
        final squad = [
          buildPlayer(id: 'tw', position: 1),
          for (var i = 1; i <= 5; i++) buildPlayer(id: 'abw$i', position: 2),
          for (var i = 1; i <= 5; i++)
            buildPlayer(id: 'm$i', position: 3, status: i == 1 ? 1 : 0),
          for (var i = 1; i <= 2; i++) buildPlayer(id: 'st$i', position: 4),
        ];
        final outcome = service.rankForGoal(
          goal: SaleGoal.keepBest,
          squad: squad,
          recommendations: buildRecs(squad, scores: {'m5': 10}),
          budget: 0,
        );

        // m1 ist kritisch (Hoch), m5 der schwächste Überbestand (Mittel).
        expect(outcome.sales.map((s) => s.playerId), ['m1', 'm5']);
      });

      test('verkauft nie den letzten Spieler einer Position', () {
        final squad = [
          buildPlayer(id: 'tw', position: 1),
          buildPlayer(id: 'st', position: 4),
          for (var i = 1; i <= 6; i++) buildPlayer(id: 'abw$i', position: 2),
          for (var i = 1; i <= 4; i++) buildPlayer(id: 'm$i', position: 3),
        ];
        final outcome = service.rankForGoal(
          goal: SaleGoal.keepBest,
          squad: squad,
          recommendations: buildRecs(
            squad,
            // TW und ST sind die Schwächsten – aber unverkäuflich.
            scores: {'tw': 3, 'st': 5, 'abw1': 20},
          ),
          budget: 0,
        );

        expect(outcome.sales.map((s) => s.playerId), ['abw1']);
      });
    });
  });
}
