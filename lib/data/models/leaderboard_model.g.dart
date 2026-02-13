// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  leagueId: json['league_id'] as String,
  userId: json['user_id'] as String,
  username: json['username'] as String,
  rank: (json['rank'] as num).toInt(),
  totalPoints: (json['total_points'] as num).toInt(),
  gamesPlayed: (json['games_played'] as num).toInt(),
  averagePoints: (json['average_points'] as num).toDouble(),
  wins: (json['wins'] as num).toInt(),
  draws: (json['draws'] as num).toInt(),
  losses: (json['losses'] as num).toInt(),
  lastUpdated: DateTime.parse(json['last_updated'] as String),
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'league_id': instance.leagueId,
  'user_id': instance.userId,
  'username': instance.username,
  'rank': instance.rank,
  'total_points': instance.totalPoints,
  'games_played': instance.gamesPlayed,
  'average_points': instance.averagePoints,
  'wins': instance.wins,
  'draws': instance.draws,
  'losses': instance.losses,
  'last_updated': instance.lastUpdated.toIso8601String(),
};

_$RankingImpl _$$RankingImplFromJson(Map<String, dynamic> json) =>
    _$RankingImpl(
      leagueId: json['league_id'] as String,
      leagueName: json['league_name'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalParticipants: (json['total_participants'] as num).toInt(),
      updateFrequency: json['update_frequency'] as String?,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$RankingImplToJson(_$RankingImpl instance) =>
    <String, dynamic>{
      'league_id': instance.leagueId,
      'league_name': instance.leagueName,
      'entries': instance.entries,
      'total_participants': instance.totalParticipants,
      'update_frequency': instance.updateFrequency,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };

_$UserRankingImpl _$$UserRankingImplFromJson(Map<String, dynamic> json) =>
    _$UserRankingImpl(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      totalPoints: (json['total_points'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      pointsBehindLeader: (json['points_behind_leader'] as num?)?.toInt(),
      pointsAheadNext: (json['points_ahead_next'] as num?)?.toInt(),
      gamesPlayed: (json['games_played'] as num).toInt(),
      trend: json['trend'] as String,
    );

Map<String, dynamic> _$$UserRankingImplToJson(_$UserRankingImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'total_points': instance.totalPoints,
      'rank': instance.rank,
      'points_behind_leader': instance.pointsBehindLeader,
      'points_ahead_next': instance.pointsAheadNext,
      'games_played': instance.gamesPlayed,
      'trend': instance.trend,
    };

_$LeagueStandingsImpl _$$LeagueStandingsImplFromJson(
  Map<String, dynamic> json,
) => _$LeagueStandingsImpl(
  leagueId: json['leagueId'] as String,
  leagueName: json['leagueName'] as String,
  standings: (json['standings'] as List<dynamic>)
      .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  matchdayNumber: (json['matchdayNumber'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$LeagueStandingsImplToJson(
  _$LeagueStandingsImpl instance,
) => <String, dynamic>{
  'leagueId': instance.leagueId,
  'leagueName': instance.leagueName,
  'standings': instance.standings,
  'matchdayNumber': instance.matchdayNumber,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$HistoricalRankingImpl _$$HistoricalRankingImplFromJson(
  Map<String, dynamic> json,
) => _$HistoricalRankingImpl(
  leagueId: json['leagueId'] as String,
  matchday: (json['matchday'] as num).toInt(),
  standings: (json['standings'] as List<dynamic>)
      .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  recordedAt: DateTime.parse(json['recordedAt'] as String),
);

Map<String, dynamic> _$$HistoricalRankingImplToJson(
  _$HistoricalRankingImpl instance,
) => <String, dynamic>{
  'leagueId': instance.leagueId,
  'matchday': instance.matchday,
  'standings': instance.standings,
  'recordedAt': instance.recordedAt.toIso8601String(),
};

_$RankingChangeImpl _$$RankingChangeImplFromJson(Map<String, dynamic> json) =>
    _$RankingChangeImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      previousRank: (json['previousRank'] as num).toInt(),
      currentRank: (json['currentRank'] as num).toInt(),
      pointsChange: (json['pointsChange'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$RankingChangeImplToJson(_$RankingChangeImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'previousRank': instance.previousRank,
      'currentRank': instance.currentRank,
      'pointsChange': instance.pointsChange,
      'timestamp': instance.timestamp.toIso8601String(),
    };
