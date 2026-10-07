// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LineupResponse {

@JsonKey(name: 'it') List<LineupPlayer> get players;
/// Create a copy of LineupResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineupResponseCopyWith<LineupResponse> get copyWith => _$LineupResponseCopyWithImpl<LineupResponse>(this as LineupResponse, _$identity);

  /// Serializes this LineupResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LineupResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineupResponse&&const DeepCollectionEquality().equals(other.players, _this.players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LineupResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.players));
}

@override
String toString() {
  final _this = this as LineupResponse;
  return 'LineupResponse(players: ${_this.players})';
}


}

/// @nodoc
abstract mixin class $LineupResponseCopyWith<$Res>  {
  factory $LineupResponseCopyWith(LineupResponse value, $Res Function(LineupResponse) _then) = _$LineupResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'it') List<LineupPlayer> players
});




}
/// @nodoc
class _$LineupResponseCopyWithImpl<$Res>
    implements $LineupResponseCopyWith<$Res> {
  _$LineupResponseCopyWithImpl(this._self, this._then);

  final LineupResponse _self;
  final $Res Function(LineupResponse) _then;

/// Create a copy of LineupResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,}) {
  return _then(LineupResponse(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<LineupPlayer>,
  ));
}

}


/// Adds pattern-matching-related methods to [LineupResponse].
extension LineupResponsePatterns on LineupResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineupResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineupResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineupResponse value)  $default,){
final _that = this;
switch (_that) {
case _LineupResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineupResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LineupResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'it')  List<LineupPlayer> players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineupResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'it')  List<LineupPlayer> players)  $default,) {final _that = this;
switch (_that) {
case _LineupResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'it')  List<LineupPlayer> players)?  $default,) {final _that = this;
switch (_that) {
case _LineupResponse() when $default != null:
return $default(_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineupResponse implements LineupResponse {
  const _LineupResponse({@JsonKey(name: 'it') required  List<LineupPlayer> players}): _players = players;
  factory _LineupResponse.fromJson(Map<String, dynamic> json) => _$LineupResponseFromJson(json);

 final  List<LineupPlayer> _players;
@override@JsonKey(name: 'it') List<LineupPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}


/// Create a copy of LineupResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineupResponseCopyWith<_LineupResponse> get copyWith => __$LineupResponseCopyWithImpl<_LineupResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineupResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineupResponse&&const DeepCollectionEquality().equals(other.players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_players));
}

@override
String toString() {
    return 'LineupResponse(players: $players)';
}


}

/// @nodoc
abstract mixin class _$LineupResponseCopyWith<$Res> implements $LineupResponseCopyWith<$Res> {
  factory _$LineupResponseCopyWith(_LineupResponse value, $Res Function(_LineupResponse) _then) = __$LineupResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'it') List<LineupPlayer> players
});




}
/// @nodoc
class __$LineupResponseCopyWithImpl<$Res>
    implements _$LineupResponseCopyWith<$Res> {
  __$LineupResponseCopyWithImpl(this._self, this._then);

  final _LineupResponse _self;
  final $Res Function(_LineupResponse) _then;

/// Create a copy of LineupResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,}) {
  return _then(_LineupResponse(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<LineupPlayer>,
  ));
}


}


/// @nodoc
mixin _$LineupPlayer {

/// Player ID
@JsonKey(name: 'i') String get id;/// Player name
@JsonKey(name: 'n') String get name;/// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
@JsonKey(name: 'pos') int get position;/// Team ID
@JsonKey(name: 'tid') String get teamId;/// Average points
@JsonKey(name: 'ap') int get averagePoints;/// Total points
@JsonKey(name: 'st') int get totalPoints;/// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
@JsonKey(name: 'mdst') int get matchDayStatus;/// Lineup order (0 means on bench/not in lineup)
@JsonKey(name: 'lo') int get lineupOrder;/// Last total points
@JsonKey(name: 'lst') int get lastTotalPoints;/// Has today (if player plays today)
@JsonKey(name: 'ht') bool get hasToday;/// Original status (e.g., injury/suspension info)
@JsonKey(name: 'os') String? get originalStatus;/// Performance history
@JsonKey(name: 'ph') List<PerformanceHistory>? get performanceHistory;
/// Create a copy of LineupPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineupPlayerCopyWith<LineupPlayer> get copyWith => _$LineupPlayerCopyWithImpl<LineupPlayer>(this as LineupPlayer, _$identity);

  /// Serializes this LineupPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LineupPlayer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineupPlayer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.averagePoints, _this.averagePoints) || other.averagePoints == _this.averagePoints)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.matchDayStatus, _this.matchDayStatus) || other.matchDayStatus == _this.matchDayStatus)&&(identical(other.lineupOrder, _this.lineupOrder) || other.lineupOrder == _this.lineupOrder)&&(identical(other.lastTotalPoints, _this.lastTotalPoints) || other.lastTotalPoints == _this.lastTotalPoints)&&(identical(other.hasToday, _this.hasToday) || other.hasToday == _this.hasToday)&&(identical(other.originalStatus, _this.originalStatus) || other.originalStatus == _this.originalStatus)&&const DeepCollectionEquality().equals(other.performanceHistory, _this.performanceHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LineupPlayer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.position,_this.teamId,_this.averagePoints,_this.totalPoints,_this.matchDayStatus,_this.lineupOrder,_this.lastTotalPoints,_this.hasToday,_this.originalStatus,const DeepCollectionEquality().hash(_this.performanceHistory));
}

@override
String toString() {
  final _this = this as LineupPlayer;
  return 'LineupPlayer(id: ${_this.id}, name: ${_this.name}, position: ${_this.position}, teamId: ${_this.teamId}, averagePoints: ${_this.averagePoints}, totalPoints: ${_this.totalPoints}, matchDayStatus: ${_this.matchDayStatus}, lineupOrder: ${_this.lineupOrder}, lastTotalPoints: ${_this.lastTotalPoints}, hasToday: ${_this.hasToday}, originalStatus: ${_this.originalStatus}, performanceHistory: ${_this.performanceHistory})';
}


}

/// @nodoc
abstract mixin class $LineupPlayerCopyWith<$Res>  {
  factory $LineupPlayerCopyWith(LineupPlayer value, $Res Function(LineupPlayer) _then) = _$LineupPlayerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'i') String id,@JsonKey(name: 'n') String name,@JsonKey(name: 'pos') int position,@JsonKey(name: 'tid') String teamId,@JsonKey(name: 'ap') int averagePoints,@JsonKey(name: 'st') int totalPoints,@JsonKey(name: 'mdst') int matchDayStatus,@JsonKey(name: 'lo') int lineupOrder,@JsonKey(name: 'lst') int lastTotalPoints,@JsonKey(name: 'ht') bool hasToday,@JsonKey(name: 'os') String? originalStatus,@JsonKey(name: 'ph') List<PerformanceHistory>? performanceHistory
});




}
/// @nodoc
class _$LineupPlayerCopyWithImpl<$Res>
    implements $LineupPlayerCopyWith<$Res> {
  _$LineupPlayerCopyWithImpl(this._self, this._then);

  final LineupPlayer _self;
  final $Res Function(LineupPlayer) _then;

/// Create a copy of LineupPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? position = null,Object? teamId = null,Object? averagePoints = null,Object? totalPoints = null,Object? matchDayStatus = null,Object? lineupOrder = null,Object? lastTotalPoints = null,Object? hasToday = null,Object? originalStatus = freezed,Object? performanceHistory = freezed,}) {
  return _then(LineupPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,matchDayStatus: null == matchDayStatus ? _self.matchDayStatus : matchDayStatus // ignore: cast_nullable_to_non_nullable
as int,lineupOrder: null == lineupOrder ? _self.lineupOrder : lineupOrder // ignore: cast_nullable_to_non_nullable
as int,lastTotalPoints: null == lastTotalPoints ? _self.lastTotalPoints : lastTotalPoints // ignore: cast_nullable_to_non_nullable
as int,hasToday: null == hasToday ? _self.hasToday : hasToday // ignore: cast_nullable_to_non_nullable
as bool,originalStatus: freezed == originalStatus ? _self.originalStatus : originalStatus // ignore: cast_nullable_to_non_nullable
as String?,performanceHistory: freezed == performanceHistory ? _self.performanceHistory : performanceHistory // ignore: cast_nullable_to_non_nullable
as List<PerformanceHistory>?,
  ));
}

}


/// Adds pattern-matching-related methods to [LineupPlayer].
extension LineupPlayerPatterns on LineupPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineupPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineupPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineupPlayer value)  $default,){
final _that = this;
switch (_that) {
case _LineupPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineupPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _LineupPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'i')  String id, @JsonKey(name: 'n')  String name, @JsonKey(name: 'pos')  int position, @JsonKey(name: 'tid')  String teamId, @JsonKey(name: 'ap')  int averagePoints, @JsonKey(name: 'st')  int totalPoints, @JsonKey(name: 'mdst')  int matchDayStatus, @JsonKey(name: 'lo')  int lineupOrder, @JsonKey(name: 'lst')  int lastTotalPoints, @JsonKey(name: 'ht')  bool hasToday, @JsonKey(name: 'os')  String? originalStatus, @JsonKey(name: 'ph')  List<PerformanceHistory>? performanceHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineupPlayer() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.teamId,_that.averagePoints,_that.totalPoints,_that.matchDayStatus,_that.lineupOrder,_that.lastTotalPoints,_that.hasToday,_that.originalStatus,_that.performanceHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'i')  String id, @JsonKey(name: 'n')  String name, @JsonKey(name: 'pos')  int position, @JsonKey(name: 'tid')  String teamId, @JsonKey(name: 'ap')  int averagePoints, @JsonKey(name: 'st')  int totalPoints, @JsonKey(name: 'mdst')  int matchDayStatus, @JsonKey(name: 'lo')  int lineupOrder, @JsonKey(name: 'lst')  int lastTotalPoints, @JsonKey(name: 'ht')  bool hasToday, @JsonKey(name: 'os')  String? originalStatus, @JsonKey(name: 'ph')  List<PerformanceHistory>? performanceHistory)  $default,) {final _that = this;
switch (_that) {
case _LineupPlayer():
return $default(_that.id,_that.name,_that.position,_that.teamId,_that.averagePoints,_that.totalPoints,_that.matchDayStatus,_that.lineupOrder,_that.lastTotalPoints,_that.hasToday,_that.originalStatus,_that.performanceHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'i')  String id, @JsonKey(name: 'n')  String name, @JsonKey(name: 'pos')  int position, @JsonKey(name: 'tid')  String teamId, @JsonKey(name: 'ap')  int averagePoints, @JsonKey(name: 'st')  int totalPoints, @JsonKey(name: 'mdst')  int matchDayStatus, @JsonKey(name: 'lo')  int lineupOrder, @JsonKey(name: 'lst')  int lastTotalPoints, @JsonKey(name: 'ht')  bool hasToday, @JsonKey(name: 'os')  String? originalStatus, @JsonKey(name: 'ph')  List<PerformanceHistory>? performanceHistory)?  $default,) {final _that = this;
switch (_that) {
case _LineupPlayer() when $default != null:
return $default(_that.id,_that.name,_that.position,_that.teamId,_that.averagePoints,_that.totalPoints,_that.matchDayStatus,_that.lineupOrder,_that.lastTotalPoints,_that.hasToday,_that.originalStatus,_that.performanceHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineupPlayer implements LineupPlayer {
  const _LineupPlayer({@JsonKey(name: 'i') required this.id, @JsonKey(name: 'n') required this.name, @JsonKey(name: 'pos') this.position = 0, @JsonKey(name: 'tid') this.teamId = '', @JsonKey(name: 'ap') this.averagePoints = 0, @JsonKey(name: 'st') this.totalPoints = 0, @JsonKey(name: 'mdst') this.matchDayStatus = 0, @JsonKey(name: 'lo') this.lineupOrder = 0, @JsonKey(name: 'lst') this.lastTotalPoints = 0, @JsonKey(name: 'ht') this.hasToday = false, @JsonKey(name: 'os') this.originalStatus, @JsonKey(name: 'ph')  List<PerformanceHistory>? performanceHistory}): _performanceHistory = performanceHistory;
  factory _LineupPlayer.fromJson(Map<String, dynamic> json) => _$LineupPlayerFromJson(json);

/// Player ID
@override@JsonKey(name: 'i') final  String id;
/// Player name
@override@JsonKey(name: 'n') final  String name;
/// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
@override@JsonKey(name: 'pos') final  int position;
/// Team ID
@override@JsonKey(name: 'tid') final  String teamId;
/// Average points
@override@JsonKey(name: 'ap') final  int averagePoints;
/// Total points
@override@JsonKey(name: 'st') final  int totalPoints;
/// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
@override@JsonKey(name: 'mdst') final  int matchDayStatus;
/// Lineup order (0 means on bench/not in lineup)
@override@JsonKey(name: 'lo') final  int lineupOrder;
/// Last total points
@override@JsonKey(name: 'lst') final  int lastTotalPoints;
/// Has today (if player plays today)
@override@JsonKey(name: 'ht') final  bool hasToday;
/// Original status (e.g., injury/suspension info)
@override@JsonKey(name: 'os') final  String? originalStatus;
/// Performance history
 final  List<PerformanceHistory>? _performanceHistory;
/// Performance history
@override@JsonKey(name: 'ph') List<PerformanceHistory>? get performanceHistory {
  final value = _performanceHistory;
  if (value == null) return null;
  if (_performanceHistory is EqualUnmodifiableListView) return _performanceHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LineupPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineupPlayerCopyWith<_LineupPlayer> get copyWith => __$LineupPlayerCopyWithImpl<_LineupPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineupPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineupPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.averagePoints, averagePoints) || other.averagePoints == averagePoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.matchDayStatus, matchDayStatus) || other.matchDayStatus == matchDayStatus)&&(identical(other.lineupOrder, lineupOrder) || other.lineupOrder == lineupOrder)&&(identical(other.lastTotalPoints, lastTotalPoints) || other.lastTotalPoints == lastTotalPoints)&&(identical(other.hasToday, hasToday) || other.hasToday == hasToday)&&(identical(other.originalStatus, originalStatus) || other.originalStatus == originalStatus)&&const DeepCollectionEquality().equals(other.performanceHistory, _performanceHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,position,teamId,averagePoints,totalPoints,matchDayStatus,lineupOrder,lastTotalPoints,hasToday,originalStatus,const DeepCollectionEquality().hash(_performanceHistory));
}

@override
String toString() {
    return 'LineupPlayer(id: $id, name: $name, position: $position, teamId: $teamId, averagePoints: $averagePoints, totalPoints: $totalPoints, matchDayStatus: $matchDayStatus, lineupOrder: $lineupOrder, lastTotalPoints: $lastTotalPoints, hasToday: $hasToday, originalStatus: $originalStatus, performanceHistory: $performanceHistory)';
}


}

/// @nodoc
abstract mixin class _$LineupPlayerCopyWith<$Res> implements $LineupPlayerCopyWith<$Res> {
  factory _$LineupPlayerCopyWith(_LineupPlayer value, $Res Function(_LineupPlayer) _then) = __$LineupPlayerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'i') String id,@JsonKey(name: 'n') String name,@JsonKey(name: 'pos') int position,@JsonKey(name: 'tid') String teamId,@JsonKey(name: 'ap') int averagePoints,@JsonKey(name: 'st') int totalPoints,@JsonKey(name: 'mdst') int matchDayStatus,@JsonKey(name: 'lo') int lineupOrder,@JsonKey(name: 'lst') int lastTotalPoints,@JsonKey(name: 'ht') bool hasToday,@JsonKey(name: 'os') String? originalStatus,@JsonKey(name: 'ph') List<PerformanceHistory>? performanceHistory
});




}
/// @nodoc
class __$LineupPlayerCopyWithImpl<$Res>
    implements _$LineupPlayerCopyWith<$Res> {
  __$LineupPlayerCopyWithImpl(this._self, this._then);

  final _LineupPlayer _self;
  final $Res Function(_LineupPlayer) _then;

/// Create a copy of LineupPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? position = null,Object? teamId = null,Object? averagePoints = null,Object? totalPoints = null,Object? matchDayStatus = null,Object? lineupOrder = null,Object? lastTotalPoints = null,Object? hasToday = null,Object? originalStatus = freezed,Object? performanceHistory = freezed,}) {
  return _then(_LineupPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,matchDayStatus: null == matchDayStatus ? _self.matchDayStatus : matchDayStatus // ignore: cast_nullable_to_non_nullable
as int,lineupOrder: null == lineupOrder ? _self.lineupOrder : lineupOrder // ignore: cast_nullable_to_non_nullable
as int,lastTotalPoints: null == lastTotalPoints ? _self.lastTotalPoints : lastTotalPoints // ignore: cast_nullable_to_non_nullable
as int,hasToday: null == hasToday ? _self.hasToday : hasToday // ignore: cast_nullable_to_non_nullable
as bool,originalStatus: freezed == originalStatus ? _self.originalStatus : originalStatus // ignore: cast_nullable_to_non_nullable
as String?,performanceHistory: freezed == performanceHistory ? _self._performanceHistory : performanceHistory // ignore: cast_nullable_to_non_nullable
as List<PerformanceHistory>?,
  ));
}


}


/// @nodoc
mixin _$PerformanceHistory {

/// Points
@JsonKey(name: 'p') int get points;/// Has played (if player played in this match)
@JsonKey(name: 'hp') bool get hasPlayed;
/// Create a copy of PerformanceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PerformanceHistoryCopyWith<PerformanceHistory> get copyWith => _$PerformanceHistoryCopyWithImpl<PerformanceHistory>(this as PerformanceHistory, _$identity);

  /// Serializes this PerformanceHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PerformanceHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PerformanceHistory&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.hasPlayed, _this.hasPlayed) || other.hasPlayed == _this.hasPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PerformanceHistory;
  return Object.hash(runtimeType,_this.points,_this.hasPlayed);
}

@override
String toString() {
  final _this = this as PerformanceHistory;
  return 'PerformanceHistory(points: ${_this.points}, hasPlayed: ${_this.hasPlayed})';
}


}

/// @nodoc
abstract mixin class $PerformanceHistoryCopyWith<$Res>  {
  factory $PerformanceHistoryCopyWith(PerformanceHistory value, $Res Function(PerformanceHistory) _then) = _$PerformanceHistoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'p') int points,@JsonKey(name: 'hp') bool hasPlayed
});




}
/// @nodoc
class _$PerformanceHistoryCopyWithImpl<$Res>
    implements $PerformanceHistoryCopyWith<$Res> {
  _$PerformanceHistoryCopyWithImpl(this._self, this._then);

  final PerformanceHistory _self;
  final $Res Function(PerformanceHistory) _then;

/// Create a copy of PerformanceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? hasPlayed = null,}) {
  return _then(PerformanceHistory(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,hasPlayed: null == hasPlayed ? _self.hasPlayed : hasPlayed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PerformanceHistory].
extension PerformanceHistoryPatterns on PerformanceHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PerformanceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PerformanceHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PerformanceHistory value)  $default,){
final _that = this;
switch (_that) {
case _PerformanceHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PerformanceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PerformanceHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'p')  int points, @JsonKey(name: 'hp')  bool hasPlayed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PerformanceHistory() when $default != null:
return $default(_that.points,_that.hasPlayed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'p')  int points, @JsonKey(name: 'hp')  bool hasPlayed)  $default,) {final _that = this;
switch (_that) {
case _PerformanceHistory():
return $default(_that.points,_that.hasPlayed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'p')  int points, @JsonKey(name: 'hp')  bool hasPlayed)?  $default,) {final _that = this;
switch (_that) {
case _PerformanceHistory() when $default != null:
return $default(_that.points,_that.hasPlayed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PerformanceHistory implements PerformanceHistory {
  const _PerformanceHistory({@JsonKey(name: 'p') this.points = 0, @JsonKey(name: 'hp') this.hasPlayed = false});
  factory _PerformanceHistory.fromJson(Map<String, dynamic> json) => _$PerformanceHistoryFromJson(json);

/// Points
@override@JsonKey(name: 'p') final  int points;
/// Has played (if player played in this match)
@override@JsonKey(name: 'hp') final  bool hasPlayed;

/// Create a copy of PerformanceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PerformanceHistoryCopyWith<_PerformanceHistory> get copyWith => __$PerformanceHistoryCopyWithImpl<_PerformanceHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PerformanceHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PerformanceHistory&&(identical(other.points, points) || other.points == points)&&(identical(other.hasPlayed, hasPlayed) || other.hasPlayed == hasPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,points,hasPlayed);
}

@override
String toString() {
    return 'PerformanceHistory(points: $points, hasPlayed: $hasPlayed)';
}


}

/// @nodoc
abstract mixin class _$PerformanceHistoryCopyWith<$Res> implements $PerformanceHistoryCopyWith<$Res> {
  factory _$PerformanceHistoryCopyWith(_PerformanceHistory value, $Res Function(_PerformanceHistory) _then) = __$PerformanceHistoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'p') int points,@JsonKey(name: 'hp') bool hasPlayed
});




}
/// @nodoc
class __$PerformanceHistoryCopyWithImpl<$Res>
    implements _$PerformanceHistoryCopyWith<$Res> {
  __$PerformanceHistoryCopyWithImpl(this._self, this._then);

  final _PerformanceHistory _self;
  final $Res Function(_PerformanceHistory) _then;

/// Create a copy of PerformanceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? hasPlayed = null,}) {
  return _then(_PerformanceHistory(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,hasPlayed: null == hasPlayed ? _self.hasPlayed : hasPlayed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LineupUpdateRequest {

/// List of player IDs in lineup order (first 11 are starters, rest are bench)
 List<String> get playerIds;
/// Create a copy of LineupUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineupUpdateRequestCopyWith<LineupUpdateRequest> get copyWith => _$LineupUpdateRequestCopyWithImpl<LineupUpdateRequest>(this as LineupUpdateRequest, _$identity);

  /// Serializes this LineupUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LineupUpdateRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineupUpdateRequest&&const DeepCollectionEquality().equals(other.playerIds, _this.playerIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LineupUpdateRequest;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.playerIds));
}

@override
String toString() {
  final _this = this as LineupUpdateRequest;
  return 'LineupUpdateRequest(playerIds: ${_this.playerIds})';
}


}

/// @nodoc
abstract mixin class $LineupUpdateRequestCopyWith<$Res>  {
  factory $LineupUpdateRequestCopyWith(LineupUpdateRequest value, $Res Function(LineupUpdateRequest) _then) = _$LineupUpdateRequestCopyWithImpl;
@useResult
$Res call({
 List<String> playerIds
});




}
/// @nodoc
class _$LineupUpdateRequestCopyWithImpl<$Res>
    implements $LineupUpdateRequestCopyWith<$Res> {
  _$LineupUpdateRequestCopyWithImpl(this._self, this._then);

  final LineupUpdateRequest _self;
  final $Res Function(LineupUpdateRequest) _then;

/// Create a copy of LineupUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerIds = null,}) {
  return _then(LineupUpdateRequest(
playerIds: null == playerIds ? _self.playerIds : playerIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LineupUpdateRequest].
extension LineupUpdateRequestPatterns on LineupUpdateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineupUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineupUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineupUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _LineupUpdateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineupUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LineupUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> playerIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineupUpdateRequest() when $default != null:
return $default(_that.playerIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> playerIds)  $default,) {final _that = this;
switch (_that) {
case _LineupUpdateRequest():
return $default(_that.playerIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> playerIds)?  $default,) {final _that = this;
switch (_that) {
case _LineupUpdateRequest() when $default != null:
return $default(_that.playerIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineupUpdateRequest implements LineupUpdateRequest {
  const _LineupUpdateRequest({required  List<String> playerIds}): _playerIds = playerIds;
  factory _LineupUpdateRequest.fromJson(Map<String, dynamic> json) => _$LineupUpdateRequestFromJson(json);

/// List of player IDs in lineup order (first 11 are starters, rest are bench)
 final  List<String> _playerIds;
/// List of player IDs in lineup order (first 11 are starters, rest are bench)
@override List<String> get playerIds {
  if (_playerIds is EqualUnmodifiableListView) return _playerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerIds);
}


/// Create a copy of LineupUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineupUpdateRequestCopyWith<_LineupUpdateRequest> get copyWith => __$LineupUpdateRequestCopyWithImpl<_LineupUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineupUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineupUpdateRequest&&const DeepCollectionEquality().equals(other.playerIds, _playerIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_playerIds));
}

@override
String toString() {
    return 'LineupUpdateRequest(playerIds: $playerIds)';
}


}

/// @nodoc
abstract mixin class _$LineupUpdateRequestCopyWith<$Res> implements $LineupUpdateRequestCopyWith<$Res> {
  factory _$LineupUpdateRequestCopyWith(_LineupUpdateRequest value, $Res Function(_LineupUpdateRequest) _then) = __$LineupUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> playerIds
});




}
/// @nodoc
class __$LineupUpdateRequestCopyWithImpl<$Res>
    implements _$LineupUpdateRequestCopyWith<$Res> {
  __$LineupUpdateRequestCopyWithImpl(this._self, this._then);

  final _LineupUpdateRequest _self;
  final $Res Function(_LineupUpdateRequest) _then;

/// Create a copy of LineupUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerIds = null,}) {
  return _then(_LineupUpdateRequest(
playerIds: null == playerIds ? _self._playerIds : playerIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
