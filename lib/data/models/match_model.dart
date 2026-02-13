import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// Match Model - Bundesliga Match
@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String matchDay,
    required int kickOffTime,
    required String homeTeamId,
    required String homeTeamName,
    required String awayTeamId,
    required String awayTeamName,
    required int homeTeamGoals,
    required int awayTeamGoals,
    required String status,
    required int season,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

/// Match Data - Detaillierte Match Informationen
@freezed
class MatchData with _$MatchData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MatchData({
    required String id,
    required String playerId,
    required String playerName,
    required String matchId,
    required String opponent,
    required int position,
    required int goals,
    required int assists,
    required int cleanSheet,
    required int ownGoals,
    required int redCards,
    required int yellowCards,
    required int minutesPlayed,
    required int points,
    required double rating,
    required DateTime createdAt,
  }) = _MatchData;

  factory MatchData.fromJson(Map<String, dynamic> json) =>
      _$MatchDataFromJson(json);
}

/// Highlight Model - Spieler-Highlights
@freezed
class Highlight with _$Highlight {
  const factory Highlight({
    required String id,
    required String playerId,
    required String playerName,
    required String matchId,
    required String description,
    required String highlightType,
    required int points,
    required DateTime timestamp,
  }) = _Highlight;

  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json);
}

/// Matches Response - Match Liste
@freezed
class MatchesResponse with _$MatchesResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MatchesResponse({
    required List<Match> matches,
    int? totalCount,
  }) = _MatchesResponse;

  factory MatchesResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchesResponseFromJson(json);
}

/// Match Day Info - Info für einen Spieltag
@freezed
class MatchDayInfo with _$MatchDayInfo {
  const factory MatchDayInfo({
    required String matchDay,
    required int startTime,
    required int endTime,
    required List<Match> matches,
  }) = _MatchDayInfo;

  factory MatchDayInfo.fromJson(Map<String, dynamic> json) =>
      _$MatchDayInfoFromJson(json);
}
