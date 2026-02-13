import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_player_counts_model.freezed.dart';
part 'team_player_counts_model.g.dart';

/// Team Spieler-Zählungen nach Position
@freezed
class TeamPlayerCounts with _$TeamPlayerCounts {
  const factory TeamPlayerCounts({
    required int total,
    required int goalkeepers,
    required int defenders,
    required int midfielders,
    required int forwards,
  }) = _TeamPlayerCounts;

  factory TeamPlayerCounts.fromJson(Map<String, dynamic> json) =>
      _$TeamPlayerCountsFromJson(json);
}

/// Fixture-Analyse für kommende Spiele
@freezed
class FixtureAnalysis with _$FixtureAnalysis {
  const factory FixtureAnalysis({
    required double averageDifficulty,
    required int topTeamOpponents,
    required int difficultAwayGames,
    required int totalMatches,
  }) = _FixtureAnalysis;

  factory FixtureAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FixtureAnalysisFromJson(json);
}
