// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ligainsider_match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LineupPlayer _$LineupPlayerFromJson(Map<String, dynamic> json) {
  return _LineupPlayer.fromJson(json);
}

/// @nodoc
mixin _$LineupPlayer {
  String get name => throw _privateConstructorUsedError;
  String? get ligainsiderId => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get alternative => throw _privateConstructorUsedError;

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
    String name,
    String? ligainsiderId,
    String? imageUrl,
    String? alternative,
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
    Object? name = null,
    Object? ligainsiderId = freezed,
    Object? imageUrl = freezed,
    Object? alternative = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            ligainsiderId: freezed == ligainsiderId
                ? _value.ligainsiderId
                : ligainsiderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            alternative: freezed == alternative
                ? _value.alternative
                : alternative // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String name,
    String? ligainsiderId,
    String? imageUrl,
    String? alternative,
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
    Object? name = null,
    Object? ligainsiderId = freezed,
    Object? imageUrl = freezed,
    Object? alternative = freezed,
  }) {
    return _then(
      _$LineupPlayerImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        ligainsiderId: freezed == ligainsiderId
            ? _value.ligainsiderId
            : ligainsiderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        alternative: freezed == alternative
            ? _value.alternative
            : alternative // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LineupPlayerImpl implements _LineupPlayer {
  const _$LineupPlayerImpl({
    required this.name,
    this.ligainsiderId,
    this.imageUrl,
    this.alternative,
  });

  factory _$LineupPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupPlayerImplFromJson(json);

  @override
  final String name;
  @override
  final String? ligainsiderId;
  @override
  final String? imageUrl;
  @override
  final String? alternative;

  @override
  String toString() {
    return 'LineupPlayer(name: $name, ligainsiderId: $ligainsiderId, imageUrl: $imageUrl, alternative: $alternative)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupPlayerImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ligainsiderId, ligainsiderId) ||
                other.ligainsiderId == ligainsiderId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.alternative, alternative) ||
                other.alternative == alternative));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, ligainsiderId, imageUrl, alternative);

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
    required final String name,
    final String? ligainsiderId,
    final String? imageUrl,
    final String? alternative,
  }) = _$LineupPlayerImpl;

  factory _LineupPlayer.fromJson(Map<String, dynamic> json) =
      _$LineupPlayerImpl.fromJson;

  @override
  String get name;
  @override
  String? get ligainsiderId;
  @override
  String? get imageUrl;
  @override
  String? get alternative;

  /// Create a copy of LineupPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupPlayerImplCopyWith<_$LineupPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LineupRow _$LineupRowFromJson(Map<String, dynamic> json) {
  return _LineupRow.fromJson(json);
}

/// @nodoc
mixin _$LineupRow {
  String get rowName => throw _privateConstructorUsedError;
  List<LineupPlayer> get players => throw _privateConstructorUsedError;

  /// Serializes this LineupRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LineupRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineupRowCopyWith<LineupRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineupRowCopyWith<$Res> {
  factory $LineupRowCopyWith(LineupRow value, $Res Function(LineupRow) then) =
      _$LineupRowCopyWithImpl<$Res, LineupRow>;
  @useResult
  $Res call({String rowName, List<LineupPlayer> players});
}

/// @nodoc
class _$LineupRowCopyWithImpl<$Res, $Val extends LineupRow>
    implements $LineupRowCopyWith<$Res> {
  _$LineupRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LineupRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rowName = null, Object? players = null}) {
    return _then(
      _value.copyWith(
            rowName: null == rowName
                ? _value.rowName
                : rowName // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$LineupRowImplCopyWith<$Res>
    implements $LineupRowCopyWith<$Res> {
  factory _$$LineupRowImplCopyWith(
    _$LineupRowImpl value,
    $Res Function(_$LineupRowImpl) then,
  ) = __$$LineupRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String rowName, List<LineupPlayer> players});
}

/// @nodoc
class __$$LineupRowImplCopyWithImpl<$Res>
    extends _$LineupRowCopyWithImpl<$Res, _$LineupRowImpl>
    implements _$$LineupRowImplCopyWith<$Res> {
  __$$LineupRowImplCopyWithImpl(
    _$LineupRowImpl _value,
    $Res Function(_$LineupRowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LineupRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? rowName = null, Object? players = null}) {
    return _then(
      _$LineupRowImpl(
        rowName: null == rowName
            ? _value.rowName
            : rowName // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$LineupRowImpl implements _LineupRow {
  const _$LineupRowImpl({
    required this.rowName,
    required final List<LineupPlayer> players,
  }) : _players = players;

  factory _$LineupRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineupRowImplFromJson(json);

  @override
  final String rowName;
  final List<LineupPlayer> _players;
  @override
  List<LineupPlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'LineupRow(rowName: $rowName, players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineupRowImpl &&
            (identical(other.rowName, rowName) || other.rowName == rowName) &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rowName,
    const DeepCollectionEquality().hash(_players),
  );

  /// Create a copy of LineupRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineupRowImplCopyWith<_$LineupRowImpl> get copyWith =>
      __$$LineupRowImplCopyWithImpl<_$LineupRowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineupRowImplToJson(this);
  }
}

abstract class _LineupRow implements LineupRow {
  const factory _LineupRow({
    required final String rowName,
    required final List<LineupPlayer> players,
  }) = _$LineupRowImpl;

  factory _LineupRow.fromJson(Map<String, dynamic> json) =
      _$LineupRowImpl.fromJson;

  @override
  String get rowName;
  @override
  List<LineupPlayer> get players;

  /// Create a copy of LineupRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineupRowImplCopyWith<_$LineupRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LigainsiderMatch _$LigainsiderMatchFromJson(Map<String, dynamic> json) {
  return _LigainsiderMatch.fromJson(json);
}

/// @nodoc
mixin _$LigainsiderMatch {
  String get id => throw _privateConstructorUsedError;
  String get homeTeam => throw _privateConstructorUsedError;
  String get awayTeam => throw _privateConstructorUsedError;
  String? get homeLogo => throw _privateConstructorUsedError;
  String? get awayLogo => throw _privateConstructorUsedError;
  List<LineupRow> get homeLineup => throw _privateConstructorUsedError;
  List<LineupRow> get awayLineup => throw _privateConstructorUsedError;

  /// Serializes this LigainsiderMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LigainsiderMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LigainsiderMatchCopyWith<LigainsiderMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LigainsiderMatchCopyWith<$Res> {
  factory $LigainsiderMatchCopyWith(
    LigainsiderMatch value,
    $Res Function(LigainsiderMatch) then,
  ) = _$LigainsiderMatchCopyWithImpl<$Res, LigainsiderMatch>;
  @useResult
  $Res call({
    String id,
    String homeTeam,
    String awayTeam,
    String? homeLogo,
    String? awayLogo,
    List<LineupRow> homeLineup,
    List<LineupRow> awayLineup,
  });
}

/// @nodoc
class _$LigainsiderMatchCopyWithImpl<$Res, $Val extends LigainsiderMatch>
    implements $LigainsiderMatchCopyWith<$Res> {
  _$LigainsiderMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LigainsiderMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? homeLogo = freezed,
    Object? awayLogo = freezed,
    Object? homeLineup = null,
    Object? awayLineup = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            homeTeam: null == homeTeam
                ? _value.homeTeam
                : homeTeam // ignore: cast_nullable_to_non_nullable
                      as String,
            awayTeam: null == awayTeam
                ? _value.awayTeam
                : awayTeam // ignore: cast_nullable_to_non_nullable
                      as String,
            homeLogo: freezed == homeLogo
                ? _value.homeLogo
                : homeLogo // ignore: cast_nullable_to_non_nullable
                      as String?,
            awayLogo: freezed == awayLogo
                ? _value.awayLogo
                : awayLogo // ignore: cast_nullable_to_non_nullable
                      as String?,
            homeLineup: null == homeLineup
                ? _value.homeLineup
                : homeLineup // ignore: cast_nullable_to_non_nullable
                      as List<LineupRow>,
            awayLineup: null == awayLineup
                ? _value.awayLineup
                : awayLineup // ignore: cast_nullable_to_non_nullable
                      as List<LineupRow>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LigainsiderMatchImplCopyWith<$Res>
    implements $LigainsiderMatchCopyWith<$Res> {
  factory _$$LigainsiderMatchImplCopyWith(
    _$LigainsiderMatchImpl value,
    $Res Function(_$LigainsiderMatchImpl) then,
  ) = __$$LigainsiderMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String homeTeam,
    String awayTeam,
    String? homeLogo,
    String? awayLogo,
    List<LineupRow> homeLineup,
    List<LineupRow> awayLineup,
  });
}

/// @nodoc
class __$$LigainsiderMatchImplCopyWithImpl<$Res>
    extends _$LigainsiderMatchCopyWithImpl<$Res, _$LigainsiderMatchImpl>
    implements _$$LigainsiderMatchImplCopyWith<$Res> {
  __$$LigainsiderMatchImplCopyWithImpl(
    _$LigainsiderMatchImpl _value,
    $Res Function(_$LigainsiderMatchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LigainsiderMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? homeLogo = freezed,
    Object? awayLogo = freezed,
    Object? homeLineup = null,
    Object? awayLineup = null,
  }) {
    return _then(
      _$LigainsiderMatchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        homeTeam: null == homeTeam
            ? _value.homeTeam
            : homeTeam // ignore: cast_nullable_to_non_nullable
                  as String,
        awayTeam: null == awayTeam
            ? _value.awayTeam
            : awayTeam // ignore: cast_nullable_to_non_nullable
                  as String,
        homeLogo: freezed == homeLogo
            ? _value.homeLogo
            : homeLogo // ignore: cast_nullable_to_non_nullable
                  as String?,
        awayLogo: freezed == awayLogo
            ? _value.awayLogo
            : awayLogo // ignore: cast_nullable_to_non_nullable
                  as String?,
        homeLineup: null == homeLineup
            ? _value._homeLineup
            : homeLineup // ignore: cast_nullable_to_non_nullable
                  as List<LineupRow>,
        awayLineup: null == awayLineup
            ? _value._awayLineup
            : awayLineup // ignore: cast_nullable_to_non_nullable
                  as List<LineupRow>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LigainsiderMatchImpl implements _LigainsiderMatch {
  const _$LigainsiderMatchImpl({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeLogo,
    this.awayLogo,
    required final List<LineupRow> homeLineup,
    required final List<LineupRow> awayLineup,
  }) : _homeLineup = homeLineup,
       _awayLineup = awayLineup;

  factory _$LigainsiderMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$LigainsiderMatchImplFromJson(json);

  @override
  final String id;
  @override
  final String homeTeam;
  @override
  final String awayTeam;
  @override
  final String? homeLogo;
  @override
  final String? awayLogo;
  final List<LineupRow> _homeLineup;
  @override
  List<LineupRow> get homeLineup {
    if (_homeLineup is EqualUnmodifiableListView) return _homeLineup;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_homeLineup);
  }

  final List<LineupRow> _awayLineup;
  @override
  List<LineupRow> get awayLineup {
    if (_awayLineup is EqualUnmodifiableListView) return _awayLineup;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awayLineup);
  }

  @override
  String toString() {
    return 'LigainsiderMatch(id: $id, homeTeam: $homeTeam, awayTeam: $awayTeam, homeLogo: $homeLogo, awayLogo: $awayLogo, homeLineup: $homeLineup, awayLineup: $awayLineup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LigainsiderMatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.homeTeam, homeTeam) ||
                other.homeTeam == homeTeam) &&
            (identical(other.awayTeam, awayTeam) ||
                other.awayTeam == awayTeam) &&
            (identical(other.homeLogo, homeLogo) ||
                other.homeLogo == homeLogo) &&
            (identical(other.awayLogo, awayLogo) ||
                other.awayLogo == awayLogo) &&
            const DeepCollectionEquality().equals(
              other._homeLineup,
              _homeLineup,
            ) &&
            const DeepCollectionEquality().equals(
              other._awayLineup,
              _awayLineup,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    homeTeam,
    awayTeam,
    homeLogo,
    awayLogo,
    const DeepCollectionEquality().hash(_homeLineup),
    const DeepCollectionEquality().hash(_awayLineup),
  );

  /// Create a copy of LigainsiderMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LigainsiderMatchImplCopyWith<_$LigainsiderMatchImpl> get copyWith =>
      __$$LigainsiderMatchImplCopyWithImpl<_$LigainsiderMatchImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LigainsiderMatchImplToJson(this);
  }
}

abstract class _LigainsiderMatch implements LigainsiderMatch {
  const factory _LigainsiderMatch({
    required final String id,
    required final String homeTeam,
    required final String awayTeam,
    final String? homeLogo,
    final String? awayLogo,
    required final List<LineupRow> homeLineup,
    required final List<LineupRow> awayLineup,
  }) = _$LigainsiderMatchImpl;

  factory _LigainsiderMatch.fromJson(Map<String, dynamic> json) =
      _$LigainsiderMatchImpl.fromJson;

  @override
  String get id;
  @override
  String get homeTeam;
  @override
  String get awayTeam;
  @override
  String? get homeLogo;
  @override
  String? get awayLogo;
  @override
  List<LineupRow> get homeLineup;
  @override
  List<LineupRow> get awayLineup;

  /// Create a copy of LigainsiderMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LigainsiderMatchImplCopyWith<_$LigainsiderMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
