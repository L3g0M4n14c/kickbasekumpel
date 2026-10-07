// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transfer _$TransferFromJson(Map<String, dynamic> json) => _Transfer(
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

Map<String, dynamic> _$TransferToJson(_Transfer instance) => <String, dynamic>{
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

_ManagerTransferHistoryEntry _$ManagerTransferHistoryEntryFromJson(
  Map<String, dynamic> json,
) => _ManagerTransferHistoryEntry(
  id: json['id'] as String,
  leagueId: json['leagueId'] as String,
  managerId: json['managerId'] as String,
  managerName: json['managerName'] as String,
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  price: (json['price'] as num).toInt(),
  transferType: (json['transferType'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  marketValueAtTransfer: (json['marketValueAtTransfer'] as num?)?.toInt(),
);

Map<String, dynamic> _$ManagerTransferHistoryEntryToJson(
  _ManagerTransferHistoryEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'leagueId': instance.leagueId,
  'managerId': instance.managerId,
  'managerName': instance.managerName,
  'playerId': instance.playerId,
  'playerName': instance.playerName,
  'price': instance.price,
  'transferType': instance.transferType,
  'timestamp': instance.timestamp.toIso8601String(),
  'marketValueAtTransfer': instance.marketValueAtTransfer,
};

_Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    _Recommendation(
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
      swapCandidateId: json['swapCandidateId'] as String?,
      swapCandidateName: json['swapCandidateName'] as String?,
      userOwnsPlayer: json['userOwnsPlayer'] as bool? ?? false,
    );

Map<String, dynamic> _$RecommendationToJson(_Recommendation instance) =>
    <String, dynamic>{
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
      'swapCandidateId': instance.swapCandidateId,
      'swapCandidateName': instance.swapCandidateName,
      'userOwnsPlayer': instance.userOwnsPlayer,
    };

_BidResponse _$BidResponseFromJson(Map<String, dynamic> json) => _BidResponse(
  id: json['id'] as String,
  transferId: json['transferId'] as String,
  bidderId: json['bidderId'] as String,
  bidAmount: (json['bidAmount'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: json['status'] as String,
);

Map<String, dynamic> _$BidResponseToJson(_BidResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transferId': instance.transferId,
      'bidderId': instance.bidderId,
      'bidAmount': instance.bidAmount,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };

_TransferRequest _$TransferRequestFromJson(Map<String, dynamic> json) =>
    _TransferRequest(
      playerId: json['playerId'] as String,
      toUserId: json['toUserId'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$TransferRequestToJson(_TransferRequest instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'toUserId': instance.toUserId,
      'price': instance.price,
    };

_TransfersResponse _$TransfersResponseFromJson(Map<String, dynamic> json) =>
    _TransfersResponse(
      transfers: (json['transfers'] as List<dynamic>)
          .map((e) => Transfer.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransfersResponseToJson(_TransfersResponse instance) =>
    <String, dynamic>{
      'transfers': instance.transfers,
      'total_count': instance.totalCount,
    };
