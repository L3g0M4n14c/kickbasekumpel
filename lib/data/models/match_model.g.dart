// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatchImpl _$$MatchImplFromJson(Map<String, dynamic> json) => _$MatchImpl(
  id: json['id'] as String,
  matchDay: json['matchDay'] as String,
  kickOffTime: (json['kickOffTime'] as num).toInt(),
  homeTeamId: json['homeTeamId'] as String,
  homeTeamName: json['homeTeamName'] as String,
  awayTeamId: json['awayTeamId'] as String,
  awayTeamName: json['awayTeamName'] as String,
  homeTeamGoals: (json['homeTeamGoals'] as num).toInt(),
  awayTeamGoals: (json['awayTeamGoals'] as num).toInt(),
  status: json['status'] as String,
  season: (json['season'] as num).toInt(),
);

Map<String, dynamic> _$$MatchImplToJson(_$MatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchDay': instance.matchDay,
      'kickOffTime': instance.kickOffTime,
      'homeTeamId': instance.homeTeamId,
      'homeTeamName': instance.homeTeamName,
      'awayTeamId': instance.awayTeamId,
      'awayTeamName': instance.awayTeamName,
      'homeTeamGoals': instance.homeTeamGoals,
      'awayTeamGoals': instance.awayTeamGoals,
      'status': instance.status,
      'season': instance.season,
    };

_$MatchDataImpl _$$MatchDataImplFromJson(Map<String, dynamic> json) =>
    _$MatchDataImpl(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      matchId: json['matchId'] as String,
      opponent: json['opponent'] as String,
      position: (json['position'] as num).toInt(),
      goals: (json['goals'] as num).toInt(),
      assists: (json['assists'] as num).toInt(),
      cleanSheet: (json['cleanSheet'] as num).toInt(),
      own_goals: (json['own_goals'] as num).toInt(),
      redCards: (json['redCards'] as num).toInt(),
      yellowCards: (json['yellowCards'] as num).toInt(),
      minutesPlayed: (json['minutesPlayed'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MatchDataImplToJson(_$MatchDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'matchId': instance.matchId,
      'opponent': instance.opponent,
      'position': instance.position,
      'goals': instance.goals,
      'assists': instance.assists,
      'cleanSheet': instance.cleanSheet,
      'own_goals': instance.own_goals,
      'redCards': instance.redCards,
      'yellowCards': instance.yellowCards,
      'minutesPlayed': instance.minutesPlayed,
      'points': instance.points,
      'rating': instance.rating,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$HighlightImpl _$$HighlightImplFromJson(Map<String, dynamic> json) =>
    _$HighlightImpl(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      matchId: json['matchId'] as String,
      description: json['description'] as String,
      highlightType: json['highlightType'] as String,
      points: (json['points'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$HighlightImplToJson(_$HighlightImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'matchId': instance.matchId,
      'description': instance.description,
      'highlightType': instance.highlightType,
      'points': instance.points,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$MatchesResponseImpl _$$MatchesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MatchesResponseImpl(
  matches: (json['matches'] as List<dynamic>)
      .map((e) => Match.fromJson(e as Map<String, dynamic>))
      .toList(),
  total_count: (json['total_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$$MatchesResponseImplToJson(
  _$MatchesResponseImpl instance,
) => <String, dynamic>{
  'matches': instance.matches,
  'total_count': instance.total_count,
};

_$MatchDayInfoImpl _$$MatchDayInfoImplFromJson(Map<String, dynamic> json) =>
    _$MatchDayInfoImpl(
      matchDay: json['matchDay'] as String,
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num).toInt(),
      matches: (json['matches'] as List<dynamic>)
          .map((e) => Match.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MatchDayInfoImplToJson(_$MatchDayInfoImpl instance) =>
    <String, dynamic>{
      'matchDay': instance.matchDay,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'matches': instance.matches,
    };
