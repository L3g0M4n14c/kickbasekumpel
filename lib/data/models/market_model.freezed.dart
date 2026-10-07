// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketPlayer {

 String get id; String get firstName; String get lastName; String get profileBigUrl; String get teamName; String get teamId; int get position; int get number; double get averagePoints; int get totalPoints; int get marketValue; int get marketValueTrend; int get price; String get expiry; int get offers; MarketSeller get seller; int get stl; int get status; int? get prlo; PlayerOwner? get owner; int get exs;
/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketPlayerCopyWith<MarketPlayer> get copyWith => _$MarketPlayerCopyWithImpl<MarketPlayer>(this as MarketPlayer, _$identity);

  /// Serializes this MarketPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketPlayer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketPlayer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.profileBigUrl, _this.profileBigUrl) || other.profileBigUrl == _this.profileBigUrl)&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.averagePoints, _this.averagePoints) || other.averagePoints == _this.averagePoints)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.marketValueTrend, _this.marketValueTrend) || other.marketValueTrend == _this.marketValueTrend)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.expiry, _this.expiry) || other.expiry == _this.expiry)&&(identical(other.offers, _this.offers) || other.offers == _this.offers)&&(identical(other.seller, _this.seller) || other.seller == _this.seller)&&(identical(other.stl, _this.stl) || other.stl == _this.stl)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.prlo, _this.prlo) || other.prlo == _this.prlo)&&(identical(other.owner, _this.owner) || other.owner == _this.owner)&&(identical(other.exs, _this.exs) || other.exs == _this.exs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketPlayer;
  return Object.hashAll([runtimeType,_this.id,_this.firstName,_this.lastName,_this.profileBigUrl,_this.teamName,_this.teamId,_this.position,_this.number,_this.averagePoints,_this.totalPoints,_this.marketValue,_this.marketValueTrend,_this.price,_this.expiry,_this.offers,_this.seller,_this.stl,_this.status,_this.prlo,_this.owner,_this.exs]);
}

@override
String toString() {
  final _this = this as MarketPlayer;
  return 'MarketPlayer(id: ${_this.id}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, profileBigUrl: ${_this.profileBigUrl}, teamName: ${_this.teamName}, teamId: ${_this.teamId}, position: ${_this.position}, number: ${_this.number}, averagePoints: ${_this.averagePoints}, totalPoints: ${_this.totalPoints}, marketValue: ${_this.marketValue}, marketValueTrend: ${_this.marketValueTrend}, price: ${_this.price}, expiry: ${_this.expiry}, offers: ${_this.offers}, seller: ${_this.seller}, stl: ${_this.stl}, status: ${_this.status}, prlo: ${_this.prlo}, owner: ${_this.owner}, exs: ${_this.exs})';
}


}

/// @nodoc
abstract mixin class $MarketPlayerCopyWith<$Res>  {
  factory $MarketPlayerCopyWith(MarketPlayer value, $Res Function(MarketPlayer) _then) = _$MarketPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String firstName, String lastName, String profileBigUrl, String teamName, String teamId, int position, int number, double averagePoints, int totalPoints, int marketValue, int marketValueTrend, int price, String expiry, int offers, MarketSeller seller, int stl, int status, int? prlo, PlayerOwner? owner, int exs
});


$MarketSellerCopyWith<$Res> get seller;$PlayerOwnerCopyWith<$Res>? get owner;

}
/// @nodoc
class _$MarketPlayerCopyWithImpl<$Res>
    implements $MarketPlayerCopyWith<$Res> {
  _$MarketPlayerCopyWithImpl(this._self, this._then);

  final MarketPlayer _self;
  final $Res Function(MarketPlayer) _then;

/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? profileBigUrl = null,Object? teamName = null,Object? teamId = null,Object? position = null,Object? number = null,Object? averagePoints = null,Object? totalPoints = null,Object? marketValue = null,Object? marketValueTrend = null,Object? price = null,Object? expiry = null,Object? offers = null,Object? seller = null,Object? stl = null,Object? status = null,Object? prlo = freezed,Object? owner = freezed,Object? exs = null,}) {
  return _then(MarketPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,profileBigUrl: null == profileBigUrl ? _self.profileBigUrl : profileBigUrl // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,marketValueTrend: null == marketValueTrend ? _self.marketValueTrend : marketValueTrend // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,expiry: null == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as String,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as int,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as MarketSeller,stl: null == stl ? _self.stl : stl // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,prlo: freezed == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as PlayerOwner?,exs: null == exs ? _self.exs : exs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarketSellerCopyWith<$Res> get seller {
  
  return $MarketSellerCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerOwnerCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $PlayerOwnerCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// Adds pattern-matching-related methods to [MarketPlayer].
extension MarketPlayerPatterns on MarketPlayer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketPlayer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketPlayer value)  $default,){
final _that = this;
switch (_that) {
case _MarketPlayer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _MarketPlayer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String profileBigUrl,  String teamName,  String teamId,  int position,  int number,  double averagePoints,  int totalPoints,  int marketValue,  int marketValueTrend,  int price,  String expiry,  int offers,  MarketSeller seller,  int stl,  int status,  int? prlo,  PlayerOwner? owner,  int exs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketPlayer() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.profileBigUrl,_that.teamName,_that.teamId,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.price,_that.expiry,_that.offers,_that.seller,_that.stl,_that.status,_that.prlo,_that.owner,_that.exs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String firstName,  String lastName,  String profileBigUrl,  String teamName,  String teamId,  int position,  int number,  double averagePoints,  int totalPoints,  int marketValue,  int marketValueTrend,  int price,  String expiry,  int offers,  MarketSeller seller,  int stl,  int status,  int? prlo,  PlayerOwner? owner,  int exs)  $default,) {final _that = this;
switch (_that) {
case _MarketPlayer():
return $default(_that.id,_that.firstName,_that.lastName,_that.profileBigUrl,_that.teamName,_that.teamId,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.price,_that.expiry,_that.offers,_that.seller,_that.stl,_that.status,_that.prlo,_that.owner,_that.exs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String firstName,  String lastName,  String profileBigUrl,  String teamName,  String teamId,  int position,  int number,  double averagePoints,  int totalPoints,  int marketValue,  int marketValueTrend,  int price,  String expiry,  int offers,  MarketSeller seller,  int stl,  int status,  int? prlo,  PlayerOwner? owner,  int exs)?  $default,) {final _that = this;
switch (_that) {
case _MarketPlayer() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.profileBigUrl,_that.teamName,_that.teamId,_that.position,_that.number,_that.averagePoints,_that.totalPoints,_that.marketValue,_that.marketValueTrend,_that.price,_that.expiry,_that.offers,_that.seller,_that.stl,_that.status,_that.prlo,_that.owner,_that.exs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketPlayer implements MarketPlayer {
  const _MarketPlayer({required this.id, required this.firstName, required this.lastName, required this.profileBigUrl, required this.teamName, required this.teamId, required this.position, required this.number, required this.averagePoints, required this.totalPoints, required this.marketValue, required this.marketValueTrend, required this.price, required this.expiry, required this.offers, required this.seller, required this.stl, required this.status, this.prlo, this.owner, required this.exs});
  factory _MarketPlayer.fromJson(Map<String, dynamic> json) => _$MarketPlayerFromJson(json);

@override final  String id;
@override final  String firstName;
@override final  String lastName;
@override final  String profileBigUrl;
@override final  String teamName;
@override final  String teamId;
@override final  int position;
@override final  int number;
@override final  double averagePoints;
@override final  int totalPoints;
@override final  int marketValue;
@override final  int marketValueTrend;
@override final  int price;
@override final  String expiry;
@override final  int offers;
@override final  MarketSeller seller;
@override final  int stl;
@override final  int status;
@override final  int? prlo;
@override final  PlayerOwner? owner;
@override final  int exs;

/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketPlayerCopyWith<_MarketPlayer> get copyWith => __$MarketPlayerCopyWithImpl<_MarketPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.profileBigUrl, profileBigUrl) || other.profileBigUrl == profileBigUrl)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.position, position) || other.position == position)&&(identical(other.number, number) || other.number == number)&&(identical(other.averagePoints, averagePoints) || other.averagePoints == averagePoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.marketValueTrend, marketValueTrend) || other.marketValueTrend == marketValueTrend)&&(identical(other.price, price) || other.price == price)&&(identical(other.expiry, expiry) || other.expiry == expiry)&&(identical(other.offers, offers) || other.offers == offers)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.stl, stl) || other.stl == stl)&&(identical(other.status, status) || other.status == status)&&(identical(other.prlo, prlo) || other.prlo == prlo)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.exs, exs) || other.exs == exs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,firstName,lastName,profileBigUrl,teamName,teamId,position,number,averagePoints,totalPoints,marketValue,marketValueTrend,price,expiry,offers,seller,stl,status,prlo,owner,exs]);
}

@override
String toString() {
    return 'MarketPlayer(id: $id, firstName: $firstName, lastName: $lastName, profileBigUrl: $profileBigUrl, teamName: $teamName, teamId: $teamId, position: $position, number: $number, averagePoints: $averagePoints, totalPoints: $totalPoints, marketValue: $marketValue, marketValueTrend: $marketValueTrend, price: $price, expiry: $expiry, offers: $offers, seller: $seller, stl: $stl, status: $status, prlo: $prlo, owner: $owner, exs: $exs)';
}


}

/// @nodoc
abstract mixin class _$MarketPlayerCopyWith<$Res> implements $MarketPlayerCopyWith<$Res> {
  factory _$MarketPlayerCopyWith(_MarketPlayer value, $Res Function(_MarketPlayer) _then) = __$MarketPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String firstName, String lastName, String profileBigUrl, String teamName, String teamId, int position, int number, double averagePoints, int totalPoints, int marketValue, int marketValueTrend, int price, String expiry, int offers, MarketSeller seller, int stl, int status, int? prlo, PlayerOwner? owner, int exs
});


@override $MarketSellerCopyWith<$Res> get seller;@override $PlayerOwnerCopyWith<$Res>? get owner;

}
/// @nodoc
class __$MarketPlayerCopyWithImpl<$Res>
    implements _$MarketPlayerCopyWith<$Res> {
  __$MarketPlayerCopyWithImpl(this._self, this._then);

  final _MarketPlayer _self;
  final $Res Function(_MarketPlayer) _then;

/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = null,Object? lastName = null,Object? profileBigUrl = null,Object? teamName = null,Object? teamId = null,Object? position = null,Object? number = null,Object? averagePoints = null,Object? totalPoints = null,Object? marketValue = null,Object? marketValueTrend = null,Object? price = null,Object? expiry = null,Object? offers = null,Object? seller = null,Object? stl = null,Object? status = null,Object? prlo = freezed,Object? owner = freezed,Object? exs = null,}) {
  return _then(_MarketPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,profileBigUrl: null == profileBigUrl ? _self.profileBigUrl : profileBigUrl // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,averagePoints: null == averagePoints ? _self.averagePoints : averagePoints // ignore: cast_nullable_to_non_nullable
as double,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,marketValueTrend: null == marketValueTrend ? _self.marketValueTrend : marketValueTrend // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,expiry: null == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as String,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as int,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as MarketSeller,stl: null == stl ? _self.stl : stl // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,prlo: freezed == prlo ? _self.prlo : prlo // ignore: cast_nullable_to_non_nullable
as int?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as PlayerOwner?,exs: null == exs ? _self.exs : exs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MarketSellerCopyWith<$Res> get seller {
  
  return $MarketSellerCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of MarketPlayer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerOwnerCopyWith<$Res>? get owner {
    if (_self.owner == null) {
    return null;
  }

  return $PlayerOwnerCopyWith<$Res>(_self.owner!, (value) {
    return _then(_self.copyWith(owner: value));
  });
}
}


/// @nodoc
mixin _$MarketResponse {

 List<MarketPlayer> get players;
/// Create a copy of MarketResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketResponseCopyWith<MarketResponse> get copyWith => _$MarketResponseCopyWithImpl<MarketResponse>(this as MarketResponse, _$identity);

  /// Serializes this MarketResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MarketResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketResponse&&const DeepCollectionEquality().equals(other.players, _this.players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MarketResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.players));
}

@override
String toString() {
  final _this = this as MarketResponse;
  return 'MarketResponse(players: ${_this.players})';
}


}

/// @nodoc
abstract mixin class $MarketResponseCopyWith<$Res>  {
  factory $MarketResponseCopyWith(MarketResponse value, $Res Function(MarketResponse) _then) = _$MarketResponseCopyWithImpl;
@useResult
$Res call({
 List<MarketPlayer> players
});




}
/// @nodoc
class _$MarketResponseCopyWithImpl<$Res>
    implements $MarketResponseCopyWith<$Res> {
  _$MarketResponseCopyWithImpl(this._self, this._then);

  final MarketResponse _self;
  final $Res Function(MarketResponse) _then;

/// Create a copy of MarketResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,}) {
  return _then(MarketResponse(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<MarketPlayer>,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketResponse].
extension MarketResponsePatterns on MarketResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketResponse value)  $default,){
final _that = this;
switch (_that) {
case _MarketResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MarketResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MarketPlayer> players)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketResponse() when $default != null:
return $default(_that.players);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MarketPlayer> players)  $default,) {final _that = this;
switch (_that) {
case _MarketResponse():
return $default(_that.players);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MarketPlayer> players)?  $default,) {final _that = this;
switch (_that) {
case _MarketResponse() when $default != null:
return $default(_that.players);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketResponse implements MarketResponse {
  const _MarketResponse({required  List<MarketPlayer> players}): _players = players;
  factory _MarketResponse.fromJson(Map<String, dynamic> json) => _$MarketResponseFromJson(json);

 final  List<MarketPlayer> _players;
@override List<MarketPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}


/// Create a copy of MarketResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketResponseCopyWith<_MarketResponse> get copyWith => __$MarketResponseCopyWithImpl<_MarketResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketResponse&&const DeepCollectionEquality().equals(other.players, _players));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_players));
}

@override
String toString() {
    return 'MarketResponse(players: $players)';
}


}

/// @nodoc
abstract mixin class _$MarketResponseCopyWith<$Res> implements $MarketResponseCopyWith<$Res> {
  factory _$MarketResponseCopyWith(_MarketResponse value, $Res Function(_MarketResponse) _then) = __$MarketResponseCopyWithImpl;
@override @useResult
$Res call({
 List<MarketPlayer> players
});




}
/// @nodoc
class __$MarketResponseCopyWithImpl<$Res>
    implements _$MarketResponseCopyWith<$Res> {
  __$MarketResponseCopyWithImpl(this._self, this._then);

  final _MarketResponse _self;
  final $Res Function(_MarketResponse) _then;

/// Create a copy of MarketResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,}) {
  return _then(_MarketResponse(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<MarketPlayer>,
  ));
}


}

// dart format on
