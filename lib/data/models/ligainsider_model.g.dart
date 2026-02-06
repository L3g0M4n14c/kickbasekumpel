// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ligainsider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LigainsiderPlayerImpl _$$LigainsiderPlayerImplFromJson(
  Map<String, dynamic> json,
) => _$LigainsiderPlayerImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  shortName: json['shortName'] as String,
  teamName: json['teamName'] as String,
  teamId: json['teamId'] as String,
  position: (json['position'] as num).toInt(),
  injury_status: json['injury_status'] as String,
  injury_description: json['injury_description'] as String?,
  form_rating: (json['form_rating'] as num?)?.toInt(),
  last_update: DateTime.parse(json['last_update'] as String),
  status_text: json['status_text'] as String?,
  expected_return: json['expected_return'] == null
      ? null
      : DateTime.parse(json['expected_return'] as String),
  alternative: json['alternative'] as String?,
  ligainsiderId: json['ligainsiderId'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$LigainsiderPlayerImplToJson(
  _$LigainsiderPlayerImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'shortName': instance.shortName,
  'teamName': instance.teamName,
  'teamId': instance.teamId,
  'position': instance.position,
  'injury_status': instance.injury_status,
  'injury_description': instance.injury_description,
  'form_rating': instance.form_rating,
  'last_update': instance.last_update.toIso8601String(),
  'status_text': instance.status_text,
  'expected_return': instance.expected_return?.toIso8601String(),
  'alternative': instance.alternative,
  'ligainsiderId': instance.ligainsiderId,
  'imageUrl': instance.imageUrl,
};

_$LigainsiderStatusImpl _$$LigainsiderStatusImplFromJson(
  Map<String, dynamic> json,
) => _$LigainsiderStatusImpl(
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  statusCategory: json['statusCategory'] as String,
  statusReason: json['statusReason'] as String,
  lastUpdate: DateTime.parse(json['lastUpdate'] as String),
);

Map<String, dynamic> _$$LigainsiderStatusImplToJson(
  _$LigainsiderStatusImpl instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'playerName': instance.playerName,
  'statusCategory': instance.statusCategory,
  'statusReason': instance.statusReason,
  'lastUpdate': instance.lastUpdate.toIso8601String(),
};

_$LigainsiderResponseImpl _$$LigainsiderResponseImplFromJson(
  Map<String, dynamic> json,
) => _$LigainsiderResponseImpl(
  players: (json['players'] as List<dynamic>)
      .map((e) => LigainsiderPlayer.fromJson(e as Map<String, dynamic>))
      .toList(),
  last_update: DateTime.parse(json['last_update'] as String),
  total_injured: (json['total_injured'] as num?)?.toInt(),
  total_questionable: (json['total_questionable'] as num?)?.toInt(),
);

Map<String, dynamic> _$$LigainsiderResponseImplToJson(
  _$LigainsiderResponseImpl instance,
) => <String, dynamic>{
  'players': instance.players,
  'last_update': instance.last_update.toIso8601String(),
  'total_injured': instance.total_injured,
  'total_questionable': instance.total_questionable,
};

_$InjuryReportImpl _$$InjuryReportImplFromJson(Map<String, dynamic> json) =>
    _$InjuryReportImpl(
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

Map<String, dynamic> _$$InjuryReportImplToJson(_$InjuryReportImpl instance) =>
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
