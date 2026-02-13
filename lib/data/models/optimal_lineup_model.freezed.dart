// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimal_lineup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OptimalLineup _$OptimalLineupFromJson(Map<String, dynamic> json) {
  return _OptimalLineup.fromJson(json);
}

/// @nodoc
mixin _$OptimalLineup {
  Player? get goalkeeper => throw _privateConstructorUsedError;
  List<Player> get defenders => throw _privateConstructorUsedError;
  List<Player> get midfielders => throw _privateConstructorUsedError;
  List<Player> get forwards => throw _privateConstructorUsedError;

  /// Serializes this OptimalLineup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptimalLineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptimalLineupCopyWith<OptimalLineup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimalLineupCopyWith<$Res> {
  factory $OptimalLineupCopyWith(
    OptimalLineup value,
    $Res Function(OptimalLineup) then,
  ) = _$OptimalLineupCopyWithImpl<$Res, OptimalLineup>;
  @useResult
  $Res call({
    Player? goalkeeper,
    List<Player> defenders,
    List<Player> midfielders,
    List<Player> forwards,
  });

  $PlayerCopyWith<$Res>? get goalkeeper;
}

/// @nodoc
class _$OptimalLineupCopyWithImpl<$Res, $Val extends OptimalLineup>
    implements $OptimalLineupCopyWith<$Res> {
  _$OptimalLineupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptimalLineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goalkeeper = freezed,
    Object? defenders = null,
    Object? midfielders = null,
    Object? forwards = null,
  }) {
    return _then(
      _value.copyWith(
            goalkeeper: freezed == goalkeeper
                ? _value.goalkeeper
                : goalkeeper // ignore: cast_nullable_to_non_nullable
                      as Player?,
            defenders: null == defenders
                ? _value.defenders
                : defenders // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            midfielders: null == midfielders
                ? _value.midfielders
                : midfielders // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            forwards: null == forwards
                ? _value.forwards
                : forwards // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
          )
          as $Val,
    );
  }

  /// Create a copy of OptimalLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res>? get goalkeeper {
    if (_value.goalkeeper == null) {
      return null;
    }

    return $PlayerCopyWith<$Res>(_value.goalkeeper!, (value) {
      return _then(_value.copyWith(goalkeeper: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OptimalLineupImplCopyWith<$Res>
    implements $OptimalLineupCopyWith<$Res> {
  factory _$$OptimalLineupImplCopyWith(
    _$OptimalLineupImpl value,
    $Res Function(_$OptimalLineupImpl) then,
  ) = __$$OptimalLineupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Player? goalkeeper,
    List<Player> defenders,
    List<Player> midfielders,
    List<Player> forwards,
  });

  @override
  $PlayerCopyWith<$Res>? get goalkeeper;
}

/// @nodoc
class __$$OptimalLineupImplCopyWithImpl<$Res>
    extends _$OptimalLineupCopyWithImpl<$Res, _$OptimalLineupImpl>
    implements _$$OptimalLineupImplCopyWith<$Res> {
  __$$OptimalLineupImplCopyWithImpl(
    _$OptimalLineupImpl _value,
    $Res Function(_$OptimalLineupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OptimalLineup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goalkeeper = freezed,
    Object? defenders = null,
    Object? midfielders = null,
    Object? forwards = null,
  }) {
    return _then(
      _$OptimalLineupImpl(
        goalkeeper: freezed == goalkeeper
            ? _value.goalkeeper
            : goalkeeper // ignore: cast_nullable_to_non_nullable
                  as Player?,
        defenders: null == defenders
            ? _value._defenders
            : defenders // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        midfielders: null == midfielders
            ? _value._midfielders
            : midfielders // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        forwards: null == forwards
            ? _value._forwards
            : forwards // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OptimalLineupImpl implements _OptimalLineup {
  const _$OptimalLineupImpl({
    required this.goalkeeper,
    required final List<Player> defenders,
    required final List<Player> midfielders,
    required final List<Player> forwards,
  }) : _defenders = defenders,
       _midfielders = midfielders,
       _forwards = forwards;

  factory _$OptimalLineupImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptimalLineupImplFromJson(json);

  @override
  final Player? goalkeeper;
  final List<Player> _defenders;
  @override
  List<Player> get defenders {
    if (_defenders is EqualUnmodifiableListView) return _defenders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defenders);
  }

  final List<Player> _midfielders;
  @override
  List<Player> get midfielders {
    if (_midfielders is EqualUnmodifiableListView) return _midfielders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_midfielders);
  }

  final List<Player> _forwards;
  @override
  List<Player> get forwards {
    if (_forwards is EqualUnmodifiableListView) return _forwards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_forwards);
  }

  @override
  String toString() {
    return 'OptimalLineup(goalkeeper: $goalkeeper, defenders: $defenders, midfielders: $midfielders, forwards: $forwards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptimalLineupImpl &&
            (identical(other.goalkeeper, goalkeeper) ||
                other.goalkeeper == goalkeeper) &&
            const DeepCollectionEquality().equals(
              other._defenders,
              _defenders,
            ) &&
            const DeepCollectionEquality().equals(
              other._midfielders,
              _midfielders,
            ) &&
            const DeepCollectionEquality().equals(other._forwards, _forwards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    goalkeeper,
    const DeepCollectionEquality().hash(_defenders),
    const DeepCollectionEquality().hash(_midfielders),
    const DeepCollectionEquality().hash(_forwards),
  );

  /// Create a copy of OptimalLineup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptimalLineupImplCopyWith<_$OptimalLineupImpl> get copyWith =>
      __$$OptimalLineupImplCopyWithImpl<_$OptimalLineupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OptimalLineupImplToJson(this);
  }
}

abstract class _OptimalLineup implements OptimalLineup {
  const factory _OptimalLineup({
    required final Player? goalkeeper,
    required final List<Player> defenders,
    required final List<Player> midfielders,
    required final List<Player> forwards,
  }) = _$OptimalLineupImpl;

  factory _OptimalLineup.fromJson(Map<String, dynamic> json) =
      _$OptimalLineupImpl.fromJson;

  @override
  Player? get goalkeeper;
  @override
  List<Player> get defenders;
  @override
  List<Player> get midfielders;
  @override
  List<Player> get forwards;

  /// Create a copy of OptimalLineup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptimalLineupImplCopyWith<_$OptimalLineupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LineupComparison _$LineupComparisonFromJson(Map<String, dynamic> json) {
  return _LineupComparison.fromJson(json);
}

/// @nodoc
mixin _$LineupComparison {
  OptimalLineup get currentLineup => throw _privateConstructorUsedError;
  OptimalLineup get optimalLineup => throw _privateConstructorUsedError;
  double get currentScore => throw _privateConstructorUsedError;
  double get optimalScore => throw _privateConstructorUsedError;
  List<Player> get suggestedAdditions => throw _privateConstructorUsedError;
  List<Player> get suggestedRemovals => throw _privateConstructorUsedError;

  /// Serializes this LineupComparison to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupComparisonCopyWith<LineupComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupComparisonCopyWith<$Res> {
  factory $LineupComparisonCopyWith(
    LineupComparison value,
    $Res Function(LineupComparison) then,
  ) = _$LineupComparisonCopyWithImpl<$Res, LineupComparison>;
  @useResult
  $Res call({
    OptimalLineup currentLineup,
    OptimalLineup optimalLineup,
    double currentScore,
    double optimalScore,
    List<Player> suggestedAdditions,
    List<Player> suggestedRemovals,
  });

  $OptimalLineupCopyWith<$Res> get currentLineup;
  $OptimalLineupCopyWith<$Res> get optimalLineup;
}

/// @nodoc
class _$LineupComparisonCopyWithImpl<$Res, $Val extends LineupComparison>
    implements $LineupComparisonCopyWith<$Res> {
  _$LineupComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLineup = null,
    Object? optimalLineup = null,
    Object? currentScore = null,
    Object? optimalScore = null,
    Object? suggestedAdditions = null,
    Object? suggestedRemovals = null,
  }) {
    return _then(
      _value.copyWith(
            currentLineup: null == currentLineup
                ? _value.currentLineup
                : currentLineup // ignore: cast_nullable_to_non_nullable
                      as OptimalLineup,
            optimalLineup: null == optimalLineup
                ? _value.optimalLineup
                : optimalLineup // ignore: cast_nullable_to_non_nullable
                      as OptimalLineup,
            currentScore: null == currentScore
                ? _value.currentScore
                : currentScore // ignore: cast_nullable_to_non_nullable
                      as double,
            optimalScore: null == optimalScore
                ? _value.optimalScore
                : optimalScore // ignore: cast_nullable_to_non_nullable
                      as double,
            suggestedAdditions: null == suggestedAdditions
                ? _value.suggestedAdditions
                : suggestedAdditions // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            suggestedRemovals: null == suggestedRemovals
                ? _value.suggestedRemovals
                : suggestedRemovals // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
          )
          as $Val,
    );
  }

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OptimalLineupCopyWith<$Res> get currentLineup {
    return $OptimalLineupCopyWith<$Res>(_value.currentLineup, (value) {
      return _then(_value.copyWith(currentLineup: value) as $Val);
    });
  }

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OptimalLineupCopyWith<$Res> get optimalLineup {
    return $OptimalLineupCopyWith<$Res>(_value.optimalLineup, (value) {
      return _then(_value.copyWith(optimalLineup: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LineupComparisonImplCopyWith<$Res>
    implements $LineupComparisonCopyWith<$Res> {
  factory _$$LineupComparisonImplCopyWith(
    _$LineupComparisonImpl value,
    $Res Function(_$LineupComparisonImpl) then,
  ) = __$$LineupComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    OptimalLineup currentLineup,
    OptimalLineup optimalLineup,
    double currentScore,
    double optimalScore,
    List<Player> suggestedAdditions,
    List<Player> suggestedRemovals,
  });

  @override
  $OptimalLineupCopyWith<$Res> get currentLineup;
  @override
  $OptimalLineupCopyWith<$Res> get optimalLineup;
}

/// @nodoc
class __$$LineupComparisonImplCopyWithImpl<$Res>
    extends _$LineupComparisonCopyWithImpl<$Res, _$LineupComparisonImpl>
    implements _$$LineupComparisonImplCopyWith<$Res> {
  __$$LineupComparisonImplCopyWithImpl(
    _$LineupComparisonImpl _value,
    $Res Function(_$LineupComparisonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentLineup = null,
    Object? optimalLineup = null,
    Object? currentScore = null,
    Object? optimalScore = null,
    Object? suggestedAdditions = null,
    Object? suggestedRemovals = null,
  }) {
    return _then(
      _$LineupComparisonImpl(
        currentLineup: null == currentLineup
            ? _value.currentLineup
            : currentLineup // ignore: cast_nullable_to_non_nullable
                  as OptimalLineup,
        optimalLineup: null == optimalLineup
            ? _value.optimalLineup
            : optimalLineup // ignore: cast_nullable_to_non_nullable
                  as OptimalLineup,
        currentScore: null == currentScore
            ? _value.currentScore
            : currentScore // ignore: cast_nullable_to_non_nullable
                  as double,
        optimalScore: null == optimalScore
            ? _value.optimalScore
            : optimalScore // ignore: cast_nullable_to_non_nullable
                  as double,
        suggestedAdditions: null == suggestedAdditions
            ? _value._suggestedAdditions
            : suggestedAdditions // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        suggestedRemovals: null == suggestedRemovals
            ? _value._suggestedRemovals
            : suggestedRemovals // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupComparisonImpl implements _LineupComparison {
  const _$LineupComparisonImpl({
    required this.currentLineup,
    required this.optimalLineup,
    required this.currentScore,
    required this.optimalScore,
    required final List<Player> suggestedAdditions,
    required final List<Player> suggestedRemovals,
  }) : _suggestedAdditions = suggestedAdditions,
       _suggestedRemovals = suggestedRemovals;

  factory _$LineupComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupComparisonImplFromJson(json);

  @override
  final OptimalLineup currentLineup;
  @override
  final OptimalLineup optimalLineup;
  @override
  final double currentScore;
  @override
  final double optimalScore;
  final List<Player> _suggestedAdditions;
  @override
  List<Player> get suggestedAdditions {
    if (_suggestedAdditions is EqualUnmodifiableListView)
      return _suggestedAdditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedAdditions);
  }

  final List<Player> _suggestedRemovals;
  @override
  List<Player> get suggestedRemovals {
    if (_suggestedRemovals is EqualUnmodifiableListView)
      return _suggestedRemovals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedRemovals);
  }

  @override
  String toString() {
    return 'LineupComparison(currentLineup: $currentLineup, optimalLineup: $optimalLineup, currentScore: $currentScore, optimalScore: $optimalScore, suggestedAdditions: $suggestedAdditions, suggestedRemovals: $suggestedRemovals)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupComparisonImpl &&
            (identical(other.currentLineup, currentLineup) ||
                other.currentLineup == currentLineup) &&
            (identical(other.optimalLineup, optimalLineup) ||
                other.optimalLineup == optimalLineup) &&
            (identical(other.currentScore, currentScore) ||
                other.currentScore == currentScore) &&
            (identical(other.optimalScore, optimalScore) ||
                other.optimalScore == optimalScore) &&
            const DeepCollectionEquality().equals(
              other._suggestedAdditions,
              _suggestedAdditions,
            ) &&
            const DeepCollectionEquality().equals(
              other._suggestedRemovals,
              _suggestedRemovals,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentLineup,
    optimalLineup,
    currentScore,
    optimalScore,
    const DeepCollectionEquality().hash(_suggestedAdditions),
    const DeepCollectionEquality().hash(_suggestedRemovals),
  );

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupComparisonImplCopyWith<_$LineupComparisonImpl> get copyWith =>
      __$$LineupComparisonImplCopyWithImpl<_$LineupComparisonImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupComparisonImplToJson(this);
  }
}

abstract class _LineupComparison implements LineupComparison {
  const factory _LineupComparison({
    required final OptimalLineup currentLineup,
    required final OptimalLineup optimalLineup,
    required final double currentScore,
    required final double optimalScore,
    required final List<Player> suggestedAdditions,
    required final List<Player> suggestedRemovals,
  }) = _$LineupComparisonImpl;

  factory _LineupComparison.fromJson(Map<String, dynamic> json) =
      _$LineupComparisonImpl.fromJson;

  @override
  OptimalLineup get currentLineup;
  @override
  OptimalLineup get optimalLineup;
  @override
  double get currentScore;
  @override
  double get optimalScore;
  @override
  List<Player> get suggestedAdditions;
  @override
  List<Player> get suggestedRemovals;

  /// Create a copy of LineupComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupComparisonImplCopyWith<_$LineupComparisonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
