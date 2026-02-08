// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligainsider_match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineupPlayerImpl _$$LineupPlayerImplFromJson(Map<String, dynamic> json) =>
    _$LineupPlayerImpl(
      name: json['name'] as String,
      ligainsiderId: json['ligainsiderId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      alternative: json['alternative'] as String?,
    );

Map<String, dynamic> _$$LineupPlayerImplToJson(_$LineupPlayerImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'ligainsiderId': instance.ligainsiderId,
      'imageUrl': instance.imageUrl,
      'alternative': instance.alternative,
    };

_$LineupRowImpl _$$LineupRowImplFromJson(Map<String, dynamic> json) =>
    _$LineupRowImpl(
      rowName: json['rowName'] as String,
      players: (json['players'] as List<dynamic>)
          .map((e) => LineupPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LineupRowImplToJson(_$LineupRowImpl instance) =>
    <String, dynamic>{'rowName': instance.rowName, 'players': instance.players};

_$LigainsiderMatchImpl _$$LigainsiderMatchImplFromJson(
  Map<String, dynamic> json,
) => _$LigainsiderMatchImpl(
  id: json['id'] as String,
  homeTeam: json['homeTeam'] as String,
  awayTeam: json['awayTeam'] as String,
  homeLogo: json['homeLogo'] as String?,
  awayLogo: json['awayLogo'] as String?,
  homeLineup: (json['homeLineup'] as List<dynamic>)
      .map((e) => LineupRow.fromJson(e as Map<String, dynamic>))
      .toList(),
  awayLineup: (json['awayLineup'] as List<dynamic>)
      .map((e) => LineupRow.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$LigainsiderMatchImplToJson(
  _$LigainsiderMatchImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'homeTeam': instance.homeTeam,
  'awayTeam': instance.awayTeam,
  'homeLogo': instance.homeLogo,
  'awayLogo': instance.awayLogo,
  'homeLineup': instance.homeLineup,
  'awayLineup': instance.awayLineup,
};
