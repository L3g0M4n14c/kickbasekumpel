import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/providers/manager_transfer_history_providers.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  group('managerTransferHistoryProvider', () {
    late MockKickbaseAPIClient mockApiClient;
    late ProviderContainer container;

    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      container = ProviderContainer(
        overrides: [kickbaseApiClientProvider.overrideWithValue(mockApiClient)],
      );
    });

    tearDown(() => container.dispose());

    test(
      'returns transfers enriched with market values at their timestamps',
      () async {
        // Arrange
        when(
          () =>
              mockApiClient.getManagerTransferHistory('league-1', 'manager-1'),
        ).thenAnswer(
          (_) async => {
            'u': 'manager-1',
            'unm': 'Konkurrent',
            'it': [
              {
                'dt': '2025-01-15T12:00:00.000Z',
                'pi': 'player-1',
                'pn': 'Max Mustermann',
                'tid': 'transfer-1',
                'trp': 15000000,
                'tty': 1,
              },
            ],
          },
        );
        when(
          () => mockApiClient.getPlayerMarketValue(
            'league-1',
            'player-1',
            timeframe: any(named: 'timeframe'),
          ),
        ).thenAnswer(
          (_) async => {
            'it': [
              // dt in Tagen seit 1.1.1970 (2025-01-15 = 1970 + 19343 Tage)
              {'dt': 19343, 'mv': 12000000},
            ],
          },
        );

        // Act
        final transfers = await container.read(
          managerTransferHistoryProvider((
            leagueId: 'league-1',
            managerId: 'manager-1',
          )).future,
        );

        // Assert
        expect(transfers, hasLength(1));
        expect(transfers.single.marketValueAtTransfer, 12000000);
      },
    );
  });
}
