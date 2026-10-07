import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickbasekumpel/data/models/lineup_model.dart';
import 'package:kickbasekumpel/data/models/performance_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/providers/repository_providers.dart';
import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart'
    hide firestoreProvider;
import 'package:kickbasekumpel/data/services/deterministic_recommendation_service.dart';
import 'package:kickbasekumpel/presentation/pages/dashboard/sales_recommendation_page.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';

import '../../../helpers/mock_firebase.dart';

Recommendation _recommendation({
  required String id,
  required double score,
  String action = 'sell',
}) {
  return Recommendation(
    id: id,
    leagueId: 'league-1',
    playerId: 'player-$id',
    playerName: 'Spieler $id',
    score: score,
    reason: 'Form schwach.',
    action: action,
    currentMarketValue: 1000000,
    estimatedValue: 950000,
    confidence: 0.5,
    timestamp: DateTime(2026, 6, 10),
    category: 'sell',
  );
}

void main() {
  group('rankForSale', () {
    test('sorts the most urgent sell candidate (lowest score) first', () {
      final recommendations = [
        _recommendation(id: 'a', score: 55),
        _recommendation(id: 'b', score: 12),
        _recommendation(id: 'c', score: 31),
      ];

      final ranked = rankForSale(recommendations);

      expect(ranked.map((rec) => rec.id), ['b', 'c', 'a']);
    });

    test('does not mutate the input list', () {
      final recommendations = [
        _recommendation(id: 'a', score: 55),
        _recommendation(id: 'b', score: 12),
      ];

      rankForSale(recommendations);

      expect(recommendations.map((rec) => rec.id), ['a', 'b']);
    });
  });

  group('isSaleCandidate', () {
    test('sell and strong-sell are candidates, hold and buy are not', () {
      expect(
        isSaleCandidate(
          _recommendation(id: 'a', score: 10, action: 'strong-sell'),
        ),
        isTrue,
      );
      expect(
        isSaleCandidate(_recommendation(id: 'b', score: 30, action: 'sell')),
        isTrue,
      );
      expect(
        isSaleCandidate(_recommendation(id: 'c', score: 50, action: 'hold')),
        isFalse,
      );
      expect(
        isSaleCandidate(_recommendation(id: 'd', score: 70, action: 'buy')),
        isFalse,
      );
    });
  });

  group('SalesRecommendationPage Analyse', () {
    testWidgets(
      'übergibt Spieltagspunkte aus dem Performance-Endpunkt an die Analyse',
      (tester) async {
        final firestore = FakeFirebaseFirestore();
        final mockApiClient = MockKickbaseAPIClient();
        final fakeService = _FakeDeterministicRecommendationService();

        when(
          () => mockApiClient.getCompetitionTable(any()),
        ).thenAnswer((_) async => {'it': []});
        when(
          () => mockApiClient.getCompetitionMatchdays(any()),
        ).thenAnswer((_) async => {'it': []});
        when(
          () => mockApiClient.getLineup(any()),
        ).thenAnswer((_) async => const LineupResponse(players: []));
        when(() => mockApiClient.getPlayerStats(any(), any())).thenAnswer(
          (_) async => PlayerPerformanceResponse(
            it: [
              SeasonPerformance(
                sid: '28',
                ti: 'Saison 2026/27',
                n: 'Bundesliga',
                ph: [
                  _match(day: 1, cumulativePoints: 12),
                  _match(day: 2, cumulativePoints: 19),
                  _match(day: 3, cumulativePoints: 34),
                ],
              ),
            ],
          ),
        );

        final player = _buildPlayer(id: 'player-a');

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              firestoreProvider.overrideWithValue(firestore),
              kickbaseApiClientProvider.overrideWithValue(mockApiClient),
              recommendationRepositoryProvider.overrideWithValue(
                RecommendationRepository(
                  firestore: firestore,
                  recommendationService: fakeService,
                ),
              ),
              teamPlayersProvider.overrideWith((ref) => Future.value([player])),
              selectedLeagueIdProvider.overrideWithValue('league-a'),
            ],
            child: const MaterialApp(home: SalesRecommendationPage()),
          ),
        );
        await tester.pumpAndSettle();

        verify(
          () => mockApiClient.getPlayerStats('league-a', 'player-a'),
        ).called(1);
        final input = fakeService.lastPlayers.single;
        expect(input.recentPerformances, isNotNull);
        // `p` ist die kumulierte Saison-Gesamtpunktzahl (12, 19, 34) – die
        // Analyse erwartet Punkte pro Spieltag, also die Differenzen.
        expect(input.recentPerformances!.map((m) => m.p), [12, 7, 15]);
      },
    );
  });
}

class _FakeDeterministicRecommendationService
    extends DeterministicRecommendationService {
  List<PlayerAnalysisInput> lastPlayers = const [];

  @override
  Map<String, PlayerRecommendationResult> analyzeBatch(
    List<PlayerAnalysisInput> players,
  ) {
    lastPlayers = players;
    return {
      for (final input in players)
        input.player.id: PlayerRecommendationResult(
          score: 28,
          action: 'sell',
          reason: 'Testempfehlung für ${input.player.id}',
          confidence: 0.91,
          estimatedValue: input.player.marketValue + 250000,
          category: 'sell',
        ),
    };
  }
}

Player _buildPlayer({required String id}) {
  return Player(
    id: id,
    firstName: 'Max',
    lastName: 'Eigentor',
    profileBigUrl: 'https://example.com/player.png',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: 3,
    number: 10,
    averagePoints: 5.5,
    totalPoints: 88,
    marketValue: 12000000,
    marketValueTrend: 1,
    tfhmvt: 250000,
    prlo: 0,
    stl: 3,
    status: 0,
    userOwnsPlayer: true,
  );
}

MatchPerformance _match({
  required int day,
  required int cumulativePoints,
}) {
  return MatchPerformance(
    day: day,
    p: cumulativePoints,
    md: DateTime.utc(2026, 8, 22)
        .add(Duration(days: (day - 1) * 7))
        .toIso8601String(),
    t1: 'FC Test',
    t2: 'FC Gegner',
    st: 1,
    cur: false,
    mdst: 0,
  );
}
