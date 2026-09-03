import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/budget_calculation_service.dart';

void main() {
  group('BudgetCalculationService', () {
    late BudgetCalculationService service;

    setUp(() {
      service = BudgetCalculationService();
    });

    test('calculateManagerBudget with no transfers', () {
      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: [],
      );

      expect(result.managerId, 'manager1');
      expect(result.managerName, 'Test Manager');
      expect(result.leagueId, 'league1');
      expect(result.initialBudget, 50000000);
      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 0);
      expect(result.totalPurchases, 0);
      expect(result.currentBudget, 50000000);
      expect(result.sales, isEmpty);
      expect(result.purchases, isEmpty);
    });

    test('calculateManagerBudget with sales only', () {
      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Sold Player',
          price: 20000000,
          transferType: 2, // Sale
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
      );

      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 20000000);
      expect(result.totalPurchases, 0);
      expect(result.currentBudget, 70000000); // 50M + 20M
      expect(result.sales.length, 1);
      expect(result.purchases.length, 0);
    });

    test('calculateManagerBudget with purchases only', () {
      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Bought Player',
          price: 30000000,
          transferType: 1, // Purchase
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
      );

      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 0);
      expect(result.totalPurchases, 30000000);
      expect(result.currentBudget, 20000000); // 50M - 30M
      expect(result.sales.length, 0);
      expect(result.purchases.length, 1);
    });

    test('calculateManagerBudget with mixed transfers', () {
      // Beispiel: Startbudget 50M + Verkauf 20M - Kauf 30M = 40M

      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Sold Player',
          price: 20000000,
          transferType: 2, // Sale
          timestamp: DateTime.now(),
        ),
        ManagerTransferHistoryEntry(
          id: '2',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '3',
          playerName: 'Bought Player',
          price: 30000000,
          transferType: 1, // Purchase
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
      );

      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 20000000);
      expect(result.totalPurchases, 30000000);
      expect(result.currentBudget, 40000000); // 50M + 20M - 30M = 40M
    });

    test('formatBudget formats correctly', () {
      expect(service.formatBudget(50000000), '50.00 M €');
      expect(service.formatBudget(70000000), '70.00 M €');
      expect(service.formatBudget(1234567), '1.23 M €');
    });

    test('formatMarketValue formats correctly', () {
      expect(service.formatMarketValue(50000000), '50.00 M €');
      expect(service.formatMarketValue(500000), '500 T €');
      expect(service.formatMarketValue(1234567), '1.23 M €');
    });
  });

  group('BudgetCalculationService – Anmeldebonus', () {
    late BudgetCalculationService service;

    setUp(() {
      service = BudgetCalculationService();
    });

    test('loginBonusForDay steigt täglich bis Tag 10 und bleibt dann konstant',
        () {
      expect(service.loginBonusForDay(1), 10000);
      expect(service.loginBonusForDay(2), 20000);
      expect(service.loginBonusForDay(3), 30000);
      expect(service.loginBonusForDay(9), 90000);
      expect(service.loginBonusForDay(10), 100000);
      expect(service.loginBonusForDay(11), 100000);
      expect(service.loginBonusForDay(25), 100000);
      expect(service.loginBonusForDay(0), 0);
      expect(service.loginBonusForDay(-5), 0);
    });

    test('cumulativeLoginBonus summiert die Tagesboni korrekt', () {
      expect(service.cumulativeLoginBonus(0), 0);
      expect(service.cumulativeLoginBonus(-3), 0);
      // Tag 1: 10.000 €
      expect(service.cumulativeLoginBonus(1), 10000);
      // Tag 1+2: 10.000 + 20.000 = 30.000 €
      expect(service.cumulativeLoginBonus(2), 30000);
      // Tag 1+2+3: 10.000 + 20.000 + 30.000 = 60.000 €
      expect(service.cumulativeLoginBonus(3), 60000);
      // Tag 1..10: 10.000 + 20.000 + … + 100.000 = 550.000 €
      expect(service.cumulativeLoginBonus(10), 550000);
      // Ab Tag 10 kommen täglich 100.000 € hinzu
      expect(service.cumulativeLoginBonus(11), 650000);
      expect(service.cumulativeLoginBonus(20), 1550000); // 550.000 + 10 × 100.000
    });

    test('calculateLoginBonus am ersten Tag der Liga', () {
      final seasonStart = DateTime.utc(2026, 8, 21);
      final result = service.calculateLoginBonus(
        seasonStart: seasonStart,
        now: DateTime.utc(2026, 8, 21, 23, 59),
      );

      expect(result, 10000);
      expect(service.loginBonusDaysSince(seasonStart, now: DateTime.utc(2026, 8, 21, 23, 59)), 1);
    });

    test('calculateLoginBonus am zweiten Tag der Liga', () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 22, 12, 0),
      );

      expect(result, 30000); // 10.000 + 20.000
    });

    test('calculateLoginBonus am zehnten Tag der Liga', () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 30, 6, 0),
      );

      expect(result, 550000); // 10.000 + … + 100.000
    });

    test('calculateLoginBonus nach dem zehnten Tag: täglich 100.000 €', () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 31, 18, 30),
      );

      expect(result, 650000); // 550.000 + 100.000
    });

    test('calculateLoginBonus ist 0, wenn die Liga noch nicht gestartet ist',
        () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 20, 23, 59),
      );

      expect(result, 0);
    });

    test('calculateLoginBonus normalisiert Zeitanteile (UTC, Tagesgrenzen)',
        () {
      // Saisonstart mit Uhrzeit – muss trotzdem als Tag 21.08. gelten
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21, 14, 30),
        now: DateTime.utc(2026, 8, 23, 1, 0),
      );

      expect(result, 60000); // 10.000 + 20.000 + 30.000
    });
  });
}
