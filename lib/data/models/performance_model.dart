import 'package:freezed_annotation/freezed_annotation.dart';

part 'performance_model.freezed.dart';
part 'performance_model.g.dart';

/// Player Performance Response
@freezed
class PlayerPerformanceResponse with _$PlayerPerformanceResponse {
  const factory PlayerPerformanceResponse({
    required List<SeasonPerformance> it,
  }) = _PlayerPerformanceResponse;

  factory PlayerPerformanceResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerPerformanceResponseFromJson(json);
}

/// Season Performance
@freezed
class SeasonPerformance with _$SeasonPerformance {
  const factory SeasonPerformance({
    required String ti,
    required String n,
    required List<MatchPerformance> ph,
  }) = _SeasonPerformance;

  factory SeasonPerformance.fromJson(Map<String, dynamic> json) =>
      _$SeasonPerformanceFromJson(json);
}

/// Match Performance
@freezed
class MatchPerformance with _$MatchPerformance {
  const factory MatchPerformance({
    required int day,
    int? p,
    String? mp,
    required String md,
    required String t1,
    required String t2,
    int? t1g,
    int? t2g,
    String? pt,
    List<int>? k,
    required int st,
    required bool cur,
    required int mdst,
    int? ap,
    int? tp,
    int? asp,
  }) = _MatchPerformance;

  factory MatchPerformance.fromJson(Map<String, dynamic> json) =>
      _$MatchPerformanceFromJson(json);
}

/// Enhanced Match Performance (mit Team-Informationen)
@freezed
class EnhancedMatchPerformance with _$EnhancedMatchPerformance {
  const factory EnhancedMatchPerformance({
    required MatchPerformance basePerformance,
    String? team1Name,
    String? team2Name,
    String? playerTeamName,
    String? opponentTeamName,
    int? team1Placement,
    int? team2Placement,
    int? playerTeamPlacement,
    int? opponentTeamPlacement,
  }) = _EnhancedMatchPerformance;

  factory EnhancedMatchPerformance.fromJson(Map<String, dynamic> json) =>
      _$EnhancedMatchPerformanceFromJson(json);
}
