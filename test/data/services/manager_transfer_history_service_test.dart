import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_value_model.dart';
import 'package:kickbasekumpel/data/services/manager_transfer_history_service.dart';

void main() {
  group('ManagerTransferHistoryService', () {
    test('uses the last market value known at the transfer timestamp', () {
      // Arrange
      final service = ManagerTransferHistoryService();
      final marketValues = [
        const MarketValueEntry(dt: 1736812800000, mv: 12000000),
        const MarketValueEntry(dt: 1737244800000, mv: 12500000),
      ];
      final transferTimestamp = DateTime.utc(2025, 1, 15);

      // Act
      final marketValue = service.marketValueAt(
        marketValues,
        transferTimestamp,
      );

      // Assert
      expect(marketValue, 12000000);
    });

    test('normalizes manager transfer API fields', () {
      // Arrange
      final service = ManagerTransferHistoryService();
      final response = {
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
      };

      // Act
      final transfers = service.transfersFromResponse(
        leagueId: 'league-1',
        response: response,
      );

      // Assert
      expect(transfers, hasLength(1));
      expect(transfers.single.managerId, 'manager-1');
      expect(transfers.single.playerId, 'player-1');
      expect(transfers.single.price, 15000000);
      expect(transfers.single.transferType, 1);
      expect(transfers.single.marketValueAtTransfer, isNull);
    });

    test(
      'enriches a transfer with its market value at the transfer timestamp',
      () {
        // Arrange
        final service = ManagerTransferHistoryService();
        final transfer = service
            .transfersFromResponse(
              leagueId: 'league-1',
              response: {
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
            )
            .single;

        // Act
        final enrichedTransfer = service
            .enrichWithMarketValues(
              [transfer],
              {
                'player-1': [
                  const MarketValueEntry(dt: 1736812800000, mv: 12000000),
                  const MarketValueEntry(dt: 1737244800000, mv: 12500000),
                ],
              },
            )
            .single;

        // Assert
        expect(enrichedTransfer.marketValueAtTransfer, 12000000);
      },
    );
  });
}
