// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_bonus_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BonusCollection {

/// Liga-ID (`li`)
@JsonKey(name: 'li') String get leagueId;/// Liga-Name (`lnm`)
@JsonKey(name: 'lnm') String get leagueName;/// Bonus-Betrag in € (`v`)
@JsonKey(name: 'v') int get value;/// Tag der Bonus-Serie (`day`)
@JsonKey(name: 'day') int get day;/// Budget nach dem Einsammeln in € (`b`)
@JsonKey(name: 'b') int get budget;/// Pfad zum Liga-Bild (`lim`)
@JsonKey(name: 'lim') String get leagueImage;
/// Create a copy of BonusCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BonusCollectionCopyWith<BonusCollection> get copyWith => _$BonusCollectionCopyWithImpl<BonusCollection>(this as BonusCollection, _$identity);

  /// Serializes this BonusCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BonusCollection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BonusCollection&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.leagueName, _this.leagueName) || other.leagueName == _this.leagueName)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.leagueImage, _this.leagueImage) || other.leagueImage == _this.leagueImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BonusCollection;
  return Object.hash(runtimeType,_this.leagueId,_this.leagueName,_this.value,_this.day,_this.budget,_this.leagueImage);
}

@override
String toString() {
  final _this = this as BonusCollection;
  return 'BonusCollection(leagueId: ${_this.leagueId}, leagueName: ${_this.leagueName}, value: ${_this.value}, day: ${_this.day}, budget: ${_this.budget}, leagueImage: ${_this.leagueImage})';
}


}

/// @nodoc
abstract mixin class $BonusCollectionCopyWith<$Res>  {
  factory $BonusCollectionCopyWith(BonusCollection value, $Res Function(BonusCollection) _then) = _$BonusCollectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'li') String leagueId,@JsonKey(name: 'lnm') String leagueName,@JsonKey(name: 'v') int value,@JsonKey(name: 'day') int day,@JsonKey(name: 'b') int budget,@JsonKey(name: 'lim') String leagueImage
});




}
/// @nodoc
class _$BonusCollectionCopyWithImpl<$Res>
    implements $BonusCollectionCopyWith<$Res> {
  _$BonusCollectionCopyWithImpl(this._self, this._then);

  final BonusCollection _self;
  final $Res Function(BonusCollection) _then;

/// Create a copy of BonusCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueId = null,Object? leagueName = null,Object? value = null,Object? day = null,Object? budget = null,Object? leagueImage = null,}) {
  return _then(BonusCollection(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,leagueImage: null == leagueImage ? _self.leagueImage : leagueImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BonusCollection].
extension BonusCollectionPatterns on BonusCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BonusCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BonusCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BonusCollection value)  $default,){
final _that = this;
switch (_that) {
case _BonusCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BonusCollection value)?  $default,){
final _that = this;
switch (_that) {
case _BonusCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'li')  String leagueId, @JsonKey(name: 'lnm')  String leagueName, @JsonKey(name: 'v')  int value, @JsonKey(name: 'day')  int day, @JsonKey(name: 'b')  int budget, @JsonKey(name: 'lim')  String leagueImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BonusCollection() when $default != null:
return $default(_that.leagueId,_that.leagueName,_that.value,_that.day,_that.budget,_that.leagueImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'li')  String leagueId, @JsonKey(name: 'lnm')  String leagueName, @JsonKey(name: 'v')  int value, @JsonKey(name: 'day')  int day, @JsonKey(name: 'b')  int budget, @JsonKey(name: 'lim')  String leagueImage)  $default,) {final _that = this;
switch (_that) {
case _BonusCollection():
return $default(_that.leagueId,_that.leagueName,_that.value,_that.day,_that.budget,_that.leagueImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'li')  String leagueId, @JsonKey(name: 'lnm')  String leagueName, @JsonKey(name: 'v')  int value, @JsonKey(name: 'day')  int day, @JsonKey(name: 'b')  int budget, @JsonKey(name: 'lim')  String leagueImage)?  $default,) {final _that = this;
switch (_that) {
case _BonusCollection() when $default != null:
return $default(_that.leagueId,_that.leagueName,_that.value,_that.day,_that.budget,_that.leagueImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BonusCollection implements BonusCollection {
  const _BonusCollection({@JsonKey(name: 'li') this.leagueId = '', @JsonKey(name: 'lnm') this.leagueName = '', @JsonKey(name: 'v') this.value = 0, @JsonKey(name: 'day') this.day = 1, @JsonKey(name: 'b') this.budget = 0, @JsonKey(name: 'lim') this.leagueImage = ''});
  factory _BonusCollection.fromJson(Map<String, dynamic> json) => _$BonusCollectionFromJson(json);

/// Liga-ID (`li`)
@override@JsonKey(name: 'li') final  String leagueId;
/// Liga-Name (`lnm`)
@override@JsonKey(name: 'lnm') final  String leagueName;
/// Bonus-Betrag in € (`v`)
@override@JsonKey(name: 'v') final  int value;
/// Tag der Bonus-Serie (`day`)
@override@JsonKey(name: 'day') final  int day;
/// Budget nach dem Einsammeln in € (`b`)
@override@JsonKey(name: 'b') final  int budget;
/// Pfad zum Liga-Bild (`lim`)
@override@JsonKey(name: 'lim') final  String leagueImage;

/// Create a copy of BonusCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BonusCollectionCopyWith<_BonusCollection> get copyWith => __$BonusCollectionCopyWithImpl<_BonusCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BonusCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BonusCollection&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.leagueName, leagueName) || other.leagueName == leagueName)&&(identical(other.value, value) || other.value == value)&&(identical(other.day, day) || other.day == day)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.leagueImage, leagueImage) || other.leagueImage == leagueImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leagueId,leagueName,value,day,budget,leagueImage);
}

@override
String toString() {
    return 'BonusCollection(leagueId: $leagueId, leagueName: $leagueName, value: $value, day: $day, budget: $budget, leagueImage: $leagueImage)';
}


}

/// @nodoc
abstract mixin class _$BonusCollectionCopyWith<$Res> implements $BonusCollectionCopyWith<$Res> {
  factory _$BonusCollectionCopyWith(_BonusCollection value, $Res Function(_BonusCollection) _then) = __$BonusCollectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'li') String leagueId,@JsonKey(name: 'lnm') String leagueName,@JsonKey(name: 'v') int value,@JsonKey(name: 'day') int day,@JsonKey(name: 'b') int budget,@JsonKey(name: 'lim') String leagueImage
});




}
/// @nodoc
class __$BonusCollectionCopyWithImpl<$Res>
    implements _$BonusCollectionCopyWith<$Res> {
  __$BonusCollectionCopyWithImpl(this._self, this._then);

  final _BonusCollection _self;
  final $Res Function(_BonusCollection) _then;

/// Create a copy of BonusCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueId = null,Object? leagueName = null,Object? value = null,Object? day = null,Object? budget = null,Object? leagueImage = null,}) {
  return _then(_BonusCollection(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as int,leagueImage: null == leagueImage ? _self.leagueImage : leagueImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BonusCollectResult {

/// Pro Liga eingesammelte Boni (`it`)
@JsonKey(name: 'it') List<BonusCollection> get collections;
/// Create a copy of BonusCollectResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BonusCollectResultCopyWith<BonusCollectResult> get copyWith => _$BonusCollectResultCopyWithImpl<BonusCollectResult>(this as BonusCollectResult, _$identity);

  /// Serializes this BonusCollectResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BonusCollectResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BonusCollectResult&&const DeepCollectionEquality().equals(other.collections, _this.collections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BonusCollectResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.collections));
}

@override
String toString() {
  final _this = this as BonusCollectResult;
  return 'BonusCollectResult(collections: ${_this.collections})';
}


}

/// @nodoc
abstract mixin class $BonusCollectResultCopyWith<$Res>  {
  factory $BonusCollectResultCopyWith(BonusCollectResult value, $Res Function(BonusCollectResult) _then) = _$BonusCollectResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'it') List<BonusCollection> collections
});




}
/// @nodoc
class _$BonusCollectResultCopyWithImpl<$Res>
    implements $BonusCollectResultCopyWith<$Res> {
  _$BonusCollectResultCopyWithImpl(this._self, this._then);

  final BonusCollectResult _self;
  final $Res Function(BonusCollectResult) _then;

/// Create a copy of BonusCollectResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collections = null,}) {
  return _then(BonusCollectResult(
collections: null == collections ? _self.collections : collections // ignore: cast_nullable_to_non_nullable
as List<BonusCollection>,
  ));
}

}


/// Adds pattern-matching-related methods to [BonusCollectResult].
extension BonusCollectResultPatterns on BonusCollectResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BonusCollectResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BonusCollectResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BonusCollectResult value)  $default,){
final _that = this;
switch (_that) {
case _BonusCollectResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BonusCollectResult value)?  $default,){
final _that = this;
switch (_that) {
case _BonusCollectResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'it')  List<BonusCollection> collections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BonusCollectResult() when $default != null:
return $default(_that.collections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'it')  List<BonusCollection> collections)  $default,) {final _that = this;
switch (_that) {
case _BonusCollectResult():
return $default(_that.collections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'it')  List<BonusCollection> collections)?  $default,) {final _that = this;
switch (_that) {
case _BonusCollectResult() when $default != null:
return $default(_that.collections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BonusCollectResult extends BonusCollectResult {
  const _BonusCollectResult({@JsonKey(name: 'it')  List<BonusCollection> collections = const []}): _collections = collections,super._();
  factory _BonusCollectResult.fromJson(Map<String, dynamic> json) => _$BonusCollectResultFromJson(json);

/// Pro Liga eingesammelte Boni (`it`)
 final  List<BonusCollection> _collections;
/// Pro Liga eingesammelte Boni (`it`)
@override@JsonKey(name: 'it') List<BonusCollection> get collections {
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_collections);
}


/// Create a copy of BonusCollectResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BonusCollectResultCopyWith<_BonusCollectResult> get copyWith => __$BonusCollectResultCopyWithImpl<_BonusCollectResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BonusCollectResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BonusCollectResult&&const DeepCollectionEquality().equals(other.collections, _collections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_collections));
}

@override
String toString() {
    return 'BonusCollectResult(collections: $collections)';
}


}

/// @nodoc
abstract mixin class _$BonusCollectResultCopyWith<$Res> implements $BonusCollectResultCopyWith<$Res> {
  factory _$BonusCollectResultCopyWith(_BonusCollectResult value, $Res Function(_BonusCollectResult) _then) = __$BonusCollectResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'it') List<BonusCollection> collections
});




}
/// @nodoc
class __$BonusCollectResultCopyWithImpl<$Res>
    implements _$BonusCollectResultCopyWith<$Res> {
  __$BonusCollectResultCopyWithImpl(this._self, this._then);

  final _BonusCollectResult _self;
  final $Res Function(_BonusCollectResult) _then;

/// Create a copy of BonusCollectResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collections = null,}) {
  return _then(_BonusCollectResult(
collections: null == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<BonusCollection>,
  ));
}


}

/// @nodoc
mixin _$DailyBonusStatus {

/// true = Bonus ausstehend (Overview meldet Bonus-Einträge),
/// null = Overview liefert keinen Bonus-Hinweis – dann entscheidet der
/// lokale Einsammel-Stand (siehe `DailyBonusService`).
/// false = Bonus ausdrücklich nicht ausstehend (derzeit nicht erkennbar,
/// für künftige API-Hinweise reserviert).
 bool? get isAvailable;
/// Create a copy of DailyBonusStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyBonusStatusCopyWith<DailyBonusStatus> get copyWith => _$DailyBonusStatusCopyWithImpl<DailyBonusStatus>(this as DailyBonusStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DailyBonusStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyBonusStatus&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable));
}


@override
int get hashCode {
  final _this = this as DailyBonusStatus;
  return Object.hash(runtimeType,_this.isAvailable);
}

@override
String toString() {
  final _this = this as DailyBonusStatus;
  return 'DailyBonusStatus(isAvailable: ${_this.isAvailable})';
}


}

/// @nodoc
abstract mixin class $DailyBonusStatusCopyWith<$Res>  {
  factory $DailyBonusStatusCopyWith(DailyBonusStatus value, $Res Function(DailyBonusStatus) _then) = _$DailyBonusStatusCopyWithImpl;
@useResult
$Res call({
 bool? isAvailable
});




}
/// @nodoc
class _$DailyBonusStatusCopyWithImpl<$Res>
    implements $DailyBonusStatusCopyWith<$Res> {
  _$DailyBonusStatusCopyWithImpl(this._self, this._then);

  final DailyBonusStatus _self;
  final $Res Function(DailyBonusStatus) _then;

/// Create a copy of DailyBonusStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAvailable = freezed,}) {
  return _then(DailyBonusStatus(
isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyBonusStatus].
extension DailyBonusStatusPatterns on DailyBonusStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyBonusStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyBonusStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyBonusStatus value)  $default,){
final _that = this;
switch (_that) {
case _DailyBonusStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyBonusStatus value)?  $default,){
final _that = this;
switch (_that) {
case _DailyBonusStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? isAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyBonusStatus() when $default != null:
return $default(_that.isAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? isAvailable)  $default,) {final _that = this;
switch (_that) {
case _DailyBonusStatus():
return $default(_that.isAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? isAvailable)?  $default,) {final _that = this;
switch (_that) {
case _DailyBonusStatus() when $default != null:
return $default(_that.isAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _DailyBonusStatus implements DailyBonusStatus {
  const _DailyBonusStatus({required this.isAvailable});
  

/// true = Bonus ausstehend (Overview meldet Bonus-Einträge),
/// null = Overview liefert keinen Bonus-Hinweis – dann entscheidet der
/// lokale Einsammel-Stand (siehe `DailyBonusService`).
/// false = Bonus ausdrücklich nicht ausstehend (derzeit nicht erkennbar,
/// für künftige API-Hinweise reserviert).
@override final  bool? isAvailable;

/// Create a copy of DailyBonusStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyBonusStatusCopyWith<_DailyBonusStatus> get copyWith => __$DailyBonusStatusCopyWithImpl<_DailyBonusStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyBonusStatus&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isAvailable);
}

@override
String toString() {
    return 'DailyBonusStatus(isAvailable: $isAvailable)';
}


}

/// @nodoc
abstract mixin class _$DailyBonusStatusCopyWith<$Res> implements $DailyBonusStatusCopyWith<$Res> {
  factory _$DailyBonusStatusCopyWith(_DailyBonusStatus value, $Res Function(_DailyBonusStatus) _then) = __$DailyBonusStatusCopyWithImpl;
@override @useResult
$Res call({
 bool? isAvailable
});




}
/// @nodoc
class __$DailyBonusStatusCopyWithImpl<$Res>
    implements _$DailyBonusStatusCopyWith<$Res> {
  __$DailyBonusStatusCopyWithImpl(this._self, this._then);

  final _DailyBonusStatus _self;
  final $Res Function(_DailyBonusStatus) _then;

/// Create a copy of DailyBonusStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAvailable = freezed,}) {
  return _then(_DailyBonusStatus(
isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
