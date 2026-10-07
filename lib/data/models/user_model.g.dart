// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  i: json['i'] as String,
  n: json['n'] as String,
  tn: json['tn'] as String,
  em: json['em'] as String,
  b: (json['b'] as num).toInt(),
  tv: (json['tv'] as num).toInt(),
  p: (json['p'] as num).toInt(),
  pl: (json['pl'] as num).toInt(),
  f: (json['f'] as num).toInt(),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'i': instance.i,
  'n': instance.n,
  'tn': instance.tn,
  'em': instance.em,
  'b': instance.b,
  'tv': instance.tv,
  'p': instance.p,
  'pl': instance.pl,
  'f': instance.f,
};

_LoginUser _$LoginUserFromJson(Map<String, dynamic> json) => _LoginUser(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  notifications: (json['notifications'] as num?)?.toInt(),
  cover: json['cover'] as String?,
  flags: (json['flags'] as num?)?.toInt(),
  proExpiry: json['proExpiry'] as String?,
  perms: (json['perms'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  trd: (json['trd'] as num?)?.toInt(),
  sfb: json['sfb'] as String?,
  efb: json['efb'] as String?,
  profile: json['profile'] as String?,
  uim: json['uim'] as String?,
  mfacp: json['mfacp'] as List<dynamic>?,
);

Map<String, dynamic> _$LoginUserToJson(_LoginUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'notifications': instance.notifications,
      'cover': instance.cover,
      'flags': instance.flags,
      'proExpiry': instance.proExpiry,
      'perms': instance.perms,
      'trd': instance.trd,
      'sfb': instance.sfb,
      'efb': instance.efb,
      'profile': instance.profile,
      'uim': instance.uim,
      'mfacp': instance.mfacp,
    };

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      em: json['em'] as String,
      pass: json['pass'] as String,
      loy: json['loy'] as bool? ?? false,
      rep:
          (json['rep'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{
      'em': instance.em,
      'pass': instance.pass,
      'loy': instance.loy,
      'rep': instance.rep,
    };

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      tkn: json['tkn'] as String,
      loginUser: json['u'] == null
          ? null
          : LoginUser.fromJson(json['u'] as Map<String, dynamic>),
      leagues: json['srvl'] as List<dynamic>?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'tkn': instance.tkn,
      'u': instance.loginUser,
      'srvl': instance.leagues,
      'userId': instance.userId,
    };
