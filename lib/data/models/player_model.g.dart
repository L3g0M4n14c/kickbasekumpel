// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profileBigUrl: json['profileBigUrl'] as String,
  teamName: json['teamName'] as String,
  teamId: json['teamId'] as String,
  position: (json['position'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  averagePoints: (json['averagePoints'] as num).toDouble(),
  totalPoints: (json['totalPoints'] as num).toInt(),
  marketValue: (json['marketValue'] as num).toInt(),
  marketValueTrend: (json['marketValueTrend'] as num).toInt(),
  tfhmvt: (json['tfhmvt'] as num).toInt(),
  prlo: (json['prlo'] as num).toInt(),
  stl: (json['stl'] as num).toInt(),
  status: (json['status'] as num).toInt(),
  userOwnsPlayer: json['userOwnsPlayer'] as bool,
  ligainsiderPhotoUrl: json['ligainsiderPhotoUrl'] as String? ?? '',
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'profileBigUrl': instance.profileBigUrl,
  'teamName': instance.teamName,
  'teamId': instance.teamId,
  'position': instance.position,
  'number': instance.number,
  'averagePoints': instance.averagePoints,
  'totalPoints': instance.totalPoints,
  'marketValue': instance.marketValue,
  'marketValueTrend': instance.marketValueTrend,
  'tfhmvt': instance.tfhmvt,
  'prlo': instance.prlo,
  'stl': instance.stl,
  'status': instance.status,
  'userOwnsPlayer': instance.userOwnsPlayer,
  'ligainsiderPhotoUrl': instance.ligainsiderPhotoUrl,
};

_PlayerDetailResponse _$PlayerDetailResponseFromJson(
  Map<String, dynamic> json,
) => _PlayerDetailResponse(
  fn: json['fn'] as String?,
  ln: json['ln'] as String?,
  tn: json['tn'] as String?,
  shn: (json['shn'] as num?)?.toInt(),
  id: json['id'] as String?,
  position: (json['position'] as num?)?.toInt(),
  number: (json['number'] as num?)?.toInt(),
  averagePoints: (json['averagePoints'] as num?)?.toDouble(),
  totalPoints: (json['totalPoints'] as num?)?.toInt(),
  marketValue: (json['marketValue'] as num?)?.toInt(),
  marketValueTrend: (json['marketValueTrend'] as num?)?.toInt(),
  profileBigUrl: json['profileBigUrl'] as String?,
  teamId: json['teamId'] as String?,
  tfhmvt: (json['tfhmvt'] as num?)?.toInt(),
  prlo: (json['prlo'] as num?)?.toInt(),
  stl: (json['stl'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt(),
  userOwnsPlayer: json['userOwnsPlayer'] as bool?,
);

Map<String, dynamic> _$PlayerDetailResponseToJson(
  _PlayerDetailResponse instance,
) => <String, dynamic>{
  'fn': instance.fn,
  'ln': instance.ln,
  'tn': instance.tn,
  'shn': instance.shn,
  'id': instance.id,
  'position': instance.position,
  'number': instance.number,
  'averagePoints': instance.averagePoints,
  'totalPoints': instance.totalPoints,
  'marketValue': instance.marketValue,
  'marketValueTrend': instance.marketValueTrend,
  'profileBigUrl': instance.profileBigUrl,
  'teamId': instance.teamId,
  'tfhmvt': instance.tfhmvt,
  'prlo': instance.prlo,
  'stl': instance.stl,
  'status': instance.status,
  'userOwnsPlayer': instance.userOwnsPlayer,
};

_PlayersResponse _$PlayersResponseFromJson(Map<String, dynamic> json) =>
    _PlayersResponse(
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayersResponseToJson(_PlayersResponse instance) =>
    <String, dynamic>{'players': instance.players};
