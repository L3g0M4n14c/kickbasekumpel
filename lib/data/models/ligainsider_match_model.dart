import 'package:freezed_annotation/freezed_annotation.dart';

part 'ligainsider_match_model.freezed.dart';
part 'ligainsider_match_model.g.dart';

/// Represents a lineup player in a match
@freezed
class LineupPlayer with _$LineupPlayer {
  const factory LineupPlayer({
    required String name,
    String? ligainsiderId,
    String? imageUrl,
    String? alternative,
  }) = _LineupPlayer;

  factory LineupPlayer.fromJson(Map<String, dynamic> json) =>
      _$LineupPlayerFromJson(json);
}

/// Row of players (e.g., GK, Defense, Mid, Attack)
@freezed
class LineupRow with _$LineupRow {
  const factory LineupRow({
    required String rowName,
    required List<LineupPlayer> players,
  }) = _LineupRow;

  factory LineupRow.fromJson(Map<String, dynamic> json) =>
      _$LineupRowFromJson(json);
}

/// Match with lineups for home and away
@freezed
class LigainsiderMatch with _$LigainsiderMatch {
  const factory LigainsiderMatch({
    required String id,
    required String homeTeam,
    required String awayTeam,
    String? homeLogo,
    String? awayLogo,
    required List<LineupRow> homeLineup,
    required List<LineupRow> awayLineup,
  }) = _LigainsiderMatch;

  factory LigainsiderMatch.fromJson(Map<String, dynamic> json) =>
      _$LigainsiderMatchFromJson(json);
}
