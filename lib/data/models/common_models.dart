import 'package:freezed_annotation/freezed_annotation.dart';

part 'common_models.freezed.dart';
part 'common_models.g.dart';

/// Helper models and enums for Kickbase

// Player Position (1=TW, 2=ABW, 3=MF, 4=ST)
enum Position {
  @JsonValue(1)
  goalkeeper,
  @JsonValue(2)
  defender,
  @JsonValue(3)
  midfielder,
  @JsonValue(4)
  forward,
}

// Player Status (st field in MatchPerformance)
enum PlayerMatchStatus {
  @JsonValue(0)
  notPlayed,
  @JsonValue(1)
  injuredOrSuspended,
  @JsonValue(3)
  substitute,
  @JsonValue(4)
  notInSquad,
  @JsonValue(5)
  startingEleven,
}

// Market Seller Info
@freezed
class MarketSeller with _$MarketSeller {
  const factory MarketSeller({required String id, required String name}) =
      _MarketSeller;

  factory MarketSeller.fromJson(Map<String, dynamic> json) =>
      _$MarketSellerFromJson(json);
}

// Player Owner (für das "u" Feld in Marktspielern)
@freezed
class PlayerOwner with _$PlayerOwner {
  const factory PlayerOwner({
    required String i,
    required String n,
    String? uim,
    bool? isvf,
    int? st,
  }) = _PlayerOwner;

  factory PlayerOwner.fromJson(Map<String, dynamic> json) =>
      _$PlayerOwnerFromJson(json);
}

// Team Info (minimal - für Team-Profil)
@freezed
class TeamInfo with _$TeamInfo {
  const factory TeamInfo({
    required String tid,
    required String tn,
    required int pl,
  }) = _TeamInfo;

  factory TeamInfo.fromJson(Map<String, dynamic> json) =>
      _$TeamInfoFromJson(json);
}

// Team Stats
@freezed
class TeamStats with _$TeamStats {
  const factory TeamStats({
    required int teamValue,
    required int teamValueTrend,
    required int budget,
    required int points,
    required int placement,
    required int won,
    required int drawn,
    required int lost,
  }) = _TeamStats;

  factory TeamStats.fromJson(Map<String, dynamic> json) =>
      _$TeamStatsFromJson(json);
}

// User Stats (gleich wie TeamStats)
@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required int teamValue,
    required int teamValueTrend,
    required int budget,
    required int points,
    required int placement,
    required int won,
    required int drawn,
    required int lost,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}

// Team Profile Response
@freezed
class TeamProfileResponse with _$TeamProfileResponse {
  const factory TeamProfileResponse({
    required String tid,
    required String tn,
    required int pl,
    required int tv,
    required int tw,
    required int td,
    required int tl,
    required int npt,
    required bool avpcl,
  }) = _TeamProfileResponse;

  factory TeamProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamProfileResponseFromJson(json);
}
