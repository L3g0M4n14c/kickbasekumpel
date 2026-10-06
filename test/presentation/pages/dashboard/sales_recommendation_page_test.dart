import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/presentation/pages/dashboard/sales_recommendation_page.dart';

Recommendation _recommendation({
  required String id,
  required double score,
  String action = 'sell',
}) {
  return Recommendation(
    id: id,
    leagueId: 'league-1',
    playerId: 'player-$id',
    playerName: 'Spieler $id',
    score: score,
    reason: 'Form schwach.',
    action: action,
    currentMarketValue: 1000000,
    estimatedValue: 950000,
    confidence: 0.5,
    timestamp: DateTime(2026, 6, 10),
    category: 'sell',
  );
}

void main() {
  group('rankForSale', () {
    test('sorts the most urgent sell candidate (lowest score) first', () {
      final recommendations = [
        _recommendation(id: 'a', score: 55),
        _recommendation(id: 'b', score: 12),
        _recommendation(id: 'c', score: 31),
      ];

      final ranked = rankForSale(recommendations);

      expect(ranked.map((rec) => rec.id), ['b', 'c', 'a']);
    });

    test('does not mutate the input list', () {
      final recommendations = [
        _recommendation(id: 'a', score: 55),
        _recommendation(id: 'b', score: 12),
      ];

      rankForSale(recommendations);

      expect(recommendations.map((rec) => rec.id), ['a', 'b']);
    });
  });

  group('isSaleCandidate', () {
    test('sell and strong-sell are candidates, hold and buy are not', () {
      expect(
        isSaleCandidate(
          _recommendation(id: 'a', score: 10, action: 'strong-sell'),
        ),
        isTrue,
      );
      expect(
        isSaleCandidate(_recommendation(id: 'b', score: 30, action: 'sell')),
        isTrue,
      );
      expect(
        isSaleCandidate(_recommendation(id: 'c', score: 50, action: 'hold')),
        isFalse,
      );
      expect(
        isSaleCandidate(_recommendation(id: 'd', score: 70, action: 'buy')),
        isFalse,
      );
    });
  });
}
