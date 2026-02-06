// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeagueImpl _$$LeagueImplFromJson(Map<String, dynamic> json) => _$LeagueImpl(
  i: json['i'] as String,
  cpi: json['cpi'] as String? ?? '1',
  n: json['n'] as String,
  cn: json['cn'] as String,
  an: json['an'] as String,
  c: json['c'] as String,
  s: json['s'] as String,
  md: (json['md'] as num).toInt(),
  cu: LeagueUser.fromJson(json['cu'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$LeagueImplToJson(_$LeagueImpl instance) =>
    <String, dynamic>{
      'i': instance.i,
      'cpi': instance.cpi,
      'n': instance.n,
      'cn': instance.cn,
      'an': instance.an,
      'c': instance.c,
      's': instance.s,
      'md': instance.md,
      'cu': instance.cu,
    };

_$LeagueUserImpl _$$LeagueUserImplFromJson(Map<String, dynamic> json) =>
    _$LeagueUserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      teamName: json['teamName'] as String,
      budget: (json['budget'] as num).toInt(),
      teamValue: (json['teamValue'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      placement: (json['placement'] as num).toInt(),
      won: (json['won'] as num).toInt(),
      drawn: (json['drawn'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
      se11: (json['se11'] as num).toInt(),
      ttm: (json['ttm'] as num).toInt(),
      mpst: (json['mpst'] as num?)?.toInt(),
      lp:
          (json['lp'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$$LeagueUserImplToJson(_$LeagueUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'teamName': instance.teamName,
      'budget': instance.budget,
      'teamValue': instance.teamValue,
      'points': instance.points,
      'placement': instance.placement,
      'won': instance.won,
      'drawn': instance.drawn,
      'lost': instance.lost,
      'se11': instance.se11,
      'ttm': instance.ttm,
      'mpst': instance.mpst,
      'lp': instance.lp,
    };

_$LeaguesResponseImpl _$$LeaguesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$LeaguesResponseImpl(
  leagues: (json['leagues'] as List<dynamic>)
      .map((e) => League.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$LeaguesResponseImplToJson(
  _$LeaguesResponseImpl instance,
) => <String, dynamic>{'leagues': instance.leagues};
