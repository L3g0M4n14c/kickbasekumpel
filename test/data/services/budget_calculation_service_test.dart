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
}
