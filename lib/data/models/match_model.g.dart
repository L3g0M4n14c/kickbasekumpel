// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Match _$MatchFromJson(Map<String, dynamic> json) => _Match(
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

Map<String, dynamic> _$MatchToJson(_Match instance) => <String, dynamic>{
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

_MatchData _$MatchDataFromJson(Map<String, dynamic> json) => _MatchData(
  id: json['id'] as String,
  playerId: json['player_id'] as String,
  playerName: json['player_name'] as String,
  matchId: json['match_id'] as String,
  opponent: json['opponent'] as String,
  position: (json['position'] as num).toInt(),
  goals: (json['goals'] as num).toInt(),
  assists: (json['assists'] as num).toInt(),
  cleanSheet: (json['clean_sheet'] as num).toInt(),
  ownGoals: (json['own_goals'] as num).toInt(),
  redCards: (json['red_cards'] as num).toInt(),
  yellowCards: (json['yellow_cards'] as num).toInt(),
  minutesPlayed: (json['minutes_played'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  rating: (json['rating'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MatchDataToJson(_MatchData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player_id': instance.playerId,
      'player_name': instance.playerName,
      'match_id': instance.matchId,
      'opponent': instance.opponent,
      'position': instance.position,
      'goals': instance.goals,
      'assists': instance.assists,
      'clean_sheet': instance.cleanSheet,
      'own_goals': instance.ownGoals,
      'red_cards': instance.redCards,
      'yellow_cards': instance.yellowCards,
      'minutes_played': instance.minutesPlayed,
      'points': instance.points,
      'rating': instance.rating,
      'created_at': instance.createdAt.toIso8601String(),
    };

_Highlight _$HighlightFromJson(Map<String, dynamic> json) => _Highlight(
  id: json['id'] as String,
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  matchId: json['matchId'] as String,
  description: json['description'] as String,
  highlightType: json['highlightType'] as String,
  points: (json['points'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$HighlightToJson(_Highlight instance) =>
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

_MatchesResponse _$MatchesResponseFromJson(Map<String, dynamic> json) =>
    _MatchesResponse(
      matches: (json['matches'] as List<dynamic>)
          .map((e) => Match.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MatchesResponseToJson(_MatchesResponse instance) =>
    <String, dynamic>{
      'matches': instance.matches,
      'total_count': instance.totalCount,
    };

_MatchDayInfo _$MatchDayInfoFromJson(Map<String, dynamic> json) =>
    _MatchDayInfo(
      matchDay: json['matchDay'] as String,
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num).toInt(),
      matches: (json['matches'] as List<dynamic>)
          .map((e) => Match.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchDayInfoToJson(_MatchDayInfo instance) =>
    <String, dynamic>{
      'matchDay': instance.matchDay,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'matches': instance.matches,
    };
