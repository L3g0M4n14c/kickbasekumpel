import 'dart:math';

import '../models/transfer_model.dart';

/// Berechnet eine konservative Gebotsempfehlung aus historischen Kaeufen.
class BidRecommendationService {
  /// Der von Kickbase fuer einen Kauf verwendete Transfer-Typ.
  static const int purchaseTransferType = 1;

  /// Mindestanzahl verwertbarer Kaeufe, damit das obere Quartil als
  /// stabile Empfehlungsgrundlage dient. Bei kleineren Stichproben
  /// entspricht das Quartil faktisch dem Maximum und liefert riskant
  /// hohe Gebote – dann wird der Median verwendet.
  static const int minimumSampleSize = 4;

  /// Standard-Boxplot-Faktor (1.5 x IQR) fuer die Ausreisserkappung.
  static const double iqrOutlierFactor = 1.5;

  const BidRecommendationService();

  /// Empfiehlt ein auf 100.000 Euro aufgerundetes Gebot.
  ///
  /// Verwendet das obere Quartil der historischen Kaufaufschlaege.
  /// Datendefekte (Kaufpreis oder Marktwert <= 0) werden ignoriert,
  /// Ausreisser werden per IQR-Regel gekappt. Bei zu kleinen
  /// Stichproben (< [minimumSampleSize]) faellt die Empfehlung auf den
  /// Median zurueck. Ohne verwertbare Kaufhistorie bleibt es beim
  /// [minimumBid].
  int recommendBid({
    required int currentMarketValue,
    required int minimumBid,
    required List<ManagerTransferHistoryEntry> transfers,
  }) {
    if (currentMarketValue <= 0) return minimumBid;

    final premiums = _collectPremiums(transfers);
    if (premiums.isEmpty) return minimumBid;

    final robustPremiums = _removeOutliers(premiums);
    final premium = robustPremiums.length >= minimumSampleSize
        ? _percentile(robustPremiums, 0.75)
        : _median(robustPremiums);

    final historicalBid = (currentMarketValue * premium).ceil();
    final bid = max(minimumBid, historicalBid);
    return ((bid + 99999) ~/ 100000) * 100000;
  }

  /// Sortierte Aufschlaege (Kaufpreis / Marktwert) aller verwertbaren Kaeufe.
  ///
  /// Ein Kaufpreis oder Marktwert <= 0 ist ein Datendefekt (der
  /// Parsing-Fallback liefert 0) und wuerde das Quartil kuenstlich
  /// nach unten ziehen, daher wird er gefiltert.
  List<double> _collectPremiums(List<ManagerTransferHistoryEntry> transfers) =>
      transfers
          .where(
            (transfer) =>
                transfer.transferType == purchaseTransferType &&
                transfer.price > 0 &&
                transfer.marketValueAtTransfer != null &&
                transfer.marketValueAtTransfer! > 0,
          )
          .map((transfer) => transfer.price / transfer.marketValueAtTransfer!)
          .toList()
        ..sort();

  /// Entfernt Ausreisser aus der sortierten Aufschlagsliste (IQR-Regel).
  ///
  /// Werte ausserhalb von [Q1 - 1.5*IQR, Q3 + 1.5*IQR] stammen
  /// typischerweise aus Sonderfaellen (z.B. Freundschaftskaeufe) und
  /// wuerden das Quartil sonst stark uebertreiben. Bei weniger als
  /// vier Werten ist das IQR zu instabil, dann bleibt die Liste
  /// unveraendert.
  List<double> _removeOutliers(List<double> sortedPremiums) {
    if (sortedPremiums.length < 4) return sortedPremiums;
    final q1 = _percentile(sortedPremiums, 0.25);
    final q3 = _percentile(sortedPremiums, 0.75);
    final iqr = q3 - q1;
    final lowerBound = q1 - iqrOutlierFactor * iqr;
    final upperBound = q3 + iqrOutlierFactor * iqr;
    return sortedPremiums
        .where((premium) => premium >= lowerBound && premium <= upperBound)
        .toList();
  }

  /// Wert am [quantile]-Perzentil der sortierten Liste.
  double _percentile(List<double> sortedValues, double quantile) {
    final index = max(0, (sortedValues.length * quantile).ceil() - 1);
    return sortedValues[index];
  }

  /// Median der sortierten Liste (Mittel der beiden mittleren Werte
  /// bei gerader Anzahl).
  double _median(List<double> sortedValues) {
    final middleIndex = sortedValues.length ~/ 2;
    if (sortedValues.length.isOdd) return sortedValues[middleIndex];
    return (sortedValues[middleIndex - 1] + sortedValues[middleIndex]) / 2;
  }
}
