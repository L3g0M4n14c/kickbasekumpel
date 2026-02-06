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
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      leagues: json['leagues'] as List<dynamic>?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'tkn': instance.tkn,
      'user': instance.user,
      'leagues': instance.leagues,
      'userId': instance.userId,
    };
