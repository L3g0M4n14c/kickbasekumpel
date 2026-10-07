// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligainsider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LigainsiderPlayer _$LigainsiderPlayerFromJson(Map<String, dynamic> json) =>
    _LigainsiderPlayer(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['short_name'] as String,
      teamName: json['team_name'] as String,
      teamId: json['team_id'] as String,
      position: (json['position'] as num).toInt(),
      injuryStatus: json['injury_status'] as String,
      injuryDescription: json['injury_description'] as String?,
      formRating: (json['form_rating'] as num?)?.toInt(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
      statusText: json['status_text'] as String?,
      expectedReturn: json['expected_return'] == null
          ? null
          : DateTime.parse(json['expected_return'] as String),
      alternative: json['alternative'] as String?,
      ligainsiderId: json['ligainsider_id'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$LigainsiderPlayerToJson(_LigainsiderPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'short_name': instance.shortName,
      'team_name': instance.teamName,
      'team_id': instance.teamId,
      'position': instance.position,
      'injury_status': instance.injuryStatus,
      'injury_description': instance.injuryDescription,
      'form_rating': instance.formRating,
      'last_update': instance.lastUpdate.toIso8601String(),
      'status_text': instance.statusText,
      'expected_return': instance.expectedReturn?.toIso8601String(),
      'alternative': instance.alternative,
      'ligainsider_id': instance.ligainsiderId,
      'image_url': instance.imageUrl,
    };

_LigainsiderStatus _$LigainsiderStatusFromJson(Map<String, dynamic> json) =>
    _LigainsiderStatus(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      statusCategory: json['statusCategory'] as String,
      statusReason: json['statusReason'] as String,
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$LigainsiderStatusToJson(_LigainsiderStatus instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'statusCategory': instance.statusCategory,
      'statusReason': instance.statusReason,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };

_LigainsiderResponse _$LigainsiderResponseFromJson(Map<String, dynamic> json) =>
    _LigainsiderResponse(
      players: (json['players'] as List<dynamic>)
          .map((e) => LigainsiderPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdate: DateTime.parse(json['last_update'] as String),
      totalInjured: (json['total_injured'] as num?)?.toInt(),
      totalQuestionable: (json['total_questionable'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LigainsiderResponseToJson(
  _LigainsiderResponse instance,
) => <String, dynamic>{
  'players': instance.players,
  'last_update': instance.lastUpdate.toIso8601String(),
  'total_injured': instance.totalInjured,
  'total_questionable': instance.totalQuestionable,
};

_InjuryReport _$InjuryReportFromJson(Map<String, dynamic> json) =>
    _InjuryReport(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      injuryType: json['injuryType'] as String,
      severity: json['severity'] as String,
      injuryDate: DateTime.parse(json['injuryDate'] as String),
      expectedReturnDate: json['expectedReturnDate'] == null
          ? null
          : DateTime.parse(json['expectedReturnDate'] as String),
      source: json['source'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$InjuryReportToJson(_InjuryReport instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'injuryType': instance.injuryType,
      'severity': instance.severity,
      'injuryDate': instance.injuryDate.toIso8601String(),
      'expectedReturnDate': instance.expectedReturnDate?.toIso8601String(),
      'source': instance.source,
      'status': instance.status,
    };
