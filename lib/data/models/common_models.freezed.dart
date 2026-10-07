// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketSeller {

 String get id; String get name;
/// Create a copy of MarketSeller
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketSellerCopyWith<MarketSeller> get copyWith => _$MarketSellerCopyWithImpl<MarketSeller>(this as MarketSeller, _$identity);

  /// Serializes this MarketSeller to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketSeller;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSeller&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketSeller;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as MarketSeller;
  return 'MarketSeller(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $MarketSellerCopyWith<$Res>  {
  factory $MarketSellerCopyWith(MarketSeller value, $Res Function(MarketSeller) _then) = _$MarketSellerCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$MarketSellerCopyWithImpl<$Res>
    implements $MarketSellerCopyWith<$Res> {
  _$MarketSellerCopyWithImpl(this._self, this._then);

  final MarketSeller _self;
  final $Res Function(MarketSeller) _then;

/// Create a copy of MarketSeller
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(MarketSeller(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketSeller].
extension MarketSellerPatterns on MarketSeller {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketSeller value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketSeller() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketSeller value)  $default,){
final _that = this;
switch (_that) {
case _MarketSeller():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketSeller value)?  $default,){
final _that = this;
switch (_that) {
case _MarketSeller() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketSeller() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _MarketSeller():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _MarketSeller() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketSeller implements MarketSeller {
  const _MarketSeller({required this.id, required this.name});
  factory _MarketSeller.fromJson(Map<String, dynamic> json) => _$MarketSellerFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of MarketSeller
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketSellerCopyWith<_MarketSeller> get copyWith => __$MarketSellerCopyWithImpl<_MarketSeller>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketSellerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketSeller&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'MarketSeller(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MarketSellerCopyWith<$Res> implements $MarketSellerCopyWith<$Res> {
  factory _$MarketSellerCopyWith(_MarketSeller value, $Res Function(_MarketSeller) _then) = __$MarketSellerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$MarketSellerCopyWithImpl<$Res>
    implements _$MarketSellerCopyWith<$Res> {
  __$MarketSellerCopyWithImpl(this._self, this._then);

  final _MarketSeller _self;
  final $Res Function(_MarketSeller) _then;

/// Create a copy of MarketSeller
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MarketSeller(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PlayerOwner {

 String get i; String get n; String? get uim; bool? get isvf; int? get st;
/// Create a copy of PlayerOwner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerOwnerCopyWith<PlayerOwner> get copyWith => _$PlayerOwnerCopyWithImpl<PlayerOwner>(this as PlayerOwner, _$identity);

  /// Serializes this PlayerOwner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerOwner;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerOwner&&(identical(other.i, _this.i) || other.i == _this.i)&&(identical(other.n, _this.n) || other.n == _this.n)&&(identical(other.uim, _this.uim) || other.uim == _this.uim)&&(identical(other.isvf, _this.isvf) || other.isvf == _this.isvf)&&(identical(other.st, _this.st) || other.st == _this.st));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerOwner;
  return Object.hash(runtimeType,_this.i,_this.n,_this.uim,_this.isvf,_this.st);
}

@override
String toString() {
  final _this = this as PlayerOwner;
  return 'PlayerOwner(i: ${_this.i}, n: ${_this.n}, uim: ${_this.uim}, isvf: ${_this.isvf}, st: ${_this.st})';
}


}

/// @nodoc
abstract mixin class $PlayerOwnerCopyWith<$Res>  {
  factory $PlayerOwnerCopyWith(PlayerOwner value, $Res Function(PlayerOwner) _then) = _$PlayerOwnerCopyWithImpl;
@useResult
$Res call({
 String i, String n, String? uim, bool? isvf, int? st
});




}
/// @nodoc
class _$PlayerOwnerCopyWithImpl<$Res>
    implements $PlayerOwnerCopyWith<$Res> {
  _$PlayerOwnerCopyWithImpl(this._self, this._then);

  final PlayerOwner _self;
  final $Res Function(PlayerOwner) _then;

/// Create a copy of PlayerOwner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? i = null,Object? n = null,Object? uim = freezed,Object? isvf = freezed,Object? st = freezed,}) {
  return _then(PlayerOwner(
i: null == i ? _self.i : i // ignore: cast_nullable_to_non_nullable
as String,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as String,uim: freezed == uim ? _self.uim : uim // ignore: cast_nullable_to_non_nullable
as String?,isvf: freezed == isvf ? _self.isvf : isvf // ignore: cast_nullable_to_non_nullable
as bool?,st: freezed == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerOwner].
extension PlayerOwnerPatterns on PlayerOwner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerOwner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerOwner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerOwner value)  $default,){
final _that = this;
switch (_that) {
case _PlayerOwner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerOwner value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerOwner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String i,  String n,  String? uim,  bool? isvf,  int? st)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerOwner() when $default != null:
return $default(_that.i,_that.n,_that.uim,_that.isvf,_that.st);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String i,  String n,  String? uim,  bool? isvf,  int? st)  $default,) {final _that = this;
switch (_that) {
case _PlayerOwner():
return $default(_that.i,_that.n,_that.uim,_that.isvf,_that.st);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String i,  String n,  String? uim,  bool? isvf,  int? st)?  $default,) {final _that = this;
switch (_that) {
case _PlayerOwner() when $default != null:
return $default(_that.i,_that.n,_that.uim,_that.isvf,_that.st);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerOwner implements PlayerOwner {
  const _PlayerOwner({required this.i, required this.n, this.uim, this.isvf, this.st});
  factory _PlayerOwner.fromJson(Map<String, dynamic> json) => _$PlayerOwnerFromJson(json);

@override final  String i;
@override final  String n;
@override final  String? uim;
@override final  bool? isvf;
@override final  int? st;

/// Create a copy of PlayerOwner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerOwnerCopyWith<_PlayerOwner> get copyWith => __$PlayerOwnerCopyWithImpl<_PlayerOwner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerOwnerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerOwner&&(identical(other.i, i) || other.i == i)&&(identical(other.n, n) || other.n == n)&&(identical(other.uim, uim) || other.uim == uim)&&(identical(other.isvf, isvf) || other.isvf == isvf)&&(identical(other.st, st) || other.st == st));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,i,n,uim,isvf,st);
}

@override
String toString() {
    return 'PlayerOwner(i: $i, n: $n, uim: $uim, isvf: $isvf, st: $st)';
}


}

/// @nodoc
abstract mixin class _$PlayerOwnerCopyWith<$Res> implements $PlayerOwnerCopyWith<$Res> {
  factory _$PlayerOwnerCopyWith(_PlayerOwner value, $Res Function(_PlayerOwner) _then) = __$PlayerOwnerCopyWithImpl;
@override @useResult
$Res call({
 String i, String n, String? uim, bool? isvf, int? st
});




}
/// @nodoc
class __$PlayerOwnerCopyWithImpl<$Res>
    implements _$PlayerOwnerCopyWith<$Res> {
  __$PlayerOwnerCopyWithImpl(this._self, this._then);

  final _PlayerOwner _self;
  final $Res Function(_PlayerOwner) _then;

/// Create a copy of PlayerOwner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? i = null,Object? n = null,Object? uim = freezed,Object? isvf = freezed,Object? st = freezed,}) {
  return _then(_PlayerOwner(
i: null == i ? _self.i : i // ignore: cast_nullable_to_non_nullable
as String,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as String,uim: freezed == uim ? _self.uim : uim // ignore: cast_nullable_to_non_nullable
as String?,isvf: freezed == isvf ? _self.isvf : isvf // ignore: cast_nullable_to_non_nullable
as bool?,st: freezed == st ? _self.st : st // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TeamInfo {

 String get tid; String get tn; int get pl;
/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamInfoCopyWith<TeamInfo> get copyWith => _$TeamInfoCopyWithImpl<TeamInfo>(this as TeamInfo, _$identity);

  /// Serializes this TeamInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamInfo&&(identical(other.tid, _this.tid) || other.tid == _this.tid)&&(identical(other.tn, _this.tn) || other.tn == _this.tn)&&(identical(other.pl, _this.pl) || other.pl == _this.pl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamInfo;
  return Object.hash(runtimeType,_this.tid,_this.tn,_this.pl);
}

@override
String toString() {
  final _this = this as TeamInfo;
  return 'TeamInfo(tid: ${_this.tid}, tn: ${_this.tn}, pl: ${_this.pl})';
}


}

/// @nodoc
abstract mixin class $TeamInfoCopyWith<$Res>  {
  factory $TeamInfoCopyWith(TeamInfo value, $Res Function(TeamInfo) _then) = _$TeamInfoCopyWithImpl;
@useResult
$Res call({
 String tid, String tn, int pl
});




}
/// @nodoc
class _$TeamInfoCopyWithImpl<$Res>
    implements $TeamInfoCopyWith<$Res> {
  _$TeamInfoCopyWithImpl(this._self, this._then);

  final TeamInfo _self;
  final $Res Function(TeamInfo) _then;

/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tid = null,Object? tn = null,Object? pl = null,}) {
  return _then(TeamInfo(
tid: null == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as String,tn: null == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String,pl: null == pl ? _self.pl : pl // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamInfo].
extension TeamInfoPatterns on TeamInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamInfo value)  $default,){
final _that = this;
switch (_that) {
case _TeamInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TeamInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tid,  String tn,  int pl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamInfo() when $default != null:
return $default(_that.tid,_that.tn,_that.pl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tid,  String tn,  int pl)  $default,) {final _that = this;
switch (_that) {
case _TeamInfo():
return $default(_that.tid,_that.tn,_that.pl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tid,  String tn,  int pl)?  $default,) {final _that = this;
switch (_that) {
case _TeamInfo() when $default != null:
return $default(_that.tid,_that.tn,_that.pl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamInfo implements TeamInfo {
  const _TeamInfo({required this.tid, required this.tn, required this.pl});
  factory _TeamInfo.fromJson(Map<String, dynamic> json) => _$TeamInfoFromJson(json);

@override final  String tid;
@override final  String tn;
@override final  int pl;

/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamInfoCopyWith<_TeamInfo> get copyWith => __$TeamInfoCopyWithImpl<_TeamInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamInfo&&(identical(other.tid, tid) || other.tid == tid)&&(identical(other.tn, tn) || other.tn == tn)&&(identical(other.pl, pl) || other.pl == pl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tid,tn,pl);
}

@override
String toString() {
    return 'TeamInfo(tid: $tid, tn: $tn, pl: $pl)';
}


}

/// @nodoc
abstract mixin class _$TeamInfoCopyWith<$Res> implements $TeamInfoCopyWith<$Res> {
  factory _$TeamInfoCopyWith(_TeamInfo value, $Res Function(_TeamInfo) _then) = __$TeamInfoCopyWithImpl;
@override @useResult
$Res call({
 String tid, String tn, int pl
});




}
/// @nodoc
class __$TeamInfoCopyWithImpl<$Res>
    implements _$TeamInfoCopyWith<$Res> {
  __$TeamInfoCopyWithImpl(this._self, this._then);

  final _TeamInfo _self;
  final $Res Function(_TeamInfo) _then;

/// Create a copy of TeamInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tid = null,Object? tn = null,Object? pl = null,}) {
  return _then(_TeamInfo(
tid: null == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as String,tn: null == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String,pl: null == pl ? _self.pl : pl // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TeamStats {

 int get teamValue; int get teamValueTrend; int get budget; int get points; int get placement; int get won; int get drawn; int get lost;
/// Create a copy of TeamStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatsCopyWith<TeamStats> get copyWith => _$TeamStatsCopyWithImpl<TeamStats>(this as TeamStats, _$identity);

  /// Serializes this TeamStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStats&&(identical(other.teamValue, _this.teamValue) || other.teamValue == _this.teamValue)&&(identical(other.teamValueTrend, _this.teamValueTrend) || other.teamValueTrend == _this.teamValueTrend)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.placement, _this.placement) || other.placement == _this.placement)&&(identical(other.won, _this.won) || other.won == _this.won)&&(identical(other.drawn, _this.drawn) || other.drawn == _this.drawn)&&(identical(other.lost, _this.lost) || other.lost == _this.lost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamStats;
  return Object.hash(runtimeType,_this.teamValue,_this.teamValueTrend,_this.budget,_this.points,_this.placement,_this.won,_this.drawn,_this.lost);
}

@override
String toString() {
  final _this = this as TeamStats;
  return 'TeamStats(teamValue: ${_this.teamValue}, teamValueTrend: ${_this.teamValueTrend}, budget: ${_this.budget}, points: ${_this.points}, placement: ${_this.placement}, won: ${_this.won}, drawn: ${_this.drawn}, lost: ${_this.lost})';
}


}

/// @nodoc
abstract mixin class $TeamStatsCopyWith<$Res>  {
  factory $TeamStatsCopyWith(TeamStats value, $Res Function(TeamStats) _then) = _$TeamStatsCopyWithImpl;
@useResult
$Res call({
 int teamValue, int teamValueTrend, int budget, int points, int placement, int won, int drawn, int lost
});




}
/// @nodoc
class _$TeamStatsCopyWithImpl<$Res>
    implements $TeamStatsCopyWith<$Res> {
  _$TeamStatsCopyWithImpl(this._self, this._then);

  final TeamStats _self;
  final $Res Function(TeamStats) _then;

/// Create a copy of TeamStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamValue = null,Object? teamValueTrend = null,Object? budget = null,Object? points = null,Object? placement = null,Object? won = null,Object? drawn = null,Object? lost = null,}) {
  return _then(TeamStats(
teamValue: null == teamValue ? _self.teamValue : teamValue // ignore: cast_nullable_to_non_nullable
as int,teamValueTrend: null == teamValueTrend ? _self.teamValueTrend : teamValueTrend // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,placement: null == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as int,won: null == won ? _self.won : won // ignore: cast_nullable_to_non_nullable
as int,drawn: null == drawn ? _self.drawn : drawn // ignore: cast_nullable_to_non_nullable
as int,lost: null == lost ? _self.lost : lost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamStats].
extension TeamStatsPatterns on TeamStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStats value)  $default,){
final _that = this;
switch (_that) {
case _TeamStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStats value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int teamValue,  int teamValueTrend,  int budget,  int points,  int placement,  int won,  int drawn,  int lost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStats() when $default != null:
return $default(_that.teamValue,_that.teamValueTrend,_that.budget,_that.points,_that.placement,_that.won,_that.drawn,_that.lost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int teamValue,  int teamValueTrend,  int budget,  int points,  int placement,  int won,  int drawn,  int lost)  $default,) {final _that = this;
switch (_that) {
case _TeamStats():
return $default(_that.teamValue,_that.teamValueTrend,_that.budget,_that.points,_that.placement,_that.won,_that.drawn,_that.lost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int teamValue,  int teamValueTrend,  int budget,  int points,  int placement,  int won,  int drawn,  int lost)?  $default,) {final _that = this;
switch (_that) {
case _TeamStats() when $default != null:
return $default(_that.teamValue,_that.teamValueTrend,_that.budget,_that.points,_that.placement,_that.won,_that.drawn,_that.lost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStats implements TeamStats {
  const _TeamStats({required this.teamValue, required this.teamValueTrend, required this.budget, required this.points, required this.placement, required this.won, required this.drawn, required this.lost});
  factory _TeamStats.fromJson(Map<String, dynamic> json) => _$TeamStatsFromJson(json);

@override final  int teamValue;
@override final  int teamValueTrend;
@override final  int budget;
@override final  int points;
@override final  int placement;
@override final  int won;
@override final  int drawn;
@override final  int lost;

/// Create a copy of TeamStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatsCopyWith<_TeamStats> get copyWith => __$TeamStatsCopyWithImpl<_TeamStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStats&&(identical(other.teamValue, teamValue) || other.teamValue == teamValue)&&(identical(other.teamValueTrend, teamValueTrend) || other.teamValueTrend == teamValueTrend)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.points, points) || other.points == points)&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.won, won) || other.won == won)&&(identical(other.drawn, drawn) || other.drawn == drawn)&&(identical(other.lost, lost) || other.lost == lost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,teamValue,teamValueTrend,budget,points,placement,won,drawn,lost);
}

@override
String toString() {
    return 'TeamStats(teamValue: $teamValue, teamValueTrend: $teamValueTrend, budget: $budget, points: $points, placement: $placement, won: $won, drawn: $drawn, lost: $lost)';
}


}

/// @nodoc
abstract mixin class _$TeamStatsCopyWith<$Res> implements $TeamStatsCopyWith<$Res> {
  factory _$TeamStatsCopyWith(_TeamStats value, $Res Function(_TeamStats) _then) = __$TeamStatsCopyWithImpl;
@override @useResult
$Res call({
 int teamValue, int teamValueTrend, int budget, int points, int placement, int won, int drawn, int lost
});




}
/// @nodoc
class __$TeamStatsCopyWithImpl<$Res>
    implements _$TeamStatsCopyWith<$Res> {
  __$TeamStatsCopyWithImpl(this._self, this._then);

  final _TeamStats _self;
  final $Res Function(_TeamStats) _then;

/// Create a copy of TeamStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamValue = null,Object? teamValueTrend = null,Object? budget = null,Object? points = null,Object? placement = null,Object? won = null,Object? drawn = null,Object? lost = null,}) {
  return _then(_TeamStats(
teamValue: null == teamValue ? _self.teamValue : teamValue // ignore: cast_nullable_to_non_nullable
as int,teamValueTrend: null == teamValueTrend ? _self.teamValueTrend : teamValueTrend // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,placement: null == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as int,won: null == won ? _self.won : won // ignore: cast_nullable_to_non_nullable
as int,drawn: null == drawn ? _self.drawn : drawn // ignore: cast_nullable_to_non_nullable
as int,lost: null == lost ? _self.lost : lost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$UserStats {

 int get teamValue; int get teamValueTrend; int get budget; int get points; int get placement; int get won; int get drawn; int get lost;
/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsCopyWith<UserStats> get copyWith => _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStats&&(identical(other.teamValue, _this.teamValue) || other.teamValue == _this.teamValue)&&(identical(other.teamValueTrend, _this.teamValueTrend) || other.teamValueTrend == _this.teamValueTrend)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.placement, _this.placement) || other.placement == _this.placement)&&(identical(other.won, _this.won) || other.won == _this.won)&&(identical(other.drawn, _this.drawn) || other.drawn == _this.drawn)&&(identical(other.lost, _this.lost) || other.lost == _this.lost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserStats;
  return Object.hash(runtimeType,_this.teamValue,_this.teamValueTrend,_this.budget,_this.points,_this.placement,_this.won,_this.drawn,_this.lost);
}

@override
String toString() {
  final _this = this as UserStats;
  return 'UserStats(teamValue: ${_this.teamValue}, teamValueTrend: ${_this.teamValueTrend}, budget: ${_this.budget}, points: ${_this.points}, placement: ${_this.placement}, won: ${_this.won}, drawn: ${_this.drawn}, lost: ${_this.lost})';
}


}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res>  {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) = _$UserStatsCopyWithImpl;
@useResult
$Res call({
 int teamValue, int teamValueTrend, int budget, int points, int placement, int won, int drawn, int lost
});




}
/// @nodoc
class _$UserStatsCopyWithImpl<$Res>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamValue = null,Object? teamValueTrend = null,Object? budget = null,Object? points = null,Object? placement = null,Object? won = null,Object? drawn = null,Object? lost = null,}) {
  return _then(UserStats(
teamValue: null == teamValue ? _self.teamValue : teamValue // ignore: cast_nullable_to_non_nullable
as int,teamValueTrend: null == teamValueTrend ? _self.teamValueTrend : teamValueTrend // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,placement: null == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as int,won: null == won ? _self.won : won // ignore: cast_nullable_to_non_nullable
as int,drawn: null == drawn ? _self.drawn : drawn // ignore: cast_nullable_to_non_nullable
as int,lost: null == lost ? _self.lost : lost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStats].
extension UserStatsPatterns on UserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStats value)  $default,){
final _that = this;
switch (_that) {
case _UserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int teamValue,  int teamValueTrend,  int budget,  int points,  int placement,  int won,  int drawn,  int lost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.teamValue,_that.teamValueTrend,_that.budget,_that.points,_that.placement,_that.won,_that.drawn,_that.lost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int teamValue,  int teamValueTrend,  int budget,  int points,  int placement,  int won,  int drawn,  int lost)  $default,) {final _that = this;
switch (_that) {
case _UserStats():
return $default(_that.teamValue,_that.teamValueTrend,_that.budget,_that.points,_that.placement,_that.won,_that.drawn,_that.lost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int teamValue,  int teamValueTrend,  int budget,  int points,  int placement,  int won,  int drawn,  int lost)?  $default,) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.teamValue,_that.teamValueTrend,_that.budget,_that.points,_that.placement,_that.won,_that.drawn,_that.lost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStats implements UserStats {
  const _UserStats({required this.teamValue, required this.teamValueTrend, required this.budget, required this.points, required this.placement, required this.won, required this.drawn, required this.lost});
  factory _UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);

@override final  int teamValue;
@override final  int teamValueTrend;
@override final  int budget;
@override final  int points;
@override final  int placement;
@override final  int won;
@override final  int drawn;
@override final  int lost;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsCopyWith<_UserStats> get copyWith => __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStats&&(identical(other.teamValue, teamValue) || other.teamValue == teamValue)&&(identical(other.teamValueTrend, teamValueTrend) || other.teamValueTrend == teamValueTrend)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.points, points) || other.points == points)&&(identical(other.placement, placement) || other.placement == placement)&&(identical(other.won, won) || other.won == won)&&(identical(other.drawn, drawn) || other.drawn == drawn)&&(identical(other.lost, lost) || other.lost == lost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,teamValue,teamValueTrend,budget,points,placement,won,drawn,lost);
}

@override
String toString() {
    return 'UserStats(teamValue: $teamValue, teamValueTrend: $teamValueTrend, budget: $budget, points: $points, placement: $placement, won: $won, drawn: $drawn, lost: $lost)';
}


}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res> implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(_UserStats value, $Res Function(_UserStats) _then) = __$UserStatsCopyWithImpl;
@override @useResult
$Res call({
 int teamValue, int teamValueTrend, int budget, int points, int placement, int won, int drawn, int lost
});




}
/// @nodoc
class __$UserStatsCopyWithImpl<$Res>
    implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamValue = null,Object? teamValueTrend = null,Object? budget = null,Object? points = null,Object? placement = null,Object? won = null,Object? drawn = null,Object? lost = null,}) {
  return _then(_UserStats(
teamValue: null == teamValue ? _self.teamValue : teamValue // ignore: cast_nullable_to_non_nullable
as int,teamValueTrend: null == teamValueTrend ? _self.teamValueTrend : teamValueTrend // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,placement: null == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as int,won: null == won ? _self.won : won // ignore: cast_nullable_to_non_nullable
as int,drawn: null == drawn ? _self.drawn : drawn // ignore: cast_nullable_to_non_nullable
as int,lost: null == lost ? _self.lost : lost // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TeamProfileResponse {

 String get tid; String get tn; int get pl; int get tv; int get tw; int get td; int get tl; int get npt; bool get avpcl;
/// Create a copy of TeamProfileResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamProfileResponseCopyWith<TeamProfileResponse> get copyWith => _$TeamProfileResponseCopyWithImpl<TeamProfileResponse>(this as TeamProfileResponse, _$identity);

  /// Serializes this TeamProfileResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamProfileResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamProfileResponse&&(identical(other.tid, _this.tid) || other.tid == _this.tid)&&(identical(other.tn, _this.tn) || other.tn == _this.tn)&&(identical(other.pl, _this.pl) || other.pl == _this.pl)&&(identical(other.tv, _this.tv) || other.tv == _this.tv)&&(identical(other.tw, _this.tw) || other.tw == _this.tw)&&(identical(other.td, _this.td) || other.td == _this.td)&&(identical(other.tl, _this.tl) || other.tl == _this.tl)&&(identical(other.npt, _this.npt) || other.npt == _this.npt)&&(identical(other.avpcl, _this.avpcl) || other.avpcl == _this.avpcl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamProfileResponse;
  return Object.hash(runtimeType,_this.tid,_this.tn,_this.pl,_this.tv,_this.tw,_this.td,_this.tl,_this.npt,_this.avpcl);
}

@override
String toString() {
  final _this = this as TeamProfileResponse;
  return 'TeamProfileResponse(tid: ${_this.tid}, tn: ${_this.tn}, pl: ${_this.pl}, tv: ${_this.tv}, tw: ${_this.tw}, td: ${_this.td}, tl: ${_this.tl}, npt: ${_this.npt}, avpcl: ${_this.avpcl})';
}


}

/// @nodoc
abstract mixin class $TeamProfileResponseCopyWith<$Res>  {
  factory $TeamProfileResponseCopyWith(TeamProfileResponse value, $Res Function(TeamProfileResponse) _then) = _$TeamProfileResponseCopyWithImpl;
@useResult
$Res call({
 String tid, String tn, int pl, int tv, int tw, int td, int tl, int npt, bool avpcl
});




}
/// @nodoc
class _$TeamProfileResponseCopyWithImpl<$Res>
    implements $TeamProfileResponseCopyWith<$Res> {
  _$TeamProfileResponseCopyWithImpl(this._self, this._then);

  final TeamProfileResponse _self;
  final $Res Function(TeamProfileResponse) _then;

/// Create a copy of TeamProfileResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tid = null,Object? tn = null,Object? pl = null,Object? tv = null,Object? tw = null,Object? td = null,Object? tl = null,Object? npt = null,Object? avpcl = null,}) {
  return _then(TeamProfileResponse(
tid: null == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as String,tn: null == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String,pl: null == pl ? _self.pl : pl // ignore: cast_nullable_to_non_nullable
as int,tv: null == tv ? _self.tv : tv // ignore: cast_nullable_to_non_nullable
as int,tw: null == tw ? _self.tw : tw // ignore: cast_nullable_to_non_nullable
as int,td: null == td ? _self.td : td // ignore: cast_nullable_to_non_nullable
as int,tl: null == tl ? _self.tl : tl // ignore: cast_nullable_to_non_nullable
as int,npt: null == npt ? _self.npt : npt // ignore: cast_nullable_to_non_nullable
as int,avpcl: null == avpcl ? _self.avpcl : avpcl // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamProfileResponse].
extension TeamProfileResponsePatterns on TeamProfileResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamProfileResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamProfileResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamProfileResponse value)  $default,){
final _that = this;
switch (_that) {
case _TeamProfileResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamProfileResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TeamProfileResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tid,  String tn,  int pl,  int tv,  int tw,  int td,  int tl,  int npt,  bool avpcl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamProfileResponse() when $default != null:
return $default(_that.tid,_that.tn,_that.pl,_that.tv,_that.tw,_that.td,_that.tl,_that.npt,_that.avpcl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tid,  String tn,  int pl,  int tv,  int tw,  int td,  int tl,  int npt,  bool avpcl)  $default,) {final _that = this;
switch (_that) {
case _TeamProfileResponse():
return $default(_that.tid,_that.tn,_that.pl,_that.tv,_that.tw,_that.td,_that.tl,_that.npt,_that.avpcl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tid,  String tn,  int pl,  int tv,  int tw,  int td,  int tl,  int npt,  bool avpcl)?  $default,) {final _that = this;
switch (_that) {
case _TeamProfileResponse() when $default != null:
return $default(_that.tid,_that.tn,_that.pl,_that.tv,_that.tw,_that.td,_that.tl,_that.npt,_that.avpcl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamProfileResponse implements TeamProfileResponse {
  const _TeamProfileResponse({required this.tid, required this.tn, required this.pl, required this.tv, required this.tw, required this.td, required this.tl, required this.npt, required this.avpcl});
  factory _TeamProfileResponse.fromJson(Map<String, dynamic> json) => _$TeamProfileResponseFromJson(json);

@override final  String tid;
@override final  String tn;
@override final  int pl;
@override final  int tv;
@override final  int tw;
@override final  int td;
@override final  int tl;
@override final  int npt;
@override final  bool avpcl;

/// Create a copy of TeamProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamProfileResponseCopyWith<_TeamProfileResponse> get copyWith => __$TeamProfileResponseCopyWithImpl<_TeamProfileResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamProfileResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamProfileResponse&&(identical(other.tid, tid) || other.tid == tid)&&(identical(other.tn, tn) || other.tn == tn)&&(identical(other.pl, pl) || other.pl == pl)&&(identical(other.tv, tv) || other.tv == tv)&&(identical(other.tw, tw) || other.tw == tw)&&(identical(other.td, td) || other.td == td)&&(identical(other.tl, tl) || other.tl == tl)&&(identical(other.npt, npt) || other.npt == npt)&&(identical(other.avpcl, avpcl) || other.avpcl == avpcl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tid,tn,pl,tv,tw,td,tl,npt,avpcl);
}

@override
String toString() {
    return 'TeamProfileResponse(tid: $tid, tn: $tn, pl: $pl, tv: $tv, tw: $tw, td: $td, tl: $tl, npt: $npt, avpcl: $avpcl)';
}


}

/// @nodoc
abstract mixin class _$TeamProfileResponseCopyWith<$Res> implements $TeamProfileResponseCopyWith<$Res> {
  factory _$TeamProfileResponseCopyWith(_TeamProfileResponse value, $Res Function(_TeamProfileResponse) _then) = __$TeamProfileResponseCopyWithImpl;
@override @useResult
$Res call({
 String tid, String tn, int pl, int tv, int tw, int td, int tl, int npt, bool avpcl
});




}
/// @nodoc
class __$TeamProfileResponseCopyWithImpl<$Res>
    implements _$TeamProfileResponseCopyWith<$Res> {
  __$TeamProfileResponseCopyWithImpl(this._self, this._then);

  final _TeamProfileResponse _self;
  final $Res Function(_TeamProfileResponse) _then;

/// Create a copy of TeamProfileResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tid = null,Object? tn = null,Object? pl = null,Object? tv = null,Object? tw = null,Object? td = null,Object? tl = null,Object? npt = null,Object? avpcl = null,}) {
  return _then(_TeamProfileResponse(
tid: null == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as String,tn: null == tn ? _self.tn : tn // ignore: cast_nullable_to_non_nullable
as String,pl: null == pl ? _self.pl : pl // ignore: cast_nullable_to_non_nullable
as int,tv: null == tv ? _self.tv : tv // ignore: cast_nullable_to_non_nullable
as int,tw: null == tw ? _self.tw : tw // ignore: cast_nullable_to_non_nullable
as int,td: null == td ? _self.td : td // ignore: cast_nullable_to_non_nullable
as int,tl: null == tl ? _self.tl : tl // ignore: cast_nullable_to_non_nullable
as int,npt: null == npt ? _self.npt : npt // ignore: cast_nullable_to_non_nullable
as int,avpcl: null == avpcl ? _self.avpcl : avpcl // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
