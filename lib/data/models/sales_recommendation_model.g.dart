// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesRecommendationImpl _$$SalesRecommendationImplFromJson(
  Map<String, dynamic> json,
) => _$SalesRecommendationImpl(
  id: json['id'] as String,
  player: Player.fromJson(json['player'] as Map<String, dynamic>),
  reason: json['reason'] as String,
  priority: $enumDecode(_$SalesPriorityEnumMap, json['priority']),
  expectedValue: (json['expectedValue'] as num).toInt(),
  impact: $enumDecode(_$LineupImpactEnumMap, json['impact']),
);

Map<String, dynamic> _$$SalesRecommendationImplToJson(
  _$SalesRecommendationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'player': instance.player,
  'reason': instance.reason,
  'priority': _$SalesPriorityEnumMap[instance.priority]!,
  'expectedValue': instance.expectedValue,
  'impact': _$LineupImpactEnumMap[instance.impact]!,
};

const _$SalesPriorityEnumMap = {
  SalesPriority.high: 'high',
  SalesPriority.medium: 'medium',
  SalesPriority.low: 'low',
};

const _$LineupImpactEnumMap = {
  LineupImpact.minimal: 'minimal',
  LineupImpact.moderate: 'moderate',
  LineupImpact.significant: 'significant',
};
