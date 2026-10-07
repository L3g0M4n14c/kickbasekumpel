// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LineupResponse _$LineupResponseFromJson(Map<String, dynamic> json) =>
    _LineupResponse(
      players: (json['it'] as List<dynamic>)
          .map((e) => LineupPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LineupResponseToJson(_LineupResponse instance) =>
    <String, dynamic>{'it': instance.players};

_LineupPlayer _$LineupPlayerFromJson(Map<String, dynamic> json) =>
    _LineupPlayer(
      id: json['i'] as String,
      name: json['n'] as String,
      position: (json['pos'] as num?)?.toInt() ?? 0,
      teamId: json['tid'] as String? ?? '',
      averagePoints: (json['ap'] as num?)?.toInt() ?? 0,
      totalPoints: (json['st'] as num?)?.toInt() ?? 0,
      matchDayStatus: (json['mdst'] as num?)?.toInt() ?? 0,
      lineupOrder: (json['lo'] as num?)?.toInt() ?? 0,
      lastTotalPoints: (json['lst'] as num?)?.toInt() ?? 0,
      hasToday: json['ht'] as bool? ?? false,
      originalStatus: json['os'] as String?,
      performanceHistory: (json['ph'] as List<dynamic>?)
          ?.map((e) => PerformanceHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LineupPlayerToJson(_LineupPlayer instance) =>
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

_PerformanceHistory _$PerformanceHistoryFromJson(Map<String, dynamic> json) =>
    _PerformanceHistory(
      points: (json['p'] as num?)?.toInt() ?? 0,
      hasPlayed: json['hp'] as bool? ?? false,
    );

Map<String, dynamic> _$PerformanceHistoryToJson(_PerformanceHistory instance) =>
    <String, dynamic>{'p': instance.points, 'hp': instance.hasPlayed};

_LineupUpdateRequest _$LineupUpdateRequestFromJson(Map<String, dynamic> json) =>
    _LineupUpdateRequest(
      playerIds: (json['playerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LineupUpdateRequestToJson(
  _LineupUpdateRequest instance,
) => <String, dynamic>{'playerIds': instance.playerIds};
