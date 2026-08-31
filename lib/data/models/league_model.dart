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
    required LeagueUser cu,
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
    // Kickbase-Feld `dt`: Datum des Ligastarts
    @JsonKey(name: 'dt', fromJson: _seasonStartDateFromJson, toJson: _seasonStartDateToJson)
    String? seasonStartDate,
  }) = _League;

  factory League.fromJson(Map<String, dynamic> json) =>
      _$LeagueFromJson(_ensureLeagueHasCu(json));
}

String? _seasonStartDateFromJson(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  // Zahl (int/double) -> zu String konvertieren, damit _asDateTime in den Providern
  // sowohl ISO-Strings als auch numerische Timestamps korrekt parsen kann.
  // Wir geben die Rohzahl als String zurück; die Provider-Logik (_asDateTime)
  // behandelt numerische Strings via int.tryParse nicht, daher wandeln wir
  // hier direkt in ein ISO-8601 um, wenn es eindeutig ein Timestamp ist.
  if (value is num) {
    // Heuristik: < 100000 -> Tage seit 1970 (altes MarketValue-Format)
    // < 100000000000 -> Sekunden -> Millisekunden
    // sonst Millisekunden
    int ms;
    if (value.abs() < 100000) {
      ms = value.toInt() * Duration.millisecondsPerDay;
    } else if (value.abs() < 100000000000) {
      ms = value.toInt() * 1000;
    } else {
      ms = value.toInt();
    }
    try {
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true)
          .toIso8601String();
    } catch (_) {
      return value.toString();
    }
  }
  return value.toString();
}

String? _seasonStartDateToJson(String? value) => value;

Map<String, dynamic> _ensureLeagueHasCu(Map<String, dynamic> json) {
  if (json['cu'] == null) {
    // Create a default LeagueUser representation
    final defaultCu = {
      'id': '',
      'name': '',
      'teamName': '',
      'budget': 0,
      'teamValue': 0,
      'points': 0,
      'placement': 0,
      'won': 0,
      'drawn': 0,
      'lost': 0,
      'se11': 0,
      'ttm': 0,
      'lp': <String>[],
    };
    final copy = Map<String, dynamic>.from(json);
    copy['cu'] = defaultCu;
    return copy;
  }
  return json;
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
