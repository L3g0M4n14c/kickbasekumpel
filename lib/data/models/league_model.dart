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
    String? cn,
    String? an,
    String? c,
    String? s,
    int? md,
    LeagueUser? cu,
    // Additional fields from /v4/leagues/selection response
    int? b, // budget
    int? tv, // team value
    int? pl, // placement
    int? un, // ?
    String? f, // image/flag
    int? lpc, // ?
    int? bs, // ?
    int? vr, // ?
    bool? adm, // admin
    bool? idf, // ?
    String? lim, // league image
    String? cpim, // competition image
    int? gpm, // ?
    int? rnkm, // ?
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
