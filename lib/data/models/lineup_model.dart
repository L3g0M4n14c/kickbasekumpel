import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup_model.freezed.dart';
part 'lineup_model.g.dart';

/// Response from GET /v4/leagues/{leagueId}/lineup
@freezed
abstract class LineupResponse with _$LineupResponse {
  const factory LineupResponse({
    @JsonKey(name: 'it') required List<LineupPlayer> players,
  }) = _LineupResponse;

  factory LineupResponse.fromJson(Map<String, dynamic> json) =>
      _$LineupResponseFromJson(json);
}

/// Player in lineup with performance history
@freezed
abstract class LineupPlayer with _$LineupPlayer {
  const factory LineupPlayer({
    /// Player ID
    @JsonKey(name: 'i') required String id,

    /// Player name
    @JsonKey(name: 'n') required String name,

    /// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
    @JsonKey(name: 'pos') @Default(0) int position,

    /// Team ID
    @JsonKey(name: 'tid') @Default('') String teamId,

    /// Average points
    @JsonKey(name: 'ap') @Default(0) int averagePoints,

    /// Total points
    @JsonKey(name: 'st') @Default(0) int totalPoints,

    /// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
    @JsonKey(name: 'mdst') @Default(0) int matchDayStatus,

    /// Lineup order (0 means on bench/not in lineup)
    @JsonKey(name: 'lo') @Default(0) int lineupOrder,

    /// Last total points
    @JsonKey(name: 'lst') @Default(0) int lastTotalPoints,

    /// Has today (if player plays today)
    @JsonKey(name: 'ht') @Default(false) bool hasToday,

    /// Original status (e.g., injury/suspension info)
    @JsonKey(name: 'os') String? originalStatus,

    /// Performance history
    @JsonKey(name: 'ph') List<PerformanceHistory>? performanceHistory,
  }) = _LineupPlayer;

  factory LineupPlayer.fromJson(Map<String, dynamic> json) =>
      _$LineupPlayerFromJson(json);
}

/// Performance history entry
@freezed
abstract class PerformanceHistory with _$PerformanceHistory {
  const factory PerformanceHistory({
    /// Points
    @JsonKey(name: 'p') @Default(0) int points,

    /// Has played (if player played in this match)
    @JsonKey(name: 'hp') @Default(false) bool hasPlayed,
  }) = _PerformanceHistory;

  factory PerformanceHistory.fromJson(Map<String, dynamic> json) =>
      _$PerformanceHistoryFromJson(json);
}

/// Request body für POST /v4/leagues/{leagueId}/lineup
///
/// Kickbase erwartet JSON (`application/json`, sonst HTTP 415):
/// `{"type": "4-4-2", "players": ["<id>", ...]}` – `type` ist die Formation
/// (Abwehr-Mittelfeld-Sturm), `players` die 11 Startelf-IDs sortiert nach
/// Position (Torwart, Abwehr, Mittelfeld, Sturm).
@freezed
abstract class LineupUpdateRequest with _$LineupUpdateRequest {
  const factory LineupUpdateRequest({
    /// Formation, z. B. "4-4-2"
    @JsonKey(name: 'type') required String formation,

    /// Startelf-IDs in Positions-Reihenfolge (TW, ABW, MF, ST)
    @JsonKey(name: 'players') required List<String> playerIds,
  }) = _LineupUpdateRequest;

  factory LineupUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LineupUpdateRequestFromJson(json);
}
