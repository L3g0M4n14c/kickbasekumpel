// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_player_counts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamPlayerCountsImpl _$$TeamPlayerCountsImplFromJson(
  Map<String, dynamic> json,
) => _$TeamPlayerCountsImpl(
  total: (json['total'] as num).toInt(),
  goalkeepers: (json['goalkeepers'] as num).toInt(),
  defenders: (json['defenders'] as num).toInt(),
  midfielders: (json['midfielders'] as num).toInt(),
  forwards: (json['forwards'] as num).toInt(),
);

Map<String, dynamic> _$$TeamPlayerCountsImplToJson(
  _$TeamPlayerCountsImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'goalkeepers': instance.goalkeepers,
  'defenders': instance.defenders,
  'midfielders': instance.midfielders,
  'forwards': instance.forwards,
};

_$FixtureAnalysisImpl _$$FixtureAnalysisImplFromJson(
  Map<String, dynamic> json,
) => _$FixtureAnalysisImpl(
  averageDifficulty: (json['averageDifficulty'] as num).toDouble(),
  topTeamOpponents: (json['topTeamOpponents'] as num).toInt(),
  difficultAwayGames: (json['difficultAwayGames'] as num).toInt(),
  totalMatches: (json['totalMatches'] as num).toInt(),
);

Map<String, dynamic> _$$FixtureAnalysisImplToJson(
  _$FixtureAnalysisImpl instance,
) => <String, dynamic>{
  'averageDifficulty': instance.averageDifficulty,
  'topTeamOpponents': instance.topTeamOpponents,
  'difficultAwayGames': instance.difficultAwayGames,
  'totalMatches': instance.totalMatches,
};
