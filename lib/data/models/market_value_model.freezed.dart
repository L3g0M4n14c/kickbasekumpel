// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketValueHistoryResponse _$MarketValueHistoryResponseFromJson(
  Map<String, dynamic> json,
) {
  return _MarketValueHistoryResponse.fromJson(json);
}

/// @nodoc
mixin _$MarketValueHistoryResponse {
  List<MarketValueEntry> get it => throw _privateConstructorUsedError;
  int? get prlo => throw _privateConstructorUsedError;

  /// Serializes this MarketValueHistoryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketValueHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketValueHistoryResponseCopyWith<MarketValueHistoryResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketValueHistoryResponseCopyWith<$Res> {
  factory $MarketValueHistoryResponseCopyWith(
    MarketValueHistoryResponse value,
    $Res Function(MarketValueHistoryResponse) then,
  ) =
      _$MarketValueHistoryResponseCopyWithImpl<
        $Res,
        MarketValueHistoryResponse
      >;
  @useResult
  $Res call({List<MarketValueEntry> it, int? prlo});
}

/// @nodoc
class _$MarketValueHistoryResponseCopyWithImpl<
  $Res,
  $Val extends MarketValueHistoryResponse
>
    implements $MarketValueHistoryResponseCopyWith<$Res> {
  _$MarketValueHistoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketValueHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? it = null, Object? prlo = freezed}) {
    return _then(
      _value.copyWith(
            it: null == it
                ? _value.it
                : it // ignore: cast_nullable_to_non_nullable
                      as List<MarketValueEntry>,
            prlo: freezed == prlo
                ? _value.prlo
                : prlo // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketValueHistoryResponseImplCopyWith<$Res>
    implements $MarketValueHistoryResponseCopyWith<$Res> {
  factory _$$MarketValueHistoryResponseImplCopyWith(
    _$MarketValueHistoryResponseImpl value,
    $Res Function(_$MarketValueHistoryResponseImpl) then,
  ) = __$$MarketValueHistoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MarketValueEntry> it, int? prlo});
}

/// @nodoc
class __$$MarketValueHistoryResponseImplCopyWithImpl<$Res>
    extends
        _$MarketValueHistoryResponseCopyWithImpl<
          $Res,
          _$MarketValueHistoryResponseImpl
        >
    implements _$$MarketValueHistoryResponseImplCopyWith<$Res> {
  __$$MarketValueHistoryResponseImplCopyWithImpl(
    _$MarketValueHistoryResponseImpl _value,
    $Res Function(_$MarketValueHistoryResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketValueHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? it = null, Object? prlo = freezed}) {
    return _then(
      _$MarketValueHistoryResponseImpl(
        it: null == it
            ? _value._it
            : it // ignore: cast_nullable_to_non_nullable
                  as List<MarketValueEntry>,
        prlo: freezed == prlo
            ? _value.prlo
            : prlo // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketValueHistoryResponseImpl implements _MarketValueHistoryResponse {
  const _$MarketValueHistoryResponseImpl({
    required final List<MarketValueEntry> it,
    this.prlo,
  }) : _it = it;

  factory _$MarketValueHistoryResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MarketValueHistoryResponseImplFromJson(json);

  final List<MarketValueEntry> _it;
  @override
  List<MarketValueEntry> get it {
    if (_it is EqualUnmodifiableListView) return _it;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_it);
  }

  @override
  final int? prlo;

  @override
  String toString() {
    return 'MarketValueHistoryResponse(it: $it, prlo: $prlo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketValueHistoryResponseImpl &&
            const DeepCollectionEquality().equals(other._it, _it) &&
            (identical(other.prlo, prlo) || other.prlo == prlo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_it), prlo);

  /// Create a copy of MarketValueHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketValueHistoryResponseImplCopyWith<_$MarketValueHistoryResponseImpl>
  get copyWith =>
      __$$MarketValueHistoryResponseImplCopyWithImpl<
        _$MarketValueHistoryResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketValueHistoryResponseImplToJson(this);
  }
}

abstract class _MarketValueHistoryResponse
    implements MarketValueHistoryResponse {
  const factory _MarketValueHistoryResponse({
    required final List<MarketValueEntry> it,
    final int? prlo,
  }) = _$MarketValueHistoryResponseImpl;

  factory _MarketValueHistoryResponse.fromJson(Map<String, dynamic> json) =
      _$MarketValueHistoryResponseImpl.fromJson;

  @override
  List<MarketValueEntry> get it;
  @override
  int? get prlo;

  /// Create a copy of MarketValueHistoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketValueHistoryResponseImplCopyWith<_$MarketValueHistoryResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MarketValueEntry _$MarketValueEntryFromJson(Map<String, dynamic> json) {
  return _MarketValueEntry.fromJson(json);
}

/// @nodoc
mixin _$MarketValueEntry {
  int get dt => throw _privateConstructorUsedError;
  int get mv => throw _privateConstructorUsedError;

  /// Serializes this MarketValueEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketValueEntryCopyWith<MarketValueEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketValueEntryCopyWith<$Res> {
  factory $MarketValueEntryCopyWith(
    MarketValueEntry value,
    $Res Function(MarketValueEntry) then,
  ) = _$MarketValueEntryCopyWithImpl<$Res, MarketValueEntry>;
  @useResult
  $Res call({int dt, int mv});
}

/// @nodoc
class _$MarketValueEntryCopyWithImpl<$Res, $Val extends MarketValueEntry>
    implements $MarketValueEntryCopyWith<$Res> {
  _$MarketValueEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dt = null, Object? mv = null}) {
    return _then(
      _value.copyWith(
            dt: null == dt
                ? _value.dt
                : dt // ignore: cast_nullable_to_non_nullable
                      as int,
            mv: null == mv
                ? _value.mv
                : mv // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketValueEntryImplCopyWith<$Res>
    implements $MarketValueEntryCopyWith<$Res> {
  factory _$$MarketValueEntryImplCopyWith(
    _$MarketValueEntryImpl value,
    $Res Function(_$MarketValueEntryImpl) then,
  ) = __$$MarketValueEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dt, int mv});
}

/// @nodoc
class __$$MarketValueEntryImplCopyWithImpl<$Res>
    extends _$MarketValueEntryCopyWithImpl<$Res, _$MarketValueEntryImpl>
    implements _$$MarketValueEntryImplCopyWith<$Res> {
  __$$MarketValueEntryImplCopyWithImpl(
    _$MarketValueEntryImpl _value,
    $Res Function(_$MarketValueEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dt = null, Object? mv = null}) {
    return _then(
      _$MarketValueEntryImpl(
        dt: null == dt
            ? _value.dt
            : dt // ignore: cast_nullable_to_non_nullable
                  as int,
        mv: null == mv
            ? _value.mv
            : mv // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketValueEntryImpl implements _MarketValueEntry {
  const _$MarketValueEntryImpl({required this.dt, required this.mv});

  factory _$MarketValueEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketValueEntryImplFromJson(json);

  @override
  final int dt;
  @override
  final int mv;

  @override
  String toString() {
    return 'MarketValueEntry(dt: $dt, mv: $mv)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketValueEntryImpl &&
            (identical(other.dt, dt) || other.dt == dt) &&
            (identical(other.mv, mv) || other.mv == mv));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dt, mv);

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketValueEntryImplCopyWith<_$MarketValueEntryImpl> get copyWith =>
      __$$MarketValueEntryImplCopyWithImpl<_$MarketValueEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketValueEntryImplToJson(this);
  }
}

abstract class _MarketValueEntry implements MarketValueEntry {
  const factory _MarketValueEntry({
    required final int dt,
    required final int mv,
  }) = _$MarketValueEntryImpl;

  factory _MarketValueEntry.fromJson(Map<String, dynamic> json) =
      _$MarketValueEntryImpl.fromJson;

  @override
  int get dt;
  @override
  int get mv;

  /// Create a copy of MarketValueEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketValueEntryImplCopyWith<_$MarketValueEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyMarketValueChange _$DailyMarketValueChangeFromJson(
  Map<String, dynamic> json,
) {
  return _DailyMarketValueChange.fromJson(json);
}

/// @nodoc
mixin _$DailyMarketValueChange {
  String get date => throw _privateConstructorUsedError;
  int get value => throw _privateConstructorUsedError;
  int get change => throw _privateConstructorUsedError;
  double get percentageChange => throw _privateConstructorUsedError;
  int get daysAgo => throw _privateConstructorUsedError;

  /// Serializes this DailyMarketValueChange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyMarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyMarketValueChangeCopyWith<DailyMarketValueChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyMarketValueChangeCopyWith<$Res> {
  factory $DailyMarketValueChangeCopyWith(
    DailyMarketValueChange value,
    $Res Function(DailyMarketValueChange) then,
  ) = _$DailyMarketValueChangeCopyWithImpl<$Res, DailyMarketValueChange>;
  @useResult
  $Res call({
    String date,
    int value,
    int change,
    double percentageChange,
    int daysAgo,
  });
}

/// @nodoc
class _$DailyMarketValueChangeCopyWithImpl<
  $Res,
  $Val extends DailyMarketValueChange
>
    implements $DailyMarketValueChangeCopyWith<$Res> {
  _$DailyMarketValueChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyMarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? change = null,
    Object? percentageChange = null,
    Object? daysAgo = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as int,
            change: null == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                      as int,
            percentageChange: null == percentageChange
                ? _value.percentageChange
                : percentageChange // ignore: cast_nullable_to_non_nullable
                      as double,
            daysAgo: null == daysAgo
                ? _value.daysAgo
                : daysAgo // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyMarketValueChangeImplCopyWith<$Res>
    implements $DailyMarketValueChangeCopyWith<$Res> {
  factory _$$DailyMarketValueChangeImplCopyWith(
    _$DailyMarketValueChangeImpl value,
    $Res Function(_$DailyMarketValueChangeImpl) then,
  ) = __$$DailyMarketValueChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String date,
    int value,
    int change,
    double percentageChange,
    int daysAgo,
  });
}

/// @nodoc
class __$$DailyMarketValueChangeImplCopyWithImpl<$Res>
    extends
        _$DailyMarketValueChangeCopyWithImpl<$Res, _$DailyMarketValueChangeImpl>
    implements _$$DailyMarketValueChangeImplCopyWith<$Res> {
  __$$DailyMarketValueChangeImplCopyWithImpl(
    _$DailyMarketValueChangeImpl _value,
    $Res Function(_$DailyMarketValueChangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyMarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? change = null,
    Object? percentageChange = null,
    Object? daysAgo = null,
  }) {
    return _then(
      _$DailyMarketValueChangeImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as int,
        change: null == change
            ? _value.change
            : change // ignore: cast_nullable_to_non_nullable
                  as int,
        percentageChange: null == percentageChange
            ? _value.percentageChange
            : percentageChange // ignore: cast_nullable_to_non_nullable
                  as double,
        daysAgo: null == daysAgo
            ? _value.daysAgo
            : daysAgo // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyMarketValueChangeImpl implements _DailyMarketValueChange {
  const _$DailyMarketValueChangeImpl({
    required this.date,
    required this.value,
    required this.change,
    required this.percentageChange,
    required this.daysAgo,
  });

  factory _$DailyMarketValueChangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyMarketValueChangeImplFromJson(json);

  @override
  final String date;
  @override
  final int value;
  @override
  final int change;
  @override
  final double percentageChange;
  @override
  final int daysAgo;

  @override
  String toString() {
    return 'DailyMarketValueChange(date: $date, value: $value, change: $change, percentageChange: $percentageChange, daysAgo: $daysAgo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyMarketValueChangeImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.percentageChange, percentageChange) ||
                other.percentageChange == percentageChange) &&
            (identical(other.daysAgo, daysAgo) || other.daysAgo == daysAgo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, value, change, percentageChange, daysAgo);

  /// Create a copy of DailyMarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyMarketValueChangeImplCopyWith<_$DailyMarketValueChangeImpl>
  get copyWith =>
      __$$DailyMarketValueChangeImplCopyWithImpl<_$DailyMarketValueChangeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyMarketValueChangeImplToJson(this);
  }
}

abstract class _DailyMarketValueChange implements DailyMarketValueChange {
  const factory _DailyMarketValueChange({
    required final String date,
    required final int value,
    required final int change,
    required final double percentageChange,
    required final int daysAgo,
  }) = _$DailyMarketValueChangeImpl;

  factory _DailyMarketValueChange.fromJson(Map<String, dynamic> json) =
      _$DailyMarketValueChangeImpl.fromJson;

  @override
  String get date;
  @override
  int get value;
  @override
  int get change;
  @override
  double get percentageChange;
  @override
  int get daysAgo;

  /// Create a copy of DailyMarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyMarketValueChangeImplCopyWith<_$DailyMarketValueChangeImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MarketValueChange _$MarketValueChangeFromJson(Map<String, dynamic> json) {
  return _MarketValueChange.fromJson(json);
}

/// @nodoc
mixin _$MarketValueChange {
  int get daysSinceLastUpdate => throw _privateConstructorUsedError;
  int get absoluteChange => throw _privateConstructorUsedError;
  double get percentageChange => throw _privateConstructorUsedError;
  int get previousValue => throw _privateConstructorUsedError;
  int get currentValue => throw _privateConstructorUsedError;
  List<DailyMarketValueChange> get dailyChanges =>
      throw _privateConstructorUsedError;

  /// Serializes this MarketValueChange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketValueChangeCopyWith<MarketValueChange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketValueChangeCopyWith<$Res> {
  factory $MarketValueChangeCopyWith(
    MarketValueChange value,
    $Res Function(MarketValueChange) then,
  ) = _$MarketValueChangeCopyWithImpl<$Res, MarketValueChange>;
  @useResult
  $Res call({
    int daysSinceLastUpdate,
    int absoluteChange,
    double percentageChange,
    int previousValue,
    int currentValue,
    List<DailyMarketValueChange> dailyChanges,
  });
}

/// @nodoc
class _$MarketValueChangeCopyWithImpl<$Res, $Val extends MarketValueChange>
    implements $MarketValueChangeCopyWith<$Res> {
  _$MarketValueChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daysSinceLastUpdate = null,
    Object? absoluteChange = null,
    Object? percentageChange = null,
    Object? previousValue = null,
    Object? currentValue = null,
    Object? dailyChanges = null,
  }) {
    return _then(
      _value.copyWith(
            daysSinceLastUpdate: null == daysSinceLastUpdate
                ? _value.daysSinceLastUpdate
                : daysSinceLastUpdate // ignore: cast_nullable_to_non_nullable
                      as int,
            absoluteChange: null == absoluteChange
                ? _value.absoluteChange
                : absoluteChange // ignore: cast_nullable_to_non_nullable
                      as int,
            percentageChange: null == percentageChange
                ? _value.percentageChange
                : percentageChange // ignore: cast_nullable_to_non_nullable
                      as double,
            previousValue: null == previousValue
                ? _value.previousValue
                : previousValue // ignore: cast_nullable_to_non_nullable
                      as int,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyChanges: null == dailyChanges
                ? _value.dailyChanges
                : dailyChanges // ignore: cast_nullable_to_non_nullable
                      as List<DailyMarketValueChange>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketValueChangeImplCopyWith<$Res>
    implements $MarketValueChangeCopyWith<$Res> {
  factory _$$MarketValueChangeImplCopyWith(
    _$MarketValueChangeImpl value,
    $Res Function(_$MarketValueChangeImpl) then,
  ) = __$$MarketValueChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int daysSinceLastUpdate,
    int absoluteChange,
    double percentageChange,
    int previousValue,
    int currentValue,
    List<DailyMarketValueChange> dailyChanges,
  });
}

/// @nodoc
class __$$MarketValueChangeImplCopyWithImpl<$Res>
    extends _$MarketValueChangeCopyWithImpl<$Res, _$MarketValueChangeImpl>
    implements _$$MarketValueChangeImplCopyWith<$Res> {
  __$$MarketValueChangeImplCopyWithImpl(
    _$MarketValueChangeImpl _value,
    $Res Function(_$MarketValueChangeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? daysSinceLastUpdate = null,
    Object? absoluteChange = null,
    Object? percentageChange = null,
    Object? previousValue = null,
    Object? currentValue = null,
    Object? dailyChanges = null,
  }) {
    return _then(
      _$MarketValueChangeImpl(
        daysSinceLastUpdate: null == daysSinceLastUpdate
            ? _value.daysSinceLastUpdate
            : daysSinceLastUpdate // ignore: cast_nullable_to_non_nullable
                  as int,
        absoluteChange: null == absoluteChange
            ? _value.absoluteChange
            : absoluteChange // ignore: cast_nullable_to_non_nullable
                  as int,
        percentageChange: null == percentageChange
            ? _value.percentageChange
            : percentageChange // ignore: cast_nullable_to_non_nullable
                  as double,
        previousValue: null == previousValue
            ? _value.previousValue
            : previousValue // ignore: cast_nullable_to_non_nullable
                  as int,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyChanges: null == dailyChanges
            ? _value._dailyChanges
            : dailyChanges // ignore: cast_nullable_to_non_nullable
                  as List<DailyMarketValueChange>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketValueChangeImpl implements _MarketValueChange {
  const _$MarketValueChangeImpl({
    required this.daysSinceLastUpdate,
    required this.absoluteChange,
    required this.percentageChange,
    required this.previousValue,
    required this.currentValue,
    required final List<DailyMarketValueChange> dailyChanges,
  }) : _dailyChanges = dailyChanges;

  factory _$MarketValueChangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketValueChangeImplFromJson(json);

  @override
  final int daysSinceLastUpdate;
  @override
  final int absoluteChange;
  @override
  final double percentageChange;
  @override
  final int previousValue;
  @override
  final int currentValue;
  final List<DailyMarketValueChange> _dailyChanges;
  @override
  List<DailyMarketValueChange> get dailyChanges {
    if (_dailyChanges is EqualUnmodifiableListView) return _dailyChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyChanges);
  }

  @override
  String toString() {
    return 'MarketValueChange(daysSinceLastUpdate: $daysSinceLastUpdate, absoluteChange: $absoluteChange, percentageChange: $percentageChange, previousValue: $previousValue, currentValue: $currentValue, dailyChanges: $dailyChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketValueChangeImpl &&
            (identical(other.daysSinceLastUpdate, daysSinceLastUpdate) ||
                other.daysSinceLastUpdate == daysSinceLastUpdate) &&
            (identical(other.absoluteChange, absoluteChange) ||
                other.absoluteChange == absoluteChange) &&
            (identical(other.percentageChange, percentageChange) ||
                other.percentageChange == percentageChange) &&
            (identical(other.previousValue, previousValue) ||
                other.previousValue == previousValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            const DeepCollectionEquality().equals(
              other._dailyChanges,
              _dailyChanges,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    daysSinceLastUpdate,
    absoluteChange,
    percentageChange,
    previousValue,
    currentValue,
    const DeepCollectionEquality().hash(_dailyChanges),
  );

  /// Create a copy of MarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketValueChangeImplCopyWith<_$MarketValueChangeImpl> get copyWith =>
      __$$MarketValueChangeImplCopyWithImpl<_$MarketValueChangeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketValueChangeImplToJson(this);
  }
}

abstract class _MarketValueChange implements MarketValueChange {
  const factory _MarketValueChange({
    required final int daysSinceLastUpdate,
    required final int absoluteChange,
    required final double percentageChange,
    required final int previousValue,
    required final int currentValue,
    required final List<DailyMarketValueChange> dailyChanges,
  }) = _$MarketValueChangeImpl;

  factory _MarketValueChange.fromJson(Map<String, dynamic> json) =
      _$MarketValueChangeImpl.fromJson;

  @override
  int get daysSinceLastUpdate;
  @override
  int get absoluteChange;
  @override
  double get percentageChange;
  @override
  int get previousValue;
  @override
  int get currentValue;
  @override
  List<DailyMarketValueChange> get dailyChanges;

  /// Create a copy of MarketValueChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketValueChangeImplCopyWith<_$MarketValueChangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
