// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketSeller _$MarketSellerFromJson(Map<String, dynamic> json) =>
    _MarketSeller(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$MarketSellerToJson(_MarketSeller instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_PlayerOwner _$PlayerOwnerFromJson(Map<String, dynamic> json) => _PlayerOwner(
  i: json['i'] as String,
  n: json['n'] as String,
  uim: json['uim'] as String?,
  isvf: json['isvf'] as bool?,
  st: (json['st'] as num?)?.toInt(),
);

Map<String, dynamic> _$PlayerOwnerToJson(_PlayerOwner instance) =>
    <String, dynamic>{
      'i': instance.i,
      'n': instance.n,
      'uim': instance.uim,
      'isvf': instance.isvf,
      'st': instance.st,
    };

_TeamInfo _$TeamInfoFromJson(Map<String, dynamic> json) => _TeamInfo(
  tid: json['tid'] as String,
  tn: json['tn'] as String,
  pl: (json['pl'] as num).toInt(),
);

Map<String, dynamic> _$TeamInfoToJson(_TeamInfo instance) => <String, dynamic>{
  'tid': instance.tid,
  'tn': instance.tn,
  'pl': instance.pl,
};

_TeamStats _$TeamStatsFromJson(Map<String, dynamic> json) => _TeamStats(
  teamValue: (json['teamValue'] as num).toInt(),
  teamValueTrend: (json['teamValueTrend'] as num).toInt(),
  budget: (json['budget'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  placement: (json['placement'] as num).toInt(),
  won: (json['won'] as num).toInt(),
  drawn: (json['drawn'] as num).toInt(),
  lost: (json['lost'] as num).toInt(),
);

Map<String, dynamic> _$TeamStatsToJson(_TeamStats instance) =>
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

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  teamValue: (json['teamValue'] as num).toInt(),
  teamValueTrend: (json['teamValueTrend'] as num).toInt(),
  budget: (json['budget'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  placement: (json['placement'] as num).toInt(),
  won: (json['won'] as num).toInt(),
  drawn: (json['drawn'] as num).toInt(),
  lost: (json['lost'] as num).toInt(),
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
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

_TeamProfileResponse _$TeamProfileResponseFromJson(Map<String, dynamic> json) =>
    _TeamProfileResponse(
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

Map<String, dynamic> _$TeamProfileResponseToJson(
  _TeamProfileResponse instance,
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
