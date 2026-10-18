import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_value_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
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

  group('ManagerTransferHistoryService – Nachfrage-Aggregation', () {
    // Feste lokale Zeitpunkte: der Service rechnet in lokaler Zeit
    // (DateTime.toLocal() ist fuer lokale DateTime-Instanzen identisch),
    // damit sind die Tests zeitzonenunabhaengig.
    // Sonntag, 20 Uhr -> aktuelles Zeitfenster „Abend" (18-24 Uhr).
    final now = DateTime(2026, 11, 1, 20);
    final currentWindow = DemandWindow(
      weekday: now.weekday,
      slot: DemandTimeSlot.ofHour(now.hour),
    );

    test(
      'aggregiert Käufe pro Wochentag/Zeitfenster und ignoriert Verkäufe',
      () {
        // Arrange
        final service = ManagerTransferHistoryService();
        final transfers = [
          _purchase(_at(reference: now, weekday: 7, slot: 3, weeksAgo: 1)),
          _purchase(_at(reference: now, weekday: 7, slot: 3, weeksAgo: 2)),
          _purchase(_at(reference: now, weekday: 1, slot: 1, weeksAgo: 1)),
          // Verkauf – zaehlt nicht als Nachfrage.
          _purchase(
            _at(reference: now, weekday: 7, slot: 3, weeksAgo: 3),
            transferType: 2,
          ),
        ];

        // Act
        final counts = service.purchasesByTimeWindow(transfers);

        // Assert
        expect(counts, hasLength(2));
        expect(
          counts[const DemandWindow(weekday: 7, slot: DemandTimeSlot.evening)],
          2,
        );
        expect(
          counts[const DemandWindow(weekday: 1, slot: DemandTimeSlot.morning)],
          1,
        );
      },
    );

    test('Zeitfenster-Label benennt Wochentag und Stundenbereich', () {
      expect(
        const DemandWindow(weekday: 7, slot: DemandTimeSlot.evening).label,
        'Sonntag, 18-24 Uhr',
      );
    });

    test('Nachfrage hoch bei vielen Käufen im aktuellen Zeitfenster', () {
      // Arrange: 5 Sonntag-Abend-Käufe (aktuelles Fenster), 5 Montag-Morgen.
      final service = ManagerTransferHistoryService();
      final transfers = [
        for (var week = 1; week <= 5; week++)
          _purchase(_at(reference: now, weekday: 7, slot: 3, weeksAgo: week)),
        for (var week = 1; week <= 5; week++)
          _purchase(_at(reference: now, weekday: 1, slot: 1, weeksAgo: week)),
      ];

      // Act
      final profile = service.demandProfile(transfers: transfers, now: now);

      // Assert
      expect(profile.currentWindow, currentWindow);
      expect(profile.currentWindowPurchases, 5);
      expect(profile.totalPurchases, 10);
      expect(profile.averagePurchasesPerWindow, closeTo(10 / 28, 0.001));
      expect(profile.intensity, DemandIntensity.high);
    });

    test('Nachfrage mittel bei Durchschnitt je Zeitfenster', () {
      // Arrange: genau ein Kauf in jedem der 28 Zeitfenster.
      final service = ManagerTransferHistoryService();
      final transfers = [
        for (var weekday = 1; weekday <= DateTime.daysPerWeek; weekday++)
          for (var slot = 0; slot < DemandTimeSlot.values.length; slot++)
            _purchase(
              _at(
                reference: now,
                weekday: weekday,
                slot: slot,
                weeksAgo: 1 + ((weekday + slot) % 5),
              ),
            ),
      ];

      // Act
      final profile = service.demandProfile(transfers: transfers, now: now);

      // Assert
      expect(profile.totalPurchases, 28);
      expect(profile.purchasesByWindow, hasLength(28));
      expect(profile.currentWindowPurchases, 1);
      expect(profile.intensity, DemandIntensity.medium);
    });

    test('Nachfrage niedrig ohne Käufe im aktuellen Zeitfenster', () {
      // Arrange: alle Käufe Montag-Morgen, nie im aktuellen Fenster.
      final service = ManagerTransferHistoryService();
      final transfers = [
        for (var week = 1; week <= 10; week++)
          _purchase(_at(reference: now, weekday: 1, slot: 1, weeksAgo: week)),
      ];

      // Act
      final profile = service.demandProfile(transfers: transfers, now: now);

      // Assert
      expect(profile.currentWindowPurchases, 0);
      expect(profile.intensity, DemandIntensity.low);
    });

    test('Hinweis entfällt, wenn die Historie kürzer als 4 Wochen ist', () {
      // Arrange: 10 Käufe, aber nur aus den letzten 10 Tagen.
      final service = ManagerTransferHistoryService();
      final transfers = [
        for (var day = 1; day <= 10; day++)
          _purchase(now.subtract(Duration(days: day))),
      ];

      // Act
      final profile = service.demandProfile(transfers: transfers, now: now);

      // Assert
      expect(profile.totalPurchases, 10);
      expect(profile.oldestPurchase, isNotNull);
      expect(profile.intensity, isNull);
    });

    test('Hinweis entfällt bei zu wenigen Käufen', () {
      // Arrange: 3 Käufe, weit genug zurückreichend.
      final service = ManagerTransferHistoryService();
      final transfers = [
        for (final week in const [1, 3, 5])
          _purchase(_at(reference: now, weekday: 1, slot: 1, weeksAgo: week)),
      ];

      // Act
      final profile = service.demandProfile(transfers: transfers, now: now);

      // Assert
      expect(profile.totalPurchases, 3);
      expect(profile.oldestPurchase, isNotNull);
      expect(profile.intensity, isNull);
    });
  });
}

/// Lokaler Zeitpunkt [weeksAgo] Wochen vor dem Wochentag [weekday] im
/// Zeitfenster [slot] (6h-Bloecke: 0 = 0-6 Uhr, 3 = 18-24 Uhr).
DateTime _at({
  required DateTime reference,
  required int weekday,
  required int slot,
  int weeksAgo = 0,
}) {
  final daysBack = (reference.weekday - weekday) % DateTime.daysPerWeek;
  return DateTime(
    reference.year,
    reference.month,
    reference.day - daysBack,
    slot * 6 + 1,
  ).subtract(Duration(days: weeksAgo * DateTime.daysPerWeek));
}

ManagerTransferHistoryEntry _purchase(
  DateTime timestamp, {
  int transferType = ManagerTransferHistoryService.purchaseTransferType,
}) {
  return ManagerTransferHistoryEntry(
    id: 'transfer-${timestamp.millisecondsSinceEpoch}-$transferType',
    leagueId: 'league-1',
    managerId: 'manager-1',
    managerName: 'Manager',
    playerId: 'player-1',
    playerName: 'Spieler',
    price: 1000000,
    transferType: transferType,
    timestamp: timestamp,
  );
}
