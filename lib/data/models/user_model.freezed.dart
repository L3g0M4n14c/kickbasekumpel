// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get i; String get n; String get tn; String get em; int get b; int get tv; int get p; int get pl; int get f;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.i, _this.i) || other.i == _this.i)&&(identical(other.n, _this.n) || other.n == _this.n)&&(identical(other.tn, _this.tn) || other.tn == _this.tn)&&(identical(other.em, _this.em) || other.em == _this.em)&&(identical(other.b, _this.b) || other.b == _this.b)&&(identical(other.tv, _this.tv) || other.tv == _this.tv)&&(identical(other.p, _this.p) || other.p == _this.p)&&(identical(other.pl, _this.pl) || other.pl == _this.pl)&&(identical(other.f, _this.f) || other.f == _this.f));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.i,_this.n,_this.tn,_this.em,_this.b,_this.tv,_this.p,_this.pl,_this.f);
}

@override
String toString() {
  final _this = this as User;
  return 'User(i: ${_this.i}, n: ${_this.n}, tn: ${_this.tn}, em: ${_this.em}, b: ${_this.b}, tv: ${_this.tv}, p: ${_this.p}, pl: ${_this.pl}, f: ${_this.f})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String i, String n, String tn, String em, int b, int tv, int p, int pl, int f
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? i = null,Object? n = null,Object? tn = null,Object? em = null,Object? b = null,Object? tv = null,Object? p = null,Object? pl = null,Object? f = null,}) {
  return _then(User(
i: null == i ? _self.i : i // ignore: cast_nullable_to_non_nullable
as String,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as String,tn: null == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String,em: null == em ? _self.em : em // ignore: cast_nullable_to_non_nullable
as String,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as int,tv: null == tv ? _self.tv : tv // ignore: cast_nullable_to_non_nullable
as int,p: null == p ? _self.p : p // ignore: cast_nullable_to_non_nullable
as int,pl: null == pl ? _self.pl : pl // ignore: cast_nullable_to_non_nullable
as int,f: null == f ? _self.f : f // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String i,  String n,  String tn,  String em,  int b,  int tv,  int p,  int pl,  int f)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.i,_that.n,_that.tn,_that.em,_that.b,_that.tv,_that.p,_that.pl,_that.f);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String i,  String n,  String tn,  String em,  int b,  int tv,  int p,  int pl,  int f)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.i,_that.n,_that.tn,_that.em,_that.b,_that.tv,_that.p,_that.pl,_that.f);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String i,  String n,  String tn,  String em,  int b,  int tv,  int p,  int pl,  int f)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.i,_that.n,_that.tn,_that.em,_that.b,_that.tv,_that.p,_that.pl,_that.f);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.i, required this.n, required this.tn, required this.em, required this.b, required this.tv, required this.p, required this.pl, required this.f});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String i;
@override final  String n;
@override final  String tn;
@override final  String em;
@override final  int b;
@override final  int tv;
@override final  int p;
@override final  int pl;
@override final  int f;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.i, i) || other.i == i)&&(identical(other.n, n) || other.n == n)&&(identical(other.tn, tn) || other.tn == tn)&&(identical(other.em, em) || other.em == em)&&(identical(other.b, b) || other.b == b)&&(identical(other.tv, tv) || other.tv == tv)&&(identical(other.p, p) || other.p == p)&&(identical(other.pl, pl) || other.pl == pl)&&(identical(other.f, f) || other.f == f));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,i,n,tn,em,b,tv,p,pl,f);
}

@override
String toString() {
    return 'User(i: $i, n: $n, tn: $tn, em: $em, b: $b, tv: $tv, p: $p, pl: $pl, f: $f)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String i, String n, String tn, String em, int b, int tv, int p, int pl, int f
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? i = null,Object? n = null,Object? tn = null,Object? em = null,Object? b = null,Object? tv = null,Object? p = null,Object? pl = null,Object? f = null,}) {
  return _then(_User(
i: null == i ? _self.i : i // ignore: cast_nullable_to_non_nullable
as String,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as String,tn: null == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String,em: null == em ? _self.em : em // ignore: cast_nullable_to_non_nullable
as String,b: null == b ? _self.b : b // ignore: cast_nullable_to_non_nullable
as int,tv: null == tv ? _self.tv : tv // ignore: cast_nullable_to_non_nullable
as int,p: null == p ? _self.p : p // ignore: cast_nullable_to_non_nullable
as int,pl: null == pl ? _self.pl : pl // ignore: cast_nullable_to_non_nullable
as int,f: null == f ? _self.f : f // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LoginUser {

 String get id; String get name; String get email; int? get notifications; String? get cover; int? get flags; String? get proExpiry; List<int>? get perms; int? get trd; String? get sfb; String? get efb; String? get profile; String? get uim; List<dynamic>? get mfacp;
/// Create a copy of LoginUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginUserCopyWith<LoginUser> get copyWith => _$LoginUserCopyWithImpl<LoginUser>(this as LoginUser, _$identity);

  /// Serializes this LoginUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.notifications, _this.notifications) || other.notifications == _this.notifications)&&(identical(other.cover, _this.cover) || other.cover == _this.cover)&&(identical(other.flags, _this.flags) || other.flags == _this.flags)&&(identical(other.proExpiry, _this.proExpiry) || other.proExpiry == _this.proExpiry)&&const DeepCollectionEquality().equals(other.perms, _this.perms)&&(identical(other.trd, _this.trd) || other.trd == _this.trd)&&(identical(other.sfb, _this.sfb) || other.sfb == _this.sfb)&&(identical(other.efb, _this.efb) || other.efb == _this.efb)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.uim, _this.uim) || other.uim == _this.uim)&&const DeepCollectionEquality().equals(other.mfacp, _this.mfacp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginUser;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.notifications,_this.cover,_this.flags,_this.proExpiry,const DeepCollectionEquality().hash(_this.perms),_this.trd,_this.sfb,_this.efb,_this.profile,_this.uim,const DeepCollectionEquality().hash(_this.mfacp));
}

@override
String toString() {
  final _this = this as LoginUser;
  return 'LoginUser(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, notifications: ${_this.notifications}, cover: ${_this.cover}, flags: ${_this.flags}, proExpiry: ${_this.proExpiry}, perms: ${_this.perms}, trd: ${_this.trd}, sfb: ${_this.sfb}, efb: ${_this.efb}, profile: ${_this.profile}, uim: ${_this.uim}, mfacp: ${_this.mfacp})';
}


}

/// @nodoc
abstract mixin class $LoginUserCopyWith<$Res>  {
  factory $LoginUserCopyWith(LoginUser value, $Res Function(LoginUser) _then) = _$LoginUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, int? notifications, String? cover, int? flags, String? proExpiry, List<int>? perms, int? trd, String? sfb, String? efb, String? profile, String? uim, List<dynamic>? mfacp
});




}
/// @nodoc
class _$LoginUserCopyWithImpl<$Res>
    implements $LoginUserCopyWith<$Res> {
  _$LoginUserCopyWithImpl(this._self, this._then);

  final LoginUser _self;
  final $Res Function(LoginUser) _then;

/// Create a copy of LoginUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? notifications = freezed,Object? cover = freezed,Object? flags = freezed,Object? proExpiry = freezed,Object? perms = freezed,Object? trd = freezed,Object? sfb = freezed,Object? efb = freezed,Object? profile = freezed,Object? uim = freezed,Object? mfacp = freezed,}) {
  return _then(LoginUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,notifications: freezed == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as int?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,flags: freezed == flags ? _self.flags : flags // ignore: cast_nullable_to_non_nullable
as int?,proExpiry: freezed == proExpiry ? _self.proExpiry : proExpiry // ignore: cast_nullable_to_non_nullable
as String?,perms: freezed == perms ? _self.perms : perms // ignore: cast_nullable_to_non_nullable
as List<int>?,trd: freezed == trd ? _self.trd : trd // ignore: cast_nullable_to_non_nullable
as int?,sfb: freezed == sfb ? _self.sfb : sfb // ignore: cast_nullable_to_non_nullable
as String?,efb: freezed == efb ? _self.efb : efb // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,uim: freezed == uim ? _self.uim : uim // ignore: cast_nullable_to_non_nullable
as String?,mfacp: freezed == mfacp ? _self.mfacp : mfacp // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginUser].
extension LoginUserPatterns on LoginUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginUser value)  $default,){
final _that = this;
switch (_that) {
case _LoginUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginUser value)?  $default,){
final _that = this;
switch (_that) {
case _LoginUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  int? notifications,  String? cover,  int? flags,  String? proExpiry,  List<int>? perms,  int? trd,  String? sfb,  String? efb,  String? profile,  String? uim,  List<dynamic>? mfacp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.notifications,_that.cover,_that.flags,_that.proExpiry,_that.perms,_that.trd,_that.sfb,_that.efb,_that.profile,_that.uim,_that.mfacp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  int? notifications,  String? cover,  int? flags,  String? proExpiry,  List<int>? perms,  int? trd,  String? sfb,  String? efb,  String? profile,  String? uim,  List<dynamic>? mfacp)  $default,) {final _that = this;
switch (_that) {
case _LoginUser():
return $default(_that.id,_that.name,_that.email,_that.notifications,_that.cover,_that.flags,_that.proExpiry,_that.perms,_that.trd,_that.sfb,_that.efb,_that.profile,_that.uim,_that.mfacp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  int? notifications,  String? cover,  int? flags,  String? proExpiry,  List<int>? perms,  int? trd,  String? sfb,  String? efb,  String? profile,  String? uim,  List<dynamic>? mfacp)?  $default,) {final _that = this;
switch (_that) {
case _LoginUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.notifications,_that.cover,_that.flags,_that.proExpiry,_that.perms,_that.trd,_that.sfb,_that.efb,_that.profile,_that.uim,_that.mfacp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginUser extends LoginUser {
  const _LoginUser({required this.id, required this.name, required this.email, this.notifications, this.cover, this.flags, this.proExpiry,  List<int>? perms, this.trd, this.sfb, this.efb, this.profile, this.uim,  List<dynamic>? mfacp}): _perms = perms,_mfacp = mfacp,super._();
  factory _LoginUser.fromJson(Map<String, dynamic> json) => _$LoginUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override final  int? notifications;
@override final  String? cover;
@override final  int? flags;
@override final  String? proExpiry;
 final  List<int>? _perms;
@override List<int>? get perms {
  final value = _perms;
  if (value == null) return null;
  if (_perms is EqualUnmodifiableListView) return _perms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? trd;
@override final  String? sfb;
@override final  String? efb;
@override final  String? profile;
@override final  String? uim;
 final  List<dynamic>? _mfacp;
@override List<dynamic>? get mfacp {
  final value = _mfacp;
  if (value == null) return null;
  if (_mfacp is EqualUnmodifiableListView) return _mfacp;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LoginUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginUserCopyWith<_LoginUser> get copyWith => __$LoginUserCopyWithImpl<_LoginUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.notifications, notifications) || other.notifications == notifications)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.flags, flags) || other.flags == flags)&&(identical(other.proExpiry, proExpiry) || other.proExpiry == proExpiry)&&const DeepCollectionEquality().equals(other.perms, _perms)&&(identical(other.trd, trd) || other.trd == trd)&&(identical(other.sfb, sfb) || other.sfb == sfb)&&(identical(other.efb, efb) || other.efb == efb)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.uim, uim) || other.uim == uim)&&const DeepCollectionEquality().equals(other.mfacp, _mfacp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,notifications,cover,flags,proExpiry,const DeepCollectionEquality().hash(_perms),trd,sfb,efb,profile,uim,const DeepCollectionEquality().hash(_mfacp));
}

@override
String toString() {
    return 'LoginUser(id: $id, name: $name, email: $email, notifications: $notifications, cover: $cover, flags: $flags, proExpiry: $proExpiry, perms: $perms, trd: $trd, sfb: $sfb, efb: $efb, profile: $profile, uim: $uim, mfacp: $mfacp)';
}


}

/// @nodoc
abstract mixin class _$LoginUserCopyWith<$Res> implements $LoginUserCopyWith<$Res> {
  factory _$LoginUserCopyWith(_LoginUser value, $Res Function(_LoginUser) _then) = __$LoginUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, int? notifications, String? cover, int? flags, String? proExpiry, List<int>? perms, int? trd, String? sfb, String? efb, String? profile, String? uim, List<dynamic>? mfacp
});




}
/// @nodoc
class __$LoginUserCopyWithImpl<$Res>
    implements _$LoginUserCopyWith<$Res> {
  __$LoginUserCopyWithImpl(this._self, this._then);

  final _LoginUser _self;
  final $Res Function(_LoginUser) _then;

/// Create a copy of LoginUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? notifications = freezed,Object? cover = freezed,Object? flags = freezed,Object? proExpiry = freezed,Object? perms = freezed,Object? trd = freezed,Object? sfb = freezed,Object? efb = freezed,Object? profile = freezed,Object? uim = freezed,Object? mfacp = freezed,}) {
  return _then(_LoginUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,notifications: freezed == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as int?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,flags: freezed == flags ? _self.flags : flags // ignore: cast_nullable_to_non_nullable
as int?,proExpiry: freezed == proExpiry ? _self.proExpiry : proExpiry // ignore: cast_nullable_to_non_nullable
as String?,perms: freezed == perms ? _self._perms : perms // ignore: cast_nullable_to_non_nullable
as List<int>?,trd: freezed == trd ? _self.trd : trd // ignore: cast_nullable_to_non_nullable
as int?,sfb: freezed == sfb ? _self.sfb : sfb // ignore: cast_nullable_to_non_nullable
as String?,efb: freezed == efb ? _self.efb : efb // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,uim: freezed == uim ? _self.uim : uim // ignore: cast_nullable_to_non_nullable
as String?,mfacp: freezed == mfacp ? _self._mfacp : mfacp // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}


}


/// @nodoc
mixin _$LoginRequest {

 String get em; String get pass; bool get loy; Map<String, String> get rep;
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestCopyWith<LoginRequest> get copyWith => _$LoginRequestCopyWithImpl<LoginRequest>(this as LoginRequest, _$identity);

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequest&&(identical(other.em, _this.em) || other.em == _this.em)&&(identical(other.pass, _this.pass) || other.pass == _this.pass)&&(identical(other.loy, _this.loy) || other.loy == _this.loy)&&const DeepCollectionEquality().equals(other.rep, _this.rep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginRequest;
  return Object.hash(runtimeType,_this.em,_this.pass,_this.loy,const DeepCollectionEquality().hash(_this.rep));
}

@override
String toString() {
  final _this = this as LoginRequest;
  return 'LoginRequest(em: ${_this.em}, pass: ${_this.pass}, loy: ${_this.loy}, rep: ${_this.rep})';
}


}

/// @nodoc
abstract mixin class $LoginRequestCopyWith<$Res>  {
  factory $LoginRequestCopyWith(LoginRequest value, $Res Function(LoginRequest) _then) = _$LoginRequestCopyWithImpl;
@useResult
$Res call({
 String em, String pass, bool loy, Map<String, String> rep
});




}
/// @nodoc
class _$LoginRequestCopyWithImpl<$Res>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._self, this._then);

  final LoginRequest _self;
  final $Res Function(LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? em = null,Object? pass = null,Object? loy = null,Object? rep = null,}) {
  return _then(LoginRequest(
em: null == em ? _self.em : em // ignore: cast_nullable_to_non_nullable
as String,pass: null == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as String,loy: null == loy ? _self.loy : loy // ignore: cast_nullable_to_non_nullable
as bool,rep: null == rep ? _self.rep : rep // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginRequest].
extension LoginRequestPatterns on LoginRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String em,  String pass,  bool loy,  Map<String, String> rep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.em,_that.pass,_that.loy,_that.rep);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String em,  String pass,  bool loy,  Map<String, String> rep)  $default,) {final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that.em,_that.pass,_that.loy,_that.rep);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String em,  String pass,  bool loy,  Map<String, String> rep)?  $default,) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.em,_that.pass,_that.loy,_that.rep);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginRequest implements LoginRequest {
  const _LoginRequest({required this.em, required this.pass, this.loy = false,  Map<String, String> rep = const {}}): _rep = rep;
  factory _LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

@override final  String em;
@override final  String pass;
@override@JsonKey() final  bool loy;
 final  Map<String, String> _rep;
@override@JsonKey() Map<String, String> get rep {
  if (_rep is EqualUnmodifiableMapView) return _rep;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rep);
}


/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestCopyWith<_LoginRequest> get copyWith => __$LoginRequestCopyWithImpl<_LoginRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequest&&(identical(other.em, em) || other.em == em)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.loy, loy) || other.loy == loy)&&const DeepCollectionEquality().equals(other.rep, _rep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,em,pass,loy,const DeepCollectionEquality().hash(_rep));
}

@override
String toString() {
    return 'LoginRequest(em: $em, pass: $pass, loy: $loy, rep: $rep)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestCopyWith<$Res> implements $LoginRequestCopyWith<$Res> {
  factory _$LoginRequestCopyWith(_LoginRequest value, $Res Function(_LoginRequest) _then) = __$LoginRequestCopyWithImpl;
@override @useResult
$Res call({
 String em, String pass, bool loy, Map<String, String> rep
});




}
/// @nodoc
class __$LoginRequestCopyWithImpl<$Res>
    implements _$LoginRequestCopyWith<$Res> {
  __$LoginRequestCopyWithImpl(this._self, this._then);

  final _LoginRequest _self;
  final $Res Function(_LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? em = null,Object? pass = null,Object? loy = null,Object? rep = null,}) {
  return _then(_LoginRequest(
em: null == em ? _self.em : em // ignore: cast_nullable_to_non_nullable
as String,pass: null == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as String,loy: null == loy ? _self.loy : loy // ignore: cast_nullable_to_non_nullable
as bool,rep: null == rep ? _self._rep : rep // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$LoginResponse {

 String get tkn;@JsonKey(name: 'u') LoginUser? get loginUser;@JsonKey(name: 'srvl') List<dynamic>? get leagues; String? get userId;
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseCopyWith<LoginResponse> get copyWith => _$LoginResponseCopyWithImpl<LoginResponse>(this as LoginResponse, _$identity);

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponse&&(identical(other.tkn, _this.tkn) || other.tkn == _this.tkn)&&(identical(other.loginUser, _this.loginUser) || other.loginUser == _this.loginUser)&&const DeepCollectionEquality().equals(other.leagues, _this.leagues)&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginResponse;
  return Object.hash(runtimeType,_this.tkn,_this.loginUser,const DeepCollectionEquality().hash(_this.leagues),_this.userId);
}

@override
String toString() {
  final _this = this as LoginResponse;
  return 'LoginResponse(tkn: ${_this.tkn}, loginUser: ${_this.loginUser}, leagues: ${_this.leagues}, userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $LoginResponseCopyWith<$Res>  {
  factory $LoginResponseCopyWith(LoginResponse value, $Res Function(LoginResponse) _then) = _$LoginResponseCopyWithImpl;
@useResult
$Res call({
 String tkn,@JsonKey(name: 'u') LoginUser? loginUser,@JsonKey(name: 'srvl') List<dynamic>? leagues, String? userId
});


$LoginUserCopyWith<$Res>? get loginUser;

}
/// @nodoc
class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tkn = null,Object? loginUser = freezed,Object? leagues = freezed,Object? userId = freezed,}) {
  return _then(LoginResponse(
tkn: null == tkn ? _self.tkn : tkn // ignore: cast_nullable_to_non_nullable
as String,loginUser: freezed == loginUser ? _self.loginUser : loginUser // ignore: cast_nullable_to_non_nullable
as LoginUser?,leagues: freezed == leagues ? _self.leagues : leagues // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginUserCopyWith<$Res>? get loginUser {
    if (_self.loginUser == null) {
    return null;
  }

  return $LoginUserCopyWith<$Res>(_self.loginUser!, (value) {
    return _then(_self.copyWith(loginUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginResponse].
extension LoginResponsePatterns on LoginResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tkn, @JsonKey(name: 'u')  LoginUser? loginUser, @JsonKey(name: 'srvl')  List<dynamic>? leagues,  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.tkn,_that.loginUser,_that.leagues,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tkn, @JsonKey(name: 'u')  LoginUser? loginUser, @JsonKey(name: 'srvl')  List<dynamic>? leagues,  String? userId)  $default,) {final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that.tkn,_that.loginUser,_that.leagues,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tkn, @JsonKey(name: 'u')  LoginUser? loginUser, @JsonKey(name: 'srvl')  List<dynamic>? leagues,  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.tkn,_that.loginUser,_that.leagues,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginResponse extends LoginResponse {
  const _LoginResponse({required this.tkn, @JsonKey(name: 'u') this.loginUser, @JsonKey(name: 'srvl')  List<dynamic>? leagues, this.userId}): _leagues = leagues,super._();
  factory _LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

@override final  String tkn;
@override@JsonKey(name: 'u') final  LoginUser? loginUser;
 final  List<dynamic>? _leagues;
@override@JsonKey(name: 'srvl') List<dynamic>? get leagues {
  final value = _leagues;
  if (value == null) return null;
  if (_leagues is EqualUnmodifiableListView) return _leagues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? userId;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseCopyWith<_LoginResponse> get copyWith => __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponse&&(identical(other.tkn, tkn) || other.tkn == tkn)&&(identical(other.loginUser, loginUser) || other.loginUser == loginUser)&&const DeepCollectionEquality().equals(other.leagues, _leagues)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tkn,loginUser,const DeepCollectionEquality().hash(_leagues),userId);
}

@override
String toString() {
    return 'LoginResponse(tkn: $tkn, loginUser: $loginUser, leagues: $leagues, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseCopyWith<$Res> implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(_LoginResponse value, $Res Function(_LoginResponse) _then) = __$LoginResponseCopyWithImpl;
@override @useResult
$Res call({
 String tkn,@JsonKey(name: 'u') LoginUser? loginUser,@JsonKey(name: 'srvl') List<dynamic>? leagues, String? userId
});


@override $LoginUserCopyWith<$Res>? get loginUser;

}
/// @nodoc
class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tkn = null,Object? loginUser = freezed,Object? leagues = freezed,Object? userId = freezed,}) {
  return _then(_LoginResponse(
tkn: null == tkn ? _self.tkn : tkn // ignore: cast_nullable_to_non_nullable
as String,loginUser: freezed == loginUser ? _self.loginUser : loginUser // ignore: cast_nullable_to_non_nullable
as LoginUser?,leagues: freezed == leagues ? _self._leagues : leagues // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginUserCopyWith<$Res>? get loginUser {
    if (_self.loginUser == null) {
    return null;
  }

  return $LoginUserCopyWith<$Res>(_self.loginUser!, (value) {
    return _then(_self.copyWith(loginUser: value));
  });
}
}

// dart format on
