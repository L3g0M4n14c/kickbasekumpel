// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
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

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
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

_$LoginUserImpl _$$LoginUserImplFromJson(Map<String, dynamic> json) =>
    _$LoginUserImpl(
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

Map<String, dynamic> _$$LoginUserImplToJson(_$LoginUserImpl instance) =>
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

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      em: json['em'] as String,
      pass: json['pass'] as String,
      loy: json['loy'] as bool? ?? false,
      rep:
          (json['rep'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'em': instance.em,
      'pass': instance.pass,
      'loy': instance.loy,
      'rep': instance.rep,
    };

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      tkn: json['tkn'] as String,
      loginUser: json['u'] == null
          ? null
          : LoginUser.fromJson(json['u'] as Map<String, dynamic>),
      leagues: json['srvl'] as List<dynamic>?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'tkn': instance.tkn,
      'u': instance.loginUser,
      'srvl': instance.leagues,
      'userId': instance.userId,
    };
