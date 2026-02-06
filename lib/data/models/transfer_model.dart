import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_model.freezed.dart';
part 'transfer_model.g.dart';

/// Transfer Model - Spielertransfer zwischen Teams
@freezed
class Transfer with _$Transfer {
  const factory Transfer({
    required String id,
    required String leagueId,
    required String fromUserId,
    required String toUserId,
    required String playerId,
    required int price,
    required int marketValue,
    required String playerName,
    required String fromUsername,
    required String toUsername,
    required DateTime timestamp,
    required String status,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}

/// Recommendation Model - Transfer Empfehlung
@freezed
class Recommendation with _$Recommendation {
  const factory Recommendation({
    required String id,
    required String leagueId,
    required String playerId,
    required String playerName,
    required double score,
    required String reason,
    required String action,
    int? suggestedPrice,
    required int currentMarketValue,
    required int estimatedValue,
    required double confidence,
    required DateTime timestamp,
    required String category,
  }) = _Recommendation;

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);
}

/// Bid Response - Gebot/Angebot Response
@freezed
class BidResponse with _$BidResponse {
  const factory BidResponse({
    required String id,
    required String transferId,
    required String bidderId,
    required int bidAmount,
    required DateTime createdAt,
    required String status,
  }) = _BidResponse;

  factory BidResponse.fromJson(Map<String, dynamic> json) =>
      _$BidResponseFromJson(json);
}

/// Transfer Request - Für neue Transfer erstellen
@freezed
class TransferRequest with _$TransferRequest {
  const factory TransferRequest({
    required String playerId,
    required String toUserId,
    required int price,
  }) = _TransferRequest;

  factory TransferRequest.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestFromJson(json);
}

/// Transfers Response - Liste von Transfers
@freezed
class TransfersResponse with _$TransfersResponse {
  const factory TransfersResponse({
    required List<Transfer> transfers,
    int? total_count,
  }) = _TransfersResponse;

  factory TransfersResponse.fromJson(Map<String, dynamic> json) =>
      _$TransfersResponseFromJson(json);
}
