// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_planner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransferPlannerInput {

 List<Player> get squadPlayers; List<Player> get marketPlayers; int get currentBudget;
/// Create a copy of TransferPlannerInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlannerInputCopyWith<TransferPlannerInput> get copyWith => _$TransferPlannerInputCopyWithImpl<TransferPlannerInput>(this as TransferPlannerInput, _$identity);

  /// Serializes this TransferPlannerInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPlannerInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlannerInput&&const DeepCollectionEquality().equals(other.squadPlayers, _this.squadPlayers)&&const DeepCollectionEquality().equals(other.marketPlayers, _this.marketPlayers)&&(identical(other.currentBudget, _this.currentBudget) || other.currentBudget == _this.currentBudget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPlannerInput;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.squadPlayers),const DeepCollectionEquality().hash(_this.marketPlayers),_this.currentBudget);
}

@override
String toString() {
  final _this = this as TransferPlannerInput;
  return 'TransferPlannerInput(squadPlayers: ${_this.squadPlayers}, marketPlayers: ${_this.marketPlayers}, currentBudget: ${_this.currentBudget})';
}


}

/// @nodoc
abstract mixin class $TransferPlannerInputCopyWith<$Res>  {
  factory $TransferPlannerInputCopyWith(TransferPlannerInput value, $Res Function(TransferPlannerInput) _then) = _$TransferPlannerInputCopyWithImpl;
@useResult
$Res call({
 List<Player> squadPlayers, List<Player> marketPlayers, int currentBudget
});




}
/// @nodoc
class _$TransferPlannerInputCopyWithImpl<$Res>
    implements $TransferPlannerInputCopyWith<$Res> {
  _$TransferPlannerInputCopyWithImpl(this._self, this._then);

  final TransferPlannerInput _self;
  final $Res Function(TransferPlannerInput) _then;

/// Create a copy of TransferPlannerInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? squadPlayers = null,Object? marketPlayers = null,Object? currentBudget = null,}) {
  return _then(TransferPlannerInput(
squadPlayers: null == squadPlayers ? _self.squadPlayers : squadPlayers // ignore: cast_nullable_to_non_nullable
as List<Player>,marketPlayers: null == marketPlayers ? _self.marketPlayers : marketPlayers // ignore: cast_nullable_to_non_nullable
as List<Player>,currentBudget: null == currentBudget ? _self.currentBudget : currentBudget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferPlannerInput].
extension TransferPlannerInputPatterns on TransferPlannerInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPlannerInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPlannerInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPlannerInput value)  $default,){
final _that = this;
switch (_that) {
case _TransferPlannerInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPlannerInput value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPlannerInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Player> squadPlayers,  List<Player> marketPlayers,  int currentBudget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPlannerInput() when $default != null:
return $default(_that.squadPlayers,_that.marketPlayers,_that.currentBudget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Player> squadPlayers,  List<Player> marketPlayers,  int currentBudget)  $default,) {final _that = this;
switch (_that) {
case _TransferPlannerInput():
return $default(_that.squadPlayers,_that.marketPlayers,_that.currentBudget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Player> squadPlayers,  List<Player> marketPlayers,  int currentBudget)?  $default,) {final _that = this;
switch (_that) {
case _TransferPlannerInput() when $default != null:
return $default(_that.squadPlayers,_that.marketPlayers,_that.currentBudget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPlannerInput implements TransferPlannerInput {
  const _TransferPlannerInput({required  List<Player> squadPlayers, required  List<Player> marketPlayers, required this.currentBudget}): _squadPlayers = squadPlayers,_marketPlayers = marketPlayers;
  factory _TransferPlannerInput.fromJson(Map<String, dynamic> json) => _$TransferPlannerInputFromJson(json);

 final  List<Player> _squadPlayers;
@override List<Player> get squadPlayers {
  if (_squadPlayers is EqualUnmodifiableListView) return _squadPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_squadPlayers);
}

 final  List<Player> _marketPlayers;
@override List<Player> get marketPlayers {
  if (_marketPlayers is EqualUnmodifiableListView) return _marketPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_marketPlayers);
}

@override final  int currentBudget;

/// Create a copy of TransferPlannerInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPlannerInputCopyWith<_TransferPlannerInput> get copyWith => __$TransferPlannerInputCopyWithImpl<_TransferPlannerInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlannerInputToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPlannerInput&&const DeepCollectionEquality().equals(other.squadPlayers, _squadPlayers)&&const DeepCollectionEquality().equals(other.marketPlayers, _marketPlayers)&&(identical(other.currentBudget, currentBudget) || other.currentBudget == currentBudget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_squadPlayers),const DeepCollectionEquality().hash(_marketPlayers),currentBudget);
}

@override
String toString() {
    return 'TransferPlannerInput(squadPlayers: $squadPlayers, marketPlayers: $marketPlayers, currentBudget: $currentBudget)';
}


}

/// @nodoc
abstract mixin class _$TransferPlannerInputCopyWith<$Res> implements $TransferPlannerInputCopyWith<$Res> {
  factory _$TransferPlannerInputCopyWith(_TransferPlannerInput value, $Res Function(_TransferPlannerInput) _then) = __$TransferPlannerInputCopyWithImpl;
@override @useResult
$Res call({
 List<Player> squadPlayers, List<Player> marketPlayers, int currentBudget
});




}
/// @nodoc
class __$TransferPlannerInputCopyWithImpl<$Res>
    implements _$TransferPlannerInputCopyWith<$Res> {
  __$TransferPlannerInputCopyWithImpl(this._self, this._then);

  final _TransferPlannerInput _self;
  final $Res Function(_TransferPlannerInput) _then;

/// Create a copy of TransferPlannerInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? squadPlayers = null,Object? marketPlayers = null,Object? currentBudget = null,}) {
  return _then(_TransferPlannerInput(
squadPlayers: null == squadPlayers ? _self._squadPlayers : squadPlayers // ignore: cast_nullable_to_non_nullable
as List<Player>,marketPlayers: null == marketPlayers ? _self._marketPlayers : marketPlayers // ignore: cast_nullable_to_non_nullable
as List<Player>,currentBudget: null == currentBudget ? _self.currentBudget : currentBudget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TransferPlanScore {

 double get startingElevenGain; double get executionRisk; double get valueStability;
/// Create a copy of TransferPlanScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlanScoreCopyWith<TransferPlanScore> get copyWith => _$TransferPlanScoreCopyWithImpl<TransferPlanScore>(this as TransferPlanScore, _$identity);

  /// Serializes this TransferPlanScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPlanScore;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlanScore&&(identical(other.startingElevenGain, _this.startingElevenGain) || other.startingElevenGain == _this.startingElevenGain)&&(identical(other.executionRisk, _this.executionRisk) || other.executionRisk == _this.executionRisk)&&(identical(other.valueStability, _this.valueStability) || other.valueStability == _this.valueStability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPlanScore;
  return Object.hash(runtimeType,_this.startingElevenGain,_this.executionRisk,_this.valueStability);
}

@override
String toString() {
  final _this = this as TransferPlanScore;
  return 'TransferPlanScore(startingElevenGain: ${_this.startingElevenGain}, executionRisk: ${_this.executionRisk}, valueStability: ${_this.valueStability})';
}


}

/// @nodoc
abstract mixin class $TransferPlanScoreCopyWith<$Res>  {
  factory $TransferPlanScoreCopyWith(TransferPlanScore value, $Res Function(TransferPlanScore) _then) = _$TransferPlanScoreCopyWithImpl;
@useResult
$Res call({
 double startingElevenGain, double executionRisk, double valueStability
});




}
/// @nodoc
class _$TransferPlanScoreCopyWithImpl<$Res>
    implements $TransferPlanScoreCopyWith<$Res> {
  _$TransferPlanScoreCopyWithImpl(this._self, this._then);

  final TransferPlanScore _self;
  final $Res Function(TransferPlanScore) _then;

/// Create a copy of TransferPlanScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startingElevenGain = null,Object? executionRisk = null,Object? valueStability = null,}) {
  return _then(TransferPlanScore(
startingElevenGain: null == startingElevenGain ? _self.startingElevenGain : startingElevenGain // ignore: cast_nullable_to_non_nullable
as double,executionRisk: null == executionRisk ? _self.executionRisk : executionRisk // ignore: cast_nullable_to_non_nullable
as double,valueStability: null == valueStability ? _self.valueStability : valueStability // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferPlanScore].
extension TransferPlanScorePatterns on TransferPlanScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPlanScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPlanScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPlanScore value)  $default,){
final _that = this;
switch (_that) {
case _TransferPlanScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPlanScore value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPlanScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double startingElevenGain,  double executionRisk,  double valueStability)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPlanScore() when $default != null:
return $default(_that.startingElevenGain,_that.executionRisk,_that.valueStability);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double startingElevenGain,  double executionRisk,  double valueStability)  $default,) {final _that = this;
switch (_that) {
case _TransferPlanScore():
return $default(_that.startingElevenGain,_that.executionRisk,_that.valueStability);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double startingElevenGain,  double executionRisk,  double valueStability)?  $default,) {final _that = this;
switch (_that) {
case _TransferPlanScore() when $default != null:
return $default(_that.startingElevenGain,_that.executionRisk,_that.valueStability);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPlanScore implements TransferPlanScore {
  const _TransferPlanScore({required this.startingElevenGain, required this.executionRisk, required this.valueStability});
  factory _TransferPlanScore.fromJson(Map<String, dynamic> json) => _$TransferPlanScoreFromJson(json);

@override final  double startingElevenGain;
@override final  double executionRisk;
@override final  double valueStability;

/// Create a copy of TransferPlanScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPlanScoreCopyWith<_TransferPlanScore> get copyWith => __$TransferPlanScoreCopyWithImpl<_TransferPlanScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlanScoreToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPlanScore&&(identical(other.startingElevenGain, startingElevenGain) || other.startingElevenGain == startingElevenGain)&&(identical(other.executionRisk, executionRisk) || other.executionRisk == executionRisk)&&(identical(other.valueStability, valueStability) || other.valueStability == valueStability));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startingElevenGain,executionRisk,valueStability);
}

@override
String toString() {
    return 'TransferPlanScore(startingElevenGain: $startingElevenGain, executionRisk: $executionRisk, valueStability: $valueStability)';
}


}

/// @nodoc
abstract mixin class _$TransferPlanScoreCopyWith<$Res> implements $TransferPlanScoreCopyWith<$Res> {
  factory _$TransferPlanScoreCopyWith(_TransferPlanScore value, $Res Function(_TransferPlanScore) _then) = __$TransferPlanScoreCopyWithImpl;
@override @useResult
$Res call({
 double startingElevenGain, double executionRisk, double valueStability
});




}
/// @nodoc
class __$TransferPlanScoreCopyWithImpl<$Res>
    implements _$TransferPlanScoreCopyWith<$Res> {
  __$TransferPlanScoreCopyWithImpl(this._self, this._then);

  final _TransferPlanScore _self;
  final $Res Function(_TransferPlanScore) _then;

/// Create a copy of TransferPlanScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startingElevenGain = null,Object? executionRisk = null,Object? valueStability = null,}) {
  return _then(_TransferPlanScore(
startingElevenGain: null == startingElevenGain ? _self.startingElevenGain : startingElevenGain // ignore: cast_nullable_to_non_nullable
as double,executionRisk: null == executionRisk ? _self.executionRisk : executionRisk // ignore: cast_nullable_to_non_nullable
as double,valueStability: null == valueStability ? _self.valueStability : valueStability // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

TransferPlanMove _$TransferPlanMoveFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'sell':
          return TransferPlanMoveSell.fromJson(
            json
          );
                case 'buy':
          return TransferPlanMoveBuy.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'TransferPlanMove',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$TransferPlanMove {

 Player get player; int get amount;
/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlanMoveCopyWith<TransferPlanMove> get copyWith => _$TransferPlanMoveCopyWithImpl<TransferPlanMove>(this as TransferPlanMove, _$identity);

  /// Serializes this TransferPlanMove to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPlanMove;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlanMove&&(identical(other.player, _this.player) || other.player == _this.player)&&(identical(other.amount, _this.amount) || other.amount == _this.amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPlanMove;
  return Object.hash(runtimeType,_this.player,_this.amount);
}

@override
String toString() {
  final _this = this as TransferPlanMove;
  return 'TransferPlanMove(player: ${_this.player}, amount: ${_this.amount})';
}


}

/// @nodoc
abstract mixin class $TransferPlanMoveCopyWith<$Res>  {
  factory $TransferPlanMoveCopyWith(TransferPlanMove value, $Res Function(TransferPlanMove) _then) = _$TransferPlanMoveCopyWithImpl;
@useResult
$Res call({
 Player player, int amount
});


$PlayerCopyWith<$Res> get player;

}
/// @nodoc
class _$TransferPlanMoveCopyWithImpl<$Res>
    implements $TransferPlanMoveCopyWith<$Res> {
  _$TransferPlanMoveCopyWithImpl(this._self, this._then);

  final TransferPlanMove _self;
  final $Res Function(TransferPlanMove) _then;

/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? player = null,Object? amount = null,}) {
  return _then(_self.copyWith(
player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as Player,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get player {
  
  return $PlayerCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransferPlanMove].
extension TransferPlanMovePatterns on TransferPlanMove {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TransferPlanMoveSell value)?  sell,TResult Function( TransferPlanMoveBuy value)?  buy,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TransferPlanMoveSell() when sell != null:
return sell(_that);case TransferPlanMoveBuy() when buy != null:
return buy(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TransferPlanMoveSell value)  sell,required TResult Function( TransferPlanMoveBuy value)  buy,}){
final _that = this;
switch (_that) {
case TransferPlanMoveSell():
return sell(_that);case TransferPlanMoveBuy():
return buy(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TransferPlanMoveSell value)?  sell,TResult? Function( TransferPlanMoveBuy value)?  buy,}){
final _that = this;
switch (_that) {
case TransferPlanMoveSell() when sell != null:
return sell(_that);case TransferPlanMoveBuy() when buy != null:
return buy(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Player player,  int amount)?  sell,TResult Function( Player player,  int amount)?  buy,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TransferPlanMoveSell() when sell != null:
return sell(_that.player,_that.amount);case TransferPlanMoveBuy() when buy != null:
return buy(_that.player,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Player player,  int amount)  sell,required TResult Function( Player player,  int amount)  buy,}) {final _that = this;
switch (_that) {
case TransferPlanMoveSell():
return sell(_that.player,_that.amount);case TransferPlanMoveBuy():
return buy(_that.player,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Player player,  int amount)?  sell,TResult? Function( Player player,  int amount)?  buy,}) {final _that = this;
switch (_that) {
case TransferPlanMoveSell() when sell != null:
return sell(_that.player,_that.amount);case TransferPlanMoveBuy() when buy != null:
return buy(_that.player,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TransferPlanMoveSell implements TransferPlanMove {
  const TransferPlanMoveSell({required this.player, required this.amount,  String? $type}): $type = $type ?? 'sell';
  factory TransferPlanMoveSell.fromJson(Map<String, dynamic> json) => _$TransferPlanMoveSellFromJson(json);

@override final  Player player;
@override final  int amount;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlanMoveSellCopyWith<TransferPlanMoveSell> get copyWith => _$TransferPlanMoveSellCopyWithImpl<TransferPlanMoveSell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlanMoveSellToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlanMoveSell&&(identical(other.player, player) || other.player == player)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,player,amount);
}

@override
String toString() {
    return 'TransferPlanMove.sell(player: $player, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $TransferPlanMoveSellCopyWith<$Res> implements $TransferPlanMoveCopyWith<$Res> {
  factory $TransferPlanMoveSellCopyWith(TransferPlanMoveSell value, $Res Function(TransferPlanMoveSell) _then) = _$TransferPlanMoveSellCopyWithImpl;
@override @useResult
$Res call({
 Player player, int amount
});


@override $PlayerCopyWith<$Res> get player;

}
/// @nodoc
class _$TransferPlanMoveSellCopyWithImpl<$Res>
    implements $TransferPlanMoveSellCopyWith<$Res> {
  _$TransferPlanMoveSellCopyWithImpl(this._self, this._then);

  final TransferPlanMoveSell _self;
  final $Res Function(TransferPlanMoveSell) _then;

/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? player = null,Object? amount = null,}) {
  return _then(TransferPlanMoveSell(
player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as Player,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get player {
  
  return $PlayerCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class TransferPlanMoveBuy implements TransferPlanMove {
  const TransferPlanMoveBuy({required this.player, required this.amount,  String? $type}): $type = $type ?? 'buy';
  factory TransferPlanMoveBuy.fromJson(Map<String, dynamic> json) => _$TransferPlanMoveBuyFromJson(json);

@override final  Player player;
@override final  int amount;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlanMoveBuyCopyWith<TransferPlanMoveBuy> get copyWith => _$TransferPlanMoveBuyCopyWithImpl<TransferPlanMoveBuy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlanMoveBuyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlanMoveBuy&&(identical(other.player, player) || other.player == player)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,player,amount);
}

@override
String toString() {
    return 'TransferPlanMove.buy(player: $player, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $TransferPlanMoveBuyCopyWith<$Res> implements $TransferPlanMoveCopyWith<$Res> {
  factory $TransferPlanMoveBuyCopyWith(TransferPlanMoveBuy value, $Res Function(TransferPlanMoveBuy) _then) = _$TransferPlanMoveBuyCopyWithImpl;
@override @useResult
$Res call({
 Player player, int amount
});


@override $PlayerCopyWith<$Res> get player;

}
/// @nodoc
class _$TransferPlanMoveBuyCopyWithImpl<$Res>
    implements $TransferPlanMoveBuyCopyWith<$Res> {
  _$TransferPlanMoveBuyCopyWithImpl(this._self, this._then);

  final TransferPlanMoveBuy _self;
  final $Res Function(TransferPlanMoveBuy) _then;

/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? player = null,Object? amount = null,}) {
  return _then(TransferPlanMoveBuy(
player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as Player,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TransferPlanMove
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get player {
  
  return $PlayerCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}
}


/// @nodoc
mixin _$TransferPlanScenario {

 String get id; String get title; List<TransferPlanMove> get sells; List<TransferPlanMove> get buys; List<Player> get resultingStarters; int get budgetBefore; int get budgetAfter; String get summary; List<String> get warnings; TransferPlanScore get score;
/// Create a copy of TransferPlanScenario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlanScenarioCopyWith<TransferPlanScenario> get copyWith => _$TransferPlanScenarioCopyWithImpl<TransferPlanScenario>(this as TransferPlanScenario, _$identity);

  /// Serializes this TransferPlanScenario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPlanScenario;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlanScenario&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.sells, _this.sells)&&const DeepCollectionEquality().equals(other.buys, _this.buys)&&const DeepCollectionEquality().equals(other.resultingStarters, _this.resultingStarters)&&(identical(other.budgetBefore, _this.budgetBefore) || other.budgetBefore == _this.budgetBefore)&&(identical(other.budgetAfter, _this.budgetAfter) || other.budgetAfter == _this.budgetAfter)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.warnings, _this.warnings)&&(identical(other.score, _this.score) || other.score == _this.score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPlanScenario;
  return Object.hash(runtimeType,_this.id,_this.title,const DeepCollectionEquality().hash(_this.sells),const DeepCollectionEquality().hash(_this.buys),const DeepCollectionEquality().hash(_this.resultingStarters),_this.budgetBefore,_this.budgetAfter,_this.summary,const DeepCollectionEquality().hash(_this.warnings),_this.score);
}

@override
String toString() {
  final _this = this as TransferPlanScenario;
  return 'TransferPlanScenario(id: ${_this.id}, title: ${_this.title}, sells: ${_this.sells}, buys: ${_this.buys}, resultingStarters: ${_this.resultingStarters}, budgetBefore: ${_this.budgetBefore}, budgetAfter: ${_this.budgetAfter}, summary: ${_this.summary}, warnings: ${_this.warnings}, score: ${_this.score})';
}


}

/// @nodoc
abstract mixin class $TransferPlanScenarioCopyWith<$Res>  {
  factory $TransferPlanScenarioCopyWith(TransferPlanScenario value, $Res Function(TransferPlanScenario) _then) = _$TransferPlanScenarioCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<TransferPlanMove> sells, List<TransferPlanMove> buys, List<Player> resultingStarters, int budgetBefore, int budgetAfter, String summary, List<String> warnings, TransferPlanScore score
});


$TransferPlanScoreCopyWith<$Res> get score;

}
/// @nodoc
class _$TransferPlanScenarioCopyWithImpl<$Res>
    implements $TransferPlanScenarioCopyWith<$Res> {
  _$TransferPlanScenarioCopyWithImpl(this._self, this._then);

  final TransferPlanScenario _self;
  final $Res Function(TransferPlanScenario) _then;

/// Create a copy of TransferPlanScenario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? sells = null,Object? buys = null,Object? resultingStarters = null,Object? budgetBefore = null,Object? budgetAfter = null,Object? summary = null,Object? warnings = null,Object? score = null,}) {
  return _then(TransferPlanScenario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sells: null == sells ? _self.sells : sells // ignore: cast_nullable_to_non_nullable
as List<TransferPlanMove>,buys: null == buys ? _self.buys : buys // ignore: cast_nullable_to_non_nullable
as List<TransferPlanMove>,resultingStarters: null == resultingStarters ? _self.resultingStarters : resultingStarters // ignore: cast_nullable_to_non_nullable
as List<Player>,budgetBefore: null == budgetBefore ? _self.budgetBefore : budgetBefore // ignore: cast_nullable_to_non_nullable
as int,budgetAfter: null == budgetAfter ? _self.budgetAfter : budgetAfter // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as TransferPlanScore,
  ));
}
/// Create a copy of TransferPlanScenario
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferPlanScoreCopyWith<$Res> get score {
  
  return $TransferPlanScoreCopyWith<$Res>(_self.score, (value) {
    return _then(_self.copyWith(score: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransferPlanScenario].
extension TransferPlanScenarioPatterns on TransferPlanScenario {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPlanScenario value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPlanScenario() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPlanScenario value)  $default,){
final _that = this;
switch (_that) {
case _TransferPlanScenario():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPlanScenario value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPlanScenario() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<TransferPlanMove> sells,  List<TransferPlanMove> buys,  List<Player> resultingStarters,  int budgetBefore,  int budgetAfter,  String summary,  List<String> warnings,  TransferPlanScore score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPlanScenario() when $default != null:
return $default(_that.id,_that.title,_that.sells,_that.buys,_that.resultingStarters,_that.budgetBefore,_that.budgetAfter,_that.summary,_that.warnings,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<TransferPlanMove> sells,  List<TransferPlanMove> buys,  List<Player> resultingStarters,  int budgetBefore,  int budgetAfter,  String summary,  List<String> warnings,  TransferPlanScore score)  $default,) {final _that = this;
switch (_that) {
case _TransferPlanScenario():
return $default(_that.id,_that.title,_that.sells,_that.buys,_that.resultingStarters,_that.budgetBefore,_that.budgetAfter,_that.summary,_that.warnings,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<TransferPlanMove> sells,  List<TransferPlanMove> buys,  List<Player> resultingStarters,  int budgetBefore,  int budgetAfter,  String summary,  List<String> warnings,  TransferPlanScore score)?  $default,) {final _that = this;
switch (_that) {
case _TransferPlanScenario() when $default != null:
return $default(_that.id,_that.title,_that.sells,_that.buys,_that.resultingStarters,_that.budgetBefore,_that.budgetAfter,_that.summary,_that.warnings,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPlanScenario implements TransferPlanScenario {
  const _TransferPlanScenario({required this.id, required this.title, required  List<TransferPlanMove> sells, required  List<TransferPlanMove> buys, required  List<Player> resultingStarters, required this.budgetBefore, required this.budgetAfter, required this.summary, required  List<String> warnings, required this.score}): _sells = sells,_buys = buys,_resultingStarters = resultingStarters,_warnings = warnings;
  factory _TransferPlanScenario.fromJson(Map<String, dynamic> json) => _$TransferPlanScenarioFromJson(json);

@override final  String id;
@override final  String title;
 final  List<TransferPlanMove> _sells;
@override List<TransferPlanMove> get sells {
  if (_sells is EqualUnmodifiableListView) return _sells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sells);
}

 final  List<TransferPlanMove> _buys;
@override List<TransferPlanMove> get buys {
  if (_buys is EqualUnmodifiableListView) return _buys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buys);
}

 final  List<Player> _resultingStarters;
@override List<Player> get resultingStarters {
  if (_resultingStarters is EqualUnmodifiableListView) return _resultingStarters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_resultingStarters);
}

@override final  int budgetBefore;
@override final  int budgetAfter;
@override final  String summary;
 final  List<String> _warnings;
@override List<String> get warnings {
  if (_warnings is EqualUnmodifiableListView) return _warnings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warnings);
}

@override final  TransferPlanScore score;

/// Create a copy of TransferPlanScenario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPlanScenarioCopyWith<_TransferPlanScenario> get copyWith => __$TransferPlanScenarioCopyWithImpl<_TransferPlanScenario>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlanScenarioToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPlanScenario&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.sells, _sells)&&const DeepCollectionEquality().equals(other.buys, _buys)&&const DeepCollectionEquality().equals(other.resultingStarters, _resultingStarters)&&(identical(other.budgetBefore, budgetBefore) || other.budgetBefore == budgetBefore)&&(identical(other.budgetAfter, budgetAfter) || other.budgetAfter == budgetAfter)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.warnings, _warnings)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_sells),const DeepCollectionEquality().hash(_buys),const DeepCollectionEquality().hash(_resultingStarters),budgetBefore,budgetAfter,summary,const DeepCollectionEquality().hash(_warnings),score);
}

@override
String toString() {
    return 'TransferPlanScenario(id: $id, title: $title, sells: $sells, buys: $buys, resultingStarters: $resultingStarters, budgetBefore: $budgetBefore, budgetAfter: $budgetAfter, summary: $summary, warnings: $warnings, score: $score)';
}


}

/// @nodoc
abstract mixin class _$TransferPlanScenarioCopyWith<$Res> implements $TransferPlanScenarioCopyWith<$Res> {
  factory _$TransferPlanScenarioCopyWith(_TransferPlanScenario value, $Res Function(_TransferPlanScenario) _then) = __$TransferPlanScenarioCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<TransferPlanMove> sells, List<TransferPlanMove> buys, List<Player> resultingStarters, int budgetBefore, int budgetAfter, String summary, List<String> warnings, TransferPlanScore score
});


@override $TransferPlanScoreCopyWith<$Res> get score;

}
/// @nodoc
class __$TransferPlanScenarioCopyWithImpl<$Res>
    implements _$TransferPlanScenarioCopyWith<$Res> {
  __$TransferPlanScenarioCopyWithImpl(this._self, this._then);

  final _TransferPlanScenario _self;
  final $Res Function(_TransferPlanScenario) _then;

/// Create a copy of TransferPlanScenario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? sells = null,Object? buys = null,Object? resultingStarters = null,Object? budgetBefore = null,Object? budgetAfter = null,Object? summary = null,Object? warnings = null,Object? score = null,}) {
  return _then(_TransferPlanScenario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sells: null == sells ? _self._sells : sells // ignore: cast_nullable_to_non_nullable
as List<TransferPlanMove>,buys: null == buys ? _self._buys : buys // ignore: cast_nullable_to_non_nullable
as List<TransferPlanMove>,resultingStarters: null == resultingStarters ? _self._resultingStarters : resultingStarters // ignore: cast_nullable_to_non_nullable
as List<Player>,budgetBefore: null == budgetBefore ? _self.budgetBefore : budgetBefore // ignore: cast_nullable_to_non_nullable
as int,budgetAfter: null == budgetAfter ? _self.budgetAfter : budgetAfter // ignore: cast_nullable_to_non_nullable
as int,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,warnings: null == warnings ? _self._warnings : warnings // ignore: cast_nullable_to_non_nullable
as List<String>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as TransferPlanScore,
  ));
}

/// Create a copy of TransferPlanScenario
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferPlanScoreCopyWith<$Res> get score {
  
  return $TransferPlanScoreCopyWith<$Res>(_self.score, (value) {
    return _then(_self.copyWith(score: value));
  });
}
}


/// @nodoc
mixin _$TransferPlannerResult {

 List<TransferPlanScenario> get scenarios; String? get noPlanReason;/// Diagnose-Unterzeile: nennt die konkrete Ursache, warum kein Plan
/// gefunden wurde (z. B. leerer Kader, leerer Markt, Ablehnungsgründe
/// je Marktspieler). Wird unter [noPlanReason] in der UI angezeigt.
 String? get noPlanDetails;
/// Create a copy of TransferPlannerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferPlannerResultCopyWith<TransferPlannerResult> get copyWith => _$TransferPlannerResultCopyWithImpl<TransferPlannerResult>(this as TransferPlannerResult, _$identity);

  /// Serializes this TransferPlannerResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferPlannerResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferPlannerResult&&const DeepCollectionEquality().equals(other.scenarios, _this.scenarios)&&(identical(other.noPlanReason, _this.noPlanReason) || other.noPlanReason == _this.noPlanReason)&&(identical(other.noPlanDetails, _this.noPlanDetails) || other.noPlanDetails == _this.noPlanDetails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferPlannerResult;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.scenarios),_this.noPlanReason,_this.noPlanDetails);
}

@override
String toString() {
  final _this = this as TransferPlannerResult;
  return 'TransferPlannerResult(scenarios: ${_this.scenarios}, noPlanReason: ${_this.noPlanReason}, noPlanDetails: ${_this.noPlanDetails})';
}


}

/// @nodoc
abstract mixin class $TransferPlannerResultCopyWith<$Res>  {
  factory $TransferPlannerResultCopyWith(TransferPlannerResult value, $Res Function(TransferPlannerResult) _then) = _$TransferPlannerResultCopyWithImpl;
@useResult
$Res call({
 List<TransferPlanScenario> scenarios, String? noPlanReason, String? noPlanDetails
});




}
/// @nodoc
class _$TransferPlannerResultCopyWithImpl<$Res>
    implements $TransferPlannerResultCopyWith<$Res> {
  _$TransferPlannerResultCopyWithImpl(this._self, this._then);

  final TransferPlannerResult _self;
  final $Res Function(TransferPlannerResult) _then;

/// Create a copy of TransferPlannerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scenarios = null,Object? noPlanReason = freezed,Object? noPlanDetails = freezed,}) {
  return _then(TransferPlannerResult(
scenarios: null == scenarios ? _self.scenarios : scenarios // ignore: cast_nullable_to_non_nullable
as List<TransferPlanScenario>,noPlanReason: freezed == noPlanReason ? _self.noPlanReason : noPlanReason // ignore: cast_nullable_to_non_nullable
as String?,noPlanDetails: freezed == noPlanDetails ? _self.noPlanDetails : noPlanDetails // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferPlannerResult].
extension TransferPlannerResultPatterns on TransferPlannerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferPlannerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferPlannerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferPlannerResult value)  $default,){
final _that = this;
switch (_that) {
case _TransferPlannerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferPlannerResult value)?  $default,){
final _that = this;
switch (_that) {
case _TransferPlannerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransferPlanScenario> scenarios,  String? noPlanReason,  String? noPlanDetails)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferPlannerResult() when $default != null:
return $default(_that.scenarios,_that.noPlanReason,_that.noPlanDetails);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransferPlanScenario> scenarios,  String? noPlanReason,  String? noPlanDetails)  $default,) {final _that = this;
switch (_that) {
case _TransferPlannerResult():
return $default(_that.scenarios,_that.noPlanReason,_that.noPlanDetails);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransferPlanScenario> scenarios,  String? noPlanReason,  String? noPlanDetails)?  $default,) {final _that = this;
switch (_that) {
case _TransferPlannerResult() when $default != null:
return $default(_that.scenarios,_that.noPlanReason,_that.noPlanDetails);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferPlannerResult implements TransferPlannerResult {
  const _TransferPlannerResult({required  List<TransferPlanScenario> scenarios, this.noPlanReason, this.noPlanDetails}): _scenarios = scenarios;
  factory _TransferPlannerResult.fromJson(Map<String, dynamic> json) => _$TransferPlannerResultFromJson(json);

 final  List<TransferPlanScenario> _scenarios;
@override List<TransferPlanScenario> get scenarios {
  if (_scenarios is EqualUnmodifiableListView) return _scenarios;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scenarios);
}

@override final  String? noPlanReason;
/// Diagnose-Unterzeile: nennt die konkrete Ursache, warum kein Plan
/// gefunden wurde (z. B. leerer Kader, leerer Markt, Ablehnungsgründe
/// je Marktspieler). Wird unter [noPlanReason] in der UI angezeigt.
@override final  String? noPlanDetails;

/// Create a copy of TransferPlannerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferPlannerResultCopyWith<_TransferPlannerResult> get copyWith => __$TransferPlannerResultCopyWithImpl<_TransferPlannerResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferPlannerResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferPlannerResult&&const DeepCollectionEquality().equals(other.scenarios, _scenarios)&&(identical(other.noPlanReason, noPlanReason) || other.noPlanReason == noPlanReason)&&(identical(other.noPlanDetails, noPlanDetails) || other.noPlanDetails == noPlanDetails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_scenarios),noPlanReason,noPlanDetails);
}

@override
String toString() {
    return 'TransferPlannerResult(scenarios: $scenarios, noPlanReason: $noPlanReason, noPlanDetails: $noPlanDetails)';
}


}

/// @nodoc
abstract mixin class _$TransferPlannerResultCopyWith<$Res> implements $TransferPlannerResultCopyWith<$Res> {
  factory _$TransferPlannerResultCopyWith(_TransferPlannerResult value, $Res Function(_TransferPlannerResult) _then) = __$TransferPlannerResultCopyWithImpl;
@override @useResult
$Res call({
 List<TransferPlanScenario> scenarios, String? noPlanReason, String? noPlanDetails
});




}
/// @nodoc
class __$TransferPlannerResultCopyWithImpl<$Res>
    implements _$TransferPlannerResultCopyWith<$Res> {
  __$TransferPlannerResultCopyWithImpl(this._self, this._then);

  final _TransferPlannerResult _self;
  final $Res Function(_TransferPlannerResult) _then;

/// Create a copy of TransferPlannerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scenarios = null,Object? noPlanReason = freezed,Object? noPlanDetails = freezed,}) {
  return _then(_TransferPlannerResult(
scenarios: null == scenarios ? _self._scenarios : scenarios // ignore: cast_nullable_to_non_nullable
as List<TransferPlanScenario>,noPlanReason: freezed == noPlanReason ? _self.noPlanReason : noPlanReason // ignore: cast_nullable_to_non_nullable
as String?,noPlanDetails: freezed == noPlanDetails ? _self.noPlanDetails : noPlanDetails // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
