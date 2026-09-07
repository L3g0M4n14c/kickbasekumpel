import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/bid_recommendation_service.dart';

void main() {
  group('BidRecommendationService', () {
    const service = BidRecommendationService();
    const currentMarketValue = 10000000;
    const minimumBid = 10500000;

    test('recommends the upper-quartile purchase premium rounded up', () {
      // Arrange
      final transfers = [
        _transfer(price: 11000000, marketValue: 10000000),
        _transfer(price: 12000000, marketValue: 10000000),
        _transfer(price: 13000000, marketValue: 10000000),
        _transfer(price: 14000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert: P75 von [1.1, 1.2, 1.3, 1.4] ist 1.3
      expect(recommendation, 13000000);
    });

    test('filters out purchases with a zero price or missing market value', () {
      // Arrange: defekte Datensaetze wuerden das Quartil verfaelschen
      final transfers = [
        _transfer(price: 0, marketValue: 10000000),
        _transfer(price: 12000000, marketValue: 10000000, marketValueAtTransfer: null),
        _transfer(price: 11000000, marketValue: 10000000),
        _transfer(price: 12000000, marketValue: 10000000),
        _transfer(price: 13000000, marketValue: 10000000),
        _transfer(price: 14000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert: identisch zum Fall mit nur den vier gueltigen Kaeufen
      expect(recommendation, 13000000);
    });

    test('caps outliers via the IQR rule before computing the premium', () {
      // Arrange: ein Ausreisserkauf mit 5x Marktwert
      final transfers = [
        _transfer(price: 11000000, marketValue: 10000000),
        _transfer(price: 12000000, marketValue: 10000000),
        _transfer(price: 13000000, marketValue: 10000000),
        _transfer(price: 14000000, marketValue: 10000000),
        _transfer(price: 50000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert: Ausreisser entfernt, P75 der Restdaten bleibt 1.3
      expect(recommendation, 13000000);
    });

    test('falls back to the median when the sample is too small', () {
      // Arrange: bei 3 Kaeufen waere P75 faktisch das Maximum
      final transfers = [
        _transfer(price: 11000000, marketValue: 10000000),
        _transfer(price: 13000000, marketValue: 10000000),
        _transfer(price: 15000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert: Median 1.3 statt Maximum 1.5
      expect(recommendation, 13000000);
    });

    test('uses the median after outlier removal shrinks a small sample', () {
      // Arrange: Ausreisser wird entfernt, Rest ist zu klein fuer P75
      final transfers = [
        _transfer(price: 11000000, marketValue: 10000000),
        _transfer(price: 12000000, marketValue: 10000000),
        _transfer(price: 13000000, marketValue: 10000000),
        _transfer(price: 50000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert: Median von [1.1, 1.2, 1.3] ist 1.2
      expect(recommendation, 12000000);
    });
    test('rounds the recommendation up to the next 100.000 euros', () {
      // Arrange: 1.055 * 10.000.000 = 10.550.000
      final transfers = [
        _transfer(price: 1055000, marketValue: 1000000),
        _transfer(price: 1055000, marketValue: 1000000),
        _transfer(price: 1055000, marketValue: 1000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: 10000000,
        transfers: transfers,
      );

      // Assert
      expect(recommendation, 10600000);
    });

    test('returns the minimum bid without usable purchase history', () {
      // Arrange: Kaufpreis-Defekt und ein Verkauf (transferType 2)
      final transfers = [
        _transfer(price: 0, marketValue: 10000000),
        _transfer(transferType: 2, price: 13000000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert
      expect(recommendation, minimumBid);
    });

    test('returns the minimum bid for a non-positive market value', () {
      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: 0,
        minimumBid: minimumBid,
        transfers: const [],
      );

      // Assert
      expect(recommendation, minimumBid);
    });

    test('never recommends below the minimum bid', () {
      // Arrange: historische Aufschlaege unterhalb des Mindestgebots
      final transfers = [
        _transfer(price: 9000000, marketValue: 10000000),
        _transfer(price: 9500000, marketValue: 10000000),
        _transfer(price: 9800000, marketValue: 10000000),
      ];

      // Act
      final recommendation = service.recommendBid(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
      );

      // Assert
      expect(recommendation, minimumBid);
    });
  });
}

/// Sentinel, um "Parameter nicht uebergeben" von "explizit null"
/// unterscheiden zu koennen.
const Object _unset = Object();

ManagerTransferHistoryEntry _transfer({
  required int price,
  required int marketValue,
  int transferType = 1,
  Object? marketValueAtTransfer = _unset,
}) {
  return ManagerTransferHistoryEntry(
    id: '$price',
    leagueId: 'league-1',
    managerId: 'manager-1',
    managerName: 'Konkurrent',
    playerId: 'player-1',
    playerName: 'Max Mustermann',
    price: price,
    transferType: transferType,
    timestamp: DateTime.utc(2025, 1, 15),
    marketValueAtTransfer: marketValueAtTransfer == _unset
        ? marketValue
        : marketValueAtTransfer as int?,
  );
}
