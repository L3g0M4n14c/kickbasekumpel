// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerPerformanceResponseImpl _$$PlayerPerformanceResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PlayerPerformanceResponseImpl(
  it: (json['it'] as List<dynamic>)
      .map((e) => SeasonPerformance.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PlayerPerformanceResponseImplToJson(
  _$PlayerPerformanceResponseImpl instance,
) => <String, dynamic>{'it': instance.it};

_$SeasonPerformanceImpl _$$SeasonPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$SeasonPerformanceImpl(
  ti: json['ti'] as String,
  n: json['n'] as String,
  ph: (json['ph'] as List<dynamic>)
      .map((e) => MatchPerformance.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$SeasonPerformanceImplToJson(
  _$SeasonPerformanceImpl instance,
) => <String, dynamic>{'ti': instance.ti, 'n': instance.n, 'ph': instance.ph};

_$MatchPerformanceImpl _$$MatchPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$MatchPerformanceImpl(
  day: (json['day'] as num).toInt(),
  p: (json['p'] as num?)?.toInt(),
  mp: json['mp'] as String?,
  md: json['md'] as String,
  t1: json['t1'] as String,
  t2: json['t2'] as String,
  t1g: (json['t1g'] as num?)?.toInt(),
  t2g: (json['t2g'] as num?)?.toInt(),
  pt: json['pt'] as String?,
  k: (json['k'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
  st: (json['st'] as num).toInt(),
  cur: json['cur'] as bool,
  mdst: (json['mdst'] as num).toInt(),
  ap: (json['ap'] as num?)?.toInt(),
  tp: (json['tp'] as num?)?.toInt(),
  asp: (json['asp'] as num?)?.toInt(),
);

Map<String, dynamic> _$$MatchPerformanceImplToJson(
  _$MatchPerformanceImpl instance,
) => <String, dynamic>{
  'day': instance.day,
  'p': instance.p,
  'mp': instance.mp,
  'md': instance.md,
  't1': instance.t1,
  't2': instance.t2,
  't1g': instance.t1g,
  't2g': instance.t2g,
  'pt': instance.pt,
  'k': instance.k,
  'st': instance.st,
  'cur': instance.cur,
  'mdst': instance.mdst,
  'ap': instance.ap,
  'tp': instance.tp,
  'asp': instance.asp,
};

_$EnhancedMatchPerformanceImpl _$$EnhancedMatchPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$EnhancedMatchPerformanceImpl(
  basePerformance: MatchPerformance.fromJson(
    json['basePerformance'] as Map<String, dynamic>,
  ),
  team1Name: json['team1Name'] as String?,
  team2Name: json['team2Name'] as String?,
  playerTeamName: json['playerTeamName'] as String?,
  opponentTeamName: json['opponentTeamName'] as String?,
  team1Placement: (json['team1Placement'] as num?)?.toInt(),
  team2Placement: (json['team2Placement'] as num?)?.toInt(),
  playerTeamPlacement: (json['playerTeamPlacement'] as num?)?.toInt(),
  opponentTeamPlacement: (json['opponentTeamPlacement'] as num?)?.toInt(),
);

Map<String, dynamic> _$$EnhancedMatchPerformanceImplToJson(
  _$EnhancedMatchPerformanceImpl instance,
) => <String, dynamic>{
  'basePerformance': instance.basePerformance,
  'team1Name': instance.team1Name,
  'team2Name': instance.team2Name,
  'playerTeamName': instance.playerTeamName,
  'opponentTeamName': instance.opponentTeamName,
  'team1Placement': instance.team1Placement,
  'team2Placement': instance.team2Placement,
  'playerTeamPlacement': instance.playerTeamPlacement,
  'opponentTeamPlacement': instance.opponentTeamPlacement,
};
