import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup_model.freezed.dart';
part 'lineup_model.g.dart';

/// Response from GET /v4/leagues/{leagueId}/lineup
@freezed
class LineupResponse with _$LineupResponse {
  const factory LineupResponse({
    @JsonKey(name: 'it') required List<LineupPlayer> players,
  }) = _LineupResponse;

  factory LineupResponse.fromJson(Map<String, dynamic> json) =>
      _$LineupResponseFromJson(json);
}

/// Player in lineup with performance history
@freezed
class LineupPlayer with _$LineupPlayer {
  const factory LineupPlayer({
    /// Player ID
    @JsonKey(name: 'i') required String id,

    /// Player name
    @JsonKey(name: 'n') required String name,

    /// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
    @JsonKey(name: 'pos') required int position,

    /// Team ID
    @JsonKey(name: 'tid') required String teamId,

    /// Average points
    @JsonKey(name: 'ap') required int averagePoints,

    /// Total points
    @JsonKey(name: 'st') required int totalPoints,

    /// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
    @JsonKey(name: 'mdst') required int matchDayStatus,

    /// Lineup order (0 means on bench/not in lineup)
    @JsonKey(name: 'lo') required int lineupOrder,

    /// Last total points
    @JsonKey(name: 'lst') required int lastTotalPoints,

    /// Has today (if player plays today)
    @JsonKey(name: 'ht') required bool hasToday,

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
class PerformanceHistory with _$PerformanceHistory {
  const factory PerformanceHistory({
    /// Points
    @JsonKey(name: 'p') required int points,

    /// Has played (if player played in this match)
    @JsonKey(name: 'hp') required bool hasPlayed,
  }) = _PerformanceHistory;

  factory PerformanceHistory.fromJson(Map<String, dynamic> json) =>
      _$PerformanceHistoryFromJson(json);
}

/// Request body for POST /v4/leagues/{leagueId}/lineup
/// Contains list of player IDs in the desired lineup order
@freezed
class LineupUpdateRequest with _$LineupUpdateRequest {
  const factory LineupUpdateRequest({
    /// List of player IDs in lineup order (first 11 are starters, rest are bench)
    required List<String> playerIds,
  }) = _LineupUpdateRequest;

  factory LineupUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LineupUpdateRequestFromJson(json);
}

/// Extension method for LineupUpdateRequest
extension LineupUpdateRequestExtension on LineupUpdateRequest {
  /// Convert to JSON string for API request body
  /// API expects just an array of player IDs as text/plain
  String toRequestBody() {
    return playerIds.join(',');
  }
}
