// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_player_counts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamPlayerCounts _$TeamPlayerCountsFromJson(Map<String, dynamic> json) =>
    _TeamPlayerCounts(
      total: (json['total'] as num).toInt(),
      goalkeepers: (json['goalkeepers'] as num).toInt(),
      defenders: (json['defenders'] as num).toInt(),
      midfielders: (json['midfielders'] as num).toInt(),
      forwards: (json['forwards'] as num).toInt(),
    );

Map<String, dynamic> _$TeamPlayerCountsToJson(_TeamPlayerCounts instance) =>
    <String, dynamic>{
      'total': instance.total,
      'goalkeepers': instance.goalkeepers,
      'defenders': instance.defenders,
      'midfielders': instance.midfielders,
      'forwards': instance.forwards,
    };

_FixtureAnalysis _$FixtureAnalysisFromJson(Map<String, dynamic> json) =>
    _FixtureAnalysis(
      averageDifficulty: (json['averageDifficulty'] as num).toDouble(),
      topTeamOpponents: (json['topTeamOpponents'] as num).toInt(),
      difficultAwayGames: (json['difficultAwayGames'] as num).toInt(),
      totalMatches: (json['totalMatches'] as num).toInt(),
    );

Map<String, dynamic> _$FixtureAnalysisToJson(_FixtureAnalysis instance) =>
    <String, dynamic>{
      'averageDifficulty': instance.averageDifficulty,
      'topTeamOpponents': instance.topTeamOpponents,
      'difficultAwayGames': instance.difficultAwayGames,
      'totalMatches': instance.totalMatches,
    };
