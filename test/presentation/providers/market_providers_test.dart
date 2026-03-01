import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/models/common_models.dart';
import 'package:kickbasekumpel/data/models/league_model.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';

import '../../helpers/mock_firebase.dart'; // contains MockKickbaseAPIClient

void main() {
  group('marketProviders', () {
    late MockKickbaseAPIClient mockApiClient;
    const leagueId = 'league-123';
    late ProviderContainer container;

    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      container = ProviderContainer(
        overrides: [kickbaseApiClientProvider.overrideWithValue(mockApiClient)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'marketPlayersProvider returns empty list when no league selected',
      () async {
        // keep the provider alive while waiting for the first result
        final sub = container.listen(marketPlayersProvider, (prev, next) {});
        final data = await container.read(marketPlayersProvider.future);
        expect(data, isEmpty);
        sub.close();
      },
    );

    test('marketPlayersProvider fetches and filters players', () async {
      // prepare a sample player
      final player = MarketPlayer(
        id: 'p1',
        firstName: 'Max',
        lastName: 'Mustermann',
        profileBigUrl: '',
        teamName: 'FC Test',
        teamId: 'team1',
        position: 1,
        number: 1,
        averagePoints: 5.0,
        totalPoints: 50,
        marketValue: 10000000,
        marketValueTrend: 0,
        price: 9000000,
        expiry: '2026-02-27T00:00:00Z',
        offers: 0,
        seller: const MarketSeller(id: 's1', name: 'Seller'),
        stl: 0,
        status: 0,
        exs: 0,
      );

      when(
        () => mockApiClient.getMarketAvailable(leagueId),
      ).thenAnswer((_) async => [player]);

      // select league so provider has an id
      container
          .read(selectedLeagueProvider.notifier)
          .select(
            League(
              i: leagueId,
              n: 'Test League',
              cu: const LeagueUser(
                id: 'u1',
                name: 'User',
                teamName: 'Team',
                budget: 0,
                teamValue: 0,
                points: 0,
                placement: 0,
                won: 0,
                drawn: 0,
                lost: 0,
                se11: 0,
                ttm: 0,
              ),
            ),
          );

      // keep provider alive to prevent autoDispose
      final sub = container.listen(marketPlayersProvider, (prev, next) {});

      final fetched = await container.read(marketPlayersProvider.future);
      expect(fetched, hasLength(1));
      expect(fetched.first.id, 'p1');

      // apply search filter that won't match
      container.read(marketFilterProvider.notifier).setSearchQuery('xyz');
      final filtered = await container.read(marketPlayersProvider.future);
      expect(filtered, isEmpty);

      // clear filter and ensure data returns
      container.read(marketFilterProvider.notifier).clearFilters();
      final again = await container.read(marketPlayersProvider.future);
      expect(again, hasLength(1));

      sub.close();
    });
  });
}
