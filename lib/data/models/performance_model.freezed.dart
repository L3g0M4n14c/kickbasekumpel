// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerPerformanceResponse {

 List<SeasonPerformance> get it;
/// Create a copy of PlayerPerformanceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerPerformanceResponseCopyWith<PlayerPerformanceResponse> get copyWith => _$PlayerPerformanceResponseCopyWithImpl<PlayerPerformanceResponse>(this as PlayerPerformanceResponse, _$identity);

  /// Serializes this PlayerPerformanceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerPerformanceResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerPerformanceResponse&&const DeepCollectionEquality().equals(other.it, _this.it));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerPerformanceResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.it));
}

@override
String toString() {
  final _this = this as PlayerPerformanceResponse;
  return 'PlayerPerformanceResponse(it: ${_this.it})';
}


}

/// @nodoc
abstract mixin class $PlayerPerformanceResponseCopyWith<$Res>  {
  factory $PlayerPerformanceResponseCopyWith(PlayerPerformanceResponse value, $Res Function(PlayerPerformanceResponse) _then) = _$PlayerPerformanceResponseCopyWithImpl;
@useResult
$Res call({
 List<SeasonPerformance> it
});




}
/// @nodoc
class _$PlayerPerformanceResponseCopyWithImpl<$Res>
    implements $PlayerPerformanceResponseCopyWith<$Res> {
  _$PlayerPerformanceResponseCopyWithImpl(this._self, this._then);

  final PlayerPerformanceResponse _self;
  final $Res Function(PlayerPerformanceResponse) _then;

/// Create a copy of PlayerPerformanceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? it = null,}) {
  return _then(PlayerPerformanceResponse(
it: null == it ? _self.it : it // ignore: cast_nullable_to_non_nullable
as List<SeasonPerformance>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerPerformanceResponse].
extension PlayerPerformanceResponsePatterns on PlayerPerformanceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerPerformanceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerPerformanceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerPerformanceResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlayerPerformanceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerPerformanceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerPerformanceResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SeasonPerformance> it)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerPerformanceResponse() when $default != null:
return $default(_that.it);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SeasonPerformance> it)  $default,) {final _that = this;
switch (_that) {
case _PlayerPerformanceResponse():
return $default(_that.it);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SeasonPerformance> it)?  $default,) {final _that = this;
switch (_that) {
case _PlayerPerformanceResponse() when $default != null:
return $default(_that.it);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerPerformanceResponse implements PlayerPerformanceResponse {
  const _PlayerPerformanceResponse({required  List<SeasonPerformance> it}): _it = it;
  factory _PlayerPerformanceResponse.fromJson(Map<String, dynamic> json) => _$PlayerPerformanceResponseFromJson(json);

 final  List<SeasonPerformance> _it;
@override List<SeasonPerformance> get it {
  if (_it is EqualUnmodifiableListView) return _it;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_it);
}


/// Create a copy of PlayerPerformanceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerPerformanceResponseCopyWith<_PlayerPerformanceResponse> get copyWith => __$PlayerPerformanceResponseCopyWithImpl<_PlayerPerformanceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerPerformanceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerPerformanceResponse&&const DeepCollectionEquality().equals(other.it, _it));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_it));
}

@override
String toString() {
    return 'PlayerPerformanceResponse(it: $it)';
}


}

/// @nodoc
abstract mixin class _$PlayerPerformanceResponseCopyWith<$Res> implements $PlayerPerformanceResponseCopyWith<$Res> {
  factory _$PlayerPerformanceResponseCopyWith(_PlayerPerformanceResponse value, $Res Function(_PlayerPerformanceResponse) _then) = __$PlayerPerformanceResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SeasonPerformance> it
});




}
/// @nodoc
class __$PlayerPerformanceResponseCopyWithImpl<$Res>
    implements _$PlayerPerformanceResponseCopyWith<$Res> {
  __$PlayerPerformanceResponseCopyWithImpl(this._self, this._then);

  final _PlayerPerformanceResponse _self;
  final $Res Function(_PlayerPerformanceResponse) _then;

/// Create a copy of PlayerPerformanceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? it = null,}) {
  return _then(_PlayerPerformanceResponse(
it: null == it ? _self._it : it // ignore: cast_nullable_to_non_nullable
as List<SeasonPerformance>,
  ));
}


}


/// @nodoc
mixin _$SeasonPerformance {

 String? get sid; String get ti; String get n; List<MatchPerformance> get ph;
/// Create a copy of SeasonPerformance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonPerformanceCopyWith<SeasonPerformance> get copyWith => _$SeasonPerformanceCopyWithImpl<SeasonPerformance>(this as SeasonPerformance, _$identity);

  /// Serializes this SeasonPerformance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SeasonPerformance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonPerformance&&(identical(other.sid, _this.sid) || other.sid == _this.sid)&&(identical(other.ti, _this.ti) || other.ti == _this.ti)&&(identical(other.n, _this.n) || other.n == _this.n)&&const DeepCollectionEquality().equals(other.ph, _this.ph));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SeasonPerformance;
  return Object.hash(runtimeType,_this.sid,_this.ti,_this.n,const DeepCollectionEquality().hash(_this.ph));
}

@override
String toString() {
  final _this = this as SeasonPerformance;
  return 'SeasonPerformance(sid: ${_this.sid}, ti: ${_this.ti}, n: ${_this.n}, ph: ${_this.ph})';
}


}

/// @nodoc
abstract mixin class $SeasonPerformanceCopyWith<$Res>  {
  factory $SeasonPerformanceCopyWith(SeasonPerformance value, $Res Function(SeasonPerformance) _then) = _$SeasonPerformanceCopyWithImpl;
@useResult
$Res call({
 String? sid, String ti, String n, List<MatchPerformance> ph
});




}
/// @nodoc
class _$SeasonPerformanceCopyWithImpl<$Res>
    implements $SeasonPerformanceCopyWith<$Res> {
  _$SeasonPerformanceCopyWithImpl(this._self, this._then);

  final SeasonPerformance _self;
  final $Res Function(SeasonPerformance) _then;

/// Create a copy of SeasonPerformance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sid = freezed,Object? ti = null,Object? n = null,Object? ph = null,}) {
  return _then(SeasonPerformance(
sid: freezed == sid ? _self.sid : sid // ignore: cast_nullable_to_non_nullable
as String?,ti: null == ti ? _self.ti : ti // ignore: cast_nullable_to_non_nullable
as String,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as String,ph: null == ph ? _self.ph : ph // ignore: cast_nullable_to_non_nullable
as List<MatchPerformance>,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonPerformance].
extension SeasonPerformancePatterns on SeasonPerformance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonPerformance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonPerformance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonPerformance value)  $default,){
final _that = this;
switch (_that) {
case _SeasonPerformance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonPerformance value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonPerformance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sid,  String ti,  String n,  List<MatchPerformance> ph)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonPerformance() when $default != null:
return $default(_that.sid,_that.ti,_that.n,_that.ph);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sid,  String ti,  String n,  List<MatchPerformance> ph)  $default,) {final _that = this;
switch (_that) {
case _SeasonPerformance():
return $default(_that.sid,_that.ti,_that.n,_that.ph);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sid,  String ti,  String n,  List<MatchPerformance> ph)?  $default,) {final _that = this;
switch (_that) {
case _SeasonPerformance() when $default != null:
return $default(_that.sid,_that.ti,_that.n,_that.ph);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SeasonPerformance implements SeasonPerformance {
  const _SeasonPerformance({this.sid, required this.ti, required this.n, required  List<MatchPerformance> ph}): _ph = ph;
  factory _SeasonPerformance.fromJson(Map<String, dynamic> json) => _$SeasonPerformanceFromJson(json);

@override final  String? sid;
@override final  String ti;
@override final  String n;
 final  List<MatchPerformance> _ph;
@override List<MatchPerformance> get ph {
  if (_ph is EqualUnmodifiableListView) return _ph;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ph);
}


/// Create a copy of SeasonPerformance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonPerformanceCopyWith<_SeasonPerformance> get copyWith => __$SeasonPerformanceCopyWithImpl<_SeasonPerformance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeasonPerformanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonPerformance&&(identical(other.sid, sid) || other.sid == sid)&&(identical(other.ti, ti) || other.ti == ti)&&(identical(other.n, n) || other.n == n)&&const DeepCollectionEquality().equals(other.ph, _ph));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sid,ti,n,const DeepCollectionEquality().hash(_ph));
}

@override
String toString() {
    return 'SeasonPerformance(sid: $sid, ti: $ti, n: $n, ph: $ph)';
}


}

/// @nodoc
abstract mixin class _$SeasonPerformanceCopyWith<$Res> implements $SeasonPerformanceCopyWith<$Res> {
  factory _$SeasonPerformanceCopyWith(_SeasonPerformance value, $Res Function(_SeasonPerformance) _then) = __$SeasonPerformanceCopyWithImpl;
@override @useResult
$Res call({
 String? sid, String ti, String n, List<MatchPerformance> ph
});




}
/// @nodoc
class __$SeasonPerformanceCopyWithImpl<$Res>
    implements _$SeasonPerformanceCopyWith<$Res> {
  __$SeasonPerformanceCopyWithImpl(this._self, this._then);

  final _SeasonPerformance _self;
  final $Res Function(_SeasonPerformance) _then;

/// Create a copy of SeasonPerformance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sid = freezed,Object? ti = null,Object? n = null,Object? ph = null,}) {
  return _then(_SeasonPerformance(
sid: freezed == sid ? _self.sid : sid // ignore: cast_nullable_to_non_nullable
as String?,ti: null == ti ? _self.ti : ti // ignore: cast_nullable_to_non_nullable
as String,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as String,ph: null == ph ? _self._ph : ph // ignore: cast_nullable_to_non_nullable
as List<MatchPerformance>,
  ));
}


}


/// @nodoc
mixin _$MatchPerformance {

 int get day; int? get p; String? get mp; String get md; String get t1; String get t2; int? get t1g; int? get t2g; String? get pt; List<int>? get k; int get st; bool get cur; int get mdst; int? get ap; int? get tp; int? get asp;
/// Create a copy of MatchPerformance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchPerformanceCopyWith<MatchPerformance> get copyWith => _$MatchPerformanceCopyWithImpl<MatchPerformance>(this as MatchPerformance, _$identity);

  /// Serializes this MatchPerformance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatchPerformance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchPerformance&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.p, _this.p) || other.p == _this.p)&&(identical(other.mp, _this.mp) || other.mp == _this.mp)&&(identical(other.md, _this.md) || other.md == _this.md)&&(identical(other.t1, _this.t1) || other.t1 == _this.t1)&&(identical(other.t2, _this.t2) || other.t2 == _this.t2)&&(identical(other.t1g, _this.t1g) || other.t1g == _this.t1g)&&(identical(other.t2g, _this.t2g) || other.t2g == _this.t2g)&&(identical(other.pt, _this.pt) || other.pt == _this.pt)&&const DeepCollectionEquality().equals(other.k, _this.k)&&(identical(other.st, _this.st) || other.st == _this.st)&&(identical(other.cur, _this.cur) || other.cur == _this.cur)&&(identical(other.mdst, _this.mdst) || other.mdst == _this.mdst)&&(identical(other.ap, _this.ap) || other.ap == _this.ap)&&(identical(other.tp, _this.tp) || other.tp == _this.tp)&&(identical(other.asp, _this.asp) || other.asp == _this.asp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatchPerformance;
  return Object.hash(runtimeType,_this.day,_this.p,_this.mp,_this.md,_this.t1,_this.t2,_this.t1g,_this.t2g,_this.pt,const DeepCollectionEquality().hash(_this.k),_this.st,_this.cur,_this.mdst,_this.ap,_this.tp,_this.asp);
}

@override
String toString() {
  final _this = this as MatchPerformance;
  return 'MatchPerformance(day: ${_this.day}, p: ${_this.p}, mp: ${_this.mp}, md: ${_this.md}, t1: ${_this.t1}, t2: ${_this.t2}, t1g: ${_this.t1g}, t2g: ${_this.t2g}, pt: ${_this.pt}, k: ${_this.k}, st: ${_this.st}, cur: ${_this.cur}, mdst: ${_this.mdst}, ap: ${_this.ap}, tp: ${_this.tp}, asp: ${_this.asp})';
}


}

/// @nodoc
abstract mixin class $MatchPerformanceCopyWith<$Res>  {
  factory $MatchPerformanceCopyWith(MatchPerformance value, $Res Function(MatchPerformance) _then) = _$MatchPerformanceCopyWithImpl;
@useResult
$Res call({
 int day, int? p, String? mp, String md, String t1, String t2, int? t1g, int? t2g, String? pt, List<int>? k, int st, bool cur, int mdst, int? ap, int? tp, int? asp
});




}
/// @nodoc
class _$MatchPerformanceCopyWithImpl<$Res>
    implements $MatchPerformanceCopyWith<$Res> {
  _$MatchPerformanceCopyWithImpl(this._self, this._then);

  final MatchPerformance _self;
  final $Res Function(MatchPerformance) _then;

/// Create a copy of MatchPerformance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? p = freezed,Object? mp = freezed,Object? md = null,Object? t1 = null,Object? t2 = null,Object? t1g = freezed,Object? t2g = freezed,Object? pt = freezed,Object? k = freezed,Object? st = null,Object? cur = null,Object? mdst = null,Object? ap = freezed,Object? tp = freezed,Object? asp = freezed,}) {
  return _then(MatchPerformance(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,p: freezed == p ? _self.p : p // ignore: cast_nullable_to_non_nullable
as int?,mp: freezed == mp ? _self.mp : mp // ignore: cast_nullable_to_non_nullable
as String?,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as String,t1: null == t1 ? _self.t1 : t1 // ignore: cast_nullable_to_non_nullable
as String,t2: null == t2 ? _self.t2 : t2 // ignore: cast_nullable_to_non_nullable
as String,t1g: freezed == t1g ? _self.t1g : t1g // ignore: cast_nullable_to_non_nullable
as int?,t2g: freezed == t2g ? _self.t2g : t2g // ignore: cast_nullable_to_non_nullable
as int?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as String?,k: freezed == k ? _self.k : k // ignore: cast_nullable_to_non_nullable
as List<int>?,st: null == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as int,cur: null == cur ? _self.cur : cur // ignore: cast_nullable_to_non_nullable
as bool,mdst: null == mdst ? _self.mdst : mdst // ignore: cast_nullable_to_non_nullable
as int,ap: freezed == ap ? _self.ap : ap // ignore: cast_nullable_to_non_nullable
as int?,tp: freezed == tp ? _self.tp : tp // ignore: cast_nullable_to_non_nullable
as int?,asp: freezed == asp ? _self.asp : asp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchPerformance].
extension MatchPerformancePatterns on MatchPerformance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchPerformance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchPerformance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchPerformance value)  $default,){
final _that = this;
switch (_that) {
case _MatchPerformance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchPerformance value)?  $default,){
final _that = this;
switch (_that) {
case _MatchPerformance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  int? p,  String? mp,  String md,  String t1,  String t2,  int? t1g,  int? t2g,  String? pt,  List<int>? k,  int st,  bool cur,  int mdst,  int? ap,  int? tp,  int? asp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchPerformance() when $default != null:
return $default(_that.day,_that.p,_that.mp,_that.md,_that.t1,_that.t2,_that.t1g,_that.t2g,_that.pt,_that.k,_that.st,_that.cur,_that.mdst,_that.ap,_that.tp,_that.asp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  int? p,  String? mp,  String md,  String t1,  String t2,  int? t1g,  int? t2g,  String? pt,  List<int>? k,  int st,  bool cur,  int mdst,  int? ap,  int? tp,  int? asp)  $default,) {final _that = this;
switch (_that) {
case _MatchPerformance():
return $default(_that.day,_that.p,_that.mp,_that.md,_that.t1,_that.t2,_that.t1g,_that.t2g,_that.pt,_that.k,_that.st,_that.cur,_that.mdst,_that.ap,_that.tp,_that.asp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  int? p,  String? mp,  String md,  String t1,  String t2,  int? t1g,  int? t2g,  String? pt,  List<int>? k,  int st,  bool cur,  int mdst,  int? ap,  int? tp,  int? asp)?  $default,) {final _that = this;
switch (_that) {
case _MatchPerformance() when $default != null:
return $default(_that.day,_that.p,_that.mp,_that.md,_that.t1,_that.t2,_that.t1g,_that.t2g,_that.pt,_that.k,_that.st,_that.cur,_that.mdst,_that.ap,_that.tp,_that.asp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchPerformance implements MatchPerformance {
  const _MatchPerformance({required this.day, this.p, this.mp, required this.md, required this.t1, required this.t2, this.t1g, this.t2g, this.pt,  List<int>? k, required this.st, required this.cur, required this.mdst, this.ap, this.tp, this.asp}): _k = k;
  factory _MatchPerformance.fromJson(Map<String, dynamic> json) => _$MatchPerformanceFromJson(json);

@override final  int day;
@override final  int? p;
@override final  String? mp;
@override final  String md;
@override final  String t1;
@override final  String t2;
@override final  int? t1g;
@override final  int? t2g;
@override final  String? pt;
 final  List<int>? _k;
@override List<int>? get k {
  final value = _k;
  if (value == null) return null;
  if (_k is EqualUnmodifiableListView) return _k;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int st;
@override final  bool cur;
@override final  int mdst;
@override final  int? ap;
@override final  int? tp;
@override final  int? asp;

/// Create a copy of MatchPerformance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchPerformanceCopyWith<_MatchPerformance> get copyWith => __$MatchPerformanceCopyWithImpl<_MatchPerformance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchPerformanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchPerformance&&(identical(other.day, day) || other.day == day)&&(identical(other.p, p) || other.p == p)&&(identical(other.mp, mp) || other.mp == mp)&&(identical(other.md, md) || other.md == md)&&(identical(other.t1, t1) || other.t1 == t1)&&(identical(other.t2, t2) || other.t2 == t2)&&(identical(other.t1g, t1g) || other.t1g == t1g)&&(identical(other.t2g, t2g) || other.t2g == t2g)&&(identical(other.pt, pt) || other.pt == pt)&&const DeepCollectionEquality().equals(other.k, _k)&&(identical(other.st, st) || other.st == st)&&(identical(other.cur, cur) || other.cur == cur)&&(identical(other.mdst, mdst) || other.mdst == mdst)&&(identical(other.ap, ap) || other.ap == ap)&&(identical(other.tp, tp) || other.tp == tp)&&(identical(other.asp, asp) || other.asp == asp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,p,mp,md,t1,t2,t1g,t2g,pt,const DeepCollectionEquality().hash(_k),st,cur,mdst,ap,tp,asp);
}

@override
String toString() {
    return 'MatchPerformance(day: $day, p: $p, mp: $mp, md: $md, t1: $t1, t2: $t2, t1g: $t1g, t2g: $t2g, pt: $pt, k: $k, st: $st, cur: $cur, mdst: $mdst, ap: $ap, tp: $tp, asp: $asp)';
}


}

/// @nodoc
abstract mixin class _$MatchPerformanceCopyWith<$Res> implements $MatchPerformanceCopyWith<$Res> {
  factory _$MatchPerformanceCopyWith(_MatchPerformance value, $Res Function(_MatchPerformance) _then) = __$MatchPerformanceCopyWithImpl;
@override @useResult
$Res call({
 int day, int? p, String? mp, String md, String t1, String t2, int? t1g, int? t2g, String? pt, List<int>? k, int st, bool cur, int mdst, int? ap, int? tp, int? asp
});




}
/// @nodoc
class __$MatchPerformanceCopyWithImpl<$Res>
    implements _$MatchPerformanceCopyWith<$Res> {
  __$MatchPerformanceCopyWithImpl(this._self, this._then);

  final _MatchPerformance _self;
  final $Res Function(_MatchPerformance) _then;

/// Create a copy of MatchPerformance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? p = freezed,Object? mp = freezed,Object? md = null,Object? t1 = null,Object? t2 = null,Object? t1g = freezed,Object? t2g = freezed,Object? pt = freezed,Object? k = freezed,Object? st = null,Object? cur = null,Object? mdst = null,Object? ap = freezed,Object? tp = freezed,Object? asp = freezed,}) {
  return _then(_MatchPerformance(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,p: freezed == p ? _self.p : p // ignore: cast_nullable_to_non_nullable
as int?,mp: freezed == mp ? _self.mp : mp // ignore: cast_nullable_to_non_nullable
as String?,md: null == md ? _self.md : md // ignore: cast_nullable_to_non_nullable
as String,t1: null == t1 ? _self.t1 : t1 // ignore: cast_nullable_to_non_nullable
as String,t2: null == t2 ? _self.t2 : t2 // ignore: cast_nullable_to_non_nullable
as String,t1g: freezed == t1g ? _self.t1g : t1g // ignore: cast_nullable_to_non_nullable
as int?,t2g: freezed == t2g ? _self.t2g : t2g // ignore: cast_nullable_to_non_nullable
as int?,pt: freezed == pt ? _self.pt : pt // ignore: cast_nullable_to_non_nullable
as String?,k: freezed == k ? _self._k : k // ignore: cast_nullable_to_non_nullable
as List<int>?,st: null == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as int,cur: null == cur ? _self.cur : cur // ignore: cast_nullable_to_non_nullable
as bool,mdst: null == mdst ? _self.mdst : mdst // ignore: cast_nullable_to_non_nullable
as int,ap: freezed == ap ? _self.ap : ap // ignore: cast_nullable_to_non_nullable
as int?,tp: freezed == tp ? _self.tp : tp // ignore: cast_nullable_to_non_nullable
as int?,asp: freezed == asp ? _self.asp : asp // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$EnhancedMatchPerformance {

 MatchPerformance get basePerformance; String? get team1Name; String? get team2Name; String? get playerTeamName; String? get opponentTeamName; int? get team1Placement; int? get team2Placement; int? get playerTeamPlacement; int? get opponentTeamPlacement;
/// Create a copy of EnhancedMatchPerformance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnhancedMatchPerformanceCopyWith<EnhancedMatchPerformance> get copyWith => _$EnhancedMatchPerformanceCopyWithImpl<EnhancedMatchPerformance>(this as EnhancedMatchPerformance, _$identity);

  /// Serializes this EnhancedMatchPerformance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnhancedMatchPerformance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnhancedMatchPerformance&&(identical(other.basePerformance, _this.basePerformance) || other.basePerformance == _this.basePerformance)&&(identical(other.team1Name, _this.team1Name) || other.team1Name == _this.team1Name)&&(identical(other.team2Name, _this.team2Name) || other.team2Name == _this.team2Name)&&(identical(other.playerTeamName, _this.playerTeamName) || other.playerTeamName == _this.playerTeamName)&&(identical(other.opponentTeamName, _this.opponentTeamName) || other.opponentTeamName == _this.opponentTeamName)&&(identical(other.team1Placement, _this.team1Placement) || other.team1Placement == _this.team1Placement)&&(identical(other.team2Placement, _this.team2Placement) || other.team2Placement == _this.team2Placement)&&(identical(other.playerTeamPlacement, _this.playerTeamPlacement) || other.playerTeamPlacement == _this.playerTeamPlacement)&&(identical(other.opponentTeamPlacement, _this.opponentTeamPlacement) || other.opponentTeamPlacement == _this.opponentTeamPlacement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnhancedMatchPerformance;
  return Object.hash(runtimeType,_this.basePerformance,_this.team1Name,_this.team2Name,_this.playerTeamName,_this.opponentTeamName,_this.team1Placement,_this.team2Placement,_this.playerTeamPlacement,_this.opponentTeamPlacement);
}

@override
String toString() {
  final _this = this as EnhancedMatchPerformance;
  return 'EnhancedMatchPerformance(basePerformance: ${_this.basePerformance}, team1Name: ${_this.team1Name}, team2Name: ${_this.team2Name}, playerTeamName: ${_this.playerTeamName}, opponentTeamName: ${_this.opponentTeamName}, team1Placement: ${_this.team1Placement}, team2Placement: ${_this.team2Placement}, playerTeamPlacement: ${_this.playerTeamPlacement}, opponentTeamPlacement: ${_this.opponentTeamPlacement})';
}


}

/// @nodoc
abstract mixin class $EnhancedMatchPerformanceCopyWith<$Res>  {
  factory $EnhancedMatchPerformanceCopyWith(EnhancedMatchPerformance value, $Res Function(EnhancedMatchPerformance) _then) = _$EnhancedMatchPerformanceCopyWithImpl;
@useResult
$Res call({
 MatchPerformance basePerformance, String? team1Name, String? team2Name, String? playerTeamName, String? opponentTeamName, int? team1Placement, int? team2Placement, int? playerTeamPlacement, int? opponentTeamPlacement
});


$MatchPerformanceCopyWith<$Res> get basePerformance;

}
/// @nodoc
class _$EnhancedMatchPerformanceCopyWithImpl<$Res>
    implements $EnhancedMatchPerformanceCopyWith<$Res> {
  _$EnhancedMatchPerformanceCopyWithImpl(this._self, this._then);

  final EnhancedMatchPerformance _self;
  final $Res Function(EnhancedMatchPerformance) _then;

/// Create a copy of EnhancedMatchPerformance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? basePerformance = null,Object? team1Name = freezed,Object? team2Name = freezed,Object? playerTeamName = freezed,Object? opponentTeamName = freezed,Object? team1Placement = freezed,Object? team2Placement = freezed,Object? playerTeamPlacement = freezed,Object? opponentTeamPlacement = freezed,}) {
  return _then(EnhancedMatchPerformance(
basePerformance: null == basePerformance ? _self.basePerformance : basePerformance // ignore: cast_nullable_to_non_nullable
as MatchPerformance,team1Name: freezed == team1Name ? _self.team1Name : team1Name // ignore: cast_nullable_to_non_nullable
as String?,team2Name: freezed == team2Name ? _self.team2Name : team2Name // ignore: cast_nullable_to_non_nullable
as String?,playerTeamName: freezed == playerTeamName ? _self.playerTeamName : playerTeamName // ignore: cast_nullable_to_non_nullable
as String?,opponentTeamName: freezed == opponentTeamName ? _self.opponentTeamName : opponentTeamName // ignore: cast_nullable_to_non_nullable
as String?,team1Placement: freezed == team1Placement ? _self.team1Placement : team1Placement // ignore: cast_nullable_to_non_nullable
as int?,team2Placement: freezed == team2Placement ? _self.team2Placement : team2Placement // ignore: cast_nullable_to_non_nullable
as int?,playerTeamPlacement: freezed == playerTeamPlacement ? _self.playerTeamPlacement : playerTeamPlacement // ignore: cast_nullable_to_non_nullable
as int?,opponentTeamPlacement: freezed == opponentTeamPlacement ? _self.opponentTeamPlacement : opponentTeamPlacement // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of EnhancedMatchPerformance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchPerformanceCopyWith<$Res> get basePerformance {
  
  return $MatchPerformanceCopyWith<$Res>(_self.basePerformance, (value) {
    return _then(_self.copyWith(basePerformance: value));
  });
}
}


/// Adds pattern-matching-related methods to [EnhancedMatchPerformance].
extension EnhancedMatchPerformancePatterns on EnhancedMatchPerformance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnhancedMatchPerformance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnhancedMatchPerformance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnhancedMatchPerformance value)  $default,){
final _that = this;
switch (_that) {
case _EnhancedMatchPerformance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnhancedMatchPerformance value)?  $default,){
final _that = this;
switch (_that) {
case _EnhancedMatchPerformance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MatchPerformance basePerformance,  String? team1Name,  String? team2Name,  String? playerTeamName,  String? opponentTeamName,  int? team1Placement,  int? team2Placement,  int? playerTeamPlacement,  int? opponentTeamPlacement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnhancedMatchPerformance() when $default != null:
return $default(_that.basePerformance,_that.team1Name,_that.team2Name,_that.playerTeamName,_that.opponentTeamName,_that.team1Placement,_that.team2Placement,_that.playerTeamPlacement,_that.opponentTeamPlacement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MatchPerformance basePerformance,  String? team1Name,  String? team2Name,  String? playerTeamName,  String? opponentTeamName,  int? team1Placement,  int? team2Placement,  int? playerTeamPlacement,  int? opponentTeamPlacement)  $default,) {final _that = this;
switch (_that) {
case _EnhancedMatchPerformance():
return $default(_that.basePerformance,_that.team1Name,_that.team2Name,_that.playerTeamName,_that.opponentTeamName,_that.team1Placement,_that.team2Placement,_that.playerTeamPlacement,_that.opponentTeamPlacement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MatchPerformance basePerformance,  String? team1Name,  String? team2Name,  String? playerTeamName,  String? opponentTeamName,  int? team1Placement,  int? team2Placement,  int? playerTeamPlacement,  int? opponentTeamPlacement)?  $default,) {final _that = this;
switch (_that) {
case _EnhancedMatchPerformance() when $default != null:
return $default(_that.basePerformance,_that.team1Name,_that.team2Name,_that.playerTeamName,_that.opponentTeamName,_that.team1Placement,_that.team2Placement,_that.playerTeamPlacement,_that.opponentTeamPlacement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnhancedMatchPerformance implements EnhancedMatchPerformance {
  const _EnhancedMatchPerformance({required this.basePerformance, this.team1Name, this.team2Name, this.playerTeamName, this.opponentTeamName, this.team1Placement, this.team2Placement, this.playerTeamPlacement, this.opponentTeamPlacement});
  factory _EnhancedMatchPerformance.fromJson(Map<String, dynamic> json) => _$EnhancedMatchPerformanceFromJson(json);

@override final  MatchPerformance basePerformance;
@override final  String? team1Name;
@override final  String? team2Name;
@override final  String? playerTeamName;
@override final  String? opponentTeamName;
@override final  int? team1Placement;
@override final  int? team2Placement;
@override final  int? playerTeamPlacement;
@override final  int? opponentTeamPlacement;

/// Create a copy of EnhancedMatchPerformance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnhancedMatchPerformanceCopyWith<_EnhancedMatchPerformance> get copyWith => __$EnhancedMatchPerformanceCopyWithImpl<_EnhancedMatchPerformance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnhancedMatchPerformanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnhancedMatchPerformance&&(identical(other.basePerformance, basePerformance) || other.basePerformance == basePerformance)&&(identical(other.team1Name, team1Name) || other.team1Name == team1Name)&&(identical(other.team2Name, team2Name) || other.team2Name == team2Name)&&(identical(other.playerTeamName, playerTeamName) || other.playerTeamName == playerTeamName)&&(identical(other.opponentTeamName, opponentTeamName) || other.opponentTeamName == opponentTeamName)&&(identical(other.team1Placement, team1Placement) || other.team1Placement == team1Placement)&&(identical(other.team2Placement, team2Placement) || other.team2Placement == team2Placement)&&(identical(other.playerTeamPlacement, playerTeamPlacement) || other.playerTeamPlacement == playerTeamPlacement)&&(identical(other.opponentTeamPlacement, opponentTeamPlacement) || other.opponentTeamPlacement == opponentTeamPlacement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,basePerformance,team1Name,team2Name,playerTeamName,opponentTeamName,team1Placement,team2Placement,playerTeamPlacement,opponentTeamPlacement);
}

@override
String toString() {
    return 'EnhancedMatchPerformance(basePerformance: $basePerformance, team1Name: $team1Name, team2Name: $team2Name, playerTeamName: $playerTeamName, opponentTeamName: $opponentTeamName, team1Placement: $team1Placement, team2Placement: $team2Placement, playerTeamPlacement: $playerTeamPlacement, opponentTeamPlacement: $opponentTeamPlacement)';
}


}

/// @nodoc
abstract mixin class _$EnhancedMatchPerformanceCopyWith<$Res> implements $EnhancedMatchPerformanceCopyWith<$Res> {
  factory _$EnhancedMatchPerformanceCopyWith(_EnhancedMatchPerformance value, $Res Function(_EnhancedMatchPerformance) _then) = __$EnhancedMatchPerformanceCopyWithImpl;
@override @useResult
$Res call({
 MatchPerformance basePerformance, String? team1Name, String? team2Name, String? playerTeamName, String? opponentTeamName, int? team1Placement, int? team2Placement, int? playerTeamPlacement, int? opponentTeamPlacement
});


@override $MatchPerformanceCopyWith<$Res> get basePerformance;

}
/// @nodoc
class __$EnhancedMatchPerformanceCopyWithImpl<$Res>
    implements _$EnhancedMatchPerformanceCopyWith<$Res> {
  __$EnhancedMatchPerformanceCopyWithImpl(this._self, this._then);

  final _EnhancedMatchPerformance _self;
  final $Res Function(_EnhancedMatchPerformance) _then;

/// Create a copy of EnhancedMatchPerformance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? basePerformance = null,Object? team1Name = freezed,Object? team2Name = freezed,Object? playerTeamName = freezed,Object? opponentTeamName = freezed,Object? team1Placement = freezed,Object? team2Placement = freezed,Object? playerTeamPlacement = freezed,Object? opponentTeamPlacement = freezed,}) {
  return _then(_EnhancedMatchPerformance(
basePerformance: null == basePerformance ? _self.basePerformance : basePerformance // ignore: cast_nullable_to_non_nullable
as MatchPerformance,team1Name: freezed == team1Name ? _self.team1Name : team1Name // ignore: cast_nullable_to_non_nullable
as String?,team2Name: freezed == team2Name ? _self.team2Name : team2Name // ignore: cast_nullable_to_non_nullable
as String?,playerTeamName: freezed == playerTeamName ? _self.playerTeamName : playerTeamName // ignore: cast_nullable_to_non_nullable
as String?,opponentTeamName: freezed == opponentTeamName ? _self.opponentTeamName : opponentTeamName // ignore: cast_nullable_to_non_nullable
as String?,team1Placement: freezed == team1Placement ? _self.team1Placement : team1Placement // ignore: cast_nullable_to_non_nullable
as int?,team2Placement: freezed == team2Placement ? _self.team2Placement : team2Placement // ignore: cast_nullable_to_non_nullable
as int?,playerTeamPlacement: freezed == playerTeamPlacement ? _self.playerTeamPlacement : playerTeamPlacement // ignore: cast_nullable_to_non_nullable
as int?,opponentTeamPlacement: freezed == opponentTeamPlacement ? _self.opponentTeamPlacement : opponentTeamPlacement // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of EnhancedMatchPerformance
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MatchPerformanceCopyWith<$Res> get basePerformance {
  
  return $MatchPerformanceCopyWith<$Res>(_self.basePerformance, (value) {
    return _then(_self.copyWith(basePerformance: value));
  });
}
}

// dart format on
