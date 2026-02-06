import 'package:freezed_annotation/freezed_annotation.dart';

part 'league_model.freezed.dart';
part 'league_model.g.dart';

/// League Model - Kickbase Liga
@freezed
class League with _$League {
  const factory League({
    required String i,
    @Default('1') String cpi,
    required String n,
    required String cn,
    required String an,
    required String c,
    required String s,
    required int md,
    required LeagueUser cu,
  }) = _League;

  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);
}

/// League User - Extended User in League Context
@freezed
class LeagueUser with _$LeagueUser {
  const factory LeagueUser({
    required String id,
    required String name,
    required String teamName,
    required int budget,
    required int teamValue,
    required int points,
    required int placement,
    required int won,
    required int drawn,
    required int lost,
    required int se11,
    required int ttm,
    int? mpst,
    @Default([]) List<String> lp,
  }) = _LeagueUser;

  factory LeagueUser.fromJson(Map<String, dynamic> json) =>
      _$LeagueUserFromJson(json);
}

/// Leagues Response
@freezed
class LeaguesResponse with _$LeaguesResponse {
  const factory LeaguesResponse({required List<League> leagues}) =
      _LeaguesResponse;

  factory LeaguesResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaguesResponseFromJson(json);
}
