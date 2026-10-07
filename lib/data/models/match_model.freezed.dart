// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Match {

 String get id; String get matchDay; int get kickOffTime; String get homeTeamId; String get homeTeamName; String get awayTeamId; String get awayTeamName; int get homeTeamGoals; int get awayTeamGoals; String get status; int get season;
/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchCopyWith<Match> get copyWith => _$MatchCopyWithImpl<Match>(this as Match, _$identity);

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Match;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Match&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.matchDay, _this.matchDay) || other.matchDay == _this.matchDay)&&(identical(other.kickOffTime, _this.kickOffTime) || other.kickOffTime == _this.kickOffTime)&&(identical(other.homeTeamId, _this.homeTeamId) || other.homeTeamId == _this.homeTeamId)&&(identical(other.homeTeamName, _this.homeTeamName) || other.homeTeamName == _this.homeTeamName)&&(identical(other.awayTeamId, _this.awayTeamId) || other.awayTeamId == _this.awayTeamId)&&(identical(other.awayTeamName, _this.awayTeamName) || other.awayTeamName == _this.awayTeamName)&&(identical(other.homeTeamGoals, _this.homeTeamGoals) || other.homeTeamGoals == _this.homeTeamGoals)&&(identical(other.awayTeamGoals, _this.awayTeamGoals) || other.awayTeamGoals == _this.awayTeamGoals)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.season, _this.season) || other.season == _this.season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Match;
  return Object.hash(runtimeType,_this.id,_this.matchDay,_this.kickOffTime,_this.homeTeamId,_this.homeTeamName,_this.awayTeamId,_this.awayTeamName,_this.homeTeamGoals,_this.awayTeamGoals,_this.status,_this.season);
}

@override
String toString() {
  final _this = this as Match;
  return 'Match(id: ${_this.id}, matchDay: ${_this.matchDay}, kickOffTime: ${_this.kickOffTime}, homeTeamId: ${_this.homeTeamId}, homeTeamName: ${_this.homeTeamName}, awayTeamId: ${_this.awayTeamId}, awayTeamName: ${_this.awayTeamName}, homeTeamGoals: ${_this.homeTeamGoals}, awayTeamGoals: ${_this.awayTeamGoals}, status: ${_this.status}, season: ${_this.season})';
}


}

/// @nodoc
abstract mixin class $MatchCopyWith<$Res>  {
  factory $MatchCopyWith(Match value, $Res Function(Match) _then) = _$MatchCopyWithImpl;
@useResult
$Res call({
 String id, String matchDay, int kickOffTime, String homeTeamId, String homeTeamName, String awayTeamId, String awayTeamName, int homeTeamGoals, int awayTeamGoals, String status, int season
});




}
/// @nodoc
class _$MatchCopyWithImpl<$Res>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._self, this._then);

  final Match _self;
  final $Res Function(Match) _then;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? matchDay = null,Object? kickOffTime = null,Object? homeTeamId = null,Object? homeTeamName = null,Object? awayTeamId = null,Object? awayTeamName = null,Object? homeTeamGoals = null,Object? awayTeamGoals = null,Object? status = null,Object? season = null,}) {
  return _then(Match(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matchDay: null == matchDay ? _self.matchDay : matchDay // ignore: cast_nullable_to_non_nullable
as String,kickOffTime: null == kickOffTime ? _self.kickOffTime : kickOffTime // ignore: cast_nullable_to_non_nullable
as int,homeTeamId: null == homeTeamId ? _self.homeTeamId : homeTeamId // ignore: cast_nullable_to_non_nullable
as String,homeTeamName: null == homeTeamName ? _self.homeTeamName : homeTeamName // ignore: cast_nullable_to_non_nullable
as String,awayTeamId: null == awayTeamId ? _self.awayTeamId : awayTeamId // ignore: cast_nullable_to_non_nullable
as String,awayTeamName: null == awayTeamName ? _self.awayTeamName : awayTeamName // ignore: cast_nullable_to_non_nullable
as String,homeTeamGoals: null == homeTeamGoals ? _self.homeTeamGoals : homeTeamGoals // ignore: cast_nullable_to_non_nullable
as int,awayTeamGoals: null == awayTeamGoals ? _self.awayTeamGoals : awayTeamGoals // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Match].
extension MatchPatterns on Match {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Match value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Match() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Match value)  $default,){
final _that = this;
switch (_that) {
case _Match():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Match value)?  $default,){
final _that = this;
switch (_that) {
case _Match() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String matchDay,  int kickOffTime,  String homeTeamId,  String homeTeamName,  String awayTeamId,  String awayTeamName,  int homeTeamGoals,  int awayTeamGoals,  String status,  int season)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Match() when $default != null:
return $default(_that.id,_that.matchDay,_that.kickOffTime,_that.homeTeamId,_that.homeTeamName,_that.awayTeamId,_that.awayTeamName,_that.homeTeamGoals,_that.awayTeamGoals,_that.status,_that.season);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String matchDay,  int kickOffTime,  String homeTeamId,  String homeTeamName,  String awayTeamId,  String awayTeamName,  int homeTeamGoals,  int awayTeamGoals,  String status,  int season)  $default,) {final _that = this;
switch (_that) {
case _Match():
return $default(_that.id,_that.matchDay,_that.kickOffTime,_that.homeTeamId,_that.homeTeamName,_that.awayTeamId,_that.awayTeamName,_that.homeTeamGoals,_that.awayTeamGoals,_that.status,_that.season);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String matchDay,  int kickOffTime,  String homeTeamId,  String homeTeamName,  String awayTeamId,  String awayTeamName,  int homeTeamGoals,  int awayTeamGoals,  String status,  int season)?  $default,) {final _that = this;
switch (_that) {
case _Match() when $default != null:
return $default(_that.id,_that.matchDay,_that.kickOffTime,_that.homeTeamId,_that.homeTeamName,_that.awayTeamId,_that.awayTeamName,_that.homeTeamGoals,_that.awayTeamGoals,_that.status,_that.season);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Match implements Match {
  const _Match({required this.id, required this.matchDay, required this.kickOffTime, required this.homeTeamId, required this.homeTeamName, required this.awayTeamId, required this.awayTeamName, required this.homeTeamGoals, required this.awayTeamGoals, required this.status, required this.season});
  factory _Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

@override final  String id;
@override final  String matchDay;
@override final  int kickOffTime;
@override final  String homeTeamId;
@override final  String homeTeamName;
@override final  String awayTeamId;
@override final  String awayTeamName;
@override final  int homeTeamGoals;
@override final  int awayTeamGoals;
@override final  String status;
@override final  int season;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchCopyWith<_Match> get copyWith => __$MatchCopyWithImpl<_Match>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Match&&(identical(other.id, id) || other.id == id)&&(identical(other.matchDay, matchDay) || other.matchDay == matchDay)&&(identical(other.kickOffTime, kickOffTime) || other.kickOffTime == kickOffTime)&&(identical(other.homeTeamId, homeTeamId) || other.homeTeamId == homeTeamId)&&(identical(other.homeTeamName, homeTeamName) || other.homeTeamName == homeTeamName)&&(identical(other.awayTeamId, awayTeamId) || other.awayTeamId == awayTeamId)&&(identical(other.awayTeamName, awayTeamName) || other.awayTeamName == awayTeamName)&&(identical(other.homeTeamGoals, homeTeamGoals) || other.homeTeamGoals == homeTeamGoals)&&(identical(other.awayTeamGoals, awayTeamGoals) || other.awayTeamGoals == awayTeamGoals)&&(identical(other.status, status) || other.status == status)&&(identical(other.season, season) || other.season == season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,matchDay,kickOffTime,homeTeamId,homeTeamName,awayTeamId,awayTeamName,homeTeamGoals,awayTeamGoals,status,season);
}

@override
String toString() {
    return 'Match(id: $id, matchDay: $matchDay, kickOffTime: $kickOffTime, homeTeamId: $homeTeamId, homeTeamName: $homeTeamName, awayTeamId: $awayTeamId, awayTeamName: $awayTeamName, homeTeamGoals: $homeTeamGoals, awayTeamGoals: $awayTeamGoals, status: $status, season: $season)';
}


}

/// @nodoc
abstract mixin class _$MatchCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$MatchCopyWith(_Match value, $Res Function(_Match) _then) = __$MatchCopyWithImpl;
@override @useResult
$Res call({
 String id, String matchDay, int kickOffTime, String homeTeamId, String homeTeamName, String awayTeamId, String awayTeamName, int homeTeamGoals, int awayTeamGoals, String status, int season
});




}
/// @nodoc
class __$MatchCopyWithImpl<$Res>
    implements _$MatchCopyWith<$Res> {
  __$MatchCopyWithImpl(this._self, this._then);

  final _Match _self;
  final $Res Function(_Match) _then;

/// Create a copy of Match
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? matchDay = null,Object? kickOffTime = null,Object? homeTeamId = null,Object? homeTeamName = null,Object? awayTeamId = null,Object? awayTeamName = null,Object? homeTeamGoals = null,Object? awayTeamGoals = null,Object? status = null,Object? season = null,}) {
  return _then(_Match(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matchDay: null == matchDay ? _self.matchDay : matchDay // ignore: cast_nullable_to_non_nullable
as String,kickOffTime: null == kickOffTime ? _self.kickOffTime : kickOffTime // ignore: cast_nullable_to_non_nullable
as int,homeTeamId: null == homeTeamId ? _self.homeTeamId : homeTeamId // ignore: cast_nullable_to_non_nullable
as String,homeTeamName: null == homeTeamName ? _self.homeTeamName : homeTeamName // ignore: cast_nullable_to_non_nullable
as String,awayTeamId: null == awayTeamId ? _self.awayTeamId : awayTeamId // ignore: cast_nullable_to_non_nullable
as String,awayTeamName: null == awayTeamName ? _self.awayTeamName : awayTeamName // ignore: cast_nullable_to_non_nullable
as String,homeTeamGoals: null == homeTeamGoals ? _self.homeTeamGoals : homeTeamGoals // ignore: cast_nullable_to_non_nullable
as int,awayTeamGoals: null == awayTeamGoals ? _self.awayTeamGoals : awayTeamGoals // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MatchData {

 String get id; String get playerId; String get playerName; String get matchId; String get opponent; int get position; int get goals; int get assists; int get cleanSheet; int get ownGoals; int get redCards; int get yellowCards; int get minutesPlayed; int get points; double get rating; DateTime get createdAt;
/// Create a copy of MatchData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchDataCopyWith<MatchData> get copyWith => _$MatchDataCopyWithImpl<MatchData>(this as MatchData, _$identity);

  /// Serializes this MatchData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatchData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchData&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.matchId, _this.matchId) || other.matchId == _this.matchId)&&(identical(other.opponent, _this.opponent) || other.opponent == _this.opponent)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.goals, _this.goals) || other.goals == _this.goals)&&(identical(other.assists, _this.assists) || other.assists == _this.assists)&&(identical(other.cleanSheet, _this.cleanSheet) || other.cleanSheet == _this.cleanSheet)&&(identical(other.ownGoals, _this.ownGoals) || other.ownGoals == _this.ownGoals)&&(identical(other.redCards, _this.redCards) || other.redCards == _this.redCards)&&(identical(other.yellowCards, _this.yellowCards) || other.yellowCards == _this.yellowCards)&&(identical(other.minutesPlayed, _this.minutesPlayed) || other.minutesPlayed == _this.minutesPlayed)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.rating, _this.rating) || other.rating == _this.rating)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatchData;
  return Object.hash(runtimeType,_this.id,_this.playerId,_this.playerName,_this.matchId,_this.opponent,_this.position,_this.goals,_this.assists,_this.cleanSheet,_this.ownGoals,_this.redCards,_this.yellowCards,_this.minutesPlayed,_this.points,_this.rating,_this.createdAt);
}

@override
String toString() {
  final _this = this as MatchData;
  return 'MatchData(id: ${_this.id}, playerId: ${_this.playerId}, playerName: ${_this.playerName}, matchId: ${_this.matchId}, opponent: ${_this.opponent}, position: ${_this.position}, goals: ${_this.goals}, assists: ${_this.assists}, cleanSheet: ${_this.cleanSheet}, ownGoals: ${_this.ownGoals}, redCards: ${_this.redCards}, yellowCards: ${_this.yellowCards}, minutesPlayed: ${_this.minutesPlayed}, points: ${_this.points}, rating: ${_this.rating}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $MatchDataCopyWith<$Res>  {
  factory $MatchDataCopyWith(MatchData value, $Res Function(MatchData) _then) = _$MatchDataCopyWithImpl;
@useResult
$Res call({
 String id, String playerId, String playerName, String matchId, String opponent, int position, int goals, int assists, int cleanSheet, int ownGoals, int redCards, int yellowCards, int minutesPlayed, int points, double rating, DateTime createdAt
});




}
/// @nodoc
class _$MatchDataCopyWithImpl<$Res>
    implements $MatchDataCopyWith<$Res> {
  _$MatchDataCopyWithImpl(this._self, this._then);

  final MatchData _self;
  final $Res Function(MatchData) _then;

/// Create a copy of MatchData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? matchId = null,Object? opponent = null,Object? position = null,Object? goals = null,Object? assists = null,Object? cleanSheet = null,Object? ownGoals = null,Object? redCards = null,Object? yellowCards = null,Object? minutesPlayed = null,Object? points = null,Object? rating = null,Object? createdAt = null,}) {
  return _then(MatchData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,opponent: null == opponent ? _self.opponent : opponent // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as int,assists: null == assists ? _self.assists : assists // ignore: cast_nullable_to_non_nullable
as int,cleanSheet: null == cleanSheet ? _self.cleanSheet : cleanSheet // ignore: cast_nullable_to_non_nullable
as int,ownGoals: null == ownGoals ? _self.ownGoals : ownGoals // ignore: cast_nullable_to_non_nullable
as int,redCards: null == redCards ? _self.redCards : redCards // ignore: cast_nullable_to_non_nullable
as int,yellowCards: null == yellowCards ? _self.yellowCards : yellowCards // ignore: cast_nullable_to_non_nullable
as int,minutesPlayed: null == minutesPlayed ? _self.minutesPlayed : minutesPlayed // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchData].
extension MatchDataPatterns on MatchData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchData value)  $default,){
final _that = this;
switch (_that) {
case _MatchData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchData value)?  $default,){
final _that = this;
switch (_that) {
case _MatchData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String playerId,  String playerName,  String matchId,  String opponent,  int position,  int goals,  int assists,  int cleanSheet,  int ownGoals,  int redCards,  int yellowCards,  int minutesPlayed,  int points,  double rating,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchData() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.matchId,_that.opponent,_that.position,_that.goals,_that.assists,_that.cleanSheet,_that.ownGoals,_that.redCards,_that.yellowCards,_that.minutesPlayed,_that.points,_that.rating,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String playerId,  String playerName,  String matchId,  String opponent,  int position,  int goals,  int assists,  int cleanSheet,  int ownGoals,  int redCards,  int yellowCards,  int minutesPlayed,  int points,  double rating,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MatchData():
return $default(_that.id,_that.playerId,_that.playerName,_that.matchId,_that.opponent,_that.position,_that.goals,_that.assists,_that.cleanSheet,_that.ownGoals,_that.redCards,_that.yellowCards,_that.minutesPlayed,_that.points,_that.rating,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String playerId,  String playerName,  String matchId,  String opponent,  int position,  int goals,  int assists,  int cleanSheet,  int ownGoals,  int redCards,  int yellowCards,  int minutesPlayed,  int points,  double rating,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MatchData() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.matchId,_that.opponent,_that.position,_that.goals,_that.assists,_that.cleanSheet,_that.ownGoals,_that.redCards,_that.yellowCards,_that.minutesPlayed,_that.points,_that.rating,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MatchData implements MatchData {
  const _MatchData({required this.id, required this.playerId, required this.playerName, required this.matchId, required this.opponent, required this.position, required this.goals, required this.assists, required this.cleanSheet, required this.ownGoals, required this.redCards, required this.yellowCards, required this.minutesPlayed, required this.points, required this.rating, required this.createdAt});
  factory _MatchData.fromJson(Map<String, dynamic> json) => _$MatchDataFromJson(json);

@override final  String id;
@override final  String playerId;
@override final  String playerName;
@override final  String matchId;
@override final  String opponent;
@override final  int position;
@override final  int goals;
@override final  int assists;
@override final  int cleanSheet;
@override final  int ownGoals;
@override final  int redCards;
@override final  int yellowCards;
@override final  int minutesPlayed;
@override final  int points;
@override final  double rating;
@override final  DateTime createdAt;

/// Create a copy of MatchData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchDataCopyWith<_MatchData> get copyWith => __$MatchDataCopyWithImpl<_MatchData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchData&&(identical(other.id, id) || other.id == id)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.opponent, opponent) || other.opponent == opponent)&&(identical(other.position, position) || other.position == position)&&(identical(other.goals, goals) || other.goals == goals)&&(identical(other.assists, assists) || other.assists == assists)&&(identical(other.cleanSheet, cleanSheet) || other.cleanSheet == cleanSheet)&&(identical(other.ownGoals, ownGoals) || other.ownGoals == ownGoals)&&(identical(other.redCards, redCards) || other.redCards == redCards)&&(identical(other.yellowCards, yellowCards) || other.yellowCards == yellowCards)&&(identical(other.minutesPlayed, minutesPlayed) || other.minutesPlayed == minutesPlayed)&&(identical(other.points, points) || other.points == points)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,playerId,playerName,matchId,opponent,position,goals,assists,cleanSheet,ownGoals,redCards,yellowCards,minutesPlayed,points,rating,createdAt);
}

@override
String toString() {
    return 'MatchData(id: $id, playerId: $playerId, playerName: $playerName, matchId: $matchId, opponent: $opponent, position: $position, goals: $goals, assists: $assists, cleanSheet: $cleanSheet, ownGoals: $ownGoals, redCards: $redCards, yellowCards: $yellowCards, minutesPlayed: $minutesPlayed, points: $points, rating: $rating, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MatchDataCopyWith<$Res> implements $MatchDataCopyWith<$Res> {
  factory _$MatchDataCopyWith(_MatchData value, $Res Function(_MatchData) _then) = __$MatchDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String playerId, String playerName, String matchId, String opponent, int position, int goals, int assists, int cleanSheet, int ownGoals, int redCards, int yellowCards, int minutesPlayed, int points, double rating, DateTime createdAt
});




}
/// @nodoc
class __$MatchDataCopyWithImpl<$Res>
    implements _$MatchDataCopyWith<$Res> {
  __$MatchDataCopyWithImpl(this._self, this._then);

  final _MatchData _self;
  final $Res Function(_MatchData) _then;

/// Create a copy of MatchData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? matchId = null,Object? opponent = null,Object? position = null,Object? goals = null,Object? assists = null,Object? cleanSheet = null,Object? ownGoals = null,Object? redCards = null,Object? yellowCards = null,Object? minutesPlayed = null,Object? points = null,Object? rating = null,Object? createdAt = null,}) {
  return _then(_MatchData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,opponent: null == opponent ? _self.opponent : opponent // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as int,assists: null == assists ? _self.assists : assists // ignore: cast_nullable_to_non_nullable
as int,cleanSheet: null == cleanSheet ? _self.cleanSheet : cleanSheet // ignore: cast_nullable_to_non_nullable
as int,ownGoals: null == ownGoals ? _self.ownGoals : ownGoals // ignore: cast_nullable_to_non_nullable
as int,redCards: null == redCards ? _self.redCards : redCards // ignore: cast_nullable_to_non_nullable
as int,yellowCards: null == yellowCards ? _self.yellowCards : yellowCards // ignore: cast_nullable_to_non_nullable
as int,minutesPlayed: null == minutesPlayed ? _self.minutesPlayed : minutesPlayed // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Highlight {

 String get id; String get playerId; String get playerName; String get matchId; String get description; String get highlightType; int get points; DateTime get timestamp;
/// Create a copy of Highlight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighlightCopyWith<Highlight> get copyWith => _$HighlightCopyWithImpl<Highlight>(this as Highlight, _$identity);

  /// Serializes this Highlight to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Highlight;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Highlight&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.matchId, _this.matchId) || other.matchId == _this.matchId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.highlightType, _this.highlightType) || other.highlightType == _this.highlightType)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Highlight;
  return Object.hash(runtimeType,_this.id,_this.playerId,_this.playerName,_this.matchId,_this.description,_this.highlightType,_this.points,_this.timestamp);
}

@override
String toString() {
  final _this = this as Highlight;
  return 'Highlight(id: ${_this.id}, playerId: ${_this.playerId}, playerName: ${_this.playerName}, matchId: ${_this.matchId}, description: ${_this.description}, highlightType: ${_this.highlightType}, points: ${_this.points}, timestamp: ${_this.timestamp})';
}


}

/// @nodoc
abstract mixin class $HighlightCopyWith<$Res>  {
  factory $HighlightCopyWith(Highlight value, $Res Function(Highlight) _then) = _$HighlightCopyWithImpl;
@useResult
$Res call({
 String id, String playerId, String playerName, String matchId, String description, String highlightType, int points, DateTime timestamp
});




}
/// @nodoc
class _$HighlightCopyWithImpl<$Res>
    implements $HighlightCopyWith<$Res> {
  _$HighlightCopyWithImpl(this._self, this._then);

  final Highlight _self;
  final $Res Function(Highlight) _then;

/// Create a copy of Highlight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? matchId = null,Object? description = null,Object? highlightType = null,Object? points = null,Object? timestamp = null,}) {
  return _then(Highlight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,highlightType: null == highlightType ? _self.highlightType : highlightType // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Highlight].
extension HighlightPatterns on Highlight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Highlight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Highlight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Highlight value)  $default,){
final _that = this;
switch (_that) {
case _Highlight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Highlight value)?  $default,){
final _that = this;
switch (_that) {
case _Highlight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String playerId,  String playerName,  String matchId,  String description,  String highlightType,  int points,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Highlight() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.matchId,_that.description,_that.highlightType,_that.points,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String playerId,  String playerName,  String matchId,  String description,  String highlightType,  int points,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _Highlight():
return $default(_that.id,_that.playerId,_that.playerName,_that.matchId,_that.description,_that.highlightType,_that.points,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String playerId,  String playerName,  String matchId,  String description,  String highlightType,  int points,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _Highlight() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.matchId,_that.description,_that.highlightType,_that.points,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Highlight implements Highlight {
  const _Highlight({required this.id, required this.playerId, required this.playerName, required this.matchId, required this.description, required this.highlightType, required this.points, required this.timestamp});
  factory _Highlight.fromJson(Map<String, dynamic> json) => _$HighlightFromJson(json);

@override final  String id;
@override final  String playerId;
@override final  String playerName;
@override final  String matchId;
@override final  String description;
@override final  String highlightType;
@override final  int points;
@override final  DateTime timestamp;

/// Create a copy of Highlight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HighlightCopyWith<_Highlight> get copyWith => __$HighlightCopyWithImpl<_Highlight>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HighlightToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Highlight&&(identical(other.id, id) || other.id == id)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.description, description) || other.description == description)&&(identical(other.highlightType, highlightType) || other.highlightType == highlightType)&&(identical(other.points, points) || other.points == points)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,playerId,playerName,matchId,description,highlightType,points,timestamp);
}

@override
String toString() {
    return 'Highlight(id: $id, playerId: $playerId, playerName: $playerName, matchId: $matchId, description: $description, highlightType: $highlightType, points: $points, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$HighlightCopyWith<$Res> implements $HighlightCopyWith<$Res> {
  factory _$HighlightCopyWith(_Highlight value, $Res Function(_Highlight) _then) = __$HighlightCopyWithImpl;
@override @useResult
$Res call({
 String id, String playerId, String playerName, String matchId, String description, String highlightType, int points, DateTime timestamp
});




}
/// @nodoc
class __$HighlightCopyWithImpl<$Res>
    implements _$HighlightCopyWith<$Res> {
  __$HighlightCopyWithImpl(this._self, this._then);

  final _Highlight _self;
  final $Res Function(_Highlight) _then;

/// Create a copy of Highlight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? matchId = null,Object? description = null,Object? highlightType = null,Object? points = null,Object? timestamp = null,}) {
  return _then(_Highlight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,highlightType: null == highlightType ? _self.highlightType : highlightType // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$MatchesResponse {

 List<Match> get matches; int? get totalCount;
/// Create a copy of MatchesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchesResponseCopyWith<MatchesResponse> get copyWith => _$MatchesResponseCopyWithImpl<MatchesResponse>(this as MatchesResponse, _$identity);

  /// Serializes this MatchesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatchesResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchesResponse&&const DeepCollectionEquality().equals(other.matches, _this.matches)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatchesResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.matches),_this.totalCount);
}

@override
String toString() {
  final _this = this as MatchesResponse;
  return 'MatchesResponse(matches: ${_this.matches}, totalCount: ${_this.totalCount})';
}


}

/// @nodoc
abstract mixin class $MatchesResponseCopyWith<$Res>  {
  factory $MatchesResponseCopyWith(MatchesResponse value, $Res Function(MatchesResponse) _then) = _$MatchesResponseCopyWithImpl;
@useResult
$Res call({
 List<Match> matches, int? totalCount
});




}
/// @nodoc
class _$MatchesResponseCopyWithImpl<$Res>
    implements $MatchesResponseCopyWith<$Res> {
  _$MatchesResponseCopyWithImpl(this._self, this._then);

  final MatchesResponse _self;
  final $Res Function(MatchesResponse) _then;

/// Create a copy of MatchesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matches = null,Object? totalCount = freezed,}) {
  return _then(MatchesResponse(
matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<Match>,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchesResponse].
extension MatchesResponsePatterns on MatchesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchesResponse value)  $default,){
final _that = this;
switch (_that) {
case _MatchesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MatchesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Match> matches,  int? totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchesResponse() when $default != null:
return $default(_that.matches,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Match> matches,  int? totalCount)  $default,) {final _that = this;
switch (_that) {
case _MatchesResponse():
return $default(_that.matches,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Match> matches,  int? totalCount)?  $default,) {final _that = this;
switch (_that) {
case _MatchesResponse() when $default != null:
return $default(_that.matches,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MatchesResponse implements MatchesResponse {
  const _MatchesResponse({required  List<Match> matches, this.totalCount}): _matches = matches;
  factory _MatchesResponse.fromJson(Map<String, dynamic> json) => _$MatchesResponseFromJson(json);

 final  List<Match> _matches;
@override List<Match> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}

@override final  int? totalCount;

/// Create a copy of MatchesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchesResponseCopyWith<_MatchesResponse> get copyWith => __$MatchesResponseCopyWithImpl<_MatchesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchesResponse&&const DeepCollectionEquality().equals(other.matches, _matches)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_matches),totalCount);
}

@override
String toString() {
    return 'MatchesResponse(matches: $matches, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$MatchesResponseCopyWith<$Res> implements $MatchesResponseCopyWith<$Res> {
  factory _$MatchesResponseCopyWith(_MatchesResponse value, $Res Function(_MatchesResponse) _then) = __$MatchesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Match> matches, int? totalCount
});




}
/// @nodoc
class __$MatchesResponseCopyWithImpl<$Res>
    implements _$MatchesResponseCopyWith<$Res> {
  __$MatchesResponseCopyWithImpl(this._self, this._then);

  final _MatchesResponse _self;
  final $Res Function(_MatchesResponse) _then;

/// Create a copy of MatchesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matches = null,Object? totalCount = freezed,}) {
  return _then(_MatchesResponse(
matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<Match>,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MatchDayInfo {

 String get matchDay; int get startTime; int get endTime; List<Match> get matches;
/// Create a copy of MatchDayInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchDayInfoCopyWith<MatchDayInfo> get copyWith => _$MatchDayInfoCopyWithImpl<MatchDayInfo>(this as MatchDayInfo, _$identity);

  /// Serializes this MatchDayInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatchDayInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchDayInfo&&(identical(other.matchDay, _this.matchDay) || other.matchDay == _this.matchDay)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&const DeepCollectionEquality().equals(other.matches, _this.matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatchDayInfo;
  return Object.hash(runtimeType,_this.matchDay,_this.startTime,_this.endTime,const DeepCollectionEquality().hash(_this.matches));
}

@override
String toString() {
  final _this = this as MatchDayInfo;
  return 'MatchDayInfo(matchDay: ${_this.matchDay}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, matches: ${_this.matches})';
}


}

/// @nodoc
abstract mixin class $MatchDayInfoCopyWith<$Res>  {
  factory $MatchDayInfoCopyWith(MatchDayInfo value, $Res Function(MatchDayInfo) _then) = _$MatchDayInfoCopyWithImpl;
@useResult
$Res call({
 String matchDay, int startTime, int endTime, List<Match> matches
});




}
/// @nodoc
class _$MatchDayInfoCopyWithImpl<$Res>
    implements $MatchDayInfoCopyWith<$Res> {
  _$MatchDayInfoCopyWithImpl(this._self, this._then);

  final MatchDayInfo _self;
  final $Res Function(MatchDayInfo) _then;

/// Create a copy of MatchDayInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchDay = null,Object? startTime = null,Object? endTime = null,Object? matches = null,}) {
  return _then(MatchDayInfo(
matchDay: null == matchDay ? _self.matchDay : matchDay // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<Match>,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchDayInfo].
extension MatchDayInfoPatterns on MatchDayInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchDayInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchDayInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchDayInfo value)  $default,){
final _that = this;
switch (_that) {
case _MatchDayInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchDayInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MatchDayInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String matchDay,  int startTime,  int endTime,  List<Match> matches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchDayInfo() when $default != null:
return $default(_that.matchDay,_that.startTime,_that.endTime,_that.matches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String matchDay,  int startTime,  int endTime,  List<Match> matches)  $default,) {final _that = this;
switch (_that) {
case _MatchDayInfo():
return $default(_that.matchDay,_that.startTime,_that.endTime,_that.matches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String matchDay,  int startTime,  int endTime,  List<Match> matches)?  $default,) {final _that = this;
switch (_that) {
case _MatchDayInfo() when $default != null:
return $default(_that.matchDay,_that.startTime,_that.endTime,_that.matches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchDayInfo implements MatchDayInfo {
  const _MatchDayInfo({required this.matchDay, required this.startTime, required this.endTime, required  List<Match> matches}): _matches = matches;
  factory _MatchDayInfo.fromJson(Map<String, dynamic> json) => _$MatchDayInfoFromJson(json);

@override final  String matchDay;
@override final  int startTime;
@override final  int endTime;
 final  List<Match> _matches;
@override List<Match> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}


/// Create a copy of MatchDayInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchDayInfoCopyWith<_MatchDayInfo> get copyWith => __$MatchDayInfoCopyWithImpl<_MatchDayInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchDayInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchDayInfo&&(identical(other.matchDay, matchDay) || other.matchDay == matchDay)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&const DeepCollectionEquality().equals(other.matches, _matches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,matchDay,startTime,endTime,const DeepCollectionEquality().hash(_matches));
}

@override
String toString() {
    return 'MatchDayInfo(matchDay: $matchDay, startTime: $startTime, endTime: $endTime, matches: $matches)';
}


}

/// @nodoc
abstract mixin class _$MatchDayInfoCopyWith<$Res> implements $MatchDayInfoCopyWith<$Res> {
  factory _$MatchDayInfoCopyWith(_MatchDayInfo value, $Res Function(_MatchDayInfo) _then) = __$MatchDayInfoCopyWithImpl;
@override @useResult
$Res call({
 String matchDay, int startTime, int endTime, List<Match> matches
});




}
/// @nodoc
class __$MatchDayInfoCopyWithImpl<$Res>
    implements _$MatchDayInfoCopyWith<$Res> {
  __$MatchDayInfoCopyWithImpl(this._self, this._then);

  final _MatchDayInfo _self;
  final $Res Function(_MatchDayInfo) _then;

/// Create a copy of MatchDayInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchDay = null,Object? startTime = null,Object? endTime = null,Object? matches = null,}) {
  return _then(_MatchDayInfo(
matchDay: null == matchDay ? _self.matchDay : matchDay // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as int,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as int,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<Match>,
  ));
}


}

// dart format on
