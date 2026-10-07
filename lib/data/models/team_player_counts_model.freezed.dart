// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_player_counts_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamPlayerCounts {

 int get total; int get goalkeepers; int get defenders; int get midfielders; int get forwards;
/// Create a copy of TeamPlayerCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamPlayerCountsCopyWith<TeamPlayerCounts> get copyWith => _$TeamPlayerCountsCopyWithImpl<TeamPlayerCounts>(this as TeamPlayerCounts, _$identity);

  /// Serializes this TeamPlayerCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TeamPlayerCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamPlayerCounts&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.goalkeepers, _this.goalkeepers) || other.goalkeepers == _this.goalkeepers)&&(identical(other.defenders, _this.defenders) || other.defenders == _this.defenders)&&(identical(other.midfielders, _this.midfielders) || other.midfielders == _this.midfielders)&&(identical(other.forwards, _this.forwards) || other.forwards == _this.forwards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TeamPlayerCounts;
  return Object.hash(runtimeType,_this.total,_this.goalkeepers,_this.defenders,_this.midfielders,_this.forwards);
}

@override
String toString() {
  final _this = this as TeamPlayerCounts;
  return 'TeamPlayerCounts(total: ${_this.total}, goalkeepers: ${_this.goalkeepers}, defenders: ${_this.defenders}, midfielders: ${_this.midfielders}, forwards: ${_this.forwards})';
}


}

/// @nodoc
abstract mixin class $TeamPlayerCountsCopyWith<$Res>  {
  factory $TeamPlayerCountsCopyWith(TeamPlayerCounts value, $Res Function(TeamPlayerCounts) _then) = _$TeamPlayerCountsCopyWithImpl;
@useResult
$Res call({
 int total, int goalkeepers, int defenders, int midfielders, int forwards
});




}
/// @nodoc
class _$TeamPlayerCountsCopyWithImpl<$Res>
    implements $TeamPlayerCountsCopyWith<$Res> {
  _$TeamPlayerCountsCopyWithImpl(this._self, this._then);

  final TeamPlayerCounts _self;
  final $Res Function(TeamPlayerCounts) _then;

/// Create a copy of TeamPlayerCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? goalkeepers = null,Object? defenders = null,Object? midfielders = null,Object? forwards = null,}) {
  return _then(TeamPlayerCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,goalkeepers: null == goalkeepers ? _self.goalkeepers : goalkeepers // ignore: cast_nullable_to_non_nullable
as int,defenders: null == defenders ? _self.defenders : defenders // ignore: cast_nullable_to_non_nullable
as int,midfielders: null == midfielders ? _self.midfielders : midfielders // ignore: cast_nullable_to_non_nullable
as int,forwards: null == forwards ? _self.forwards : forwards // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamPlayerCounts].
extension TeamPlayerCountsPatterns on TeamPlayerCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamPlayerCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamPlayerCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamPlayerCounts value)  $default,){
final _that = this;
switch (_that) {
case _TeamPlayerCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamPlayerCounts value)?  $default,){
final _that = this;
switch (_that) {
case _TeamPlayerCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int goalkeepers,  int defenders,  int midfielders,  int forwards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamPlayerCounts() when $default != null:
return $default(_that.total,_that.goalkeepers,_that.defenders,_that.midfielders,_that.forwards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int goalkeepers,  int defenders,  int midfielders,  int forwards)  $default,) {final _that = this;
switch (_that) {
case _TeamPlayerCounts():
return $default(_that.total,_that.goalkeepers,_that.defenders,_that.midfielders,_that.forwards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int goalkeepers,  int defenders,  int midfielders,  int forwards)?  $default,) {final _that = this;
switch (_that) {
case _TeamPlayerCounts() when $default != null:
return $default(_that.total,_that.goalkeepers,_that.defenders,_that.midfielders,_that.forwards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamPlayerCounts implements TeamPlayerCounts {
  const _TeamPlayerCounts({required this.total, required this.goalkeepers, required this.defenders, required this.midfielders, required this.forwards});
  factory _TeamPlayerCounts.fromJson(Map<String, dynamic> json) => _$TeamPlayerCountsFromJson(json);

@override final  int total;
@override final  int goalkeepers;
@override final  int defenders;
@override final  int midfielders;
@override final  int forwards;

/// Create a copy of TeamPlayerCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamPlayerCountsCopyWith<_TeamPlayerCounts> get copyWith => __$TeamPlayerCountsCopyWithImpl<_TeamPlayerCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamPlayerCountsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamPlayerCounts&&(identical(other.total, total) || other.total == total)&&(identical(other.goalkeepers, goalkeepers) || other.goalkeepers == goalkeepers)&&(identical(other.defenders, defenders) || other.defenders == defenders)&&(identical(other.midfielders, midfielders) || other.midfielders == midfielders)&&(identical(other.forwards, forwards) || other.forwards == forwards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,goalkeepers,defenders,midfielders,forwards);
}

@override
String toString() {
    return 'TeamPlayerCounts(total: $total, goalkeepers: $goalkeepers, defenders: $defenders, midfielders: $midfielders, forwards: $forwards)';
}


}

/// @nodoc
abstract mixin class _$TeamPlayerCountsCopyWith<$Res> implements $TeamPlayerCountsCopyWith<$Res> {
  factory _$TeamPlayerCountsCopyWith(_TeamPlayerCounts value, $Res Function(_TeamPlayerCounts) _then) = __$TeamPlayerCountsCopyWithImpl;
@override @useResult
$Res call({
 int total, int goalkeepers, int defenders, int midfielders, int forwards
});




}
/// @nodoc
class __$TeamPlayerCountsCopyWithImpl<$Res>
    implements _$TeamPlayerCountsCopyWith<$Res> {
  __$TeamPlayerCountsCopyWithImpl(this._self, this._then);

  final _TeamPlayerCounts _self;
  final $Res Function(_TeamPlayerCounts) _then;

/// Create a copy of TeamPlayerCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? goalkeepers = null,Object? defenders = null,Object? midfielders = null,Object? forwards = null,}) {
  return _then(_TeamPlayerCounts(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,goalkeepers: null == goalkeepers ? _self.goalkeepers : goalkeepers // ignore: cast_nullable_to_non_nullable
as int,defenders: null == defenders ? _self.defenders : defenders // ignore: cast_nullable_to_non_nullable
as int,midfielders: null == midfielders ? _self.midfielders : midfielders // ignore: cast_nullable_to_non_nullable
as int,forwards: null == forwards ? _self.forwards : forwards // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FixtureAnalysis {

 double get averageDifficulty; int get topTeamOpponents; int get difficultAwayGames; int get totalMatches;
/// Create a copy of FixtureAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FixtureAnalysisCopyWith<FixtureAnalysis> get copyWith => _$FixtureAnalysisCopyWithImpl<FixtureAnalysis>(this as FixtureAnalysis, _$identity);

  /// Serializes this FixtureAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FixtureAnalysis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FixtureAnalysis&&(identical(other.averageDifficulty, _this.averageDifficulty) || other.averageDifficulty == _this.averageDifficulty)&&(identical(other.topTeamOpponents, _this.topTeamOpponents) || other.topTeamOpponents == _this.topTeamOpponents)&&(identical(other.difficultAwayGames, _this.difficultAwayGames) || other.difficultAwayGames == _this.difficultAwayGames)&&(identical(other.totalMatches, _this.totalMatches) || other.totalMatches == _this.totalMatches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FixtureAnalysis;
  return Object.hash(runtimeType,_this.averageDifficulty,_this.topTeamOpponents,_this.difficultAwayGames,_this.totalMatches);
}

@override
String toString() {
  final _this = this as FixtureAnalysis;
  return 'FixtureAnalysis(averageDifficulty: ${_this.averageDifficulty}, topTeamOpponents: ${_this.topTeamOpponents}, difficultAwayGames: ${_this.difficultAwayGames}, totalMatches: ${_this.totalMatches})';
}


}

/// @nodoc
abstract mixin class $FixtureAnalysisCopyWith<$Res>  {
  factory $FixtureAnalysisCopyWith(FixtureAnalysis value, $Res Function(FixtureAnalysis) _then) = _$FixtureAnalysisCopyWithImpl;
@useResult
$Res call({
 double averageDifficulty, int topTeamOpponents, int difficultAwayGames, int totalMatches
});




}
/// @nodoc
class _$FixtureAnalysisCopyWithImpl<$Res>
    implements $FixtureAnalysisCopyWith<$Res> {
  _$FixtureAnalysisCopyWithImpl(this._self, this._then);

  final FixtureAnalysis _self;
  final $Res Function(FixtureAnalysis) _then;

/// Create a copy of FixtureAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? averageDifficulty = null,Object? topTeamOpponents = null,Object? difficultAwayGames = null,Object? totalMatches = null,}) {
  return _then(FixtureAnalysis(
averageDifficulty: null == averageDifficulty ? _self.averageDifficulty : averageDifficulty // ignore: cast_nullable_to_non_nullable
as double,topTeamOpponents: null == topTeamOpponents ? _self.topTeamOpponents : topTeamOpponents // ignore: cast_nullable_to_non_nullable
as int,difficultAwayGames: null == difficultAwayGames ? _self.difficultAwayGames : difficultAwayGames // ignore: cast_nullable_to_non_nullable
as int,totalMatches: null == totalMatches ? _self.totalMatches : totalMatches // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FixtureAnalysis].
extension FixtureAnalysisPatterns on FixtureAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FixtureAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FixtureAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FixtureAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _FixtureAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FixtureAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _FixtureAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double averageDifficulty,  int topTeamOpponents,  int difficultAwayGames,  int totalMatches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FixtureAnalysis() when $default != null:
return $default(_that.averageDifficulty,_that.topTeamOpponents,_that.difficultAwayGames,_that.totalMatches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double averageDifficulty,  int topTeamOpponents,  int difficultAwayGames,  int totalMatches)  $default,) {final _that = this;
switch (_that) {
case _FixtureAnalysis():
return $default(_that.averageDifficulty,_that.topTeamOpponents,_that.difficultAwayGames,_that.totalMatches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double averageDifficulty,  int topTeamOpponents,  int difficultAwayGames,  int totalMatches)?  $default,) {final _that = this;
switch (_that) {
case _FixtureAnalysis() when $default != null:
return $default(_that.averageDifficulty,_that.topTeamOpponents,_that.difficultAwayGames,_that.totalMatches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FixtureAnalysis implements FixtureAnalysis {
  const _FixtureAnalysis({required this.averageDifficulty, required this.topTeamOpponents, required this.difficultAwayGames, required this.totalMatches});
  factory _FixtureAnalysis.fromJson(Map<String, dynamic> json) => _$FixtureAnalysisFromJson(json);

@override final  double averageDifficulty;
@override final  int topTeamOpponents;
@override final  int difficultAwayGames;
@override final  int totalMatches;

/// Create a copy of FixtureAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FixtureAnalysisCopyWith<_FixtureAnalysis> get copyWith => __$FixtureAnalysisCopyWithImpl<_FixtureAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FixtureAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FixtureAnalysis&&(identical(other.averageDifficulty, averageDifficulty) || other.averageDifficulty == averageDifficulty)&&(identical(other.topTeamOpponents, topTeamOpponents) || other.topTeamOpponents == topTeamOpponents)&&(identical(other.difficultAwayGames, difficultAwayGames) || other.difficultAwayGames == difficultAwayGames)&&(identical(other.totalMatches, totalMatches) || other.totalMatches == totalMatches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,averageDifficulty,topTeamOpponents,difficultAwayGames,totalMatches);
}

@override
String toString() {
    return 'FixtureAnalysis(averageDifficulty: $averageDifficulty, topTeamOpponents: $topTeamOpponents, difficultAwayGames: $difficultAwayGames, totalMatches: $totalMatches)';
}


}

/// @nodoc
abstract mixin class _$FixtureAnalysisCopyWith<$Res> implements $FixtureAnalysisCopyWith<$Res> {
  factory _$FixtureAnalysisCopyWith(_FixtureAnalysis value, $Res Function(_FixtureAnalysis) _then) = __$FixtureAnalysisCopyWithImpl;
@override @useResult
$Res call({
 double averageDifficulty, int topTeamOpponents, int difficultAwayGames, int totalMatches
});




}
/// @nodoc
class __$FixtureAnalysisCopyWithImpl<$Res>
    implements _$FixtureAnalysisCopyWith<$Res> {
  __$FixtureAnalysisCopyWithImpl(this._self, this._then);

  final _FixtureAnalysis _self;
  final $Res Function(_FixtureAnalysis) _then;

/// Create a copy of FixtureAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? averageDifficulty = null,Object? topTeamOpponents = null,Object? difficultAwayGames = null,Object? totalMatches = null,}) {
  return _then(_FixtureAnalysis(
averageDifficulty: null == averageDifficulty ? _self.averageDifficulty : averageDifficulty // ignore: cast_nullable_to_non_nullable
as double,topTeamOpponents: null == topTeamOpponents ? _self.topTeamOpponents : topTeamOpponents // ignore: cast_nullable_to_non_nullable
as int,difficultAwayGames: null == difficultAwayGames ? _self.difficultAwayGames : difficultAwayGames // ignore: cast_nullable_to_non_nullable
as int,totalMatches: null == totalMatches ? _self.totalMatches : totalMatches // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
