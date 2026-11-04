import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/utils/parsing_utils.dart';

void main() {
  group('normalizeMarketPlayerJson', () {
    test('mappt uop auf ownOfferPrice (null ohne eigenes Gebot)', () {
      expect(
        normalizeMarketPlayerJson({'i': 'p1', 'uop': 9000000})['ownOfferPrice'],
        9000000,
      );
      expect(normalizeMarketPlayerJson({'i': 'p1'})['ownOfferPrice'], isNull);
    });

    test('does not use the listing timestamp as an expiry fallback', () {
      // Arrange
      final listedAt = DateTime.now()
          .subtract(const Duration(days: 1))
          .toUtc()
          .toIso8601String();

      // Act
      final normalized = normalizeMarketPlayerJson({
        'i': 'player-1',
        'dt': listedAt,
        'exs': 0,
      });

      // Assert
      expect(normalized['expiry'], isEmpty);
    });
  });
}
