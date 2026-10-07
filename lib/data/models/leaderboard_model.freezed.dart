// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardEntry {

 String get leagueId; String get userId; String get username; int get rank; int get totalPoints; int get gamesPlayed; double get averagePoints; int get wins; int get draws; int get losses; DateTime get lastUpdated;
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith => _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(this as LeaderboardEntry, _$identity);

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntry&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.gamesPlayed, _this.gamesPlayed) || other.gamesPlayed == _this.gamesPlayed)&&(identical(other.averagePoints, _this.averagePoints) || other.averagePoints == _this.averagePoints)&&(identical(other.wins, _this.wins) || other.wins == _this.wins)&&(identical(other.draws, _this.draws) || other.draws == _this.draws)&&(identical(other.losses, _this.losses) || other.losses == _this.losses)&&(identical(other.lastUpdated, _this.lastUpdated) || other.lastUpdated == _this.lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardEntry;
  return Object.hash(runtimeType,_this.leagueId,_this.userId,_this.username,_this.rank,_this.totalPoints,_this.gamesPlayed,_this.averagePoints,_this.wins,_this.draws,_this.losses,_this.lastUpdated);
}

@override
String toString() {
  final _this = this as LeaderboardEntry;
  return 'LeaderboardEntry(leagueId: ${_this.leagueId}, userId: ${_this.userId}, username: ${_this.username}, rank: ${_this.rank}, totalPoints: ${_this.totalPoints}, gamesPlayed: ${_this.gamesPlayed}, averagePoints: ${_this.averagePoints}, wins: ${_this.wins}, draws: ${_this.draws}, losses: ${_this.losses}, lastUpdated: ${_this.lastUpdated})';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res>  {
  factory $LeaderboardEntryCopyWith(LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) = _$LeaderboardEntryCopyWithImpl;
@useResult
$Res call({
 String leagueId, String userId, String username, int rank, int totalPoints, int gamesPlayed, double averagePoints, int wins, int draws, int losses, DateTime lastUpdated
});




}
/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueId = null,Object? userId = null,Object? username = null,Object? rank = null,Object? totalPoints = null,Object? gamesPlayed = null,Object? averagePoints = null,Object? wins = null,Object? draws = null,Object? losses = null,Object? lastUpdated = null,}) {
  return _then(LeaderboardEntry(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,gamesPlayed: null == gamesPlayed ? _self.gamesPlayed : gamesPlayed // ignore: cast_nullable_to_non_nullable
as int,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String leagueId,  String userId,  String username,  int rank,  int totalPoints,  int gamesPlayed,  double averagePoints,  int wins,  int draws,  int losses,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.leagueId,_that.userId,_that.username,_that.rank,_that.totalPoints,_that.gamesPlayed,_that.averagePoints,_that.wins,_that.draws,_that.losses,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String leagueId,  String userId,  String username,  int rank,  int totalPoints,  int gamesPlayed,  double averagePoints,  int wins,  int draws,  int losses,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry():
return $default(_that.leagueId,_that.userId,_that.username,_that.rank,_that.totalPoints,_that.gamesPlayed,_that.averagePoints,_that.wins,_that.draws,_that.losses,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String leagueId,  String userId,  String username,  int rank,  int totalPoints,  int gamesPlayed,  double averagePoints,  int wins,  int draws,  int losses,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.leagueId,_that.userId,_that.username,_that.rank,_that.totalPoints,_that.gamesPlayed,_that.averagePoints,_that.wins,_that.draws,_that.losses,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _LeaderboardEntry implements LeaderboardEntry {
  const _LeaderboardEntry({required this.leagueId, required this.userId, required this.username, required this.rank, required this.totalPoints, required this.gamesPlayed, required this.averagePoints, required this.wins, required this.draws, required this.losses, required this.lastUpdated});
  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryFromJson(json);

@override final  String leagueId;
@override final  String userId;
@override final  String username;
@override final  int rank;
@override final  int totalPoints;
@override final  int gamesPlayed;
@override final  double averagePoints;
@override final  int wins;
@override final  int draws;
@override final  int losses;
@override final  DateTime lastUpdated;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith => __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntry&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.gamesPlayed, gamesPlayed) || other.gamesPlayed == gamesPlayed)&&(identical(other.averagePoints, averagePoints) || other.averagePoints == averagePoints)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.draws, draws) || other.draws == draws)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leagueId,userId,username,rank,totalPoints,gamesPlayed,averagePoints,wins,draws,losses,lastUpdated);
}

@override
String toString() {
    return 'LeaderboardEntry(leagueId: $leagueId, userId: $userId, username: $username, rank: $rank, totalPoints: $totalPoints, gamesPlayed: $gamesPlayed, averagePoints: $averagePoints, wins: $wins, draws: $draws, losses: $losses, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res> implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(_LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) = __$LeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
 String leagueId, String userId, String username, int rank, int totalPoints, int gamesPlayed, double averagePoints, int wins, int draws, int losses, DateTime lastUpdated
});




}
/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueId = null,Object? userId = null,Object? username = null,Object? rank = null,Object? totalPoints = null,Object? gamesPlayed = null,Object? averagePoints = null,Object? wins = null,Object? draws = null,Object? losses = null,Object? lastUpdated = null,}) {
  return _then(_LeaderboardEntry(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,gamesPlayed: null == gamesPlayed ? _self.gamesPlayed : gamesPlayed // ignore: cast_nullable_to_non_nullable
as int,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Ranking {

 String get leagueId; String get leagueName; List<LeaderboardEntry> get entries; int get totalParticipants; String? get updateFrequency; DateTime get lastUpdated;
/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingCopyWith<Ranking> get copyWith => _$RankingCopyWithImpl<Ranking>(this as Ranking, _$identity);

  /// Serializes this Ranking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Ranking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ranking&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.leagueName, _this.leagueName) || other.leagueName == _this.leagueName)&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.totalParticipants, _this.totalParticipants) || other.totalParticipants == _this.totalParticipants)&&(identical(other.updateFrequency, _this.updateFrequency) || other.updateFrequency == _this.updateFrequency)&&(identical(other.lastUpdated, _this.lastUpdated) || other.lastUpdated == _this.lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Ranking;
  return Object.hash(runtimeType,_this.leagueId,_this.leagueName,const DeepCollectionEquality().hash(_this.entries),_this.totalParticipants,_this.updateFrequency,_this.lastUpdated);
}

@override
String toString() {
  final _this = this as Ranking;
  return 'Ranking(leagueId: ${_this.leagueId}, leagueName: ${_this.leagueName}, entries: ${_this.entries}, totalParticipants: ${_this.totalParticipants}, updateFrequency: ${_this.updateFrequency}, lastUpdated: ${_this.lastUpdated})';
}


}

/// @nodoc
abstract mixin class $RankingCopyWith<$Res>  {
  factory $RankingCopyWith(Ranking value, $Res Function(Ranking) _then) = _$RankingCopyWithImpl;
@useResult
$Res call({
 String leagueId, String leagueName, List<LeaderboardEntry> entries, int totalParticipants, String? updateFrequency, DateTime lastUpdated
});




}
/// @nodoc
class _$RankingCopyWithImpl<$Res>
    implements $RankingCopyWith<$Res> {
  _$RankingCopyWithImpl(this._self, this._then);

  final Ranking _self;
  final $Res Function(Ranking) _then;

/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueId = null,Object? leagueName = null,Object? entries = null,Object? totalParticipants = null,Object? updateFrequency = freezed,Object? lastUpdated = null,}) {
  return _then(Ranking(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,updateFrequency: freezed == updateFrequency ? _self.updateFrequency : updateFrequency // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Ranking].
extension RankingPatterns on Ranking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ranking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ranking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ranking value)  $default,){
final _that = this;
switch (_that) {
case _Ranking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ranking value)?  $default,){
final _that = this;
switch (_that) {
case _Ranking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String leagueId,  String leagueName,  List<LeaderboardEntry> entries,  int totalParticipants,  String? updateFrequency,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ranking() when $default != null:
return $default(_that.leagueId,_that.leagueName,_that.entries,_that.totalParticipants,_that.updateFrequency,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String leagueId,  String leagueName,  List<LeaderboardEntry> entries,  int totalParticipants,  String? updateFrequency,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _Ranking():
return $default(_that.leagueId,_that.leagueName,_that.entries,_that.totalParticipants,_that.updateFrequency,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String leagueId,  String leagueName,  List<LeaderboardEntry> entries,  int totalParticipants,  String? updateFrequency,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _Ranking() when $default != null:
return $default(_that.leagueId,_that.leagueName,_that.entries,_that.totalParticipants,_that.updateFrequency,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Ranking implements Ranking {
  const _Ranking({required this.leagueId, required this.leagueName, required  List<LeaderboardEntry> entries, required this.totalParticipants, this.updateFrequency, required this.lastUpdated}): _entries = entries;
  factory _Ranking.fromJson(Map<String, dynamic> json) => _$RankingFromJson(json);

@override final  String leagueId;
@override final  String leagueName;
 final  List<LeaderboardEntry> _entries;
@override List<LeaderboardEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override final  int totalParticipants;
@override final  String? updateFrequency;
@override final  DateTime lastUpdated;

/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingCopyWith<_Ranking> get copyWith => __$RankingCopyWithImpl<_Ranking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ranking&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.leagueName, leagueName) || other.leagueName == leagueName)&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&(identical(other.updateFrequency, updateFrequency) || other.updateFrequency == updateFrequency)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leagueId,leagueName,const DeepCollectionEquality().hash(_entries),totalParticipants,updateFrequency,lastUpdated);
}

@override
String toString() {
    return 'Ranking(leagueId: $leagueId, leagueName: $leagueName, entries: $entries, totalParticipants: $totalParticipants, updateFrequency: $updateFrequency, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$RankingCopyWith<$Res> implements $RankingCopyWith<$Res> {
  factory _$RankingCopyWith(_Ranking value, $Res Function(_Ranking) _then) = __$RankingCopyWithImpl;
@override @useResult
$Res call({
 String leagueId, String leagueName, List<LeaderboardEntry> entries, int totalParticipants, String? updateFrequency, DateTime lastUpdated
});




}
/// @nodoc
class __$RankingCopyWithImpl<$Res>
    implements _$RankingCopyWith<$Res> {
  __$RankingCopyWithImpl(this._self, this._then);

  final _Ranking _self;
  final $Res Function(_Ranking) _then;

/// Create a copy of Ranking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueId = null,Object? leagueName = null,Object? entries = null,Object? totalParticipants = null,Object? updateFrequency = freezed,Object? lastUpdated = null,}) {
  return _then(_Ranking(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,updateFrequency: freezed == updateFrequency ? _self.updateFrequency : updateFrequency // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UserRanking {

 String get userId; String get username; int get totalPoints; int get rank; int? get pointsBehindLeader; int? get pointsAheadNext; int get gamesPlayed; String get trend;
/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRankingCopyWith<UserRanking> get copyWith => _$UserRankingCopyWithImpl<UserRanking>(this as UserRanking, _$identity);

  /// Serializes this UserRanking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserRanking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRanking&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.pointsBehindLeader, _this.pointsBehindLeader) || other.pointsBehindLeader == _this.pointsBehindLeader)&&(identical(other.pointsAheadNext, _this.pointsAheadNext) || other.pointsAheadNext == _this.pointsAheadNext)&&(identical(other.gamesPlayed, _this.gamesPlayed) || other.gamesPlayed == _this.gamesPlayed)&&(identical(other.trend, _this.trend) || other.trend == _this.trend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserRanking;
  return Object.hash(runtimeType,_this.userId,_this.username,_this.totalPoints,_this.rank,_this.pointsBehindLeader,_this.pointsAheadNext,_this.gamesPlayed,_this.trend);
}

@override
String toString() {
  final _this = this as UserRanking;
  return 'UserRanking(userId: ${_this.userId}, username: ${_this.username}, totalPoints: ${_this.totalPoints}, rank: ${_this.rank}, pointsBehindLeader: ${_this.pointsBehindLeader}, pointsAheadNext: ${_this.pointsAheadNext}, gamesPlayed: ${_this.gamesPlayed}, trend: ${_this.trend})';
}


}

/// @nodoc
abstract mixin class $UserRankingCopyWith<$Res>  {
  factory $UserRankingCopyWith(UserRanking value, $Res Function(UserRanking) _then) = _$UserRankingCopyWithImpl;
@useResult
$Res call({
 String userId, String username, int totalPoints, int rank, int? pointsBehindLeader, int? pointsAheadNext, int gamesPlayed, String trend
});




}
/// @nodoc
class _$UserRankingCopyWithImpl<$Res>
    implements $UserRankingCopyWith<$Res> {
  _$UserRankingCopyWithImpl(this._self, this._then);

  final UserRanking _self;
  final $Res Function(UserRanking) _then;

/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? totalPoints = null,Object? rank = null,Object? pointsBehindLeader = freezed,Object? pointsAheadNext = freezed,Object? gamesPlayed = null,Object? trend = null,}) {
  return _then(UserRanking(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,pointsBehindLeader: freezed == pointsBehindLeader ? _self.pointsBehindLeader : pointsBehindLeader // ignore: cast_nullable_to_non_nullable
as int?,pointsAheadNext: freezed == pointsAheadNext ? _self.pointsAheadNext : pointsAheadNext // ignore: cast_nullable_to_non_nullable
as int?,gamesPlayed: null == gamesPlayed ? _self.gamesPlayed : gamesPlayed // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRanking].
extension UserRankingPatterns on UserRanking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRanking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRanking value)  $default,){
final _that = this;
switch (_that) {
case _UserRanking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRanking value)?  $default,){
final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String username,  int totalPoints,  int rank,  int? pointsBehindLeader,  int? pointsAheadNext,  int gamesPlayed,  String trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
return $default(_that.userId,_that.username,_that.totalPoints,_that.rank,_that.pointsBehindLeader,_that.pointsAheadNext,_that.gamesPlayed,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String username,  int totalPoints,  int rank,  int? pointsBehindLeader,  int? pointsAheadNext,  int gamesPlayed,  String trend)  $default,) {final _that = this;
switch (_that) {
case _UserRanking():
return $default(_that.userId,_that.username,_that.totalPoints,_that.rank,_that.pointsBehindLeader,_that.pointsAheadNext,_that.gamesPlayed,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String username,  int totalPoints,  int rank,  int? pointsBehindLeader,  int? pointsAheadNext,  int gamesPlayed,  String trend)?  $default,) {final _that = this;
switch (_that) {
case _UserRanking() when $default != null:
return $default(_that.userId,_that.username,_that.totalPoints,_that.rank,_that.pointsBehindLeader,_that.pointsAheadNext,_that.gamesPlayed,_that.trend);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserRanking implements UserRanking {
  const _UserRanking({required this.userId, required this.username, required this.totalPoints, required this.rank, this.pointsBehindLeader, this.pointsAheadNext, required this.gamesPlayed, required this.trend});
  factory _UserRanking.fromJson(Map<String, dynamic> json) => _$UserRankingFromJson(json);

@override final  String userId;
@override final  String username;
@override final  int totalPoints;
@override final  int rank;
@override final  int? pointsBehindLeader;
@override final  int? pointsAheadNext;
@override final  int gamesPlayed;
@override final  String trend;

/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRankingCopyWith<_UserRanking> get copyWith => __$UserRankingCopyWithImpl<_UserRanking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRankingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRanking&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.pointsBehindLeader, pointsBehindLeader) || other.pointsBehindLeader == pointsBehindLeader)&&(identical(other.pointsAheadNext, pointsAheadNext) || other.pointsAheadNext == pointsAheadNext)&&(identical(other.gamesPlayed, gamesPlayed) || other.gamesPlayed == gamesPlayed)&&(identical(other.trend, trend) || other.trend == trend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,username,totalPoints,rank,pointsBehindLeader,pointsAheadNext,gamesPlayed,trend);
}

@override
String toString() {
    return 'UserRanking(userId: $userId, username: $username, totalPoints: $totalPoints, rank: $rank, pointsBehindLeader: $pointsBehindLeader, pointsAheadNext: $pointsAheadNext, gamesPlayed: $gamesPlayed, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$UserRankingCopyWith<$Res> implements $UserRankingCopyWith<$Res> {
  factory _$UserRankingCopyWith(_UserRanking value, $Res Function(_UserRanking) _then) = __$UserRankingCopyWithImpl;
@override @useResult
$Res call({
 String userId, String username, int totalPoints, int rank, int? pointsBehindLeader, int? pointsAheadNext, int gamesPlayed, String trend
});




}
/// @nodoc
class __$UserRankingCopyWithImpl<$Res>
    implements _$UserRankingCopyWith<$Res> {
  __$UserRankingCopyWithImpl(this._self, this._then);

  final _UserRanking _self;
  final $Res Function(_UserRanking) _then;

/// Create a copy of UserRanking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? totalPoints = null,Object? rank = null,Object? pointsBehindLeader = freezed,Object? pointsAheadNext = freezed,Object? gamesPlayed = null,Object? trend = null,}) {
  return _then(_UserRanking(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,pointsBehindLeader: freezed == pointsBehindLeader ? _self.pointsBehindLeader : pointsBehindLeader // ignore: cast_nullable_to_non_nullable
as int?,pointsAheadNext: freezed == pointsAheadNext ? _self.pointsAheadNext : pointsAheadNext // ignore: cast_nullable_to_non_nullable
as int?,gamesPlayed: null == gamesPlayed ? _self.gamesPlayed : gamesPlayed // ignore: cast_nullable_to_non_nullable
as int,trend: null == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LeagueStandings {

 String get leagueId; String get leagueName; List<LeaderboardEntry> get standings; int get matchdayNumber; DateTime get createdAt;
/// Create a copy of LeagueStandings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeagueStandingsCopyWith<LeagueStandings> get copyWith => _$LeagueStandingsCopyWithImpl<LeagueStandings>(this as LeagueStandings, _$identity);

  /// Serializes this LeagueStandings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeagueStandings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeagueStandings&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.leagueName, _this.leagueName) || other.leagueName == _this.leagueName)&&const DeepCollectionEquality().equals(other.standings, _this.standings)&&(identical(other.matchdayNumber, _this.matchdayNumber) || other.matchdayNumber == _this.matchdayNumber)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeagueStandings;
  return Object.hash(runtimeType,_this.leagueId,_this.leagueName,const DeepCollectionEquality().hash(_this.standings),_this.matchdayNumber,_this.createdAt);
}

@override
String toString() {
  final _this = this as LeagueStandings;
  return 'LeagueStandings(leagueId: ${_this.leagueId}, leagueName: ${_this.leagueName}, standings: ${_this.standings}, matchdayNumber: ${_this.matchdayNumber}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $LeagueStandingsCopyWith<$Res>  {
  factory $LeagueStandingsCopyWith(LeagueStandings value, $Res Function(LeagueStandings) _then) = _$LeagueStandingsCopyWithImpl;
@useResult
$Res call({
 String leagueId, String leagueName, List<LeaderboardEntry> standings, int matchdayNumber, DateTime createdAt
});




}
/// @nodoc
class _$LeagueStandingsCopyWithImpl<$Res>
    implements $LeagueStandingsCopyWith<$Res> {
  _$LeagueStandingsCopyWithImpl(this._self, this._then);

  final LeagueStandings _self;
  final $Res Function(LeagueStandings) _then;

/// Create a copy of LeagueStandings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueId = null,Object? leagueName = null,Object? standings = null,Object? matchdayNumber = null,Object? createdAt = null,}) {
  return _then(LeagueStandings(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,standings: null == standings ? _self.standings : standings // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,matchdayNumber: null == matchdayNumber ? _self.matchdayNumber : matchdayNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LeagueStandings].
extension LeagueStandingsPatterns on LeagueStandings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeagueStandings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeagueStandings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeagueStandings value)  $default,){
final _that = this;
switch (_that) {
case _LeagueStandings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeagueStandings value)?  $default,){
final _that = this;
switch (_that) {
case _LeagueStandings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String leagueId,  String leagueName,  List<LeaderboardEntry> standings,  int matchdayNumber,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeagueStandings() when $default != null:
return $default(_that.leagueId,_that.leagueName,_that.standings,_that.matchdayNumber,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String leagueId,  String leagueName,  List<LeaderboardEntry> standings,  int matchdayNumber,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _LeagueStandings():
return $default(_that.leagueId,_that.leagueName,_that.standings,_that.matchdayNumber,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String leagueId,  String leagueName,  List<LeaderboardEntry> standings,  int matchdayNumber,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LeagueStandings() when $default != null:
return $default(_that.leagueId,_that.leagueName,_that.standings,_that.matchdayNumber,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeagueStandings implements LeagueStandings {
  const _LeagueStandings({required this.leagueId, required this.leagueName, required  List<LeaderboardEntry> standings, required this.matchdayNumber, required this.createdAt}): _standings = standings;
  factory _LeagueStandings.fromJson(Map<String, dynamic> json) => _$LeagueStandingsFromJson(json);

@override final  String leagueId;
@override final  String leagueName;
 final  List<LeaderboardEntry> _standings;
@override List<LeaderboardEntry> get standings {
  if (_standings is EqualUnmodifiableListView) return _standings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_standings);
}

@override final  int matchdayNumber;
@override final  DateTime createdAt;

/// Create a copy of LeagueStandings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeagueStandingsCopyWith<_LeagueStandings> get copyWith => __$LeagueStandingsCopyWithImpl<_LeagueStandings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeagueStandingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeagueStandings&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.leagueName, leagueName) || other.leagueName == leagueName)&&const DeepCollectionEquality().equals(other.standings, _standings)&&(identical(other.matchdayNumber, matchdayNumber) || other.matchdayNumber == matchdayNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leagueId,leagueName,const DeepCollectionEquality().hash(_standings),matchdayNumber,createdAt);
}

@override
String toString() {
    return 'LeagueStandings(leagueId: $leagueId, leagueName: $leagueName, standings: $standings, matchdayNumber: $matchdayNumber, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LeagueStandingsCopyWith<$Res> implements $LeagueStandingsCopyWith<$Res> {
  factory _$LeagueStandingsCopyWith(_LeagueStandings value, $Res Function(_LeagueStandings) _then) = __$LeagueStandingsCopyWithImpl;
@override @useResult
$Res call({
 String leagueId, String leagueName, List<LeaderboardEntry> standings, int matchdayNumber, DateTime createdAt
});




}
/// @nodoc
class __$LeagueStandingsCopyWithImpl<$Res>
    implements _$LeagueStandingsCopyWith<$Res> {
  __$LeagueStandingsCopyWithImpl(this._self, this._then);

  final _LeagueStandings _self;
  final $Res Function(_LeagueStandings) _then;

/// Create a copy of LeagueStandings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueId = null,Object? leagueName = null,Object? standings = null,Object? matchdayNumber = null,Object? createdAt = null,}) {
  return _then(_LeagueStandings(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,leagueName: null == leagueName ? _self.leagueName : leagueName // ignore: cast_nullable_to_non_nullable
as String,standings: null == standings ? _self._standings : standings // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,matchdayNumber: null == matchdayNumber ? _self.matchdayNumber : matchdayNumber // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$HistoricalRanking {

 String get leagueId; int get matchday; List<LeaderboardEntry> get standings; DateTime get recordedAt;
/// Create a copy of HistoricalRanking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoricalRankingCopyWith<HistoricalRanking> get copyWith => _$HistoricalRankingCopyWithImpl<HistoricalRanking>(this as HistoricalRanking, _$identity);

  /// Serializes this HistoricalRanking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HistoricalRanking;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoricalRanking&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.matchday, _this.matchday) || other.matchday == _this.matchday)&&const DeepCollectionEquality().equals(other.standings, _this.standings)&&(identical(other.recordedAt, _this.recordedAt) || other.recordedAt == _this.recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HistoricalRanking;
  return Object.hash(runtimeType,_this.leagueId,_this.matchday,const DeepCollectionEquality().hash(_this.standings),_this.recordedAt);
}

@override
String toString() {
  final _this = this as HistoricalRanking;
  return 'HistoricalRanking(leagueId: ${_this.leagueId}, matchday: ${_this.matchday}, standings: ${_this.standings}, recordedAt: ${_this.recordedAt})';
}


}

/// @nodoc
abstract mixin class $HistoricalRankingCopyWith<$Res>  {
  factory $HistoricalRankingCopyWith(HistoricalRanking value, $Res Function(HistoricalRanking) _then) = _$HistoricalRankingCopyWithImpl;
@useResult
$Res call({
 String leagueId, int matchday, List<LeaderboardEntry> standings, DateTime recordedAt
});




}
/// @nodoc
class _$HistoricalRankingCopyWithImpl<$Res>
    implements $HistoricalRankingCopyWith<$Res> {
  _$HistoricalRankingCopyWithImpl(this._self, this._then);

  final HistoricalRanking _self;
  final $Res Function(HistoricalRanking) _then;

/// Create a copy of HistoricalRanking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leagueId = null,Object? matchday = null,Object? standings = null,Object? recordedAt = null,}) {
  return _then(HistoricalRanking(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,standings: null == standings ? _self.standings : standings // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoricalRanking].
extension HistoricalRankingPatterns on HistoricalRanking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoricalRanking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoricalRanking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoricalRanking value)  $default,){
final _that = this;
switch (_that) {
case _HistoricalRanking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoricalRanking value)?  $default,){
final _that = this;
switch (_that) {
case _HistoricalRanking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String leagueId,  int matchday,  List<LeaderboardEntry> standings,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoricalRanking() when $default != null:
return $default(_that.leagueId,_that.matchday,_that.standings,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String leagueId,  int matchday,  List<LeaderboardEntry> standings,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _HistoricalRanking():
return $default(_that.leagueId,_that.matchday,_that.standings,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String leagueId,  int matchday,  List<LeaderboardEntry> standings,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _HistoricalRanking() when $default != null:
return $default(_that.leagueId,_that.matchday,_that.standings,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoricalRanking implements HistoricalRanking {
  const _HistoricalRanking({required this.leagueId, required this.matchday, required  List<LeaderboardEntry> standings, required this.recordedAt}): _standings = standings;
  factory _HistoricalRanking.fromJson(Map<String, dynamic> json) => _$HistoricalRankingFromJson(json);

@override final  String leagueId;
@override final  int matchday;
 final  List<LeaderboardEntry> _standings;
@override List<LeaderboardEntry> get standings {
  if (_standings is EqualUnmodifiableListView) return _standings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_standings);
}

@override final  DateTime recordedAt;

/// Create a copy of HistoricalRanking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoricalRankingCopyWith<_HistoricalRanking> get copyWith => __$HistoricalRankingCopyWithImpl<_HistoricalRanking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoricalRankingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoricalRanking&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.matchday, matchday) || other.matchday == matchday)&&const DeepCollectionEquality().equals(other.standings, _standings)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,leagueId,matchday,const DeepCollectionEquality().hash(_standings),recordedAt);
}

@override
String toString() {
    return 'HistoricalRanking(leagueId: $leagueId, matchday: $matchday, standings: $standings, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$HistoricalRankingCopyWith<$Res> implements $HistoricalRankingCopyWith<$Res> {
  factory _$HistoricalRankingCopyWith(_HistoricalRanking value, $Res Function(_HistoricalRanking) _then) = __$HistoricalRankingCopyWithImpl;
@override @useResult
$Res call({
 String leagueId, int matchday, List<LeaderboardEntry> standings, DateTime recordedAt
});




}
/// @nodoc
class __$HistoricalRankingCopyWithImpl<$Res>
    implements _$HistoricalRankingCopyWith<$Res> {
  __$HistoricalRankingCopyWithImpl(this._self, this._then);

  final _HistoricalRanking _self;
  final $Res Function(_HistoricalRanking) _then;

/// Create a copy of HistoricalRanking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leagueId = null,Object? matchday = null,Object? standings = null,Object? recordedAt = null,}) {
  return _then(_HistoricalRanking(
leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,standings: null == standings ? _self._standings : standings // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RankingChange {

 String get userId; String get username; int get previousRank; int get currentRank; int get pointsChange; DateTime get timestamp;
/// Create a copy of RankingChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingChangeCopyWith<RankingChange> get copyWith => _$RankingChangeCopyWithImpl<RankingChange>(this as RankingChange, _$identity);

  /// Serializes this RankingChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RankingChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingChange&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.previousRank, _this.previousRank) || other.previousRank == _this.previousRank)&&(identical(other.currentRank, _this.currentRank) || other.currentRank == _this.currentRank)&&(identical(other.pointsChange, _this.pointsChange) || other.pointsChange == _this.pointsChange)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RankingChange;
  return Object.hash(runtimeType,_this.userId,_this.username,_this.previousRank,_this.currentRank,_this.pointsChange,_this.timestamp);
}

@override
String toString() {
  final _this = this as RankingChange;
  return 'RankingChange(userId: ${_this.userId}, username: ${_this.username}, previousRank: ${_this.previousRank}, currentRank: ${_this.currentRank}, pointsChange: ${_this.pointsChange}, timestamp: ${_this.timestamp})';
}


}

/// @nodoc
abstract mixin class $RankingChangeCopyWith<$Res>  {
  factory $RankingChangeCopyWith(RankingChange value, $Res Function(RankingChange) _then) = _$RankingChangeCopyWithImpl;
@useResult
$Res call({
 String userId, String username, int previousRank, int currentRank, int pointsChange, DateTime timestamp
});




}
/// @nodoc
class _$RankingChangeCopyWithImpl<$Res>
    implements $RankingChangeCopyWith<$Res> {
  _$RankingChangeCopyWithImpl(this._self, this._then);

  final RankingChange _self;
  final $Res Function(RankingChange) _then;

/// Create a copy of RankingChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? previousRank = null,Object? currentRank = null,Object? pointsChange = null,Object? timestamp = null,}) {
  return _then(RankingChange(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,previousRank: null == previousRank ? _self.previousRank : previousRank // ignore: cast_nullable_to_non_nullable
as int,currentRank: null == currentRank ? _self.currentRank : currentRank // ignore: cast_nullable_to_non_nullable
as int,pointsChange: null == pointsChange ? _self.pointsChange : pointsChange // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingChange].
extension RankingChangePatterns on RankingChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingChange value)  $default,){
final _that = this;
switch (_that) {
case _RankingChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingChange value)?  $default,){
final _that = this;
switch (_that) {
case _RankingChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String username,  int previousRank,  int currentRank,  int pointsChange,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingChange() when $default != null:
return $default(_that.userId,_that.username,_that.previousRank,_that.currentRank,_that.pointsChange,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String username,  int previousRank,  int currentRank,  int pointsChange,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _RankingChange():
return $default(_that.userId,_that.username,_that.previousRank,_that.currentRank,_that.pointsChange,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String username,  int previousRank,  int currentRank,  int pointsChange,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _RankingChange() when $default != null:
return $default(_that.userId,_that.username,_that.previousRank,_that.currentRank,_that.pointsChange,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingChange implements RankingChange {
  const _RankingChange({required this.userId, required this.username, required this.previousRank, required this.currentRank, required this.pointsChange, required this.timestamp});
  factory _RankingChange.fromJson(Map<String, dynamic> json) => _$RankingChangeFromJson(json);

@override final  String userId;
@override final  String username;
@override final  int previousRank;
@override final  int currentRank;
@override final  int pointsChange;
@override final  DateTime timestamp;

/// Create a copy of RankingChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingChangeCopyWith<_RankingChange> get copyWith => __$RankingChangeCopyWithImpl<_RankingChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingChangeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingChange&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.previousRank, previousRank) || other.previousRank == previousRank)&&(identical(other.currentRank, currentRank) || other.currentRank == currentRank)&&(identical(other.pointsChange, pointsChange) || other.pointsChange == pointsChange)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,username,previousRank,currentRank,pointsChange,timestamp);
}

@override
String toString() {
    return 'RankingChange(userId: $userId, username: $username, previousRank: $previousRank, currentRank: $currentRank, pointsChange: $pointsChange, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$RankingChangeCopyWith<$Res> implements $RankingChangeCopyWith<$Res> {
  factory _$RankingChangeCopyWith(_RankingChange value, $Res Function(_RankingChange) _then) = __$RankingChangeCopyWithImpl;
@override @useResult
$Res call({
 String userId, String username, int previousRank, int currentRank, int pointsChange, DateTime timestamp
});




}
/// @nodoc
class __$RankingChangeCopyWithImpl<$Res>
    implements _$RankingChangeCopyWith<$Res> {
  __$RankingChangeCopyWithImpl(this._self, this._then);

  final _RankingChange _self;
  final $Res Function(_RankingChange) _then;

/// Create a copy of RankingChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? previousRank = null,Object? currentRank = null,Object? pointsChange = null,Object? timestamp = null,}) {
  return _then(_RankingChange(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,previousRank: null == previousRank ? _self.previousRank : previousRank // ignore: cast_nullable_to_non_nullable
as int,currentRank: null == currentRank ? _self.currentRank : currentRank // ignore: cast_nullable_to_non_nullable
as int,pointsChange: null == pointsChange ? _self.pointsChange : pointsChange // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
