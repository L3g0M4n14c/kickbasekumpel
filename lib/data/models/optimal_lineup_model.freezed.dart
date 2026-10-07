// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimal_lineup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OptimalLineup {

 Player? get goalkeeper; List<Player> get defenders; List<Player> get midfielders; List<Player> get forwards;
/// Create a copy of OptimalLineup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptimalLineupCopyWith<OptimalLineup> get copyWith => _$OptimalLineupCopyWithImpl<OptimalLineup>(this as OptimalLineup, _$identity);

  /// Serializes this OptimalLineup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OptimalLineup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptimalLineup&&(identical(other.goalkeeper, _this.goalkeeper) || other.goalkeeper == _this.goalkeeper)&&const DeepCollectionEquality().equals(other.defenders, _this.defenders)&&const DeepCollectionEquality().equals(other.midfielders, _this.midfielders)&&const DeepCollectionEquality().equals(other.forwards, _this.forwards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OptimalLineup;
  return Object.hash(runtimeType,_this.goalkeeper,const DeepCollectionEquality().hash(_this.defenders),const DeepCollectionEquality().hash(_this.midfielders),const DeepCollectionEquality().hash(_this.forwards));
}

@override
String toString() {
  final _this = this as OptimalLineup;
  return 'OptimalLineup(goalkeeper: ${_this.goalkeeper}, defenders: ${_this.defenders}, midfielders: ${_this.midfielders}, forwards: ${_this.forwards})';
}


}

/// @nodoc
abstract mixin class $OptimalLineupCopyWith<$Res>  {
  factory $OptimalLineupCopyWith(OptimalLineup value, $Res Function(OptimalLineup) _then) = _$OptimalLineupCopyWithImpl;
@useResult
$Res call({
 Player? goalkeeper, List<Player> defenders, List<Player> midfielders, List<Player> forwards
});


$PlayerCopyWith<$Res>? get goalkeeper;

}
/// @nodoc
class _$OptimalLineupCopyWithImpl<$Res>
    implements $OptimalLineupCopyWith<$Res> {
  _$OptimalLineupCopyWithImpl(this._self, this._then);

  final OptimalLineup _self;
  final $Res Function(OptimalLineup) _then;

/// Create a copy of OptimalLineup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? goalkeeper = freezed,Object? defenders = null,Object? midfielders = null,Object? forwards = null,}) {
  return _then(OptimalLineup(
goalkeeper: freezed == goalkeeper ? _self.goalkeeper : goalkeeper // ignore: cast_nullable_to_non_nullable
as Player?,defenders: null == defenders ? _self.defenders : defenders // ignore: cast_nullable_to_non_nullable
as List<Player>,midfielders: null == midfielders ? _self.midfielders : midfielders // ignore: cast_nullable_to_non_nullable
as List<Player>,forwards: null == forwards ? _self.forwards : forwards // ignore: cast_nullable_to_non_nullable
as List<Player>,
  ));
}
/// Create a copy of OptimalLineup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res>? get goalkeeper {
    if (_self.goalkeeper == null) {
    return null;
  }

  return $PlayerCopyWith<$Res>(_self.goalkeeper!, (value) {
    return _then(_self.copyWith(goalkeeper: value));
  });
}
}


/// Adds pattern-matching-related methods to [OptimalLineup].
extension OptimalLineupPatterns on OptimalLineup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptimalLineup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptimalLineup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptimalLineup value)  $default,){
final _that = this;
switch (_that) {
case _OptimalLineup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptimalLineup value)?  $default,){
final _that = this;
switch (_that) {
case _OptimalLineup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Player? goalkeeper,  List<Player> defenders,  List<Player> midfielders,  List<Player> forwards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptimalLineup() when $default != null:
return $default(_that.goalkeeper,_that.defenders,_that.midfielders,_that.forwards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Player? goalkeeper,  List<Player> defenders,  List<Player> midfielders,  List<Player> forwards)  $default,) {final _that = this;
switch (_that) {
case _OptimalLineup():
return $default(_that.goalkeeper,_that.defenders,_that.midfielders,_that.forwards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Player? goalkeeper,  List<Player> defenders,  List<Player> midfielders,  List<Player> forwards)?  $default,) {final _that = this;
switch (_that) {
case _OptimalLineup() when $default != null:
return $default(_that.goalkeeper,_that.defenders,_that.midfielders,_that.forwards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OptimalLineup implements OptimalLineup {
  const _OptimalLineup({required this.goalkeeper, required  List<Player> defenders, required  List<Player> midfielders, required  List<Player> forwards}): _defenders = defenders,_midfielders = midfielders,_forwards = forwards;
  factory _OptimalLineup.fromJson(Map<String, dynamic> json) => _$OptimalLineupFromJson(json);

@override final  Player? goalkeeper;
 final  List<Player> _defenders;
@override List<Player> get defenders {
  if (_defenders is EqualUnmodifiableListView) return _defenders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defenders);
}

 final  List<Player> _midfielders;
@override List<Player> get midfielders {
  if (_midfielders is EqualUnmodifiableListView) return _midfielders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_midfielders);
}

 final  List<Player> _forwards;
@override List<Player> get forwards {
  if (_forwards is EqualUnmodifiableListView) return _forwards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_forwards);
}


/// Create a copy of OptimalLineup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptimalLineupCopyWith<_OptimalLineup> get copyWith => __$OptimalLineupCopyWithImpl<_OptimalLineup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OptimalLineupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptimalLineup&&(identical(other.goalkeeper, goalkeeper) || other.goalkeeper == goalkeeper)&&const DeepCollectionEquality().equals(other.defenders, _defenders)&&const DeepCollectionEquality().equals(other.midfielders, _midfielders)&&const DeepCollectionEquality().equals(other.forwards, _forwards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,goalkeeper,const DeepCollectionEquality().hash(_defenders),const DeepCollectionEquality().hash(_midfielders),const DeepCollectionEquality().hash(_forwards));
}

@override
String toString() {
    return 'OptimalLineup(goalkeeper: $goalkeeper, defenders: $defenders, midfielders: $midfielders, forwards: $forwards)';
}


}

/// @nodoc
abstract mixin class _$OptimalLineupCopyWith<$Res> implements $OptimalLineupCopyWith<$Res> {
  factory _$OptimalLineupCopyWith(_OptimalLineup value, $Res Function(_OptimalLineup) _then) = __$OptimalLineupCopyWithImpl;
@override @useResult
$Res call({
 Player? goalkeeper, List<Player> defenders, List<Player> midfielders, List<Player> forwards
});


@override $PlayerCopyWith<$Res>? get goalkeeper;

}
/// @nodoc
class __$OptimalLineupCopyWithImpl<$Res>
    implements _$OptimalLineupCopyWith<$Res> {
  __$OptimalLineupCopyWithImpl(this._self, this._then);

  final _OptimalLineup _self;
  final $Res Function(_OptimalLineup) _then;

/// Create a copy of OptimalLineup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? goalkeeper = freezed,Object? defenders = null,Object? midfielders = null,Object? forwards = null,}) {
  return _then(_OptimalLineup(
goalkeeper: freezed == goalkeeper ? _self.goalkeeper : goalkeeper // ignore: cast_nullable_to_non_nullable
as Player?,defenders: null == defenders ? _self._defenders : defenders // ignore: cast_nullable_to_non_nullable
as List<Player>,midfielders: null == midfielders ? _self._midfielders : midfielders // ignore: cast_nullable_to_non_nullable
as List<Player>,forwards: null == forwards ? _self._forwards : forwards // ignore: cast_nullable_to_non_nullable
as List<Player>,
  ));
}

/// Create a copy of OptimalLineup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res>? get goalkeeper {
    if (_self.goalkeeper == null) {
    return null;
  }

  return $PlayerCopyWith<$Res>(_self.goalkeeper!, (value) {
    return _then(_self.copyWith(goalkeeper: value));
  });
}
}


/// @nodoc
mixin _$LineupComparison {

 OptimalLineup get currentLineup; OptimalLineup get optimalLineup; double get currentScore; double get optimalScore; List<Player> get suggestedAdditions; List<Player> get suggestedRemovals;
/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineupComparisonCopyWith<LineupComparison> get copyWith => _$LineupComparisonCopyWithImpl<LineupComparison>(this as LineupComparison, _$identity);

  /// Serializes this LineupComparison to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LineupComparison;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineupComparison&&(identical(other.currentLineup, _this.currentLineup) || other.currentLineup == _this.currentLineup)&&(identical(other.optimalLineup, _this.optimalLineup) || other.optimalLineup == _this.optimalLineup)&&(identical(other.currentScore, _this.currentScore) || other.currentScore == _this.currentScore)&&(identical(other.optimalScore, _this.optimalScore) || other.optimalScore == _this.optimalScore)&&const DeepCollectionEquality().equals(other.suggestedAdditions, _this.suggestedAdditions)&&const DeepCollectionEquality().equals(other.suggestedRemovals, _this.suggestedRemovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LineupComparison;
  return Object.hash(runtimeType,_this.currentLineup,_this.optimalLineup,_this.currentScore,_this.optimalScore,const DeepCollectionEquality().hash(_this.suggestedAdditions),const DeepCollectionEquality().hash(_this.suggestedRemovals));
}

@override
String toString() {
  final _this = this as LineupComparison;
  return 'LineupComparison(currentLineup: ${_this.currentLineup}, optimalLineup: ${_this.optimalLineup}, currentScore: ${_this.currentScore}, optimalScore: ${_this.optimalScore}, suggestedAdditions: ${_this.suggestedAdditions}, suggestedRemovals: ${_this.suggestedRemovals})';
}


}

/// @nodoc
abstract mixin class $LineupComparisonCopyWith<$Res>  {
  factory $LineupComparisonCopyWith(LineupComparison value, $Res Function(LineupComparison) _then) = _$LineupComparisonCopyWithImpl;
@useResult
$Res call({
 OptimalLineup currentLineup, OptimalLineup optimalLineup, double currentScore, double optimalScore, List<Player> suggestedAdditions, List<Player> suggestedRemovals
});


$OptimalLineupCopyWith<$Res> get currentLineup;$OptimalLineupCopyWith<$Res> get optimalLineup;

}
/// @nodoc
class _$LineupComparisonCopyWithImpl<$Res>
    implements $LineupComparisonCopyWith<$Res> {
  _$LineupComparisonCopyWithImpl(this._self, this._then);

  final LineupComparison _self;
  final $Res Function(LineupComparison) _then;

/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentLineup = null,Object? optimalLineup = null,Object? currentScore = null,Object? optimalScore = null,Object? suggestedAdditions = null,Object? suggestedRemovals = null,}) {
  return _then(LineupComparison(
currentLineup: null == currentLineup ? _self.currentLineup : currentLineup // ignore: cast_nullable_to_non_nullable
as OptimalLineup,optimalLineup: null == optimalLineup ? _self.optimalLineup : optimalLineup // ignore: cast_nullable_to_non_nullable
as OptimalLineup,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as double,optimalScore: null == optimalScore ? _self.optimalScore : optimalScore // ignore: cast_nullable_to_non_nullable
as double,suggestedAdditions: null == suggestedAdditions ? _self.suggestedAdditions : suggestedAdditions // ignore: cast_nullable_to_non_nullable
as List<Player>,suggestedRemovals: null == suggestedRemovals ? _self.suggestedRemovals : suggestedRemovals // ignore: cast_nullable_to_non_nullable
as List<Player>,
  ));
}
/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptimalLineupCopyWith<$Res> get currentLineup {
  
  return $OptimalLineupCopyWith<$Res>(_self.currentLineup, (value) {
    return _then(_self.copyWith(currentLineup: value));
  });
}/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptimalLineupCopyWith<$Res> get optimalLineup {
  
  return $OptimalLineupCopyWith<$Res>(_self.optimalLineup, (value) {
    return _then(_self.copyWith(optimalLineup: value));
  });
}
}


/// Adds pattern-matching-related methods to [LineupComparison].
extension LineupComparisonPatterns on LineupComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineupComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineupComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineupComparison value)  $default,){
final _that = this;
switch (_that) {
case _LineupComparison():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineupComparison value)?  $default,){
final _that = this;
switch (_that) {
case _LineupComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OptimalLineup currentLineup,  OptimalLineup optimalLineup,  double currentScore,  double optimalScore,  List<Player> suggestedAdditions,  List<Player> suggestedRemovals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineupComparison() when $default != null:
return $default(_that.currentLineup,_that.optimalLineup,_that.currentScore,_that.optimalScore,_that.suggestedAdditions,_that.suggestedRemovals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OptimalLineup currentLineup,  OptimalLineup optimalLineup,  double currentScore,  double optimalScore,  List<Player> suggestedAdditions,  List<Player> suggestedRemovals)  $default,) {final _that = this;
switch (_that) {
case _LineupComparison():
return $default(_that.currentLineup,_that.optimalLineup,_that.currentScore,_that.optimalScore,_that.suggestedAdditions,_that.suggestedRemovals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OptimalLineup currentLineup,  OptimalLineup optimalLineup,  double currentScore,  double optimalScore,  List<Player> suggestedAdditions,  List<Player> suggestedRemovals)?  $default,) {final _that = this;
switch (_that) {
case _LineupComparison() when $default != null:
return $default(_that.currentLineup,_that.optimalLineup,_that.currentScore,_that.optimalScore,_that.suggestedAdditions,_that.suggestedRemovals);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LineupComparison implements LineupComparison {
  const _LineupComparison({required this.currentLineup, required this.optimalLineup, required this.currentScore, required this.optimalScore, required  List<Player> suggestedAdditions, required  List<Player> suggestedRemovals}): _suggestedAdditions = suggestedAdditions,_suggestedRemovals = suggestedRemovals;
  factory _LineupComparison.fromJson(Map<String, dynamic> json) => _$LineupComparisonFromJson(json);

@override final  OptimalLineup currentLineup;
@override final  OptimalLineup optimalLineup;
@override final  double currentScore;
@override final  double optimalScore;
 final  List<Player> _suggestedAdditions;
@override List<Player> get suggestedAdditions {
  if (_suggestedAdditions is EqualUnmodifiableListView) return _suggestedAdditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedAdditions);
}

 final  List<Player> _suggestedRemovals;
@override List<Player> get suggestedRemovals {
  if (_suggestedRemovals is EqualUnmodifiableListView) return _suggestedRemovals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedRemovals);
}


/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineupComparisonCopyWith<_LineupComparison> get copyWith => __$LineupComparisonCopyWithImpl<_LineupComparison>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineupComparisonToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineupComparison&&(identical(other.currentLineup, currentLineup) || other.currentLineup == currentLineup)&&(identical(other.optimalLineup, optimalLineup) || other.optimalLineup == optimalLineup)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.optimalScore, optimalScore) || other.optimalScore == optimalScore)&&const DeepCollectionEquality().equals(other.suggestedAdditions, _suggestedAdditions)&&const DeepCollectionEquality().equals(other.suggestedRemovals, _suggestedRemovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currentLineup,optimalLineup,currentScore,optimalScore,const DeepCollectionEquality().hash(_suggestedAdditions),const DeepCollectionEquality().hash(_suggestedRemovals));
}

@override
String toString() {
    return 'LineupComparison(currentLineup: $currentLineup, optimalLineup: $optimalLineup, currentScore: $currentScore, optimalScore: $optimalScore, suggestedAdditions: $suggestedAdditions, suggestedRemovals: $suggestedRemovals)';
}


}

/// @nodoc
abstract mixin class _$LineupComparisonCopyWith<$Res> implements $LineupComparisonCopyWith<$Res> {
  factory _$LineupComparisonCopyWith(_LineupComparison value, $Res Function(_LineupComparison) _then) = __$LineupComparisonCopyWithImpl;
@override @useResult
$Res call({
 OptimalLineup currentLineup, OptimalLineup optimalLineup, double currentScore, double optimalScore, List<Player> suggestedAdditions, List<Player> suggestedRemovals
});


@override $OptimalLineupCopyWith<$Res> get currentLineup;@override $OptimalLineupCopyWith<$Res> get optimalLineup;

}
/// @nodoc
class __$LineupComparisonCopyWithImpl<$Res>
    implements _$LineupComparisonCopyWith<$Res> {
  __$LineupComparisonCopyWithImpl(this._self, this._then);

  final _LineupComparison _self;
  final $Res Function(_LineupComparison) _then;

/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentLineup = null,Object? optimalLineup = null,Object? currentScore = null,Object? optimalScore = null,Object? suggestedAdditions = null,Object? suggestedRemovals = null,}) {
  return _then(_LineupComparison(
currentLineup: null == currentLineup ? _self.currentLineup : currentLineup // ignore: cast_nullable_to_non_nullable
as OptimalLineup,optimalLineup: null == optimalLineup ? _self.optimalLineup : optimalLineup // ignore: cast_nullable_to_non_nullable
as OptimalLineup,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as double,optimalScore: null == optimalScore ? _self.optimalScore : optimalScore // ignore: cast_nullable_to_non_nullable
as double,suggestedAdditions: null == suggestedAdditions ? _self._suggestedAdditions : suggestedAdditions // ignore: cast_nullable_to_non_nullable
as List<Player>,suggestedRemovals: null == suggestedRemovals ? _self._suggestedRemovals : suggestedRemovals // ignore: cast_nullable_to_non_nullable
as List<Player>,
  ));
}

/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptimalLineupCopyWith<$Res> get currentLineup {
  
  return $OptimalLineupCopyWith<$Res>(_self.currentLineup, (value) {
    return _then(_self.copyWith(currentLineup: value));
  });
}/// Create a copy of LineupComparison
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptimalLineupCopyWith<$Res> get optimalLineup {
  
  return $OptimalLineupCopyWith<$Res>(_self.optimalLineup, (value) {
    return _then(_self.copyWith(optimalLineup: value));
  });
}
}

// dart format on
