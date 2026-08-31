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

/// Ein automatischer Verkauf ("Auto-Verkauf", 250er-Regel).
///
/// Seit Kickbase-Update 4.8.0 kann der Admin eine Liga-Regel aktivieren, die
/// jeden Spieler automatisch an den Transfermarkt verkauft, sobald er eine
/// festgelegte Saison-Punktzahl erreicht (Schwelle aus dem
/// Overview-Endpoint, Feld `ptspf` – z.B. 250). Der Verkauf erfolgt mit der
/// finalen Spieltagsberechnung und erscheint NICHT in der Transfer-Historie
/// des Managers – daher muss das dabei eingenommene Budget (Marktwert zum
/// Verkaufszeitpunkt) separat zur Budget-Berechnung addiert werden.
@freezed
class AutoSaleEvent with _$AutoSaleEvent {
  const factory AutoSaleEvent({
    /// Spieltag, an dem der Spieler die Schwelle erreicht hat
    required int matchday,

    /// Spieler-ID
    required String playerId,

    /// Spielername
    required String playerName,

    /// Saison-Gesamtpunkte zum Zeitpunkt des Verkaufs
    required int points,

    /// Punkte-Schwelle der Regel (z.B. 250)
    required int threshold,

    /// Marktwert zum Verkaufszeitpunkt (Einnahme)
    required int marketValue,

    /// true, wenn der Marktwert nicht zweifelsfrei ermittelt werden konnte
    @Default(false) bool uncertain,
  }) = _AutoSaleEvent;

  factory AutoSaleEvent.fromJson(Map<String, dynamic> json) =>
      _$AutoSaleEventFromJson(json);
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

    /// Summe der Einnahmen durch automatische Verkäufe (Auto-Verkauf /
    /// 250er-Regel). Diese Verkäufe erscheinen nicht in der Transfer-Historie
    /// und werden daher separat ermittelt und addiert.
    @Default(0) int autoSaleIncome,

    /// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
    @Default([]) List<AutoSaleEvent> autoSaleEvents,
  }) = _BudgetCalculationResult;

  factory BudgetCalculationResult.fromJson(Map<String, dynamic> json) =>
      _$BudgetCalculationResultFromJson(json);
}
