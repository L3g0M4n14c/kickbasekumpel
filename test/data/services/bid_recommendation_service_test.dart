import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/bid_recommendation_service.dart';

void main() {
  group('BidRecommendationService', () {
    const service = BidRecommendationService();
    const currentMarketValue = 10000000;
    const minimumBid = 10500000;

    // Fixe Referenzzeit, damit der 90-Tage-Fenster-Test deterministisch ist.
    final now = DateTime.utc(2026, 9, 28);
    final recent = DateTime.utc(2026, 9, 1);
    final old = DateTime.utc(2026, 1, 1);

    test('empfiehlt das obere Quartil (P75) der Konkurrenz-Aufschlaege', () {
      final transfers = [
        for (final premium in [1.1, 1.2, 1.3, 1.4])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: recent,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 13000000);
      expect(recommendation.method, 'quartile');
      expect(recommendation.sampleSize, 4);
      expect(recommendation.scope, contains('Preisklasse'));
    });

    test('zu kleine Stichprobe faellt auf den Median zurueck', () {
      final transfers = [
        for (final premium in [1.1, 1.2, 1.3])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: recent,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 12000000);
      expect(recommendation.method, 'median');
    });

    test('aeltere Kaeufe werden genutzt, wenn das aktuelle Fenster leer ist',
        () {
      final transfers = [
        for (final premium in [1.1, 1.2, 1.3, 1.4])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: old,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 13000000);
      expect(recommendation.scope, 'alle Käufe + Preisklasse');
    });

    test('Preisklassen trennen: Billigkauf-Aufschlaege beeinflussen teure '
        'Spieler nicht', () {
      final transfers = [
        // Billigsegment: über 200% Aufschlag.
        for (final premium in [2.0, 2.1, 2.2, 2.3])
          _transfer(
            price: (premium * 500000).toInt(),
            marketValue: 500000,
            timestamp: recent,
          ),
        // Gleiches Segment wie der Zielspieler (20 Mio.).
        for (final premium in [1.1, 1.2, 1.3, 1.4])
          _transfer(
            price: (premium * 15000000).toInt(),
            marketValue: 15000000,
            timestamp: recent,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: 20000000,
        minimumBid: 21000000,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 26000000);
      expect(recommendation.scope, contains('Preisklasse'));
    });

    test('faellt in der Leiter zurueck, wenn die Preisklasse zu duenn ist',
        () {
      final transfers = [
        // Nur 1 Kauf in der Preisklasse des Zielspielers.
        _transfer(
          price: 26000000,
          marketValue: 20000000,
          timestamp: recent,
        ),
        // 4 kaufkräftige Kaeufe in anderen Preisklassen.
        for (final premium in [2.0, 2.1, 2.2, 2.3])
          _transfer(
            price: (premium * 500000).toInt(),
            marketValue: 500000,
            timestamp: recent,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: 20000000,
        minimumBid: 21000000,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.scope, 'letzte 90 Tage');
      expect(recommendation.amount, 44000000);
    });

    test('kappt Ausreisser per IQR-Regel vor der Perzentilberechnung', () {
      final transfers = [
        for (final premium in [1.1, 1.2, 1.3, 1.4])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: recent,
          ),
        // Ausreisserkauf mit 5x Marktwert.
        _transfer(price: 50000000, marketValue: 10000000, timestamp: recent),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 13000000);
      expect(recommendation.sampleSize, 4);
    });

    test('empfiehlt nie mehr als noetig: Mindestgebot bleibt exakt erhalten',
        () {
      final transfers = [
        for (var i = 0; i < 3; i++)
          _transfer(price: 10000000, marketValue: 10000000, timestamp: recent),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: 10550000, // bewusst kein 100k-Vielfaches
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 10550000);
      expect(recommendation.minimumBid, 10550000);
    });

    test('filtert defekte Datensaetze heraus', () {
      final transfers = [
        _transfer(price: 0, marketValue: 10000000, timestamp: recent),
        _transfer(
          price: 12000000,
          marketValue: 10000000,
          marketValueAtTransfer: null,
          timestamp: recent,
        ),
        for (final premium in [1.1, 1.2, 1.3, 1.4])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: recent,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, 13000000);
      expect(recommendation.sampleSize, 4);
    });

    test('verkaeufe (transferType 2) werden ignoriert', () {
      final transfers = [
        _transfer(
          transferType: 2,
          price: 50000000,
          marketValue: 10000000,
          timestamp: recent,
        ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.method, 'minimum');
      expect(recommendation.amount, minimumBid);
      expect(recommendation.sampleSize, 0);
      expect(recommendation.confidence, 0.1);
    });

    test('kein positiver Marktwert fuehrt zum Minimum', () {
      final recommendation = service.recommend(
        currentMarketValue: 0,
        minimumBid: minimumBid,
        transfers: const [],
        now: now,
      );

      expect(recommendation.amount, minimumBid);
      expect(recommendation.method, 'minimum');
    });

    test('empfiehlt nie unter dem Mindestgebot', () {
      final transfers = [
        for (final premium in [0.9, 0.95, 0.98])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: recent,
          ),
      ];

      final recommendation = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: transfers,
        now: now,
      );

      expect(recommendation.amount, minimumBid);
    });

    test('Konfidenz steigt mit der Sample-Groesse', () {
      List<ManagerTransferHistoryEntry> buildTransfers(int count) => [
        for (var i = 0; i < count; i++)
          _transfer(
            price: 11000000 + i * 10000,
            marketValue: 10000000,
            timestamp: recent,
          ),
      ];

      final low = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: buildTransfers(4),
        now: now,
      );
      final high = service.recommend(
        currentMarketValue: currentMarketValue,
        minimumBid: minimumBid,
        transfers: buildTransfers(20),
        now: now,
      );

      expect(
        low.confidence,
        lessThan(high.confidence),
        reason: 'mehr Daten = mehr Konfidenz',
      );
      expect(high.confidence, inInclusiveRange(0.0, 1.0));
    });

    test('recommendBid-Wrapper liefert nur den Betrag', () {
      final transfers = [
        for (final premium in [1.1, 1.2, 1.3, 1.4])
          _transfer(
            price: (premium * 10000000).toInt(),
            marketValue: 10000000,
            timestamp: recent,
          ),
      ];

      // Wrapper liefert nur den Betrag (P75-Pfad).
      expect(
        service.recommendBid(
          currentMarketValue: currentMarketValue,
          minimumBid: minimumBid,
          transfers: transfers,
        ),
        13000000,
      );
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
  DateTime? timestamp,
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
    timestamp: timestamp ?? DateTime.utc(2026, 9, 1),
    marketValueAtTransfer: marketValueAtTransfer == _unset
        ? marketValue
        : marketValueAtTransfer as int?,
  );
}

