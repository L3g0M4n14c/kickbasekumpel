// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Player {

 String get id; String get firstName; String get lastName; String get profileBigUrl; String get teamName; String get teamId; int get position; int get number; double get averagePoints; int get totalPoints; int get marketValue; int get marketValueTrend; int get tfhmvt; int get prlo; int get stl; int get status; bool get userOwnsPlayer; String get ligainsiderPhotoUrl;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Player;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.profileBigUrl, _this.profileBigUrl) || other.profileBigUrl == _this.profileBigUrl)&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.averagePoints, _this.averagePoints) || other.averagePoints == _this.averagePoints)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.marketValueTrend, _this.marketValueTrend) || other.marketValueTrend == _this.marketValueTrend)&&(identical(other.tfhmvt, _this.tfhmvt) || other.tfhmvt == _this.tfhmvt)&&(identical(other.prlo, _this.prlo) || other.prlo == _this.prlo)&&(identical(other.stl, _this.stl) || other.stl == _this.stl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.userOwnsPlayer, _this.userOwnsPlayer) || other.userOwnsPlayer == _this.userOwnsPlayer)&&(identical(other.ligainsiderPhotoUrl, _this.ligainsiderPhotoUrl) || other.ligainsiderPhotoUrl == _this.ligainsiderPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Player;
  return Object.hash(runtimeType,_this.id,_this.firstName,_this.lastName,_this.profileBigUrl,_this.teamName,_this.teamId,_this.position,_this.number,_this.averagePoints,_this.totalPoints,_this.marketValue,_this.marketValueTrend,_this.tfhmvt,_this.prlo,_this.stl,_this.status,_this.userOwnsPlayer,_this.ligainsiderPhotoUrl);
}

@override
String toString() {
  final _this = this as Player;
  return 'Player(id: ${_this.id}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, profileBigUrl: ${_this.profileBigUrl}, teamName: ${_this.teamName}, teamId: ${_this.teamId}, position: ${_this.position}, number: ${_this.number}, averagePoints: ${_this.averagePoints}, totalPoints: ${_this.totalPoints}, marketValue: ${_this.marketValue}, marketValueTrend: ${_this.marketValueTrend}, tfhmvt: ${_this.tfhmvt}, prlo: ${_this.prlo}, stl: ${_this.stl}, status: ${_this.status}, userOwnsPlayer: ${_this.userOwnsPlayer}, ligainsiderPhotoUrl: ${_this.ligainsiderPhotoUrl})';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, String lastName, String profileBigUrl, String teamName, String teamId, int position, int number, double averagePoints, int totalPoints, int marketValue, int marketValueTrend, int tfhmvt, int prlo, int stl, int status, bool userOwnsPlayer, String ligainsiderPhotoUrl
});




}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? profileBigUrl = null,Object? teamName = null,Object? teamId = null,Object? position = null,Object? number = null,Object? averagePoints = null,Object? totalPoints = null,Object? marketValue = null,Object? marketValueTrend = null,Object? tfhmvt = null,Object? prlo = null,Object? stl = null,Object? status = null,Object? userOwnsPlayer = null,Object? ligainsiderPhotoUrl = null,}) {
  return _then(Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,profileBigUrl: null == profileBigUrl ? _self.profileBigUrl : profileBigUrl // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,marketValueTrend: null == marketValueTrend ? _self.marketValueTrend : marketValueTrend // ignore: cast_nullable_to_non_nullable
as int,tfhmvt: null == tfhmvt ? _self.tfhmvt : tfhmvt // ignore: cast_nullable_to_non_nullable
as int,prlo: null == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int,stl: null == stl ? _self.stl : stl // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,userOwnsPlayer: null == userOwnsPlayer ? _self.userOwnsPlayer : userOwnsPlayer // ignore: cast_nullable_to_non_nullable
as bool,ligainsiderPhotoUrl: null == ligainsiderPhotoUrl ? _self.ligainsiderPhotoUrl : ligainsiderPhotoUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String profileBigUrl,  String teamName,  String teamId,  int position,  int number,  double averagePoints,  int totalPoints,  int marketValue,  int marketValueTrend,  int tfhmvt,  int prlo,  int stl,  int status,  bool userOwnsPlayer,  String ligainsiderPhotoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.profileBigUrl,_that.teamName,_that.teamId,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.tfhmvt,_that.prlo,_that.stl,_that.status,_that.userOwnsPlayer,_that.ligainsiderPhotoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String profileBigUrl,  String teamName,  String teamId,  int position,  int number,  double averagePoints,  int totalPoints,  int marketValue,  int marketValueTrend,  int tfhmvt,  int prlo,  int stl,  int status,  bool userOwnsPlayer,  String ligainsiderPhotoUrl)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.id,_that.firstName,_that.lastName,_that.profileBigUrl,_that.teamName,_that.teamId,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.tfhmvt,_that.prlo,_that.stl,_that.status,_that.userOwnsPlayer,_that.ligainsiderPhotoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  String lastName,  String profileBigUrl,  String teamName,  String teamId,  int position,  int number,  double averagePoints,  int totalPoints,  int marketValue,  int marketValueTrend,  int tfhmvt,  int prlo,  int stl,  int status,  bool userOwnsPlayer,  String ligainsiderPhotoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.profileBigUrl,_that.teamName,_that.teamId,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.tfhmvt,_that.prlo,_that.stl,_that.status,_that.userOwnsPlayer,_that.ligainsiderPhotoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Player implements Player {
  const _Player({required this.id, required this.firstName, required this.lastName, required this.profileBigUrl, required this.teamName, required this.teamId, required this.position, required this.number, required this.averagePoints, required this.totalPoints, required this.marketValue, required this.marketValueTrend, required this.tfhmvt, required this.prlo, required this.stl, required this.status, required this.userOwnsPlayer, this.ligainsiderPhotoUrl = ''});
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override final  String id;
@override final  String firstName;
@override final  String lastName;
@override final  String profileBigUrl;
@override final  String teamName;
@override final  String teamId;
@override final  int position;
@override final  int number;
@override final  double averagePoints;
@override final  int totalPoints;
@override final  int marketValue;
@override final  int marketValueTrend;
@override final  int tfhmvt;
@override final  int prlo;
@override final  int stl;
@override final  int status;
@override final  bool userOwnsPlayer;
@override@JsonKey() final  String ligainsiderPhotoUrl;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.profileBigUrl, profileBigUrl) || other.profileBigUrl == profileBigUrl)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.position, position) || other.position == position)&&(identical(other.number, number) || other.number == number)&&(identical(other.averagePoints, averagePoints) || other.averagePoints == averagePoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.marketValueTrend, marketValueTrend) || other.marketValueTrend == marketValueTrend)&&(identical(other.tfhmvt, tfhmvt) || other.tfhmvt == tfhmvt)&&(identical(other.prlo, prlo) || other.prlo == prlo)&&(identical(other.stl, stl) || other.stl == stl)&&(identical(other.status, status) || other.status == status)&&(identical(other.userOwnsPlayer, userOwnsPlayer) || other.userOwnsPlayer == userOwnsPlayer)&&(identical(other.ligainsiderPhotoUrl, ligainsiderPhotoUrl) || other.ligainsiderPhotoUrl == ligainsiderPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,firstName,lastName,profileBigUrl,teamName,teamId,position,number,averagePoints,totalPoints,marketValue,marketValueTrend,tfhmvt,prlo,stl,status,userOwnsPlayer,ligainsiderPhotoUrl);
}

@override
String toString() {
    return 'Player(id: $id, firstName: $firstName, lastName: $lastName, profileBigUrl: $profileBigUrl, teamName: $teamName, teamId: $teamId, position: $position, number: $number, averagePoints: $averagePoints, totalPoints: $totalPoints, marketValue: $marketValue, marketValueTrend: $marketValueTrend, tfhmvt: $tfhmvt, prlo: $prlo, stl: $stl, status: $status, userOwnsPlayer: $userOwnsPlayer, ligainsiderPhotoUrl: $ligainsiderPhotoUrl)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, String lastName, String profileBigUrl, String teamName, String teamId, int position, int number, double averagePoints, int totalPoints, int marketValue, int marketValueTrend, int tfhmvt, int prlo, int stl, int status, bool userOwnsPlayer, String ligainsiderPhotoUrl
});




}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? profileBigUrl = null,Object? teamName = null,Object? teamId = null,Object? position = null,Object? number = null,Object? averagePoints = null,Object? totalPoints = null,Object? marketValue = null,Object? marketValueTrend = null,Object? tfhmvt = null,Object? prlo = null,Object? stl = null,Object? status = null,Object? userOwnsPlayer = null,Object? ligainsiderPhotoUrl = null,}) {
  return _then(_Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,profileBigUrl: null == profileBigUrl ? _self.profileBigUrl : profileBigUrl // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,marketValueTrend: null == marketValueTrend ? _self.marketValueTrend : marketValueTrend // ignore: cast_nullable_to_non_nullable
as int,tfhmvt: null == tfhmvt ? _self.tfhmvt : tfhmvt // ignore: cast_nullable_to_non_nullable
as int,prlo: null == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int,stl: null == stl ? _self.stl : stl // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,userOwnsPlayer: null == userOwnsPlayer ? _self.userOwnsPlayer : userOwnsPlayer // ignore: cast_nullable_to_non_nullable
as bool,ligainsiderPhotoUrl: null == ligainsiderPhotoUrl ? _self.ligainsiderPhotoUrl : ligainsiderPhotoUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PlayerDetailResponse {

 String? get fn; String? get ln; String? get tn; int? get shn; String? get id; int? get position; int? get number; double? get averagePoints; int? get totalPoints; int? get marketValue; int? get marketValueTrend; String? get profileBigUrl; String? get teamId; int? get tfhmvt; int? get prlo; int? get stl; int? get status; bool? get userOwnsPlayer;
/// Create a copy of PlayerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerDetailResponseCopyWith<PlayerDetailResponse> get copyWith => _$PlayerDetailResponseCopyWithImpl<PlayerDetailResponse>(this as PlayerDetailResponse, _$identity);

  /// Serializes this PlayerDetailResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerDetailResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerDetailResponse&&(identical(other.fn, _this.fn) || other.fn == _this.fn)&&(identical(other.ln, _this.ln) || other.ln == _this.ln)&&(identical(other.tn, _this.tn) || other.tn == _this.tn)&&(identical(other.shn, _this.shn) || other.shn == _this.shn)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.averagePoints, _this.averagePoints) || other.averagePoints == _this.averagePoints)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.marketValueTrend, _this.marketValueTrend) || other.marketValueTrend == _this.marketValueTrend)&&(identical(other.profileBigUrl, _this.profileBigUrl) || other.profileBigUrl == _this.profileBigUrl)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.tfhmvt, _this.tfhmvt) || other.tfhmvt == _this.tfhmvt)&&(identical(other.prlo, _this.prlo) || other.prlo == _this.prlo)&&(identical(other.stl, _this.stl) || other.stl == _this.stl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.userOwnsPlayer, _this.userOwnsPlayer) || other.userOwnsPlayer == _this.userOwnsPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerDetailResponse;
  return Object.hash(runtimeType,_this.fn,_this.ln,_this.tn,_this.shn,_this.id,_this.position,_this.number,_this.averagePoints,_this.totalPoints,_this.marketValue,_this.marketValueTrend,_this.profileBigUrl,_this.teamId,_this.tfhmvt,_this.prlo,_this.stl,_this.status,_this.userOwnsPlayer);
}

@override
String toString() {
  final _this = this as PlayerDetailResponse;
  return 'PlayerDetailResponse(fn: ${_this.fn}, ln: ${_this.ln}, tn: ${_this.tn}, shn: ${_this.shn}, id: ${_this.id}, position: ${_this.position}, number: ${_this.number}, averagePoints: ${_this.averagePoints}, totalPoints: ${_this.totalPoints}, marketValue: ${_this.marketValue}, marketValueTrend: ${_this.marketValueTrend}, profileBigUrl: ${_this.profileBigUrl}, teamId: ${_this.teamId}, tfhmvt: ${_this.tfhmvt}, prlo: ${_this.prlo}, stl: ${_this.stl}, status: ${_this.status}, userOwnsPlayer: ${_this.userOwnsPlayer})';
}


}

/// @nodoc
abstract mixin class $PlayerDetailResponseCopyWith<$Res>  {
  factory $PlayerDetailResponseCopyWith(PlayerDetailResponse value, $Res Function(PlayerDetailResponse) _then) = _$PlayerDetailResponseCopyWithImpl;
@useResult
$Res call({
 String? fn, String? ln, String? tn, int? shn, String? id, int? position, int? number, double? averagePoints, int? totalPoints, int? marketValue, int? marketValueTrend, String? profileBigUrl, String? teamId, int? tfhmvt, int? prlo, int? stl, int? status, bool? userOwnsPlayer
});




}
/// @nodoc
class _$PlayerDetailResponseCopyWithImpl<$Res>
    implements $PlayerDetailResponseCopyWith<$Res> {
  _$PlayerDetailResponseCopyWithImpl(this._self, this._then);

  final PlayerDetailResponse _self;
  final $Res Function(PlayerDetailResponse) _then;

/// Create a copy of PlayerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fn = freezed,Object? ln = freezed,Object? tn = freezed,Object? shn = freezed,Object? id = freezed,Object? position = freezed,Object? number = freezed,Object? averagePoints = freezed,Object? totalPoints = freezed,Object? marketValue = freezed,Object? marketValueTrend = freezed,Object? profileBigUrl = freezed,Object? teamId = freezed,Object? tfhmvt = freezed,Object? prlo = freezed,Object? stl = freezed,Object? status = freezed,Object? userOwnsPlayer = freezed,}) {
  return _then(PlayerDetailResponse(
fn: freezed == fn ? _self.fn : fn // ignore: cast_nullable_to_non_nullable
as String?,ln: freezed == ln ? _self.ln : ln // ignore: cast_nullable_to_non_nullable
as String?,tn: freezed == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String?,shn: freezed == shn ? _self.shn : shn // ignore: cast_nullable_to_non_nullable
as int?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,averagePoints: freezed == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double?,totalPoints: freezed == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int?,marketValue: freezed == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int?,marketValueTrend: freezed == marketValueTrend ? _self.marketValueTrend : marketValueTrend // ignore: cast_nullable_to_non_nullable
as int?,profileBigUrl: freezed == profileBigUrl ? _self.profileBigUrl : profileBigUrl // ignore: cast_nullable_to_non_nullable
as String?,teamId: freezed == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String?,tfhmvt: freezed == tfhmvt ? _self.tfhmvt : tfhmvt // ignore: cast_nullable_to_non_nullable
as int?,prlo: freezed == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int?,stl: freezed == stl ? _self.stl : stl // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,userOwnsPlayer: freezed == userOwnsPlayer ? _self.userOwnsPlayer : userOwnsPlayer // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerDetailResponse].
extension PlayerDetailResponsePatterns on PlayerDetailResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerDetailResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerDetailResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerDetailResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlayerDetailResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerDetailResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerDetailResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fn,  String? ln,  String? tn,  int? shn,  String? id,  int? position,  int? number,  double? averagePoints,  int? totalPoints,  int? marketValue,  int? marketValueTrend,  String? profileBigUrl,  String? teamId,  int? tfhmvt,  int? prlo,  int? stl,  int? status,  bool? userOwnsPlayer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerDetailResponse() when $default != null:
return $default(_that.fn,_that.ln,_that.tn,_that.shn,_that.id,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.profileBigUrl,_that.teamId,_that.tfhmvt,_that.prlo,_that.stl,_that.status,_that.userOwnsPlayer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fn,  String? ln,  String? tn,  int? shn,  String? id,  int? position,  int? number,  double? averagePoints,  int? totalPoints,  int? marketValue,  int? marketValueTrend,  String? profileBigUrl,  String? teamId,  int? tfhmvt,  int? prlo,  int? stl,  int? status,  bool? userOwnsPlayer)  $default,) {final _that = this;
switch (_that) {
case _PlayerDetailResponse():
return $default(_that.fn,_that.ln,_that.tn,_that.shn,_that.id,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.profileBigUrl,_that.teamId,_that.tfhmvt,_that.prlo,_that.stl,_that.status,_that.userOwnsPlayer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fn,  String? ln,  String? tn,  int? shn,  String? id,  int? position,  int? number,  double? averagePoints,  int? totalPoints,  int? marketValue,  int? marketValueTrend,  String? profileBigUrl,  String? teamId,  int? tfhmvt,  int? prlo,  int? stl,  int? status,  bool? userOwnsPlayer)?  $default,) {final _that = this;
switch (_that) {
case _PlayerDetailResponse() when $default != null:
return $default(_that.fn,_that.ln,_that.tn,_that.shn,_that.id,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.profileBigUrl,_that.teamId,_that.tfhmvt,_that.prlo,_that.stl,_that.status,_that.userOwnsPlayer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerDetailResponse implements PlayerDetailResponse {
  const _PlayerDetailResponse({this.fn, this.ln, this.tn, this.shn, this.id, this.position, this.number, this.averagePoints, this.totalPoints, this.marketValue, this.marketValueTrend, this.profileBigUrl, this.teamId, this.tfhmvt, this.prlo, this.stl, this.status, this.userOwnsPlayer});
  factory _PlayerDetailResponse.fromJson(Map<String, dynamic> json) => _$PlayerDetailResponseFromJson(json);

@override final  String? fn;
@override final  String? ln;
@override final  String? tn;
@override final  int? shn;
@override final  String? id;
@override final  int? position;
@override final  int? number;
@override final  double? averagePoints;
@override final  int? totalPoints;
@override final  int? marketValue;
@override final  int? marketValueTrend;
@override final  String? profileBigUrl;
@override final  String? teamId;
@override final  int? tfhmvt;
@override final  int? prlo;
@override final  int? stl;
@override final  int? status;
@override final  bool? userOwnsPlayer;

/// Create a copy of PlayerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerDetailResponseCopyWith<_PlayerDetailResponse> get copyWith => __$PlayerDetailResponseCopyWithImpl<_PlayerDetailResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerDetailResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerDetailResponse&&(identical(other.fn, fn) || other.fn == fn)&&(identical(other.ln, ln) || other.ln == ln)&&(identical(other.tn, tn) || other.tn == tn)&&(identical(other.shn, shn) || other.shn == shn)&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.number, number) || other.number == number)&&(identical(other.averagePoints, averagePoints) || other.averagePoints == averagePoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.marketValueTrend, marketValueTrend) || other.marketValueTrend == marketValueTrend)&&(identical(other.profileBigUrl, profileBigUrl) || other.profileBigUrl == profileBigUrl)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.tfhmvt, tfhmvt) || other.tfhmvt == tfhmvt)&&(identical(other.prlo, prlo) || other.prlo == prlo)&&(identical(other.stl, stl) || other.stl == stl)&&(identical(other.status, status) || other.status == status)&&(identical(other.userOwnsPlayer, userOwnsPlayer) || other.userOwnsPlayer == userOwnsPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fn,ln,tn,shn,id,position,number,averagePoints,totalPoints,marketValue,marketValueTrend,profileBigUrl,teamId,tfhmvt,prlo,stl,status,userOwnsPlayer);
}

@override
String toString() {
    return 'PlayerDetailResponse(fn: $fn, ln: $ln, tn: $tn, shn: $shn, id: $id, position: $position, number: $number, averagePoints: $averagePoints, totalPoints: $totalPoints, marketValue: $marketValue, marketValueTrend: $marketValueTrend, profileBigUrl: $profileBigUrl, teamId: $teamId, tfhmvt: $tfhmvt, prlo: $prlo, stl: $stl, status: $status, userOwnsPlayer: $userOwnsPlayer)';
}


}

/// @nodoc
abstract mixin class _$PlayerDetailResponseCopyWith<$Res> implements $PlayerDetailResponseCopyWith<$Res> {
  factory _$PlayerDetailResponseCopyWith(_PlayerDetailResponse value, $Res Function(_PlayerDetailResponse) _then) = __$PlayerDetailResponseCopyWithImpl;
@override @useResult
$Res call({
 String? fn, String? ln, String? tn, int? shn, String? id, int? position, int? number, double? averagePoints, int? totalPoints, int? marketValue, int? marketValueTrend, String? profileBigUrl, String? teamId, int? tfhmvt, int? prlo, int? stl, int? status, bool? userOwnsPlayer
});




}
/// @nodoc
class __$PlayerDetailResponseCopyWithImpl<$Res>
    implements _$PlayerDetailResponseCopyWith<$Res> {
  __$PlayerDetailResponseCopyWithImpl(this._self, this._then);

  final _PlayerDetailResponse _self;
  final $Res Function(_PlayerDetailResponse) _then;

/// Create a copy of PlayerDetailResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fn = freezed,Object? ln = freezed,Object? tn = freezed,Object? shn = freezed,Object? id = freezed,Object? position = freezed,Object? number = freezed,Object? averagePoints = freezed,Object? totalPoints = freezed,Object? marketValue = freezed,Object? marketValueTrend = freezed,Object? profileBigUrl = freezed,Object? teamId = freezed,Object? tfhmvt = freezed,Object? prlo = freezed,Object? stl = freezed,Object? status = freezed,Object? userOwnsPlayer = freezed,}) {
  return _then(_PlayerDetailResponse(
fn: freezed == fn ? _self.fn : fn // ignore: cast_nullable_to_non_nullable
as String?,ln: freezed == ln ? _self.ln : ln // ignore: cast_nullable_to_non_nullable
as String?,tn: freezed == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String?,shn: freezed == shn ? _self.shn : shn // ignore: cast_nullable_to_non_nullable
as int?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,averagePoints: freezed == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double?,totalPoints: freezed == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int?,marketValue: freezed == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int?,marketValueTrend: freezed == marketValueTrend ? _self.marketValueTrend : marketValueTrend // ignore: cast_nullable_to_non_nullable
as int?,profileBigUrl: freezed == profileBigUrl ? _self.profileBigUrl : profileBigUrl // ignore: cast_nullable_to_non_nullable
as String?,teamId: freezed == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String?,tfhmvt: freezed == tfhmvt ? _self.tfhmvt : tfhmvt // ignore: cast_nullable_to_non_nullable
as int?,prlo: freezed == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int?,stl: freezed == stl ? _self.stl : stl // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,userOwnsPlayer: freezed == userOwnsPlayer ? _self.userOwnsPlayer : userOwnsPlayer // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$PlayersResponse {

 List<Player> get players;
/// Create a copy of PlayersResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayersResponseCopyWith<PlayersResponse> get copyWith => _$PlayersResponseCopyWithImpl<PlayersResponse>(this as PlayersResponse, _$identity);

  /// Serializes this PlayersResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayersResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayersResponse&&const DeepCollectionEquality().equals(other.players, _this.players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayersResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.players));
}

@override
String toString() {
  final _this = this as PlayersResponse;
  return 'PlayersResponse(players: ${_this.players})';
}


}

/// @nodoc
abstract mixin class $PlayersResponseCopyWith<$Res>  {
  factory $PlayersResponseCopyWith(PlayersResponse value, $Res Function(PlayersResponse) _then) = _$PlayersResponseCopyWithImpl;
@useResult
$Res call({
 List<Player> players
});




}
/// @nodoc
class _$PlayersResponseCopyWithImpl<$Res>
    implements $PlayersResponseCopyWith<$Res> {
  _$PlayersResponseCopyWithImpl(this._self, this._then);

  final PlayersResponse _self;
  final $Res Function(PlayersResponse) _then;

/// Create a copy of PlayersResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,}) {
  return _then(PlayersResponse(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayersResponse].
extension PlayersResponsePatterns on PlayersResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayersResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayersResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayersResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlayersResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayersResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlayersResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Player> players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayersResponse() when $default != null:
return $default(_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Player> players)  $default,) {final _that = this;
switch (_that) {
case _PlayersResponse():
return $default(_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Player> players)?  $default,) {final _that = this;
switch (_that) {
case _PlayersResponse() when $default != null:
return $default(_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayersResponse implements PlayersResponse {
  const _PlayersResponse({required  List<Player> players}): _players = players;
  factory _PlayersResponse.fromJson(Map<String, dynamic> json) => _$PlayersResponseFromJson(json);

 final  List<Player> _players;
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}


/// Create a copy of PlayersResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayersResponseCopyWith<_PlayersResponse> get copyWith => __$PlayersResponseCopyWithImpl<_PlayersResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayersResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayersResponse&&const DeepCollectionEquality().equals(other.players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_players));
}

@override
String toString() {
    return 'PlayersResponse(players: $players)';
}


}

/// @nodoc
abstract mixin class _$PlayersResponseCopyWith<$Res> implements $PlayersResponseCopyWith<$Res> {
  factory _$PlayersResponseCopyWith(_PlayersResponse value, $Res Function(_PlayersResponse) _then) = __$PlayersResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Player> players
});




}
/// @nodoc
class __$PlayersResponseCopyWithImpl<$Res>
    implements _$PlayersResponseCopyWith<$Res> {
  __$PlayersResponseCopyWithImpl(this._self, this._then);

  final _PlayersResponse _self;
  final $Res Function(_PlayersResponse) _then;

/// Create a copy of PlayersResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,}) {
  return _then(_PlayersResponse(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,
  ));
}


}

// dart format on
