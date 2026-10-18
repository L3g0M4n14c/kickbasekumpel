// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_bonus_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BonusCollection _$BonusCollectionFromJson(Map<String, dynamic> json) =>
    _BonusCollection(
      leagueId: json['li'] as String? ?? '',
      leagueName: json['lnm'] as String? ?? '',
      value: (json['v'] as num?)?.toInt() ?? 0,
      day: (json['day'] as num?)?.toInt() ?? 1,
      budget: (json['b'] as num?)?.toInt() ?? 0,
      leagueImage: json['lim'] as String? ?? '',
    );

Map<String, dynamic> _$BonusCollectionToJson(_BonusCollection instance) =>
    <String, dynamic>{
      'li': instance.leagueId,
      'lnm': instance.leagueName,
      'v': instance.value,
      'day': instance.day,
      'b': instance.budget,
      'lim': instance.leagueImage,
    };

_BonusCollectResult _$BonusCollectResultFromJson(Map<String, dynamic> json) =>
    _BonusCollectResult(
      collections:
          (json['it'] as List<dynamic>?)
              ?.map((e) => BonusCollection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BonusCollectResultToJson(_BonusCollectResult instance) =>
    <String, dynamic>{'it': instance.collections};
