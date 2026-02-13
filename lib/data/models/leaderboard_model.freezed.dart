// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) {
  return _LeaderboardEntry.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntry {
  String get leagueId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get gamesPlayed => throw _privateConstructorUsedError;
  double get averagePoints => throw _privateConstructorUsedError;
  int get wins => throw _privateConstructorUsedError;
  int get draws => throw _privateConstructorUsedError;
  int get losses => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryCopyWith<$Res> {
  factory $LeaderboardEntryCopyWith(
    LeaderboardEntry value,
    $Res Function(LeaderboardEntry) then,
  ) = _$LeaderboardEntryCopyWithImpl<$Res, LeaderboardEntry>;
  @useResult
  $Res call({
    String leagueId,
    String userId,
    String username,
    int rank,
    int totalPoints,
    int gamesPlayed,
    double averagePoints,
    int wins,
    int draws,
    int losses,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res, $Val extends LeaderboardEntry>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? userId = null,
    Object? username = null,
    Object? rank = null,
    Object? totalPoints = null,
    Object? gamesPlayed = null,
    Object? averagePoints = null,
    Object? wins = null,
    Object? draws = null,
    Object? losses = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            gamesPlayed: null == gamesPlayed
                ? _value.gamesPlayed
                : gamesPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            averagePoints: null == averagePoints
                ? _value.averagePoints
                : averagePoints // ignore: cast_nullable_to_non_nullable
                      as double,
            wins: null == wins
                ? _value.wins
                : wins // ignore: cast_nullable_to_non_nullable
                      as int,
            draws: null == draws
                ? _value.draws
                : draws // ignore: cast_nullable_to_non_nullable
                      as int,
            losses: null == losses
                ? _value.losses
                : losses // ignore: cast_nullable_to_non_nullable
                      as int,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryImplCopyWith<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  factory _$$LeaderboardEntryImplCopyWith(
    _$LeaderboardEntryImpl value,
    $Res Function(_$LeaderboardEntryImpl) then,
  ) = __$$LeaderboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leagueId,
    String userId,
    String username,
    int rank,
    int totalPoints,
    int gamesPlayed,
    double averagePoints,
    int wins,
    int draws,
    int losses,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$LeaderboardEntryImplCopyWithImpl<$Res>
    extends _$LeaderboardEntryCopyWithImpl<$Res, _$LeaderboardEntryImpl>
    implements _$$LeaderboardEntryImplCopyWith<$Res> {
  __$$LeaderboardEntryImplCopyWithImpl(
    _$LeaderboardEntryImpl _value,
    $Res Function(_$LeaderboardEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? userId = null,
    Object? username = null,
    Object? rank = null,
    Object? totalPoints = null,
    Object? gamesPlayed = null,
    Object? averagePoints = null,
    Object? wins = null,
    Object? draws = null,
    Object? losses = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$LeaderboardEntryImpl(
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        gamesPlayed: null == gamesPlayed
            ? _value.gamesPlayed
            : gamesPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        averagePoints: null == averagePoints
            ? _value.averagePoints
            : averagePoints // ignore: cast_nullable_to_non_nullable
                  as double,
        wins: null == wins
            ? _value.wins
            : wins // ignore: cast_nullable_to_non_nullable
                  as int,
        draws: null == draws
            ? _value.draws
            : draws // ignore: cast_nullable_to_non_nullable
                  as int,
        losses: null == losses
            ? _value.losses
            : losses // ignore: cast_nullable_to_non_nullable
                  as int,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$LeaderboardEntryImpl implements _LeaderboardEntry {
  const _$LeaderboardEntryImpl({
    required this.leagueId,
    required this.userId,
    required this.username,
    required this.rank,
    required this.totalPoints,
    required this.gamesPlayed,
    required this.averagePoints,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.lastUpdated,
  });

  factory _$LeaderboardEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryImplFromJson(json);

  @override
  final String leagueId;
  @override
  final String userId;
  @override
  final String username;
  @override
  final int rank;
  @override
  final int totalPoints;
  @override
  final int gamesPlayed;
  @override
  final double averagePoints;
  @override
  final int wins;
  @override
  final int draws;
  @override
  final int losses;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'LeaderboardEntry(leagueId: $leagueId, userId: $userId, username: $username, rank: $rank, totalPoints: $totalPoints, gamesPlayed: $gamesPlayed, averagePoints: $averagePoints, wins: $wins, draws: $draws, losses: $losses, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryImpl &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.averagePoints, averagePoints) ||
                other.averagePoints == averagePoints) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.draws, draws) || other.draws == draws) &&
            (identical(other.losses, losses) || other.losses == losses) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leagueId,
    userId,
    username,
    rank,
    totalPoints,
    gamesPlayed,
    averagePoints,
    wins,
    draws,
    losses,
    lastUpdated,
  );

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      __$$LeaderboardEntryImplCopyWithImpl<_$LeaderboardEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryImplToJson(this);
  }
}

abstract class _LeaderboardEntry implements LeaderboardEntry {
  const factory _LeaderboardEntry({
    required final String leagueId,
    required final String userId,
    required final String username,
    required final int rank,
    required final int totalPoints,
    required final int gamesPlayed,
    required final double averagePoints,
    required final int wins,
    required final int draws,
    required final int losses,
    required final DateTime lastUpdated,
  }) = _$LeaderboardEntryImpl;

  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryImpl.fromJson;

  @override
  String get leagueId;
  @override
  String get userId;
  @override
  String get username;
  @override
  int get rank;
  @override
  int get totalPoints;
  @override
  int get gamesPlayed;
  @override
  double get averagePoints;
  @override
  int get wins;
  @override
  int get draws;
  @override
  int get losses;
  @override
  DateTime get lastUpdated;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ranking _$RankingFromJson(Map<String, dynamic> json) {
  return _Ranking.fromJson(json);
}

/// @nodoc
mixin _$Ranking {
  String get leagueId => throw _privateConstructorUsedError;
  String get leagueName => throw _privateConstructorUsedError;
  List<LeaderboardEntry> get entries => throw _privateConstructorUsedError;
  int get totalParticipants => throw _privateConstructorUsedError;
  String? get updateFrequency => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this Ranking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingCopyWith<Ranking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingCopyWith<$Res> {
  factory $RankingCopyWith(Ranking value, $Res Function(Ranking) then) =
      _$RankingCopyWithImpl<$Res, Ranking>;
  @useResult
  $Res call({
    String leagueId,
    String leagueName,
    List<LeaderboardEntry> entries,
    int totalParticipants,
    String? updateFrequency,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$RankingCopyWithImpl<$Res, $Val extends Ranking>
    implements $RankingCopyWith<$Res> {
  _$RankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? leagueName = null,
    Object? entries = null,
    Object? totalParticipants = null,
    Object? updateFrequency = freezed,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueName: null == leagueName
                ? _value.leagueName
                : leagueName // ignore: cast_nullable_to_non_nullable
                      as String,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardEntry>,
            totalParticipants: null == totalParticipants
                ? _value.totalParticipants
                : totalParticipants // ignore: cast_nullable_to_non_nullable
                      as int,
            updateFrequency: freezed == updateFrequency
                ? _value.updateFrequency
                : updateFrequency // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RankingImplCopyWith<$Res> implements $RankingCopyWith<$Res> {
  factory _$$RankingImplCopyWith(
    _$RankingImpl value,
    $Res Function(_$RankingImpl) then,
  ) = __$$RankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leagueId,
    String leagueName,
    List<LeaderboardEntry> entries,
    int totalParticipants,
    String? updateFrequency,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$RankingImplCopyWithImpl<$Res>
    extends _$RankingCopyWithImpl<$Res, _$RankingImpl>
    implements _$$RankingImplCopyWith<$Res> {
  __$$RankingImplCopyWithImpl(
    _$RankingImpl _value,
    $Res Function(_$RankingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? leagueName = null,
    Object? entries = null,
    Object? totalParticipants = null,
    Object? updateFrequency = freezed,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$RankingImpl(
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueName: null == leagueName
            ? _value.leagueName
            : leagueName // ignore: cast_nullable_to_non_nullable
                  as String,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardEntry>,
        totalParticipants: null == totalParticipants
            ? _value.totalParticipants
            : totalParticipants // ignore: cast_nullable_to_non_nullable
                  as int,
        updateFrequency: freezed == updateFrequency
            ? _value.updateFrequency
            : updateFrequency // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RankingImpl implements _Ranking {
  const _$RankingImpl({
    required this.leagueId,
    required this.leagueName,
    required final List<LeaderboardEntry> entries,
    required this.totalParticipants,
    this.updateFrequency,
    required this.lastUpdated,
  }) : _entries = entries;

  factory _$RankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingImplFromJson(json);

  @override
  final String leagueId;
  @override
  final String leagueName;
  final List<LeaderboardEntry> _entries;
  @override
  List<LeaderboardEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final int totalParticipants;
  @override
  final String? updateFrequency;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'Ranking(leagueId: $leagueId, leagueName: $leagueName, entries: $entries, totalParticipants: $totalParticipants, updateFrequency: $updateFrequency, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingImpl &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.leagueName, leagueName) ||
                other.leagueName == leagueName) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.totalParticipants, totalParticipants) ||
                other.totalParticipants == totalParticipants) &&
            (identical(other.updateFrequency, updateFrequency) ||
                other.updateFrequency == updateFrequency) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leagueId,
    leagueName,
    const DeepCollectionEquality().hash(_entries),
    totalParticipants,
    updateFrequency,
    lastUpdated,
  );

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingImplCopyWith<_$RankingImpl> get copyWith =>
      __$$RankingImplCopyWithImpl<_$RankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingImplToJson(this);
  }
}

abstract class _Ranking implements Ranking {
  const factory _Ranking({
    required final String leagueId,
    required final String leagueName,
    required final List<LeaderboardEntry> entries,
    required final int totalParticipants,
    final String? updateFrequency,
    required final DateTime lastUpdated,
  }) = _$RankingImpl;

  factory _Ranking.fromJson(Map<String, dynamic> json) = _$RankingImpl.fromJson;

  @override
  String get leagueId;
  @override
  String get leagueName;
  @override
  List<LeaderboardEntry> get entries;
  @override
  int get totalParticipants;
  @override
  String? get updateFrequency;
  @override
  DateTime get lastUpdated;

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingImplCopyWith<_$RankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserRanking _$UserRankingFromJson(Map<String, dynamic> json) {
  return _UserRanking.fromJson(json);
}

/// @nodoc
mixin _$UserRanking {
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int? get pointsBehindLeader => throw _privateConstructorUsedError;
  int? get pointsAheadNext => throw _privateConstructorUsedError;
  int get gamesPlayed => throw _privateConstructorUsedError;
  String get trend => throw _privateConstructorUsedError;

  /// Serializes this UserRanking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRankingCopyWith<UserRanking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRankingCopyWith<$Res> {
  factory $UserRankingCopyWith(
    UserRanking value,
    $Res Function(UserRanking) then,
  ) = _$UserRankingCopyWithImpl<$Res, UserRanking>;
  @useResult
  $Res call({
    String userId,
    String username,
    int totalPoints,
    int rank,
    int? pointsBehindLeader,
    int? pointsAheadNext,
    int gamesPlayed,
    String trend,
  });
}

/// @nodoc
class _$UserRankingCopyWithImpl<$Res, $Val extends UserRanking>
    implements $UserRankingCopyWith<$Res> {
  _$UserRankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? totalPoints = null,
    Object? rank = null,
    Object? pointsBehindLeader = freezed,
    Object? pointsAheadNext = freezed,
    Object? gamesPlayed = null,
    Object? trend = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            pointsBehindLeader: freezed == pointsBehindLeader
                ? _value.pointsBehindLeader
                : pointsBehindLeader // ignore: cast_nullable_to_non_nullable
                      as int?,
            pointsAheadNext: freezed == pointsAheadNext
                ? _value.pointsAheadNext
                : pointsAheadNext // ignore: cast_nullable_to_non_nullable
                      as int?,
            gamesPlayed: null == gamesPlayed
                ? _value.gamesPlayed
                : gamesPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserRankingImplCopyWith<$Res>
    implements $UserRankingCopyWith<$Res> {
  factory _$$UserRankingImplCopyWith(
    _$UserRankingImpl value,
    $Res Function(_$UserRankingImpl) then,
  ) = __$$UserRankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String username,
    int totalPoints,
    int rank,
    int? pointsBehindLeader,
    int? pointsAheadNext,
    int gamesPlayed,
    String trend,
  });
}

/// @nodoc
class __$$UserRankingImplCopyWithImpl<$Res>
    extends _$UserRankingCopyWithImpl<$Res, _$UserRankingImpl>
    implements _$$UserRankingImplCopyWith<$Res> {
  __$$UserRankingImplCopyWithImpl(
    _$UserRankingImpl _value,
    $Res Function(_$UserRankingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? totalPoints = null,
    Object? rank = null,
    Object? pointsBehindLeader = freezed,
    Object? pointsAheadNext = freezed,
    Object? gamesPlayed = null,
    Object? trend = null,
  }) {
    return _then(
      _$UserRankingImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        pointsBehindLeader: freezed == pointsBehindLeader
            ? _value.pointsBehindLeader
            : pointsBehindLeader // ignore: cast_nullable_to_non_nullable
                  as int?,
        pointsAheadNext: freezed == pointsAheadNext
            ? _value.pointsAheadNext
            : pointsAheadNext // ignore: cast_nullable_to_non_nullable
                  as int?,
        gamesPlayed: null == gamesPlayed
            ? _value.gamesPlayed
            : gamesPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        trend: null == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$UserRankingImpl implements _UserRanking {
  const _$UserRankingImpl({
    required this.userId,
    required this.username,
    required this.totalPoints,
    required this.rank,
    this.pointsBehindLeader,
    this.pointsAheadNext,
    required this.gamesPlayed,
    required this.trend,
  });

  factory _$UserRankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRankingImplFromJson(json);

  @override
  final String userId;
  @override
  final String username;
  @override
  final int totalPoints;
  @override
  final int rank;
  @override
  final int? pointsBehindLeader;
  @override
  final int? pointsAheadNext;
  @override
  final int gamesPlayed;
  @override
  final String trend;

  @override
  String toString() {
    return 'UserRanking(userId: $userId, username: $username, totalPoints: $totalPoints, rank: $rank, pointsBehindLeader: $pointsBehindLeader, pointsAheadNext: $pointsAheadNext, gamesPlayed: $gamesPlayed, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRankingImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.pointsBehindLeader, pointsBehindLeader) ||
                other.pointsBehindLeader == pointsBehindLeader) &&
            (identical(other.pointsAheadNext, pointsAheadNext) ||
                other.pointsAheadNext == pointsAheadNext) &&
            (identical(other.gamesPlayed, gamesPlayed) ||
                other.gamesPlayed == gamesPlayed) &&
            (identical(other.trend, trend) || other.trend == trend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    username,
    totalPoints,
    rank,
    pointsBehindLeader,
    pointsAheadNext,
    gamesPlayed,
    trend,
  );

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRankingImplCopyWith<_$UserRankingImpl> get copyWith =>
      __$$UserRankingImplCopyWithImpl<_$UserRankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRankingImplToJson(this);
  }
}

abstract class _UserRanking implements UserRanking {
  const factory _UserRanking({
    required final String userId,
    required final String username,
    required final int totalPoints,
    required final int rank,
    final int? pointsBehindLeader,
    final int? pointsAheadNext,
    required final int gamesPlayed,
    required final String trend,
  }) = _$UserRankingImpl;

  factory _UserRanking.fromJson(Map<String, dynamic> json) =
      _$UserRankingImpl.fromJson;

  @override
  String get userId;
  @override
  String get username;
  @override
  int get totalPoints;
  @override
  int get rank;
  @override
  int? get pointsBehindLeader;
  @override
  int? get pointsAheadNext;
  @override
  int get gamesPlayed;
  @override
  String get trend;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRankingImplCopyWith<_$UserRankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LeagueStandings _$LeagueStandingsFromJson(Map<String, dynamic> json) {
  return _LeagueStandings.fromJson(json);
}

/// @nodoc
mixin _$LeagueStandings {
  String get leagueId => throw _privateConstructorUsedError;
  String get leagueName => throw _privateConstructorUsedError;
  List<LeaderboardEntry> get standings => throw _privateConstructorUsedError;
  int get matchdayNumber => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LeagueStandings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeagueStandingsCopyWith<LeagueStandings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeagueStandingsCopyWith<$Res> {
  factory $LeagueStandingsCopyWith(
    LeagueStandings value,
    $Res Function(LeagueStandings) then,
  ) = _$LeagueStandingsCopyWithImpl<$Res, LeagueStandings>;
  @useResult
  $Res call({
    String leagueId,
    String leagueName,
    List<LeaderboardEntry> standings,
    int matchdayNumber,
    DateTime createdAt,
  });
}

/// @nodoc
class _$LeagueStandingsCopyWithImpl<$Res, $Val extends LeagueStandings>
    implements $LeagueStandingsCopyWith<$Res> {
  _$LeagueStandingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? leagueName = null,
    Object? standings = null,
    Object? matchdayNumber = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueName: null == leagueName
                ? _value.leagueName
                : leagueName // ignore: cast_nullable_to_non_nullable
                      as String,
            standings: null == standings
                ? _value.standings
                : standings // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardEntry>,
            matchdayNumber: null == matchdayNumber
                ? _value.matchdayNumber
                : matchdayNumber // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$LeagueStandingsImplCopyWith<$Res>
    implements $LeagueStandingsCopyWith<$Res> {
  factory _$$LeagueStandingsImplCopyWith(
    _$LeagueStandingsImpl value,
    $Res Function(_$LeagueStandingsImpl) then,
  ) = __$$LeagueStandingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leagueId,
    String leagueName,
    List<LeaderboardEntry> standings,
    int matchdayNumber,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$LeagueStandingsImplCopyWithImpl<$Res>
    extends _$LeagueStandingsCopyWithImpl<$Res, _$LeagueStandingsImpl>
    implements _$$LeagueStandingsImplCopyWith<$Res> {
  __$$LeagueStandingsImplCopyWithImpl(
    _$LeagueStandingsImpl _value,
    $Res Function(_$LeagueStandingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? leagueName = null,
    Object? standings = null,
    Object? matchdayNumber = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$LeagueStandingsImpl(
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueName: null == leagueName
            ? _value.leagueName
            : leagueName // ignore: cast_nullable_to_non_nullable
                  as String,
        standings: null == standings
            ? _value._standings
            : standings // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardEntry>,
        matchdayNumber: null == matchdayNumber
            ? _value.matchdayNumber
            : matchdayNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeagueStandingsImpl implements _LeagueStandings {
  const _$LeagueStandingsImpl({
    required this.leagueId,
    required this.leagueName,
    required final List<LeaderboardEntry> standings,
    required this.matchdayNumber,
    required this.createdAt,
  }) : _standings = standings;

  factory _$LeagueStandingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeagueStandingsImplFromJson(json);

  @override
  final String leagueId;
  @override
  final String leagueName;
  final List<LeaderboardEntry> _standings;
  @override
  List<LeaderboardEntry> get standings {
    if (_standings is EqualUnmodifiableListView) return _standings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_standings);
  }

  @override
  final int matchdayNumber;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'LeagueStandings(leagueId: $leagueId, leagueName: $leagueName, standings: $standings, matchdayNumber: $matchdayNumber, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeagueStandingsImpl &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.leagueName, leagueName) ||
                other.leagueName == leagueName) &&
            const DeepCollectionEquality().equals(
              other._standings,
              _standings,
            ) &&
            (identical(other.matchdayNumber, matchdayNumber) ||
                other.matchdayNumber == matchdayNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leagueId,
    leagueName,
    const DeepCollectionEquality().hash(_standings),
    matchdayNumber,
    createdAt,
  );

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeagueStandingsImplCopyWith<_$LeagueStandingsImpl> get copyWith =>
      __$$LeagueStandingsImplCopyWithImpl<_$LeagueStandingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeagueStandingsImplToJson(this);
  }
}

abstract class _LeagueStandings implements LeagueStandings {
  const factory _LeagueStandings({
    required final String leagueId,
    required final String leagueName,
    required final List<LeaderboardEntry> standings,
    required final int matchdayNumber,
    required final DateTime createdAt,
  }) = _$LeagueStandingsImpl;

  factory _LeagueStandings.fromJson(Map<String, dynamic> json) =
      _$LeagueStandingsImpl.fromJson;

  @override
  String get leagueId;
  @override
  String get leagueName;
  @override
  List<LeaderboardEntry> get standings;
  @override
  int get matchdayNumber;
  @override
  DateTime get createdAt;

  /// Create a copy of LeagueStandings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeagueStandingsImplCopyWith<_$LeagueStandingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HistoricalRanking _$HistoricalRankingFromJson(Map<String, dynamic> json) {
  return _HistoricalRanking.fromJson(json);
}

/// @nodoc
mixin _$HistoricalRanking {
  String get leagueId => throw _privateConstructorUsedError;
  int get matchday => throw _privateConstructorUsedError;
  List<LeaderboardEntry> get standings => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;

  /// Serializes this HistoricalRanking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoricalRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoricalRankingCopyWith<HistoricalRanking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoricalRankingCopyWith<$Res> {
  factory $HistoricalRankingCopyWith(
    HistoricalRanking value,
    $Res Function(HistoricalRanking) then,
  ) = _$HistoricalRankingCopyWithImpl<$Res, HistoricalRanking>;
  @useResult
  $Res call({
    String leagueId,
    int matchday,
    List<LeaderboardEntry> standings,
    DateTime recordedAt,
  });
}

/// @nodoc
class _$HistoricalRankingCopyWithImpl<$Res, $Val extends HistoricalRanking>
    implements $HistoricalRankingCopyWith<$Res> {
  _$HistoricalRankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoricalRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? matchday = null,
    Object? standings = null,
    Object? recordedAt = null,
  }) {
    return _then(
      _value.copyWith(
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            matchday: null == matchday
                ? _value.matchday
                : matchday // ignore: cast_nullable_to_non_nullable
                      as int,
            standings: null == standings
                ? _value.standings
                : standings // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardEntry>,
            recordedAt: null == recordedAt
                ? _value.recordedAt
                : recordedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HistoricalRankingImplCopyWith<$Res>
    implements $HistoricalRankingCopyWith<$Res> {
  factory _$$HistoricalRankingImplCopyWith(
    _$HistoricalRankingImpl value,
    $Res Function(_$HistoricalRankingImpl) then,
  ) = __$$HistoricalRankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String leagueId,
    int matchday,
    List<LeaderboardEntry> standings,
    DateTime recordedAt,
  });
}

/// @nodoc
class __$$HistoricalRankingImplCopyWithImpl<$Res>
    extends _$HistoricalRankingCopyWithImpl<$Res, _$HistoricalRankingImpl>
    implements _$$HistoricalRankingImplCopyWith<$Res> {
  __$$HistoricalRankingImplCopyWithImpl(
    _$HistoricalRankingImpl _value,
    $Res Function(_$HistoricalRankingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HistoricalRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leagueId = null,
    Object? matchday = null,
    Object? standings = null,
    Object? recordedAt = null,
  }) {
    return _then(
      _$HistoricalRankingImpl(
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        matchday: null == matchday
            ? _value.matchday
            : matchday // ignore: cast_nullable_to_non_nullable
                  as int,
        standings: null == standings
            ? _value._standings
            : standings // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardEntry>,
        recordedAt: null == recordedAt
            ? _value.recordedAt
            : recordedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoricalRankingImpl implements _HistoricalRanking {
  const _$HistoricalRankingImpl({
    required this.leagueId,
    required this.matchday,
    required final List<LeaderboardEntry> standings,
    required this.recordedAt,
  }) : _standings = standings;

  factory _$HistoricalRankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoricalRankingImplFromJson(json);

  @override
  final String leagueId;
  @override
  final int matchday;
  final List<LeaderboardEntry> _standings;
  @override
  List<LeaderboardEntry> get standings {
    if (_standings is EqualUnmodifiableListView) return _standings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_standings);
  }

  @override
  final DateTime recordedAt;

  @override
  String toString() {
    return 'HistoricalRanking(leagueId: $leagueId, matchday: $matchday, standings: $standings, recordedAt: $recordedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoricalRankingImpl &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.matchday, matchday) ||
                other.matchday == matchday) &&
            const DeepCollectionEquality().equals(
              other._standings,
              _standings,
            ) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    leagueId,
    matchday,
    const DeepCollectionEquality().hash(_standings),
    recordedAt,
  );

  /// Create a copy of HistoricalRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoricalRankingImplCopyWith<_$HistoricalRankingImpl> get copyWith =>
      __$$HistoricalRankingImplCopyWithImpl<_$HistoricalRankingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoricalRankingImplToJson(this);
  }
}

abstract class _HistoricalRanking implements HistoricalRanking {
  const factory _HistoricalRanking({
    required final String leagueId,
    required final int matchday,
    required final List<LeaderboardEntry> standings,
    required final DateTime recordedAt,
  }) = _$HistoricalRankingImpl;

  factory _HistoricalRanking.fromJson(Map<String, dynamic> json) =
      _$HistoricalRankingImpl.fromJson;

  @override
  String get leagueId;
  @override
  int get matchday;
  @override
  List<LeaderboardEntry> get standings;
  @override
  DateTime get recordedAt;

  /// Create a copy of HistoricalRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoricalRankingImplCopyWith<_$HistoricalRankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RankingChange _$RankingChangeFromJson(Map<String, dynamic> json) {
  return _RankingChange.fromJson(json);
}

/// @nodoc
mixin _$RankingChange {
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int get previousRank => throw _privateConstructorUsedError;
  int get currentRank => throw _privateConstructorUsedError;
  int get pointsChange => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this RankingChange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RankingChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingChangeCopyWith<RankingChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingChangeCopyWith<$Res> {
  factory $RankingChangeCopyWith(
    RankingChange value,
    $Res Function(RankingChange) then,
  ) = _$RankingChangeCopyWithImpl<$Res, RankingChange>;
  @useResult
  $Res call({
    String userId,
    String username,
    int previousRank,
    int currentRank,
    int pointsChange,
    DateTime timestamp,
  });
}

/// @nodoc
class _$RankingChangeCopyWithImpl<$Res, $Val extends RankingChange>
    implements $RankingChangeCopyWith<$Res> {
  _$RankingChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankingChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? previousRank = null,
    Object? currentRank = null,
    Object? pointsChange = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            previousRank: null == previousRank
                ? _value.previousRank
                : previousRank // ignore: cast_nullable_to_non_nullable
                      as int,
            currentRank: null == currentRank
                ? _value.currentRank
                : currentRank // ignore: cast_nullable_to_non_nullable
                      as int,
            pointsChange: null == pointsChange
                ? _value.pointsChange
                : pointsChange // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RankingChangeImplCopyWith<$Res>
    implements $RankingChangeCopyWith<$Res> {
  factory _$$RankingChangeImplCopyWith(
    _$RankingChangeImpl value,
    $Res Function(_$RankingChangeImpl) then,
  ) = __$$RankingChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String username,
    int previousRank,
    int currentRank,
    int pointsChange,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$RankingChangeImplCopyWithImpl<$Res>
    extends _$RankingChangeCopyWithImpl<$Res, _$RankingChangeImpl>
    implements _$$RankingChangeImplCopyWith<$Res> {
  __$$RankingChangeImplCopyWithImpl(
    _$RankingChangeImpl _value,
    $Res Function(_$RankingChangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankingChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? previousRank = null,
    Object? currentRank = null,
    Object? pointsChange = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$RankingChangeImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        previousRank: null == previousRank
            ? _value.previousRank
            : previousRank // ignore: cast_nullable_to_non_nullable
                  as int,
        currentRank: null == currentRank
            ? _value.currentRank
            : currentRank // ignore: cast_nullable_to_non_nullable
                  as int,
        pointsChange: null == pointsChange
            ? _value.pointsChange
            : pointsChange // ignore: cast_nullable_to_non_nullable
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
class _$RankingChangeImpl implements _RankingChange {
  const _$RankingChangeImpl({
    required this.userId,
    required this.username,
    required this.previousRank,
    required this.currentRank,
    required this.pointsChange,
    required this.timestamp,
  });

  factory _$RankingChangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingChangeImplFromJson(json);

  @override
  final String userId;
  @override
  final String username;
  @override
  final int previousRank;
  @override
  final int currentRank;
  @override
  final int pointsChange;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'RankingChange(userId: $userId, username: $username, previousRank: $previousRank, currentRank: $currentRank, pointsChange: $pointsChange, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingChangeImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.previousRank, previousRank) ||
                other.previousRank == previousRank) &&
            (identical(other.currentRank, currentRank) ||
                other.currentRank == currentRank) &&
            (identical(other.pointsChange, pointsChange) ||
                other.pointsChange == pointsChange) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    username,
    previousRank,
    currentRank,
    pointsChange,
    timestamp,
  );

  /// Create a copy of RankingChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingChangeImplCopyWith<_$RankingChangeImpl> get copyWith =>
      __$$RankingChangeImplCopyWithImpl<_$RankingChangeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingChangeImplToJson(this);
  }
}

abstract class _RankingChange implements RankingChange {
  const factory _RankingChange({
    required final String userId,
    required final String username,
    required final int previousRank,
    required final int currentRank,
    required final int pointsChange,
    required final DateTime timestamp,
  }) = _$RankingChangeImpl;

  factory _RankingChange.fromJson(Map<String, dynamic> json) =
      _$RankingChangeImpl.fromJson;

  @override
  String get userId;
  @override
  String get username;
  @override
  int get previousRank;
  @override
  int get currentRank;
  @override
  int get pointsChange;
  @override
  DateTime get timestamp;

  /// Create a copy of RankingChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingChangeImplCopyWith<_$RankingChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
