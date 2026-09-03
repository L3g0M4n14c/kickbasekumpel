import '../models/budget_calculation_model.dart';
import '../models/transfer_model.dart';

/// Service für die Berechnung des Manager-Budgets
///
/// Vereinfachte Version: Startbudget = 50 Mio. €
/// Dann werden verrechnet:
/// - Verkäufe (transferType == 2) werden addiert
/// - Käufe (transferType == 1) werden subtrahiert
/// - Täglicher Anmeldebonus (siehe [calculateLoginBonus])
class BudgetCalculationService {
  /// Festes Startbudget für die vereinfachte Berechnung (50 Mio. €)
  static const int startingBudget = 50000000;

  /// Bonus am 1. Tag der Liga (10.000 €), steigt täglich um 10.000 €
  /// bis am 10. Tag 100.000 € erreicht sind – ab dann konstant 100.000 €.
  static const int loginBonusPerDayStep = 10000;

  /// Tag, ab dem der Tagesbonus auf dem Maximum ([loginBonusMaxPerDay])
  /// gedeckelt ist.
  static const int loginBonusMaxDay = 10;

  /// Maximaler Tagesbonus (100.000 €, ab Tag 10)
  static const int loginBonusMaxPerDay =
      loginBonusPerDayStep * loginBonusMaxDay;

  /// Tagesbonus für einen bestimmten Liga-Tag (1-basiert).
  ///
  /// Tag 1 = 10.000 €, Tag 2 = 20.000 €, … Tag 10 = 100.000 €,
  /// ab Tag 10 konstant 100.000 €.
  int loginBonusForDay(int day) {
    if (day <= 0) return 0;
    final effectiveDay = day < loginBonusMaxDay ? day : loginBonusMaxDay;
    return effectiveDay * loginBonusPerDayStep;
  }

  /// Kumulierter Anmeldebonus für [days] vergangene Liga-Tage.
  ///
  /// [days] = Anzahl der Tage, für die der Bonus gewährt wurde
  /// (Tag 1 = erster Tag der Liga). Bei 0 oder negativen Tagen wird 0
  /// zurückgegeben.
  ///
  /// Beispiele:
  /// - 1 Tag  → 10.000 €
  /// - 2 Tage → 30.000 € (10.000 + 20.000)
  /// - 10 Tage → 550.000 € (10.000 + 20.000 + … + 100.000)
  /// - 11 Tage → 650.000 € (550.000 + 100.000)
  int cumulativeLoginBonus(int days) {
    if (days <= 0) return 0;
    final cappedDays = days < loginBonusMaxDay ? days : loginBonusMaxDay;
    // Summe 1 + 2 + … + n = n * (n + 1) / 2
    final rampUpTotal = cappedDays * (cappedDays + 1) ~/ 2;
    final flatDays = days > loginBonusMaxDay ? days - loginBonusMaxDay : 0;
    return rampUpTotal * loginBonusPerDayStep + flatDays * loginBonusMaxPerDay;
  }

  /// Anzahl der Liga-Tage seit dem Saison-Start bis zum Referenzzeitpunkt
  /// (1-basiert: am Tag des Saison-Starts ist man bei Liga-Tag 1).
  ///
  /// Liefert 0, wenn der Saison-Start in der Zukunft liegt.
  int loginBonusDaysSince(DateTime seasonStart, {DateTime? now}) {
    final reference = (now ?? DateTime.now().toUtc()).toUtc();
    final startDay = DateTime.utc(
      seasonStart.toUtc().year,
      seasonStart.toUtc().month,
      seasonStart.toUtc().day,
    );
    final today = DateTime.utc(reference.year, reference.month, reference.day);

    if (today.isBefore(startDay)) return 0;

    final daysElapsed = today.difference(startDay).inDays;
    // Tag 1 ist der Start-Tag selbst, daher +1
    return daysElapsed + 1;
  }

  /// Berechnet den kumulierten täglichen Anmeldebonus seit dem Liga-Start.
  ///
  /// Jeder Manager erhält am ersten Tag der Liga 10.000 €, am zweiten Tag
  /// 20.000 €, … bis zum zehnten Tag 100.000 € – und ab da an jedem Tag
  /// konstant 100.000 €. Tag 1 ist der [seasonStart]-Tag selbst.
  ///
  /// [seasonStart] - Erster Tag der Liga
  /// [now] - Referenzzeitpunkt (default: jetzt, UTC)
  ///
  /// Returns: kumulierter Bonus in € (0, wenn der Liga-Start in der Zukunft
  /// liegt).
  int calculateLoginBonus({required DateTime seasonStart, DateTime? now}) {
    final days = loginBonusDaysSince(seasonStart, now: now);
    return cumulativeLoginBonus(days);
  }

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
