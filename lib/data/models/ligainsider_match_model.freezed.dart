// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ligainsider_match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LineupPlayer {

 String get name; String? get ligainsiderId; String? get imageUrl; String? get alternative;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineupPlayer&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.ligainsiderId, _this.ligainsiderId) || other.ligainsiderId == _this.ligainsiderId)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.alternative, _this.alternative) || other.alternative == _this.alternative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LineupPlayer;
  return Object.hash(runtimeType,_this.name,_this.ligainsiderId,_this.imageUrl,_this.alternative);
}

@override
String toString() {
  final _this = this as LineupPlayer;
  return 'LineupPlayer(name: ${_this.name}, ligainsiderId: ${_this.ligainsiderId}, imageUrl: ${_this.imageUrl}, alternative: ${_this.alternative})';
}


}

/// @nodoc
abstract mixin class $LineupPlayerCopyWith<$Res>  {
  factory $LineupPlayerCopyWith(LineupPlayer value, $Res Function(LineupPlayer) _then) = _$LineupPlayerCopyWithImpl;
@useResult
$Res call({
 String name, String? ligainsiderId, String? imageUrl, String? alternative
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? ligainsiderId = freezed,Object? imageUrl = freezed,Object? alternative = freezed,}) {
  return _then(LineupPlayer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ligainsiderId: freezed == ligainsiderId ? _self.ligainsiderId : ligainsiderId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,alternative: freezed == alternative ? _self.alternative : alternative // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? ligainsiderId,  String? imageUrl,  String? alternative)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineupPlayer() when $default != null:
return $default(_that.name,_that.ligainsiderId,_that.imageUrl,_that.alternative);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? ligainsiderId,  String? imageUrl,  String? alternative)  $default,) {final _that = this;
switch (_that) {
case _LineupPlayer():
return $default(_that.name,_that.ligainsiderId,_that.imageUrl,_that.alternative);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? ligainsiderId,  String? imageUrl,  String? alternative)?  $default,) {final _that = this;
switch (_that) {
case _LineupPlayer() when $default != null:
return $default(_that.name,_that.ligainsiderId,_that.imageUrl,_that.alternative);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineupPlayer implements LineupPlayer {
  const _LineupPlayer({required this.name, this.ligainsiderId, this.imageUrl, this.alternative});
  factory _LineupPlayer.fromJson(Map<String, dynamic> json) => _$LineupPlayerFromJson(json);

@override final  String name;
@override final  String? ligainsiderId;
@override final  String? imageUrl;
@override final  String? alternative;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineupPlayer&&(identical(other.name, name) || other.name == name)&&(identical(other.ligainsiderId, ligainsiderId) || other.ligainsiderId == ligainsiderId)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.alternative, alternative) || other.alternative == alternative));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,ligainsiderId,imageUrl,alternative);
}

@override
String toString() {
    return 'LineupPlayer(name: $name, ligainsiderId: $ligainsiderId, imageUrl: $imageUrl, alternative: $alternative)';
}


}

/// @nodoc
abstract mixin class _$LineupPlayerCopyWith<$Res> implements $LineupPlayerCopyWith<$Res> {
  factory _$LineupPlayerCopyWith(_LineupPlayer value, $Res Function(_LineupPlayer) _then) = __$LineupPlayerCopyWithImpl;
@override @useResult
$Res call({
 String name, String? ligainsiderId, String? imageUrl, String? alternative
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? ligainsiderId = freezed,Object? imageUrl = freezed,Object? alternative = freezed,}) {
  return _then(_LineupPlayer(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ligainsiderId: freezed == ligainsiderId ? _self.ligainsiderId : ligainsiderId // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,alternative: freezed == alternative ? _self.alternative : alternative // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LineupRow {

 String get rowName; List<LineupPlayer> get players;
/// Create a copy of LineupRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineupRowCopyWith<LineupRow> get copyWith => _$LineupRowCopyWithImpl<LineupRow>(this as LineupRow, _$identity);

  /// Serializes this LineupRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LineupRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineupRow&&(identical(other.rowName, _this.rowName) || other.rowName == _this.rowName)&&const DeepCollectionEquality().equals(other.players, _this.players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LineupRow;
  return Object.hash(runtimeType,_this.rowName,const DeepCollectionEquality().hash(_this.players));
}

@override
String toString() {
  final _this = this as LineupRow;
  return 'LineupRow(rowName: ${_this.rowName}, players: ${_this.players})';
}


}

/// @nodoc
abstract mixin class $LineupRowCopyWith<$Res>  {
  factory $LineupRowCopyWith(LineupRow value, $Res Function(LineupRow) _then) = _$LineupRowCopyWithImpl;
@useResult
$Res call({
 String rowName, List<LineupPlayer> players
});




}
/// @nodoc
class _$LineupRowCopyWithImpl<$Res>
    implements $LineupRowCopyWith<$Res> {
  _$LineupRowCopyWithImpl(this._self, this._then);

  final LineupRow _self;
  final $Res Function(LineupRow) _then;

/// Create a copy of LineupRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowName = null,Object? players = null,}) {
  return _then(LineupRow(
rowName: null == rowName ? _self.rowName : rowName // ignore: cast_nullable_to_non_nullable
as String,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<LineupPlayer>,
  ));
}

}


/// Adds pattern-matching-related methods to [LineupRow].
extension LineupRowPatterns on LineupRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineupRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineupRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineupRow value)  $default,){
final _that = this;
switch (_that) {
case _LineupRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineupRow value)?  $default,){
final _that = this;
switch (_that) {
case _LineupRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rowName,  List<LineupPlayer> players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineupRow() when $default != null:
return $default(_that.rowName,_that.players);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rowName,  List<LineupPlayer> players)  $default,) {final _that = this;
switch (_that) {
case _LineupRow():
return $default(_that.rowName,_that.players);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rowName,  List<LineupPlayer> players)?  $default,) {final _that = this;
switch (_that) {
case _LineupRow() when $default != null:
return $default(_that.rowName,_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineupRow implements LineupRow {
  const _LineupRow({required this.rowName, required  List<LineupPlayer> players}): _players = players;
  factory _LineupRow.fromJson(Map<String, dynamic> json) => _$LineupRowFromJson(json);

@override final  String rowName;
 final  List<LineupPlayer> _players;
@override List<LineupPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}


/// Create a copy of LineupRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineupRowCopyWith<_LineupRow> get copyWith => __$LineupRowCopyWithImpl<_LineupRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineupRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineupRow&&(identical(other.rowName, rowName) || other.rowName == rowName)&&const DeepCollectionEquality().equals(other.players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rowName,const DeepCollectionEquality().hash(_players));
}

@override
String toString() {
    return 'LineupRow(rowName: $rowName, players: $players)';
}


}

/// @nodoc
abstract mixin class _$LineupRowCopyWith<$Res> implements $LineupRowCopyWith<$Res> {
  factory _$LineupRowCopyWith(_LineupRow value, $Res Function(_LineupRow) _then) = __$LineupRowCopyWithImpl;
@override @useResult
$Res call({
 String rowName, List<LineupPlayer> players
});




}
/// @nodoc
class __$LineupRowCopyWithImpl<$Res>
    implements _$LineupRowCopyWith<$Res> {
  __$LineupRowCopyWithImpl(this._self, this._then);

  final _LineupRow _self;
  final $Res Function(_LineupRow) _then;

/// Create a copy of LineupRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowName = null,Object? players = null,}) {
  return _then(_LineupRow(
rowName: null == rowName ? _self.rowName : rowName // ignore: cast_nullable_to_non_nullable
as String,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<LineupPlayer>,
  ));
}


}


/// @nodoc
mixin _$LigainsiderMatch {

 String get id; String get homeTeam; String get awayTeam; String? get homeLogo; String? get awayLogo; List<LineupRow> get homeLineup; List<LineupRow> get awayLineup;
/// Create a copy of LigainsiderMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LigainsiderMatchCopyWith<LigainsiderMatch> get copyWith => _$LigainsiderMatchCopyWithImpl<LigainsiderMatch>(this as LigainsiderMatch, _$identity);

  /// Serializes this LigainsiderMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LigainsiderMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LigainsiderMatch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.homeTeam, _this.homeTeam) || other.homeTeam == _this.homeTeam)&&(identical(other.awayTeam, _this.awayTeam) || other.awayTeam == _this.awayTeam)&&(identical(other.homeLogo, _this.homeLogo) || other.homeLogo == _this.homeLogo)&&(identical(other.awayLogo, _this.awayLogo) || other.awayLogo == _this.awayLogo)&&const DeepCollectionEquality().equals(other.homeLineup, _this.homeLineup)&&const DeepCollectionEquality().equals(other.awayLineup, _this.awayLineup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LigainsiderMatch;
  return Object.hash(runtimeType,_this.id,_this.homeTeam,_this.awayTeam,_this.homeLogo,_this.awayLogo,const DeepCollectionEquality().hash(_this.homeLineup),const DeepCollectionEquality().hash(_this.awayLineup));
}

@override
String toString() {
  final _this = this as LigainsiderMatch;
  return 'LigainsiderMatch(id: ${_this.id}, homeTeam: ${_this.homeTeam}, awayTeam: ${_this.awayTeam}, homeLogo: ${_this.homeLogo}, awayLogo: ${_this.awayLogo}, homeLineup: ${_this.homeLineup}, awayLineup: ${_this.awayLineup})';
}


}

/// @nodoc
abstract mixin class $LigainsiderMatchCopyWith<$Res>  {
  factory $LigainsiderMatchCopyWith(LigainsiderMatch value, $Res Function(LigainsiderMatch) _then) = _$LigainsiderMatchCopyWithImpl;
@useResult
$Res call({
 String id, String homeTeam, String awayTeam, String? homeLogo, String? awayLogo, List<LineupRow> homeLineup, List<LineupRow> awayLineup
});




}
/// @nodoc
class _$LigainsiderMatchCopyWithImpl<$Res>
    implements $LigainsiderMatchCopyWith<$Res> {
  _$LigainsiderMatchCopyWithImpl(this._self, this._then);

  final LigainsiderMatch _self;
  final $Res Function(LigainsiderMatch) _then;

/// Create a copy of LigainsiderMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? homeTeam = null,Object? awayTeam = null,Object? homeLogo = freezed,Object? awayLogo = freezed,Object? homeLineup = null,Object? awayLineup = null,}) {
  return _then(LigainsiderMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as String,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as String,homeLogo: freezed == homeLogo ? _self.homeLogo : homeLogo // ignore: cast_nullable_to_non_nullable
as String?,awayLogo: freezed == awayLogo ? _self.awayLogo : awayLogo // ignore: cast_nullable_to_non_nullable
as String?,homeLineup: null == homeLineup ? _self.homeLineup : homeLineup // ignore: cast_nullable_to_non_nullable
as List<LineupRow>,awayLineup: null == awayLineup ? _self.awayLineup : awayLineup // ignore: cast_nullable_to_non_nullable
as List<LineupRow>,
  ));
}

}


/// Adds pattern-matching-related methods to [LigainsiderMatch].
extension LigainsiderMatchPatterns on LigainsiderMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LigainsiderMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LigainsiderMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LigainsiderMatch value)  $default,){
final _that = this;
switch (_that) {
case _LigainsiderMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LigainsiderMatch value)?  $default,){
final _that = this;
switch (_that) {
case _LigainsiderMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String homeTeam,  String awayTeam,  String? homeLogo,  String? awayLogo,  List<LineupRow> homeLineup,  List<LineupRow> awayLineup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LigainsiderMatch() when $default != null:
return $default(_that.id,_that.homeTeam,_that.awayTeam,_that.homeLogo,_that.awayLogo,_that.homeLineup,_that.awayLineup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String homeTeam,  String awayTeam,  String? homeLogo,  String? awayLogo,  List<LineupRow> homeLineup,  List<LineupRow> awayLineup)  $default,) {final _that = this;
switch (_that) {
case _LigainsiderMatch():
return $default(_that.id,_that.homeTeam,_that.awayTeam,_that.homeLogo,_that.awayLogo,_that.homeLineup,_that.awayLineup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String homeTeam,  String awayTeam,  String? homeLogo,  String? awayLogo,  List<LineupRow> homeLineup,  List<LineupRow> awayLineup)?  $default,) {final _that = this;
switch (_that) {
case _LigainsiderMatch() when $default != null:
return $default(_that.id,_that.homeTeam,_that.awayTeam,_that.homeLogo,_that.awayLogo,_that.homeLineup,_that.awayLineup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LigainsiderMatch implements LigainsiderMatch {
  const _LigainsiderMatch({required this.id, required this.homeTeam, required this.awayTeam, this.homeLogo, this.awayLogo, required  List<LineupRow> homeLineup, required  List<LineupRow> awayLineup}): _homeLineup = homeLineup,_awayLineup = awayLineup;
  factory _LigainsiderMatch.fromJson(Map<String, dynamic> json) => _$LigainsiderMatchFromJson(json);

@override final  String id;
@override final  String homeTeam;
@override final  String awayTeam;
@override final  String? homeLogo;
@override final  String? awayLogo;
 final  List<LineupRow> _homeLineup;
@override List<LineupRow> get homeLineup {
  if (_homeLineup is EqualUnmodifiableListView) return _homeLineup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_homeLineup);
}

 final  List<LineupRow> _awayLineup;
@override List<LineupRow> get awayLineup {
  if (_awayLineup is EqualUnmodifiableListView) return _awayLineup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_awayLineup);
}


/// Create a copy of LigainsiderMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LigainsiderMatchCopyWith<_LigainsiderMatch> get copyWith => __$LigainsiderMatchCopyWithImpl<_LigainsiderMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LigainsiderMatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LigainsiderMatch&&(identical(other.id, id) || other.id == id)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.homeLogo, homeLogo) || other.homeLogo == homeLogo)&&(identical(other.awayLogo, awayLogo) || other.awayLogo == awayLogo)&&const DeepCollectionEquality().equals(other.homeLineup, _homeLineup)&&const DeepCollectionEquality().equals(other.awayLineup, _awayLineup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,homeTeam,awayTeam,homeLogo,awayLogo,const DeepCollectionEquality().hash(_homeLineup),const DeepCollectionEquality().hash(_awayLineup));
}

@override
String toString() {
    return 'LigainsiderMatch(id: $id, homeTeam: $homeTeam, awayTeam: $awayTeam, homeLogo: $homeLogo, awayLogo: $awayLogo, homeLineup: $homeLineup, awayLineup: $awayLineup)';
}


}

/// @nodoc
abstract mixin class _$LigainsiderMatchCopyWith<$Res> implements $LigainsiderMatchCopyWith<$Res> {
  factory _$LigainsiderMatchCopyWith(_LigainsiderMatch value, $Res Function(_LigainsiderMatch) _then) = __$LigainsiderMatchCopyWithImpl;
@override @useResult
$Res call({
 String id, String homeTeam, String awayTeam, String? homeLogo, String? awayLogo, List<LineupRow> homeLineup, List<LineupRow> awayLineup
});




}
/// @nodoc
class __$LigainsiderMatchCopyWithImpl<$Res>
    implements _$LigainsiderMatchCopyWith<$Res> {
  __$LigainsiderMatchCopyWithImpl(this._self, this._then);

  final _LigainsiderMatch _self;
  final $Res Function(_LigainsiderMatch) _then;

/// Create a copy of LigainsiderMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? homeTeam = null,Object? awayTeam = null,Object? homeLogo = freezed,Object? awayLogo = freezed,Object? homeLineup = null,Object? awayLineup = null,}) {
  return _then(_LigainsiderMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as String,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as String,homeLogo: freezed == homeLogo ? _self.homeLogo : homeLogo // ignore: cast_nullable_to_non_nullable
as String?,awayLogo: freezed == awayLogo ? _self.awayLogo : awayLogo // ignore: cast_nullable_to_non_nullable
as String?,homeLineup: null == homeLineup ? _self._homeLineup : homeLineup // ignore: cast_nullable_to_non_nullable
as List<LineupRow>,awayLineup: null == awayLineup ? _self._awayLineup : awayLineup // ignore: cast_nullable_to_non_nullable
as List<LineupRow>,
  ));
}


}

// dart format on
