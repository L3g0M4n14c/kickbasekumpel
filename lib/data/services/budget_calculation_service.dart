import '../models/budget_calculation_model.dart';
import '../models/transfer_model.dart';

/// Service für die Berechnung des Manager-Budgets
///
/// Vereinfachte Version: Startbudget = 50 Mio. €
/// Dann werden nur die Transfers verrechnet:
/// - Verkäufe (transferType == 2) werden addiert
/// - Käufe (transferType == 1) werden subtrahiert
class BudgetCalculationService {
  /// Festes Startbudget für die vereinfachte Berechnung (50 Mio. €)
  static const int startingBudget = 50000000;

  /// Berechnet das Budget für einen Manager
  ///
  /// [managerId] - ID des Managers
  /// [managerName] - Name des Managers
  /// [leagueId] - Liga ID
  /// [allTransfers] - Alle Transfers (Käufe und Verkäufe) des Managers
  /// [currentTimestamp] - Aktueller Zeitstempel für die Berechnung
  ///
  /// Returns [BudgetCalculationResult] mit allen Berechnungsschritten
  BudgetCalculationResult calculateManagerBudget({
    required String managerId,
    required String managerName,
    required String leagueId,
    required List<ManagerTransferHistoryEntry> allTransfers,
    DateTime? currentTimestamp,
  }) {
    final now = currentTimestamp ?? DateTime.now().toUtc();

    // 1. Transfers nach Typ trennen
    final sales = <ManagerTransfer>[];
    final purchases = <ManagerTransfer>[];

    for (final transfer in allTransfers) {
      final managerTransfer = ManagerTransfer(
        transferId: transfer.id,
        playerId: transfer.playerId,
        playerName: transfer.playerName,
        price: transfer.price,
        transferType: transfer.transferType,
        timestamp: transfer.timestamp,
        marketValueAtTransfer: transfer.marketValueAtTransfer,
      );

      if (transfer.transferType == 2) {
        // Verkauf (transferType == 2)
        sales.add(managerTransfer);
      } else if (transfer.transferType == 1) {
        // Kauf (transferType == 1)
        purchases.add(managerTransfer);
      }
      // Andere Typen (z.B. Tausch) werden ignoriert
    }

    // 2. Summen berechnen
    final totalSales = sales.fold<int>(0, (sum, sale) => sum + sale.price);
    final totalPurchases = purchases.fold<int>(
      0,
      (sum, purchase) => sum + purchase.price,
    );

    // 3. Aktuelles Budget berechnen: 50M + Verkäufe - Käufe
    final currentBudget = startingBudget + totalSales - totalPurchases;

    return BudgetCalculationResult(
      managerId: managerId,
      managerName: managerName,
      leagueId: leagueId,
      initialBudget: startingBudget,
      initialSquadValue: 0, // Nicht verwendet in vereinfachter Version
      startingBudget: startingBudget,
      totalSales: totalSales,
      totalPurchases: totalPurchases,
      currentBudget: currentBudget,
      initialPlayers: [], // Nicht verwendet in vereinfachter Version
      sales: sales,
      purchases: purchases,
      calculatedAt: now,
    );
  }

  /// Formatiere Budget für die Anzeige (in Mio. €)
  String formatBudget(int budget) {
    final inMillions = budget / 1000000;
    return '${inMillions.toStringAsFixed(2)} M €';
  }

  /// Formatiere Marktwert für die Anzeige
  String formatMarketValue(int value) {
    if (value >= 1000000) {
      final inMillions = value / 1000000;
      return '${inMillions.toStringAsFixed(2)} M €';
    } else {
      return '${(value / 1000).toStringAsFixed(0)} T €';
    }
  }
}
