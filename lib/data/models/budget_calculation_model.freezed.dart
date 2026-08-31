// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_calculation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ManagerBudgetCalculation _$ManagerBudgetCalculationFromJson(
  Map<String, dynamic> json,
) {
  return _ManagerBudgetCalculation.fromJson(json);
}

/// @nodoc
mixin _$ManagerBudgetCalculation {
  /// Manager ID
  String get managerId => throw _privateConstructorUsedError;

  /// Manager Name
  String get managerName => throw _privateConstructorUsedError;

  /// Liga ID
  String get leagueId => throw _privateConstructorUsedError;

  /// Startbudget (150 Mio. €)
  int get initialBudget => throw _privateConstructorUsedError;

  /// Summe der Marktwerte der Anfangsspieler
  int get initialSquadValue => throw _privateConstructorUsedError;

  /// Startbudget nach Abzug der Anfangsspieler
  int get startingBudget => throw _privateConstructorUsedError;

  /// Summe aller Verkäufe (Einnahmen)
  int get totalSales => throw _privateConstructorUsedError;

  /// Summe aller Käufe (Ausgaben)
  int get totalPurchases => throw _privateConstructorUsedError;

  /// Aktuelles Budget
  int get currentBudget => throw _privateConstructorUsedError;

  /// Liste der Anfangsspieler mit Marktwert
  List<InitialPlayer> get initialPlayers => throw _privateConstructorUsedError;

  /// Liste der Transfers (Käufe und Verkäufe)
  List<ManagerTransfer> get transfers => throw _privateConstructorUsedError;

  /// Zeitstempel der Berechnung
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this ManagerBudgetCalculation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerBudgetCalculation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerBudgetCalculationCopyWith<ManagerBudgetCalculation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerBudgetCalculationCopyWith<$Res> {
  factory $ManagerBudgetCalculationCopyWith(
    ManagerBudgetCalculation value,
    $Res Function(ManagerBudgetCalculation) then,
  ) = _$ManagerBudgetCalculationCopyWithImpl<$Res, ManagerBudgetCalculation>;
  @useResult
  $Res call({
    String managerId,
    String managerName,
    String leagueId,
    int initialBudget,
    int initialSquadValue,
    int startingBudget,
    int totalSales,
    int totalPurchases,
    int currentBudget,
    List<InitialPlayer> initialPlayers,
    List<ManagerTransfer> transfers,
    DateTime calculatedAt,
  });
}

/// @nodoc
class _$ManagerBudgetCalculationCopyWithImpl<
  $Res,
  $Val extends ManagerBudgetCalculation
>
    implements $ManagerBudgetCalculationCopyWith<$Res> {
  _$ManagerBudgetCalculationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerBudgetCalculation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? managerId = null,
    Object? managerName = null,
    Object? leagueId = null,
    Object? initialBudget = null,
    Object? initialSquadValue = null,
    Object? startingBudget = null,
    Object? totalSales = null,
    Object? totalPurchases = null,
    Object? currentBudget = null,
    Object? initialPlayers = null,
    Object? transfers = null,
    Object? calculatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            managerId: null == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String,
            managerName: null == managerName
                ? _value.managerName
                : managerName // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            initialBudget: null == initialBudget
                ? _value.initialBudget
                : initialBudget // ignore: cast_nullable_to_non_nullable
                      as int,
            initialSquadValue: null == initialSquadValue
                ? _value.initialSquadValue
                : initialSquadValue // ignore: cast_nullable_to_non_nullable
                      as int,
            startingBudget: null == startingBudget
                ? _value.startingBudget
                : startingBudget // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSales: null == totalSales
                ? _value.totalSales
                : totalSales // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPurchases: null == totalPurchases
                ? _value.totalPurchases
                : totalPurchases // ignore: cast_nullable_to_non_nullable
                      as int,
            currentBudget: null == currentBudget
                ? _value.currentBudget
                : currentBudget // ignore: cast_nullable_to_non_nullable
                      as int,
            initialPlayers: null == initialPlayers
                ? _value.initialPlayers
                : initialPlayers // ignore: cast_nullable_to_non_nullable
                      as List<InitialPlayer>,
            transfers: null == transfers
                ? _value.transfers
                : transfers // ignore: cast_nullable_to_non_nullable
                      as List<ManagerTransfer>,
            calculatedAt: null == calculatedAt
                ? _value.calculatedAt
                : calculatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagerBudgetCalculationImplCopyWith<$Res>
    implements $ManagerBudgetCalculationCopyWith<$Res> {
  factory _$$ManagerBudgetCalculationImplCopyWith(
    _$ManagerBudgetCalculationImpl value,
    $Res Function(_$ManagerBudgetCalculationImpl) then,
  ) = __$$ManagerBudgetCalculationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String managerId,
    String managerName,
    String leagueId,
    int initialBudget,
    int initialSquadValue,
    int startingBudget,
    int totalSales,
    int totalPurchases,
    int currentBudget,
    List<InitialPlayer> initialPlayers,
    List<ManagerTransfer> transfers,
    DateTime calculatedAt,
  });
}

/// @nodoc
class __$$ManagerBudgetCalculationImplCopyWithImpl<$Res>
    extends
        _$ManagerBudgetCalculationCopyWithImpl<
          $Res,
          _$ManagerBudgetCalculationImpl
        >
    implements _$$ManagerBudgetCalculationImplCopyWith<$Res> {
  __$$ManagerBudgetCalculationImplCopyWithImpl(
    _$ManagerBudgetCalculationImpl _value,
    $Res Function(_$ManagerBudgetCalculationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerBudgetCalculation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? managerId = null,
    Object? managerName = null,
    Object? leagueId = null,
    Object? initialBudget = null,
    Object? initialSquadValue = null,
    Object? startingBudget = null,
    Object? totalSales = null,
    Object? totalPurchases = null,
    Object? currentBudget = null,
    Object? initialPlayers = null,
    Object? transfers = null,
    Object? calculatedAt = null,
  }) {
    return _then(
      _$ManagerBudgetCalculationImpl(
        managerId: null == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String,
        managerName: null == managerName
            ? _value.managerName
            : managerName // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        initialBudget: null == initialBudget
            ? _value.initialBudget
            : initialBudget // ignore: cast_nullable_to_non_nullable
                  as int,
        initialSquadValue: null == initialSquadValue
            ? _value.initialSquadValue
            : initialSquadValue // ignore: cast_nullable_to_non_nullable
                  as int,
        startingBudget: null == startingBudget
            ? _value.startingBudget
            : startingBudget // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSales: null == totalSales
            ? _value.totalSales
            : totalSales // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPurchases: null == totalPurchases
            ? _value.totalPurchases
            : totalPurchases // ignore: cast_nullable_to_non_nullable
                  as int,
        currentBudget: null == currentBudget
            ? _value.currentBudget
            : currentBudget // ignore: cast_nullable_to_non_nullable
                  as int,
        initialPlayers: null == initialPlayers
            ? _value._initialPlayers
            : initialPlayers // ignore: cast_nullable_to_non_nullable
                  as List<InitialPlayer>,
        transfers: null == transfers
            ? _value._transfers
            : transfers // ignore: cast_nullable_to_non_nullable
                  as List<ManagerTransfer>,
        calculatedAt: null == calculatedAt
            ? _value.calculatedAt
            : calculatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerBudgetCalculationImpl implements _ManagerBudgetCalculation {
  const _$ManagerBudgetCalculationImpl({
    required this.managerId,
    required this.managerName,
    required this.leagueId,
    this.initialBudget = 150000000,
    this.initialSquadValue = 0,
    this.startingBudget = 0,
    this.totalSales = 0,
    this.totalPurchases = 0,
    this.currentBudget = 0,
    final List<InitialPlayer> initialPlayers = const [],
    final List<ManagerTransfer> transfers = const [],
    required this.calculatedAt,
  }) : _initialPlayers = initialPlayers,
       _transfers = transfers;

  factory _$ManagerBudgetCalculationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerBudgetCalculationImplFromJson(json);

  /// Manager ID
  @override
  final String managerId;

  /// Manager Name
  @override
  final String managerName;

  /// Liga ID
  @override
  final String leagueId;

  /// Startbudget (150 Mio. €)
  @override
  @JsonKey()
  final int initialBudget;

  /// Summe der Marktwerte der Anfangsspieler
  @override
  @JsonKey()
  final int initialSquadValue;

  /// Startbudget nach Abzug der Anfangsspieler
  @override
  @JsonKey()
  final int startingBudget;

  /// Summe aller Verkäufe (Einnahmen)
  @override
  @JsonKey()
  final int totalSales;

  /// Summe aller Käufe (Ausgaben)
  @override
  @JsonKey()
  final int totalPurchases;

  /// Aktuelles Budget
  @override
  @JsonKey()
  final int currentBudget;

  /// Liste der Anfangsspieler mit Marktwert
  final List<InitialPlayer> _initialPlayers;

  /// Liste der Anfangsspieler mit Marktwert
  @override
  @JsonKey()
  List<InitialPlayer> get initialPlayers {
    if (_initialPlayers is EqualUnmodifiableListView) return _initialPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_initialPlayers);
  }

  /// Liste der Transfers (Käufe und Verkäufe)
  final List<ManagerTransfer> _transfers;

  /// Liste der Transfers (Käufe und Verkäufe)
  @override
  @JsonKey()
  List<ManagerTransfer> get transfers {
    if (_transfers is EqualUnmodifiableListView) return _transfers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transfers);
  }

  /// Zeitstempel der Berechnung
  @override
  final DateTime calculatedAt;

  @override
  String toString() {
    return 'ManagerBudgetCalculation(managerId: $managerId, managerName: $managerName, leagueId: $leagueId, initialBudget: $initialBudget, initialSquadValue: $initialSquadValue, startingBudget: $startingBudget, totalSales: $totalSales, totalPurchases: $totalPurchases, currentBudget: $currentBudget, initialPlayers: $initialPlayers, transfers: $transfers, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerBudgetCalculationImpl &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.initialBudget, initialBudget) ||
                other.initialBudget == initialBudget) &&
            (identical(other.initialSquadValue, initialSquadValue) ||
                other.initialSquadValue == initialSquadValue) &&
            (identical(other.startingBudget, startingBudget) ||
                other.startingBudget == startingBudget) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalPurchases, totalPurchases) ||
                other.totalPurchases == totalPurchases) &&
            (identical(other.currentBudget, currentBudget) ||
                other.currentBudget == currentBudget) &&
            const DeepCollectionEquality().equals(
              other._initialPlayers,
              _initialPlayers,
            ) &&
            const DeepCollectionEquality().equals(
              other._transfers,
              _transfers,
            ) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    managerId,
    managerName,
    leagueId,
    initialBudget,
    initialSquadValue,
    startingBudget,
    totalSales,
    totalPurchases,
    currentBudget,
    const DeepCollectionEquality().hash(_initialPlayers),
    const DeepCollectionEquality().hash(_transfers),
    calculatedAt,
  );

  /// Create a copy of ManagerBudgetCalculation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerBudgetCalculationImplCopyWith<_$ManagerBudgetCalculationImpl>
  get copyWith =>
      __$$ManagerBudgetCalculationImplCopyWithImpl<
        _$ManagerBudgetCalculationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerBudgetCalculationImplToJson(this);
  }
}

abstract class _ManagerBudgetCalculation implements ManagerBudgetCalculation {
  const factory _ManagerBudgetCalculation({
    required final String managerId,
    required final String managerName,
    required final String leagueId,
    final int initialBudget,
    final int initialSquadValue,
    final int startingBudget,
    final int totalSales,
    final int totalPurchases,
    final int currentBudget,
    final List<InitialPlayer> initialPlayers,
    final List<ManagerTransfer> transfers,
    required final DateTime calculatedAt,
  }) = _$ManagerBudgetCalculationImpl;

  factory _ManagerBudgetCalculation.fromJson(Map<String, dynamic> json) =
      _$ManagerBudgetCalculationImpl.fromJson;

  /// Manager ID
  @override
  String get managerId;

  /// Manager Name
  @override
  String get managerName;

  /// Liga ID
  @override
  String get leagueId;

  /// Startbudget (150 Mio. €)
  @override
  int get initialBudget;

  /// Summe der Marktwerte der Anfangsspieler
  @override
  int get initialSquadValue;

  /// Startbudget nach Abzug der Anfangsspieler
  @override
  int get startingBudget;

  /// Summe aller Verkäufe (Einnahmen)
  @override
  int get totalSales;

  /// Summe aller Käufe (Ausgaben)
  @override
  int get totalPurchases;

  /// Aktuelles Budget
  @override
  int get currentBudget;

  /// Liste der Anfangsspieler mit Marktwert
  @override
  List<InitialPlayer> get initialPlayers;

  /// Liste der Transfers (Käufe und Verkäufe)
  @override
  List<ManagerTransfer> get transfers;

  /// Zeitstempel der Berechnung
  @override
  DateTime get calculatedAt;

  /// Create a copy of ManagerBudgetCalculation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerBudgetCalculationImplCopyWith<_$ManagerBudgetCalculationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InitialPlayer _$InitialPlayerFromJson(Map<String, dynamic> json) {
  return _InitialPlayer.fromJson(json);
}

/// @nodoc
mixin _$InitialPlayer {
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  int get marketValue => throw _privateConstructorUsedError;
  DateTime get transferDate => throw _privateConstructorUsedError;

  /// Serializes this InitialPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InitialPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InitialPlayerCopyWith<InitialPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InitialPlayerCopyWith<$Res> {
  factory $InitialPlayerCopyWith(
    InitialPlayer value,
    $Res Function(InitialPlayer) then,
  ) = _$InitialPlayerCopyWithImpl<$Res, InitialPlayer>;
  @useResult
  $Res call({
    String playerId,
    String playerName,
    int marketValue,
    DateTime transferDate,
  });
}

/// @nodoc
class _$InitialPlayerCopyWithImpl<$Res, $Val extends InitialPlayer>
    implements $InitialPlayerCopyWith<$Res> {
  _$InitialPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InitialPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? marketValue = null,
    Object? transferDate = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            marketValue: null == marketValue
                ? _value.marketValue
                : marketValue // ignore: cast_nullable_to_non_nullable
                      as int,
            transferDate: null == transferDate
                ? _value.transferDate
                : transferDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InitialPlayerImplCopyWith<$Res>
    implements $InitialPlayerCopyWith<$Res> {
  factory _$$InitialPlayerImplCopyWith(
    _$InitialPlayerImpl value,
    $Res Function(_$InitialPlayerImpl) then,
  ) = __$$InitialPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    String playerName,
    int marketValue,
    DateTime transferDate,
  });
}

/// @nodoc
class __$$InitialPlayerImplCopyWithImpl<$Res>
    extends _$InitialPlayerCopyWithImpl<$Res, _$InitialPlayerImpl>
    implements _$$InitialPlayerImplCopyWith<$Res> {
  __$$InitialPlayerImplCopyWithImpl(
    _$InitialPlayerImpl _value,
    $Res Function(_$InitialPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InitialPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? marketValue = null,
    Object? transferDate = null,
  }) {
    return _then(
      _$InitialPlayerImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        marketValue: null == marketValue
            ? _value.marketValue
            : marketValue // ignore: cast_nullable_to_non_nullable
                  as int,
        transferDate: null == transferDate
            ? _value.transferDate
            : transferDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InitialPlayerImpl implements _InitialPlayer {
  const _$InitialPlayerImpl({
    required this.playerId,
    required this.playerName,
    required this.marketValue,
    required this.transferDate,
  });

  factory _$InitialPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$InitialPlayerImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final int marketValue;
  @override
  final DateTime transferDate;

  @override
  String toString() {
    return 'InitialPlayer(playerId: $playerId, playerName: $playerName, marketValue: $marketValue, transferDate: $transferDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitialPlayerImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.marketValue, marketValue) ||
                other.marketValue == marketValue) &&
            (identical(other.transferDate, transferDate) ||
                other.transferDate == transferDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, playerId, playerName, marketValue, transferDate);

  /// Create a copy of InitialPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialPlayerImplCopyWith<_$InitialPlayerImpl> get copyWith =>
      __$$InitialPlayerImplCopyWithImpl<_$InitialPlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InitialPlayerImplToJson(this);
  }
}

abstract class _InitialPlayer implements InitialPlayer {
  const factory _InitialPlayer({
    required final String playerId,
    required final String playerName,
    required final int marketValue,
    required final DateTime transferDate,
  }) = _$InitialPlayerImpl;

  factory _InitialPlayer.fromJson(Map<String, dynamic> json) =
      _$InitialPlayerImpl.fromJson;

  @override
  String get playerId;
  @override
  String get playerName;
  @override
  int get marketValue;
  @override
  DateTime get transferDate;

  /// Create a copy of InitialPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitialPlayerImplCopyWith<_$InitialPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ManagerTransfer _$ManagerTransferFromJson(Map<String, dynamic> json) {
  return _ManagerTransfer.fromJson(json);
}

/// @nodoc
mixin _$ManagerTransfer {
  String get transferId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get transferType =>
      throw _privateConstructorUsedError; // 1 = Kauf, 2 = Verkauf
  DateTime get timestamp => throw _privateConstructorUsedError;
  int? get marketValueAtTransfer => throw _privateConstructorUsedError;

  /// Serializes this ManagerTransfer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerTransferCopyWith<ManagerTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerTransferCopyWith<$Res> {
  factory $ManagerTransferCopyWith(
    ManagerTransfer value,
    $Res Function(ManagerTransfer) then,
  ) = _$ManagerTransferCopyWithImpl<$Res, ManagerTransfer>;
  @useResult
  $Res call({
    String transferId,
    String playerId,
    String playerName,
    int price,
    int transferType,
    DateTime timestamp,
    int? marketValueAtTransfer,
  });
}

/// @nodoc
class _$ManagerTransferCopyWithImpl<$Res, $Val extends ManagerTransfer>
    implements $ManagerTransferCopyWith<$Res> {
  _$ManagerTransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferId = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? price = null,
    Object? transferType = null,
    Object? timestamp = null,
    Object? marketValueAtTransfer = freezed,
  }) {
    return _then(
      _value.copyWith(
            transferId: null == transferId
                ? _value.transferId
                : transferId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            transferType: null == transferType
                ? _value.transferType
                : transferType // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            marketValueAtTransfer: freezed == marketValueAtTransfer
                ? _value.marketValueAtTransfer
                : marketValueAtTransfer // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ManagerTransferImplCopyWith<$Res>
    implements $ManagerTransferCopyWith<$Res> {
  factory _$$ManagerTransferImplCopyWith(
    _$ManagerTransferImpl value,
    $Res Function(_$ManagerTransferImpl) then,
  ) = __$$ManagerTransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transferId,
    String playerId,
    String playerName,
    int price,
    int transferType,
    DateTime timestamp,
    int? marketValueAtTransfer,
  });
}

/// @nodoc
class __$$ManagerTransferImplCopyWithImpl<$Res>
    extends _$ManagerTransferCopyWithImpl<$Res, _$ManagerTransferImpl>
    implements _$$ManagerTransferImplCopyWith<$Res> {
  __$$ManagerTransferImplCopyWithImpl(
    _$ManagerTransferImpl _value,
    $Res Function(_$ManagerTransferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ManagerTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferId = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? price = null,
    Object? transferType = null,
    Object? timestamp = null,
    Object? marketValueAtTransfer = freezed,
  }) {
    return _then(
      _$ManagerTransferImpl(
        transferId: null == transferId
            ? _value.transferId
            : transferId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        transferType: null == transferType
            ? _value.transferType
            : transferType // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        marketValueAtTransfer: freezed == marketValueAtTransfer
            ? _value.marketValueAtTransfer
            : marketValueAtTransfer // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerTransferImpl implements _ManagerTransfer {
  const _$ManagerTransferImpl({
    required this.transferId,
    required this.playerId,
    required this.playerName,
    required this.price,
    required this.transferType,
    required this.timestamp,
    this.marketValueAtTransfer,
  });

  factory _$ManagerTransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerTransferImplFromJson(json);

  @override
  final String transferId;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final int price;
  @override
  final int transferType;
  // 1 = Kauf, 2 = Verkauf
  @override
  final DateTime timestamp;
  @override
  final int? marketValueAtTransfer;

  @override
  String toString() {
    return 'ManagerTransfer(transferId: $transferId, playerId: $playerId, playerName: $playerName, price: $price, transferType: $transferType, timestamp: $timestamp, marketValueAtTransfer: $marketValueAtTransfer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerTransferImpl &&
            (identical(other.transferId, transferId) ||
                other.transferId == transferId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.transferType, transferType) ||
                other.transferType == transferType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.marketValueAtTransfer, marketValueAtTransfer) ||
                other.marketValueAtTransfer == marketValueAtTransfer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    transferId,
    playerId,
    playerName,
    price,
    transferType,
    timestamp,
    marketValueAtTransfer,
  );

  /// Create a copy of ManagerTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerTransferImplCopyWith<_$ManagerTransferImpl> get copyWith =>
      __$$ManagerTransferImplCopyWithImpl<_$ManagerTransferImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerTransferImplToJson(this);
  }
}

abstract class _ManagerTransfer implements ManagerTransfer {
  const factory _ManagerTransfer({
    required final String transferId,
    required final String playerId,
    required final String playerName,
    required final int price,
    required final int transferType,
    required final DateTime timestamp,
    final int? marketValueAtTransfer,
  }) = _$ManagerTransferImpl;

  factory _ManagerTransfer.fromJson(Map<String, dynamic> json) =
      _$ManagerTransferImpl.fromJson;

  @override
  String get transferId;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  int get price;
  @override
  int get transferType; // 1 = Kauf, 2 = Verkauf
  @override
  DateTime get timestamp;
  @override
  int? get marketValueAtTransfer;

  /// Create a copy of ManagerTransfer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerTransferImplCopyWith<_$ManagerTransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AutoSaleEvent _$AutoSaleEventFromJson(Map<String, dynamic> json) {
  return _AutoSaleEvent.fromJson(json);
}

/// @nodoc
mixin _$AutoSaleEvent {
  /// Spieltag, an dem der Spieler die Schwelle erreicht hat
  int get matchday => throw _privateConstructorUsedError;

  /// Spieler-ID
  String get playerId => throw _privateConstructorUsedError;

  /// Spielername
  String get playerName => throw _privateConstructorUsedError;

  /// Saison-Gesamtpunkte zum Zeitpunkt des Verkaufs
  int get points => throw _privateConstructorUsedError;

  /// Punkte-Schwelle der Regel (z.B. 250)
  int get threshold => throw _privateConstructorUsedError;

  /// Marktwert zum Verkaufszeitpunkt (Einnahme)
  int get marketValue => throw _privateConstructorUsedError;

  /// true, wenn der Marktwert nicht zweifelsfrei ermittelt werden konnte
  bool get uncertain => throw _privateConstructorUsedError;

  /// Serializes this AutoSaleEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AutoSaleEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoSaleEventCopyWith<AutoSaleEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoSaleEventCopyWith<$Res> {
  factory $AutoSaleEventCopyWith(
    AutoSaleEvent value,
    $Res Function(AutoSaleEvent) then,
  ) = _$AutoSaleEventCopyWithImpl<$Res, AutoSaleEvent>;
  @useResult
  $Res call({
    int matchday,
    String playerId,
    String playerName,
    int points,
    int threshold,
    int marketValue,
    bool uncertain,
  });
}

/// @nodoc
class _$AutoSaleEventCopyWithImpl<$Res, $Val extends AutoSaleEvent>
    implements $AutoSaleEventCopyWith<$Res> {
  _$AutoSaleEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoSaleEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchday = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? points = null,
    Object? threshold = null,
    Object? marketValue = null,
    Object? uncertain = null,
  }) {
    return _then(
      _value.copyWith(
            matchday: null == matchday
                ? _value.matchday
                : matchday // ignore: cast_nullable_to_non_nullable
                      as int,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            threshold: null == threshold
                ? _value.threshold
                : threshold // ignore: cast_nullable_to_non_nullable
                      as int,
            marketValue: null == marketValue
                ? _value.marketValue
                : marketValue // ignore: cast_nullable_to_non_nullable
                      as int,
            uncertain: null == uncertain
                ? _value.uncertain
                : uncertain // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AutoSaleEventImplCopyWith<$Res>
    implements $AutoSaleEventCopyWith<$Res> {
  factory _$$AutoSaleEventImplCopyWith(
    _$AutoSaleEventImpl value,
    $Res Function(_$AutoSaleEventImpl) then,
  ) = __$$AutoSaleEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int matchday,
    String playerId,
    String playerName,
    int points,
    int threshold,
    int marketValue,
    bool uncertain,
  });
}

/// @nodoc
class __$$AutoSaleEventImplCopyWithImpl<$Res>
    extends _$AutoSaleEventCopyWithImpl<$Res, _$AutoSaleEventImpl>
    implements _$$AutoSaleEventImplCopyWith<$Res> {
  __$$AutoSaleEventImplCopyWithImpl(
    _$AutoSaleEventImpl _value,
    $Res Function(_$AutoSaleEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AutoSaleEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matchday = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? points = null,
    Object? threshold = null,
    Object? marketValue = null,
    Object? uncertain = null,
  }) {
    return _then(
      _$AutoSaleEventImpl(
        matchday: null == matchday
            ? _value.matchday
            : matchday // ignore: cast_nullable_to_non_nullable
                  as int,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        threshold: null == threshold
            ? _value.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int,
        marketValue: null == marketValue
            ? _value.marketValue
            : marketValue // ignore: cast_nullable_to_non_nullable
                  as int,
        uncertain: null == uncertain
            ? _value.uncertain
            : uncertain // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AutoSaleEventImpl implements _AutoSaleEvent {
  const _$AutoSaleEventImpl({
    required this.matchday,
    required this.playerId,
    required this.playerName,
    required this.points,
    required this.threshold,
    required this.marketValue,
    this.uncertain = false,
  });

  factory _$AutoSaleEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$AutoSaleEventImplFromJson(json);

  /// Spieltag, an dem der Spieler die Schwelle erreicht hat
  @override
  final int matchday;

  /// Spieler-ID
  @override
  final String playerId;

  /// Spielername
  @override
  final String playerName;

  /// Saison-Gesamtpunkte zum Zeitpunkt des Verkaufs
  @override
  final int points;

  /// Punkte-Schwelle der Regel (z.B. 250)
  @override
  final int threshold;

  /// Marktwert zum Verkaufszeitpunkt (Einnahme)
  @override
  final int marketValue;

  /// true, wenn der Marktwert nicht zweifelsfrei ermittelt werden konnte
  @override
  @JsonKey()
  final bool uncertain;

  @override
  String toString() {
    return 'AutoSaleEvent(matchday: $matchday, playerId: $playerId, playerName: $playerName, points: $points, threshold: $threshold, marketValue: $marketValue, uncertain: $uncertain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoSaleEventImpl &&
            (identical(other.matchday, matchday) ||
                other.matchday == matchday) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.marketValue, marketValue) ||
                other.marketValue == marketValue) &&
            (identical(other.uncertain, uncertain) ||
                other.uncertain == uncertain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    matchday,
    playerId,
    playerName,
    points,
    threshold,
    marketValue,
    uncertain,
  );

  /// Create a copy of AutoSaleEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoSaleEventImplCopyWith<_$AutoSaleEventImpl> get copyWith =>
      __$$AutoSaleEventImplCopyWithImpl<_$AutoSaleEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AutoSaleEventImplToJson(this);
  }
}

abstract class _AutoSaleEvent implements AutoSaleEvent {
  const factory _AutoSaleEvent({
    required final int matchday,
    required final String playerId,
    required final String playerName,
    required final int points,
    required final int threshold,
    required final int marketValue,
    final bool uncertain,
  }) = _$AutoSaleEventImpl;

  factory _AutoSaleEvent.fromJson(Map<String, dynamic> json) =
      _$AutoSaleEventImpl.fromJson;

  /// Spieltag, an dem der Spieler die Schwelle erreicht hat
  @override
  int get matchday;

  /// Spieler-ID
  @override
  String get playerId;

  /// Spielername
  @override
  String get playerName;

  /// Saison-Gesamtpunkte zum Zeitpunkt des Verkaufs
  @override
  int get points;

  /// Punkte-Schwelle der Regel (z.B. 250)
  @override
  int get threshold;

  /// Marktwert zum Verkaufszeitpunkt (Einnahme)
  @override
  int get marketValue;

  /// true, wenn der Marktwert nicht zweifelsfrei ermittelt werden konnte
  @override
  bool get uncertain;

  /// Create a copy of AutoSaleEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoSaleEventImplCopyWith<_$AutoSaleEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BudgetCalculationResult _$BudgetCalculationResultFromJson(
  Map<String, dynamic> json,
) {
  return _BudgetCalculationResult.fromJson(json);
}

/// @nodoc
mixin _$BudgetCalculationResult {
  String get managerId => throw _privateConstructorUsedError;
  String get managerName => throw _privateConstructorUsedError;
  String get leagueId => throw _privateConstructorUsedError;
  int get initialBudget => throw _privateConstructorUsedError;
  int get initialSquadValue => throw _privateConstructorUsedError;
  int get startingBudget => throw _privateConstructorUsedError;
  int get totalSales => throw _privateConstructorUsedError;
  int get totalPurchases => throw _privateConstructorUsedError;
  int get currentBudget => throw _privateConstructorUsedError;
  List<InitialPlayer> get initialPlayers => throw _privateConstructorUsedError;
  List<ManagerTransfer> get sales => throw _privateConstructorUsedError;
  List<ManagerTransfer> get purchases => throw _privateConstructorUsedError;
  DateTime get calculatedAt => throw _privateConstructorUsedError;

  /// Summe der Einnahmen durch automatische Verkäufe (Auto-Verkauf /
  /// 250er-Regel). Diese Verkäufe erscheinen nicht in der Transfer-Historie
  /// und werden daher separat ermittelt und addiert.
  int get autoSaleIncome => throw _privateConstructorUsedError;

  /// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
  List<AutoSaleEvent> get autoSaleEvents => throw _privateConstructorUsedError;

  /// Serializes this BudgetCalculationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BudgetCalculationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BudgetCalculationResultCopyWith<BudgetCalculationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCalculationResultCopyWith<$Res> {
  factory $BudgetCalculationResultCopyWith(
    BudgetCalculationResult value,
    $Res Function(BudgetCalculationResult) then,
  ) = _$BudgetCalculationResultCopyWithImpl<$Res, BudgetCalculationResult>;
  @useResult
  $Res call({
    String managerId,
    String managerName,
    String leagueId,
    int initialBudget,
    int initialSquadValue,
    int startingBudget,
    int totalSales,
    int totalPurchases,
    int currentBudget,
    List<InitialPlayer> initialPlayers,
    List<ManagerTransfer> sales,
    List<ManagerTransfer> purchases,
    DateTime calculatedAt,
    int autoSaleIncome,
    List<AutoSaleEvent> autoSaleEvents,
  });
}

/// @nodoc
class _$BudgetCalculationResultCopyWithImpl<
  $Res,
  $Val extends BudgetCalculationResult
>
    implements $BudgetCalculationResultCopyWith<$Res> {
  _$BudgetCalculationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BudgetCalculationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? managerId = null,
    Object? managerName = null,
    Object? leagueId = null,
    Object? initialBudget = null,
    Object? initialSquadValue = null,
    Object? startingBudget = null,
    Object? totalSales = null,
    Object? totalPurchases = null,
    Object? currentBudget = null,
    Object? initialPlayers = null,
    Object? sales = null,
    Object? purchases = null,
    Object? calculatedAt = null,
    Object? autoSaleIncome = null,
    Object? autoSaleEvents = null,
  }) {
    return _then(
      _value.copyWith(
            managerId: null == managerId
                ? _value.managerId
                : managerId // ignore: cast_nullable_to_non_nullable
                      as String,
            managerName: null == managerName
                ? _value.managerName
                : managerName // ignore: cast_nullable_to_non_nullable
                      as String,
            leagueId: null == leagueId
                ? _value.leagueId
                : leagueId // ignore: cast_nullable_to_non_nullable
                      as String,
            initialBudget: null == initialBudget
                ? _value.initialBudget
                : initialBudget // ignore: cast_nullable_to_non_nullable
                      as int,
            initialSquadValue: null == initialSquadValue
                ? _value.initialSquadValue
                : initialSquadValue // ignore: cast_nullable_to_non_nullable
                      as int,
            startingBudget: null == startingBudget
                ? _value.startingBudget
                : startingBudget // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSales: null == totalSales
                ? _value.totalSales
                : totalSales // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPurchases: null == totalPurchases
                ? _value.totalPurchases
                : totalPurchases // ignore: cast_nullable_to_non_nullable
                      as int,
            currentBudget: null == currentBudget
                ? _value.currentBudget
                : currentBudget // ignore: cast_nullable_to_non_nullable
                      as int,
            initialPlayers: null == initialPlayers
                ? _value.initialPlayers
                : initialPlayers // ignore: cast_nullable_to_non_nullable
                      as List<InitialPlayer>,
            sales: null == sales
                ? _value.sales
                : sales // ignore: cast_nullable_to_non_nullable
                      as List<ManagerTransfer>,
            purchases: null == purchases
                ? _value.purchases
                : purchases // ignore: cast_nullable_to_non_nullable
                      as List<ManagerTransfer>,
            calculatedAt: null == calculatedAt
                ? _value.calculatedAt
                : calculatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            autoSaleIncome: null == autoSaleIncome
                ? _value.autoSaleIncome
                : autoSaleIncome // ignore: cast_nullable_to_non_nullable
                      as int,
            autoSaleEvents: null == autoSaleEvents
                ? _value.autoSaleEvents
                : autoSaleEvents // ignore: cast_nullable_to_non_nullable
                      as List<AutoSaleEvent>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BudgetCalculationResultImplCopyWith<$Res>
    implements $BudgetCalculationResultCopyWith<$Res> {
  factory _$$BudgetCalculationResultImplCopyWith(
    _$BudgetCalculationResultImpl value,
    $Res Function(_$BudgetCalculationResultImpl) then,
  ) = __$$BudgetCalculationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String managerId,
    String managerName,
    String leagueId,
    int initialBudget,
    int initialSquadValue,
    int startingBudget,
    int totalSales,
    int totalPurchases,
    int currentBudget,
    List<InitialPlayer> initialPlayers,
    List<ManagerTransfer> sales,
    List<ManagerTransfer> purchases,
    DateTime calculatedAt,
    int autoSaleIncome,
    List<AutoSaleEvent> autoSaleEvents,
  });
}

/// @nodoc
class __$$BudgetCalculationResultImplCopyWithImpl<$Res>
    extends
        _$BudgetCalculationResultCopyWithImpl<
          $Res,
          _$BudgetCalculationResultImpl
        >
    implements _$$BudgetCalculationResultImplCopyWith<$Res> {
  __$$BudgetCalculationResultImplCopyWithImpl(
    _$BudgetCalculationResultImpl _value,
    $Res Function(_$BudgetCalculationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BudgetCalculationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? managerId = null,
    Object? managerName = null,
    Object? leagueId = null,
    Object? initialBudget = null,
    Object? initialSquadValue = null,
    Object? startingBudget = null,
    Object? totalSales = null,
    Object? totalPurchases = null,
    Object? currentBudget = null,
    Object? initialPlayers = null,
    Object? sales = null,
    Object? purchases = null,
    Object? calculatedAt = null,
    Object? autoSaleIncome = null,
    Object? autoSaleEvents = null,
  }) {
    return _then(
      _$BudgetCalculationResultImpl(
        managerId: null == managerId
            ? _value.managerId
            : managerId // ignore: cast_nullable_to_non_nullable
                  as String,
        managerName: null == managerName
            ? _value.managerName
            : managerName // ignore: cast_nullable_to_non_nullable
                  as String,
        leagueId: null == leagueId
            ? _value.leagueId
            : leagueId // ignore: cast_nullable_to_non_nullable
                  as String,
        initialBudget: null == initialBudget
            ? _value.initialBudget
            : initialBudget // ignore: cast_nullable_to_non_nullable
                  as int,
        initialSquadValue: null == initialSquadValue
            ? _value.initialSquadValue
            : initialSquadValue // ignore: cast_nullable_to_non_nullable
                  as int,
        startingBudget: null == startingBudget
            ? _value.startingBudget
            : startingBudget // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSales: null == totalSales
            ? _value.totalSales
            : totalSales // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPurchases: null == totalPurchases
            ? _value.totalPurchases
            : totalPurchases // ignore: cast_nullable_to_non_nullable
                  as int,
        currentBudget: null == currentBudget
            ? _value.currentBudget
            : currentBudget // ignore: cast_nullable_to_non_nullable
                  as int,
        initialPlayers: null == initialPlayers
            ? _value._initialPlayers
            : initialPlayers // ignore: cast_nullable_to_non_nullable
                  as List<InitialPlayer>,
        sales: null == sales
            ? _value._sales
            : sales // ignore: cast_nullable_to_non_nullable
                  as List<ManagerTransfer>,
        purchases: null == purchases
            ? _value._purchases
            : purchases // ignore: cast_nullable_to_non_nullable
                  as List<ManagerTransfer>,
        calculatedAt: null == calculatedAt
            ? _value.calculatedAt
            : calculatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        autoSaleIncome: null == autoSaleIncome
            ? _value.autoSaleIncome
            : autoSaleIncome // ignore: cast_nullable_to_non_nullable
                  as int,
        autoSaleEvents: null == autoSaleEvents
            ? _value._autoSaleEvents
            : autoSaleEvents // ignore: cast_nullable_to_non_nullable
                  as List<AutoSaleEvent>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BudgetCalculationResultImpl implements _BudgetCalculationResult {
  const _$BudgetCalculationResultImpl({
    required this.managerId,
    required this.managerName,
    required this.leagueId,
    required this.initialBudget,
    required this.initialSquadValue,
    required this.startingBudget,
    required this.totalSales,
    required this.totalPurchases,
    required this.currentBudget,
    required final List<InitialPlayer> initialPlayers,
    required final List<ManagerTransfer> sales,
    required final List<ManagerTransfer> purchases,
    required this.calculatedAt,
    this.autoSaleIncome = 0,
    final List<AutoSaleEvent> autoSaleEvents = const [],
  }) : _initialPlayers = initialPlayers,
       _sales = sales,
       _purchases = purchases,
       _autoSaleEvents = autoSaleEvents;

  factory _$BudgetCalculationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetCalculationResultImplFromJson(json);

  @override
  final String managerId;
  @override
  final String managerName;
  @override
  final String leagueId;
  @override
  final int initialBudget;
  @override
  final int initialSquadValue;
  @override
  final int startingBudget;
  @override
  final int totalSales;
  @override
  final int totalPurchases;
  @override
  final int currentBudget;
  final List<InitialPlayer> _initialPlayers;
  @override
  List<InitialPlayer> get initialPlayers {
    if (_initialPlayers is EqualUnmodifiableListView) return _initialPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_initialPlayers);
  }

  final List<ManagerTransfer> _sales;
  @override
  List<ManagerTransfer> get sales {
    if (_sales is EqualUnmodifiableListView) return _sales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sales);
  }

  final List<ManagerTransfer> _purchases;
  @override
  List<ManagerTransfer> get purchases {
    if (_purchases is EqualUnmodifiableListView) return _purchases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchases);
  }

  @override
  final DateTime calculatedAt;

  /// Summe der Einnahmen durch automatische Verkäufe (Auto-Verkauf /
  /// 250er-Regel). Diese Verkäufe erscheinen nicht in der Transfer-Historie
  /// und werden daher separat ermittelt und addiert.
  @override
  @JsonKey()
  final int autoSaleIncome;

  /// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
  final List<AutoSaleEvent> _autoSaleEvents;

  /// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
  @override
  @JsonKey()
  List<AutoSaleEvent> get autoSaleEvents {
    if (_autoSaleEvents is EqualUnmodifiableListView) return _autoSaleEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_autoSaleEvents);
  }

  @override
  String toString() {
    return 'BudgetCalculationResult(managerId: $managerId, managerName: $managerName, leagueId: $leagueId, initialBudget: $initialBudget, initialSquadValue: $initialSquadValue, startingBudget: $startingBudget, totalSales: $totalSales, totalPurchases: $totalPurchases, currentBudget: $currentBudget, initialPlayers: $initialPlayers, sales: $sales, purchases: $purchases, calculatedAt: $calculatedAt, autoSaleIncome: $autoSaleIncome, autoSaleEvents: $autoSaleEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetCalculationResultImpl &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName) &&
            (identical(other.leagueId, leagueId) ||
                other.leagueId == leagueId) &&
            (identical(other.initialBudget, initialBudget) ||
                other.initialBudget == initialBudget) &&
            (identical(other.initialSquadValue, initialSquadValue) ||
                other.initialSquadValue == initialSquadValue) &&
            (identical(other.startingBudget, startingBudget) ||
                other.startingBudget == startingBudget) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalPurchases, totalPurchases) ||
                other.totalPurchases == totalPurchases) &&
            (identical(other.currentBudget, currentBudget) ||
                other.currentBudget == currentBudget) &&
            const DeepCollectionEquality().equals(
              other._initialPlayers,
              _initialPlayers,
            ) &&
            const DeepCollectionEquality().equals(other._sales, _sales) &&
            const DeepCollectionEquality().equals(
              other._purchases,
              _purchases,
            ) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt) &&
            (identical(other.autoSaleIncome, autoSaleIncome) ||
                other.autoSaleIncome == autoSaleIncome) &&
            const DeepCollectionEquality().equals(
              other._autoSaleEvents,
              _autoSaleEvents,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    managerId,
    managerName,
    leagueId,
    initialBudget,
    initialSquadValue,
    startingBudget,
    totalSales,
    totalPurchases,
    currentBudget,
    const DeepCollectionEquality().hash(_initialPlayers),
    const DeepCollectionEquality().hash(_sales),
    const DeepCollectionEquality().hash(_purchases),
    calculatedAt,
    autoSaleIncome,
    const DeepCollectionEquality().hash(_autoSaleEvents),
  );

  /// Create a copy of BudgetCalculationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetCalculationResultImplCopyWith<_$BudgetCalculationResultImpl>
  get copyWith =>
      __$$BudgetCalculationResultImplCopyWithImpl<
        _$BudgetCalculationResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetCalculationResultImplToJson(this);
  }
}

abstract class _BudgetCalculationResult implements BudgetCalculationResult {
  const factory _BudgetCalculationResult({
    required final String managerId,
    required final String managerName,
    required final String leagueId,
    required final int initialBudget,
    required final int initialSquadValue,
    required final int startingBudget,
    required final int totalSales,
    required final int totalPurchases,
    required final int currentBudget,
    required final List<InitialPlayer> initialPlayers,
    required final List<ManagerTransfer> sales,
    required final List<ManagerTransfer> purchases,
    required final DateTime calculatedAt,
    final int autoSaleIncome,
    final List<AutoSaleEvent> autoSaleEvents,
  }) = _$BudgetCalculationResultImpl;

  factory _BudgetCalculationResult.fromJson(Map<String, dynamic> json) =
      _$BudgetCalculationResultImpl.fromJson;

  @override
  String get managerId;
  @override
  String get managerName;
  @override
  String get leagueId;
  @override
  int get initialBudget;
  @override
  int get initialSquadValue;
  @override
  int get startingBudget;
  @override
  int get totalSales;
  @override
  int get totalPurchases;
  @override
  int get currentBudget;
  @override
  List<InitialPlayer> get initialPlayers;
  @override
  List<ManagerTransfer> get sales;
  @override
  List<ManagerTransfer> get purchases;
  @override
  DateTime get calculatedAt;

  /// Summe der Einnahmen durch automatische Verkäufe (Auto-Verkauf /
  /// 250er-Regel). Diese Verkäufe erscheinen nicht in der Transfer-Historie
  /// und werden daher separat ermittelt und addiert.
  @override
  int get autoSaleIncome;

  /// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
  @override
  List<AutoSaleEvent> get autoSaleEvents;

  /// Create a copy of BudgetCalculationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BudgetCalculationResultImplCopyWith<_$BudgetCalculationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
