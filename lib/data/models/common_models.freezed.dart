// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketSeller _$MarketSellerFromJson(Map<String, dynamic> json) {
  return _MarketSeller.fromJson(json);
}

/// @nodoc
mixin _$MarketSeller {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this MarketSeller to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketSeller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketSellerCopyWith<MarketSeller> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketSellerCopyWith<$Res> {
  factory $MarketSellerCopyWith(
    MarketSeller value,
    $Res Function(MarketSeller) then,
  ) = _$MarketSellerCopyWithImpl<$Res, MarketSeller>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$MarketSellerCopyWithImpl<$Res, $Val extends MarketSeller>
    implements $MarketSellerCopyWith<$Res> {
  _$MarketSellerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketSeller
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketSellerImplCopyWith<$Res>
    implements $MarketSellerCopyWith<$Res> {
  factory _$$MarketSellerImplCopyWith(
    _$MarketSellerImpl value,
    $Res Function(_$MarketSellerImpl) then,
  ) = __$$MarketSellerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$MarketSellerImplCopyWithImpl<$Res>
    extends _$MarketSellerCopyWithImpl<$Res, _$MarketSellerImpl>
    implements _$$MarketSellerImplCopyWith<$Res> {
  __$$MarketSellerImplCopyWithImpl(
    _$MarketSellerImpl _value,
    $Res Function(_$MarketSellerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketSeller
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$MarketSellerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketSellerImpl implements _MarketSeller {
  const _$MarketSellerImpl({required this.id, required this.name});

  factory _$MarketSellerImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketSellerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'MarketSeller(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketSellerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of MarketSeller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketSellerImplCopyWith<_$MarketSellerImpl> get copyWith =>
      __$$MarketSellerImplCopyWithImpl<_$MarketSellerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketSellerImplToJson(this);
  }
}

abstract class _MarketSeller implements MarketSeller {
  const factory _MarketSeller({
    required final String id,
    required final String name,
  }) = _$MarketSellerImpl;

  factory _MarketSeller.fromJson(Map<String, dynamic> json) =
      _$MarketSellerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of MarketSeller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketSellerImplCopyWith<_$MarketSellerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerOwner _$PlayerOwnerFromJson(Map<String, dynamic> json) {
  return _PlayerOwner.fromJson(json);
}

/// @nodoc
mixin _$PlayerOwner {
  String get i => throw _privateConstructorUsedError;
  String get n => throw _privateConstructorUsedError;
  String? get uim => throw _privateConstructorUsedError;
  bool? get isvf => throw _privateConstructorUsedError;
  int? get st => throw _privateConstructorUsedError;

  /// Serializes this PlayerOwner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerOwnerCopyWith<PlayerOwner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerOwnerCopyWith<$Res> {
  factory $PlayerOwnerCopyWith(
    PlayerOwner value,
    $Res Function(PlayerOwner) then,
  ) = _$PlayerOwnerCopyWithImpl<$Res, PlayerOwner>;
  @useResult
  $Res call({String i, String n, String? uim, bool? isvf, int? st});
}

/// @nodoc
class _$PlayerOwnerCopyWithImpl<$Res, $Val extends PlayerOwner>
    implements $PlayerOwnerCopyWith<$Res> {
  _$PlayerOwnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? i = null,
    Object? n = null,
    Object? uim = freezed,
    Object? isvf = freezed,
    Object? st = freezed,
  }) {
    return _then(
      _value.copyWith(
            i: null == i
                ? _value.i
                : i // ignore: cast_nullable_to_non_nullable
                      as String,
            n: null == n
                ? _value.n
                : n // ignore: cast_nullable_to_non_nullable
                      as String,
            uim: freezed == uim
                ? _value.uim
                : uim // ignore: cast_nullable_to_non_nullable
                      as String?,
            isvf: freezed == isvf
                ? _value.isvf
                : isvf // ignore: cast_nullable_to_non_nullable
                      as bool?,
            st: freezed == st
                ? _value.st
                : st // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerOwnerImplCopyWith<$Res>
    implements $PlayerOwnerCopyWith<$Res> {
  factory _$$PlayerOwnerImplCopyWith(
    _$PlayerOwnerImpl value,
    $Res Function(_$PlayerOwnerImpl) then,
  ) = __$$PlayerOwnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String i, String n, String? uim, bool? isvf, int? st});
}

/// @nodoc
class __$$PlayerOwnerImplCopyWithImpl<$Res>
    extends _$PlayerOwnerCopyWithImpl<$Res, _$PlayerOwnerImpl>
    implements _$$PlayerOwnerImplCopyWith<$Res> {
  __$$PlayerOwnerImplCopyWithImpl(
    _$PlayerOwnerImpl _value,
    $Res Function(_$PlayerOwnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerOwner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? i = null,
    Object? n = null,
    Object? uim = freezed,
    Object? isvf = freezed,
    Object? st = freezed,
  }) {
    return _then(
      _$PlayerOwnerImpl(
        i: null == i
            ? _value.i
            : i // ignore: cast_nullable_to_non_nullable
                  as String,
        n: null == n
            ? _value.n
            : n // ignore: cast_nullable_to_non_nullable
                  as String,
        uim: freezed == uim
            ? _value.uim
            : uim // ignore: cast_nullable_to_non_nullable
                  as String?,
        isvf: freezed == isvf
            ? _value.isvf
            : isvf // ignore: cast_nullable_to_non_nullable
                  as bool?,
        st: freezed == st
            ? _value.st
            : st // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerOwnerImpl implements _PlayerOwner {
  const _$PlayerOwnerImpl({
    required this.i,
    required this.n,
    this.uim,
    this.isvf,
    this.st,
  });

  factory _$PlayerOwnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerOwnerImplFromJson(json);

  @override
  final String i;
  @override
  final String n;
  @override
  final String? uim;
  @override
  final bool? isvf;
  @override
  final int? st;

  @override
  String toString() {
    return 'PlayerOwner(i: $i, n: $n, uim: $uim, isvf: $isvf, st: $st)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerOwnerImpl &&
            (identical(other.i, i) || other.i == i) &&
            (identical(other.n, n) || other.n == n) &&
            (identical(other.uim, uim) || other.uim == uim) &&
            (identical(other.isvf, isvf) || other.isvf == isvf) &&
            (identical(other.st, st) || other.st == st));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, i, n, uim, isvf, st);

  /// Create a copy of PlayerOwner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerOwnerImplCopyWith<_$PlayerOwnerImpl> get copyWith =>
      __$$PlayerOwnerImplCopyWithImpl<_$PlayerOwnerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerOwnerImplToJson(this);
  }
}

abstract class _PlayerOwner implements PlayerOwner {
  const factory _PlayerOwner({
    required final String i,
    required final String n,
    final String? uim,
    final bool? isvf,
    final int? st,
  }) = _$PlayerOwnerImpl;

  factory _PlayerOwner.fromJson(Map<String, dynamic> json) =
      _$PlayerOwnerImpl.fromJson;

  @override
  String get i;
  @override
  String get n;
  @override
  String? get uim;
  @override
  bool? get isvf;
  @override
  int? get st;

  /// Create a copy of PlayerOwner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerOwnerImplCopyWith<_$PlayerOwnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamInfo _$TeamInfoFromJson(Map<String, dynamic> json) {
  return _TeamInfo.fromJson(json);
}

/// @nodoc
mixin _$TeamInfo {
  String get tid => throw _privateConstructorUsedError;
  String get tn => throw _privateConstructorUsedError;
  int get pl => throw _privateConstructorUsedError;

  /// Serializes this TeamInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamInfoCopyWith<TeamInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamInfoCopyWith<$Res> {
  factory $TeamInfoCopyWith(TeamInfo value, $Res Function(TeamInfo) then) =
      _$TeamInfoCopyWithImpl<$Res, TeamInfo>;
  @useResult
  $Res call({String tid, String tn, int pl});
}

/// @nodoc
class _$TeamInfoCopyWithImpl<$Res, $Val extends TeamInfo>
    implements $TeamInfoCopyWith<$Res> {
  _$TeamInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tid = null, Object? tn = null, Object? pl = null}) {
    return _then(
      _value.copyWith(
            tid: null == tid
                ? _value.tid
                : tid // ignore: cast_nullable_to_non_nullable
                      as String,
            tn: null == tn
                ? _value.tn
                : tn // ignore: cast_nullable_to_non_nullable
                      as String,
            pl: null == pl
                ? _value.pl
                : pl // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamInfoImplCopyWith<$Res>
    implements $TeamInfoCopyWith<$Res> {
  factory _$$TeamInfoImplCopyWith(
    _$TeamInfoImpl value,
    $Res Function(_$TeamInfoImpl) then,
  ) = __$$TeamInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tid, String tn, int pl});
}

/// @nodoc
class __$$TeamInfoImplCopyWithImpl<$Res>
    extends _$TeamInfoCopyWithImpl<$Res, _$TeamInfoImpl>
    implements _$$TeamInfoImplCopyWith<$Res> {
  __$$TeamInfoImplCopyWithImpl(
    _$TeamInfoImpl _value,
    $Res Function(_$TeamInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tid = null, Object? tn = null, Object? pl = null}) {
    return _then(
      _$TeamInfoImpl(
        tid: null == tid
            ? _value.tid
            : tid // ignore: cast_nullable_to_non_nullable
                  as String,
        tn: null == tn
            ? _value.tn
            : tn // ignore: cast_nullable_to_non_nullable
                  as String,
        pl: null == pl
            ? _value.pl
            : pl // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamInfoImpl implements _TeamInfo {
  const _$TeamInfoImpl({required this.tid, required this.tn, required this.pl});

  factory _$TeamInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamInfoImplFromJson(json);

  @override
  final String tid;
  @override
  final String tn;
  @override
  final int pl;

  @override
  String toString() {
    return 'TeamInfo(tid: $tid, tn: $tn, pl: $pl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamInfoImpl &&
            (identical(other.tid, tid) || other.tid == tid) &&
            (identical(other.tn, tn) || other.tn == tn) &&
            (identical(other.pl, pl) || other.pl == pl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tid, tn, pl);

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamInfoImplCopyWith<_$TeamInfoImpl> get copyWith =>
      __$$TeamInfoImplCopyWithImpl<_$TeamInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamInfoImplToJson(this);
  }
}

abstract class _TeamInfo implements TeamInfo {
  const factory _TeamInfo({
    required final String tid,
    required final String tn,
    required final int pl,
  }) = _$TeamInfoImpl;

  factory _TeamInfo.fromJson(Map<String, dynamic> json) =
      _$TeamInfoImpl.fromJson;

  @override
  String get tid;
  @override
  String get tn;
  @override
  int get pl;

  /// Create a copy of TeamInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamInfoImplCopyWith<_$TeamInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamStats _$TeamStatsFromJson(Map<String, dynamic> json) {
  return _TeamStats.fromJson(json);
}

/// @nodoc
mixin _$TeamStats {
  int get teamValue => throw _privateConstructorUsedError;
  int get teamValueTrend => throw _privateConstructorUsedError;
  int get budget => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get placement => throw _privateConstructorUsedError;
  int get won => throw _privateConstructorUsedError;
  int get drawn => throw _privateConstructorUsedError;
  int get lost => throw _privateConstructorUsedError;

  /// Serializes this TeamStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamStatsCopyWith<TeamStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamStatsCopyWith<$Res> {
  factory $TeamStatsCopyWith(TeamStats value, $Res Function(TeamStats) then) =
      _$TeamStatsCopyWithImpl<$Res, TeamStats>;
  @useResult
  $Res call({
    int teamValue,
    int teamValueTrend,
    int budget,
    int points,
    int placement,
    int won,
    int drawn,
    int lost,
  });
}

/// @nodoc
class _$TeamStatsCopyWithImpl<$Res, $Val extends TeamStats>
    implements $TeamStatsCopyWith<$Res> {
  _$TeamStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamValue = null,
    Object? teamValueTrend = null,
    Object? budget = null,
    Object? points = null,
    Object? placement = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
  }) {
    return _then(
      _value.copyWith(
            teamValue: null == teamValue
                ? _value.teamValue
                : teamValue // ignore: cast_nullable_to_non_nullable
                      as int,
            teamValueTrend: null == teamValueTrend
                ? _value.teamValueTrend
                : teamValueTrend // ignore: cast_nullable_to_non_nullable
                      as int,
            budget: null == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                      as int,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            placement: null == placement
                ? _value.placement
                : placement // ignore: cast_nullable_to_non_nullable
                      as int,
            won: null == won
                ? _value.won
                : won // ignore: cast_nullable_to_non_nullable
                      as int,
            drawn: null == drawn
                ? _value.drawn
                : drawn // ignore: cast_nullable_to_non_nullable
                      as int,
            lost: null == lost
                ? _value.lost
                : lost // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamStatsImplCopyWith<$Res>
    implements $TeamStatsCopyWith<$Res> {
  factory _$$TeamStatsImplCopyWith(
    _$TeamStatsImpl value,
    $Res Function(_$TeamStatsImpl) then,
  ) = __$$TeamStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int teamValue,
    int teamValueTrend,
    int budget,
    int points,
    int placement,
    int won,
    int drawn,
    int lost,
  });
}

/// @nodoc
class __$$TeamStatsImplCopyWithImpl<$Res>
    extends _$TeamStatsCopyWithImpl<$Res, _$TeamStatsImpl>
    implements _$$TeamStatsImplCopyWith<$Res> {
  __$$TeamStatsImplCopyWithImpl(
    _$TeamStatsImpl _value,
    $Res Function(_$TeamStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamValue = null,
    Object? teamValueTrend = null,
    Object? budget = null,
    Object? points = null,
    Object? placement = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
  }) {
    return _then(
      _$TeamStatsImpl(
        teamValue: null == teamValue
            ? _value.teamValue
            : teamValue // ignore: cast_nullable_to_non_nullable
                  as int,
        teamValueTrend: null == teamValueTrend
            ? _value.teamValueTrend
            : teamValueTrend // ignore: cast_nullable_to_non_nullable
                  as int,
        budget: null == budget
            ? _value.budget
            : budget // ignore: cast_nullable_to_non_nullable
                  as int,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        placement: null == placement
            ? _value.placement
            : placement // ignore: cast_nullable_to_non_nullable
                  as int,
        won: null == won
            ? _value.won
            : won // ignore: cast_nullable_to_non_nullable
                  as int,
        drawn: null == drawn
            ? _value.drawn
            : drawn // ignore: cast_nullable_to_non_nullable
                  as int,
        lost: null == lost
            ? _value.lost
            : lost // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamStatsImpl implements _TeamStats {
  const _$TeamStatsImpl({
    required this.teamValue,
    required this.teamValueTrend,
    required this.budget,
    required this.points,
    required this.placement,
    required this.won,
    required this.drawn,
    required this.lost,
  });

  factory _$TeamStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamStatsImplFromJson(json);

  @override
  final int teamValue;
  @override
  final int teamValueTrend;
  @override
  final int budget;
  @override
  final int points;
  @override
  final int placement;
  @override
  final int won;
  @override
  final int drawn;
  @override
  final int lost;

  @override
  String toString() {
    return 'TeamStats(teamValue: $teamValue, teamValueTrend: $teamValueTrend, budget: $budget, points: $points, placement: $placement, won: $won, drawn: $drawn, lost: $lost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamStatsImpl &&
            (identical(other.teamValue, teamValue) ||
                other.teamValue == teamValue) &&
            (identical(other.teamValueTrend, teamValueTrend) ||
                other.teamValueTrend == teamValueTrend) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.placement, placement) ||
                other.placement == placement) &&
            (identical(other.won, won) || other.won == won) &&
            (identical(other.drawn, drawn) || other.drawn == drawn) &&
            (identical(other.lost, lost) || other.lost == lost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    teamValue,
    teamValueTrend,
    budget,
    points,
    placement,
    won,
    drawn,
    lost,
  );

  /// Create a copy of TeamStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamStatsImplCopyWith<_$TeamStatsImpl> get copyWith =>
      __$$TeamStatsImplCopyWithImpl<_$TeamStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamStatsImplToJson(this);
  }
}

abstract class _TeamStats implements TeamStats {
  const factory _TeamStats({
    required final int teamValue,
    required final int teamValueTrend,
    required final int budget,
    required final int points,
    required final int placement,
    required final int won,
    required final int drawn,
    required final int lost,
  }) = _$TeamStatsImpl;

  factory _TeamStats.fromJson(Map<String, dynamic> json) =
      _$TeamStatsImpl.fromJson;

  @override
  int get teamValue;
  @override
  int get teamValueTrend;
  @override
  int get budget;
  @override
  int get points;
  @override
  int get placement;
  @override
  int get won;
  @override
  int get drawn;
  @override
  int get lost;

  /// Create a copy of TeamStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamStatsImplCopyWith<_$TeamStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  int get teamValue => throw _privateConstructorUsedError;
  int get teamValueTrend => throw _privateConstructorUsedError;
  int get budget => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get placement => throw _privateConstructorUsedError;
  int get won => throw _privateConstructorUsedError;
  int get drawn => throw _privateConstructorUsedError;
  int get lost => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call({
    int teamValue,
    int teamValueTrend,
    int budget,
    int points,
    int placement,
    int won,
    int drawn,
    int lost,
  });
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamValue = null,
    Object? teamValueTrend = null,
    Object? budget = null,
    Object? points = null,
    Object? placement = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
  }) {
    return _then(
      _value.copyWith(
            teamValue: null == teamValue
                ? _value.teamValue
                : teamValue // ignore: cast_nullable_to_non_nullable
                      as int,
            teamValueTrend: null == teamValueTrend
                ? _value.teamValueTrend
                : teamValueTrend // ignore: cast_nullable_to_non_nullable
                      as int,
            budget: null == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                      as int,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            placement: null == placement
                ? _value.placement
                : placement // ignore: cast_nullable_to_non_nullable
                      as int,
            won: null == won
                ? _value.won
                : won // ignore: cast_nullable_to_non_nullable
                      as int,
            drawn: null == drawn
                ? _value.drawn
                : drawn // ignore: cast_nullable_to_non_nullable
                      as int,
            lost: null == lost
                ? _value.lost
                : lost // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
    _$UserStatsImpl value,
    $Res Function(_$UserStatsImpl) then,
  ) = __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int teamValue,
    int teamValueTrend,
    int budget,
    int points,
    int placement,
    int won,
    int drawn,
    int lost,
  });
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
    _$UserStatsImpl _value,
    $Res Function(_$UserStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? teamValue = null,
    Object? teamValueTrend = null,
    Object? budget = null,
    Object? points = null,
    Object? placement = null,
    Object? won = null,
    Object? drawn = null,
    Object? lost = null,
  }) {
    return _then(
      _$UserStatsImpl(
        teamValue: null == teamValue
            ? _value.teamValue
            : teamValue // ignore: cast_nullable_to_non_nullable
                  as int,
        teamValueTrend: null == teamValueTrend
            ? _value.teamValueTrend
            : teamValueTrend // ignore: cast_nullable_to_non_nullable
                  as int,
        budget: null == budget
            ? _value.budget
            : budget // ignore: cast_nullable_to_non_nullable
                  as int,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        placement: null == placement
            ? _value.placement
            : placement // ignore: cast_nullable_to_non_nullable
                  as int,
        won: null == won
            ? _value.won
            : won // ignore: cast_nullable_to_non_nullable
                  as int,
        drawn: null == drawn
            ? _value.drawn
            : drawn // ignore: cast_nullable_to_non_nullable
                  as int,
        lost: null == lost
            ? _value.lost
            : lost // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl({
    required this.teamValue,
    required this.teamValueTrend,
    required this.budget,
    required this.points,
    required this.placement,
    required this.won,
    required this.drawn,
    required this.lost,
  });

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  final int teamValue;
  @override
  final int teamValueTrend;
  @override
  final int budget;
  @override
  final int points;
  @override
  final int placement;
  @override
  final int won;
  @override
  final int drawn;
  @override
  final int lost;

  @override
  String toString() {
    return 'UserStats(teamValue: $teamValue, teamValueTrend: $teamValueTrend, budget: $budget, points: $points, placement: $placement, won: $won, drawn: $drawn, lost: $lost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.teamValue, teamValue) ||
                other.teamValue == teamValue) &&
            (identical(other.teamValueTrend, teamValueTrend) ||
                other.teamValueTrend == teamValueTrend) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.placement, placement) ||
                other.placement == placement) &&
            (identical(other.won, won) || other.won == won) &&
            (identical(other.drawn, drawn) || other.drawn == drawn) &&
            (identical(other.lost, lost) || other.lost == lost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    teamValue,
    teamValueTrend,
    budget,
    points,
    placement,
    won,
    drawn,
    lost,
  );

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(this);
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats({
    required final int teamValue,
    required final int teamValueTrend,
    required final int budget,
    required final int points,
    required final int placement,
    required final int won,
    required final int drawn,
    required final int lost,
  }) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  int get teamValue;
  @override
  int get teamValueTrend;
  @override
  int get budget;
  @override
  int get points;
  @override
  int get placement;
  @override
  int get won;
  @override
  int get drawn;
  @override
  int get lost;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamProfileResponse _$TeamProfileResponseFromJson(Map<String, dynamic> json) {
  return _TeamProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$TeamProfileResponse {
  String get tid => throw _privateConstructorUsedError;
  String get tn => throw _privateConstructorUsedError;
  int get pl => throw _privateConstructorUsedError;
  int get tv => throw _privateConstructorUsedError;
  int get tw => throw _privateConstructorUsedError;
  int get td => throw _privateConstructorUsedError;
  int get tl => throw _privateConstructorUsedError;
  int get npt => throw _privateConstructorUsedError;
  bool get avpcl => throw _privateConstructorUsedError;

  /// Serializes this TeamProfileResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamProfileResponseCopyWith<TeamProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamProfileResponseCopyWith<$Res> {
  factory $TeamProfileResponseCopyWith(
    TeamProfileResponse value,
    $Res Function(TeamProfileResponse) then,
  ) = _$TeamProfileResponseCopyWithImpl<$Res, TeamProfileResponse>;
  @useResult
  $Res call({
    String tid,
    String tn,
    int pl,
    int tv,
    int tw,
    int td,
    int tl,
    int npt,
    bool avpcl,
  });
}

/// @nodoc
class _$TeamProfileResponseCopyWithImpl<$Res, $Val extends TeamProfileResponse>
    implements $TeamProfileResponseCopyWith<$Res> {
  _$TeamProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tid = null,
    Object? tn = null,
    Object? pl = null,
    Object? tv = null,
    Object? tw = null,
    Object? td = null,
    Object? tl = null,
    Object? npt = null,
    Object? avpcl = null,
  }) {
    return _then(
      _value.copyWith(
            tid: null == tid
                ? _value.tid
                : tid // ignore: cast_nullable_to_non_nullable
                      as String,
            tn: null == tn
                ? _value.tn
                : tn // ignore: cast_nullable_to_non_nullable
                      as String,
            pl: null == pl
                ? _value.pl
                : pl // ignore: cast_nullable_to_non_nullable
                      as int,
            tv: null == tv
                ? _value.tv
                : tv // ignore: cast_nullable_to_non_nullable
                      as int,
            tw: null == tw
                ? _value.tw
                : tw // ignore: cast_nullable_to_non_nullable
                      as int,
            td: null == td
                ? _value.td
                : td // ignore: cast_nullable_to_non_nullable
                      as int,
            tl: null == tl
                ? _value.tl
                : tl // ignore: cast_nullable_to_non_nullable
                      as int,
            npt: null == npt
                ? _value.npt
                : npt // ignore: cast_nullable_to_non_nullable
                      as int,
            avpcl: null == avpcl
                ? _value.avpcl
                : avpcl // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamProfileResponseImplCopyWith<$Res>
    implements $TeamProfileResponseCopyWith<$Res> {
  factory _$$TeamProfileResponseImplCopyWith(
    _$TeamProfileResponseImpl value,
    $Res Function(_$TeamProfileResponseImpl) then,
  ) = __$$TeamProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String tid,
    String tn,
    int pl,
    int tv,
    int tw,
    int td,
    int tl,
    int npt,
    bool avpcl,
  });
}

/// @nodoc
class __$$TeamProfileResponseImplCopyWithImpl<$Res>
    extends _$TeamProfileResponseCopyWithImpl<$Res, _$TeamProfileResponseImpl>
    implements _$$TeamProfileResponseImplCopyWith<$Res> {
  __$$TeamProfileResponseImplCopyWithImpl(
    _$TeamProfileResponseImpl _value,
    $Res Function(_$TeamProfileResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tid = null,
    Object? tn = null,
    Object? pl = null,
    Object? tv = null,
    Object? tw = null,
    Object? td = null,
    Object? tl = null,
    Object? npt = null,
    Object? avpcl = null,
  }) {
    return _then(
      _$TeamProfileResponseImpl(
        tid: null == tid
            ? _value.tid
            : tid // ignore: cast_nullable_to_non_nullable
                  as String,
        tn: null == tn
            ? _value.tn
            : tn // ignore: cast_nullable_to_non_nullable
                  as String,
        pl: null == pl
            ? _value.pl
            : pl // ignore: cast_nullable_to_non_nullable
                  as int,
        tv: null == tv
            ? _value.tv
            : tv // ignore: cast_nullable_to_non_nullable
                  as int,
        tw: null == tw
            ? _value.tw
            : tw // ignore: cast_nullable_to_non_nullable
                  as int,
        td: null == td
            ? _value.td
            : td // ignore: cast_nullable_to_non_nullable
                  as int,
        tl: null == tl
            ? _value.tl
            : tl // ignore: cast_nullable_to_non_nullable
                  as int,
        npt: null == npt
            ? _value.npt
            : npt // ignore: cast_nullable_to_non_nullable
                  as int,
        avpcl: null == avpcl
            ? _value.avpcl
            : avpcl // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamProfileResponseImpl implements _TeamProfileResponse {
  const _$TeamProfileResponseImpl({
    required this.tid,
    required this.tn,
    required this.pl,
    required this.tv,
    required this.tw,
    required this.td,
    required this.tl,
    required this.npt,
    required this.avpcl,
  });

  factory _$TeamProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamProfileResponseImplFromJson(json);

  @override
  final String tid;
  @override
  final String tn;
  @override
  final int pl;
  @override
  final int tv;
  @override
  final int tw;
  @override
  final int td;
  @override
  final int tl;
  @override
  final int npt;
  @override
  final bool avpcl;

  @override
  String toString() {
    return 'TeamProfileResponse(tid: $tid, tn: $tn, pl: $pl, tv: $tv, tw: $tw, td: $td, tl: $tl, npt: $npt, avpcl: $avpcl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamProfileResponseImpl &&
            (identical(other.tid, tid) || other.tid == tid) &&
            (identical(other.tn, tn) || other.tn == tn) &&
            (identical(other.pl, pl) || other.pl == pl) &&
            (identical(other.tv, tv) || other.tv == tv) &&
            (identical(other.tw, tw) || other.tw == tw) &&
            (identical(other.td, td) || other.td == td) &&
            (identical(other.tl, tl) || other.tl == tl) &&
            (identical(other.npt, npt) || other.npt == npt) &&
            (identical(other.avpcl, avpcl) || other.avpcl == avpcl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tid, tn, pl, tv, tw, td, tl, npt, avpcl);

  /// Create a copy of TeamProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamProfileResponseImplCopyWith<_$TeamProfileResponseImpl> get copyWith =>
      __$$TeamProfileResponseImplCopyWithImpl<_$TeamProfileResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamProfileResponseImplToJson(this);
  }
}

abstract class _TeamProfileResponse implements TeamProfileResponse {
  const factory _TeamProfileResponse({
    required final String tid,
    required final String tn,
    required final int pl,
    required final int tv,
    required final int tw,
    required final int td,
    required final int tl,
    required final int npt,
    required final bool avpcl,
  }) = _$TeamProfileResponseImpl;

  factory _TeamProfileResponse.fromJson(Map<String, dynamic> json) =
      _$TeamProfileResponseImpl.fromJson;

  @override
  String get tid;
  @override
  String get tn;
  @override
  int get pl;
  @override
  int get tv;
  @override
  int get tw;
  @override
  int get td;
  @override
  int get tl;
  @override
  int get npt;
  @override
  bool get avpcl;

  /// Create a copy of TeamProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamProfileResponseImplCopyWith<_$TeamProfileResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
