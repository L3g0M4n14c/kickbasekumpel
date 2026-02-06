// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineupResponseImpl _$$LineupResponseImplFromJson(Map<String, dynamic> json) =>
    _$LineupResponseImpl(
      players: (json['it'] as List<dynamic>)
          .map((e) => LineupPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LineupResponseImplToJson(
  _$LineupResponseImpl instance,
) => <String, dynamic>{'it': instance.players};

_$LineupPlayerImpl _$$LineupPlayerImplFromJson(Map<String, dynamic> json) =>
    _$LineupPlayerImpl(
      id: json['i'] as String,
      name: json['n'] as String,
      position: (json['pos'] as num).toInt(),
      teamId: json['tid'] as String,
      averagePoints: (json['ap'] as num).toInt(),
      totalPoints: (json['st'] as num).toInt(),
      matchDayStatus: (json['mdst'] as num).toInt(),
      lineupOrder: (json['lo'] as num).toInt(),
      lastTotalPoints: (json['lst'] as num).toInt(),
      hasToday: json['ht'] as bool,
      originalStatus: json['os'] as String?,
      performanceHistory: (json['ph'] as List<dynamic>?)
          ?.map((e) => PerformanceHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LineupPlayerImplToJson(_$LineupPlayerImpl instance) =>
    <String, dynamic>{
      'i': instance.id,
      'n': instance.name,
      'pos': instance.position,
      'tid': instance.teamId,
      'ap': instance.averagePoints,
      'st': instance.totalPoints,
      'mdst': instance.matchDayStatus,
      'lo': instance.lineupOrder,
      'lst': instance.lastTotalPoints,
      'ht': instance.hasToday,
      'os': instance.originalStatus,
      'ph': instance.performanceHistory,
    };

_$PerformanceHistoryImpl _$$PerformanceHistoryImplFromJson(
  Map<String, dynamic> json,
) => _$PerformanceHistoryImpl(
  points: (json['p'] as num).toInt(),
  hasPlayed: json['hp'] as bool,
);

Map<String, dynamic> _$$PerformanceHistoryImplToJson(
  _$PerformanceHistoryImpl instance,
) => <String, dynamic>{'p': instance.points, 'hp': instance.hasPlayed};

_$LineupUpdateRequestImpl _$$LineupUpdateRequestImplFromJson(
  Map<String, dynamic> json,
) => _$LineupUpdateRequestImpl(
  playerIds: (json['playerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$LineupUpdateRequestImplToJson(
  _$LineupUpdateRequestImpl instance,
) => <String, dynamic>{'playerIds': instance.playerIds};
