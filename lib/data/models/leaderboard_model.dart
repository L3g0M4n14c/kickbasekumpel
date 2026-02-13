import 'package:freezed_annotation/freezed_annotation.dart';

part 'leaderboard_model.freezed.dart';
part 'leaderboard_model.g.dart';

/// Leaderboard Entry - Eintrag in der Rangliste
@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LeaderboardEntry({
    required String leagueId,
    required String userId,
    required String username,
    required int rank,
    required int totalPoints,
    required int gamesPlayed,
    required double averagePoints,
    required int wins,
    required int draws,
    required int losses,
    required DateTime lastUpdated,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}

/// Ranking Model - Rangliste/Standings für eine Liga
@freezed
class Ranking with _$Ranking {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Ranking({
    required String leagueId,
    required String leagueName,
    required List<LeaderboardEntry> entries,
    required int totalParticipants,
    String? updateFrequency,
    required DateTime lastUpdated,
  }) = _Ranking;

  factory Ranking.fromJson(Map<String, dynamic> json) =>
      _$RankingFromJson(json);
}

/// User Ranking - Ranking eines einzelnen Nutzers
@freezed
class UserRanking with _$UserRanking {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UserRanking({
    required String userId,
    required String username,
    required int totalPoints,
    required int rank,
    int? pointsBehindLeader,
    int? pointsAheadNext,
    required int gamesPlayed,
    required String trend,
  }) = _UserRanking;

  factory UserRanking.fromJson(Map<String, dynamic> json) =>
      _$UserRankingFromJson(json);
}

/// League Standings - Komplette Liga Tabelle
@freezed
class LeagueStandings with _$LeagueStandings {
  const factory LeagueStandings({
    required String leagueId,
    required String leagueName,
    required List<LeaderboardEntry> standings,
    required int matchdayNumber,
    required DateTime createdAt,
  }) = _LeagueStandings;

  factory LeagueStandings.fromJson(Map<String, dynamic> json) =>
      _$LeagueStandingsFromJson(json);
}

/// Historical Ranking - Historische Rangliste
@freezed
class HistoricalRanking with _$HistoricalRanking {
  const factory HistoricalRanking({
    required String leagueId,
    required int matchday,
    required List<LeaderboardEntry> standings,
    required DateTime recordedAt,
  }) = _HistoricalRanking;

  factory HistoricalRanking.fromJson(Map<String, dynamic> json) =>
      _$HistoricalRankingFromJson(json);
}

/// Ranking Change - Änderung in Ranking
@freezed
class RankingChange with _$RankingChange {
  const factory RankingChange({
    required String userId,
    required String username,
    required int previousRank,
    required int currentRank,
    required int pointsChange,
    required DateTime timestamp,
  }) = _RankingChange;

  factory RankingChange.fromJson(Map<String, dynamic> json) =>
      _$RankingChangeFromJson(json);
}
