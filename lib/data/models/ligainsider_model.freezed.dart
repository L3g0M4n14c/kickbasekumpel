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
  String get injuryStatus => throw _privateConstructorUsedError;
  String? get injuryDescription => throw _privateConstructorUsedError;
  int? get formRating => throw _privateConstructorUsedError;
  DateTime get lastUpdate => throw _privateConstructorUsedError;
  String? get statusText => throw _privateConstructorUsedError;
  DateTime? get expectedReturn => throw _privateConstructorUsedError;
  String? get alternative =>
      throw _privateConstructorUsedError; // Name der Alternative (für Lineup-Status)
  String? get ligainsiderId =>
      throw _privateConstructorUsedError; // Ligainsider ID (z.B. "nikola-vasilj_13866")
  String? get imageUrl => throw _privateConstructorUsedError;

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
    String injuryStatus,
    String? injuryDescription,
    int? formRating,
    DateTime lastUpdate,
    String? statusText,
    DateTime? expectedReturn,
    String? alternative,
    String? ligainsiderId,
    String? imageUrl,
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
    Object? injuryStatus = null,
    Object? injuryDescription = freezed,
    Object? formRating = freezed,
    Object? lastUpdate = null,
    Object? statusText = freezed,
    Object? expectedReturn = freezed,
    Object? alternative = freezed,
    Object? ligainsiderId = freezed,
    Object? imageUrl = freezed,
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
            injuryStatus: null == injuryStatus
                ? _value.injuryStatus
                : injuryStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            injuryDescription: freezed == injuryDescription
                ? _value.injuryDescription
                : injuryDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            formRating: freezed == formRating
                ? _value.formRating
                : formRating // ignore: cast_nullable_to_non_nullable
                      as int?,
            lastUpdate: null == lastUpdate
                ? _value.lastUpdate
                : lastUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            statusText: freezed == statusText
                ? _value.statusText
                : statusText // ignore: cast_nullable_to_non_nullable
                      as String?,
            expectedReturn: freezed == expectedReturn
                ? _value.expectedReturn
                : expectedReturn // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            alternative: freezed == alternative
                ? _value.alternative
                : alternative // ignore: cast_nullable_to_non_nullable
                      as String?,
            ligainsiderId: freezed == ligainsiderId
                ? _value.ligainsiderId
                : ligainsiderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String injuryStatus,
    String? injuryDescription,
    int? formRating,
    DateTime lastUpdate,
    String? statusText,
    DateTime? expectedReturn,
    String? alternative,
    String? ligainsiderId,
    String? imageUrl,
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
    Object? injuryStatus = null,
    Object? injuryDescription = freezed,
    Object? formRating = freezed,
    Object? lastUpdate = null,
    Object? statusText = freezed,
    Object? expectedReturn = freezed,
    Object? alternative = freezed,
    Object? ligainsiderId = freezed,
    Object? imageUrl = freezed,
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
        injuryStatus: null == injuryStatus
            ? _value.injuryStatus
            : injuryStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        injuryDescription: freezed == injuryDescription
            ? _value.injuryDescription
            : injuryDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        formRating: freezed == formRating
            ? _value.formRating
            : formRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        lastUpdate: null == lastUpdate
            ? _value.lastUpdate
            : lastUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        statusText: freezed == statusText
            ? _value.statusText
            : statusText // ignore: cast_nullable_to_non_nullable
                  as String?,
        expectedReturn: freezed == expectedReturn
            ? _value.expectedReturn
            : expectedReturn // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        alternative: freezed == alternative
            ? _value.alternative
            : alternative // ignore: cast_nullable_to_non_nullable
                  as String?,
        ligainsiderId: freezed == ligainsiderId
            ? _value.ligainsiderId
            : ligainsiderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$LigainsiderPlayerImpl implements _LigainsiderPlayer {
  const _$LigainsiderPlayerImpl({
    required this.id,
    required this.name,
    required this.shortName,
    required this.teamName,
    required this.teamId,
    required this.position,
    required this.injuryStatus,
    this.injuryDescription,
    this.formRating,
    required this.lastUpdate,
    this.statusText,
    this.expectedReturn,
    this.alternative,
    this.ligainsiderId,
    this.imageUrl,
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
  final String injuryStatus;
  @override
  final String? injuryDescription;
  @override
  final int? formRating;
  @override
  final DateTime lastUpdate;
  @override
  final String? statusText;
  @override
  final DateTime? expectedReturn;
  @override
  final String? alternative;
  // Name der Alternative (für Lineup-Status)
  @override
  final String? ligainsiderId;
  // Ligainsider ID (z.B. "nikola-vasilj_13866")
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'LigainsiderPlayer(id: $id, name: $name, shortName: $shortName, teamName: $teamName, teamId: $teamId, position: $position, injuryStatus: $injuryStatus, injuryDescription: $injuryDescription, formRating: $formRating, lastUpdate: $lastUpdate, statusText: $statusText, expectedReturn: $expectedReturn, alternative: $alternative, ligainsiderId: $ligainsiderId, imageUrl: $imageUrl)';
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
            (identical(other.injuryStatus, injuryStatus) ||
                other.injuryStatus == injuryStatus) &&
            (identical(other.injuryDescription, injuryDescription) ||
                other.injuryDescription == injuryDescription) &&
            (identical(other.formRating, formRating) ||
                other.formRating == formRating) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText) &&
            (identical(other.expectedReturn, expectedReturn) ||
                other.expectedReturn == expectedReturn) &&
            (identical(other.alternative, alternative) ||
                other.alternative == alternative) &&
            (identical(other.ligainsiderId, ligainsiderId) ||
                other.ligainsiderId == ligainsiderId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
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
    injuryStatus,
    injuryDescription,
    formRating,
    lastUpdate,
    statusText,
    expectedReturn,
    alternative,
    ligainsiderId,
    imageUrl,
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
    required final String injuryStatus,
    final String? injuryDescription,
    final int? formRating,
    required final DateTime lastUpdate,
    final String? statusText,
    final DateTime? expectedReturn,
    final String? alternative,
    final String? ligainsiderId,
    final String? imageUrl,
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
  String get injuryStatus;
  @override
  String? get injuryDescription;
  @override
  int? get formRating;
  @override
  DateTime get lastUpdate;
  @override
  String? get statusText;
  @override
  DateTime? get expectedReturn;
  @override
  String? get alternative; // Name der Alternative (für Lineup-Status)
  @override
  String? get ligainsiderId; // Ligainsider ID (z.B. "nikola-vasilj_13866")
  @override
  String? get imageUrl;

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
  DateTime get lastUpdate => throw _privateConstructorUsedError;
  int? get totalInjured => throw _privateConstructorUsedError;
  int? get totalQuestionable => throw _privateConstructorUsedError;

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
    DateTime lastUpdate,
    int? totalInjured,
    int? totalQuestionable,
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
    Object? lastUpdate = null,
    Object? totalInjured = freezed,
    Object? totalQuestionable = freezed,
  }) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<LigainsiderPlayer>,
            lastUpdate: null == lastUpdate
                ? _value.lastUpdate
                : lastUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalInjured: freezed == totalInjured
                ? _value.totalInjured
                : totalInjured // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalQuestionable: freezed == totalQuestionable
                ? _value.totalQuestionable
                : totalQuestionable // ignore: cast_nullable_to_non_nullable
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
    DateTime lastUpdate,
    int? totalInjured,
    int? totalQuestionable,
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
    Object? lastUpdate = null,
    Object? totalInjured = freezed,
    Object? totalQuestionable = freezed,
  }) {
    return _then(
      _$LigainsiderResponseImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<LigainsiderPlayer>,
        lastUpdate: null == lastUpdate
            ? _value.lastUpdate
            : lastUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalInjured: freezed == totalInjured
            ? _value.totalInjured
            : totalInjured // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalQuestionable: freezed == totalQuestionable
            ? _value.totalQuestionable
            : totalQuestionable // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$LigainsiderResponseImpl implements _LigainsiderResponse {
  const _$LigainsiderResponseImpl({
    required final List<LigainsiderPlayer> players,
    required this.lastUpdate,
    this.totalInjured,
    this.totalQuestionable,
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
  final DateTime lastUpdate;
  @override
  final int? totalInjured;
  @override
  final int? totalQuestionable;

  @override
  String toString() {
    return 'LigainsiderResponse(players: $players, lastUpdate: $lastUpdate, totalInjured: $totalInjured, totalQuestionable: $totalQuestionable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LigainsiderResponseImpl &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate) &&
            (identical(other.totalInjured, totalInjured) ||
                other.totalInjured == totalInjured) &&
            (identical(other.totalQuestionable, totalQuestionable) ||
                other.totalQuestionable == totalQuestionable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_players),
    lastUpdate,
    totalInjured,
    totalQuestionable,
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
    required final DateTime lastUpdate,
    final int? totalInjured,
    final int? totalQuestionable,
  }) = _$LigainsiderResponseImpl;

  factory _LigainsiderResponse.fromJson(Map<String, dynamic> json) =
      _$LigainsiderResponseImpl.fromJson;

  @override
  List<LigainsiderPlayer> get players;
  @override
  DateTime get lastUpdate;
  @override
  int? get totalInjured;
  @override
  int? get totalQuestionable;

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
