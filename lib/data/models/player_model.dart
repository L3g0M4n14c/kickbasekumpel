import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

/// Player Model - Kickbase Spieler
@freezed
class Player with _$Player {
  const factory Player({
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
    required int tfhmvt,
    required int prlo,
    required int stl,
    required int status,
    required bool userOwnsPlayer,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

// TeamPlayer ist ein Alias für Player
typedef TeamPlayer = Player;

/// Player Detail Response
@freezed
class PlayerDetailResponse with _$PlayerDetailResponse {
  const factory PlayerDetailResponse({
    String? fn,
    String? ln,
    String? tn,
    int? shn,
    String? id,
    int? position,
    int? number,
    double? averagePoints,
    int? totalPoints,
    int? marketValue,
    int? marketValueTrend,
    String? profileBigUrl,
    String? teamId,
    int? tfhmvt,
    int? prlo,
    int? stl,
    int? status,
    bool? userOwnsPlayer,
  }) = _PlayerDetailResponse;

  factory PlayerDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerDetailResponseFromJson(json);
}

/// Players Response
@freezed
class PlayersResponse with _$PlayersResponse {
  const factory PlayersResponse({required List<Player> players}) =
      _PlayersResponse;

  factory PlayersResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayersResponseFromJson(json);
}
