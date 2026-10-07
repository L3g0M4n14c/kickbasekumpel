import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_value_model.dart';
import 'package:kickbasekumpel/data/models/performance_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/services/deterministic_recommendation_service.dart';

void main() {
  const service = DeterministicRecommendationService();

  Player buildPlayer({
    String id = 'p1',
    double averagePoints = 6.0,
    int marketValue = 10000000,
    int marketValueTrend = 0,
    int tfhmvt = 0,
    int status = 0,
    bool userOwnsPlayer = false,
    int position = 3,
  }) {
    return Player(
      id: id,
      firstName: 'Max',
      lastName: 'Mustermann',
      profileBigUrl: 'https://example.com/p.png',
      teamName: 'FC Test',
      teamId: 'team-1',
      position: position,
      number: 10,
      averagePoints: averagePoints,
      totalPoints: 120,
      marketValue: marketValue,
      marketValueTrend: marketValueTrend,
      tfhmvt: tfhmvt,
      prlo: 0,
      stl: 0,
      status: status,
      userOwnsPlayer: userOwnsPlayer,
    );
  }

  MatchPerformance performance(int day, int points) => MatchPerformance(
    day: day,
    p: points,
    mp: '90',
    md: 'Test',
    t1: 'FC Test',
    t2: 'FC Gegner',
    st: 1,
    cur: false,
    mdst: 1,
  );

  group('DeterministicRecommendationService', () {
    test('verfügbarer Durchschnittsspieler erhält Hold-Score', () {
      final result = service.analyze(
        PlayerAnalysisInput(player: buildPlayer()),
      );

      expect(result.score, greaterThanOrEqualTo(40));
      expect(result.score, lessThan(60));
      expect(result.action, 'hold');
      expect(result.category, 'general');
      expect(result.reason, contains('Effizienz'));
    });

    test('verletzter eigener Spieler wird zum Strong-Sell', () {
      final result = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(status: 1, userOwnsPlayer: true),
        ),
      );

      expect(result.score, lessThan(20));
      expect(result.action, 'strong-sell');
      expect(result.reason, contains('Verfügbarkeitsrisiko'));
    });

    test('gesperrter Marktspieler ist kein Kauf', () {
      final result = service.analyze(
        PlayerAnalysisInput(player: buildPlayer(status: 32)),
      );

      expect(result.action, 'sell');
      expect(result.reason, contains('gesperrt'));
      expect(result.reason, contains('kein Kauf'));
    });

    test('starke Form und schwacher Gegner ergeben einen Kauf', () {
      final result = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(averagePoints: 8.0, marketValue: 8000000),
          recentPerformances: [
            for (var day = 24; day <= 28; day++) performance(day, 10),
          ],
          nextOpponent: 'FC Schwach',
          nextOpponentTablePosition: 16,
          nextMatchLocation: 'Heimspiel',
        ),
      );

      expect(result.action, anyOf('buy', 'strong-buy'));
      expect(result.reason, contains('FC Schwach'));
      expect(result.confidence, greaterThan(0.7));
    });

    test('neuere Spiele zählen bei der Form stärker', () {
      final upward = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(),
          recentPerformances: [performance(24, 2), performance(28, 12)],
        ),
      );
      final downward = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(),
          recentPerformances: [performance(24, 12), performance(28, 2)],
        ),
      );

      expect(upward.score, greaterThan(downward.score));
    });

    test('Marktwert-Historie mit Aufwärtstrend erhöht den Score', () {
      final history = [
        for (var i = 0; i < 10; i++)
          MarketValueEntry(
            dt: 1700000000000 + i * 86400000,
            mv: 9000000 + i * 100000,
          ),
      ];
      final flat = [
        for (var i = 0; i < 10; i++)
          MarketValueEntry(dt: 1700000000000 + i * 86400000, mv: 10000000),
      ];

      final rising = service.analyze(
        PlayerAnalysisInput(player: buildPlayer(), marketValueHistory: history),
      );
      final stable = service.analyze(
        PlayerAnalysisInput(player: buildPlayer(), marketValueHistory: flat),
      );

      expect(rising.score, greaterThan(stable.score));
    });

    test('guter Tausch-Kandidat wird vorgeschlagen und belohnt', () {
      final alternative = buildPlayer(
        id: 'p2',
        averagePoints: 9.0,
        marketValue: 10000000,
      );
      final result = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(userOwnsPlayer: true),
          swapCandidates: [alternative],
        ),
      );

      expect(result.swapCandidateId, 'p2');
      expect(result.swapCandidateName, 'Max Mustermann');
      expect(result.components['swap'], 5.0);
    });

    test('Score bleibt immer zwischen 0 und 100', () {
      final results = [
        // Extrem teuer, schwach, Top-Gegner, fallender Trend.
        service.analyze(
          PlayerAnalysisInput(
            player: buildPlayer(
              averagePoints: 0.1,
              marketValue: 50000000,
              tfhmvt: -200000,
            ),
            nextOpponent: 'FC Bayern',
            nextOpponentTablePosition: 1,
            nextMatchLocation: 'Auswärts',
          ),
        ),
        // Extrem günstig, stark, schwacher Gegner, steigender Trend.
        service.analyze(
          PlayerAnalysisInput(
            player: buildPlayer(
              averagePoints: 15.0,
              marketValue: 1000000,
              tfhmvt: 200000,
            ),
            nextOpponent: 'FC Absteiger',
            nextOpponentTablePosition: 18,
            nextMatchLocation: 'Heimspiel',
          ),
        ),
      ];

      for (final result in results) {
        expect(result.score, inInclusiveRange(0, 100));
      }
    });

    test('Status 4 (Aufbautraining) führt zum Strong-Sell', () {
      final result = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(status: 4, userOwnsPlayer: true),
        ),
      );

      expect(result.score, lessThan(20));
      expect(result.action, 'strong-sell');
      expect(result.reason, contains('Aufbautraining'));
    });

    test('Status 3 (Gesperrt) wird als Sperre behandelt', () {
      final result = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(status: 3, userOwnsPlayer: true),
        ),
      );

      expect(result.action, 'strong-sell');
      expect(result.reason, contains('gesperrt'));
    });

    test('kommende Gegner werden über bis zu drei Spiele gemittelt', () {
      List<FixtureInfo> fixtures(int position) => [
        for (var i = 0; i < 3; i++)
          FixtureInfo(
            opponentName: 'FC Gegner ${i + 1}',
            opponentTablePosition: position,
            isHomeGame: true,
          ),
      ];

      final weakOpponents = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(),
          upcomingFixtures: fixtures(16),
        ),
      );
      final topOpponents = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(),
          upcomingFixtures: fixtures(1),
        ),
      );

      // Schwache Gegner (Platz 16, Heim): +6 pro Spiel, Top-Teams (Heim): -4.
      expect(
        weakOpponents.score,
        greaterThanOrEqualTo(topOpponents.score + 10),
      );
      expect(weakOpponents.reason, contains('Nächste Gegner'));
    });

    test('gemischte Gegnerstärke ergibt den Mittelwert', () {
      final mixed = service.analyze(
        PlayerAnalysisInput(
          player: buildPlayer(),
          upcomingFixtures: const [
            FixtureInfo(
              opponentName: 'Top',
              opponentTablePosition: 1,
              isHomeGame: false,
            ),
            FixtureInfo(
              opponentName: 'Mittel',
              opponentTablePosition: 10,
              isHomeGame: true,
            ),
            FixtureInfo(
              opponentName: 'Schwach',
              opponentTablePosition: 16,
              isHomeGame: true,
            ),
          ],
        ),
      );
      final neutral = service.analyze(
        PlayerAnalysisInput(player: buildPlayer()),
      );

      // Top auswärts: -6; Platz 10 Heim: +2; Platz 16 Heim: +6 -> Ø +0.67.
      expect(mixed.score, closeTo(neutral.score + 0.67, 0.5));
    });

    test('analyzeBatch keyed Ergebnisse nach Spieler-ID', () {
      final results = service.analyzeBatch([
        PlayerAnalysisInput(player: buildPlayer(id: 'a')),
        PlayerAnalysisInput(player: buildPlayer(id: 'b', status: 8)),
      ]);

      expect(results.keys, containsAll(['a', 'b']));
      expect(results['a']!.action, isNot('strong-sell'));
      expect(results['b']!.action, 'sell');
    });
  });
}
