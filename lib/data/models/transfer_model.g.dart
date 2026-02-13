// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferImpl _$$TransferImplFromJson(Map<String, dynamic> json) =>
    _$TransferImpl(
      id: json['id'] as String,
      leagueId: json['leagueId'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      playerId: json['playerId'] as String,
      price: (json['price'] as num).toInt(),
      marketValue: (json['marketValue'] as num).toInt(),
      playerName: json['playerName'] as String,
      fromUsername: json['fromUsername'] as String,
      toUsername: json['toUsername'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$TransferImplToJson(_$TransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leagueId': instance.leagueId,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'playerId': instance.playerId,
      'price': instance.price,
      'marketValue': instance.marketValue,
      'playerName': instance.playerName,
      'fromUsername': instance.fromUsername,
      'toUsername': instance.toUsername,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': instance.status,
    };

_$RecommendationImpl _$$RecommendationImplFromJson(Map<String, dynamic> json) =>
    _$RecommendationImpl(
      id: json['id'] as String,
      leagueId: json['leagueId'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      score: (json['score'] as num).toDouble(),
      reason: json['reason'] as String,
      action: json['action'] as String,
      suggestedPrice: (json['suggestedPrice'] as num?)?.toInt(),
      currentMarketValue: (json['currentMarketValue'] as num).toInt(),
      estimatedValue: (json['estimatedValue'] as num).toInt(),
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String,
    );

Map<String, dynamic> _$$RecommendationImplToJson(
  _$RecommendationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'leagueId': instance.leagueId,
  'playerId': instance.playerId,
  'playerName': instance.playerName,
  'score': instance.score,
  'reason': instance.reason,
  'action': instance.action,
  'suggestedPrice': instance.suggestedPrice,
  'currentMarketValue': instance.currentMarketValue,
  'estimatedValue': instance.estimatedValue,
  'confidence': instance.confidence,
  'timestamp': instance.timestamp.toIso8601String(),
  'category': instance.category,
};

_$BidResponseImpl _$$BidResponseImplFromJson(Map<String, dynamic> json) =>
    _$BidResponseImpl(
      id: json['id'] as String,
      transferId: json['transferId'] as String,
      bidderId: json['bidderId'] as String,
      bidAmount: (json['bidAmount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$BidResponseImplToJson(_$BidResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transferId': instance.transferId,
      'bidderId': instance.bidderId,
      'bidAmount': instance.bidAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };

_$TransferRequestImpl _$$TransferRequestImplFromJson(
  Map<String, dynamic> json,
) => _$TransferRequestImpl(
  playerId: json['playerId'] as String,
  toUserId: json['toUserId'] as String,
  price: (json['price'] as num).toInt(),
);

Map<String, dynamic> _$$TransferRequestImplToJson(
  _$TransferRequestImpl instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'toUserId': instance.toUserId,
  'price': instance.price,
};

_$TransfersResponseImpl _$$TransfersResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TransfersResponseImpl(
  transfers: (json['transfers'] as List<dynamic>)
      .map((e) => Transfer.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['total_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TransfersResponseImplToJson(
  _$TransfersResponseImpl instance,
) => <String, dynamic>{
  'transfers': instance.transfers,
  'total_count': instance.totalCount,
};
