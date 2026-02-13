// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_recommendation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SalesRecommendation _$SalesRecommendationFromJson(Map<String, dynamic> json) {
  return _SalesRecommendation.fromJson(json);
}

/// @nodoc
mixin _$SalesRecommendation {
  String get id => throw _privateConstructorUsedError;
  Player get player => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  SalesPriority get priority => throw _privateConstructorUsedError;
  int get expectedValue => throw _privateConstructorUsedError;
  LineupImpact get impact => throw _privateConstructorUsedError;

  /// Serializes this SalesRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesRecommendationCopyWith<SalesRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesRecommendationCopyWith<$Res> {
  factory $SalesRecommendationCopyWith(
    SalesRecommendation value,
    $Res Function(SalesRecommendation) then,
  ) = _$SalesRecommendationCopyWithImpl<$Res, SalesRecommendation>;
  @useResult
  $Res call({
    String id,
    Player player,
    String reason,
    SalesPriority priority,
    int expectedValue,
    LineupImpact impact,
  });

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$SalesRecommendationCopyWithImpl<$Res, $Val extends SalesRecommendation>
    implements $SalesRecommendationCopyWith<$Res> {
  _$SalesRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player = null,
    Object? reason = null,
    Object? priority = null,
    Object? expectedValue = null,
    Object? impact = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as Player,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as SalesPriority,
            expectedValue: null == expectedValue
                ? _value.expectedValue
                : expectedValue // ignore: cast_nullable_to_non_nullable
                      as int,
            impact: null == impact
                ? _value.impact
                : impact // ignore: cast_nullable_to_non_nullable
                      as LineupImpact,
          )
          as $Val,
    );
  }

  /// Create a copy of SalesRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SalesRecommendationImplCopyWith<$Res>
    implements $SalesRecommendationCopyWith<$Res> {
  factory _$$SalesRecommendationImplCopyWith(
    _$SalesRecommendationImpl value,
    $Res Function(_$SalesRecommendationImpl) then,
  ) = __$$SalesRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Player player,
    String reason,
    SalesPriority priority,
    int expectedValue,
    LineupImpact impact,
  });

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$SalesRecommendationImplCopyWithImpl<$Res>
    extends _$SalesRecommendationCopyWithImpl<$Res, _$SalesRecommendationImpl>
    implements _$$SalesRecommendationImplCopyWith<$Res> {
  __$$SalesRecommendationImplCopyWithImpl(
    _$SalesRecommendationImpl _value,
    $Res Function(_$SalesRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SalesRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? player = null,
    Object? reason = null,
    Object? priority = null,
    Object? expectedValue = null,
    Object? impact = null,
  }) {
    return _then(
      _$SalesRecommendationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as Player,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as SalesPriority,
        expectedValue: null == expectedValue
            ? _value.expectedValue
            : expectedValue // ignore: cast_nullable_to_non_nullable
                  as int,
        impact: null == impact
            ? _value.impact
            : impact // ignore: cast_nullable_to_non_nullable
                  as LineupImpact,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesRecommendationImpl implements _SalesRecommendation {
  const _$SalesRecommendationImpl({
    required this.id,
    required this.player,
    required this.reason,
    required this.priority,
    required this.expectedValue,
    required this.impact,
  });

  factory _$SalesRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  final Player player;
  @override
  final String reason;
  @override
  final SalesPriority priority;
  @override
  final int expectedValue;
  @override
  final LineupImpact impact;

  @override
  String toString() {
    return 'SalesRecommendation(id: $id, player: $player, reason: $reason, priority: $priority, expectedValue: $expectedValue, impact: $impact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.expectedValue, expectedValue) ||
                other.expectedValue == expectedValue) &&
            (identical(other.impact, impact) || other.impact == impact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    player,
    reason,
    priority,
    expectedValue,
    impact,
  );

  /// Create a copy of SalesRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesRecommendationImplCopyWith<_$SalesRecommendationImpl> get copyWith =>
      __$$SalesRecommendationImplCopyWithImpl<_$SalesRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesRecommendationImplToJson(this);
  }
}

abstract class _SalesRecommendation implements SalesRecommendation {
  const factory _SalesRecommendation({
    required final String id,
    required final Player player,
    required final String reason,
    required final SalesPriority priority,
    required final int expectedValue,
    required final LineupImpact impact,
  }) = _$SalesRecommendationImpl;

  factory _SalesRecommendation.fromJson(Map<String, dynamic> json) =
      _$SalesRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  Player get player;
  @override
  String get reason;
  @override
  SalesPriority get priority;
  @override
  int get expectedValue;
  @override
  LineupImpact get impact;

  /// Create a copy of SalesRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesRecommendationImplCopyWith<_$SalesRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
