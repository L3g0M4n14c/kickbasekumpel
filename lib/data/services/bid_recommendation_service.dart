import 'dart:math';

import '../models/transfer_model.dart';

/// Berechnet eine konservative Gebotsempfehlung aus historischen Kaeufen.
class BidRecommendationService {
  /// Der von Kickbase fuer einen Kauf verwendete Transfer-Typ.
  static const int purchaseTransferType = 1;

  const BidRecommendationService();

  /// Empfiehlt ein auf 100.000 Euro aufgerundetes Gebot.
  ///
  /// Verwendet das obere Quartil der historischen Kaufaufschlaege. Ohne
  /// verwertbare Kaufhistorie bleibt es beim [minimumBid].
  int recommendBid({
    required int currentMarketValue,
    required int minimumBid,
    required List<ManagerTransferHistoryEntry> transfers,
  }) {
    if (currentMarketValue <= 0) return minimumBid;

    final premiums =
        transfers
            .where(
              (transfer) =>
                  transfer.transferType == purchaseTransferType &&
                  transfer.marketValueAtTransfer != null &&
                  transfer.marketValueAtTransfer! > 0,
            )
            .map((transfer) => transfer.price / transfer.marketValueAtTransfer!)
            .toList()
          ..sort();

    if (premiums.isEmpty) return minimumBid;

    final upperQuartileIndex = max(0, (premiums.length * 0.75).ceil() - 1);
    final historicalBid = (currentMarketValue * premiums[upperQuartileIndex])
        .ceil();
    final bid = max(minimumBid, historicalBid);
    return ((bid + 99999) ~/ 100000) * 100000;
  }
}
