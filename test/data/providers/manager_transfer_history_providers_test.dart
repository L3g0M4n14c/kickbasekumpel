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

  group('leagueTransferDemandProvider', () {
    late MockKickbaseAPIClient mockApiClient;
    late ProviderContainer container;

    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      container = ProviderContainer(
        overrides: [kickbaseApiClientProvider.overrideWithValue(mockApiClient)],
      );
    });

    tearDown(() => container.dispose());

    test('aggregiert die Käufe aller Manager der Liga', () async {
      // Arrange: 5 Käufe bei Manager 1, 4 Käufe + 1 Verkauf bei Manager 2.
      final now = DateTime.now();
      when(() => mockApiClient.getLeagueRanking('league-1')).thenAnswer(
        (_) async => {
          'us': [
            {'i': 'manager-1'},
            {'i': 'manager-2'},
            {'i': ''},
          ],
        },
      );
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-1',
          since: any(named: 'since'),
        ),
      ).thenAnswer(
        (_) async => _history('manager-1', [
          for (var i = 0; i < 5; i++)
            _rawPurchase(now.subtract(Duration(days: 40 - i * 5))),
        ]),
      );
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-2',
          since: any(named: 'since'),
        ),
      ).thenAnswer(
        (_) async => _history('manager-2', [
          for (var i = 0; i < 4; i++)
            _rawPurchase(now.subtract(Duration(days: 30 - i * 7))),
          _rawPurchase(now.subtract(const Duration(days: 10)), transferType: 2),
        ]),
      );

      // Act
      final profile = await container.read(
        leagueTransferDemandProvider('league-1').future,
      );

      // Assert: nur Käufe zaehlen, eigene und fremde Manager zusammen.
      expect(profile.totalPurchases, 9);
      expect(
        profile.purchasesByWindow.values.fold(0, (sum, count) => sum + count),
        9,
      );
      // Daten reichen > 4 Wochen zurueck und enthalten genug Kaeufe.
      expect(profile.intensity, isNotNull);
    });

    test('ignoriert Manager, deren Historie fehlschlägt', () async {
      // Arrange
      final now = DateTime.now();
      when(() => mockApiClient.getLeagueRanking('league-1')).thenAnswer(
        (_) async => {
          'us': [
            {'i': 'manager-1'},
            {'i': 'manager-2'},
          ],
        },
      );
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-1',
          since: any(named: 'since'),
        ),
      ).thenAnswer(
        (_) async => _history('manager-1', [
          for (var i = 0; i < 7; i++)
            _rawPurchase(now.subtract(Duration(days: 40 - i * 5))),
        ]),
      );
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-2',
          since: any(named: 'since'),
        ),
      ).thenThrow(Exception('Netzwerkfehler'));

      // Act
      final profile = await container.read(
        leagueTransferDemandProvider('league-1').future,
      );

      // Assert
      expect(profile.totalPurchases, 7);
      expect(profile.intensity, isNotNull);
    });

    test('liefert ohne Ranking keine Intensität (Hinweis entfällt)', () async {
      // Arrange
      when(() => mockApiClient.getLeagueRanking('league-1'))
          .thenThrow(Exception('Netzwerkfehler'));

      // Act
      final profile = await container.read(
        leagueTransferDemandProvider('league-1').future,
      );

      // Assert
      expect(profile.totalPurchases, 0);
      expect(profile.intensity, isNull);
    });
  });
}

Map<String, dynamic> _history(
  String managerId,
  List<Map<String, dynamic>> items,
) {
  return {'u': managerId, 'unm': 'Manager $managerId', 'it': items};
}

Map<String, dynamic> _rawPurchase(DateTime timestamp, {int transferType = 1}) {
  return {
    'dt': timestamp.toUtc().toIso8601String(),
    'pi': 'player-${timestamp.millisecondsSinceEpoch}',
    'pn': 'Spieler',
    'tid': 'transfer-${timestamp.millisecondsSinceEpoch}-$transferType',
    'trp': 1000000,
    'tty': transferType,
  };
}
