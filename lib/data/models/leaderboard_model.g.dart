// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  leagueId: json['leagueId'] as String,
  userId: json['userId'] as String,
  username: json['username'] as String,
  rank: (json['rank'] as num).toInt(),
  totalPoints: (json['totalPoints'] as num).toInt(),
  gamesPlayed: (json['gamesPlayed'] as num).toInt(),
  averagePoints: (json['averagePoints'] as num).toDouble(),
  wins: (json['wins'] as num).toInt(),
  draws: (json['draws'] as num).toInt(),
  losses: (json['losses'] as num).toInt(),
  last_updated: DateTime.parse(json['last_updated'] as String),
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'leagueId': instance.leagueId,
  'userId': instance.userId,
  'username': instance.username,
  'rank': instance.rank,
  'totalPoints': instance.totalPoints,
  'gamesPlayed': instance.gamesPlayed,
  'averagePoints': instance.averagePoints,
  'wins': instance.wins,
  'draws': instance.draws,
  'losses': instance.losses,
  'last_updated': instance.last_updated.toIso8601String(),
};

_$RankingImpl _$$RankingImplFromJson(Map<String, dynamic> json) =>
    _$RankingImpl(
      leagueId: json['leagueId'] as String,
      leagueName: json['leagueName'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_participants: (json['total_participants'] as num).toInt(),
      update_frequency: json['update_frequency'] as String?,
      last_updated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$RankingImplToJson(_$RankingImpl instance) =>
    <String, dynamic>{
      'leagueId': instance.leagueId,
      'leagueName': instance.leagueName,
      'entries': instance.entries,
      'total_participants': instance.total_participants,
      'update_frequency': instance.update_frequency,
      'last_updated': instance.last_updated.toIso8601String(),
    };

_$UserRankingImpl _$$UserRankingImplFromJson(Map<String, dynamic> json) =>
    _$UserRankingImpl(
      userId: json['userId'] as String,
      username: json['username'] as String,
      totalPoints: (json['totalPoints'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      points_behind_leader: (json['points_behind_leader'] as num?)?.toInt(),
      points_ahead_next: (json['points_ahead_next'] as num?)?.toInt(),
      gamesPlayed: (json['gamesPlayed'] as num).toInt(),
      trend: json['trend'] as String,
    );

Map<String, dynamic> _$$UserRankingImplToJson(_$UserRankingImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'totalPoints': instance.totalPoints,
      'rank': instance.rank,
      'points_behind_leader': instance.points_behind_leader,
      'points_ahead_next': instance.points_ahead_next,
      'gamesPlayed': instance.gamesPlayed,
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
