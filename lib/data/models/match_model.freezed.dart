// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get matchDay => throw _privateConstructorUsedError;
  int get kickOffTime => throw _privateConstructorUsedError;
  String get homeTeamId => throw _privateConstructorUsedError;
  String get homeTeamName => throw _privateConstructorUsedError;
  String get awayTeamId => throw _privateConstructorUsedError;
  String get awayTeamName => throw _privateConstructorUsedError;
  int get homeTeamGoals => throw _privateConstructorUsedError;
  int get awayTeamGoals => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get season => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call({
    String id,
    String matchDay,
    int kickOffTime,
    String homeTeamId,
    String homeTeamName,
    String awayTeamId,
    String awayTeamName,
    int homeTeamGoals,
    int awayTeamGoals,
    String status,
    int season,
  });
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchDay = null,
    Object? kickOffTime = null,
    Object? homeTeamId = null,
    Object? homeTeamName = null,
    Object? awayTeamId = null,
    Object? awayTeamName = null,
    Object? homeTeamGoals = null,
    Object? awayTeamGoals = null,
    Object? status = null,
    Object? season = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            matchDay: null == matchDay
                ? _value.matchDay
                : matchDay // ignore: cast_nullable_to_non_nullable
                      as String,
            kickOffTime: null == kickOffTime
                ? _value.kickOffTime
                : kickOffTime // ignore: cast_nullable_to_non_nullable
                      as int,
            homeTeamId: null == homeTeamId
                ? _value.homeTeamId
                : homeTeamId // ignore: cast_nullable_to_non_nullable
                      as String,
            homeTeamName: null == homeTeamName
                ? _value.homeTeamName
                : homeTeamName // ignore: cast_nullable_to_non_nullable
                      as String,
            awayTeamId: null == awayTeamId
                ? _value.awayTeamId
                : awayTeamId // ignore: cast_nullable_to_non_nullable
                      as String,
            awayTeamName: null == awayTeamName
                ? _value.awayTeamName
                : awayTeamName // ignore: cast_nullable_to_non_nullable
                      as String,
            homeTeamGoals: null == homeTeamGoals
                ? _value.homeTeamGoals
                : homeTeamGoals // ignore: cast_nullable_to_non_nullable
                      as int,
            awayTeamGoals: null == awayTeamGoals
                ? _value.awayTeamGoals
                : awayTeamGoals // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            season: null == season
                ? _value.season
                : season // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
    _$MatchImpl value,
    $Res Function(_$MatchImpl) then,
  ) = __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String matchDay,
    int kickOffTime,
    String homeTeamId,
    String homeTeamName,
    String awayTeamId,
    String awayTeamName,
    int homeTeamGoals,
    int awayTeamGoals,
    String status,
    int season,
  });
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
    _$MatchImpl _value,
    $Res Function(_$MatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? matchDay = null,
    Object? kickOffTime = null,
    Object? homeTeamId = null,
    Object? homeTeamName = null,
    Object? awayTeamId = null,
    Object? awayTeamName = null,
    Object? homeTeamGoals = null,
    Object? awayTeamGoals = null,
    Object? status = null,
    Object? season = null,
  }) {
    return _then(
      _$MatchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        matchDay: null == matchDay
            ? _value.matchDay
            : matchDay // ignore: cast_nullable_to_non_nullable
                  as String,
        kickOffTime: null == kickOffTime
            ? _value.kickOffTime
            : kickOffTime // ignore: cast_nullable_to_non_nullable
                  as int,
        homeTeamId: null == homeTeamId
            ? _value.homeTeamId
            : homeTeamId // ignore: cast_nullable_to_non_nullable
                  as String,
        homeTeamName: null == homeTeamName
            ? _value.homeTeamName
            : homeTeamName // ignore: cast_nullable_to_non_nullable
                  as String,
        awayTeamId: null == awayTeamId
            ? _value.awayTeamId
            : awayTeamId // ignore: cast_nullable_to_non_nullable
                  as String,
        awayTeamName: null == awayTeamName
            ? _value.awayTeamName
            : awayTeamName // ignore: cast_nullable_to_non_nullable
                  as String,
        homeTeamGoals: null == homeTeamGoals
            ? _value.homeTeamGoals
            : homeTeamGoals // ignore: cast_nullable_to_non_nullable
                  as int,
        awayTeamGoals: null == awayTeamGoals
            ? _value.awayTeamGoals
            : awayTeamGoals // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        season: null == season
            ? _value.season
            : season // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchImpl implements _Match {
  const _$MatchImpl({
    required this.id,
    required this.matchDay,
    required this.kickOffTime,
    required this.homeTeamId,
    required this.homeTeamName,
    required this.awayTeamId,
    required this.awayTeamName,
    required this.homeTeamGoals,
    required this.awayTeamGoals,
    required this.status,
    required this.season,
  });

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String matchDay;
  @override
  final int kickOffTime;
  @override
  final String homeTeamId;
  @override
  final String homeTeamName;
  @override
  final String awayTeamId;
  @override
  final String awayTeamName;
  @override
  final int homeTeamGoals;
  @override
  final int awayTeamGoals;
  @override
  final String status;
  @override
  final int season;

  @override
  String toString() {
    return 'Match(id: $id, matchDay: $matchDay, kickOffTime: $kickOffTime, homeTeamId: $homeTeamId, homeTeamName: $homeTeamName, awayTeamId: $awayTeamId, awayTeamName: $awayTeamName, homeTeamGoals: $homeTeamGoals, awayTeamGoals: $awayTeamGoals, status: $status, season: $season)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.matchDay, matchDay) ||
                other.matchDay == matchDay) &&
            (identical(other.kickOffTime, kickOffTime) ||
                other.kickOffTime == kickOffTime) &&
            (identical(other.homeTeamId, homeTeamId) ||
                other.homeTeamId == homeTeamId) &&
            (identical(other.homeTeamName, homeTeamName) ||
                other.homeTeamName == homeTeamName) &&
            (identical(other.awayTeamId, awayTeamId) ||
                other.awayTeamId == awayTeamId) &&
            (identical(other.awayTeamName, awayTeamName) ||
                other.awayTeamName == awayTeamName) &&
            (identical(other.homeTeamGoals, homeTeamGoals) ||
                other.homeTeamGoals == homeTeamGoals) &&
            (identical(other.awayTeamGoals, awayTeamGoals) ||
                other.awayTeamGoals == awayTeamGoals) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.season, season) || other.season == season));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    matchDay,
    kickOffTime,
    homeTeamId,
    homeTeamName,
    awayTeamId,
    awayTeamName,
    homeTeamGoals,
    awayTeamGoals,
    status,
    season,
  );

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(this);
  }
}

abstract class _Match implements Match {
  const factory _Match({
    required final String id,
    required final String matchDay,
    required final int kickOffTime,
    required final String homeTeamId,
    required final String homeTeamName,
    required final String awayTeamId,
    required final String awayTeamName,
    required final int homeTeamGoals,
    required final int awayTeamGoals,
    required final String status,
    required final int season,
  }) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get matchDay;
  @override
  int get kickOffTime;
  @override
  String get homeTeamId;
  @override
  String get homeTeamName;
  @override
  String get awayTeamId;
  @override
  String get awayTeamName;
  @override
  int get homeTeamGoals;
  @override
  int get awayTeamGoals;
  @override
  String get status;
  @override
  int get season;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchData _$MatchDataFromJson(Map<String, dynamic> json) {
  return _MatchData.fromJson(json);
}

/// @nodoc
mixin _$MatchData {
  String get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get opponent => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  int get goals => throw _privateConstructorUsedError;
  int get assists => throw _privateConstructorUsedError;
  int get cleanSheet => throw _privateConstructorUsedError;
  int get ownGoals => throw _privateConstructorUsedError;
  int get redCards => throw _privateConstructorUsedError;
  int get yellowCards => throw _privateConstructorUsedError;
  int get minutesPlayed => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MatchData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchDataCopyWith<MatchData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchDataCopyWith<$Res> {
  factory $MatchDataCopyWith(MatchData value, $Res Function(MatchData) then) =
      _$MatchDataCopyWithImpl<$Res, MatchData>;
  @useResult
  $Res call({
    String id,
    String playerId,
    String playerName,
    String matchId,
    String opponent,
    int position,
    int goals,
    int assists,
    int cleanSheet,
    int ownGoals,
    int redCards,
    int yellowCards,
    int minutesPlayed,
    int points,
    double rating,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MatchDataCopyWithImpl<$Res, $Val extends MatchData>
    implements $MatchDataCopyWith<$Res> {
  _$MatchDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? matchId = null,
    Object? opponent = null,
    Object? position = null,
    Object? goals = null,
    Object? assists = null,
    Object? cleanSheet = null,
    Object? ownGoals = null,
    Object? redCards = null,
    Object? yellowCards = null,
    Object? minutesPlayed = null,
    Object? points = null,
    Object? rating = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            matchId: null == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String,
            opponent: null == opponent
                ? _value.opponent
                : opponent // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            goals: null == goals
                ? _value.goals
                : goals // ignore: cast_nullable_to_non_nullable
                      as int,
            assists: null == assists
                ? _value.assists
                : assists // ignore: cast_nullable_to_non_nullable
                      as int,
            cleanSheet: null == cleanSheet
                ? _value.cleanSheet
                : cleanSheet // ignore: cast_nullable_to_non_nullable
                      as int,
            ownGoals: null == ownGoals
                ? _value.ownGoals
                : ownGoals // ignore: cast_nullable_to_non_nullable
                      as int,
            redCards: null == redCards
                ? _value.redCards
                : redCards // ignore: cast_nullable_to_non_nullable
                      as int,
            yellowCards: null == yellowCards
                ? _value.yellowCards
                : yellowCards // ignore: cast_nullable_to_non_nullable
                      as int,
            minutesPlayed: null == minutesPlayed
                ? _value.minutesPlayed
                : minutesPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchDataImplCopyWith<$Res>
    implements $MatchDataCopyWith<$Res> {
  factory _$$MatchDataImplCopyWith(
    _$MatchDataImpl value,
    $Res Function(_$MatchDataImpl) then,
  ) = __$$MatchDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String playerId,
    String playerName,
    String matchId,
    String opponent,
    int position,
    int goals,
    int assists,
    int cleanSheet,
    int ownGoals,
    int redCards,
    int yellowCards,
    int minutesPlayed,
    int points,
    double rating,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MatchDataImplCopyWithImpl<$Res>
    extends _$MatchDataCopyWithImpl<$Res, _$MatchDataImpl>
    implements _$$MatchDataImplCopyWith<$Res> {
  __$$MatchDataImplCopyWithImpl(
    _$MatchDataImpl _value,
    $Res Function(_$MatchDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? matchId = null,
    Object? opponent = null,
    Object? position = null,
    Object? goals = null,
    Object? assists = null,
    Object? cleanSheet = null,
    Object? ownGoals = null,
    Object? redCards = null,
    Object? yellowCards = null,
    Object? minutesPlayed = null,
    Object? points = null,
    Object? rating = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MatchDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        opponent: null == opponent
            ? _value.opponent
            : opponent // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        goals: null == goals
            ? _value.goals
            : goals // ignore: cast_nullable_to_non_nullable
                  as int,
        assists: null == assists
            ? _value.assists
            : assists // ignore: cast_nullable_to_non_nullable
                  as int,
        cleanSheet: null == cleanSheet
            ? _value.cleanSheet
            : cleanSheet // ignore: cast_nullable_to_non_nullable
                  as int,
        ownGoals: null == ownGoals
            ? _value.ownGoals
            : ownGoals // ignore: cast_nullable_to_non_nullable
                  as int,
        redCards: null == redCards
            ? _value.redCards
            : redCards // ignore: cast_nullable_to_non_nullable
                  as int,
        yellowCards: null == yellowCards
            ? _value.yellowCards
            : yellowCards // ignore: cast_nullable_to_non_nullable
                  as int,
        minutesPlayed: null == minutesPlayed
            ? _value.minutesPlayed
            : minutesPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MatchDataImpl implements _MatchData {
  const _$MatchDataImpl({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.matchId,
    required this.opponent,
    required this.position,
    required this.goals,
    required this.assists,
    required this.cleanSheet,
    required this.ownGoals,
    required this.redCards,
    required this.yellowCards,
    required this.minutesPlayed,
    required this.points,
    required this.rating,
    required this.createdAt,
  });

  factory _$MatchDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchDataImplFromJson(json);

  @override
  final String id;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String matchId;
  @override
  final String opponent;
  @override
  final int position;
  @override
  final int goals;
  @override
  final int assists;
  @override
  final int cleanSheet;
  @override
  final int ownGoals;
  @override
  final int redCards;
  @override
  final int yellowCards;
  @override
  final int minutesPlayed;
  @override
  final int points;
  @override
  final double rating;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MatchData(id: $id, playerId: $playerId, playerName: $playerName, matchId: $matchId, opponent: $opponent, position: $position, goals: $goals, assists: $assists, cleanSheet: $cleanSheet, ownGoals: $ownGoals, redCards: $redCards, yellowCards: $yellowCards, minutesPlayed: $minutesPlayed, points: $points, rating: $rating, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.opponent, opponent) ||
                other.opponent == opponent) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.goals, goals) || other.goals == goals) &&
            (identical(other.assists, assists) || other.assists == assists) &&
            (identical(other.cleanSheet, cleanSheet) ||
                other.cleanSheet == cleanSheet) &&
            (identical(other.ownGoals, ownGoals) ||
                other.ownGoals == ownGoals) &&
            (identical(other.redCards, redCards) ||
                other.redCards == redCards) &&
            (identical(other.yellowCards, yellowCards) ||
                other.yellowCards == yellowCards) &&
            (identical(other.minutesPlayed, minutesPlayed) ||
                other.minutesPlayed == minutesPlayed) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    playerId,
    playerName,
    matchId,
    opponent,
    position,
    goals,
    assists,
    cleanSheet,
    ownGoals,
    redCards,
    yellowCards,
    minutesPlayed,
    points,
    rating,
    createdAt,
  );

  /// Create a copy of MatchData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchDataImplCopyWith<_$MatchDataImpl> get copyWith =>
      __$$MatchDataImplCopyWithImpl<_$MatchDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchDataImplToJson(this);
  }
}

abstract class _MatchData implements MatchData {
  const factory _MatchData({
    required final String id,
    required final String playerId,
    required final String playerName,
    required final String matchId,
    required final String opponent,
    required final int position,
    required final int goals,
    required final int assists,
    required final int cleanSheet,
    required final int ownGoals,
    required final int redCards,
    required final int yellowCards,
    required final int minutesPlayed,
    required final int points,
    required final double rating,
    required final DateTime createdAt,
  }) = _$MatchDataImpl;

  factory _MatchData.fromJson(Map<String, dynamic> json) =
      _$MatchDataImpl.fromJson;

  @override
  String get id;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get matchId;
  @override
  String get opponent;
  @override
  int get position;
  @override
  int get goals;
  @override
  int get assists;
  @override
  int get cleanSheet;
  @override
  int get ownGoals;
  @override
  int get redCards;
  @override
  int get yellowCards;
  @override
  int get minutesPlayed;
  @override
  int get points;
  @override
  double get rating;
  @override
  DateTime get createdAt;

  /// Create a copy of MatchData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchDataImplCopyWith<_$MatchDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Highlight _$HighlightFromJson(Map<String, dynamic> json) {
  return _Highlight.fromJson(json);
}

/// @nodoc
mixin _$Highlight {
  String get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get highlightType => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this Highlight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightCopyWith<Highlight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightCopyWith<$Res> {
  factory $HighlightCopyWith(Highlight value, $Res Function(Highlight) then) =
      _$HighlightCopyWithImpl<$Res, Highlight>;
  @useResult
  $Res call({
    String id,
    String playerId,
    String playerName,
    String matchId,
    String description,
    String highlightType,
    int points,
    DateTime timestamp,
  });
}

/// @nodoc
class _$HighlightCopyWithImpl<$Res, $Val extends Highlight>
    implements $HighlightCopyWith<$Res> {
  _$HighlightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? matchId = null,
    Object? description = null,
    Object? highlightType = null,
    Object? points = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            matchId: null == matchId
                ? _value.matchId
                : matchId // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            highlightType: null == highlightType
                ? _value.highlightType
                : highlightType // ignore: cast_nullable_to_non_nullable
                      as String,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HighlightImplCopyWith<$Res>
    implements $HighlightCopyWith<$Res> {
  factory _$$HighlightImplCopyWith(
    _$HighlightImpl value,
    $Res Function(_$HighlightImpl) then,
  ) = __$$HighlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String playerId,
    String playerName,
    String matchId,
    String description,
    String highlightType,
    int points,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$HighlightImplCopyWithImpl<$Res>
    extends _$HighlightCopyWithImpl<$Res, _$HighlightImpl>
    implements _$$HighlightImplCopyWith<$Res> {
  __$$HighlightImplCopyWithImpl(
    _$HighlightImpl _value,
    $Res Function(_$HighlightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? matchId = null,
    Object? description = null,
    Object? highlightType = null,
    Object? points = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$HighlightImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        matchId: null == matchId
            ? _value.matchId
            : matchId // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        highlightType: null == highlightType
            ? _value.highlightType
            : highlightType // ignore: cast_nullable_to_non_nullable
                  as String,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightImpl implements _Highlight {
  const _$HighlightImpl({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.matchId,
    required this.description,
    required this.highlightType,
    required this.points,
    required this.timestamp,
  });

  factory _$HighlightImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightImplFromJson(json);

  @override
  final String id;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String matchId;
  @override
  final String description;
  @override
  final String highlightType;
  @override
  final int points;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'Highlight(id: $id, playerId: $playerId, playerName: $playerName, matchId: $matchId, description: $description, highlightType: $highlightType, points: $points, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.highlightType, highlightType) ||
                other.highlightType == highlightType) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    playerId,
    playerName,
    matchId,
    description,
    highlightType,
    points,
    timestamp,
  );

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightImplCopyWith<_$HighlightImpl> get copyWith =>
      __$$HighlightImplCopyWithImpl<_$HighlightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HighlightImplToJson(this);
  }
}

abstract class _Highlight implements Highlight {
  const factory _Highlight({
    required final String id,
    required final String playerId,
    required final String playerName,
    required final String matchId,
    required final String description,
    required final String highlightType,
    required final int points,
    required final DateTime timestamp,
  }) = _$HighlightImpl;

  factory _Highlight.fromJson(Map<String, dynamic> json) =
      _$HighlightImpl.fromJson;

  @override
  String get id;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get matchId;
  @override
  String get description;
  @override
  String get highlightType;
  @override
  int get points;
  @override
  DateTime get timestamp;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightImplCopyWith<_$HighlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchesResponse _$MatchesResponseFromJson(Map<String, dynamic> json) {
  return _MatchesResponse.fromJson(json);
}

/// @nodoc
mixin _$MatchesResponse {
  List<Match> get matches => throw _privateConstructorUsedError;
  int? get totalCount => throw _privateConstructorUsedError;

  /// Serializes this MatchesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchesResponseCopyWith<MatchesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchesResponseCopyWith<$Res> {
  factory $MatchesResponseCopyWith(
    MatchesResponse value,
    $Res Function(MatchesResponse) then,
  ) = _$MatchesResponseCopyWithImpl<$Res, MatchesResponse>;
  @useResult
  $Res call({List<Match> matches, int? totalCount});
}

/// @nodoc
class _$MatchesResponseCopyWithImpl<$Res, $Val extends MatchesResponse>
    implements $MatchesResponseCopyWith<$Res> {
  _$MatchesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? matches = null, Object? totalCount = freezed}) {
    return _then(
      _value.copyWith(
            matches: null == matches
                ? _value.matches
                : matches // ignore: cast_nullable_to_non_nullable
                      as List<Match>,
            totalCount: freezed == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchesResponseImplCopyWith<$Res>
    implements $MatchesResponseCopyWith<$Res> {
  factory _$$MatchesResponseImplCopyWith(
    _$MatchesResponseImpl value,
    $Res Function(_$MatchesResponseImpl) then,
  ) = __$$MatchesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Match> matches, int? totalCount});
}

/// @nodoc
class __$$MatchesResponseImplCopyWithImpl<$Res>
    extends _$MatchesResponseCopyWithImpl<$Res, _$MatchesResponseImpl>
    implements _$$MatchesResponseImplCopyWith<$Res> {
  __$$MatchesResponseImplCopyWithImpl(
    _$MatchesResponseImpl _value,
    $Res Function(_$MatchesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? matches = null, Object? totalCount = freezed}) {
    return _then(
      _$MatchesResponseImpl(
        matches: null == matches
            ? _value._matches
            : matches // ignore: cast_nullable_to_non_nullable
                  as List<Match>,
        totalCount: freezed == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MatchesResponseImpl implements _MatchesResponse {
  const _$MatchesResponseImpl({
    required final List<Match> matches,
    this.totalCount,
  }) : _matches = matches;

  factory _$MatchesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchesResponseImplFromJson(json);

  final List<Match> _matches;
  @override
  List<Match> get matches {
    if (_matches is EqualUnmodifiableListView) return _matches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matches);
  }

  @override
  final int? totalCount;

  @override
  String toString() {
    return 'MatchesResponse(matches: $matches, totalCount: $totalCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchesResponseImpl &&
            const DeepCollectionEquality().equals(other._matches, _matches) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_matches),
    totalCount,
  );

  /// Create a copy of MatchesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchesResponseImplCopyWith<_$MatchesResponseImpl> get copyWith =>
      __$$MatchesResponseImplCopyWithImpl<_$MatchesResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchesResponseImplToJson(this);
  }
}

abstract class _MatchesResponse implements MatchesResponse {
  const factory _MatchesResponse({
    required final List<Match> matches,
    final int? totalCount,
  }) = _$MatchesResponseImpl;

  factory _MatchesResponse.fromJson(Map<String, dynamic> json) =
      _$MatchesResponseImpl.fromJson;

  @override
  List<Match> get matches;
  @override
  int? get totalCount;

  /// Create a copy of MatchesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchesResponseImplCopyWith<_$MatchesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchDayInfo _$MatchDayInfoFromJson(Map<String, dynamic> json) {
  return _MatchDayInfo.fromJson(json);
}

/// @nodoc
mixin _$MatchDayInfo {
  String get matchDay => throw _privateConstructorUsedError;
  int get startTime => throw _privateConstructorUsedError;
  int get endTime => throw _privateConstructorUsedError;
  List<Match> get matches => throw _privateConstructorUsedError;

  /// Serializes this MatchDayInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchDayInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchDayInfoCopyWith<MatchDayInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchDayInfoCopyWith<$Res> {
  factory $MatchDayInfoCopyWith(
    MatchDayInfo value,
    $Res Function(MatchDayInfo) then,
  ) = _$MatchDayInfoCopyWithImpl<$Res, MatchDayInfo>;
  @useResult
  $Res call({String matchDay, int startTime, int endTime, List<Match> matches});
}

/// @nodoc
class _$MatchDayInfoCopyWithImpl<$Res, $Val extends MatchDayInfo>
    implements $MatchDayInfoCopyWith<$Res> {
  _$MatchDayInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchDayInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchDay = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? matches = null,
  }) {
    return _then(
      _value.copyWith(
            matchDay: null == matchDay
                ? _value.matchDay
                : matchDay // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as int,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as int,
            matches: null == matches
                ? _value.matches
                : matches // ignore: cast_nullable_to_non_nullable
                      as List<Match>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchDayInfoImplCopyWith<$Res>
    implements $MatchDayInfoCopyWith<$Res> {
  factory _$$MatchDayInfoImplCopyWith(
    _$MatchDayInfoImpl value,
    $Res Function(_$MatchDayInfoImpl) then,
  ) = __$$MatchDayInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String matchDay, int startTime, int endTime, List<Match> matches});
}

/// @nodoc
class __$$MatchDayInfoImplCopyWithImpl<$Res>
    extends _$MatchDayInfoCopyWithImpl<$Res, _$MatchDayInfoImpl>
    implements _$$MatchDayInfoImplCopyWith<$Res> {
  __$$MatchDayInfoImplCopyWithImpl(
    _$MatchDayInfoImpl _value,
    $Res Function(_$MatchDayInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchDayInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchDay = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? matches = null,
  }) {
    return _then(
      _$MatchDayInfoImpl(
        matchDay: null == matchDay
            ? _value.matchDay
            : matchDay // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as int,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as int,
        matches: null == matches
            ? _value._matches
            : matches // ignore: cast_nullable_to_non_nullable
                  as List<Match>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchDayInfoImpl implements _MatchDayInfo {
  const _$MatchDayInfoImpl({
    required this.matchDay,
    required this.startTime,
    required this.endTime,
    required final List<Match> matches,
  }) : _matches = matches;

  factory _$MatchDayInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchDayInfoImplFromJson(json);

  @override
  final String matchDay;
  @override
  final int startTime;
  @override
  final int endTime;
  final List<Match> _matches;
  @override
  List<Match> get matches {
    if (_matches is EqualUnmodifiableListView) return _matches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matches);
  }

  @override
  String toString() {
    return 'MatchDayInfo(matchDay: $matchDay, startTime: $startTime, endTime: $endTime, matches: $matches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchDayInfoImpl &&
            (identical(other.matchDay, matchDay) ||
                other.matchDay == matchDay) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._matches, _matches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    matchDay,
    startTime,
    endTime,
    const DeepCollectionEquality().hash(_matches),
  );

  /// Create a copy of MatchDayInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchDayInfoImplCopyWith<_$MatchDayInfoImpl> get copyWith =>
      __$$MatchDayInfoImplCopyWithImpl<_$MatchDayInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchDayInfoImplToJson(this);
  }
}

abstract class _MatchDayInfo implements MatchDayInfo {
  const factory _MatchDayInfo({
    required final String matchDay,
    required final int startTime,
    required final int endTime,
    required final List<Match> matches,
  }) = _$MatchDayInfoImpl;

  factory _MatchDayInfo.fromJson(Map<String, dynamic> json) =
      _$MatchDayInfoImpl.fromJson;

  @override
  String get matchDay;
  @override
  int get startTime;
  @override
  int get endTime;
  @override
  List<Match> get matches;

  /// Create a copy of MatchDayInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchDayInfoImplCopyWith<_$MatchDayInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
