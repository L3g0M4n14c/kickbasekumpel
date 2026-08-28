import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/bid_recommendation_service.dart';

void main() {
  group('BidRecommendationService', () {
    test('recommends the upper-quartile purchase premium rounded up', () {
      // Arrange
      const service = BidRecommendationService();
      final transfers = [
        _transfer(price: 11000000, marketValue: 10000000),
        _transfer(price: 12000000, marketValue: 10000000),
        _transfer(price: 13000000, marketValue: 10000000),
        _transfer(price: 14000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: 10000000,
        minimumBid: 10500000,
        transfers: transfers,
      );

      // Assert
      expect(recommendation, 13000000);
    });
  });
}

ManagerTransferHistoryEntry _transfer({
  required int price,
  required int marketValue,
}) {
  return ManagerTransferHistoryEntry(
    id: '$price',
    leagueId: 'league-1',
    managerId: 'manager-1',
    managerName: 'Konkurrent',
    playerId: 'player-1',
    playerName: 'Max Mustermann',
    price: price,
    transferType: 1,
    timestamp: DateTime.utc(2025, 1, 15),
    marketValueAtTransfer: marketValue,
  );
}
