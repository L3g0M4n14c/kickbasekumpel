// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lineup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LineupResponse _$LineupResponseFromJson(Map<String, dynamic> json) {
  return _LineupResponse.fromJson(json);
}

/// @nodoc
mixin _$LineupResponse {
  @JsonKey(name: 'it')
  List<LineupPlayer> get players => throw _privateConstructorUsedError;

  /// Serializes this LineupResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupResponseCopyWith<LineupResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupResponseCopyWith<$Res> {
  factory $LineupResponseCopyWith(
    LineupResponse value,
    $Res Function(LineupResponse) then,
  ) = _$LineupResponseCopyWithImpl<$Res, LineupResponse>;
  @useResult
  $Res call({@JsonKey(name: 'it') List<LineupPlayer> players});
}

/// @nodoc
class _$LineupResponseCopyWithImpl<$Res, $Val extends LineupResponse>
    implements $LineupResponseCopyWith<$Res> {
  _$LineupResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<LineupPlayer>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LineupResponseImplCopyWith<$Res>
    implements $LineupResponseCopyWith<$Res> {
  factory _$$LineupResponseImplCopyWith(
    _$LineupResponseImpl value,
    $Res Function(_$LineupResponseImpl) then,
  ) = __$$LineupResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'it') List<LineupPlayer> players});
}

/// @nodoc
class __$$LineupResponseImplCopyWithImpl<$Res>
    extends _$LineupResponseCopyWithImpl<$Res, _$LineupResponseImpl>
    implements _$$LineupResponseImplCopyWith<$Res> {
  __$$LineupResponseImplCopyWithImpl(
    _$LineupResponseImpl _value,
    $Res Function(_$LineupResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _$LineupResponseImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<LineupPlayer>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupResponseImpl implements _LineupResponse {
  const _$LineupResponseImpl({
    @JsonKey(name: 'it') required final List<LineupPlayer> players,
  }) : _players = players;

  factory _$LineupResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupResponseImplFromJson(json);

  final List<LineupPlayer> _players;
  @override
  @JsonKey(name: 'it')
  List<LineupPlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'LineupResponse(players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupResponseImpl &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_players));

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupResponseImplCopyWith<_$LineupResponseImpl> get copyWith =>
      __$$LineupResponseImplCopyWithImpl<_$LineupResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupResponseImplToJson(this);
  }
}

abstract class _LineupResponse implements LineupResponse {
  const factory _LineupResponse({
    @JsonKey(name: 'it') required final List<LineupPlayer> players,
  }) = _$LineupResponseImpl;

  factory _LineupResponse.fromJson(Map<String, dynamic> json) =
      _$LineupResponseImpl.fromJson;

  @override
  @JsonKey(name: 'it')
  List<LineupPlayer> get players;

  /// Create a copy of LineupResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupResponseImplCopyWith<_$LineupResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LineupPlayer _$LineupPlayerFromJson(Map<String, dynamic> json) {
  return _LineupPlayer.fromJson(json);
}

/// @nodoc
mixin _$LineupPlayer {
  /// Player ID
  @JsonKey(name: 'i')
  String get id => throw _privateConstructorUsedError;

  /// Player name
  @JsonKey(name: 'n')
  String get name => throw _privateConstructorUsedError;

  /// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
  @JsonKey(name: 'pos')
  int get position => throw _privateConstructorUsedError;

  /// Team ID
  @JsonKey(name: 'tid')
  String get teamId => throw _privateConstructorUsedError;

  /// Average points
  @JsonKey(name: 'ap')
  int get averagePoints => throw _privateConstructorUsedError;

  /// Total points
  @JsonKey(name: 'st')
  int get totalPoints => throw _privateConstructorUsedError;

  /// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
  @JsonKey(name: 'mdst')
  int get matchDayStatus => throw _privateConstructorUsedError;

  /// Lineup order (0 means on bench/not in lineup)
  @JsonKey(name: 'lo')
  int get lineupOrder => throw _privateConstructorUsedError;

  /// Last total points
  @JsonKey(name: 'lst')
  int get lastTotalPoints => throw _privateConstructorUsedError;

  /// Has today (if player plays today)
  @JsonKey(name: 'ht')
  bool get hasToday => throw _privateConstructorUsedError;

  /// Original status (e.g., injury/suspension info)
  @JsonKey(name: 'os')
  String? get originalStatus => throw _privateConstructorUsedError;

  /// Performance history
  @JsonKey(name: 'ph')
  List<PerformanceHistory>? get performanceHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this LineupPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupPlayerCopyWith<LineupPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupPlayerCopyWith<$Res> {
  factory $LineupPlayerCopyWith(
    LineupPlayer value,
    $Res Function(LineupPlayer) then,
  ) = _$LineupPlayerCopyWithImpl<$Res, LineupPlayer>;
  @useResult
  $Res call({
    @JsonKey(name: 'i') String id,
    @JsonKey(name: 'n') String name,
    @JsonKey(name: 'pos') int position,
    @JsonKey(name: 'tid') String teamId,
    @JsonKey(name: 'ap') int averagePoints,
    @JsonKey(name: 'st') int totalPoints,
    @JsonKey(name: 'mdst') int matchDayStatus,
    @JsonKey(name: 'lo') int lineupOrder,
    @JsonKey(name: 'lst') int lastTotalPoints,
    @JsonKey(name: 'ht') bool hasToday,
    @JsonKey(name: 'os') String? originalStatus,
    @JsonKey(name: 'ph') List<PerformanceHistory>? performanceHistory,
  });
}

/// @nodoc
class _$LineupPlayerCopyWithImpl<$Res, $Val extends LineupPlayer>
    implements $LineupPlayerCopyWith<$Res> {
  _$LineupPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? position = null,
    Object? teamId = null,
    Object? averagePoints = null,
    Object? totalPoints = null,
    Object? matchDayStatus = null,
    Object? lineupOrder = null,
    Object? lastTotalPoints = null,
    Object? hasToday = null,
    Object? originalStatus = freezed,
    Object? performanceHistory = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            teamId: null == teamId
                ? _value.teamId
                : teamId // ignore: cast_nullable_to_non_nullable
                      as String,
            averagePoints: null == averagePoints
                ? _value.averagePoints
                : averagePoints // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            matchDayStatus: null == matchDayStatus
                ? _value.matchDayStatus
                : matchDayStatus // ignore: cast_nullable_to_non_nullable
                      as int,
            lineupOrder: null == lineupOrder
                ? _value.lineupOrder
                : lineupOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            lastTotalPoints: null == lastTotalPoints
                ? _value.lastTotalPoints
                : lastTotalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            hasToday: null == hasToday
                ? _value.hasToday
                : hasToday // ignore: cast_nullable_to_non_nullable
                      as bool,
            originalStatus: freezed == originalStatus
                ? _value.originalStatus
                : originalStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            performanceHistory: freezed == performanceHistory
                ? _value.performanceHistory
                : performanceHistory // ignore: cast_nullable_to_non_nullable
                      as List<PerformanceHistory>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LineupPlayerImplCopyWith<$Res>
    implements $LineupPlayerCopyWith<$Res> {
  factory _$$LineupPlayerImplCopyWith(
    _$LineupPlayerImpl value,
    $Res Function(_$LineupPlayerImpl) then,
  ) = __$$LineupPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'i') String id,
    @JsonKey(name: 'n') String name,
    @JsonKey(name: 'pos') int position,
    @JsonKey(name: 'tid') String teamId,
    @JsonKey(name: 'ap') int averagePoints,
    @JsonKey(name: 'st') int totalPoints,
    @JsonKey(name: 'mdst') int matchDayStatus,
    @JsonKey(name: 'lo') int lineupOrder,
    @JsonKey(name: 'lst') int lastTotalPoints,
    @JsonKey(name: 'ht') bool hasToday,
    @JsonKey(name: 'os') String? originalStatus,
    @JsonKey(name: 'ph') List<PerformanceHistory>? performanceHistory,
  });
}

/// @nodoc
class __$$LineupPlayerImplCopyWithImpl<$Res>
    extends _$LineupPlayerCopyWithImpl<$Res, _$LineupPlayerImpl>
    implements _$$LineupPlayerImplCopyWith<$Res> {
  __$$LineupPlayerImplCopyWithImpl(
    _$LineupPlayerImpl _value,
    $Res Function(_$LineupPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? position = null,
    Object? teamId = null,
    Object? averagePoints = null,
    Object? totalPoints = null,
    Object? matchDayStatus = null,
    Object? lineupOrder = null,
    Object? lastTotalPoints = null,
    Object? hasToday = null,
    Object? originalStatus = freezed,
    Object? performanceHistory = freezed,
  }) {
    return _then(
      _$LineupPlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        teamId: null == teamId
            ? _value.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String,
        averagePoints: null == averagePoints
            ? _value.averagePoints
            : averagePoints // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        matchDayStatus: null == matchDayStatus
            ? _value.matchDayStatus
            : matchDayStatus // ignore: cast_nullable_to_non_nullable
                  as int,
        lineupOrder: null == lineupOrder
            ? _value.lineupOrder
            : lineupOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        lastTotalPoints: null == lastTotalPoints
            ? _value.lastTotalPoints
            : lastTotalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        hasToday: null == hasToday
            ? _value.hasToday
            : hasToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        originalStatus: freezed == originalStatus
            ? _value.originalStatus
            : originalStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        performanceHistory: freezed == performanceHistory
            ? _value._performanceHistory
            : performanceHistory // ignore: cast_nullable_to_non_nullable
                  as List<PerformanceHistory>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupPlayerImpl implements _LineupPlayer {
  const _$LineupPlayerImpl({
    @JsonKey(name: 'i') required this.id,
    @JsonKey(name: 'n') required this.name,
    @JsonKey(name: 'pos') required this.position,
    @JsonKey(name: 'tid') required this.teamId,
    @JsonKey(name: 'ap') required this.averagePoints,
    @JsonKey(name: 'st') required this.totalPoints,
    @JsonKey(name: 'mdst') required this.matchDayStatus,
    @JsonKey(name: 'lo') required this.lineupOrder,
    @JsonKey(name: 'lst') required this.lastTotalPoints,
    @JsonKey(name: 'ht') required this.hasToday,
    @JsonKey(name: 'os') this.originalStatus,
    @JsonKey(name: 'ph') final List<PerformanceHistory>? performanceHistory,
  }) : _performanceHistory = performanceHistory;

  factory _$LineupPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupPlayerImplFromJson(json);

  /// Player ID
  @override
  @JsonKey(name: 'i')
  final String id;

  /// Player name
  @override
  @JsonKey(name: 'n')
  final String name;

  /// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
  @override
  @JsonKey(name: 'pos')
  final int position;

  /// Team ID
  @override
  @JsonKey(name: 'tid')
  final String teamId;

  /// Average points
  @override
  @JsonKey(name: 'ap')
  final int averagePoints;

  /// Total points
  @override
  @JsonKey(name: 'st')
  final int totalPoints;

  /// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
  @override
  @JsonKey(name: 'mdst')
  final int matchDayStatus;

  /// Lineup order (0 means on bench/not in lineup)
  @override
  @JsonKey(name: 'lo')
  final int lineupOrder;

  /// Last total points
  @override
  @JsonKey(name: 'lst')
  final int lastTotalPoints;

  /// Has today (if player plays today)
  @override
  @JsonKey(name: 'ht')
  final bool hasToday;

  /// Original status (e.g., injury/suspension info)
  @override
  @JsonKey(name: 'os')
  final String? originalStatus;

  /// Performance history
  final List<PerformanceHistory>? _performanceHistory;

  /// Performance history
  @override
  @JsonKey(name: 'ph')
  List<PerformanceHistory>? get performanceHistory {
    final value = _performanceHistory;
    if (value == null) return null;
    if (_performanceHistory is EqualUnmodifiableListView)
      return _performanceHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LineupPlayer(id: $id, name: $name, position: $position, teamId: $teamId, averagePoints: $averagePoints, totalPoints: $totalPoints, matchDayStatus: $matchDayStatus, lineupOrder: $lineupOrder, lastTotalPoints: $lastTotalPoints, hasToday: $hasToday, originalStatus: $originalStatus, performanceHistory: $performanceHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupPlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.averagePoints, averagePoints) ||
                other.averagePoints == averagePoints) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.matchDayStatus, matchDayStatus) ||
                other.matchDayStatus == matchDayStatus) &&
            (identical(other.lineupOrder, lineupOrder) ||
                other.lineupOrder == lineupOrder) &&
            (identical(other.lastTotalPoints, lastTotalPoints) ||
                other.lastTotalPoints == lastTotalPoints) &&
            (identical(other.hasToday, hasToday) ||
                other.hasToday == hasToday) &&
            (identical(other.originalStatus, originalStatus) ||
                other.originalStatus == originalStatus) &&
            const DeepCollectionEquality().equals(
              other._performanceHistory,
              _performanceHistory,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    position,
    teamId,
    averagePoints,
    totalPoints,
    matchDayStatus,
    lineupOrder,
    lastTotalPoints,
    hasToday,
    originalStatus,
    const DeepCollectionEquality().hash(_performanceHistory),
  );

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupPlayerImplCopyWith<_$LineupPlayerImpl> get copyWith =>
      __$$LineupPlayerImplCopyWithImpl<_$LineupPlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupPlayerImplToJson(this);
  }
}

abstract class _LineupPlayer implements LineupPlayer {
  const factory _LineupPlayer({
    @JsonKey(name: 'i') required final String id,
    @JsonKey(name: 'n') required final String name,
    @JsonKey(name: 'pos') required final int position,
    @JsonKey(name: 'tid') required final String teamId,
    @JsonKey(name: 'ap') required final int averagePoints,
    @JsonKey(name: 'st') required final int totalPoints,
    @JsonKey(name: 'mdst') required final int matchDayStatus,
    @JsonKey(name: 'lo') required final int lineupOrder,
    @JsonKey(name: 'lst') required final int lastTotalPoints,
    @JsonKey(name: 'ht') required final bool hasToday,
    @JsonKey(name: 'os') final String? originalStatus,
    @JsonKey(name: 'ph') final List<PerformanceHistory>? performanceHistory,
  }) = _$LineupPlayerImpl;

  factory _LineupPlayer.fromJson(Map<String, dynamic> json) =
      _$LineupPlayerImpl.fromJson;

  /// Player ID
  @override
  @JsonKey(name: 'i')
  String get id;

  /// Player name
  @override
  @JsonKey(name: 'n')
  String get name;

  /// Position (1=Torwart, 2=Abwehr, 3=Mittelfeld, 4=Sturm)
  @override
  @JsonKey(name: 'pos')
  int get position;

  /// Team ID
  @override
  @JsonKey(name: 'tid')
  String get teamId;

  /// Average points
  @override
  @JsonKey(name: 'ap')
  int get averagePoints;

  /// Total points
  @override
  @JsonKey(name: 'st')
  int get totalPoints;

  /// Match day status (0=fit, 1=verletzt, 2=gesperrt, etc.)
  @override
  @JsonKey(name: 'mdst')
  int get matchDayStatus;

  /// Lineup order (0 means on bench/not in lineup)
  @override
  @JsonKey(name: 'lo')
  int get lineupOrder;

  /// Last total points
  @override
  @JsonKey(name: 'lst')
  int get lastTotalPoints;

  /// Has today (if player plays today)
  @override
  @JsonKey(name: 'ht')
  bool get hasToday;

  /// Original status (e.g., injury/suspension info)
  @override
  @JsonKey(name: 'os')
  String? get originalStatus;

  /// Performance history
  @override
  @JsonKey(name: 'ph')
  List<PerformanceHistory>? get performanceHistory;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupPlayerImplCopyWith<_$LineupPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PerformanceHistory _$PerformanceHistoryFromJson(Map<String, dynamic> json) {
  return _PerformanceHistory.fromJson(json);
}

/// @nodoc
mixin _$PerformanceHistory {
  /// Points
  @JsonKey(name: 'p')
  int get points => throw _privateConstructorUsedError;

  /// Has played (if player played in this match)
  @JsonKey(name: 'hp')
  bool get hasPlayed => throw _privateConstructorUsedError;

  /// Serializes this PerformanceHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerformanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerformanceHistoryCopyWith<PerformanceHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerformanceHistoryCopyWith<$Res> {
  factory $PerformanceHistoryCopyWith(
    PerformanceHistory value,
    $Res Function(PerformanceHistory) then,
  ) = _$PerformanceHistoryCopyWithImpl<$Res, PerformanceHistory>;
  @useResult
  $Res call({
    @JsonKey(name: 'p') int points,
    @JsonKey(name: 'hp') bool hasPlayed,
  });
}

/// @nodoc
class _$PerformanceHistoryCopyWithImpl<$Res, $Val extends PerformanceHistory>
    implements $PerformanceHistoryCopyWith<$Res> {
  _$PerformanceHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerformanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? points = null, Object? hasPlayed = null}) {
    return _then(
      _value.copyWith(
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            hasPlayed: null == hasPlayed
                ? _value.hasPlayed
                : hasPlayed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PerformanceHistoryImplCopyWith<$Res>
    implements $PerformanceHistoryCopyWith<$Res> {
  factory _$$PerformanceHistoryImplCopyWith(
    _$PerformanceHistoryImpl value,
    $Res Function(_$PerformanceHistoryImpl) then,
  ) = __$$PerformanceHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'p') int points,
    @JsonKey(name: 'hp') bool hasPlayed,
  });
}

/// @nodoc
class __$$PerformanceHistoryImplCopyWithImpl<$Res>
    extends _$PerformanceHistoryCopyWithImpl<$Res, _$PerformanceHistoryImpl>
    implements _$$PerformanceHistoryImplCopyWith<$Res> {
  __$$PerformanceHistoryImplCopyWithImpl(
    _$PerformanceHistoryImpl _value,
    $Res Function(_$PerformanceHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PerformanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? points = null, Object? hasPlayed = null}) {
    return _then(
      _$PerformanceHistoryImpl(
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        hasPlayed: null == hasPlayed
            ? _value.hasPlayed
            : hasPlayed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PerformanceHistoryImpl implements _PerformanceHistory {
  const _$PerformanceHistoryImpl({
    @JsonKey(name: 'p') required this.points,
    @JsonKey(name: 'hp') required this.hasPlayed,
  });

  factory _$PerformanceHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerformanceHistoryImplFromJson(json);

  /// Points
  @override
  @JsonKey(name: 'p')
  final int points;

  /// Has played (if player played in this match)
  @override
  @JsonKey(name: 'hp')
  final bool hasPlayed;

  @override
  String toString() {
    return 'PerformanceHistory(points: $points, hasPlayed: $hasPlayed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerformanceHistoryImpl &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.hasPlayed, hasPlayed) ||
                other.hasPlayed == hasPlayed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, points, hasPlayed);

  /// Create a copy of PerformanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerformanceHistoryImplCopyWith<_$PerformanceHistoryImpl> get copyWith =>
      __$$PerformanceHistoryImplCopyWithImpl<_$PerformanceHistoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PerformanceHistoryImplToJson(this);
  }
}

abstract class _PerformanceHistory implements PerformanceHistory {
  const factory _PerformanceHistory({
    @JsonKey(name: 'p') required final int points,
    @JsonKey(name: 'hp') required final bool hasPlayed,
  }) = _$PerformanceHistoryImpl;

  factory _PerformanceHistory.fromJson(Map<String, dynamic> json) =
      _$PerformanceHistoryImpl.fromJson;

  /// Points
  @override
  @JsonKey(name: 'p')
  int get points;

  /// Has played (if player played in this match)
  @override
  @JsonKey(name: 'hp')
  bool get hasPlayed;

  /// Create a copy of PerformanceHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerformanceHistoryImplCopyWith<_$PerformanceHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LineupUpdateRequest _$LineupUpdateRequestFromJson(Map<String, dynamic> json) {
  return _LineupUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$LineupUpdateRequest {
  /// List of player IDs in lineup order (first 11 are starters, rest are bench)
  List<String> get playerIds => throw _privateConstructorUsedError;

  /// Serializes this LineupUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineupUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupUpdateRequestCopyWith<LineupUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupUpdateRequestCopyWith<$Res> {
  factory $LineupUpdateRequestCopyWith(
    LineupUpdateRequest value,
    $Res Function(LineupUpdateRequest) then,
  ) = _$LineupUpdateRequestCopyWithImpl<$Res, LineupUpdateRequest>;
  @useResult
  $Res call({List<String> playerIds});
}

/// @nodoc
class _$LineupUpdateRequestCopyWithImpl<$Res, $Val extends LineupUpdateRequest>
    implements $LineupUpdateRequestCopyWith<$Res> {
  _$LineupUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerIds = null}) {
    return _then(
      _value.copyWith(
            playerIds: null == playerIds
                ? _value.playerIds
                : playerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LineupUpdateRequestImplCopyWith<$Res>
    implements $LineupUpdateRequestCopyWith<$Res> {
  factory _$$LineupUpdateRequestImplCopyWith(
    _$LineupUpdateRequestImpl value,
    $Res Function(_$LineupUpdateRequestImpl) then,
  ) = __$$LineupUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> playerIds});
}

/// @nodoc
class __$$LineupUpdateRequestImplCopyWithImpl<$Res>
    extends _$LineupUpdateRequestCopyWithImpl<$Res, _$LineupUpdateRequestImpl>
    implements _$$LineupUpdateRequestImplCopyWith<$Res> {
  __$$LineupUpdateRequestImplCopyWithImpl(
    _$LineupUpdateRequestImpl _value,
    $Res Function(_$LineupUpdateRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LineupUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerIds = null}) {
    return _then(
      _$LineupUpdateRequestImpl(
        playerIds: null == playerIds
            ? _value._playerIds
            : playerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupUpdateRequestImpl implements _LineupUpdateRequest {
  const _$LineupUpdateRequestImpl({required final List<String> playerIds})
    : _playerIds = playerIds;

  factory _$LineupUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupUpdateRequestImplFromJson(json);

  /// List of player IDs in lineup order (first 11 are starters, rest are bench)
  final List<String> _playerIds;

  /// List of player IDs in lineup order (first 11 are starters, rest are bench)
  @override
  List<String> get playerIds {
    if (_playerIds is EqualUnmodifiableListView) return _playerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerIds);
  }

  @override
  String toString() {
    return 'LineupUpdateRequest(playerIds: $playerIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupUpdateRequestImpl &&
            const DeepCollectionEquality().equals(
              other._playerIds,
              _playerIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_playerIds));

  /// Create a copy of LineupUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupUpdateRequestImplCopyWith<_$LineupUpdateRequestImpl> get copyWith =>
      __$$LineupUpdateRequestImplCopyWithImpl<_$LineupUpdateRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupUpdateRequestImplToJson(this);
  }
}

abstract class _LineupUpdateRequest implements LineupUpdateRequest {
  const factory _LineupUpdateRequest({required final List<String> playerIds}) =
      _$LineupUpdateRequestImpl;

  factory _LineupUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$LineupUpdateRequestImpl.fromJson;

  /// List of player IDs in lineup order (first 11 are starters, rest are bench)
  @override
  List<String> get playerIds;

  /// Create a copy of LineupUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupUpdateRequestImplCopyWith<_$LineupUpdateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
