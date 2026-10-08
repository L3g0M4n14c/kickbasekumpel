import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickbasekumpel/data/models/lineup_model.dart';
import 'package:kickbasekumpel/data/models/market_value_model.dart';
import 'package:kickbasekumpel/data/models/performance_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/providers/recommendation_providers.dart';
import 'package:kickbasekumpel/data/providers/repository_providers.dart';
import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart'
    hide firestoreProvider;
import 'package:kickbasekumpel/data/services/deterministic_recommendation_service.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  group('recommendationProviders', () {
    late FakeFirebaseFirestore firestore;
    late MockKickbaseAPIClient mockApiClient;
    late ProviderContainer container;
    late _FakeDeterministicRecommendationService fakeRecommendationService;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      mockApiClient = MockKickbaseAPIClient();
      fakeRecommendationService = _FakeDeterministicRecommendationService();

      when(() => mockApiClient.getCompetitionTable(any()))
          .thenAnswer((_) async => {'it': []});
      when(() => mockApiClient.getCompetitionMatchdays(any()))
          .thenAnswer((_) async => {'it': []});
      when(() => mockApiClient.getLineup(any()))
          .thenAnswer((_) async => const LineupResponse(players: []));

      final repository = RecommendationRepository(
        firestore: firestore,
        recommendationService: fakeRecommendationService,
      );

      container = ProviderContainer(
        overrides: [
          firestoreProvider.overrideWithValue(firestore),
          kickbaseApiClientProvider.overrideWithValue(mockApiClient),
          recommendationRepositoryProvider.overrideWithValue(repository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'generateForPlayers keeps ownership flags and scopes results by league',
      () async {
        final notifier = container.read(
          generateRecommendationsNotifierProvider.notifier,
        );

        final ownedPlayer = _buildPlayer(
          id: 'owned-player',
          userOwnsPlayer: true,
        );
        final marketPlayer = _buildPlayer(
          id: 'market-player',
          userOwnsPlayer: false,
          averagePoints: 8.2,
        );

        await notifier.generateForPlayers(
          'league-a',
          [ownedPlayer, marketPlayer],
          marketValueHistories: {
            ownedPlayer.id: <MarketValueEntry>[],
            marketPlayer.id: <MarketValueEntry>[],
          },
          recentPerformances: {
            ownedPlayer.id: <MatchPerformance>[],
            marketPlayer.id: <MatchPerformance>[],
          },
        );

        final stateAfterFirstRun = container.read(
          generateRecommendationsNotifierProvider,
        );
        final leagueARecommendations = container.read(
          recommendationsForLeagueProvider('league-a'),
        );

        expect(stateAfterFirstRun.isGenerating, false);
        expect(stateAfterFirstRun.lastRunSucceeded, true);
        expect(stateAfterFirstRun.generatedCount, 2);
        expect(stateAfterFirstRun.leagueId, 'league-a');
        expect(leagueARecommendations, hasLength(2));
        expect(
          leagueARecommendations.where(
            (recommendation) => recommendation.userOwnsPlayer,
          ),
          hasLength(1),
        );
        expect(
          leagueARecommendations.where(
            (recommendation) => !recommendation.userOwnsPlayer,
          ),
          hasLength(1),
        );
        expect(
          leagueARecommendations
              .singleWhere(
                (recommendation) => recommendation.playerId == 'owned-player',
              )
              .action,
          'sell',
        );
        expect(
          leagueARecommendations
              .singleWhere(
                (recommendation) => recommendation.playerId == 'market-player',
              )
              .action,
          'buy',
        );
        expect(
          container.read(recommendationsForLeagueProvider('league-b')),
          isEmpty,
        );

        await notifier.generateForPlayers(
          'league-b',
          [marketPlayer],
          marketValueHistories: {marketPlayer.id: <MarketValueEntry>[]},
          recentPerformances: {marketPlayer.id: <MatchPerformance>[]},
        );

        expect(
          container.read(recommendationsForLeagueProvider('league-a')),
          isEmpty,
        );
        expect(
          container.read(recommendationsForLeagueProvider('league-b')),
          hasLength(1),
        );
      },
    );

    test('generateForPlayers does not request market values or performances when no optional maps are provided', () async {
      final notifier = container.read(
        generateRecommendationsNotifierProvider.notifier,
      );
      final players = [
        _buildPlayer(id: 'player-a', userOwnsPlayer: false),
        _buildPlayer(id: 'player-b', userOwnsPlayer: true),
      ];

      await notifier.generateForPlayers('league-a', players);

      verifyNever(
        () => mockApiClient.getPlayerMarketValue(
          any(),
          any(),
          timeframe: any(named: 'timeframe'),
        ),
      );
      verifyNever(() => mockApiClient.getPlayerStats(any(), any()));
      expect(
        container.read(recommendationsForLeagueProvider('league-a')),
        hasLength(2),
      );
    });

    test('generateForPlayers reloads team names and adds next fixture metadata to analysis inputs', () async {
      final notifier = container.read(
        generateRecommendationsNotifierProvider.notifier,
      );
      final player = _buildPlayer(
        id: 'player-a',
        userOwnsPlayer: false,
      ).copyWith(teamName: '');

      when(() => mockApiClient.getCompetitionTable(any())).thenAnswer(
        (_) async => {
          'it': [
            {'tid': 'team-1', 'tp': 12, 'tn': 'FC Nachgeladen'},
            {'tid': 'team-2', 'tp': 4, 'tn': 'FC Gegner'},
          ],
        },
      );
      when(() => mockApiClient.getCompetitionMatchdays(any())).thenAnswer(
        (_) async => {
          'it': [
            {
              'day': 28,
              'finished': false,
              'ms': [
                {
                  't1id': 'team-1',
                  't1n': 'FC Nachgeladen',
                  't2id': 'team-2',
                  't2n': 'FC Gegner',
                },
              ],
            },
          ],
        },
      );

      await notifier.generateForPlayers('league-a', [player]);

      final promptInput = fakeRecommendationService.lastPlayers.single;
      expect(promptInput.player.teamName, 'FC Nachgeladen');
      expect(promptInput.nextOpponent, 'FC Gegner');
      expect(promptInput.nextOpponentTablePosition, 4);
      expect(promptInput.ownTeamTablePosition, 12);
      expect(promptInput.nextMatchLocation, 'Heimspiel');
      expect(
        promptInput.fixtureContext,
        contains('Spieltag 28: vs FC Gegner (Heimspiel, Platz 4'),
      );
    });

    test(
      'parsest das echte Matchdays-Schema (Matches unter it, Team-Namen, dt)',
      () async {
        final notifier = container.read(
          generateRecommendationsNotifierProvider.notifier,
        );
        final player = _buildPlayer(
          id: 'player-real',
          userOwnsPlayer: false,
        ).copyWith(teamName: '');

        when(() => mockApiClient.getCompetitionTable(any())).thenAnswer(
          (_) async => {
            'it': [
              {'tid': 'team-1', 'tp': 12, 'tn': 'FC Nachgeladen'},
              {'tid': 'team-2', 'tp': 4, 'tn': 'FC Gegner'},
            ],
          },
        );
        // Echtes Schema (api-endpoints.json, "Fixtures"): Spieltage mit
        // verschachteltem 'it', Matches mit Team-Namen (t1/t2/t1sy) und 'dt'.
        final past = DateTime.now().subtract(const Duration(days: 7));
        final future = DateTime.now().add(const Duration(days: 7));
        when(() => mockApiClient.getCompetitionMatchdays(any())).thenAnswer(
          (_) async => {
            'it': [
              {
                // Bereits gespielt – muss gefiltert werden (dt in der Vergangenheit).
                'day': 27,
                'it': [
                  {
                    'day': 27,
                    'dt': past.toIso8601String(),
                    'il': false,
                    'mi': 'match-past',
                    'st': 2,
                    't1': 'FC Nachgeladen',
                    't1g': 2,
                    't1sy': 'FCN',
                    't2': 'FC Vergangen',
                    't2g': 1,
                    't2sy': 'FCV',
                  },
                ],
              },
              {
                'day': 28,
                'it': [
                  {
                    'day': 28,
                    'dt': future.toIso8601String(),
                    'il': false,
                    'mi': 'match-next',
                    'st': 0,
                    't1': 'FC Nachgeladen',
                    't1g': 0,
                    't1sy': 'FCN',
                    't2': 'FC Gegner',
                    't2g': 0,
                    't2sy': 'FCG',
                  },
                ],
              },
            ],
          },
        );

        await notifier.generateForPlayers('league-a', [player]);

        final promptInput = fakeRecommendationService.lastPlayers.single;
        expect(promptInput.nextOpponent, 'FC Gegner');
        expect(promptInput.nextOpponentTablePosition, 4);
        expect(promptInput.ownTeamTablePosition, 12);
        expect(promptInput.nextMatchLocation, 'Heimspiel');
        expect(promptInput.fixtureContext, contains('vs FC Gegner'));
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
          score: input.player.userOwnsPlayer ? 28 : 74,
          action: input.player.userOwnsPlayer ? 'sell' : 'buy',
          reason: 'Testempfehlung für ${input.player.id}',
          confidence: 0.91,
          estimatedValue: input.player.marketValue + 250000,
          category: input.player.userOwnsPlayer ? 'sell' : 'buy',
        ),
    };
  }
}

Player _buildPlayer({
  required String id,
  required bool userOwnsPlayer,
  double averagePoints = 5.5,
}) {
  return Player(
    id: id,
    firstName: 'Max',
    lastName: userOwnsPlayer ? 'Eigentor' : 'Marktmann',
    profileBigUrl: 'https://example.com/player.png',
    teamName: 'FC Test',
    teamId: 'team-1',
    position: 3,
    number: 10,
    averagePoints: averagePoints,
    totalPoints: 88,
    marketValue: 12000000,
    marketValueTrend: 1,
    tfhmvt: 250000,
    prlo: 0,
    stl: 3,
    status: 0,
    userOwnsPlayer: userOwnsPlayer,
  );
}
