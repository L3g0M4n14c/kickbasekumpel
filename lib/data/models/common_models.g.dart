// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketSellerImpl _$$MarketSellerImplFromJson(Map<String, dynamic> json) =>
    _$MarketSellerImpl(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$$MarketSellerImplToJson(_$MarketSellerImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$PlayerOwnerImpl _$$PlayerOwnerImplFromJson(Map<String, dynamic> json) =>
    _$PlayerOwnerImpl(
      i: json['i'] as String,
      n: json['n'] as String,
      uim: json['uim'] as String?,
      isvf: json['isvf'] as bool?,
      st: (json['st'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PlayerOwnerImplToJson(_$PlayerOwnerImpl instance) =>
    <String, dynamic>{
      'i': instance.i,
      'n': instance.n,
      'uim': instance.uim,
      'isvf': instance.isvf,
      'st': instance.st,
    };

_$TeamInfoImpl _$$TeamInfoImplFromJson(Map<String, dynamic> json) =>
    _$TeamInfoImpl(
      tid: json['tid'] as String,
      tn: json['tn'] as String,
      pl: (json['pl'] as num).toInt(),
    );

Map<String, dynamic> _$$TeamInfoImplToJson(_$TeamInfoImpl instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'tn': instance.tn,
      'pl': instance.pl,
    };

_$TeamStatsImpl _$$TeamStatsImplFromJson(Map<String, dynamic> json) =>
    _$TeamStatsImpl(
      teamValue: (json['teamValue'] as num).toInt(),
      teamValueTrend: (json['teamValueTrend'] as num).toInt(),
      budget: (json['budget'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      placement: (json['placement'] as num).toInt(),
      won: (json['won'] as num).toInt(),
      drawn: (json['drawn'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
    );

Map<String, dynamic> _$$TeamStatsImplToJson(_$TeamStatsImpl instance) =>
    <String, dynamic>{
      'teamValue': instance.teamValue,
      'teamValueTrend': instance.teamValueTrend,
      'budget': instance.budget,
      'points': instance.points,
      'placement': instance.placement,
      'won': instance.won,
      'drawn': instance.drawn,
      'lost': instance.lost,
    };

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      teamValue: (json['teamValue'] as num).toInt(),
      teamValueTrend: (json['teamValueTrend'] as num).toInt(),
      budget: (json['budget'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      placement: (json['placement'] as num).toInt(),
      won: (json['won'] as num).toInt(),
      drawn: (json['drawn'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'teamValue': instance.teamValue,
      'teamValueTrend': instance.teamValueTrend,
      'budget': instance.budget,
      'points': instance.points,
      'placement': instance.placement,
      'won': instance.won,
      'drawn': instance.drawn,
      'lost': instance.lost,
    };

_$TeamProfileResponseImpl _$$TeamProfileResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TeamProfileResponseImpl(
  tid: json['tid'] as String,
  tn: json['tn'] as String,
  pl: (json['pl'] as num).toInt(),
  tv: (json['tv'] as num).toInt(),
  tw: (json['tw'] as num).toInt(),
  td: (json['td'] as num).toInt(),
  tl: (json['tl'] as num).toInt(),
  npt: (json['npt'] as num).toInt(),
  avpcl: json['avpcl'] as bool,
);

Map<String, dynamic> _$$TeamProfileResponseImplToJson(
  _$TeamProfileResponseImpl instance,
) => <String, dynamic>{
  'tid': instance.tid,
  'tn': instance.tn,
  'pl': instance.pl,
  'tv': instance.tv,
  'tw': instance.tw,
  'td': instance.td,
  'tl': instance.tl,
  'npt': instance.npt,
  'avpcl': instance.avpcl,
};
