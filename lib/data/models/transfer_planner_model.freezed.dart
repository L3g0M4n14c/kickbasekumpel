// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_planner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransferPlannerInput _$TransferPlannerInputFromJson(Map<String, dynamic> json) {
  return _TransferPlannerInput.fromJson(json);
}

/// @nodoc
mixin _$TransferPlannerInput {
  List<Player> get squadPlayers => throw _privateConstructorUsedError;
  List<Player> get marketPlayers => throw _privateConstructorUsedError;
  int get currentBudget => throw _privateConstructorUsedError;

  /// Serializes this TransferPlannerInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferPlannerInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferPlannerInputCopyWith<TransferPlannerInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferPlannerInputCopyWith<$Res> {
  factory $TransferPlannerInputCopyWith(
    TransferPlannerInput value,
    $Res Function(TransferPlannerInput) then,
  ) = _$TransferPlannerInputCopyWithImpl<$Res, TransferPlannerInput>;
  @useResult
  $Res call({
    List<Player> squadPlayers,
    List<Player> marketPlayers,
    int currentBudget,
  });
}

/// @nodoc
class _$TransferPlannerInputCopyWithImpl<
  $Res,
  $Val extends TransferPlannerInput
>
    implements $TransferPlannerInputCopyWith<$Res> {
  _$TransferPlannerInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferPlannerInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? squadPlayers = null,
    Object? marketPlayers = null,
    Object? currentBudget = null,
  }) {
    return _then(
      _value.copyWith(
            squadPlayers: null == squadPlayers
                ? _value.squadPlayers
                : squadPlayers // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            marketPlayers: null == marketPlayers
                ? _value.marketPlayers
                : marketPlayers // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            currentBudget: null == currentBudget
                ? _value.currentBudget
                : currentBudget // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferPlannerInputImplCopyWith<$Res>
    implements $TransferPlannerInputCopyWith<$Res> {
  factory _$$TransferPlannerInputImplCopyWith(
    _$TransferPlannerInputImpl value,
    $Res Function(_$TransferPlannerInputImpl) then,
  ) = __$$TransferPlannerInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Player> squadPlayers,
    List<Player> marketPlayers,
    int currentBudget,
  });
}

/// @nodoc
class __$$TransferPlannerInputImplCopyWithImpl<$Res>
    extends _$TransferPlannerInputCopyWithImpl<$Res, _$TransferPlannerInputImpl>
    implements _$$TransferPlannerInputImplCopyWith<$Res> {
  __$$TransferPlannerInputImplCopyWithImpl(
    _$TransferPlannerInputImpl _value,
    $Res Function(_$TransferPlannerInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferPlannerInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? squadPlayers = null,
    Object? marketPlayers = null,
    Object? currentBudget = null,
  }) {
    return _then(
      _$TransferPlannerInputImpl(
        squadPlayers: null == squadPlayers
            ? _value._squadPlayers
            : squadPlayers // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        marketPlayers: null == marketPlayers
            ? _value._marketPlayers
            : marketPlayers // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        currentBudget: null == currentBudget
            ? _value.currentBudget
            : currentBudget // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPlannerInputImpl implements _TransferPlannerInput {
  const _$TransferPlannerInputImpl({
    required final List<Player> squadPlayers,
    required final List<Player> marketPlayers,
    required this.currentBudget,
  }) : _squadPlayers = squadPlayers,
       _marketPlayers = marketPlayers;

  factory _$TransferPlannerInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPlannerInputImplFromJson(json);

  final List<Player> _squadPlayers;
  @override
  List<Player> get squadPlayers {
    if (_squadPlayers is EqualUnmodifiableListView) return _squadPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_squadPlayers);
  }

  final List<Player> _marketPlayers;
  @override
  List<Player> get marketPlayers {
    if (_marketPlayers is EqualUnmodifiableListView) return _marketPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_marketPlayers);
  }

  @override
  final int currentBudget;

  @override
  String toString() {
    return 'TransferPlannerInput(squadPlayers: $squadPlayers, marketPlayers: $marketPlayers, currentBudget: $currentBudget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPlannerInputImpl &&
            const DeepCollectionEquality().equals(
              other._squadPlayers,
              _squadPlayers,
            ) &&
            const DeepCollectionEquality().equals(
              other._marketPlayers,
              _marketPlayers,
            ) &&
            (identical(other.currentBudget, currentBudget) ||
                other.currentBudget == currentBudget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_squadPlayers),
    const DeepCollectionEquality().hash(_marketPlayers),
    currentBudget,
  );

  /// Create a copy of TransferPlannerInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPlannerInputImplCopyWith<_$TransferPlannerInputImpl>
  get copyWith =>
      __$$TransferPlannerInputImplCopyWithImpl<_$TransferPlannerInputImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPlannerInputImplToJson(this);
  }
}

abstract class _TransferPlannerInput implements TransferPlannerInput {
  const factory _TransferPlannerInput({
    required final List<Player> squadPlayers,
    required final List<Player> marketPlayers,
    required final int currentBudget,
  }) = _$TransferPlannerInputImpl;

  factory _TransferPlannerInput.fromJson(Map<String, dynamic> json) =
      _$TransferPlannerInputImpl.fromJson;

  @override
  List<Player> get squadPlayers;
  @override
  List<Player> get marketPlayers;
  @override
  int get currentBudget;

  /// Create a copy of TransferPlannerInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferPlannerInputImplCopyWith<_$TransferPlannerInputImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TransferPlanScore _$TransferPlanScoreFromJson(Map<String, dynamic> json) {
  return _TransferPlanScore.fromJson(json);
}

/// @nodoc
mixin _$TransferPlanScore {
  double get startingElevenGain => throw _privateConstructorUsedError;
  double get executionRisk => throw _privateConstructorUsedError;
  double get valueStability => throw _privateConstructorUsedError;

  /// Serializes this TransferPlanScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferPlanScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferPlanScoreCopyWith<TransferPlanScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferPlanScoreCopyWith<$Res> {
  factory $TransferPlanScoreCopyWith(
    TransferPlanScore value,
    $Res Function(TransferPlanScore) then,
  ) = _$TransferPlanScoreCopyWithImpl<$Res, TransferPlanScore>;
  @useResult
  $Res call({
    double startingElevenGain,
    double executionRisk,
    double valueStability,
  });
}

/// @nodoc
class _$TransferPlanScoreCopyWithImpl<$Res, $Val extends TransferPlanScore>
    implements $TransferPlanScoreCopyWith<$Res> {
  _$TransferPlanScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferPlanScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startingElevenGain = null,
    Object? executionRisk = null,
    Object? valueStability = null,
  }) {
    return _then(
      _value.copyWith(
            startingElevenGain: null == startingElevenGain
                ? _value.startingElevenGain
                : startingElevenGain // ignore: cast_nullable_to_non_nullable
                      as double,
            executionRisk: null == executionRisk
                ? _value.executionRisk
                : executionRisk // ignore: cast_nullable_to_non_nullable
                      as double,
            valueStability: null == valueStability
                ? _value.valueStability
                : valueStability // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferPlanScoreImplCopyWith<$Res>
    implements $TransferPlanScoreCopyWith<$Res> {
  factory _$$TransferPlanScoreImplCopyWith(
    _$TransferPlanScoreImpl value,
    $Res Function(_$TransferPlanScoreImpl) then,
  ) = __$$TransferPlanScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double startingElevenGain,
    double executionRisk,
    double valueStability,
  });
}

/// @nodoc
class __$$TransferPlanScoreImplCopyWithImpl<$Res>
    extends _$TransferPlanScoreCopyWithImpl<$Res, _$TransferPlanScoreImpl>
    implements _$$TransferPlanScoreImplCopyWith<$Res> {
  __$$TransferPlanScoreImplCopyWithImpl(
    _$TransferPlanScoreImpl _value,
    $Res Function(_$TransferPlanScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferPlanScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startingElevenGain = null,
    Object? executionRisk = null,
    Object? valueStability = null,
  }) {
    return _then(
      _$TransferPlanScoreImpl(
        startingElevenGain: null == startingElevenGain
            ? _value.startingElevenGain
            : startingElevenGain // ignore: cast_nullable_to_non_nullable
                  as double,
        executionRisk: null == executionRisk
            ? _value.executionRisk
            : executionRisk // ignore: cast_nullable_to_non_nullable
                  as double,
        valueStability: null == valueStability
            ? _value.valueStability
            : valueStability // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPlanScoreImpl implements _TransferPlanScore {
  const _$TransferPlanScoreImpl({
    required this.startingElevenGain,
    required this.executionRisk,
    required this.valueStability,
  });

  factory _$TransferPlanScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPlanScoreImplFromJson(json);

  @override
  final double startingElevenGain;
  @override
  final double executionRisk;
  @override
  final double valueStability;

  @override
  String toString() {
    return 'TransferPlanScore(startingElevenGain: $startingElevenGain, executionRisk: $executionRisk, valueStability: $valueStability)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPlanScoreImpl &&
            (identical(other.startingElevenGain, startingElevenGain) ||
                other.startingElevenGain == startingElevenGain) &&
            (identical(other.executionRisk, executionRisk) ||
                other.executionRisk == executionRisk) &&
            (identical(other.valueStability, valueStability) ||
                other.valueStability == valueStability));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    startingElevenGain,
    executionRisk,
    valueStability,
  );

  /// Create a copy of TransferPlanScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPlanScoreImplCopyWith<_$TransferPlanScoreImpl> get copyWith =>
      __$$TransferPlanScoreImplCopyWithImpl<_$TransferPlanScoreImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPlanScoreImplToJson(this);
  }
}

abstract class _TransferPlanScore implements TransferPlanScore {
  const factory _TransferPlanScore({
    required final double startingElevenGain,
    required final double executionRisk,
    required final double valueStability,
  }) = _$TransferPlanScoreImpl;

  factory _TransferPlanScore.fromJson(Map<String, dynamic> json) =
      _$TransferPlanScoreImpl.fromJson;

  @override
  double get startingElevenGain;
  @override
  double get executionRisk;
  @override
  double get valueStability;

  /// Create a copy of TransferPlanScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferPlanScoreImplCopyWith<_$TransferPlanScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferPlanMove _$TransferPlanMoveFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'sell':
      return TransferPlanMoveSell.fromJson(json);
    case 'buy':
      return TransferPlanMoveBuy.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'TransferPlanMove',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$TransferPlanMove {
  Player get player => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Player player, int amount) sell,
    required TResult Function(Player player, int amount) buy,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Player player, int amount)? sell,
    TResult? Function(Player player, int amount)? buy,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Player player, int amount)? sell,
    TResult Function(Player player, int amount)? buy,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransferPlanMoveSell value) sell,
    required TResult Function(TransferPlanMoveBuy value) buy,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransferPlanMoveSell value)? sell,
    TResult? Function(TransferPlanMoveBuy value)? buy,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransferPlanMoveSell value)? sell,
    TResult Function(TransferPlanMoveBuy value)? buy,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this TransferPlanMove to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferPlanMoveCopyWith<TransferPlanMove> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferPlanMoveCopyWith<$Res> {
  factory $TransferPlanMoveCopyWith(
    TransferPlanMove value,
    $Res Function(TransferPlanMove) then,
  ) = _$TransferPlanMoveCopyWithImpl<$Res, TransferPlanMove>;
  @useResult
  $Res call({Player player, int amount});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$TransferPlanMoveCopyWithImpl<$Res, $Val extends TransferPlanMove>
    implements $TransferPlanMoveCopyWith<$Res> {
  _$TransferPlanMoveCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? player = null, Object? amount = null}) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as Player,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of TransferPlanMove
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
abstract class _$$TransferPlanMoveSellImplCopyWith<$Res>
    implements $TransferPlanMoveCopyWith<$Res> {
  factory _$$TransferPlanMoveSellImplCopyWith(
    _$TransferPlanMoveSellImpl value,
    $Res Function(_$TransferPlanMoveSellImpl) then,
  ) = __$$TransferPlanMoveSellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player, int amount});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$TransferPlanMoveSellImplCopyWithImpl<$Res>
    extends _$TransferPlanMoveCopyWithImpl<$Res, _$TransferPlanMoveSellImpl>
    implements _$$TransferPlanMoveSellImplCopyWith<$Res> {
  __$$TransferPlanMoveSellImplCopyWithImpl(
    _$TransferPlanMoveSellImpl _value,
    $Res Function(_$TransferPlanMoveSellImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? player = null, Object? amount = null}) {
    return _then(
      _$TransferPlanMoveSellImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as Player,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPlanMoveSellImpl implements TransferPlanMoveSell {
  const _$TransferPlanMoveSellImpl({
    required this.player,
    required this.amount,
    final String? $type,
  }) : $type = $type ?? 'sell';

  factory _$TransferPlanMoveSellImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPlanMoveSellImplFromJson(json);

  @override
  final Player player;
  @override
  final int amount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferPlanMove.sell(player: $player, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPlanMoveSellImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, player, amount);

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPlanMoveSellImplCopyWith<_$TransferPlanMoveSellImpl>
  get copyWith =>
      __$$TransferPlanMoveSellImplCopyWithImpl<_$TransferPlanMoveSellImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Player player, int amount) sell,
    required TResult Function(Player player, int amount) buy,
  }) {
    return sell(player, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Player player, int amount)? sell,
    TResult? Function(Player player, int amount)? buy,
  }) {
    return sell?.call(player, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Player player, int amount)? sell,
    TResult Function(Player player, int amount)? buy,
    required TResult orElse(),
  }) {
    if (sell != null) {
      return sell(player, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransferPlanMoveSell value) sell,
    required TResult Function(TransferPlanMoveBuy value) buy,
  }) {
    return sell(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransferPlanMoveSell value)? sell,
    TResult? Function(TransferPlanMoveBuy value)? buy,
  }) {
    return sell?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransferPlanMoveSell value)? sell,
    TResult Function(TransferPlanMoveBuy value)? buy,
    required TResult orElse(),
  }) {
    if (sell != null) {
      return sell(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPlanMoveSellImplToJson(this);
  }
}

abstract class TransferPlanMoveSell implements TransferPlanMove {
  const factory TransferPlanMoveSell({
    required final Player player,
    required final int amount,
  }) = _$TransferPlanMoveSellImpl;

  factory TransferPlanMoveSell.fromJson(Map<String, dynamic> json) =
      _$TransferPlanMoveSellImpl.fromJson;

  @override
  Player get player;
  @override
  int get amount;

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferPlanMoveSellImplCopyWith<_$TransferPlanMoveSellImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransferPlanMoveBuyImplCopyWith<$Res>
    implements $TransferPlanMoveCopyWith<$Res> {
  factory _$$TransferPlanMoveBuyImplCopyWith(
    _$TransferPlanMoveBuyImpl value,
    $Res Function(_$TransferPlanMoveBuyImpl) then,
  ) = __$$TransferPlanMoveBuyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player, int amount});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$TransferPlanMoveBuyImplCopyWithImpl<$Res>
    extends _$TransferPlanMoveCopyWithImpl<$Res, _$TransferPlanMoveBuyImpl>
    implements _$$TransferPlanMoveBuyImplCopyWith<$Res> {
  __$$TransferPlanMoveBuyImplCopyWithImpl(
    _$TransferPlanMoveBuyImpl _value,
    $Res Function(_$TransferPlanMoveBuyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? player = null, Object? amount = null}) {
    return _then(
      _$TransferPlanMoveBuyImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as Player,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPlanMoveBuyImpl implements TransferPlanMoveBuy {
  const _$TransferPlanMoveBuyImpl({
    required this.player,
    required this.amount,
    final String? $type,
  }) : $type = $type ?? 'buy';

  factory _$TransferPlanMoveBuyImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPlanMoveBuyImplFromJson(json);

  @override
  final Player player;
  @override
  final int amount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferPlanMove.buy(player: $player, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPlanMoveBuyImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, player, amount);

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPlanMoveBuyImplCopyWith<_$TransferPlanMoveBuyImpl> get copyWith =>
      __$$TransferPlanMoveBuyImplCopyWithImpl<_$TransferPlanMoveBuyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Player player, int amount) sell,
    required TResult Function(Player player, int amount) buy,
  }) {
    return buy(player, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Player player, int amount)? sell,
    TResult? Function(Player player, int amount)? buy,
  }) {
    return buy?.call(player, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Player player, int amount)? sell,
    TResult Function(Player player, int amount)? buy,
    required TResult orElse(),
  }) {
    if (buy != null) {
      return buy(player, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TransferPlanMoveSell value) sell,
    required TResult Function(TransferPlanMoveBuy value) buy,
  }) {
    return buy(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TransferPlanMoveSell value)? sell,
    TResult? Function(TransferPlanMoveBuy value)? buy,
  }) {
    return buy?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TransferPlanMoveSell value)? sell,
    TResult Function(TransferPlanMoveBuy value)? buy,
    required TResult orElse(),
  }) {
    if (buy != null) {
      return buy(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPlanMoveBuyImplToJson(this);
  }
}

abstract class TransferPlanMoveBuy implements TransferPlanMove {
  const factory TransferPlanMoveBuy({
    required final Player player,
    required final int amount,
  }) = _$TransferPlanMoveBuyImpl;

  factory TransferPlanMoveBuy.fromJson(Map<String, dynamic> json) =
      _$TransferPlanMoveBuyImpl.fromJson;

  @override
  Player get player;
  @override
  int get amount;

  /// Create a copy of TransferPlanMove
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferPlanMoveBuyImplCopyWith<_$TransferPlanMoveBuyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferPlanScenario _$TransferPlanScenarioFromJson(Map<String, dynamic> json) {
  return _TransferPlanScenario.fromJson(json);
}

/// @nodoc
mixin _$TransferPlanScenario {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<TransferPlanMove> get sells => throw _privateConstructorUsedError;
  List<TransferPlanMove> get buys => throw _privateConstructorUsedError;
  List<Player> get resultingStarters => throw _privateConstructorUsedError;
  int get budgetBefore => throw _privateConstructorUsedError;
  int get budgetAfter => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<String> get warnings => throw _privateConstructorUsedError;
  TransferPlanScore get score => throw _privateConstructorUsedError;

  /// Serializes this TransferPlanScenario to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferPlanScenario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferPlanScenarioCopyWith<TransferPlanScenario> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferPlanScenarioCopyWith<$Res> {
  factory $TransferPlanScenarioCopyWith(
    TransferPlanScenario value,
    $Res Function(TransferPlanScenario) then,
  ) = _$TransferPlanScenarioCopyWithImpl<$Res, TransferPlanScenario>;
  @useResult
  $Res call({
    String id,
    String title,
    List<TransferPlanMove> sells,
    List<TransferPlanMove> buys,
    List<Player> resultingStarters,
    int budgetBefore,
    int budgetAfter,
    String summary,
    List<String> warnings,
    TransferPlanScore score,
  });

  $TransferPlanScoreCopyWith<$Res> get score;
}

/// @nodoc
class _$TransferPlanScenarioCopyWithImpl<
  $Res,
  $Val extends TransferPlanScenario
>
    implements $TransferPlanScenarioCopyWith<$Res> {
  _$TransferPlanScenarioCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferPlanScenario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sells = null,
    Object? buys = null,
    Object? resultingStarters = null,
    Object? budgetBefore = null,
    Object? budgetAfter = null,
    Object? summary = null,
    Object? warnings = null,
    Object? score = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            sells: null == sells
                ? _value.sells
                : sells // ignore: cast_nullable_to_non_nullable
                      as List<TransferPlanMove>,
            buys: null == buys
                ? _value.buys
                : buys // ignore: cast_nullable_to_non_nullable
                      as List<TransferPlanMove>,
            resultingStarters: null == resultingStarters
                ? _value.resultingStarters
                : resultingStarters // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            budgetBefore: null == budgetBefore
                ? _value.budgetBefore
                : budgetBefore // ignore: cast_nullable_to_non_nullable
                      as int,
            budgetAfter: null == budgetAfter
                ? _value.budgetAfter
                : budgetAfter // ignore: cast_nullable_to_non_nullable
                      as int,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            warnings: null == warnings
                ? _value.warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as TransferPlanScore,
          )
          as $Val,
    );
  }

  /// Create a copy of TransferPlanScenario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferPlanScoreCopyWith<$Res> get score {
    return $TransferPlanScoreCopyWith<$Res>(_value.score, (value) {
      return _then(_value.copyWith(score: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferPlanScenarioImplCopyWith<$Res>
    implements $TransferPlanScenarioCopyWith<$Res> {
  factory _$$TransferPlanScenarioImplCopyWith(
    _$TransferPlanScenarioImpl value,
    $Res Function(_$TransferPlanScenarioImpl) then,
  ) = __$$TransferPlanScenarioImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    List<TransferPlanMove> sells,
    List<TransferPlanMove> buys,
    List<Player> resultingStarters,
    int budgetBefore,
    int budgetAfter,
    String summary,
    List<String> warnings,
    TransferPlanScore score,
  });

  @override
  $TransferPlanScoreCopyWith<$Res> get score;
}

/// @nodoc
class __$$TransferPlanScenarioImplCopyWithImpl<$Res>
    extends _$TransferPlanScenarioCopyWithImpl<$Res, _$TransferPlanScenarioImpl>
    implements _$$TransferPlanScenarioImplCopyWith<$Res> {
  __$$TransferPlanScenarioImplCopyWithImpl(
    _$TransferPlanScenarioImpl _value,
    $Res Function(_$TransferPlanScenarioImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferPlanScenario
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sells = null,
    Object? buys = null,
    Object? resultingStarters = null,
    Object? budgetBefore = null,
    Object? budgetAfter = null,
    Object? summary = null,
    Object? warnings = null,
    Object? score = null,
  }) {
    return _then(
      _$TransferPlanScenarioImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        sells: null == sells
            ? _value._sells
            : sells // ignore: cast_nullable_to_non_nullable
                  as List<TransferPlanMove>,
        buys: null == buys
            ? _value._buys
            : buys // ignore: cast_nullable_to_non_nullable
                  as List<TransferPlanMove>,
        resultingStarters: null == resultingStarters
            ? _value._resultingStarters
            : resultingStarters // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        budgetBefore: null == budgetBefore
            ? _value.budgetBefore
            : budgetBefore // ignore: cast_nullable_to_non_nullable
                  as int,
        budgetAfter: null == budgetAfter
            ? _value.budgetAfter
            : budgetAfter // ignore: cast_nullable_to_non_nullable
                  as int,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        warnings: null == warnings
            ? _value._warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as TransferPlanScore,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPlanScenarioImpl implements _TransferPlanScenario {
  const _$TransferPlanScenarioImpl({
    required this.id,
    required this.title,
    required final List<TransferPlanMove> sells,
    required final List<TransferPlanMove> buys,
    required final List<Player> resultingStarters,
    required this.budgetBefore,
    required this.budgetAfter,
    required this.summary,
    required final List<String> warnings,
    required this.score,
  }) : _sells = sells,
       _buys = buys,
       _resultingStarters = resultingStarters,
       _warnings = warnings;

  factory _$TransferPlanScenarioImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPlanScenarioImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<TransferPlanMove> _sells;
  @override
  List<TransferPlanMove> get sells {
    if (_sells is EqualUnmodifiableListView) return _sells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sells);
  }

  final List<TransferPlanMove> _buys;
  @override
  List<TransferPlanMove> get buys {
    if (_buys is EqualUnmodifiableListView) return _buys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_buys);
  }

  final List<Player> _resultingStarters;
  @override
  List<Player> get resultingStarters {
    if (_resultingStarters is EqualUnmodifiableListView)
      return _resultingStarters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resultingStarters);
  }

  @override
  final int budgetBefore;
  @override
  final int budgetAfter;
  @override
  final String summary;
  final List<String> _warnings;
  @override
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  final TransferPlanScore score;

  @override
  String toString() {
    return 'TransferPlanScenario(id: $id, title: $title, sells: $sells, buys: $buys, resultingStarters: $resultingStarters, budgetBefore: $budgetBefore, budgetAfter: $budgetAfter, summary: $summary, warnings: $warnings, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPlanScenarioImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._sells, _sells) &&
            const DeepCollectionEquality().equals(other._buys, _buys) &&
            const DeepCollectionEquality().equals(
              other._resultingStarters,
              _resultingStarters,
            ) &&
            (identical(other.budgetBefore, budgetBefore) ||
                other.budgetBefore == budgetBefore) &&
            (identical(other.budgetAfter, budgetAfter) ||
                other.budgetAfter == budgetAfter) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_sells),
    const DeepCollectionEquality().hash(_buys),
    const DeepCollectionEquality().hash(_resultingStarters),
    budgetBefore,
    budgetAfter,
    summary,
    const DeepCollectionEquality().hash(_warnings),
    score,
  );

  /// Create a copy of TransferPlanScenario
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPlanScenarioImplCopyWith<_$TransferPlanScenarioImpl>
  get copyWith =>
      __$$TransferPlanScenarioImplCopyWithImpl<_$TransferPlanScenarioImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPlanScenarioImplToJson(this);
  }
}

abstract class _TransferPlanScenario implements TransferPlanScenario {
  const factory _TransferPlanScenario({
    required final String id,
    required final String title,
    required final List<TransferPlanMove> sells,
    required final List<TransferPlanMove> buys,
    required final List<Player> resultingStarters,
    required final int budgetBefore,
    required final int budgetAfter,
    required final String summary,
    required final List<String> warnings,
    required final TransferPlanScore score,
  }) = _$TransferPlanScenarioImpl;

  factory _TransferPlanScenario.fromJson(Map<String, dynamic> json) =
      _$TransferPlanScenarioImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<TransferPlanMove> get sells;
  @override
  List<TransferPlanMove> get buys;
  @override
  List<Player> get resultingStarters;
  @override
  int get budgetBefore;
  @override
  int get budgetAfter;
  @override
  String get summary;
  @override
  List<String> get warnings;
  @override
  TransferPlanScore get score;

  /// Create a copy of TransferPlanScenario
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferPlanScenarioImplCopyWith<_$TransferPlanScenarioImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TransferPlannerResult _$TransferPlannerResultFromJson(
  Map<String, dynamic> json,
) {
  return _TransferPlannerResult.fromJson(json);
}

/// @nodoc
mixin _$TransferPlannerResult {
  List<TransferPlanScenario> get scenarios =>
      throw _privateConstructorUsedError;
  String? get noPlanReason => throw _privateConstructorUsedError;

  /// Serializes this TransferPlannerResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransferPlannerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferPlannerResultCopyWith<TransferPlannerResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferPlannerResultCopyWith<$Res> {
  factory $TransferPlannerResultCopyWith(
    TransferPlannerResult value,
    $Res Function(TransferPlannerResult) then,
  ) = _$TransferPlannerResultCopyWithImpl<$Res, TransferPlannerResult>;
  @useResult
  $Res call({List<TransferPlanScenario> scenarios, String? noPlanReason});
}

/// @nodoc
class _$TransferPlannerResultCopyWithImpl<
  $Res,
  $Val extends TransferPlannerResult
>
    implements $TransferPlannerResultCopyWith<$Res> {
  _$TransferPlannerResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferPlannerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scenarios = null, Object? noPlanReason = freezed}) {
    return _then(
      _value.copyWith(
            scenarios: null == scenarios
                ? _value.scenarios
                : scenarios // ignore: cast_nullable_to_non_nullable
                      as List<TransferPlanScenario>,
            noPlanReason: freezed == noPlanReason
                ? _value.noPlanReason
                : noPlanReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferPlannerResultImplCopyWith<$Res>
    implements $TransferPlannerResultCopyWith<$Res> {
  factory _$$TransferPlannerResultImplCopyWith(
    _$TransferPlannerResultImpl value,
    $Res Function(_$TransferPlannerResultImpl) then,
  ) = __$$TransferPlannerResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransferPlanScenario> scenarios, String? noPlanReason});
}

/// @nodoc
class __$$TransferPlannerResultImplCopyWithImpl<$Res>
    extends
        _$TransferPlannerResultCopyWithImpl<$Res, _$TransferPlannerResultImpl>
    implements _$$TransferPlannerResultImplCopyWith<$Res> {
  __$$TransferPlannerResultImplCopyWithImpl(
    _$TransferPlannerResultImpl _value,
    $Res Function(_$TransferPlannerResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferPlannerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? scenarios = null, Object? noPlanReason = freezed}) {
    return _then(
      _$TransferPlannerResultImpl(
        scenarios: null == scenarios
            ? _value._scenarios
            : scenarios // ignore: cast_nullable_to_non_nullable
                  as List<TransferPlanScenario>,
        noPlanReason: freezed == noPlanReason
            ? _value.noPlanReason
            : noPlanReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPlannerResultImpl implements _TransferPlannerResult {
  const _$TransferPlannerResultImpl({
    required final List<TransferPlanScenario> scenarios,
    this.noPlanReason,
  }) : _scenarios = scenarios;

  factory _$TransferPlannerResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPlannerResultImplFromJson(json);

  final List<TransferPlanScenario> _scenarios;
  @override
  List<TransferPlanScenario> get scenarios {
    if (_scenarios is EqualUnmodifiableListView) return _scenarios;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scenarios);
  }

  @override
  final String? noPlanReason;

  @override
  String toString() {
    return 'TransferPlannerResult(scenarios: $scenarios, noPlanReason: $noPlanReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPlannerResultImpl &&
            const DeepCollectionEquality().equals(
              other._scenarios,
              _scenarios,
            ) &&
            (identical(other.noPlanReason, noPlanReason) ||
                other.noPlanReason == noPlanReason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_scenarios),
    noPlanReason,
  );

  /// Create a copy of TransferPlannerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPlannerResultImplCopyWith<_$TransferPlannerResultImpl>
  get copyWith =>
      __$$TransferPlannerResultImplCopyWithImpl<_$TransferPlannerResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPlannerResultImplToJson(this);
  }
}

abstract class _TransferPlannerResult implements TransferPlannerResult {
  const factory _TransferPlannerResult({
    required final List<TransferPlanScenario> scenarios,
    final String? noPlanReason,
  }) = _$TransferPlannerResultImpl;

  factory _TransferPlannerResult.fromJson(Map<String, dynamic> json) =
      _$TransferPlannerResultImpl.fromJson;

  @override
  List<TransferPlanScenario> get scenarios;
  @override
  String? get noPlanReason;

  /// Create a copy of TransferPlannerResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferPlannerResultImplCopyWith<_$TransferPlannerResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
