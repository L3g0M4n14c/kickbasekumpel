// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketValueHistoryResponse {

 List<MarketValueEntry> get it; int? get prlo;
/// Create a copy of MarketValueHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketValueHistoryResponseCopyWith<MarketValueHistoryResponse> get copyWith => _$MarketValueHistoryResponseCopyWithImpl<MarketValueHistoryResponse>(this as MarketValueHistoryResponse, _$identity);

  /// Serializes this MarketValueHistoryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketValueHistoryResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketValueHistoryResponse&&const DeepCollectionEquality().equals(other.it, _this.it)&&(identical(other.prlo, _this.prlo) || other.prlo == _this.prlo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketValueHistoryResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.it),_this.prlo);
}

@override
String toString() {
  final _this = this as MarketValueHistoryResponse;
  return 'MarketValueHistoryResponse(it: ${_this.it}, prlo: ${_this.prlo})';
}


}

/// @nodoc
abstract mixin class $MarketValueHistoryResponseCopyWith<$Res>  {
  factory $MarketValueHistoryResponseCopyWith(MarketValueHistoryResponse value, $Res Function(MarketValueHistoryResponse) _then) = _$MarketValueHistoryResponseCopyWithImpl;
@useResult
$Res call({
 List<MarketValueEntry> it, int? prlo
});




}
/// @nodoc
class _$MarketValueHistoryResponseCopyWithImpl<$Res>
    implements $MarketValueHistoryResponseCopyWith<$Res> {
  _$MarketValueHistoryResponseCopyWithImpl(this._self, this._then);

  final MarketValueHistoryResponse _self;
  final $Res Function(MarketValueHistoryResponse) _then;

/// Create a copy of MarketValueHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? it = null,Object? prlo = freezed,}) {
  return _then(MarketValueHistoryResponse(
it: null == it ? _self.it : it // ignore: cast_nullable_to_non_nullable
as List<MarketValueEntry>,prlo: freezed == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketValueHistoryResponse].
extension MarketValueHistoryResponsePatterns on MarketValueHistoryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketValueHistoryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketValueHistoryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketValueHistoryResponse value)  $default,){
final _that = this;
switch (_that) {
case _MarketValueHistoryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketValueHistoryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MarketValueHistoryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MarketValueEntry> it,  int? prlo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketValueHistoryResponse() when $default != null:
return $default(_that.it,_that.prlo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MarketValueEntry> it,  int? prlo)  $default,) {final _that = this;
switch (_that) {
case _MarketValueHistoryResponse():
return $default(_that.it,_that.prlo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MarketValueEntry> it,  int? prlo)?  $default,) {final _that = this;
switch (_that) {
case _MarketValueHistoryResponse() when $default != null:
return $default(_that.it,_that.prlo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketValueHistoryResponse implements MarketValueHistoryResponse {
  const _MarketValueHistoryResponse({required  List<MarketValueEntry> it, this.prlo}): _it = it;
  factory _MarketValueHistoryResponse.fromJson(Map<String, dynamic> json) => _$MarketValueHistoryResponseFromJson(json);

 final  List<MarketValueEntry> _it;
@override List<MarketValueEntry> get it {
  if (_it is EqualUnmodifiableListView) return _it;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_it);
}

@override final  int? prlo;

/// Create a copy of MarketValueHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketValueHistoryResponseCopyWith<_MarketValueHistoryResponse> get copyWith => __$MarketValueHistoryResponseCopyWithImpl<_MarketValueHistoryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketValueHistoryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketValueHistoryResponse&&const DeepCollectionEquality().equals(other.it, _it)&&(identical(other.prlo, prlo) || other.prlo == prlo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_it),prlo);
}

@override
String toString() {
    return 'MarketValueHistoryResponse(it: $it, prlo: $prlo)';
}


}

/// @nodoc
abstract mixin class _$MarketValueHistoryResponseCopyWith<$Res> implements $MarketValueHistoryResponseCopyWith<$Res> {
  factory _$MarketValueHistoryResponseCopyWith(_MarketValueHistoryResponse value, $Res Function(_MarketValueHistoryResponse) _then) = __$MarketValueHistoryResponseCopyWithImpl;
@override @useResult
$Res call({
 List<MarketValueEntry> it, int? prlo
});




}
/// @nodoc
class __$MarketValueHistoryResponseCopyWithImpl<$Res>
    implements _$MarketValueHistoryResponseCopyWith<$Res> {
  __$MarketValueHistoryResponseCopyWithImpl(this._self, this._then);

  final _MarketValueHistoryResponse _self;
  final $Res Function(_MarketValueHistoryResponse) _then;

/// Create a copy of MarketValueHistoryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? it = null,Object? prlo = freezed,}) {
  return _then(_MarketValueHistoryResponse(
it: null == it ? _self._it : it // ignore: cast_nullable_to_non_nullable
as List<MarketValueEntry>,prlo: freezed == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MarketValueEntry {

 int get dt; int get mv;
/// Create a copy of MarketValueEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketValueEntryCopyWith<MarketValueEntry> get copyWith => _$MarketValueEntryCopyWithImpl<MarketValueEntry>(this as MarketValueEntry, _$identity);

  /// Serializes this MarketValueEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketValueEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketValueEntry&&(identical(other.dt, _this.dt) || other.dt == _this.dt)&&(identical(other.mv, _this.mv) || other.mv == _this.mv));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketValueEntry;
  return Object.hash(runtimeType,_this.dt,_this.mv);
}

@override
String toString() {
  final _this = this as MarketValueEntry;
  return 'MarketValueEntry(dt: ${_this.dt}, mv: ${_this.mv})';
}


}

/// @nodoc
abstract mixin class $MarketValueEntryCopyWith<$Res>  {
  factory $MarketValueEntryCopyWith(MarketValueEntry value, $Res Function(MarketValueEntry) _then) = _$MarketValueEntryCopyWithImpl;
@useResult
$Res call({
 int dt, int mv
});




}
/// @nodoc
class _$MarketValueEntryCopyWithImpl<$Res>
    implements $MarketValueEntryCopyWith<$Res> {
  _$MarketValueEntryCopyWithImpl(this._self, this._then);

  final MarketValueEntry _self;
  final $Res Function(MarketValueEntry) _then;

/// Create a copy of MarketValueEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dt = null,Object? mv = null,}) {
  return _then(MarketValueEntry(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,mv: null == mv ? _self.mv : mv // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketValueEntry].
extension MarketValueEntryPatterns on MarketValueEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketValueEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketValueEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketValueEntry value)  $default,){
final _that = this;
switch (_that) {
case _MarketValueEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketValueEntry value)?  $default,){
final _that = this;
switch (_that) {
case _MarketValueEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dt,  int mv)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketValueEntry() when $default != null:
return $default(_that.dt,_that.mv);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dt,  int mv)  $default,) {final _that = this;
switch (_that) {
case _MarketValueEntry():
return $default(_that.dt,_that.mv);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dt,  int mv)?  $default,) {final _that = this;
switch (_that) {
case _MarketValueEntry() when $default != null:
return $default(_that.dt,_that.mv);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketValueEntry implements MarketValueEntry {
  const _MarketValueEntry({required this.dt, required this.mv});
  factory _MarketValueEntry.fromJson(Map<String, dynamic> json) => _$MarketValueEntryFromJson(json);

@override final  int dt;
@override final  int mv;

/// Create a copy of MarketValueEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketValueEntryCopyWith<_MarketValueEntry> get copyWith => __$MarketValueEntryCopyWithImpl<_MarketValueEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketValueEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketValueEntry&&(identical(other.dt, dt) || other.dt == dt)&&(identical(other.mv, mv) || other.mv == mv));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dt,mv);
}

@override
String toString() {
    return 'MarketValueEntry(dt: $dt, mv: $mv)';
}


}

/// @nodoc
abstract mixin class _$MarketValueEntryCopyWith<$Res> implements $MarketValueEntryCopyWith<$Res> {
  factory _$MarketValueEntryCopyWith(_MarketValueEntry value, $Res Function(_MarketValueEntry) _then) = __$MarketValueEntryCopyWithImpl;
@override @useResult
$Res call({
 int dt, int mv
});




}
/// @nodoc
class __$MarketValueEntryCopyWithImpl<$Res>
    implements _$MarketValueEntryCopyWith<$Res> {
  __$MarketValueEntryCopyWithImpl(this._self, this._then);

  final _MarketValueEntry _self;
  final $Res Function(_MarketValueEntry) _then;

/// Create a copy of MarketValueEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dt = null,Object? mv = null,}) {
  return _then(_MarketValueEntry(
dt: null == dt ? _self.dt : dt // ignore: cast_nullable_to_non_nullable
as int,mv: null == mv ? _self.mv : mv // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DailyMarketValueChange {

 String get date; int get value; int get change; double get percentageChange; int get daysAgo;
/// Create a copy of DailyMarketValueChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMarketValueChangeCopyWith<DailyMarketValueChange> get copyWith => _$DailyMarketValueChangeCopyWithImpl<DailyMarketValueChange>(this as DailyMarketValueChange, _$identity);

  /// Serializes this DailyMarketValueChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailyMarketValueChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMarketValueChange&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.change, _this.change) || other.change == _this.change)&&(identical(other.percentageChange, _this.percentageChange) || other.percentageChange == _this.percentageChange)&&(identical(other.daysAgo, _this.daysAgo) || other.daysAgo == _this.daysAgo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailyMarketValueChange;
  return Object.hash(runtimeType,_this.date,_this.value,_this.change,_this.percentageChange,_this.daysAgo);
}

@override
String toString() {
  final _this = this as DailyMarketValueChange;
  return 'DailyMarketValueChange(date: ${_this.date}, value: ${_this.value}, change: ${_this.change}, percentageChange: ${_this.percentageChange}, daysAgo: ${_this.daysAgo})';
}


}

/// @nodoc
abstract mixin class $DailyMarketValueChangeCopyWith<$Res>  {
  factory $DailyMarketValueChangeCopyWith(DailyMarketValueChange value, $Res Function(DailyMarketValueChange) _then) = _$DailyMarketValueChangeCopyWithImpl;
@useResult
$Res call({
 String date, int value, int change, double percentageChange, int daysAgo
});




}
/// @nodoc
class _$DailyMarketValueChangeCopyWithImpl<$Res>
    implements $DailyMarketValueChangeCopyWith<$Res> {
  _$DailyMarketValueChangeCopyWithImpl(this._self, this._then);

  final DailyMarketValueChange _self;
  final $Res Function(DailyMarketValueChange) _then;

/// Create a copy of DailyMarketValueChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? value = null,Object? change = null,Object? percentageChange = null,Object? daysAgo = null,}) {
  return _then(DailyMarketValueChange(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as int,percentageChange: null == percentageChange ? _self.percentageChange : percentageChange // ignore: cast_nullable_to_non_nullable
as double,daysAgo: null == daysAgo ? _self.daysAgo : daysAgo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyMarketValueChange].
extension DailyMarketValueChangePatterns on DailyMarketValueChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyMarketValueChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyMarketValueChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyMarketValueChange value)  $default,){
final _that = this;
switch (_that) {
case _DailyMarketValueChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyMarketValueChange value)?  $default,){
final _that = this;
switch (_that) {
case _DailyMarketValueChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int value,  int change,  double percentageChange,  int daysAgo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMarketValueChange() when $default != null:
return $default(_that.date,_that.value,_that.change,_that.percentageChange,_that.daysAgo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int value,  int change,  double percentageChange,  int daysAgo)  $default,) {final _that = this;
switch (_that) {
case _DailyMarketValueChange():
return $default(_that.date,_that.value,_that.change,_that.percentageChange,_that.daysAgo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int value,  int change,  double percentageChange,  int daysAgo)?  $default,) {final _that = this;
switch (_that) {
case _DailyMarketValueChange() when $default != null:
return $default(_that.date,_that.value,_that.change,_that.percentageChange,_that.daysAgo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyMarketValueChange implements DailyMarketValueChange {
  const _DailyMarketValueChange({required this.date, required this.value, required this.change, required this.percentageChange, required this.daysAgo});
  factory _DailyMarketValueChange.fromJson(Map<String, dynamic> json) => _$DailyMarketValueChangeFromJson(json);

@override final  String date;
@override final  int value;
@override final  int change;
@override final  double percentageChange;
@override final  int daysAgo;

/// Create a copy of DailyMarketValueChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMarketValueChangeCopyWith<_DailyMarketValueChange> get copyWith => __$DailyMarketValueChangeCopyWithImpl<_DailyMarketValueChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyMarketValueChangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMarketValueChange&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value)&&(identical(other.change, change) || other.change == change)&&(identical(other.percentageChange, percentageChange) || other.percentageChange == percentageChange)&&(identical(other.daysAgo, daysAgo) || other.daysAgo == daysAgo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,value,change,percentageChange,daysAgo);
}

@override
String toString() {
    return 'DailyMarketValueChange(date: $date, value: $value, change: $change, percentageChange: $percentageChange, daysAgo: $daysAgo)';
}


}

/// @nodoc
abstract mixin class _$DailyMarketValueChangeCopyWith<$Res> implements $DailyMarketValueChangeCopyWith<$Res> {
  factory _$DailyMarketValueChangeCopyWith(_DailyMarketValueChange value, $Res Function(_DailyMarketValueChange) _then) = __$DailyMarketValueChangeCopyWithImpl;
@override @useResult
$Res call({
 String date, int value, int change, double percentageChange, int daysAgo
});




}
/// @nodoc
class __$DailyMarketValueChangeCopyWithImpl<$Res>
    implements _$DailyMarketValueChangeCopyWith<$Res> {
  __$DailyMarketValueChangeCopyWithImpl(this._self, this._then);

  final _DailyMarketValueChange _self;
  final $Res Function(_DailyMarketValueChange) _then;

/// Create a copy of DailyMarketValueChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? value = null,Object? change = null,Object? percentageChange = null,Object? daysAgo = null,}) {
  return _then(_DailyMarketValueChange(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as int,percentageChange: null == percentageChange ? _self.percentageChange : percentageChange // ignore: cast_nullable_to_non_nullable
as double,daysAgo: null == daysAgo ? _self.daysAgo : daysAgo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MarketValueChange {

 int get daysSinceLastUpdate; int get absoluteChange; double get percentageChange; int get previousValue; int get currentValue; List<DailyMarketValueChange> get dailyChanges;
/// Create a copy of MarketValueChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketValueChangeCopyWith<MarketValueChange> get copyWith => _$MarketValueChangeCopyWithImpl<MarketValueChange>(this as MarketValueChange, _$identity);

  /// Serializes this MarketValueChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketValueChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketValueChange&&(identical(other.daysSinceLastUpdate, _this.daysSinceLastUpdate) || other.daysSinceLastUpdate == _this.daysSinceLastUpdate)&&(identical(other.absoluteChange, _this.absoluteChange) || other.absoluteChange == _this.absoluteChange)&&(identical(other.percentageChange, _this.percentageChange) || other.percentageChange == _this.percentageChange)&&(identical(other.previousValue, _this.previousValue) || other.previousValue == _this.previousValue)&&(identical(other.currentValue, _this.currentValue) || other.currentValue == _this.currentValue)&&const DeepCollectionEquality().equals(other.dailyChanges, _this.dailyChanges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketValueChange;
  return Object.hash(runtimeType,_this.daysSinceLastUpdate,_this.absoluteChange,_this.percentageChange,_this.previousValue,_this.currentValue,const DeepCollectionEquality().hash(_this.dailyChanges));
}

@override
String toString() {
  final _this = this as MarketValueChange;
  return 'MarketValueChange(daysSinceLastUpdate: ${_this.daysSinceLastUpdate}, absoluteChange: ${_this.absoluteChange}, percentageChange: ${_this.percentageChange}, previousValue: ${_this.previousValue}, currentValue: ${_this.currentValue}, dailyChanges: ${_this.dailyChanges})';
}


}

/// @nodoc
abstract mixin class $MarketValueChangeCopyWith<$Res>  {
  factory $MarketValueChangeCopyWith(MarketValueChange value, $Res Function(MarketValueChange) _then) = _$MarketValueChangeCopyWithImpl;
@useResult
$Res call({
 int daysSinceLastUpdate, int absoluteChange, double percentageChange, int previousValue, int currentValue, List<DailyMarketValueChange> dailyChanges
});




}
/// @nodoc
class _$MarketValueChangeCopyWithImpl<$Res>
    implements $MarketValueChangeCopyWith<$Res> {
  _$MarketValueChangeCopyWithImpl(this._self, this._then);

  final MarketValueChange _self;
  final $Res Function(MarketValueChange) _then;

/// Create a copy of MarketValueChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? daysSinceLastUpdate = null,Object? absoluteChange = null,Object? percentageChange = null,Object? previousValue = null,Object? currentValue = null,Object? dailyChanges = null,}) {
  return _then(MarketValueChange(
daysSinceLastUpdate: null == daysSinceLastUpdate ? _self.daysSinceLastUpdate : daysSinceLastUpdate // ignore: cast_nullable_to_non_nullable
as int,absoluteChange: null == absoluteChange ? _self.absoluteChange : absoluteChange // ignore: cast_nullable_to_non_nullable
as int,percentageChange: null == percentageChange ? _self.percentageChange : percentageChange // ignore: cast_nullable_to_non_nullable
as double,previousValue: null == previousValue ? _self.previousValue : previousValue // ignore: cast_nullable_to_non_nullable
as int,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,dailyChanges: null == dailyChanges ? _self.dailyChanges : dailyChanges // ignore: cast_nullable_to_non_nullable
as List<DailyMarketValueChange>,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketValueChange].
extension MarketValueChangePatterns on MarketValueChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketValueChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketValueChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketValueChange value)  $default,){
final _that = this;
switch (_that) {
case _MarketValueChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketValueChange value)?  $default,){
final _that = this;
switch (_that) {
case _MarketValueChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int daysSinceLastUpdate,  int absoluteChange,  double percentageChange,  int previousValue,  int currentValue,  List<DailyMarketValueChange> dailyChanges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketValueChange() when $default != null:
return $default(_that.daysSinceLastUpdate,_that.absoluteChange,_that.percentageChange,_that.previousValue,_that.currentValue,_that.dailyChanges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int daysSinceLastUpdate,  int absoluteChange,  double percentageChange,  int previousValue,  int currentValue,  List<DailyMarketValueChange> dailyChanges)  $default,) {final _that = this;
switch (_that) {
case _MarketValueChange():
return $default(_that.daysSinceLastUpdate,_that.absoluteChange,_that.percentageChange,_that.previousValue,_that.currentValue,_that.dailyChanges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int daysSinceLastUpdate,  int absoluteChange,  double percentageChange,  int previousValue,  int currentValue,  List<DailyMarketValueChange> dailyChanges)?  $default,) {final _that = this;
switch (_that) {
case _MarketValueChange() when $default != null:
return $default(_that.daysSinceLastUpdate,_that.absoluteChange,_that.percentageChange,_that.previousValue,_that.currentValue,_that.dailyChanges);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketValueChange implements MarketValueChange {
  const _MarketValueChange({required this.daysSinceLastUpdate, required this.absoluteChange, required this.percentageChange, required this.previousValue, required this.currentValue, required  List<DailyMarketValueChange> dailyChanges}): _dailyChanges = dailyChanges;
  factory _MarketValueChange.fromJson(Map<String, dynamic> json) => _$MarketValueChangeFromJson(json);

@override final  int daysSinceLastUpdate;
@override final  int absoluteChange;
@override final  double percentageChange;
@override final  int previousValue;
@override final  int currentValue;
 final  List<DailyMarketValueChange> _dailyChanges;
@override List<DailyMarketValueChange> get dailyChanges {
  if (_dailyChanges is EqualUnmodifiableListView) return _dailyChanges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyChanges);
}


/// Create a copy of MarketValueChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketValueChangeCopyWith<_MarketValueChange> get copyWith => __$MarketValueChangeCopyWithImpl<_MarketValueChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketValueChangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketValueChange&&(identical(other.daysSinceLastUpdate, daysSinceLastUpdate) || other.daysSinceLastUpdate == daysSinceLastUpdate)&&(identical(other.absoluteChange, absoluteChange) || other.absoluteChange == absoluteChange)&&(identical(other.percentageChange, percentageChange) || other.percentageChange == percentageChange)&&(identical(other.previousValue, previousValue) || other.previousValue == previousValue)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&const DeepCollectionEquality().equals(other.dailyChanges, _dailyChanges));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,daysSinceLastUpdate,absoluteChange,percentageChange,previousValue,currentValue,const DeepCollectionEquality().hash(_dailyChanges));
}

@override
String toString() {
    return 'MarketValueChange(daysSinceLastUpdate: $daysSinceLastUpdate, absoluteChange: $absoluteChange, percentageChange: $percentageChange, previousValue: $previousValue, currentValue: $currentValue, dailyChanges: $dailyChanges)';
}


}

/// @nodoc
abstract mixin class _$MarketValueChangeCopyWith<$Res> implements $MarketValueChangeCopyWith<$Res> {
  factory _$MarketValueChangeCopyWith(_MarketValueChange value, $Res Function(_MarketValueChange) _then) = __$MarketValueChangeCopyWithImpl;
@override @useResult
$Res call({
 int daysSinceLastUpdate, int absoluteChange, double percentageChange, int previousValue, int currentValue, List<DailyMarketValueChange> dailyChanges
});




}
/// @nodoc
class __$MarketValueChangeCopyWithImpl<$Res>
    implements _$MarketValueChangeCopyWith<$Res> {
  __$MarketValueChangeCopyWithImpl(this._self, this._then);

  final _MarketValueChange _self;
  final $Res Function(_MarketValueChange) _then;

/// Create a copy of MarketValueChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? daysSinceLastUpdate = null,Object? absoluteChange = null,Object? percentageChange = null,Object? previousValue = null,Object? currentValue = null,Object? dailyChanges = null,}) {
  return _then(_MarketValueChange(
daysSinceLastUpdate: null == daysSinceLastUpdate ? _self.daysSinceLastUpdate : daysSinceLastUpdate // ignore: cast_nullable_to_non_nullable
as int,absoluteChange: null == absoluteChange ? _self.absoluteChange : absoluteChange // ignore: cast_nullable_to_non_nullable
as int,percentageChange: null == percentageChange ? _self.percentageChange : percentageChange // ignore: cast_nullable_to_non_nullable
as double,previousValue: null == previousValue ? _self.previousValue : previousValue // ignore: cast_nullable_to_non_nullable
as int,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as int,dailyChanges: null == dailyChanges ? _self._dailyChanges : dailyChanges // ignore: cast_nullable_to_non_nullable
as List<DailyMarketValueChange>,
  ));
}


}

// dart format on
