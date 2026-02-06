// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'performance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerPerformanceResponse _$PlayerPerformanceResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PlayerPerformanceResponse.fromJson(json);
}

/// @nodoc
mixin _$PlayerPerformanceResponse {
  List<SeasonPerformance> get it => throw _privateConstructorUsedError;

  /// Serializes this PlayerPerformanceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerPerformanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerPerformanceResponseCopyWith<PlayerPerformanceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerPerformanceResponseCopyWith<$Res> {
  factory $PlayerPerformanceResponseCopyWith(
    PlayerPerformanceResponse value,
    $Res Function(PlayerPerformanceResponse) then,
  ) = _$PlayerPerformanceResponseCopyWithImpl<$Res, PlayerPerformanceResponse>;
  @useResult
  $Res call({List<SeasonPerformance> it});
}

/// @nodoc
class _$PlayerPerformanceResponseCopyWithImpl<
  $Res,
  $Val extends PlayerPerformanceResponse
>
    implements $PlayerPerformanceResponseCopyWith<$Res> {
  _$PlayerPerformanceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerPerformanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? it = null}) {
    return _then(
      _value.copyWith(
            it: null == it
                ? _value.it
                : it // ignore: cast_nullable_to_non_nullable
                      as List<SeasonPerformance>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerPerformanceResponseImplCopyWith<$Res>
    implements $PlayerPerformanceResponseCopyWith<$Res> {
  factory _$$PlayerPerformanceResponseImplCopyWith(
    _$PlayerPerformanceResponseImpl value,
    $Res Function(_$PlayerPerformanceResponseImpl) then,
  ) = __$$PlayerPerformanceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SeasonPerformance> it});
}

/// @nodoc
class __$$PlayerPerformanceResponseImplCopyWithImpl<$Res>
    extends
        _$PlayerPerformanceResponseCopyWithImpl<
          $Res,
          _$PlayerPerformanceResponseImpl
        >
    implements _$$PlayerPerformanceResponseImplCopyWith<$Res> {
  __$$PlayerPerformanceResponseImplCopyWithImpl(
    _$PlayerPerformanceResponseImpl _value,
    $Res Function(_$PlayerPerformanceResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerPerformanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? it = null}) {
    return _then(
      _$PlayerPerformanceResponseImpl(
        it: null == it
            ? _value._it
            : it // ignore: cast_nullable_to_non_nullable
                  as List<SeasonPerformance>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerPerformanceResponseImpl implements _PlayerPerformanceResponse {
  const _$PlayerPerformanceResponseImpl({
    required final List<SeasonPerformance> it,
  }) : _it = it;

  factory _$PlayerPerformanceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerPerformanceResponseImplFromJson(json);

  final List<SeasonPerformance> _it;
  @override
  List<SeasonPerformance> get it {
    if (_it is EqualUnmodifiableListView) return _it;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_it);
  }

  @override
  String toString() {
    return 'PlayerPerformanceResponse(it: $it)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerPerformanceResponseImpl &&
            const DeepCollectionEquality().equals(other._it, _it));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_it));

  /// Create a copy of PlayerPerformanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerPerformanceResponseImplCopyWith<_$PlayerPerformanceResponseImpl>
  get copyWith =>
      __$$PlayerPerformanceResponseImplCopyWithImpl<
        _$PlayerPerformanceResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerPerformanceResponseImplToJson(this);
  }
}

abstract class _PlayerPerformanceResponse implements PlayerPerformanceResponse {
  const factory _PlayerPerformanceResponse({
    required final List<SeasonPerformance> it,
  }) = _$PlayerPerformanceResponseImpl;

  factory _PlayerPerformanceResponse.fromJson(Map<String, dynamic> json) =
      _$PlayerPerformanceResponseImpl.fromJson;

  @override
  List<SeasonPerformance> get it;

  /// Create a copy of PlayerPerformanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerPerformanceResponseImplCopyWith<_$PlayerPerformanceResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SeasonPerformance _$SeasonPerformanceFromJson(Map<String, dynamic> json) {
  return _SeasonPerformance.fromJson(json);
}

/// @nodoc
mixin _$SeasonPerformance {
  String get ti => throw _privateConstructorUsedError;
  String get n => throw _privateConstructorUsedError;
  List<MatchPerformance> get ph => throw _privateConstructorUsedError;

  /// Serializes this SeasonPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeasonPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeasonPerformanceCopyWith<SeasonPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonPerformanceCopyWith<$Res> {
  factory $SeasonPerformanceCopyWith(
    SeasonPerformance value,
    $Res Function(SeasonPerformance) then,
  ) = _$SeasonPerformanceCopyWithImpl<$Res, SeasonPerformance>;
  @useResult
  $Res call({String ti, String n, List<MatchPerformance> ph});
}

/// @nodoc
class _$SeasonPerformanceCopyWithImpl<$Res, $Val extends SeasonPerformance>
    implements $SeasonPerformanceCopyWith<$Res> {
  _$SeasonPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeasonPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ti = null, Object? n = null, Object? ph = null}) {
    return _then(
      _value.copyWith(
            ti: null == ti
                ? _value.ti
                : ti // ignore: cast_nullable_to_non_nullable
                      as String,
            n: null == n
                ? _value.n
                : n // ignore: cast_nullable_to_non_nullable
                      as String,
            ph: null == ph
                ? _value.ph
                : ph // ignore: cast_nullable_to_non_nullable
                      as List<MatchPerformance>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SeasonPerformanceImplCopyWith<$Res>
    implements $SeasonPerformanceCopyWith<$Res> {
  factory _$$SeasonPerformanceImplCopyWith(
    _$SeasonPerformanceImpl value,
    $Res Function(_$SeasonPerformanceImpl) then,
  ) = __$$SeasonPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ti, String n, List<MatchPerformance> ph});
}

/// @nodoc
class __$$SeasonPerformanceImplCopyWithImpl<$Res>
    extends _$SeasonPerformanceCopyWithImpl<$Res, _$SeasonPerformanceImpl>
    implements _$$SeasonPerformanceImplCopyWith<$Res> {
  __$$SeasonPerformanceImplCopyWithImpl(
    _$SeasonPerformanceImpl _value,
    $Res Function(_$SeasonPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SeasonPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ti = null, Object? n = null, Object? ph = null}) {
    return _then(
      _$SeasonPerformanceImpl(
        ti: null == ti
            ? _value.ti
            : ti // ignore: cast_nullable_to_non_nullable
                  as String,
        n: null == n
            ? _value.n
            : n // ignore: cast_nullable_to_non_nullable
                  as String,
        ph: null == ph
            ? _value._ph
            : ph // ignore: cast_nullable_to_non_nullable
                  as List<MatchPerformance>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SeasonPerformanceImpl implements _SeasonPerformance {
  const _$SeasonPerformanceImpl({
    required this.ti,
    required this.n,
    required final List<MatchPerformance> ph,
  }) : _ph = ph;

  factory _$SeasonPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeasonPerformanceImplFromJson(json);

  @override
  final String ti;
  @override
  final String n;
  final List<MatchPerformance> _ph;
  @override
  List<MatchPerformance> get ph {
    if (_ph is EqualUnmodifiableListView) return _ph;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ph);
  }

  @override
  String toString() {
    return 'SeasonPerformance(ti: $ti, n: $n, ph: $ph)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonPerformanceImpl &&
            (identical(other.ti, ti) || other.ti == ti) &&
            (identical(other.n, n) || other.n == n) &&
            const DeepCollectionEquality().equals(other._ph, _ph));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, ti, n, const DeepCollectionEquality().hash(_ph));

  /// Create a copy of SeasonPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonPerformanceImplCopyWith<_$SeasonPerformanceImpl> get copyWith =>
      __$$SeasonPerformanceImplCopyWithImpl<_$SeasonPerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SeasonPerformanceImplToJson(this);
  }
}

abstract class _SeasonPerformance implements SeasonPerformance {
  const factory _SeasonPerformance({
    required final String ti,
    required final String n,
    required final List<MatchPerformance> ph,
  }) = _$SeasonPerformanceImpl;

  factory _SeasonPerformance.fromJson(Map<String, dynamic> json) =
      _$SeasonPerformanceImpl.fromJson;

  @override
  String get ti;
  @override
  String get n;
  @override
  List<MatchPerformance> get ph;

  /// Create a copy of SeasonPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeasonPerformanceImplCopyWith<_$SeasonPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchPerformance _$MatchPerformanceFromJson(Map<String, dynamic> json) {
  return _MatchPerformance.fromJson(json);
}

/// @nodoc
mixin _$MatchPerformance {
  int get day => throw _privateConstructorUsedError;
  int? get p => throw _privateConstructorUsedError;
  String? get mp => throw _privateConstructorUsedError;
  String get md => throw _privateConstructorUsedError;
  String get t1 => throw _privateConstructorUsedError;
  String get t2 => throw _privateConstructorUsedError;
  int? get t1g => throw _privateConstructorUsedError;
  int? get t2g => throw _privateConstructorUsedError;
  String? get pt => throw _privateConstructorUsedError;
  List<int>? get k => throw _privateConstructorUsedError;
  int get st => throw _privateConstructorUsedError;
  bool get cur => throw _privateConstructorUsedError;
  int get mdst => throw _privateConstructorUsedError;
  int? get ap => throw _privateConstructorUsedError;
  int? get tp => throw _privateConstructorUsedError;
  int? get asp => throw _privateConstructorUsedError;

  /// Serializes this MatchPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchPerformanceCopyWith<MatchPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchPerformanceCopyWith<$Res> {
  factory $MatchPerformanceCopyWith(
    MatchPerformance value,
    $Res Function(MatchPerformance) then,
  ) = _$MatchPerformanceCopyWithImpl<$Res, MatchPerformance>;
  @useResult
  $Res call({
    int day,
    int? p,
    String? mp,
    String md,
    String t1,
    String t2,
    int? t1g,
    int? t2g,
    String? pt,
    List<int>? k,
    int st,
    bool cur,
    int mdst,
    int? ap,
    int? tp,
    int? asp,
  });
}

/// @nodoc
class _$MatchPerformanceCopyWithImpl<$Res, $Val extends MatchPerformance>
    implements $MatchPerformanceCopyWith<$Res> {
  _$MatchPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? p = freezed,
    Object? mp = freezed,
    Object? md = null,
    Object? t1 = null,
    Object? t2 = null,
    Object? t1g = freezed,
    Object? t2g = freezed,
    Object? pt = freezed,
    Object? k = freezed,
    Object? st = null,
    Object? cur = null,
    Object? mdst = null,
    Object? ap = freezed,
    Object? tp = freezed,
    Object? asp = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            p: freezed == p
                ? _value.p
                : p // ignore: cast_nullable_to_non_nullable
                      as int?,
            mp: freezed == mp
                ? _value.mp
                : mp // ignore: cast_nullable_to_non_nullable
                      as String?,
            md: null == md
                ? _value.md
                : md // ignore: cast_nullable_to_non_nullable
                      as String,
            t1: null == t1
                ? _value.t1
                : t1 // ignore: cast_nullable_to_non_nullable
                      as String,
            t2: null == t2
                ? _value.t2
                : t2 // ignore: cast_nullable_to_non_nullable
                      as String,
            t1g: freezed == t1g
                ? _value.t1g
                : t1g // ignore: cast_nullable_to_non_nullable
                      as int?,
            t2g: freezed == t2g
                ? _value.t2g
                : t2g // ignore: cast_nullable_to_non_nullable
                      as int?,
            pt: freezed == pt
                ? _value.pt
                : pt // ignore: cast_nullable_to_non_nullable
                      as String?,
            k: freezed == k
                ? _value.k
                : k // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            st: null == st
                ? _value.st
                : st // ignore: cast_nullable_to_non_nullable
                      as int,
            cur: null == cur
                ? _value.cur
                : cur // ignore: cast_nullable_to_non_nullable
                      as bool,
            mdst: null == mdst
                ? _value.mdst
                : mdst // ignore: cast_nullable_to_non_nullable
                      as int,
            ap: freezed == ap
                ? _value.ap
                : ap // ignore: cast_nullable_to_non_nullable
                      as int?,
            tp: freezed == tp
                ? _value.tp
                : tp // ignore: cast_nullable_to_non_nullable
                      as int?,
            asp: freezed == asp
                ? _value.asp
                : asp // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchPerformanceImplCopyWith<$Res>
    implements $MatchPerformanceCopyWith<$Res> {
  factory _$$MatchPerformanceImplCopyWith(
    _$MatchPerformanceImpl value,
    $Res Function(_$MatchPerformanceImpl) then,
  ) = __$$MatchPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int day,
    int? p,
    String? mp,
    String md,
    String t1,
    String t2,
    int? t1g,
    int? t2g,
    String? pt,
    List<int>? k,
    int st,
    bool cur,
    int mdst,
    int? ap,
    int? tp,
    int? asp,
  });
}

/// @nodoc
class __$$MatchPerformanceImplCopyWithImpl<$Res>
    extends _$MatchPerformanceCopyWithImpl<$Res, _$MatchPerformanceImpl>
    implements _$$MatchPerformanceImplCopyWith<$Res> {
  __$$MatchPerformanceImplCopyWithImpl(
    _$MatchPerformanceImpl _value,
    $Res Function(_$MatchPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? p = freezed,
    Object? mp = freezed,
    Object? md = null,
    Object? t1 = null,
    Object? t2 = null,
    Object? t1g = freezed,
    Object? t2g = freezed,
    Object? pt = freezed,
    Object? k = freezed,
    Object? st = null,
    Object? cur = null,
    Object? mdst = null,
    Object? ap = freezed,
    Object? tp = freezed,
    Object? asp = freezed,
  }) {
    return _then(
      _$MatchPerformanceImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        p: freezed == p
            ? _value.p
            : p // ignore: cast_nullable_to_non_nullable
                  as int?,
        mp: freezed == mp
            ? _value.mp
            : mp // ignore: cast_nullable_to_non_nullable
                  as String?,
        md: null == md
            ? _value.md
            : md // ignore: cast_nullable_to_non_nullable
                  as String,
        t1: null == t1
            ? _value.t1
            : t1 // ignore: cast_nullable_to_non_nullable
                  as String,
        t2: null == t2
            ? _value.t2
            : t2 // ignore: cast_nullable_to_non_nullable
                  as String,
        t1g: freezed == t1g
            ? _value.t1g
            : t1g // ignore: cast_nullable_to_non_nullable
                  as int?,
        t2g: freezed == t2g
            ? _value.t2g
            : t2g // ignore: cast_nullable_to_non_nullable
                  as int?,
        pt: freezed == pt
            ? _value.pt
            : pt // ignore: cast_nullable_to_non_nullable
                  as String?,
        k: freezed == k
            ? _value._k
            : k // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        st: null == st
            ? _value.st
            : st // ignore: cast_nullable_to_non_nullable
                  as int,
        cur: null == cur
            ? _value.cur
            : cur // ignore: cast_nullable_to_non_nullable
                  as bool,
        mdst: null == mdst
            ? _value.mdst
            : mdst // ignore: cast_nullable_to_non_nullable
                  as int,
        ap: freezed == ap
            ? _value.ap
            : ap // ignore: cast_nullable_to_non_nullable
                  as int?,
        tp: freezed == tp
            ? _value.tp
            : tp // ignore: cast_nullable_to_non_nullable
                  as int?,
        asp: freezed == asp
            ? _value.asp
            : asp // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchPerformanceImpl implements _MatchPerformance {
  const _$MatchPerformanceImpl({
    required this.day,
    this.p,
    this.mp,
    required this.md,
    required this.t1,
    required this.t2,
    this.t1g,
    this.t2g,
    this.pt,
    final List<int>? k,
    required this.st,
    required this.cur,
    required this.mdst,
    this.ap,
    this.tp,
    this.asp,
  }) : _k = k;

  factory _$MatchPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchPerformanceImplFromJson(json);

  @override
  final int day;
  @override
  final int? p;
  @override
  final String? mp;
  @override
  final String md;
  @override
  final String t1;
  @override
  final String t2;
  @override
  final int? t1g;
  @override
  final int? t2g;
  @override
  final String? pt;
  final List<int>? _k;
  @override
  List<int>? get k {
    final value = _k;
    if (value == null) return null;
    if (_k is EqualUnmodifiableListView) return _k;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int st;
  @override
  final bool cur;
  @override
  final int mdst;
  @override
  final int? ap;
  @override
  final int? tp;
  @override
  final int? asp;

  @override
  String toString() {
    return 'MatchPerformance(day: $day, p: $p, mp: $mp, md: $md, t1: $t1, t2: $t2, t1g: $t1g, t2g: $t2g, pt: $pt, k: $k, st: $st, cur: $cur, mdst: $mdst, ap: $ap, tp: $tp, asp: $asp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchPerformanceImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.p, p) || other.p == p) &&
            (identical(other.mp, mp) || other.mp == mp) &&
            (identical(other.md, md) || other.md == md) &&
            (identical(other.t1, t1) || other.t1 == t1) &&
            (identical(other.t2, t2) || other.t2 == t2) &&
            (identical(other.t1g, t1g) || other.t1g == t1g) &&
            (identical(other.t2g, t2g) || other.t2g == t2g) &&
            (identical(other.pt, pt) || other.pt == pt) &&
            const DeepCollectionEquality().equals(other._k, _k) &&
            (identical(other.st, st) || other.st == st) &&
            (identical(other.cur, cur) || other.cur == cur) &&
            (identical(other.mdst, mdst) || other.mdst == mdst) &&
            (identical(other.ap, ap) || other.ap == ap) &&
            (identical(other.tp, tp) || other.tp == tp) &&
            (identical(other.asp, asp) || other.asp == asp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    p,
    mp,
    md,
    t1,
    t2,
    t1g,
    t2g,
    pt,
    const DeepCollectionEquality().hash(_k),
    st,
    cur,
    mdst,
    ap,
    tp,
    asp,
  );

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchPerformanceImplCopyWith<_$MatchPerformanceImpl> get copyWith =>
      __$$MatchPerformanceImplCopyWithImpl<_$MatchPerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchPerformanceImplToJson(this);
  }
}

abstract class _MatchPerformance implements MatchPerformance {
  const factory _MatchPerformance({
    required final int day,
    final int? p,
    final String? mp,
    required final String md,
    required final String t1,
    required final String t2,
    final int? t1g,
    final int? t2g,
    final String? pt,
    final List<int>? k,
    required final int st,
    required final bool cur,
    required final int mdst,
    final int? ap,
    final int? tp,
    final int? asp,
  }) = _$MatchPerformanceImpl;

  factory _MatchPerformance.fromJson(Map<String, dynamic> json) =
      _$MatchPerformanceImpl.fromJson;

  @override
  int get day;
  @override
  int? get p;
  @override
  String? get mp;
  @override
  String get md;
  @override
  String get t1;
  @override
  String get t2;
  @override
  int? get t1g;
  @override
  int? get t2g;
  @override
  String? get pt;
  @override
  List<int>? get k;
  @override
  int get st;
  @override
  bool get cur;
  @override
  int get mdst;
  @override
  int? get ap;
  @override
  int? get tp;
  @override
  int? get asp;

  /// Create a copy of MatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchPerformanceImplCopyWith<_$MatchPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnhancedMatchPerformance _$EnhancedMatchPerformanceFromJson(
  Map<String, dynamic> json,
) {
  return _EnhancedMatchPerformance.fromJson(json);
}

/// @nodoc
mixin _$EnhancedMatchPerformance {
  MatchPerformance get basePerformance => throw _privateConstructorUsedError;
  String? get team1Name => throw _privateConstructorUsedError;
  String? get team2Name => throw _privateConstructorUsedError;
  String? get playerTeamName => throw _privateConstructorUsedError;
  String? get opponentTeamName => throw _privateConstructorUsedError;
  int? get team1Placement => throw _privateConstructorUsedError;
  int? get team2Placement => throw _privateConstructorUsedError;
  int? get playerTeamPlacement => throw _privateConstructorUsedError;
  int? get opponentTeamPlacement => throw _privateConstructorUsedError;

  /// Serializes this EnhancedMatchPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnhancedMatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnhancedMatchPerformanceCopyWith<EnhancedMatchPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnhancedMatchPerformanceCopyWith<$Res> {
  factory $EnhancedMatchPerformanceCopyWith(
    EnhancedMatchPerformance value,
    $Res Function(EnhancedMatchPerformance) then,
  ) = _$EnhancedMatchPerformanceCopyWithImpl<$Res, EnhancedMatchPerformance>;
  @useResult
  $Res call({
    MatchPerformance basePerformance,
    String? team1Name,
    String? team2Name,
    String? playerTeamName,
    String? opponentTeamName,
    int? team1Placement,
    int? team2Placement,
    int? playerTeamPlacement,
    int? opponentTeamPlacement,
  });

  $MatchPerformanceCopyWith<$Res> get basePerformance;
}

/// @nodoc
class _$EnhancedMatchPerformanceCopyWithImpl<
  $Res,
  $Val extends EnhancedMatchPerformance
>
    implements $EnhancedMatchPerformanceCopyWith<$Res> {
  _$EnhancedMatchPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnhancedMatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? basePerformance = null,
    Object? team1Name = freezed,
    Object? team2Name = freezed,
    Object? playerTeamName = freezed,
    Object? opponentTeamName = freezed,
    Object? team1Placement = freezed,
    Object? team2Placement = freezed,
    Object? playerTeamPlacement = freezed,
    Object? opponentTeamPlacement = freezed,
  }) {
    return _then(
      _value.copyWith(
            basePerformance: null == basePerformance
                ? _value.basePerformance
                : basePerformance // ignore: cast_nullable_to_non_nullable
                      as MatchPerformance,
            team1Name: freezed == team1Name
                ? _value.team1Name
                : team1Name // ignore: cast_nullable_to_non_nullable
                      as String?,
            team2Name: freezed == team2Name
                ? _value.team2Name
                : team2Name // ignore: cast_nullable_to_non_nullable
                      as String?,
            playerTeamName: freezed == playerTeamName
                ? _value.playerTeamName
                : playerTeamName // ignore: cast_nullable_to_non_nullable
                      as String?,
            opponentTeamName: freezed == opponentTeamName
                ? _value.opponentTeamName
                : opponentTeamName // ignore: cast_nullable_to_non_nullable
                      as String?,
            team1Placement: freezed == team1Placement
                ? _value.team1Placement
                : team1Placement // ignore: cast_nullable_to_non_nullable
                      as int?,
            team2Placement: freezed == team2Placement
                ? _value.team2Placement
                : team2Placement // ignore: cast_nullable_to_non_nullable
                      as int?,
            playerTeamPlacement: freezed == playerTeamPlacement
                ? _value.playerTeamPlacement
                : playerTeamPlacement // ignore: cast_nullable_to_non_nullable
                      as int?,
            opponentTeamPlacement: freezed == opponentTeamPlacement
                ? _value.opponentTeamPlacement
                : opponentTeamPlacement // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of EnhancedMatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchPerformanceCopyWith<$Res> get basePerformance {
    return $MatchPerformanceCopyWith<$Res>(_value.basePerformance, (value) {
      return _then(_value.copyWith(basePerformance: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EnhancedMatchPerformanceImplCopyWith<$Res>
    implements $EnhancedMatchPerformanceCopyWith<$Res> {
  factory _$$EnhancedMatchPerformanceImplCopyWith(
    _$EnhancedMatchPerformanceImpl value,
    $Res Function(_$EnhancedMatchPerformanceImpl) then,
  ) = __$$EnhancedMatchPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MatchPerformance basePerformance,
    String? team1Name,
    String? team2Name,
    String? playerTeamName,
    String? opponentTeamName,
    int? team1Placement,
    int? team2Placement,
    int? playerTeamPlacement,
    int? opponentTeamPlacement,
  });

  @override
  $MatchPerformanceCopyWith<$Res> get basePerformance;
}

/// @nodoc
class __$$EnhancedMatchPerformanceImplCopyWithImpl<$Res>
    extends
        _$EnhancedMatchPerformanceCopyWithImpl<
          $Res,
          _$EnhancedMatchPerformanceImpl
        >
    implements _$$EnhancedMatchPerformanceImplCopyWith<$Res> {
  __$$EnhancedMatchPerformanceImplCopyWithImpl(
    _$EnhancedMatchPerformanceImpl _value,
    $Res Function(_$EnhancedMatchPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnhancedMatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? basePerformance = null,
    Object? team1Name = freezed,
    Object? team2Name = freezed,
    Object? playerTeamName = freezed,
    Object? opponentTeamName = freezed,
    Object? team1Placement = freezed,
    Object? team2Placement = freezed,
    Object? playerTeamPlacement = freezed,
    Object? opponentTeamPlacement = freezed,
  }) {
    return _then(
      _$EnhancedMatchPerformanceImpl(
        basePerformance: null == basePerformance
            ? _value.basePerformance
            : basePerformance // ignore: cast_nullable_to_non_nullable
                  as MatchPerformance,
        team1Name: freezed == team1Name
            ? _value.team1Name
            : team1Name // ignore: cast_nullable_to_non_nullable
                  as String?,
        team2Name: freezed == team2Name
            ? _value.team2Name
            : team2Name // ignore: cast_nullable_to_non_nullable
                  as String?,
        playerTeamName: freezed == playerTeamName
            ? _value.playerTeamName
            : playerTeamName // ignore: cast_nullable_to_non_nullable
                  as String?,
        opponentTeamName: freezed == opponentTeamName
            ? _value.opponentTeamName
            : opponentTeamName // ignore: cast_nullable_to_non_nullable
                  as String?,
        team1Placement: freezed == team1Placement
            ? _value.team1Placement
            : team1Placement // ignore: cast_nullable_to_non_nullable
                  as int?,
        team2Placement: freezed == team2Placement
            ? _value.team2Placement
            : team2Placement // ignore: cast_nullable_to_non_nullable
                  as int?,
        playerTeamPlacement: freezed == playerTeamPlacement
            ? _value.playerTeamPlacement
            : playerTeamPlacement // ignore: cast_nullable_to_non_nullable
                  as int?,
        opponentTeamPlacement: freezed == opponentTeamPlacement
            ? _value.opponentTeamPlacement
            : opponentTeamPlacement // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnhancedMatchPerformanceImpl implements _EnhancedMatchPerformance {
  const _$EnhancedMatchPerformanceImpl({
    required this.basePerformance,
    this.team1Name,
    this.team2Name,
    this.playerTeamName,
    this.opponentTeamName,
    this.team1Placement,
    this.team2Placement,
    this.playerTeamPlacement,
    this.opponentTeamPlacement,
  });

  factory _$EnhancedMatchPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnhancedMatchPerformanceImplFromJson(json);

  @override
  final MatchPerformance basePerformance;
  @override
  final String? team1Name;
  @override
  final String? team2Name;
  @override
  final String? playerTeamName;
  @override
  final String? opponentTeamName;
  @override
  final int? team1Placement;
  @override
  final int? team2Placement;
  @override
  final int? playerTeamPlacement;
  @override
  final int? opponentTeamPlacement;

  @override
  String toString() {
    return 'EnhancedMatchPerformance(basePerformance: $basePerformance, team1Name: $team1Name, team2Name: $team2Name, playerTeamName: $playerTeamName, opponentTeamName: $opponentTeamName, team1Placement: $team1Placement, team2Placement: $team2Placement, playerTeamPlacement: $playerTeamPlacement, opponentTeamPlacement: $opponentTeamPlacement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnhancedMatchPerformanceImpl &&
            (identical(other.basePerformance, basePerformance) ||
                other.basePerformance == basePerformance) &&
            (identical(other.team1Name, team1Name) ||
                other.team1Name == team1Name) &&
            (identical(other.team2Name, team2Name) ||
                other.team2Name == team2Name) &&
            (identical(other.playerTeamName, playerTeamName) ||
                other.playerTeamName == playerTeamName) &&
            (identical(other.opponentTeamName, opponentTeamName) ||
                other.opponentTeamName == opponentTeamName) &&
            (identical(other.team1Placement, team1Placement) ||
                other.team1Placement == team1Placement) &&
            (identical(other.team2Placement, team2Placement) ||
                other.team2Placement == team2Placement) &&
            (identical(other.playerTeamPlacement, playerTeamPlacement) ||
                other.playerTeamPlacement == playerTeamPlacement) &&
            (identical(other.opponentTeamPlacement, opponentTeamPlacement) ||
                other.opponentTeamPlacement == opponentTeamPlacement));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    basePerformance,
    team1Name,
    team2Name,
    playerTeamName,
    opponentTeamName,
    team1Placement,
    team2Placement,
    playerTeamPlacement,
    opponentTeamPlacement,
  );

  /// Create a copy of EnhancedMatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnhancedMatchPerformanceImplCopyWith<_$EnhancedMatchPerformanceImpl>
  get copyWith =>
      __$$EnhancedMatchPerformanceImplCopyWithImpl<
        _$EnhancedMatchPerformanceImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnhancedMatchPerformanceImplToJson(this);
  }
}

abstract class _EnhancedMatchPerformance implements EnhancedMatchPerformance {
  const factory _EnhancedMatchPerformance({
    required final MatchPerformance basePerformance,
    final String? team1Name,
    final String? team2Name,
    final String? playerTeamName,
    final String? opponentTeamName,
    final int? team1Placement,
    final int? team2Placement,
    final int? playerTeamPlacement,
    final int? opponentTeamPlacement,
  }) = _$EnhancedMatchPerformanceImpl;

  factory _EnhancedMatchPerformance.fromJson(Map<String, dynamic> json) =
      _$EnhancedMatchPerformanceImpl.fromJson;

  @override
  MatchPerformance get basePerformance;
  @override
  String? get team1Name;
  @override
  String? get team2Name;
  @override
  String? get playerTeamName;
  @override
  String? get opponentTeamName;
  @override
  int? get team1Placement;
  @override
  int? get team2Placement;
  @override
  int? get playerTeamPlacement;
  @override
  int? get opponentTeamPlacement;

  /// Create a copy of EnhancedMatchPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnhancedMatchPerformanceImplCopyWith<_$EnhancedMatchPerformanceImpl>
  get copyWith => throw _privateConstructorUsedError;
}
