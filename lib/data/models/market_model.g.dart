// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketPlayerImpl _$$MarketPlayerImplFromJson(Map<String, dynamic> json) =>
    _$MarketPlayerImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileBigUrl: json['profileBigUrl'] as String,
      teamName: json['teamName'] as String,
      teamId: json['teamId'] as String,
      position: (json['position'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      averagePoints: (json['averagePoints'] as num).toDouble(),
      totalPoints: (json['totalPoints'] as num).toInt(),
      marketValue: (json['marketValue'] as num).toInt(),
      marketValueTrend: (json['marketValueTrend'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      expiry: json['expiry'] as String,
      offers: (json['offers'] as num).toInt(),
      seller: MarketSeller.fromJson(json['seller'] as Map<String, dynamic>),
      stl: (json['stl'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      prlo: (json['prlo'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : PlayerOwner.fromJson(json['owner'] as Map<String, dynamic>),
      exs: (json['exs'] as num).toInt(),
    );

Map<String, dynamic> _$$MarketPlayerImplToJson(_$MarketPlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profileBigUrl': instance.profileBigUrl,
      'teamName': instance.teamName,
      'teamId': instance.teamId,
      'position': instance.position,
      'number': instance.number,
      'averagePoints': instance.averagePoints,
      'totalPoints': instance.totalPoints,
      'marketValue': instance.marketValue,
      'marketValueTrend': instance.marketValueTrend,
      'price': instance.price,
      'expiry': instance.expiry,
      'offers': instance.offers,
      'seller': instance.seller,
      'stl': instance.stl,
      'status': instance.status,
      'prlo': instance.prlo,
      'owner': instance.owner,
      'exs': instance.exs,
    };

_$MarketResponseImpl _$$MarketResponseImplFromJson(Map<String, dynamic> json) =>
    _$MarketResponseImpl(
      players: (json['players'] as List<dynamic>)
          .map((e) => MarketPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MarketResponseImplToJson(
  _$MarketResponseImpl instance,
) => <String, dynamic>{'players': instance.players};
