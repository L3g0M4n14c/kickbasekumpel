import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_calculation_model.freezed.dart';
part 'budget_calculation_model.g.dart';

/// Budget Berechnungs-Model für Manager
///
/// Berechnet das aktuelle Budget eines Managers basierend auf:
/// - Startbudget: 150 Mio. €
/// - Anfangskader: Summe der Marktwerte der zugelosten Spieler
/// - Transfers: Verkäufe (addieren) und Käufe (subtrahieren)
@freezed
class ManagerBudgetCalculation with _$ManagerBudgetCalculation {
  const factory ManagerBudgetCalculation({
    /// Manager ID
    required String managerId,

    /// Manager Name
    required String managerName,

    /// Liga ID
    required String leagueId,

    /// Startbudget (150 Mio. €)
    @Default(150000000) int initialBudget,

    /// Summe der Marktwerte der Anfangsspieler
    @Default(0) int initialSquadValue,

    /// Startbudget nach Abzug der Anfangsspieler
    @Default(0) int startingBudget,

    /// Summe aller Verkäufe (Einnahmen)
    @Default(0) int totalSales,

    /// Summe aller Käufe (Ausgaben)
    @Default(0) int totalPurchases,

    /// Aktuelles Budget
    @Default(0) int currentBudget,

    /// Liste der Anfangsspieler mit Marktwert
    @Default([]) List<InitialPlayer> initialPlayers,

    /// Liste der Transfers (Käufe und Verkäufe)
    @Default([]) List<ManagerTransfer> transfers,

    /// Zeitstempel der Berechnung
    required DateTime calculatedAt,
  }) = _ManagerBudgetCalculation;

  factory ManagerBudgetCalculation.fromJson(Map<String, dynamic> json) =>
      _$ManagerBudgetCalculationFromJson(json);
}

/// Spieler im Anfangskader mit Marktwert
@freezed
class InitialPlayer with _$InitialPlayer {
  const factory InitialPlayer({
    required String playerId,
    required String playerName,
    required int marketValue,
    required DateTime transferDate,
  }) = _InitialPlayer;

  factory InitialPlayer.fromJson(Map<String, dynamic> json) =>
      _$InitialPlayerFromJson(json);
}

/// Manager Transfer für Budget-Berechnung
@freezed
class ManagerTransfer with _$ManagerTransfer {
  const factory ManagerTransfer({
    required String transferId,
    required String playerId,
    required String playerName,
    required int price,
    required int transferType, // 1 = Kauf, 2 = Verkauf
    required DateTime timestamp,
    int? marketValueAtTransfer,
  }) = _ManagerTransfer;

  factory ManagerTransfer.fromJson(Map<String, dynamic> json) =>
      _$ManagerTransferFromJson(json);
}

/// Ergebnis der Budget-Berechnung
@freezed
class BudgetCalculationResult with _$BudgetCalculationResult {
  const factory BudgetCalculationResult({
    required String managerId,
    required String managerName,
    required String leagueId,
    required int initialBudget,
    required int initialSquadValue,
    required int startingBudget,
    required int totalSales,
    required int totalPurchases,
    required int currentBudget,
    required List<InitialPlayer> initialPlayers,
    required List<ManagerTransfer> sales,
    required List<ManagerTransfer> purchases,
    required DateTime calculatedAt,
  }) = _BudgetCalculationResult;

  factory BudgetCalculationResult.fromJson(Map<String, dynamic> json) =>
      _$BudgetCalculationResultFromJson(json);
}
