// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ligainsider_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LigainsiderPlayer {

 String get id; String get name; String get shortName; String get teamName; String get teamId; int get position; String get injuryStatus; String? get injuryDescription; int? get formRating; DateTime get lastUpdate; String? get statusText; DateTime? get expectedReturn; String? get alternative; String? get ligainsiderId; String? get imageUrl;
/// Create a copy of LigainsiderPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LigainsiderPlayerCopyWith<LigainsiderPlayer> get copyWith => _$LigainsiderPlayerCopyWithImpl<LigainsiderPlayer>(this as LigainsiderPlayer, _$identity);

  /// Serializes this LigainsiderPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LigainsiderPlayer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LigainsiderPlayer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.shortName, _this.shortName) || other.shortName == _this.shortName)&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.injuryStatus, _this.injuryStatus) || other.injuryStatus == _this.injuryStatus)&&(identical(other.injuryDescription, _this.injuryDescription) || other.injuryDescription == _this.injuryDescription)&&(identical(other.formRating, _this.formRating) || other.formRating == _this.formRating)&&(identical(other.lastUpdate, _this.lastUpdate) || other.lastUpdate == _this.lastUpdate)&&(identical(other.statusText, _this.statusText) || other.statusText == _this.statusText)&&(identical(other.expectedReturn, _this.expectedReturn) || other.expectedReturn == _this.expectedReturn)&&(identical(other.alternative, _this.alternative) || other.alternative == _this.alternative)&&(identical(other.ligainsiderId, _this.ligainsiderId) || other.ligainsiderId == _this.ligainsiderId)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LigainsiderPlayer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.shortName,_this.teamName,_this.teamId,_this.position,_this.injuryStatus,_this.injuryDescription,_this.formRating,_this.lastUpdate,_this.statusText,_this.expectedReturn,_this.alternative,_this.ligainsiderId,_this.imageUrl);
}

@override
String toString() {
  final _this = this as LigainsiderPlayer;
  return 'LigainsiderPlayer(id: ${_this.id}, name: ${_this.name}, shortName: ${_this.shortName}, teamName: ${_this.teamName}, teamId: ${_this.teamId}, position: ${_this.position}, injuryStatus: ${_this.injuryStatus}, injuryDescription: ${_this.injuryDescription}, formRating: ${_this.formRating}, lastUpdate: ${_this.lastUpdate}, statusText: ${_this.statusText}, expectedReturn: ${_this.expectedReturn}, alternative: ${_this.alternative}, ligainsiderId: ${_this.ligainsiderId}, imageUrl: ${_this.imageUrl})';
}


}

/// @nodoc
abstract mixin class $LigainsiderPlayerCopyWith<$Res>  {
  factory $LigainsiderPlayerCopyWith(LigainsiderPlayer value, $Res Function(LigainsiderPlayer) _then) = _$LigainsiderPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String shortName, String teamName, String teamId, int position, String injuryStatus, String? injuryDescription, int? formRating, DateTime lastUpdate, String? statusText, DateTime? expectedReturn, String? alternative, String? ligainsiderId, String? imageUrl
});




}
/// @nodoc
class _$LigainsiderPlayerCopyWithImpl<$Res>
    implements $LigainsiderPlayerCopyWith<$Res> {
  _$LigainsiderPlayerCopyWithImpl(this._self, this._then);

  final LigainsiderPlayer _self;
  final $Res Function(LigainsiderPlayer) _then;

/// Create a copy of LigainsiderPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? shortName = null,Object? teamName = null,Object? teamId = null,Object? position = null,Object? injuryStatus = null,Object? injuryDescription = freezed,Object? formRating = freezed,Object? lastUpdate = null,Object? statusText = freezed,Object? expectedReturn = freezed,Object? alternative = freezed,Object? ligainsiderId = freezed,Object? imageUrl = freezed,}) {
  return _then(LigainsiderPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortName: null == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,injuryStatus: null == injuryStatus ? _self.injuryStatus : injuryStatus // ignore: cast_nullable_to_non_nullable
as String,injuryDescription: freezed == injuryDescription ? _self.injuryDescription : injuryDescription // ignore: cast_nullable_to_non_nullable
as String?,formRating: freezed == formRating ? _self.formRating : formRating // ignore: cast_nullable_to_non_nullable
as int?,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,statusText: freezed == statusText ? _self.statusText : statusText // ignore: cast_nullable_to_non_nullable
as String?,expectedReturn: freezed == expectedReturn ? _self.expectedReturn : expectedReturn // ignore: cast_nullable_to_non_nullable
as DateTime?,alternative: freezed == alternative ? _self.alternative : alternative // ignore: cast_nullable_to_non_nullable
as String?,ligainsiderId: freezed == ligainsiderId ? _self.ligainsiderId : ligainsiderId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LigainsiderPlayer].
extension LigainsiderPlayerPatterns on LigainsiderPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LigainsiderPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LigainsiderPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LigainsiderPlayer value)  $default,){
final _that = this;
switch (_that) {
case _LigainsiderPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LigainsiderPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _LigainsiderPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String shortName,  String teamName,  String teamId,  int position,  String injuryStatus,  String? injuryDescription,  int? formRating,  DateTime lastUpdate,  String? statusText,  DateTime? expectedReturn,  String? alternative,  String? ligainsiderId,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LigainsiderPlayer() when $default != null:
return $default(_that.id,_that.name,_that.shortName,_that.teamName,_that.teamId,_that.position,_that.injuryStatus,_that.injuryDescription,_that.formRating,_that.lastUpdate,_that.statusText,_that.expectedReturn,_that.alternative,_that.ligainsiderId,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String shortName,  String teamName,  String teamId,  int position,  String injuryStatus,  String? injuryDescription,  int? formRating,  DateTime lastUpdate,  String? statusText,  DateTime? expectedReturn,  String? alternative,  String? ligainsiderId,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _LigainsiderPlayer():
return $default(_that.id,_that.name,_that.shortName,_that.teamName,_that.teamId,_that.position,_that.injuryStatus,_that.injuryDescription,_that.formRating,_that.lastUpdate,_that.statusText,_that.expectedReturn,_that.alternative,_that.ligainsiderId,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String shortName,  String teamName,  String teamId,  int position,  String injuryStatus,  String? injuryDescription,  int? formRating,  DateTime lastUpdate,  String? statusText,  DateTime? expectedReturn,  String? alternative,  String? ligainsiderId,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _LigainsiderPlayer() when $default != null:
return $default(_that.id,_that.name,_that.shortName,_that.teamName,_that.teamId,_that.position,_that.injuryStatus,_that.injuryDescription,_that.formRating,_that.lastUpdate,_that.statusText,_that.expectedReturn,_that.alternative,_that.ligainsiderId,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LigainsiderPlayer implements LigainsiderPlayer {
  const _LigainsiderPlayer({required this.id, required this.name, required this.shortName, required this.teamName, required this.teamId, required this.position, required this.injuryStatus, this.injuryDescription, this.formRating, required this.lastUpdate, this.statusText, this.expectedReturn, this.alternative, this.ligainsiderId, this.imageUrl});
  factory _LigainsiderPlayer.fromJson(Map<String, dynamic> json) => _$LigainsiderPlayerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String shortName;
@override final  String teamName;
@override final  String teamId;
@override final  int position;
@override final  String injuryStatus;
@override final  String? injuryDescription;
@override final  int? formRating;
@override final  DateTime lastUpdate;
@override final  String? statusText;
@override final  DateTime? expectedReturn;
@override final  String? alternative;
@override final  String? ligainsiderId;
@override final  String? imageUrl;

/// Create a copy of LigainsiderPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LigainsiderPlayerCopyWith<_LigainsiderPlayer> get copyWith => __$LigainsiderPlayerCopyWithImpl<_LigainsiderPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LigainsiderPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LigainsiderPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.position, position) || other.position == position)&&(identical(other.injuryStatus, injuryStatus) || other.injuryStatus == injuryStatus)&&(identical(other.injuryDescription, injuryDescription) || other.injuryDescription == injuryDescription)&&(identical(other.formRating, formRating) || other.formRating == formRating)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.statusText, statusText) || other.statusText == statusText)&&(identical(other.expectedReturn, expectedReturn) || other.expectedReturn == expectedReturn)&&(identical(other.alternative, alternative) || other.alternative == alternative)&&(identical(other.ligainsiderId, ligainsiderId) || other.ligainsiderId == ligainsiderId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,shortName,teamName,teamId,position,injuryStatus,injuryDescription,formRating,lastUpdate,statusText,expectedReturn,alternative,ligainsiderId,imageUrl);
}

@override
String toString() {
    return 'LigainsiderPlayer(id: $id, name: $name, shortName: $shortName, teamName: $teamName, teamId: $teamId, position: $position, injuryStatus: $injuryStatus, injuryDescription: $injuryDescription, formRating: $formRating, lastUpdate: $lastUpdate, statusText: $statusText, expectedReturn: $expectedReturn, alternative: $alternative, ligainsiderId: $ligainsiderId, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$LigainsiderPlayerCopyWith<$Res> implements $LigainsiderPlayerCopyWith<$Res> {
  factory _$LigainsiderPlayerCopyWith(_LigainsiderPlayer value, $Res Function(_LigainsiderPlayer) _then) = __$LigainsiderPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String shortName, String teamName, String teamId, int position, String injuryStatus, String? injuryDescription, int? formRating, DateTime lastUpdate, String? statusText, DateTime? expectedReturn, String? alternative, String? ligainsiderId, String? imageUrl
});




}
/// @nodoc
class __$LigainsiderPlayerCopyWithImpl<$Res>
    implements _$LigainsiderPlayerCopyWith<$Res> {
  __$LigainsiderPlayerCopyWithImpl(this._self, this._then);

  final _LigainsiderPlayer _self;
  final $Res Function(_LigainsiderPlayer) _then;

/// Create a copy of LigainsiderPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? shortName = null,Object? teamName = null,Object? teamId = null,Object? position = null,Object? injuryStatus = null,Object? injuryDescription = freezed,Object? formRating = freezed,Object? lastUpdate = null,Object? statusText = freezed,Object? expectedReturn = freezed,Object? alternative = freezed,Object? ligainsiderId = freezed,Object? imageUrl = freezed,}) {
  return _then(_LigainsiderPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shortName: null == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,injuryStatus: null == injuryStatus ? _self.injuryStatus : injuryStatus // ignore: cast_nullable_to_non_nullable
as String,injuryDescription: freezed == injuryDescription ? _self.injuryDescription : injuryDescription // ignore: cast_nullable_to_non_nullable
as String?,formRating: freezed == formRating ? _self.formRating : formRating // ignore: cast_nullable_to_non_nullable
as int?,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,statusText: freezed == statusText ? _self.statusText : statusText // ignore: cast_nullable_to_non_nullable
as String?,expectedReturn: freezed == expectedReturn ? _self.expectedReturn : expectedReturn // ignore: cast_nullable_to_non_nullable
as DateTime?,alternative: freezed == alternative ? _self.alternative : alternative // ignore: cast_nullable_to_non_nullable
as String?,ligainsiderId: freezed == ligainsiderId ? _self.ligainsiderId : ligainsiderId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LigainsiderStatus {

 String get playerId; String get playerName; String get statusCategory; String get statusReason; DateTime get lastUpdate;
/// Create a copy of LigainsiderStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LigainsiderStatusCopyWith<LigainsiderStatus> get copyWith => _$LigainsiderStatusCopyWithImpl<LigainsiderStatus>(this as LigainsiderStatus, _$identity);

  /// Serializes this LigainsiderStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LigainsiderStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LigainsiderStatus&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.statusCategory, _this.statusCategory) || other.statusCategory == _this.statusCategory)&&(identical(other.statusReason, _this.statusReason) || other.statusReason == _this.statusReason)&&(identical(other.lastUpdate, _this.lastUpdate) || other.lastUpdate == _this.lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LigainsiderStatus;
  return Object.hash(runtimeType,_this.playerId,_this.playerName,_this.statusCategory,_this.statusReason,_this.lastUpdate);
}

@override
String toString() {
  final _this = this as LigainsiderStatus;
  return 'LigainsiderStatus(playerId: ${_this.playerId}, playerName: ${_this.playerName}, statusCategory: ${_this.statusCategory}, statusReason: ${_this.statusReason}, lastUpdate: ${_this.lastUpdate})';
}


}

/// @nodoc
abstract mixin class $LigainsiderStatusCopyWith<$Res>  {
  factory $LigainsiderStatusCopyWith(LigainsiderStatus value, $Res Function(LigainsiderStatus) _then) = _$LigainsiderStatusCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, String statusCategory, String statusReason, DateTime lastUpdate
});




}
/// @nodoc
class _$LigainsiderStatusCopyWithImpl<$Res>
    implements $LigainsiderStatusCopyWith<$Res> {
  _$LigainsiderStatusCopyWithImpl(this._self, this._then);

  final LigainsiderStatus _self;
  final $Res Function(LigainsiderStatus) _then;

/// Create a copy of LigainsiderStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? statusCategory = null,Object? statusReason = null,Object? lastUpdate = null,}) {
  return _then(LigainsiderStatus(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,statusCategory: null == statusCategory ? _self.statusCategory : statusCategory // ignore: cast_nullable_to_non_nullable
as String,statusReason: null == statusReason ? _self.statusReason : statusReason // ignore: cast_nullable_to_non_nullable
as String,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LigainsiderStatus].
extension LigainsiderStatusPatterns on LigainsiderStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LigainsiderStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LigainsiderStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LigainsiderStatus value)  $default,){
final _that = this;
switch (_that) {
case _LigainsiderStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LigainsiderStatus value)?  $default,){
final _that = this;
switch (_that) {
case _LigainsiderStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String statusCategory,  String statusReason,  DateTime lastUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LigainsiderStatus() when $default != null:
return $default(_that.playerId,_that.playerName,_that.statusCategory,_that.statusReason,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String statusCategory,  String statusReason,  DateTime lastUpdate)  $default,) {final _that = this;
switch (_that) {
case _LigainsiderStatus():
return $default(_that.playerId,_that.playerName,_that.statusCategory,_that.statusReason,_that.lastUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  String statusCategory,  String statusReason,  DateTime lastUpdate)?  $default,) {final _that = this;
switch (_that) {
case _LigainsiderStatus() when $default != null:
return $default(_that.playerId,_that.playerName,_that.statusCategory,_that.statusReason,_that.lastUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LigainsiderStatus implements LigainsiderStatus {
  const _LigainsiderStatus({required this.playerId, required this.playerName, required this.statusCategory, required this.statusReason, required this.lastUpdate});
  factory _LigainsiderStatus.fromJson(Map<String, dynamic> json) => _$LigainsiderStatusFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  String statusCategory;
@override final  String statusReason;
@override final  DateTime lastUpdate;

/// Create a copy of LigainsiderStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LigainsiderStatusCopyWith<_LigainsiderStatus> get copyWith => __$LigainsiderStatusCopyWithImpl<_LigainsiderStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LigainsiderStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LigainsiderStatus&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.statusCategory, statusCategory) || other.statusCategory == statusCategory)&&(identical(other.statusReason, statusReason) || other.statusReason == statusReason)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,playerId,playerName,statusCategory,statusReason,lastUpdate);
}

@override
String toString() {
    return 'LigainsiderStatus(playerId: $playerId, playerName: $playerName, statusCategory: $statusCategory, statusReason: $statusReason, lastUpdate: $lastUpdate)';
}


}

/// @nodoc
abstract mixin class _$LigainsiderStatusCopyWith<$Res> implements $LigainsiderStatusCopyWith<$Res> {
  factory _$LigainsiderStatusCopyWith(_LigainsiderStatus value, $Res Function(_LigainsiderStatus) _then) = __$LigainsiderStatusCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, String statusCategory, String statusReason, DateTime lastUpdate
});




}
/// @nodoc
class __$LigainsiderStatusCopyWithImpl<$Res>
    implements _$LigainsiderStatusCopyWith<$Res> {
  __$LigainsiderStatusCopyWithImpl(this._self, this._then);

  final _LigainsiderStatus _self;
  final $Res Function(_LigainsiderStatus) _then;

/// Create a copy of LigainsiderStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? statusCategory = null,Object? statusReason = null,Object? lastUpdate = null,}) {
  return _then(_LigainsiderStatus(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,statusCategory: null == statusCategory ? _self.statusCategory : statusCategory // ignore: cast_nullable_to_non_nullable
as String,statusReason: null == statusReason ? _self.statusReason : statusReason // ignore: cast_nullable_to_non_nullable
as String,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$LigainsiderResponse {

 List<LigainsiderPlayer> get players; DateTime get lastUpdate; int? get totalInjured; int? get totalQuestionable;
/// Create a copy of LigainsiderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LigainsiderResponseCopyWith<LigainsiderResponse> get copyWith => _$LigainsiderResponseCopyWithImpl<LigainsiderResponse>(this as LigainsiderResponse, _$identity);

  /// Serializes this LigainsiderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LigainsiderResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LigainsiderResponse&&const DeepCollectionEquality().equals(other.players, _this.players)&&(identical(other.lastUpdate, _this.lastUpdate) || other.lastUpdate == _this.lastUpdate)&&(identical(other.totalInjured, _this.totalInjured) || other.totalInjured == _this.totalInjured)&&(identical(other.totalQuestionable, _this.totalQuestionable) || other.totalQuestionable == _this.totalQuestionable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LigainsiderResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.players),_this.lastUpdate,_this.totalInjured,_this.totalQuestionable);
}

@override
String toString() {
  final _this = this as LigainsiderResponse;
  return 'LigainsiderResponse(players: ${_this.players}, lastUpdate: ${_this.lastUpdate}, totalInjured: ${_this.totalInjured}, totalQuestionable: ${_this.totalQuestionable})';
}


}

/// @nodoc
abstract mixin class $LigainsiderResponseCopyWith<$Res>  {
  factory $LigainsiderResponseCopyWith(LigainsiderResponse value, $Res Function(LigainsiderResponse) _then) = _$LigainsiderResponseCopyWithImpl;
@useResult
$Res call({
 List<LigainsiderPlayer> players, DateTime lastUpdate, int? totalInjured, int? totalQuestionable
});




}
/// @nodoc
class _$LigainsiderResponseCopyWithImpl<$Res>
    implements $LigainsiderResponseCopyWith<$Res> {
  _$LigainsiderResponseCopyWithImpl(this._self, this._then);

  final LigainsiderResponse _self;
  final $Res Function(LigainsiderResponse) _then;

/// Create a copy of LigainsiderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? lastUpdate = null,Object? totalInjured = freezed,Object? totalQuestionable = freezed,}) {
  return _then(LigainsiderResponse(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<LigainsiderPlayer>,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,totalInjured: freezed == totalInjured ? _self.totalInjured : totalInjured // ignore: cast_nullable_to_non_nullable
as int?,totalQuestionable: freezed == totalQuestionable ? _self.totalQuestionable : totalQuestionable // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LigainsiderResponse].
extension LigainsiderResponsePatterns on LigainsiderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LigainsiderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LigainsiderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LigainsiderResponse value)  $default,){
final _that = this;
switch (_that) {
case _LigainsiderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LigainsiderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LigainsiderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LigainsiderPlayer> players,  DateTime lastUpdate,  int? totalInjured,  int? totalQuestionable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LigainsiderResponse() when $default != null:
return $default(_that.players,_that.lastUpdate,_that.totalInjured,_that.totalQuestionable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LigainsiderPlayer> players,  DateTime lastUpdate,  int? totalInjured,  int? totalQuestionable)  $default,) {final _that = this;
switch (_that) {
case _LigainsiderResponse():
return $default(_that.players,_that.lastUpdate,_that.totalInjured,_that.totalQuestionable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LigainsiderPlayer> players,  DateTime lastUpdate,  int? totalInjured,  int? totalQuestionable)?  $default,) {final _that = this;
switch (_that) {
case _LigainsiderResponse() when $default != null:
return $default(_that.players,_that.lastUpdate,_that.totalInjured,_that.totalQuestionable);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LigainsiderResponse implements LigainsiderResponse {
  const _LigainsiderResponse({required  List<LigainsiderPlayer> players, required this.lastUpdate, this.totalInjured, this.totalQuestionable}): _players = players;
  factory _LigainsiderResponse.fromJson(Map<String, dynamic> json) => _$LigainsiderResponseFromJson(json);

 final  List<LigainsiderPlayer> _players;
@override List<LigainsiderPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  DateTime lastUpdate;
@override final  int? totalInjured;
@override final  int? totalQuestionable;

/// Create a copy of LigainsiderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LigainsiderResponseCopyWith<_LigainsiderResponse> get copyWith => __$LigainsiderResponseCopyWithImpl<_LigainsiderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LigainsiderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LigainsiderResponse&&const DeepCollectionEquality().equals(other.players, _players)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.totalInjured, totalInjured) || other.totalInjured == totalInjured)&&(identical(other.totalQuestionable, totalQuestionable) || other.totalQuestionable == totalQuestionable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),lastUpdate,totalInjured,totalQuestionable);
}

@override
String toString() {
    return 'LigainsiderResponse(players: $players, lastUpdate: $lastUpdate, totalInjured: $totalInjured, totalQuestionable: $totalQuestionable)';
}


}

/// @nodoc
abstract mixin class _$LigainsiderResponseCopyWith<$Res> implements $LigainsiderResponseCopyWith<$Res> {
  factory _$LigainsiderResponseCopyWith(_LigainsiderResponse value, $Res Function(_LigainsiderResponse) _then) = __$LigainsiderResponseCopyWithImpl;
@override @useResult
$Res call({
 List<LigainsiderPlayer> players, DateTime lastUpdate, int? totalInjured, int? totalQuestionable
});




}
/// @nodoc
class __$LigainsiderResponseCopyWithImpl<$Res>
    implements _$LigainsiderResponseCopyWith<$Res> {
  __$LigainsiderResponseCopyWithImpl(this._self, this._then);

  final _LigainsiderResponse _self;
  final $Res Function(_LigainsiderResponse) _then;

/// Create a copy of LigainsiderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? lastUpdate = null,Object? totalInjured = freezed,Object? totalQuestionable = freezed,}) {
  return _then(_LigainsiderResponse(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<LigainsiderPlayer>,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as DateTime,totalInjured: freezed == totalInjured ? _self.totalInjured : totalInjured // ignore: cast_nullable_to_non_nullable
as int?,totalQuestionable: freezed == totalQuestionable ? _self.totalQuestionable : totalQuestionable // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$InjuryReport {

 String get playerId; String get playerName; String get injuryType; String get severity; DateTime get injuryDate; DateTime? get expectedReturnDate; String get source; String get status;
/// Create a copy of InjuryReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InjuryReportCopyWith<InjuryReport> get copyWith => _$InjuryReportCopyWithImpl<InjuryReport>(this as InjuryReport, _$identity);

  /// Serializes this InjuryReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InjuryReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InjuryReport&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.injuryType, _this.injuryType) || other.injuryType == _this.injuryType)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.injuryDate, _this.injuryDate) || other.injuryDate == _this.injuryDate)&&(identical(other.expectedReturnDate, _this.expectedReturnDate) || other.expectedReturnDate == _this.expectedReturnDate)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InjuryReport;
  return Object.hash(runtimeType,_this.playerId,_this.playerName,_this.injuryType,_this.severity,_this.injuryDate,_this.expectedReturnDate,_this.source,_this.status);
}

@override
String toString() {
  final _this = this as InjuryReport;
  return 'InjuryReport(playerId: ${_this.playerId}, playerName: ${_this.playerName}, injuryType: ${_this.injuryType}, severity: ${_this.severity}, injuryDate: ${_this.injuryDate}, expectedReturnDate: ${_this.expectedReturnDate}, source: ${_this.source}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $InjuryReportCopyWith<$Res>  {
  factory $InjuryReportCopyWith(InjuryReport value, $Res Function(InjuryReport) _then) = _$InjuryReportCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, String injuryType, String severity, DateTime injuryDate, DateTime? expectedReturnDate, String source, String status
});




}
/// @nodoc
class _$InjuryReportCopyWithImpl<$Res>
    implements $InjuryReportCopyWith<$Res> {
  _$InjuryReportCopyWithImpl(this._self, this._then);

  final InjuryReport _self;
  final $Res Function(InjuryReport) _then;

/// Create a copy of InjuryReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? injuryType = null,Object? severity = null,Object? injuryDate = null,Object? expectedReturnDate = freezed,Object? source = null,Object? status = null,}) {
  return _then(InjuryReport(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,injuryType: null == injuryType ? _self.injuryType : injuryType // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,injuryDate: null == injuryDate ? _self.injuryDate : injuryDate // ignore: cast_nullable_to_non_nullable
as DateTime,expectedReturnDate: freezed == expectedReturnDate ? _self.expectedReturnDate : expectedReturnDate // ignore: cast_nullable_to_non_nullable
as DateTime?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InjuryReport].
extension InjuryReportPatterns on InjuryReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InjuryReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InjuryReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InjuryReport value)  $default,){
final _that = this;
switch (_that) {
case _InjuryReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InjuryReport value)?  $default,){
final _that = this;
switch (_that) {
case _InjuryReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String injuryType,  String severity,  DateTime injuryDate,  DateTime? expectedReturnDate,  String source,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InjuryReport() when $default != null:
return $default(_that.playerId,_that.playerName,_that.injuryType,_that.severity,_that.injuryDate,_that.expectedReturnDate,_that.source,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String injuryType,  String severity,  DateTime injuryDate,  DateTime? expectedReturnDate,  String source,  String status)  $default,) {final _that = this;
switch (_that) {
case _InjuryReport():
return $default(_that.playerId,_that.playerName,_that.injuryType,_that.severity,_that.injuryDate,_that.expectedReturnDate,_that.source,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  String injuryType,  String severity,  DateTime injuryDate,  DateTime? expectedReturnDate,  String source,  String status)?  $default,) {final _that = this;
switch (_that) {
case _InjuryReport() when $default != null:
return $default(_that.playerId,_that.playerName,_that.injuryType,_that.severity,_that.injuryDate,_that.expectedReturnDate,_that.source,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InjuryReport implements InjuryReport {
  const _InjuryReport({required this.playerId, required this.playerName, required this.injuryType, required this.severity, required this.injuryDate, this.expectedReturnDate, required this.source, required this.status});
  factory _InjuryReport.fromJson(Map<String, dynamic> json) => _$InjuryReportFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  String injuryType;
@override final  String severity;
@override final  DateTime injuryDate;
@override final  DateTime? expectedReturnDate;
@override final  String source;
@override final  String status;

/// Create a copy of InjuryReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InjuryReportCopyWith<_InjuryReport> get copyWith => __$InjuryReportCopyWithImpl<_InjuryReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InjuryReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InjuryReport&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.injuryType, injuryType) || other.injuryType == injuryType)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.injuryDate, injuryDate) || other.injuryDate == injuryDate)&&(identical(other.expectedReturnDate, expectedReturnDate) || other.expectedReturnDate == expectedReturnDate)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,playerId,playerName,injuryType,severity,injuryDate,expectedReturnDate,source,status);
}

@override
String toString() {
    return 'InjuryReport(playerId: $playerId, playerName: $playerName, injuryType: $injuryType, severity: $severity, injuryDate: $injuryDate, expectedReturnDate: $expectedReturnDate, source: $source, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InjuryReportCopyWith<$Res> implements $InjuryReportCopyWith<$Res> {
  factory _$InjuryReportCopyWith(_InjuryReport value, $Res Function(_InjuryReport) _then) = __$InjuryReportCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, String injuryType, String severity, DateTime injuryDate, DateTime? expectedReturnDate, String source, String status
});




}
/// @nodoc
class __$InjuryReportCopyWithImpl<$Res>
    implements _$InjuryReportCopyWith<$Res> {
  __$InjuryReportCopyWithImpl(this._self, this._then);

  final _InjuryReport _self;
  final $Res Function(_InjuryReport) _then;

/// Create a copy of InjuryReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? injuryType = null,Object? severity = null,Object? injuryDate = null,Object? expectedReturnDate = freezed,Object? source = null,Object? status = null,}) {
  return _then(_InjuryReport(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,injuryType: null == injuryType ? _self.injuryType : injuryType // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,injuryDate: null == injuryDate ? _self.injuryDate : injuryDate // ignore: cast_nullable_to_non_nullable
as DateTime,expectedReturnDate: freezed == expectedReturnDate ? _self.expectedReturnDate : expectedReturnDate // ignore: cast_nullable_to_non_nullable
as DateTime?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
