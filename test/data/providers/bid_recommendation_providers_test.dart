import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickbasekumpel/data/providers/bid_recommendation_providers.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/providers/user_providers.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  group('recommendedBidProvider', () {
    late MockKickbaseAPIClient mockApiClient;
    late ProviderContainer container;

    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      container = ProviderContainer(
        overrides: [
          kickbaseApiClientProvider.overrideWithValue(mockApiClient),
          currentAuthUserIdProvider.overrideWithValue('manager-me'),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('uses competitor purchase premiums for the recommended bid', () async {
      // Arrange
      when(() => mockApiClient.getLeagueRanking('league-1')).thenAnswer(
        (_) async => {
          'us': [
            {'i': 'manager-me'},
            {'i': 'manager-1'},
          ],
        },
      );
      when(
        () => mockApiClient.getManagerTransferHistory('league-1', 'manager-1'),
      ).thenAnswer(
        (_) async => {
          'u': 'manager-1',
          'unm': 'Konkurrent',
          'it': [
            {
              'dt': '2025-01-15T12:00:00.000Z',
              'pi': 'past-player',
              'pn': 'Vergangener Spieler',
              'tid': 'transfer-1',
              'trp': 13000000,
              'tty': 1,
            },
          ],
        },
      );
      when(
        () => mockApiClient.getPlayerMarketValue(
          'league-1',
          'past-player',
          timeframe: any(named: 'timeframe'),
        ),
      ).thenAnswer(
        (_) async => {
          'it': [
            {'dt': 1736812800000, 'mv': 10000000},
          ],
        },
      );

      // Act
      final bid = await container.read(
        recommendedBidProvider((
          leagueId: 'league-1',
          currentMarketValue: 10000000,
          minimumBid: 10500000,
        )).future,
      );

      // Assert
      expect(bid, 13000000);
    });
  });
}
