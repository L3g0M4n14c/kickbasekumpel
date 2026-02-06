// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MarketPlayer _$MarketPlayerFromJson(Map<String, dynamic> json) {
  return _MarketPlayer.fromJson(json);
}

/// @nodoc
mixin _$MarketPlayer {
  String get id => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get profileBigUrl => throw _privateConstructorUsedError;
  String get teamName => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  double get averagePoints => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get marketValue => throw _privateConstructorUsedError;
  int get marketValueTrend => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  String get expiry => throw _privateConstructorUsedError;
  int get offers => throw _privateConstructorUsedError;
  MarketSeller get seller => throw _privateConstructorUsedError;
  int get stl => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  int? get prlo => throw _privateConstructorUsedError;
  PlayerOwner? get owner => throw _privateConstructorUsedError;
  int get exs => throw _privateConstructorUsedError;

  /// Serializes this MarketPlayer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketPlayerCopyWith<MarketPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketPlayerCopyWith<$Res> {
  factory $MarketPlayerCopyWith(
    MarketPlayer value,
    $Res Function(MarketPlayer) then,
  ) = _$MarketPlayerCopyWithImpl<$Res, MarketPlayer>;
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String profileBigUrl,
    String teamName,
    String teamId,
    int position,
    int number,
    double averagePoints,
    int totalPoints,
    int marketValue,
    int marketValueTrend,
    int price,
    String expiry,
    int offers,
    MarketSeller seller,
    int stl,
    int status,
    int? prlo,
    PlayerOwner? owner,
    int exs,
  });

  $MarketSellerCopyWith<$Res> get seller;
  $PlayerOwnerCopyWith<$Res>? get owner;
}

/// @nodoc
class _$MarketPlayerCopyWithImpl<$Res, $Val extends MarketPlayer>
    implements $MarketPlayerCopyWith<$Res> {
  _$MarketPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? profileBigUrl = null,
    Object? teamName = null,
    Object? teamId = null,
    Object? position = null,
    Object? number = null,
    Object? averagePoints = null,
    Object? totalPoints = null,
    Object? marketValue = null,
    Object? marketValueTrend = null,
    Object? price = null,
    Object? expiry = null,
    Object? offers = null,
    Object? seller = null,
    Object? stl = null,
    Object? status = null,
    Object? prlo = freezed,
    Object? owner = freezed,
    Object? exs = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            profileBigUrl: null == profileBigUrl
                ? _value.profileBigUrl
                : profileBigUrl // ignore: cast_nullable_to_non_nullable
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
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            averagePoints: null == averagePoints
                ? _value.averagePoints
                : averagePoints // ignore: cast_nullable_to_non_nullable
                      as double,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            marketValue: null == marketValue
                ? _value.marketValue
                : marketValue // ignore: cast_nullable_to_non_nullable
                      as int,
            marketValueTrend: null == marketValueTrend
                ? _value.marketValueTrend
                : marketValueTrend // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as int,
            expiry: null == expiry
                ? _value.expiry
                : expiry // ignore: cast_nullable_to_non_nullable
                      as String,
            offers: null == offers
                ? _value.offers
                : offers // ignore: cast_nullable_to_non_nullable
                      as int,
            seller: null == seller
                ? _value.seller
                : seller // ignore: cast_nullable_to_non_nullable
                      as MarketSeller,
            stl: null == stl
                ? _value.stl
                : stl // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int,
            prlo: freezed == prlo
                ? _value.prlo
                : prlo // ignore: cast_nullable_to_non_nullable
                      as int?,
            owner: freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as PlayerOwner?,
            exs: null == exs
                ? _value.exs
                : exs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MarketSellerCopyWith<$Res> get seller {
    return $MarketSellerCopyWith<$Res>(_value.seller, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerOwnerCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $PlayerOwnerCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MarketPlayerImplCopyWith<$Res>
    implements $MarketPlayerCopyWith<$Res> {
  factory _$$MarketPlayerImplCopyWith(
    _$MarketPlayerImpl value,
    $Res Function(_$MarketPlayerImpl) then,
  ) = __$$MarketPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String firstName,
    String lastName,
    String profileBigUrl,
    String teamName,
    String teamId,
    int position,
    int number,
    double averagePoints,
    int totalPoints,
    int marketValue,
    int marketValueTrend,
    int price,
    String expiry,
    int offers,
    MarketSeller seller,
    int stl,
    int status,
    int? prlo,
    PlayerOwner? owner,
    int exs,
  });

  @override
  $MarketSellerCopyWith<$Res> get seller;
  @override
  $PlayerOwnerCopyWith<$Res>? get owner;
}

/// @nodoc
class __$$MarketPlayerImplCopyWithImpl<$Res>
    extends _$MarketPlayerCopyWithImpl<$Res, _$MarketPlayerImpl>
    implements _$$MarketPlayerImplCopyWith<$Res> {
  __$$MarketPlayerImplCopyWithImpl(
    _$MarketPlayerImpl _value,
    $Res Function(_$MarketPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? profileBigUrl = null,
    Object? teamName = null,
    Object? teamId = null,
    Object? position = null,
    Object? number = null,
    Object? averagePoints = null,
    Object? totalPoints = null,
    Object? marketValue = null,
    Object? marketValueTrend = null,
    Object? price = null,
    Object? expiry = null,
    Object? offers = null,
    Object? seller = null,
    Object? stl = null,
    Object? status = null,
    Object? prlo = freezed,
    Object? owner = freezed,
    Object? exs = null,
  }) {
    return _then(
      _$MarketPlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        profileBigUrl: null == profileBigUrl
            ? _value.profileBigUrl
            : profileBigUrl // ignore: cast_nullable_to_non_nullable
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
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        averagePoints: null == averagePoints
            ? _value.averagePoints
            : averagePoints // ignore: cast_nullable_to_non_nullable
                  as double,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        marketValue: null == marketValue
            ? _value.marketValue
            : marketValue // ignore: cast_nullable_to_non_nullable
                  as int,
        marketValueTrend: null == marketValueTrend
            ? _value.marketValueTrend
            : marketValueTrend // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as int,
        expiry: null == expiry
            ? _value.expiry
            : expiry // ignore: cast_nullable_to_non_nullable
                  as String,
        offers: null == offers
            ? _value.offers
            : offers // ignore: cast_nullable_to_non_nullable
                  as int,
        seller: null == seller
            ? _value.seller
            : seller // ignore: cast_nullable_to_non_nullable
                  as MarketSeller,
        stl: null == stl
            ? _value.stl
            : stl // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int,
        prlo: freezed == prlo
            ? _value.prlo
            : prlo // ignore: cast_nullable_to_non_nullable
                  as int?,
        owner: freezed == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as PlayerOwner?,
        exs: null == exs
            ? _value.exs
            : exs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketPlayerImpl implements _MarketPlayer {
  const _$MarketPlayerImpl({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileBigUrl,
    required this.teamName,
    required this.teamId,
    required this.position,
    required this.number,
    required this.averagePoints,
    required this.totalPoints,
    required this.marketValue,
    required this.marketValueTrend,
    required this.price,
    required this.expiry,
    required this.offers,
    required this.seller,
    required this.stl,
    required this.status,
    this.prlo,
    this.owner,
    required this.exs,
  });

  factory _$MarketPlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketPlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String profileBigUrl;
  @override
  final String teamName;
  @override
  final String teamId;
  @override
  final int position;
  @override
  final int number;
  @override
  final double averagePoints;
  @override
  final int totalPoints;
  @override
  final int marketValue;
  @override
  final int marketValueTrend;
  @override
  final int price;
  @override
  final String expiry;
  @override
  final int offers;
  @override
  final MarketSeller seller;
  @override
  final int stl;
  @override
  final int status;
  @override
  final int? prlo;
  @override
  final PlayerOwner? owner;
  @override
  final int exs;

  @override
  String toString() {
    return 'MarketPlayer(id: $id, firstName: $firstName, lastName: $lastName, profileBigUrl: $profileBigUrl, teamName: $teamName, teamId: $teamId, position: $position, number: $number, averagePoints: $averagePoints, totalPoints: $totalPoints, marketValue: $marketValue, marketValueTrend: $marketValueTrend, price: $price, expiry: $expiry, offers: $offers, seller: $seller, stl: $stl, status: $status, prlo: $prlo, owner: $owner, exs: $exs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketPlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profileBigUrl, profileBigUrl) ||
                other.profileBigUrl == profileBigUrl) &&
            (identical(other.teamName, teamName) ||
                other.teamName == teamName) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.averagePoints, averagePoints) ||
                other.averagePoints == averagePoints) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.marketValue, marketValue) ||
                other.marketValue == marketValue) &&
            (identical(other.marketValueTrend, marketValueTrend) ||
                other.marketValueTrend == marketValueTrend) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.expiry, expiry) || other.expiry == expiry) &&
            (identical(other.offers, offers) || other.offers == offers) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            (identical(other.stl, stl) || other.stl == stl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.prlo, prlo) || other.prlo == prlo) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.exs, exs) || other.exs == exs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    firstName,
    lastName,
    profileBigUrl,
    teamName,
    teamId,
    position,
    number,
    averagePoints,
    totalPoints,
    marketValue,
    marketValueTrend,
    price,
    expiry,
    offers,
    seller,
    stl,
    status,
    prlo,
    owner,
    exs,
  ]);

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketPlayerImplCopyWith<_$MarketPlayerImpl> get copyWith =>
      __$$MarketPlayerImplCopyWithImpl<_$MarketPlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketPlayerImplToJson(this);
  }
}

abstract class _MarketPlayer implements MarketPlayer {
  const factory _MarketPlayer({
    required final String id,
    required final String firstName,
    required final String lastName,
    required final String profileBigUrl,
    required final String teamName,
    required final String teamId,
    required final int position,
    required final int number,
    required final double averagePoints,
    required final int totalPoints,
    required final int marketValue,
    required final int marketValueTrend,
    required final int price,
    required final String expiry,
    required final int offers,
    required final MarketSeller seller,
    required final int stl,
    required final int status,
    final int? prlo,
    final PlayerOwner? owner,
    required final int exs,
  }) = _$MarketPlayerImpl;

  factory _MarketPlayer.fromJson(Map<String, dynamic> json) =
      _$MarketPlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get profileBigUrl;
  @override
  String get teamName;
  @override
  String get teamId;
  @override
  int get position;
  @override
  int get number;
  @override
  double get averagePoints;
  @override
  int get totalPoints;
  @override
  int get marketValue;
  @override
  int get marketValueTrend;
  @override
  int get price;
  @override
  String get expiry;
  @override
  int get offers;
  @override
  MarketSeller get seller;
  @override
  int get stl;
  @override
  int get status;
  @override
  int? get prlo;
  @override
  PlayerOwner? get owner;
  @override
  int get exs;

  /// Create a copy of MarketPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketPlayerImplCopyWith<_$MarketPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketResponse _$MarketResponseFromJson(Map<String, dynamic> json) {
  return _MarketResponse.fromJson(json);
}

/// @nodoc
mixin _$MarketResponse {
  List<MarketPlayer> get players => throw _privateConstructorUsedError;

  /// Serializes this MarketResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketResponseCopyWith<MarketResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketResponseCopyWith<$Res> {
  factory $MarketResponseCopyWith(
    MarketResponse value,
    $Res Function(MarketResponse) then,
  ) = _$MarketResponseCopyWithImpl<$Res, MarketResponse>;
  @useResult
  $Res call({List<MarketPlayer> players});
}

/// @nodoc
class _$MarketResponseCopyWithImpl<$Res, $Val extends MarketResponse>
    implements $MarketResponseCopyWith<$Res> {
  _$MarketResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<MarketPlayer>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketResponseImplCopyWith<$Res>
    implements $MarketResponseCopyWith<$Res> {
  factory _$$MarketResponseImplCopyWith(
    _$MarketResponseImpl value,
    $Res Function(_$MarketResponseImpl) then,
  ) = __$$MarketResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MarketPlayer> players});
}

/// @nodoc
class __$$MarketResponseImplCopyWithImpl<$Res>
    extends _$MarketResponseCopyWithImpl<$Res, _$MarketResponseImpl>
    implements _$$MarketResponseImplCopyWith<$Res> {
  __$$MarketResponseImplCopyWithImpl(
    _$MarketResponseImpl _value,
    $Res Function(_$MarketResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? players = null}) {
    return _then(
      _$MarketResponseImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<MarketPlayer>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketResponseImpl implements _MarketResponse {
  const _$MarketResponseImpl({required final List<MarketPlayer> players})
    : _players = players;

  factory _$MarketResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketResponseImplFromJson(json);

  final List<MarketPlayer> _players;
  @override
  List<MarketPlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  String toString() {
    return 'MarketResponse(players: $players)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketResponseImpl &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_players));

  /// Create a copy of MarketResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketResponseImplCopyWith<_$MarketResponseImpl> get copyWith =>
      __$$MarketResponseImplCopyWithImpl<_$MarketResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketResponseImplToJson(this);
  }
}

abstract class _MarketResponse implements MarketResponse {
  const factory _MarketResponse({required final List<MarketPlayer> players}) =
      _$MarketResponseImpl;

  factory _MarketResponse.fromJson(Map<String, dynamic> json) =
      _$MarketResponseImpl.fromJson;

  @override
  List<MarketPlayer> get players;

  /// Create a copy of MarketResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketResponseImplCopyWith<_$MarketResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
