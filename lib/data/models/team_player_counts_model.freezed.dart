// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_player_counts_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamPlayerCounts _$TeamPlayerCountsFromJson(Map<String, dynamic> json) {
  return _TeamPlayerCounts.fromJson(json);
}

/// @nodoc
mixin _$TeamPlayerCounts {
  int get total => throw _privateConstructorUsedError;
  int get goalkeepers => throw _privateConstructorUsedError;
  int get defenders => throw _privateConstructorUsedError;
  int get midfielders => throw _privateConstructorUsedError;
  int get forwards => throw _privateConstructorUsedError;

  /// Serializes this TeamPlayerCounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamPlayerCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamPlayerCountsCopyWith<TeamPlayerCounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamPlayerCountsCopyWith<$Res> {
  factory $TeamPlayerCountsCopyWith(
    TeamPlayerCounts value,
    $Res Function(TeamPlayerCounts) then,
  ) = _$TeamPlayerCountsCopyWithImpl<$Res, TeamPlayerCounts>;
  @useResult
  $Res call({
    int total,
    int goalkeepers,
    int defenders,
    int midfielders,
    int forwards,
  });
}

/// @nodoc
class _$TeamPlayerCountsCopyWithImpl<$Res, $Val extends TeamPlayerCounts>
    implements $TeamPlayerCountsCopyWith<$Res> {
  _$TeamPlayerCountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamPlayerCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? goalkeepers = null,
    Object? defenders = null,
    Object? midfielders = null,
    Object? forwards = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            goalkeepers: null == goalkeepers
                ? _value.goalkeepers
                : goalkeepers // ignore: cast_nullable_to_non_nullable
                      as int,
            defenders: null == defenders
                ? _value.defenders
                : defenders // ignore: cast_nullable_to_non_nullable
                      as int,
            midfielders: null == midfielders
                ? _value.midfielders
                : midfielders // ignore: cast_nullable_to_non_nullable
                      as int,
            forwards: null == forwards
                ? _value.forwards
                : forwards // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamPlayerCountsImplCopyWith<$Res>
    implements $TeamPlayerCountsCopyWith<$Res> {
  factory _$$TeamPlayerCountsImplCopyWith(
    _$TeamPlayerCountsImpl value,
    $Res Function(_$TeamPlayerCountsImpl) then,
  ) = __$$TeamPlayerCountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int total,
    int goalkeepers,
    int defenders,
    int midfielders,
    int forwards,
  });
}

/// @nodoc
class __$$TeamPlayerCountsImplCopyWithImpl<$Res>
    extends _$TeamPlayerCountsCopyWithImpl<$Res, _$TeamPlayerCountsImpl>
    implements _$$TeamPlayerCountsImplCopyWith<$Res> {
  __$$TeamPlayerCountsImplCopyWithImpl(
    _$TeamPlayerCountsImpl _value,
    $Res Function(_$TeamPlayerCountsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamPlayerCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? goalkeepers = null,
    Object? defenders = null,
    Object? midfielders = null,
    Object? forwards = null,
  }) {
    return _then(
      _$TeamPlayerCountsImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        goalkeepers: null == goalkeepers
            ? _value.goalkeepers
            : goalkeepers // ignore: cast_nullable_to_non_nullable
                  as int,
        defenders: null == defenders
            ? _value.defenders
            : defenders // ignore: cast_nullable_to_non_nullable
                  as int,
        midfielders: null == midfielders
            ? _value.midfielders
            : midfielders // ignore: cast_nullable_to_non_nullable
                  as int,
        forwards: null == forwards
            ? _value.forwards
            : forwards // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamPlayerCountsImpl implements _TeamPlayerCounts {
  const _$TeamPlayerCountsImpl({
    required this.total,
    required this.goalkeepers,
    required this.defenders,
    required this.midfielders,
    required this.forwards,
  });

  factory _$TeamPlayerCountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamPlayerCountsImplFromJson(json);

  @override
  final int total;
  @override
  final int goalkeepers;
  @override
  final int defenders;
  @override
  final int midfielders;
  @override
  final int forwards;

  @override
  String toString() {
    return 'TeamPlayerCounts(total: $total, goalkeepers: $goalkeepers, defenders: $defenders, midfielders: $midfielders, forwards: $forwards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamPlayerCountsImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.goalkeepers, goalkeepers) ||
                other.goalkeepers == goalkeepers) &&
            (identical(other.defenders, defenders) ||
                other.defenders == defenders) &&
            (identical(other.midfielders, midfielders) ||
                other.midfielders == midfielders) &&
            (identical(other.forwards, forwards) ||
                other.forwards == forwards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    total,
    goalkeepers,
    defenders,
    midfielders,
    forwards,
  );

  /// Create a copy of TeamPlayerCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamPlayerCountsImplCopyWith<_$TeamPlayerCountsImpl> get copyWith =>
      __$$TeamPlayerCountsImplCopyWithImpl<_$TeamPlayerCountsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamPlayerCountsImplToJson(this);
  }
}

abstract class _TeamPlayerCounts implements TeamPlayerCounts {
  const factory _TeamPlayerCounts({
    required final int total,
    required final int goalkeepers,
    required final int defenders,
    required final int midfielders,
    required final int forwards,
  }) = _$TeamPlayerCountsImpl;

  factory _TeamPlayerCounts.fromJson(Map<String, dynamic> json) =
      _$TeamPlayerCountsImpl.fromJson;

  @override
  int get total;
  @override
  int get goalkeepers;
  @override
  int get defenders;
  @override
  int get midfielders;
  @override
  int get forwards;

  /// Create a copy of TeamPlayerCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamPlayerCountsImplCopyWith<_$TeamPlayerCountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FixtureAnalysis _$FixtureAnalysisFromJson(Map<String, dynamic> json) {
  return _FixtureAnalysis.fromJson(json);
}

/// @nodoc
mixin _$FixtureAnalysis {
  double get averageDifficulty => throw _privateConstructorUsedError;
  int get topTeamOpponents => throw _privateConstructorUsedError;
  int get difficultAwayGames => throw _privateConstructorUsedError;
  int get totalMatches => throw _privateConstructorUsedError;

  /// Serializes this FixtureAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FixtureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FixtureAnalysisCopyWith<FixtureAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FixtureAnalysisCopyWith<$Res> {
  factory $FixtureAnalysisCopyWith(
    FixtureAnalysis value,
    $Res Function(FixtureAnalysis) then,
  ) = _$FixtureAnalysisCopyWithImpl<$Res, FixtureAnalysis>;
  @useResult
  $Res call({
    double averageDifficulty,
    int topTeamOpponents,
    int difficultAwayGames,
    int totalMatches,
  });
}

/// @nodoc
class _$FixtureAnalysisCopyWithImpl<$Res, $Val extends FixtureAnalysis>
    implements $FixtureAnalysisCopyWith<$Res> {
  _$FixtureAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FixtureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageDifficulty = null,
    Object? topTeamOpponents = null,
    Object? difficultAwayGames = null,
    Object? totalMatches = null,
  }) {
    return _then(
      _value.copyWith(
            averageDifficulty: null == averageDifficulty
                ? _value.averageDifficulty
                : averageDifficulty // ignore: cast_nullable_to_non_nullable
                      as double,
            topTeamOpponents: null == topTeamOpponents
                ? _value.topTeamOpponents
                : topTeamOpponents // ignore: cast_nullable_to_non_nullable
                      as int,
            difficultAwayGames: null == difficultAwayGames
                ? _value.difficultAwayGames
                : difficultAwayGames // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMatches: null == totalMatches
                ? _value.totalMatches
                : totalMatches // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FixtureAnalysisImplCopyWith<$Res>
    implements $FixtureAnalysisCopyWith<$Res> {
  factory _$$FixtureAnalysisImplCopyWith(
    _$FixtureAnalysisImpl value,
    $Res Function(_$FixtureAnalysisImpl) then,
  ) = __$$FixtureAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double averageDifficulty,
    int topTeamOpponents,
    int difficultAwayGames,
    int totalMatches,
  });
}

/// @nodoc
class __$$FixtureAnalysisImplCopyWithImpl<$Res>
    extends _$FixtureAnalysisCopyWithImpl<$Res, _$FixtureAnalysisImpl>
    implements _$$FixtureAnalysisImplCopyWith<$Res> {
  __$$FixtureAnalysisImplCopyWithImpl(
    _$FixtureAnalysisImpl _value,
    $Res Function(_$FixtureAnalysisImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FixtureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageDifficulty = null,
    Object? topTeamOpponents = null,
    Object? difficultAwayGames = null,
    Object? totalMatches = null,
  }) {
    return _then(
      _$FixtureAnalysisImpl(
        averageDifficulty: null == averageDifficulty
            ? _value.averageDifficulty
            : averageDifficulty // ignore: cast_nullable_to_non_nullable
                  as double,
        topTeamOpponents: null == topTeamOpponents
            ? _value.topTeamOpponents
            : topTeamOpponents // ignore: cast_nullable_to_non_nullable
                  as int,
        difficultAwayGames: null == difficultAwayGames
            ? _value.difficultAwayGames
            : difficultAwayGames // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMatches: null == totalMatches
            ? _value.totalMatches
            : totalMatches // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FixtureAnalysisImpl implements _FixtureAnalysis {
  const _$FixtureAnalysisImpl({
    required this.averageDifficulty,
    required this.topTeamOpponents,
    required this.difficultAwayGames,
    required this.totalMatches,
  });

  factory _$FixtureAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$FixtureAnalysisImplFromJson(json);

  @override
  final double averageDifficulty;
  @override
  final int topTeamOpponents;
  @override
  final int difficultAwayGames;
  @override
  final int totalMatches;

  @override
  String toString() {
    return 'FixtureAnalysis(averageDifficulty: $averageDifficulty, topTeamOpponents: $topTeamOpponents, difficultAwayGames: $difficultAwayGames, totalMatches: $totalMatches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FixtureAnalysisImpl &&
            (identical(other.averageDifficulty, averageDifficulty) ||
                other.averageDifficulty == averageDifficulty) &&
            (identical(other.topTeamOpponents, topTeamOpponents) ||
                other.topTeamOpponents == topTeamOpponents) &&
            (identical(other.difficultAwayGames, difficultAwayGames) ||
                other.difficultAwayGames == difficultAwayGames) &&
            (identical(other.totalMatches, totalMatches) ||
                other.totalMatches == totalMatches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageDifficulty,
    topTeamOpponents,
    difficultAwayGames,
    totalMatches,
  );

  /// Create a copy of FixtureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FixtureAnalysisImplCopyWith<_$FixtureAnalysisImpl> get copyWith =>
      __$$FixtureAnalysisImplCopyWithImpl<_$FixtureAnalysisImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FixtureAnalysisImplToJson(this);
  }
}

abstract class _FixtureAnalysis implements FixtureAnalysis {
  const factory _FixtureAnalysis({
    required final double averageDifficulty,
    required final int topTeamOpponents,
    required final int difficultAwayGames,
    required final int totalMatches,
  }) = _$FixtureAnalysisImpl;

  factory _FixtureAnalysis.fromJson(Map<String, dynamic> json) =
      _$FixtureAnalysisImpl.fromJson;

  @override
  double get averageDifficulty;
  @override
  int get topTeamOpponents;
  @override
  int get difficultAwayGames;
  @override
  int get totalMatches;

  /// Create a copy of FixtureAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FixtureAnalysisImplCopyWith<_$FixtureAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
