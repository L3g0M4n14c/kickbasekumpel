// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_planner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferPlannerInputImpl _$$TransferPlannerInputImplFromJson(
  Map<String, dynamic> json,
) => _$TransferPlannerInputImpl(
  squadPlayers: (json['squadPlayers'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  marketPlayers: (json['marketPlayers'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  currentBudget: (json['currentBudget'] as num).toInt(),
);

Map<String, dynamic> _$$TransferPlannerInputImplToJson(
  _$TransferPlannerInputImpl instance,
) => <String, dynamic>{
  'squadPlayers': instance.squadPlayers,
  'marketPlayers': instance.marketPlayers,
  'currentBudget': instance.currentBudget,
};

_$TransferPlanScoreImpl _$$TransferPlanScoreImplFromJson(
  Map<String, dynamic> json,
) => _$TransferPlanScoreImpl(
  startingElevenGain: (json['startingElevenGain'] as num).toDouble(),
  executionRisk: (json['executionRisk'] as num).toDouble(),
  valueStability: (json['valueStability'] as num).toDouble(),
);

Map<String, dynamic> _$$TransferPlanScoreImplToJson(
  _$TransferPlanScoreImpl instance,
) => <String, dynamic>{
  'startingElevenGain': instance.startingElevenGain,
  'executionRisk': instance.executionRisk,
  'valueStability': instance.valueStability,
};

_$TransferPlanMoveSellImpl _$$TransferPlanMoveSellImplFromJson(
  Map<String, dynamic> json,
) => _$TransferPlanMoveSellImpl(
  player: Player.fromJson(json['player'] as Map<String, dynamic>),
  amount: (json['amount'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$TransferPlanMoveSellImplToJson(
  _$TransferPlanMoveSellImpl instance,
) => <String, dynamic>{
  'player': instance.player,
  'amount': instance.amount,
  'runtimeType': instance.$type,
};

_$TransferPlanMoveBuyImpl _$$TransferPlanMoveBuyImplFromJson(
  Map<String, dynamic> json,
) => _$TransferPlanMoveBuyImpl(
  player: Player.fromJson(json['player'] as Map<String, dynamic>),
  amount: (json['amount'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$TransferPlanMoveBuyImplToJson(
  _$TransferPlanMoveBuyImpl instance,
) => <String, dynamic>{
  'player': instance.player,
  'amount': instance.amount,
  'runtimeType': instance.$type,
};

_$TransferPlanScenarioImpl _$$TransferPlanScenarioImplFromJson(
  Map<String, dynamic> json,
) => _$TransferPlanScenarioImpl(
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

Map<String, dynamic> _$$TransferPlanScenarioImplToJson(
  _$TransferPlanScenarioImpl instance,
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

_$TransferPlannerResultImpl _$$TransferPlannerResultImplFromJson(
  Map<String, dynamic> json,
) => _$TransferPlannerResultImpl(
  scenarios: (json['scenarios'] as List<dynamic>)
      .map((e) => TransferPlanScenario.fromJson(e as Map<String, dynamic>))
      .toList(),
  noPlanReason: json['noPlanReason'] as String?,
);

Map<String, dynamic> _$$TransferPlannerResultImplToJson(
  _$TransferPlannerResultImpl instance,
) => <String, dynamic>{
  'scenarios': instance.scenarios,
  'noPlanReason': instance.noPlanReason,
};
