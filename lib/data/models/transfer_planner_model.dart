import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';

part 'transfer_planner_model.freezed.dart';
part 'transfer_planner_model.g.dart';

/// Eingabedaten für die Erstellung von Transfer-Plänen.
@freezed
class TransferPlannerInput with _$TransferPlannerInput {
  const factory TransferPlannerInput({
    required List<Player> squadPlayers,
    required List<Player> marketPlayers,
    required int currentBudget,
  }) = _TransferPlannerInput;

  factory TransferPlannerInput.fromJson(Map<String, dynamic> json) =>
      _$TransferPlannerInputFromJson(json);
}

/// Bewertungsmetriken für ein Transfer-Szenario.
@freezed
class TransferPlanScore with _$TransferPlanScore {
  const factory TransferPlanScore({
    required double startingElevenGain,
    required double executionRisk,
    required double valueStability,
  }) = _TransferPlanScore;

  factory TransferPlanScore.fromJson(Map<String, dynamic> json) =>
      _$TransferPlanScoreFromJson(json);
}

/// Ein einzelner Transfer-Schritt eines Szenarios.
@freezed
class TransferPlanMove with _$TransferPlanMove {
  const factory TransferPlanMove.sell({
    required Player player,
    required int amount,
  }) = TransferPlanMoveSell;

  const factory TransferPlanMove.buy({
    required Player player,
    required int amount,
  }) = TransferPlanMoveBuy;

  factory TransferPlanMove.fromJson(Map<String, dynamic> json) =>
      _$TransferPlanMoveFromJson(json);
}

/// Vollständiges Transfer-Szenario.
@freezed
class TransferPlanScenario with _$TransferPlanScenario {
  const factory TransferPlanScenario({
    required String id,
    required String title,
    required List<TransferPlanMove> sells,
    required List<TransferPlanMove> buys,
    required List<Player> resultingStarters,
    required int budgetBefore,
    required int budgetAfter,
    required String summary,
    required List<String> warnings,
    required TransferPlanScore score,
  }) = _TransferPlanScenario;

  factory TransferPlanScenario.fromJson(Map<String, dynamic> json) =>
      _$TransferPlanScenarioFromJson(json);
}

/// Ergebnis der Plan-Berechnung.
@freezed
class TransferPlannerResult with _$TransferPlannerResult {
  const factory TransferPlannerResult({
    required List<TransferPlanScenario> scenarios,
    String? noPlanReason,
  }) = _TransferPlannerResult;

  factory TransferPlannerResult.fromJson(Map<String, dynamic> json) =>
      _$TransferPlannerResultFromJson(json);
}
