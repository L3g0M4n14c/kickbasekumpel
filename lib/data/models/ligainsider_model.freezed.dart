// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ligainsider_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LigainsiderPlayer _$LigainsiderPlayerFromJson(Map<String, dynamic> json) {
  return _LigainsiderPlayer.fromJson(json);
}

/// @nodoc
mixin _$LigainsiderPlayer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String get teamName => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  String get injury_status => throw _privateConstructorUsedError;
  String? get injury_description => throw _privateConstructorUsedError;
  int? get form_rating => throw _privateConstructorUsedError;
  DateTime get last_update => throw _privateConstructorUsedError;
  String? get status_text => throw _privateConstructorUsedError;
  DateTime? get expected_return => throw _privateConstructorUsedError;

  /// Serializes this LigainsiderPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LigainsiderPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LigainsiderPlayerCopyWith<LigainsiderPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LigainsiderPlayerCopyWith<$Res> {
  factory $LigainsiderPlayerCopyWith(
    LigainsiderPlayer value,
    $Res Function(LigainsiderPlayer) then,
  ) = _$LigainsiderPlayerCopyWithImpl<$Res, LigainsiderPlayer>;
  @useResult
  $Res call({
    String id,
    String name,
    String shortName,
    String teamName,
    String teamId,
    int position,
    String injury_status,
    String? injury_description,
    int? form_rating,
    DateTime last_update,
    String? status_text,
    DateTime? expected_return,
  });
}

/// @nodoc
class _$LigainsiderPlayerCopyWithImpl<$Res, $Val extends LigainsiderPlayer>
    implements $LigainsiderPlayerCopyWith<$Res> {
  _$LigainsiderPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LigainsiderPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = null,
    Object? teamName = null,
    Object? teamId = null,
    Object? position = null,
    Object? injury_status = null,
    Object? injury_description = freezed,
    Object? form_rating = freezed,
    Object? last_update = null,
    Object? status_text = freezed,
    Object? expected_return = freezed,
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
            shortName: null == shortName
                ? _value.shortName
                : shortName // ignore: cast_nullable_to_non_nullable
                      as String,
            teamName: null == teamName
                ? _value.teamName
                : teamName // ignore: cast_nullable_to_non_nullable
                      as String,
            teamId: null == teamId
                ? _value.teamId
                : teamId // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            injury_status: null == injury_status
                ? _value.injury_status
                : injury_status // ignore: cast_nullable_to_non_nullable
                      as String,
            injury_description: freezed == injury_description
                ? _value.injury_description
                : injury_description // ignore: cast_nullable_to_non_nullable
                      as String?,
            form_rating: freezed == form_rating
                ? _value.form_rating
                : form_rating // ignore: cast_nullable_to_non_nullable
                      as int?,
            last_update: null == last_update
                ? _value.last_update
                : last_update // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status_text: freezed == status_text
                ? _value.status_text
                : status_text // ignore: cast_nullable_to_non_nullable
                      as String?,
            expected_return: freezed == expected_return
                ? _value.expected_return
                : expected_return // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LigainsiderPlayerImplCopyWith<$Res>
    implements $LigainsiderPlayerCopyWith<$Res> {
  factory _$$LigainsiderPlayerImplCopyWith(
    _$LigainsiderPlayerImpl value,
    $Res Function(_$LigainsiderPlayerImpl) then,
  ) = __$$LigainsiderPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String shortName,
    String teamName,
    String teamId,
    int position,
    String injury_status,
    String? injury_description,
    int? form_rating,
    DateTime last_update,
    String? status_text,
    DateTime? expected_return,
  });
}

/// @nodoc
class __$$LigainsiderPlayerImplCopyWithImpl<$Res>
    extends _$LigainsiderPlayerCopyWithImpl<$Res, _$LigainsiderPlayerImpl>
    implements _$$LigainsiderPlayerImplCopyWith<$Res> {
  __$$LigainsiderPlayerImplCopyWithImpl(
    _$LigainsiderPlayerImpl _value,
    $Res Function(_$LigainsiderPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LigainsiderPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = null,
    Object? teamName = null,
    Object? teamId = null,
    Object? position = null,
    Object? injury_status = null,
    Object? injury_description = freezed,
    Object? form_rating = freezed,
    Object? last_update = null,
    Object? status_text = freezed,
    Object? expected_return = freezed,
  }) {
    return _then(
      _$LigainsiderPlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        shortName: null == shortName
            ? _value.shortName
            : shortName // ignore: cast_nullable_to_non_nullable
                  as String,
        teamName: null == teamName
            ? _value.teamName
            : teamName // ignore: cast_nullable_to_non_nullable
                  as String,
        teamId: null == teamId
            ? _value.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        injury_status: null == injury_status
            ? _value.injury_status
            : injury_status // ignore: cast_nullable_to_non_nullable
                  as String,
        injury_description: freezed == injury_description
            ? _value.injury_description
            : injury_description // ignore: cast_nullable_to_non_nullable
                  as String?,
        form_rating: freezed == form_rating
            ? _value.form_rating
            : form_rating // ignore: cast_nullable_to_non_nullable
                  as int?,
        last_update: null == last_update
            ? _value.last_update
            : last_update // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status_text: freezed == status_text
            ? _value.status_text
            : status_text // ignore: cast_nullable_to_non_nullable
                  as String?,
        expected_return: freezed == expected_return
            ? _value.expected_return
            : expected_return // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LigainsiderPlayerImpl implements _LigainsiderPlayer {
  const _$LigainsiderPlayerImpl({
    required this.id,
    required this.name,
    required this.shortName,
    required this.teamName,
    required this.teamId,
    required this.position,
    required this.injury_status,
    this.injury_description,
    this.form_rating,
    required this.last_update,
    this.status_text,
    this.expected_return,
  });

  factory _$LigainsiderPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$LigainsiderPlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String shortName;
  @override
  final String teamName;
  @override
  final String teamId;
  @override
  final int position;
  @override
  final String injury_status;
  @override
  final String? injury_description;
  @override
  final int? form_rating;
  @override
  final DateTime last_update;
  @override
  final String? status_text;
  @override
  final DateTime? expected_return;

  @override
  String toString() {
    return 'LigainsiderPlayer(id: $id, name: $name, shortName: $shortName, teamName: $teamName, teamId: $teamId, position: $position, injury_status: $injury_status, injury_description: $injury_description, form_rating: $form_rating, last_update: $last_update, status_text: $status_text, expected_return: $expected_return)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LigainsiderPlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.teamName, teamName) ||
                other.teamName == teamName) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.injury_status, injury_status) ||
                other.injury_status == injury_status) &&
            (identical(other.injury_description, injury_description) ||
                other.injury_description == injury_description) &&
            (identical(other.form_rating, form_rating) ||
                other.form_rating == form_rating) &&
            (identical(other.last_update, last_update) ||
                other.last_update == last_update) &&
            (identical(other.status_text, status_text) ||
                other.status_text == status_text) &&
            (identical(other.expected_return, expected_return) ||
                other.expected_return == expected_return));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    shortName,
    teamName,
    teamId,
    position,
    injury_status,
    injury_description,
    form_rating,
    last_update,
    status_text,
    expected_return,
  );

  /// Create a copy of LigainsiderPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LigainsiderPlayerImplCopyWith<_$LigainsiderPlayerImpl> get copyWith =>
      __$$LigainsiderPlayerImplCopyWithImpl<_$LigainsiderPlayerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LigainsiderPlayerImplToJson(this);
  }
}

abstract class _LigainsiderPlayer implements LigainsiderPlayer {
  const factory _LigainsiderPlayer({
    required final String id,
    required final String name,
    required final String shortName,
    required final String teamName,
    required final String teamId,
    required final int position,
    required final String injury_status,
    final String? injury_description,
    final int? form_rating,
    required final DateTime last_update,
    final String? status_text,
    final DateTime? expected_return,
  }) = _$LigainsiderPlayerImpl;

  factory _LigainsiderPlayer.fromJson(Map<String, dynamic> json) =
      _$LigainsiderPlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get shortName;
  @override
  String get teamName;
  @override
  String get teamId;
  @override
  int get position;
  @override
  String get injury_status;
  @override
  String? get injury_description;
  @override
  int? get form_rating;
  @override
  DateTime get last_update;
  @override
  String? get status_text;
  @override
  DateTime? get expected_return;

  /// Create a copy of LigainsiderPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LigainsiderPlayerImplCopyWith<_$LigainsiderPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LigainsiderStatus _$LigainsiderStatusFromJson(Map<String, dynamic> json) {
  return _LigainsiderStatus.fromJson(json);
}

/// @nodoc
mixin _$LigainsiderStatus {
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get statusCategory => throw _privateConstructorUsedError;
  String get statusReason => throw _privateConstructorUsedError;
  DateTime get lastUpdate => throw _privateConstructorUsedError;

  /// Serializes this LigainsiderStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LigainsiderStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LigainsiderStatusCopyWith<LigainsiderStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LigainsiderStatusCopyWith<$Res> {
  factory $LigainsiderStatusCopyWith(
    LigainsiderStatus value,
    $Res Function(LigainsiderStatus) then,
  ) = _$LigainsiderStatusCopyWithImpl<$Res, LigainsiderStatus>;
  @useResult
  $Res call({
    String playerId,
    String playerName,
    String statusCategory,
    String statusReason,
    DateTime lastUpdate,
  });
}

/// @nodoc
class _$LigainsiderStatusCopyWithImpl<$Res, $Val extends LigainsiderStatus>
    implements $LigainsiderStatusCopyWith<$Res> {
  _$LigainsiderStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LigainsiderStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? statusCategory = null,
    Object? statusReason = null,
    Object? lastUpdate = null,
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
            statusCategory: null == statusCategory
                ? _value.statusCategory
                : statusCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            statusReason: null == statusReason
                ? _value.statusReason
                : statusReason // ignore: cast_nullable_to_non_nullable
                      as String,
            lastUpdate: null == lastUpdate
                ? _value.lastUpdate
                : lastUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LigainsiderStatusImplCopyWith<$Res>
    implements $LigainsiderStatusCopyWith<$Res> {
  factory _$$LigainsiderStatusImplCopyWith(
    _$LigainsiderStatusImpl value,
    $Res Function(_$LigainsiderStatusImpl) then,
  ) = __$$LigainsiderStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    String playerName,
    String statusCategory,
    String statusReason,
    DateTime lastUpdate,
  });
}

/// @nodoc
class __$$LigainsiderStatusImplCopyWithImpl<$Res>
    extends _$LigainsiderStatusCopyWithImpl<$Res, _$LigainsiderStatusImpl>
    implements _$$LigainsiderStatusImplCopyWith<$Res> {
  __$$LigainsiderStatusImplCopyWithImpl(
    _$LigainsiderStatusImpl _value,
    $Res Function(_$LigainsiderStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LigainsiderStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? statusCategory = null,
    Object? statusReason = null,
    Object? lastUpdate = null,
  }) {
    return _then(
      _$LigainsiderStatusImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        statusCategory: null == statusCategory
            ? _value.statusCategory
            : statusCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        statusReason: null == statusReason
            ? _value.statusReason
            : statusReason // ignore: cast_nullable_to_non_nullable
                  as String,
        lastUpdate: null == lastUpdate
            ? _value.lastUpdate
            : lastUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LigainsiderStatusImpl implements _LigainsiderStatus {
  const _$LigainsiderStatusImpl({
    required this.playerId,
    required this.playerName,
    required this.statusCategory,
    required this.statusReason,
    required this.lastUpdate,
  });

  factory _$LigainsiderStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$LigainsiderStatusImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String statusCategory;
  @override
  final String statusReason;
  @override
  final DateTime lastUpdate;

  @override
  String toString() {
    return 'LigainsiderStatus(playerId: $playerId, playerName: $playerName, statusCategory: $statusCategory, statusReason: $statusReason, lastUpdate: $lastUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LigainsiderStatusImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.statusCategory, statusCategory) ||
                other.statusCategory == statusCategory) &&
            (identical(other.statusReason, statusReason) ||
                other.statusReason == statusReason) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    playerName,
    statusCategory,
    statusReason,
    lastUpdate,
  );

  /// Create a copy of LigainsiderStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LigainsiderStatusImplCopyWith<_$LigainsiderStatusImpl> get copyWith =>
      __$$LigainsiderStatusImplCopyWithImpl<_$LigainsiderStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LigainsiderStatusImplToJson(this);
  }
}

abstract class _LigainsiderStatus implements LigainsiderStatus {
  const factory _LigainsiderStatus({
    required final String playerId,
    required final String playerName,
    required final String statusCategory,
    required final String statusReason,
    required final DateTime lastUpdate,
  }) = _$LigainsiderStatusImpl;

  factory _LigainsiderStatus.fromJson(Map<String, dynamic> json) =
      _$LigainsiderStatusImpl.fromJson;

  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get statusCategory;
  @override
  String get statusReason;
  @override
  DateTime get lastUpdate;

  /// Create a copy of LigainsiderStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LigainsiderStatusImplCopyWith<_$LigainsiderStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LigainsiderResponse _$LigainsiderResponseFromJson(Map<String, dynamic> json) {
  return _LigainsiderResponse.fromJson(json);
}

/// @nodoc
mixin _$LigainsiderResponse {
  List<LigainsiderPlayer> get players => throw _privateConstructorUsedError;
  DateTime get last_update => throw _privateConstructorUsedError;
  int? get total_injured => throw _privateConstructorUsedError;
  int? get total_questionable => throw _privateConstructorUsedError;

  /// Serializes this LigainsiderResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LigainsiderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LigainsiderResponseCopyWith<LigainsiderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LigainsiderResponseCopyWith<$Res> {
  factory $LigainsiderResponseCopyWith(
    LigainsiderResponse value,
    $Res Function(LigainsiderResponse) then,
  ) = _$LigainsiderResponseCopyWithImpl<$Res, LigainsiderResponse>;
  @useResult
  $Res call({
    List<LigainsiderPlayer> players,
    DateTime last_update,
    int? total_injured,
    int? total_questionable,
  });
}

/// @nodoc
class _$LigainsiderResponseCopyWithImpl<$Res, $Val extends LigainsiderResponse>
    implements $LigainsiderResponseCopyWith<$Res> {
  _$LigainsiderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LigainsiderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? last_update = null,
    Object? total_injured = freezed,
    Object? total_questionable = freezed,
  }) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<LigainsiderPlayer>,
            last_update: null == last_update
                ? _value.last_update
                : last_update // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            total_injured: freezed == total_injured
                ? _value.total_injured
                : total_injured // ignore: cast_nullable_to_non_nullable
                      as int?,
            total_questionable: freezed == total_questionable
                ? _value.total_questionable
                : total_questionable // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LigainsiderResponseImplCopyWith<$Res>
    implements $LigainsiderResponseCopyWith<$Res> {
  factory _$$LigainsiderResponseImplCopyWith(
    _$LigainsiderResponseImpl value,
    $Res Function(_$LigainsiderResponseImpl) then,
  ) = __$$LigainsiderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<LigainsiderPlayer> players,
    DateTime last_update,
    int? total_injured,
    int? total_questionable,
  });
}

/// @nodoc
class __$$LigainsiderResponseImplCopyWithImpl<$Res>
    extends _$LigainsiderResponseCopyWithImpl<$Res, _$LigainsiderResponseImpl>
    implements _$$LigainsiderResponseImplCopyWith<$Res> {
  __$$LigainsiderResponseImplCopyWithImpl(
    _$LigainsiderResponseImpl _value,
    $Res Function(_$LigainsiderResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LigainsiderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? last_update = null,
    Object? total_injured = freezed,
    Object? total_questionable = freezed,
  }) {
    return _then(
      _$LigainsiderResponseImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<LigainsiderPlayer>,
        last_update: null == last_update
            ? _value.last_update
            : last_update // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        total_injured: freezed == total_injured
            ? _value.total_injured
            : total_injured // ignore: cast_nullable_to_non_nullable
                  as int?,
        total_questionable: freezed == total_questionable
            ? _value.total_questionable
            : total_questionable // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LigainsiderResponseImpl implements _LigainsiderResponse {
  const _$LigainsiderResponseImpl({
    required final List<LigainsiderPlayer> players,
    required this.last_update,
    this.total_injured,
    this.total_questionable,
  }) : _players = players;

  factory _$LigainsiderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LigainsiderResponseImplFromJson(json);

  final List<LigainsiderPlayer> _players;
  @override
  List<LigainsiderPlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final DateTime last_update;
  @override
  final int? total_injured;
  @override
  final int? total_questionable;

  @override
  String toString() {
    return 'LigainsiderResponse(players: $players, last_update: $last_update, total_injured: $total_injured, total_questionable: $total_questionable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LigainsiderResponseImpl &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.last_update, last_update) ||
                other.last_update == last_update) &&
            (identical(other.total_injured, total_injured) ||
                other.total_injured == total_injured) &&
            (identical(other.total_questionable, total_questionable) ||
                other.total_questionable == total_questionable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_players),
    last_update,
    total_injured,
    total_questionable,
  );

  /// Create a copy of LigainsiderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LigainsiderResponseImplCopyWith<_$LigainsiderResponseImpl> get copyWith =>
      __$$LigainsiderResponseImplCopyWithImpl<_$LigainsiderResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LigainsiderResponseImplToJson(this);
  }
}

abstract class _LigainsiderResponse implements LigainsiderResponse {
  const factory _LigainsiderResponse({
    required final List<LigainsiderPlayer> players,
    required final DateTime last_update,
    final int? total_injured,
    final int? total_questionable,
  }) = _$LigainsiderResponseImpl;

  factory _LigainsiderResponse.fromJson(Map<String, dynamic> json) =
      _$LigainsiderResponseImpl.fromJson;

  @override
  List<LigainsiderPlayer> get players;
  @override
  DateTime get last_update;
  @override
  int? get total_injured;
  @override
  int? get total_questionable;

  /// Create a copy of LigainsiderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LigainsiderResponseImplCopyWith<_$LigainsiderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InjuryReport _$InjuryReportFromJson(Map<String, dynamic> json) {
  return _InjuryReport.fromJson(json);
}

/// @nodoc
mixin _$InjuryReport {
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get injuryType => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  DateTime get injuryDate => throw _privateConstructorUsedError;
  DateTime? get expectedReturnDate => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this InjuryReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InjuryReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InjuryReportCopyWith<InjuryReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InjuryReportCopyWith<$Res> {
  factory $InjuryReportCopyWith(
    InjuryReport value,
    $Res Function(InjuryReport) then,
  ) = _$InjuryReportCopyWithImpl<$Res, InjuryReport>;
  @useResult
  $Res call({
    String playerId,
    String playerName,
    String injuryType,
    String severity,
    DateTime injuryDate,
    DateTime? expectedReturnDate,
    String source,
    String status,
  });
}

/// @nodoc
class _$InjuryReportCopyWithImpl<$Res, $Val extends InjuryReport>
    implements $InjuryReportCopyWith<$Res> {
  _$InjuryReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InjuryReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? injuryType = null,
    Object? severity = null,
    Object? injuryDate = null,
    Object? expectedReturnDate = freezed,
    Object? source = null,
    Object? status = null,
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
            injuryType: null == injuryType
                ? _value.injuryType
                : injuryType // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String,
            injuryDate: null == injuryDate
                ? _value.injuryDate
                : injuryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expectedReturnDate: freezed == expectedReturnDate
                ? _value.expectedReturnDate
                : expectedReturnDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InjuryReportImplCopyWith<$Res>
    implements $InjuryReportCopyWith<$Res> {
  factory _$$InjuryReportImplCopyWith(
    _$InjuryReportImpl value,
    $Res Function(_$InjuryReportImpl) then,
  ) = __$$InjuryReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    String playerName,
    String injuryType,
    String severity,
    DateTime injuryDate,
    DateTime? expectedReturnDate,
    String source,
    String status,
  });
}

/// @nodoc
class __$$InjuryReportImplCopyWithImpl<$Res>
    extends _$InjuryReportCopyWithImpl<$Res, _$InjuryReportImpl>
    implements _$$InjuryReportImplCopyWith<$Res> {
  __$$InjuryReportImplCopyWithImpl(
    _$InjuryReportImpl _value,
    $Res Function(_$InjuryReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InjuryReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? injuryType = null,
    Object? severity = null,
    Object? injuryDate = null,
    Object? expectedReturnDate = freezed,
    Object? source = null,
    Object? status = null,
  }) {
    return _then(
      _$InjuryReportImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        injuryType: null == injuryType
            ? _value.injuryType
            : injuryType // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String,
        injuryDate: null == injuryDate
            ? _value.injuryDate
            : injuryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expectedReturnDate: freezed == expectedReturnDate
            ? _value.expectedReturnDate
            : expectedReturnDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InjuryReportImpl implements _InjuryReport {
  const _$InjuryReportImpl({
    required this.playerId,
    required this.playerName,
    required this.injuryType,
    required this.severity,
    required this.injuryDate,
    this.expectedReturnDate,
    required this.source,
    required this.status,
  });

  factory _$InjuryReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$InjuryReportImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String injuryType;
  @override
  final String severity;
  @override
  final DateTime injuryDate;
  @override
  final DateTime? expectedReturnDate;
  @override
  final String source;
  @override
  final String status;

  @override
  String toString() {
    return 'InjuryReport(playerId: $playerId, playerName: $playerName, injuryType: $injuryType, severity: $severity, injuryDate: $injuryDate, expectedReturnDate: $expectedReturnDate, source: $source, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InjuryReportImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.injuryType, injuryType) ||
                other.injuryType == injuryType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.injuryDate, injuryDate) ||
                other.injuryDate == injuryDate) &&
            (identical(other.expectedReturnDate, expectedReturnDate) ||
                other.expectedReturnDate == expectedReturnDate) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    playerName,
    injuryType,
    severity,
    injuryDate,
    expectedReturnDate,
    source,
    status,
  );

  /// Create a copy of InjuryReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InjuryReportImplCopyWith<_$InjuryReportImpl> get copyWith =>
      __$$InjuryReportImplCopyWithImpl<_$InjuryReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InjuryReportImplToJson(this);
  }
}

abstract class _InjuryReport implements InjuryReport {
  const factory _InjuryReport({
    required final String playerId,
    required final String playerName,
    required final String injuryType,
    required final String severity,
    required final DateTime injuryDate,
    final DateTime? expectedReturnDate,
    required final String source,
    required final String status,
  }) = _$InjuryReportImpl;

  factory _InjuryReport.fromJson(Map<String, dynamic> json) =
      _$InjuryReportImpl.fromJson;

  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get injuryType;
  @override
  String get severity;
  @override
  DateTime get injuryDate;
  @override
  DateTime? get expectedReturnDate;
  @override
  String get source;
  @override
  String get status;

  /// Create a copy of InjuryReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InjuryReportImplCopyWith<_$InjuryReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
