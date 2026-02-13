// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimal_lineup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OptimalLineupImpl _$$OptimalLineupImplFromJson(Map<String, dynamic> json) =>
    _$OptimalLineupImpl(
      goalkeeper: json['goalkeeper'] == null
          ? null
          : Player.fromJson(json['goalkeeper'] as Map<String, dynamic>),
      defenders: (json['defenders'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      midfielders: (json['midfielders'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      forwards: (json['forwards'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OptimalLineupImplToJson(_$OptimalLineupImpl instance) =>
    <String, dynamic>{
      'goalkeeper': instance.goalkeeper,
      'defenders': instance.defenders,
      'midfielders': instance.midfielders,
      'forwards': instance.forwards,
    };

_$LineupComparisonImpl _$$LineupComparisonImplFromJson(
  Map<String, dynamic> json,
) => _$LineupComparisonImpl(
  currentLineup: OptimalLineup.fromJson(
    json['currentLineup'] as Map<String, dynamic>,
  ),
  optimalLineup: OptimalLineup.fromJson(
    json['optimalLineup'] as Map<String, dynamic>,
  ),
  currentScore: (json['currentScore'] as num).toDouble(),
  optimalScore: (json['optimalScore'] as num).toDouble(),
  suggestedAdditions: (json['suggestedAdditions'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  suggestedRemovals: (json['suggestedRemovals'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$LineupComparisonImplToJson(
  _$LineupComparisonImpl instance,
) => <String, dynamic>{
  'currentLineup': instance.currentLineup,
  'optimalLineup': instance.optimalLineup,
  'currentScore': instance.currentScore,
  'optimalScore': instance.optimalScore,
  'suggestedAdditions': instance.suggestedAdditions,
  'suggestedRemovals': instance.suggestedRemovals,
};
