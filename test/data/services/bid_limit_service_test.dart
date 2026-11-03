import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/services/bid_limit_service.dart';

void main() {
  const service = BidLimitService();

  group('BidLimitService.calculate (33 %-Regel)', () {
    test('Beispiel der Kickbase-Hilfe: TW 100 Mio, Konto −10 Mio', () {
      final limit = service.calculate(budget: -10000000, teamValue: 100000000);

      // Basis 90 Mio → Untergrenze −30 Mio → noch 20 Mio Spielraum
      expect(limit.minBalance, -30000000);
      expect(limit.overdraftAllowance, 30000000);
      expect(limit.maxBid, 20000000);
    });

    test('positiver Kontostand erhöht die Basis nicht', () {
      final limit = service.calculate(budget: 20000000, teamValue: 90000000);

      expect(limit.minBalance, -30000000);
      expect(limit.maxBid, 50000000);
      expect(limit.allows(50000000), isTrue);
      expect(limit.allows(50000001), isFalse);
    });

    test('offene Gebote verringern das max. Gebot', () {
      final limit = service.calculate(
        budget: 20000000,
        teamValue: 90000000,
        pendingOffers: 15000000,
      );

      expect(limit.maxBid, 35000000);
      expect(limit.balanceAfterBid(35000000), -30000000);
    });

    test('über der Grenze → max. Gebot 0 statt negativ', () {
      final limit = service.calculate(budget: -40000000, teamValue: 90000000);

      expect(limit.maxBid, 0);
    });

    test('ohne Teamwert kein Minus erlaubt', () {
      final limit = service.calculate(budget: 5000000, teamValue: 0);

      expect(limit.minBalance, 0);
      expect(limit.maxBid, 5000000);
    });

    test('rundet die Untergrenze konservativ', () {
      final limit = service.calculate(budget: 0, teamValue: 100);

      // −33,33 → −33 (nicht −34)
      expect(limit.minBalance, -33);
    });
  });

  group('BidLimitService.sumOpenOffers', () {
    test('summiert eigene Gebote ohne den aktuellen Spieler', () {
      final sum = service.sumOpenOffers([
        (playerId: 'a', ownOfferPrice: 1000),
        (playerId: 'b', ownOfferPrice: null),
        (playerId: 'c', ownOfferPrice: 2500),
      ], excludePlayerId: 'c');

      expect(sum, 1000);
    });
  });
}
