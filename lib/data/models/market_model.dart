import 'package:freezed_annotation/freezed_annotation.dart';
import 'common_models.dart';

part 'market_model.freezed.dart';
part 'market_model.g.dart';

/// Market Player - Spieler auf dem Transfermarkt
@freezed
class MarketPlayer with _$MarketPlayer {
  const factory MarketPlayer({
    required String id,
    required String firstName,
    required String lastName,
    required String profileBigUrl,
    required String teamName,
    required String teamId,
    required int position,
    required int number,
    required double averagePoints,
    required int totalPoints,
    required int marketValue,
    required int marketValueTrend,
    required int price,
    required String expiry,
    required int offers,
    required MarketSeller seller,
    required int stl,
    required int status,
    int? prlo,
    PlayerOwner? owner,
    required int exs,
  }) = _MarketPlayer;

  factory MarketPlayer.fromJson(Map<String, dynamic> json) =>
      _$MarketPlayerFromJson(json);
}

/// Market Response
@freezed
class MarketResponse with _$MarketResponse {
  const factory MarketResponse({required List<MarketPlayer> players}) =
      _MarketResponse;

  factory MarketResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketResponseFromJson(json);
}
