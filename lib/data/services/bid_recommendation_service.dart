import 'dart:math';

import '../models/transfer_model.dart';

/// Ergebnis einer Gebotsempfehlung inkl. Transparenzdaten.
class BidRecommendation {
  /// Empfohlenes Gebot in Euro.
  final int amount;

  /// Härter Floor (aktuelles Mindestgebot des Marktplatz-Eintrags).
  final int minimumBid;

  /// Effektiver Aufschlag (amount / Marktwert). 0 wenn kein Marktwert bekannt.
  final double premium;

  /// Anzahl verwertbarer Käufe, auf denen der Aufschlag basiert.
  final int sampleSize;

  /// Verwendete Methode: 'minimum' | 'median' | 'quartile'.
  final String method;

  /// Konfidenz 0-1 aus Datenlage (Sample-Größe, sichtbare Konkurrenz).
  final double confidence;

  /// Beschreibt, welche Datenmenge verwendet wurde (Zeitfenster/Preisklasse).
  final String scope;

  const BidRecommendation({
    required this.amount,
    required this.minimumBid,
    required this.premium,
    required this.sampleSize,
    required this.method,
    required this.confidence,
    required this.scope,
  });
}

/// Berechnet eine konservative Gebotsempfehlung aus historischen Kaeufen der
/// Ligakonkurrenz – rein deterministisch.
///
/// Strategie-Leiter (erster Satz mit ausreichendem Sample gewinnt):
/// 1. letzte 90 Tage + gleiche Preisklasse
/// 2. letzte 90 Tage (alle Preisklassen)
/// 3. alle Käufe + gleiche Preisklasse
/// 4. alle Käufe
///
/// Ziel-Perzentil ist fix das obere Quartil (P75): Das Gebot überbietet so
/// die historischen Aufschläge von 75 % aller Konkurrenz-Käufe. Die
/// tatsächliche Konkurrenz auf dem Markt ist über die API nicht beobachtbar
/// (Anzahl Gebote zeigt nur das eigene Gebot), daher gibt es keine
/// Angebots-Eskalation – P75 ist der robuste Default.
class BidRecommendationService {
  /// Der von Kickbase fuer einen Kauf verwendeten Transfer-Typ.
  static const int purchaseTransferType = 1;

  /// Mindestanzahl verwertbarer Kaeufe, damit das Ziel-Perzentil als
  /// stabile Empfehlungsgrundlage dient. Bei kleineren Stichproben
  /// entspricht das Perzentil faktisch dem Maximum und liefert riskant
  /// hohe Gebote – dann wird der Median verwendet.
  static const int minimumSampleSize = 4;

  /// Ziel-Perzentil der Aufschlagsverteilung (oberes Quartil).
  static const double targetQuantile = 0.75;

  /// Standard-Boxplot-Faktor (1.5 x IQR) fuer die Ausreisserkappung.
  static const double iqrOutlierFactor = 1.5;

  /// Zeitfenster in Tagen, innerhalb dessen Kaeufe als aktuell gelten.
  /// Aeltere Kaeufe werden nur genutzt, wenn das aktuelle Fenster zu
  /// duenn besetzt ist (siehe Klassen-Dokumentation).
  static const int recentWindowDays = 90;

  /// Obere Grenze der kleinen Preisklasse (< 2 Mio. € Marktwert).
  static const double smallBandUpperLimit = 2000000;

  /// Untere Grenze der grossen Preisklasse (>= 10 Mio. € Marktwert).
  static const double largeBandLowerLimit = 10000000;

  const BidRecommendationService();

  /// Empfiehlt ein Gebot auf Basis der Konkurrenz-Kaufhistorie.
  ///
  /// [now] ist nur für Tests gedacht (sonst aktuelle Zeit).
  BidRecommendation recommend({
    required int currentMarketValue,
    required int minimumBid,
    required List<ManagerTransferHistoryEntry> transfers,
    DateTime? now,
  }) {
    if (currentMarketValue <= 0) {
      return _minimumFallback(minimumBid, currentMarketValue);
    }

    final usable = _collectUsable(transfers);
    if (usable.isEmpty) {
      return _minimumFallback(minimumBid, currentMarketValue);
    }

    final referenceDate = now ?? DateTime.now();
    final recentCutoff = referenceDate.subtract(
      const Duration(days: recentWindowDays),
    );
    bool isRecent(ManagerTransferHistoryEntry entry) =>
        !entry.timestamp.isBefore(recentCutoff) &&
        !entry.timestamp.isAfter(referenceDate);
    bool sameBand(ManagerTransferHistoryEntry entry) =>
        entry.marketValueAtTransfer != null &&
        _bandIndex(entry.marketValueAtTransfer!) ==
            _bandIndex(currentMarketValue);

    final candidateSets = <(String, List<ManagerTransferHistoryEntry>)>[
      (
        'letzte $recentWindowDays Tage + Preisklasse',
        usable.where(isRecent).where(sameBand).toList(),
      ),
      ('letzte $recentWindowDays Tage', usable.where(isRecent).toList()),
      ('alle Käufe + Preisklasse', usable.where(sameBand).toList()),
      ('alle Käufe', usable),
    ];

    // Erster Satz mit ausreichendem Sample gewinnt (Perzentil-Pfad);
    // sonst der erste nicht-leere Satz (Median-Pfad).
    (String, List<ManagerTransferHistoryEntry>)? chosen;
    var quantilePath = true;
    for (final candidate in candidateSets) {
      if (candidate.$2.length >= minimumSampleSize) {
        chosen = candidate;
        break;
      }
    }
    if (chosen == null) {
      for (final candidate in candidateSets) {
        if (candidate.$2.isNotEmpty) {
          chosen = candidate;
          quantilePath = false;
          break;
        }
      }
    }
    if (chosen == null) {
      return _minimumFallback(minimumBid, currentMarketValue);
    }

    final premiums = chosen.$2
        .map((entry) => entry.price / entry.marketValueAtTransfer!)
        .toList()
      ..sort();
    final robust = _removeOutliers(premiums);
    final sampleSize = robust.length;

    final usePercentile = quantilePath && sampleSize >= minimumSampleSize;
    final premium = usePercentile
        ? _percentile(robust, targetQuantile)
        : _median(robust);
    final method = usePercentile ? 'quartile' : 'median';

    // Erst aufrunden, dann mit dem Mindestgebot vergleichen – so empfehlen
    // wir nie mehr als nötig, wenn das Mindestgebot bereits ausreicht.
    final roundedHistoricalBid = _ceilTo100k(
      (currentMarketValue * premium).ceil(),
    );
    final amount = max(minimumBid, roundedHistoricalBid);

    return BidRecommendation(
      amount: amount,
      minimumBid: minimumBid,
      premium: amount / currentMarketValue,
      sampleSize: sampleSize,
      method: method,
      confidence: _confidence(sampleSize: sampleSize, hasHistory: true),
      scope: chosen.$1,
    );
  }

  /// Rueckwaerts-kompatibler Wrapper: nur der empfohlene Betrag.
  int recommendBid({
    required int currentMarketValue,
    required int minimumBid,
    required List<ManagerTransferHistoryEntry> transfers,
  }) => recommend(
    currentMarketValue: currentMarketValue,
    minimumBid: minimumBid,
    transfers: transfers,
  ).amount;

  // ---------------------------------------------------------------------------
  // Komponenten
  // ---------------------------------------------------------------------------

  BidRecommendation _minimumFallback(int minimumBid, int currentMarketValue) {
    return BidRecommendation(
      amount: minimumBid,
      minimumBid: minimumBid,
      premium: currentMarketValue > 0 ? minimumBid / currentMarketValue : 0,
      sampleSize: 0,
      method: 'minimum',
      confidence: 0.1,
      scope: 'keine verwertbare Kaufhistorie',
    );
  }

  double _confidence({required int sampleSize, required bool hasHistory}) {
    if (!hasHistory) return 0.1;
    return (0.25 + 0.75 * min(1.0, sampleSize / 20)).clamp(0.0, 1.0);
  }

  int _bandIndex(int marketValue) {
    if (marketValue < smallBandUpperLimit) return 0;
    if (marketValue < largeBandLowerLimit) return 1;
    return 2;
  }

  int _ceilTo100k(int value) => ((value + 99999) ~/ 100000) * 100000;

  /// Alle verwertbaren Kaeufe (Kaeufe mit positivem Preis und Marktwert).
  ///
  /// Ein Kaufpreis oder Marktwert <= 0 ist ein Datendefekt (der
  /// Parsing-Fallback liefert 0) und wuerde das Perzentil kuenstlich
  /// nach unten ziehen, daher wird er gefiltert.
  List<ManagerTransferHistoryEntry> _collectUsable(
    List<ManagerTransferHistoryEntry> transfers,
  ) => transfers
      .where(
        (transfer) =>
            transfer.transferType == purchaseTransferType &&
            transfer.price > 0 &&
            transfer.marketValueAtTransfer != null &&
            transfer.marketValueAtTransfer! > 0,
      )
      .toList();

  /// Entfernt Ausreisser aus der sortierten Aufschlagsliste (IQR-Regel).
  ///
  /// Werte ausserhalb von [Q1 - 1.5*IQR, Q3 + 1.5*IQR] stammen
  /// typischerweise aus Sonderfaellen (z.B. Freundschaftskaeufe) und
  /// wuerden das Perzentil sonst stark uebertreiben. Bei weniger als
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
