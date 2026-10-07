// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_planner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferPlannerInput _$TransferPlannerInputFromJson(
  Map<String, dynamic> json,
) => _TransferPlannerInput(
  squadPlayers: (json['squadPlayers'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  marketPlayers: (json['marketPlayers'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentBudget: (json['currentBudget'] as num).toInt(),
);

Map<String, dynamic> _$TransferPlannerInputToJson(
  _TransferPlannerInput instance,
) => <String, dynamic>{
  'squadPlayers': instance.squadPlayers,
  'marketPlayers': instance.marketPlayers,
  'currentBudget': instance.currentBudget,
};

_TransferPlanScore _$TransferPlanScoreFromJson(Map<String, dynamic> json) =>
    _TransferPlanScore(
      startingElevenGain: (json['startingElevenGain'] as num).toDouble(),
      executionRisk: (json['executionRisk'] as num).toDouble(),
      valueStability: (json['valueStability'] as num).toDouble(),
    );

Map<String, dynamic> _$TransferPlanScoreToJson(_TransferPlanScore instance) =>
    <String, dynamic>{
      'startingElevenGain': instance.startingElevenGain,
      'executionRisk': instance.executionRisk,
      'valueStability': instance.valueStability,
    };

TransferPlanMoveSell _$TransferPlanMoveSellFromJson(
  Map<String, dynamic> json,
) => TransferPlanMoveSell(
  player: Player.fromJson(json['player'] as Map<String, dynamic>),
  amount: (json['amount'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$TransferPlanMoveSellToJson(
  TransferPlanMoveSell instance,
) => <String, dynamic>{
  'player': instance.player,
  'amount': instance.amount,
  'runtimeType': instance.$type,
};

TransferPlanMoveBuy _$TransferPlanMoveBuyFromJson(Map<String, dynamic> json) =>
    TransferPlanMoveBuy(
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      amount: (json['amount'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$TransferPlanMoveBuyToJson(
  TransferPlanMoveBuy instance,
) => <String, dynamic>{
  'player': instance.player,
  'amount': instance.amount,
  'runtimeType': instance.$type,
};

_TransferPlanScenario _$TransferPlanScenarioFromJson(
  Map<String, dynamic> json,
) => _TransferPlanScenario(
  id: json['id'] as String,
  title: json['title'] as String,
  sells: (json['sells'] as List<dynamic>)
      .map((e) => TransferPlanMove.fromJson(e as Map<String, dynamic>))
      .toList(),
  buys: (json['buys'] as List<dynamic>)
      .map((e) => TransferPlanMove.fromJson(e as Map<String, dynamic>))
      .toList(),
  resultingStarters: (json['resultingStarters'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  budgetBefore: (json['budgetBefore'] as num).toInt(),
  budgetAfter: (json['budgetAfter'] as num).toInt(),
  summary: json['summary'] as String,
  warnings: (json['warnings'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  score: TransferPlanScore.fromJson(json['score'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransferPlanScenarioToJson(
  _TransferPlanScenario instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'sells': instance.sells,
  'buys': instance.buys,
  'resultingStarters': instance.resultingStarters,
  'budgetBefore': instance.budgetBefore,
  'budgetAfter': instance.budgetAfter,
  'summary': instance.summary,
  'warnings': instance.warnings,
  'score': instance.score,
};

_TransferPlannerResult _$TransferPlannerResultFromJson(
  Map<String, dynamic> json,
) => _TransferPlannerResult(
  scenarios: (json['scenarios'] as List<dynamic>)
      .map((e) => TransferPlanScenario.fromJson(e as Map<String, dynamic>))
      .toList(),
  noPlanReason: json['noPlanReason'] as String?,
  noPlanDetails: json['noPlanDetails'] as String?,
);

Map<String, dynamic> _$TransferPlannerResultToJson(
  _TransferPlannerResult instance,
) => <String, dynamic>{
  'scenarios': instance.scenarios,
  'noPlanReason': instance.noPlanReason,
  'noPlanDetails': instance.noPlanDetails,
};
