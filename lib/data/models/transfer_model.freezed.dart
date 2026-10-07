// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transfer {

 String get id; String get leagueId; String get fromUserId; String get toUserId; String get playerId; int get price; int get marketValue; String get playerName; String get fromUsername; String get toUsername; DateTime get timestamp; String get status;
/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferCopyWith<Transfer> get copyWith => _$TransferCopyWithImpl<Transfer>(this as Transfer, _$identity);

  /// Serializes this Transfer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Transfer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transfer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.fromUserId, _this.fromUserId) || other.fromUserId == _this.fromUserId)&&(identical(other.toUserId, _this.toUserId) || other.toUserId == _this.toUserId)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.fromUsername, _this.fromUsername) || other.fromUsername == _this.fromUsername)&&(identical(other.toUsername, _this.toUsername) || other.toUsername == _this.toUsername)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Transfer;
  return Object.hash(runtimeType,_this.id,_this.leagueId,_this.fromUserId,_this.toUserId,_this.playerId,_this.price,_this.marketValue,_this.playerName,_this.fromUsername,_this.toUsername,_this.timestamp,_this.status);
}

@override
String toString() {
  final _this = this as Transfer;
  return 'Transfer(id: ${_this.id}, leagueId: ${_this.leagueId}, fromUserId: ${_this.fromUserId}, toUserId: ${_this.toUserId}, playerId: ${_this.playerId}, price: ${_this.price}, marketValue: ${_this.marketValue}, playerName: ${_this.playerName}, fromUsername: ${_this.fromUsername}, toUsername: ${_this.toUsername}, timestamp: ${_this.timestamp}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $TransferCopyWith<$Res>  {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) _then) = _$TransferCopyWithImpl;
@useResult
$Res call({
 String id, String leagueId, String fromUserId, String toUserId, String playerId, int price, int marketValue, String playerName, String fromUsername, String toUsername, DateTime timestamp, String status
});




}
/// @nodoc
class _$TransferCopyWithImpl<$Res>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._self, this._then);

  final Transfer _self;
  final $Res Function(Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leagueId = null,Object? fromUserId = null,Object? toUserId = null,Object? playerId = null,Object? price = null,Object? marketValue = null,Object? playerName = null,Object? fromUsername = null,Object? toUsername = null,Object? timestamp = null,Object? status = null,}) {
  return _then(Transfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,fromUsername: null == fromUsername ? _self.fromUsername : fromUsername // ignore: cast_nullable_to_non_nullable
as String,toUsername: null == toUsername ? _self.toUsername : toUsername // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Transfer].
extension TransferPatterns on Transfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transfer value)  $default,){
final _that = this;
switch (_that) {
case _Transfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transfer value)?  $default,){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leagueId,  String fromUserId,  String toUserId,  String playerId,  int price,  int marketValue,  String playerName,  String fromUsername,  String toUsername,  DateTime timestamp,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.leagueId,_that.fromUserId,_that.toUserId,_that.playerId,_that.price,_that.marketValue,_that.playerName,_that.fromUsername,_that.toUsername,_that.timestamp,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leagueId,  String fromUserId,  String toUserId,  String playerId,  int price,  int marketValue,  String playerName,  String fromUsername,  String toUsername,  DateTime timestamp,  String status)  $default,) {final _that = this;
switch (_that) {
case _Transfer():
return $default(_that.id,_that.leagueId,_that.fromUserId,_that.toUserId,_that.playerId,_that.price,_that.marketValue,_that.playerName,_that.fromUsername,_that.toUsername,_that.timestamp,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leagueId,  String fromUserId,  String toUserId,  String playerId,  int price,  int marketValue,  String playerName,  String fromUsername,  String toUsername,  DateTime timestamp,  String status)?  $default,) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.leagueId,_that.fromUserId,_that.toUserId,_that.playerId,_that.price,_that.marketValue,_that.playerName,_that.fromUsername,_that.toUsername,_that.timestamp,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transfer implements Transfer {
  const _Transfer({required this.id, required this.leagueId, required this.fromUserId, required this.toUserId, required this.playerId, required this.price, required this.marketValue, required this.playerName, required this.fromUsername, required this.toUsername, required this.timestamp, required this.status});
  factory _Transfer.fromJson(Map<String, dynamic> json) => _$TransferFromJson(json);

@override final  String id;
@override final  String leagueId;
@override final  String fromUserId;
@override final  String toUserId;
@override final  String playerId;
@override final  int price;
@override final  int marketValue;
@override final  String playerName;
@override final  String fromUsername;
@override final  String toUsername;
@override final  DateTime timestamp;
@override final  String status;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferCopyWith<_Transfer> get copyWith => __$TransferCopyWithImpl<_Transfer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transfer&&(identical(other.id, id) || other.id == id)&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.price, price) || other.price == price)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.fromUsername, fromUsername) || other.fromUsername == fromUsername)&&(identical(other.toUsername, toUsername) || other.toUsername == toUsername)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,leagueId,fromUserId,toUserId,playerId,price,marketValue,playerName,fromUsername,toUsername,timestamp,status);
}

@override
String toString() {
    return 'Transfer(id: $id, leagueId: $leagueId, fromUserId: $fromUserId, toUserId: $toUserId, playerId: $playerId, price: $price, marketValue: $marketValue, playerName: $playerName, fromUsername: $fromUsername, toUsername: $toUsername, timestamp: $timestamp, status: $status)';
}


}

/// @nodoc
abstract mixin class _$TransferCopyWith<$Res> implements $TransferCopyWith<$Res> {
  factory _$TransferCopyWith(_Transfer value, $Res Function(_Transfer) _then) = __$TransferCopyWithImpl;
@override @useResult
$Res call({
 String id, String leagueId, String fromUserId, String toUserId, String playerId, int price, int marketValue, String playerName, String fromUsername, String toUsername, DateTime timestamp, String status
});




}
/// @nodoc
class __$TransferCopyWithImpl<$Res>
    implements _$TransferCopyWith<$Res> {
  __$TransferCopyWithImpl(this._self, this._then);

  final _Transfer _self;
  final $Res Function(_Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leagueId = null,Object? fromUserId = null,Object? toUserId = null,Object? playerId = null,Object? price = null,Object? marketValue = null,Object? playerName = null,Object? fromUsername = null,Object? toUsername = null,Object? timestamp = null,Object? status = null,}) {
  return _then(_Transfer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,fromUsername: null == fromUsername ? _self.fromUsername : fromUsername // ignore: cast_nullable_to_non_nullable
as String,toUsername: null == toUsername ? _self.toUsername : toUsername // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ManagerTransferHistoryEntry {

 String get id; String get leagueId; String get managerId; String get managerName; String get playerId; String get playerName; int get price; int get transferType; DateTime get timestamp; int? get marketValueAtTransfer;
/// Create a copy of ManagerTransferHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagerTransferHistoryEntryCopyWith<ManagerTransferHistoryEntry> get copyWith => _$ManagerTransferHistoryEntryCopyWithImpl<ManagerTransferHistoryEntry>(this as ManagerTransferHistoryEntry, _$identity);

  /// Serializes this ManagerTransferHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ManagerTransferHistoryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagerTransferHistoryEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.managerId, _this.managerId) || other.managerId == _this.managerId)&&(identical(other.managerName, _this.managerName) || other.managerName == _this.managerName)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.transferType, _this.transferType) || other.transferType == _this.transferType)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.marketValueAtTransfer, _this.marketValueAtTransfer) || other.marketValueAtTransfer == _this.marketValueAtTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ManagerTransferHistoryEntry;
  return Object.hash(runtimeType,_this.id,_this.leagueId,_this.managerId,_this.managerName,_this.playerId,_this.playerName,_this.price,_this.transferType,_this.timestamp,_this.marketValueAtTransfer);
}

@override
String toString() {
  final _this = this as ManagerTransferHistoryEntry;
  return 'ManagerTransferHistoryEntry(id: ${_this.id}, leagueId: ${_this.leagueId}, managerId: ${_this.managerId}, managerName: ${_this.managerName}, playerId: ${_this.playerId}, playerName: ${_this.playerName}, price: ${_this.price}, transferType: ${_this.transferType}, timestamp: ${_this.timestamp}, marketValueAtTransfer: ${_this.marketValueAtTransfer})';
}


}

/// @nodoc
abstract mixin class $ManagerTransferHistoryEntryCopyWith<$Res>  {
  factory $ManagerTransferHistoryEntryCopyWith(ManagerTransferHistoryEntry value, $Res Function(ManagerTransferHistoryEntry) _then) = _$ManagerTransferHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, String leagueId, String managerId, String managerName, String playerId, String playerName, int price, int transferType, DateTime timestamp, int? marketValueAtTransfer
});




}
/// @nodoc
class _$ManagerTransferHistoryEntryCopyWithImpl<$Res>
    implements $ManagerTransferHistoryEntryCopyWith<$Res> {
  _$ManagerTransferHistoryEntryCopyWithImpl(this._self, this._then);

  final ManagerTransferHistoryEntry _self;
  final $Res Function(ManagerTransferHistoryEntry) _then;

/// Create a copy of ManagerTransferHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leagueId = null,Object? managerId = null,Object? managerName = null,Object? playerId = null,Object? playerName = null,Object? price = null,Object? transferType = null,Object? timestamp = null,Object? marketValueAtTransfer = freezed,}) {
  return _then(ManagerTransferHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,managerId: null == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,transferType: null == transferType ? _self.transferType : transferType // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,marketValueAtTransfer: freezed == marketValueAtTransfer ? _self.marketValueAtTransfer : marketValueAtTransfer // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagerTransferHistoryEntry].
extension ManagerTransferHistoryEntryPatterns on ManagerTransferHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagerTransferHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagerTransferHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagerTransferHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _ManagerTransferHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagerTransferHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ManagerTransferHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leagueId,  String managerId,  String managerName,  String playerId,  String playerName,  int price,  int transferType,  DateTime timestamp,  int? marketValueAtTransfer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagerTransferHistoryEntry() when $default != null:
return $default(_that.id,_that.leagueId,_that.managerId,_that.managerName,_that.playerId,_that.playerName,_that.price,_that.transferType,_that.timestamp,_that.marketValueAtTransfer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leagueId,  String managerId,  String managerName,  String playerId,  String playerName,  int price,  int transferType,  DateTime timestamp,  int? marketValueAtTransfer)  $default,) {final _that = this;
switch (_that) {
case _ManagerTransferHistoryEntry():
return $default(_that.id,_that.leagueId,_that.managerId,_that.managerName,_that.playerId,_that.playerName,_that.price,_that.transferType,_that.timestamp,_that.marketValueAtTransfer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leagueId,  String managerId,  String managerName,  String playerId,  String playerName,  int price,  int transferType,  DateTime timestamp,  int? marketValueAtTransfer)?  $default,) {final _that = this;
switch (_that) {
case _ManagerTransferHistoryEntry() when $default != null:
return $default(_that.id,_that.leagueId,_that.managerId,_that.managerName,_that.playerId,_that.playerName,_that.price,_that.transferType,_that.timestamp,_that.marketValueAtTransfer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagerTransferHistoryEntry implements ManagerTransferHistoryEntry {
  const _ManagerTransferHistoryEntry({required this.id, required this.leagueId, required this.managerId, required this.managerName, required this.playerId, required this.playerName, required this.price, required this.transferType, required this.timestamp, this.marketValueAtTransfer});
  factory _ManagerTransferHistoryEntry.fromJson(Map<String, dynamic> json) => _$ManagerTransferHistoryEntryFromJson(json);

@override final  String id;
@override final  String leagueId;
@override final  String managerId;
@override final  String managerName;
@override final  String playerId;
@override final  String playerName;
@override final  int price;
@override final  int transferType;
@override final  DateTime timestamp;
@override final  int? marketValueAtTransfer;

/// Create a copy of ManagerTransferHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagerTransferHistoryEntryCopyWith<_ManagerTransferHistoryEntry> get copyWith => __$ManagerTransferHistoryEntryCopyWithImpl<_ManagerTransferHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagerTransferHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagerTransferHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.managerId, managerId) || other.managerId == managerId)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.price, price) || other.price == price)&&(identical(other.transferType, transferType) || other.transferType == transferType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.marketValueAtTransfer, marketValueAtTransfer) || other.marketValueAtTransfer == marketValueAtTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,leagueId,managerId,managerName,playerId,playerName,price,transferType,timestamp,marketValueAtTransfer);
}

@override
String toString() {
    return 'ManagerTransferHistoryEntry(id: $id, leagueId: $leagueId, managerId: $managerId, managerName: $managerName, playerId: $playerId, playerName: $playerName, price: $price, transferType: $transferType, timestamp: $timestamp, marketValueAtTransfer: $marketValueAtTransfer)';
}


}

/// @nodoc
abstract mixin class _$ManagerTransferHistoryEntryCopyWith<$Res> implements $ManagerTransferHistoryEntryCopyWith<$Res> {
  factory _$ManagerTransferHistoryEntryCopyWith(_ManagerTransferHistoryEntry value, $Res Function(_ManagerTransferHistoryEntry) _then) = __$ManagerTransferHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String leagueId, String managerId, String managerName, String playerId, String playerName, int price, int transferType, DateTime timestamp, int? marketValueAtTransfer
});




}
/// @nodoc
class __$ManagerTransferHistoryEntryCopyWithImpl<$Res>
    implements _$ManagerTransferHistoryEntryCopyWith<$Res> {
  __$ManagerTransferHistoryEntryCopyWithImpl(this._self, this._then);

  final _ManagerTransferHistoryEntry _self;
  final $Res Function(_ManagerTransferHistoryEntry) _then;

/// Create a copy of ManagerTransferHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leagueId = null,Object? managerId = null,Object? managerName = null,Object? playerId = null,Object? playerName = null,Object? price = null,Object? transferType = null,Object? timestamp = null,Object? marketValueAtTransfer = freezed,}) {
  return _then(_ManagerTransferHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,managerId: null == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,transferType: null == transferType ? _self.transferType : transferType // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,marketValueAtTransfer: freezed == marketValueAtTransfer ? _self.marketValueAtTransfer : marketValueAtTransfer // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Recommendation {

 String get id; String get leagueId; String get playerId; String get playerName; double get score; String get reason; String get action; int? get suggestedPrice; int get currentMarketValue; int get estimatedValue; double get confidence; DateTime get timestamp; String get category; String? get swapCandidateId; String? get swapCandidateName; bool get userOwnsPlayer;
/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationCopyWith<Recommendation> get copyWith => _$RecommendationCopyWithImpl<Recommendation>(this as Recommendation, _$identity);

  /// Serializes this Recommendation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Recommendation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recommendation&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.suggestedPrice, _this.suggestedPrice) || other.suggestedPrice == _this.suggestedPrice)&&(identical(other.currentMarketValue, _this.currentMarketValue) || other.currentMarketValue == _this.currentMarketValue)&&(identical(other.estimatedValue, _this.estimatedValue) || other.estimatedValue == _this.estimatedValue)&&(identical(other.confidence, _this.confidence) || other.confidence == _this.confidence)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.swapCandidateId, _this.swapCandidateId) || other.swapCandidateId == _this.swapCandidateId)&&(identical(other.swapCandidateName, _this.swapCandidateName) || other.swapCandidateName == _this.swapCandidateName)&&(identical(other.userOwnsPlayer, _this.userOwnsPlayer) || other.userOwnsPlayer == _this.userOwnsPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Recommendation;
  return Object.hash(runtimeType,_this.id,_this.leagueId,_this.playerId,_this.playerName,_this.score,_this.reason,_this.action,_this.suggestedPrice,_this.currentMarketValue,_this.estimatedValue,_this.confidence,_this.timestamp,_this.category,_this.swapCandidateId,_this.swapCandidateName,_this.userOwnsPlayer);
}

@override
String toString() {
  final _this = this as Recommendation;
  return 'Recommendation(id: ${_this.id}, leagueId: ${_this.leagueId}, playerId: ${_this.playerId}, playerName: ${_this.playerName}, score: ${_this.score}, reason: ${_this.reason}, action: ${_this.action}, suggestedPrice: ${_this.suggestedPrice}, currentMarketValue: ${_this.currentMarketValue}, estimatedValue: ${_this.estimatedValue}, confidence: ${_this.confidence}, timestamp: ${_this.timestamp}, category: ${_this.category}, swapCandidateId: ${_this.swapCandidateId}, swapCandidateName: ${_this.swapCandidateName}, userOwnsPlayer: ${_this.userOwnsPlayer})';
}


}

/// @nodoc
abstract mixin class $RecommendationCopyWith<$Res>  {
  factory $RecommendationCopyWith(Recommendation value, $Res Function(Recommendation) _then) = _$RecommendationCopyWithImpl;
@useResult
$Res call({
 String id, String leagueId, String playerId, String playerName, double score, String reason, String action, int? suggestedPrice, int currentMarketValue, int estimatedValue, double confidence, DateTime timestamp, String category, String? swapCandidateId, String? swapCandidateName, bool userOwnsPlayer
});




}
/// @nodoc
class _$RecommendationCopyWithImpl<$Res>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._self, this._then);

  final Recommendation _self;
  final $Res Function(Recommendation) _then;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leagueId = null,Object? playerId = null,Object? playerName = null,Object? score = null,Object? reason = null,Object? action = null,Object? suggestedPrice = freezed,Object? currentMarketValue = null,Object? estimatedValue = null,Object? confidence = null,Object? timestamp = null,Object? category = null,Object? swapCandidateId = freezed,Object? swapCandidateName = freezed,Object? userOwnsPlayer = null,}) {
  return _then(Recommendation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,suggestedPrice: freezed == suggestedPrice ? _self.suggestedPrice : suggestedPrice // ignore: cast_nullable_to_non_nullable
as int?,currentMarketValue: null == currentMarketValue ? _self.currentMarketValue : currentMarketValue // ignore: cast_nullable_to_non_nullable
as int,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,swapCandidateId: freezed == swapCandidateId ? _self.swapCandidateId : swapCandidateId // ignore: cast_nullable_to_non_nullable
as String?,swapCandidateName: freezed == swapCandidateName ? _self.swapCandidateName : swapCandidateName // ignore: cast_nullable_to_non_nullable
as String?,userOwnsPlayer: null == userOwnsPlayer ? _self.userOwnsPlayer : userOwnsPlayer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Recommendation].
extension RecommendationPatterns on Recommendation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recommendation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recommendation value)  $default,){
final _that = this;
switch (_that) {
case _Recommendation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recommendation value)?  $default,){
final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leagueId,  String playerId,  String playerName,  double score,  String reason,  String action,  int? suggestedPrice,  int currentMarketValue,  int estimatedValue,  double confidence,  DateTime timestamp,  String category,  String? swapCandidateId,  String? swapCandidateName,  bool userOwnsPlayer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
return $default(_that.id,_that.leagueId,_that.playerId,_that.playerName,_that.score,_that.reason,_that.action,_that.suggestedPrice,_that.currentMarketValue,_that.estimatedValue,_that.confidence,_that.timestamp,_that.category,_that.swapCandidateId,_that.swapCandidateName,_that.userOwnsPlayer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leagueId,  String playerId,  String playerName,  double score,  String reason,  String action,  int? suggestedPrice,  int currentMarketValue,  int estimatedValue,  double confidence,  DateTime timestamp,  String category,  String? swapCandidateId,  String? swapCandidateName,  bool userOwnsPlayer)  $default,) {final _that = this;
switch (_that) {
case _Recommendation():
return $default(_that.id,_that.leagueId,_that.playerId,_that.playerName,_that.score,_that.reason,_that.action,_that.suggestedPrice,_that.currentMarketValue,_that.estimatedValue,_that.confidence,_that.timestamp,_that.category,_that.swapCandidateId,_that.swapCandidateName,_that.userOwnsPlayer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leagueId,  String playerId,  String playerName,  double score,  String reason,  String action,  int? suggestedPrice,  int currentMarketValue,  int estimatedValue,  double confidence,  DateTime timestamp,  String category,  String? swapCandidateId,  String? swapCandidateName,  bool userOwnsPlayer)?  $default,) {final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
return $default(_that.id,_that.leagueId,_that.playerId,_that.playerName,_that.score,_that.reason,_that.action,_that.suggestedPrice,_that.currentMarketValue,_that.estimatedValue,_that.confidence,_that.timestamp,_that.category,_that.swapCandidateId,_that.swapCandidateName,_that.userOwnsPlayer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recommendation implements Recommendation {
  const _Recommendation({required this.id, required this.leagueId, required this.playerId, required this.playerName, required this.score, required this.reason, required this.action, this.suggestedPrice, required this.currentMarketValue, required this.estimatedValue, required this.confidence, required this.timestamp, required this.category, this.swapCandidateId, this.swapCandidateName, this.userOwnsPlayer = false});
  factory _Recommendation.fromJson(Map<String, dynamic> json) => _$RecommendationFromJson(json);

@override final  String id;
@override final  String leagueId;
@override final  String playerId;
@override final  String playerName;
@override final  double score;
@override final  String reason;
@override final  String action;
@override final  int? suggestedPrice;
@override final  int currentMarketValue;
@override final  int estimatedValue;
@override final  double confidence;
@override final  DateTime timestamp;
@override final  String category;
@override final  String? swapCandidateId;
@override final  String? swapCandidateName;
@override@JsonKey() final  bool userOwnsPlayer;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationCopyWith<_Recommendation> get copyWith => __$RecommendationCopyWithImpl<_Recommendation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recommendation&&(identical(other.id, id) || other.id == id)&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.score, score) || other.score == score)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.action, action) || other.action == action)&&(identical(other.suggestedPrice, suggestedPrice) || other.suggestedPrice == suggestedPrice)&&(identical(other.currentMarketValue, currentMarketValue) || other.currentMarketValue == currentMarketValue)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.category, category) || other.category == category)&&(identical(other.swapCandidateId, swapCandidateId) || other.swapCandidateId == swapCandidateId)&&(identical(other.swapCandidateName, swapCandidateName) || other.swapCandidateName == swapCandidateName)&&(identical(other.userOwnsPlayer, userOwnsPlayer) || other.userOwnsPlayer == userOwnsPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,leagueId,playerId,playerName,score,reason,action,suggestedPrice,currentMarketValue,estimatedValue,confidence,timestamp,category,swapCandidateId,swapCandidateName,userOwnsPlayer);
}

@override
String toString() {
    return 'Recommendation(id: $id, leagueId: $leagueId, playerId: $playerId, playerName: $playerName, score: $score, reason: $reason, action: $action, suggestedPrice: $suggestedPrice, currentMarketValue: $currentMarketValue, estimatedValue: $estimatedValue, confidence: $confidence, timestamp: $timestamp, category: $category, swapCandidateId: $swapCandidateId, swapCandidateName: $swapCandidateName, userOwnsPlayer: $userOwnsPlayer)';
}


}

/// @nodoc
abstract mixin class _$RecommendationCopyWith<$Res> implements $RecommendationCopyWith<$Res> {
  factory _$RecommendationCopyWith(_Recommendation value, $Res Function(_Recommendation) _then) = __$RecommendationCopyWithImpl;
@override @useResult
$Res call({
 String id, String leagueId, String playerId, String playerName, double score, String reason, String action, int? suggestedPrice, int currentMarketValue, int estimatedValue, double confidence, DateTime timestamp, String category, String? swapCandidateId, String? swapCandidateName, bool userOwnsPlayer
});




}
/// @nodoc
class __$RecommendationCopyWithImpl<$Res>
    implements _$RecommendationCopyWith<$Res> {
  __$RecommendationCopyWithImpl(this._self, this._then);

  final _Recommendation _self;
  final $Res Function(_Recommendation) _then;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leagueId = null,Object? playerId = null,Object? playerName = null,Object? score = null,Object? reason = null,Object? action = null,Object? suggestedPrice = freezed,Object? currentMarketValue = null,Object? estimatedValue = null,Object? confidence = null,Object? timestamp = null,Object? category = null,Object? swapCandidateId = freezed,Object? swapCandidateName = freezed,Object? userOwnsPlayer = null,}) {
  return _then(_Recommendation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,suggestedPrice: freezed == suggestedPrice ? _self.suggestedPrice : suggestedPrice // ignore: cast_nullable_to_non_nullable
as int?,currentMarketValue: null == currentMarketValue ? _self.currentMarketValue : currentMarketValue // ignore: cast_nullable_to_non_nullable
as int,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,swapCandidateId: freezed == swapCandidateId ? _self.swapCandidateId : swapCandidateId // ignore: cast_nullable_to_non_nullable
as String?,swapCandidateName: freezed == swapCandidateName ? _self.swapCandidateName : swapCandidateName // ignore: cast_nullable_to_non_nullable
as String?,userOwnsPlayer: null == userOwnsPlayer ? _self.userOwnsPlayer : userOwnsPlayer // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BidResponse {

 String get id; String get transferId; String get bidderId; int get bidAmount; DateTime get createdAt; String get status;
/// Create a copy of BidResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BidResponseCopyWith<BidResponse> get copyWith => _$BidResponseCopyWithImpl<BidResponse>(this as BidResponse, _$identity);

  /// Serializes this BidResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BidResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BidResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.transferId, _this.transferId) || other.transferId == _this.transferId)&&(identical(other.bidderId, _this.bidderId) || other.bidderId == _this.bidderId)&&(identical(other.bidAmount, _this.bidAmount) || other.bidAmount == _this.bidAmount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BidResponse;
  return Object.hash(runtimeType,_this.id,_this.transferId,_this.bidderId,_this.bidAmount,_this.createdAt,_this.status);
}

@override
String toString() {
  final _this = this as BidResponse;
  return 'BidResponse(id: ${_this.id}, transferId: ${_this.transferId}, bidderId: ${_this.bidderId}, bidAmount: ${_this.bidAmount}, createdAt: ${_this.createdAt}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $BidResponseCopyWith<$Res>  {
  factory $BidResponseCopyWith(BidResponse value, $Res Function(BidResponse) _then) = _$BidResponseCopyWithImpl;
@useResult
$Res call({
 String id, String transferId, String bidderId, int bidAmount, DateTime createdAt, String status
});




}
/// @nodoc
class _$BidResponseCopyWithImpl<$Res>
    implements $BidResponseCopyWith<$Res> {
  _$BidResponseCopyWithImpl(this._self, this._then);

  final BidResponse _self;
  final $Res Function(BidResponse) _then;

/// Create a copy of BidResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transferId = null,Object? bidderId = null,Object? bidAmount = null,Object? createdAt = null,Object? status = null,}) {
  return _then(BidResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,bidderId: null == bidderId ? _self.bidderId : bidderId // ignore: cast_nullable_to_non_nullable
as String,bidAmount: null == bidAmount ? _self.bidAmount : bidAmount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BidResponse].
extension BidResponsePatterns on BidResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BidResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BidResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BidResponse value)  $default,){
final _that = this;
switch (_that) {
case _BidResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BidResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BidResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String transferId,  String bidderId,  int bidAmount,  DateTime createdAt,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BidResponse() when $default != null:
return $default(_that.id,_that.transferId,_that.bidderId,_that.bidAmount,_that.createdAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String transferId,  String bidderId,  int bidAmount,  DateTime createdAt,  String status)  $default,) {final _that = this;
switch (_that) {
case _BidResponse():
return $default(_that.id,_that.transferId,_that.bidderId,_that.bidAmount,_that.createdAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String transferId,  String bidderId,  int bidAmount,  DateTime createdAt,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BidResponse() when $default != null:
return $default(_that.id,_that.transferId,_that.bidderId,_that.bidAmount,_that.createdAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BidResponse implements BidResponse {
  const _BidResponse({required this.id, required this.transferId, required this.bidderId, required this.bidAmount, required this.createdAt, required this.status});
  factory _BidResponse.fromJson(Map<String, dynamic> json) => _$BidResponseFromJson(json);

@override final  String id;
@override final  String transferId;
@override final  String bidderId;
@override final  int bidAmount;
@override final  DateTime createdAt;
@override final  String status;

/// Create a copy of BidResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BidResponseCopyWith<_BidResponse> get copyWith => __$BidResponseCopyWithImpl<_BidResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BidResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BidResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.bidderId, bidderId) || other.bidderId == bidderId)&&(identical(other.bidAmount, bidAmount) || other.bidAmount == bidAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,transferId,bidderId,bidAmount,createdAt,status);
}

@override
String toString() {
    return 'BidResponse(id: $id, transferId: $transferId, bidderId: $bidderId, bidAmount: $bidAmount, createdAt: $createdAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BidResponseCopyWith<$Res> implements $BidResponseCopyWith<$Res> {
  factory _$BidResponseCopyWith(_BidResponse value, $Res Function(_BidResponse) _then) = __$BidResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String transferId, String bidderId, int bidAmount, DateTime createdAt, String status
});




}
/// @nodoc
class __$BidResponseCopyWithImpl<$Res>
    implements _$BidResponseCopyWith<$Res> {
  __$BidResponseCopyWithImpl(this._self, this._then);

  final _BidResponse _self;
  final $Res Function(_BidResponse) _then;

/// Create a copy of BidResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transferId = null,Object? bidderId = null,Object? bidAmount = null,Object? createdAt = null,Object? status = null,}) {
  return _then(_BidResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,bidderId: null == bidderId ? _self.bidderId : bidderId // ignore: cast_nullable_to_non_nullable
as String,bidAmount: null == bidAmount ? _self.bidAmount : bidAmount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TransferRequest {

 String get playerId; String get toUserId; int get price;
/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferRequestCopyWith<TransferRequest> get copyWith => _$TransferRequestCopyWithImpl<TransferRequest>(this as TransferRequest, _$identity);

  /// Serializes this TransferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransferRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferRequest&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.toUserId, _this.toUserId) || other.toUserId == _this.toUserId)&&(identical(other.price, _this.price) || other.price == _this.price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransferRequest;
  return Object.hash(runtimeType,_this.playerId,_this.toUserId,_this.price);
}

@override
String toString() {
  final _this = this as TransferRequest;
  return 'TransferRequest(playerId: ${_this.playerId}, toUserId: ${_this.toUserId}, price: ${_this.price})';
}


}

/// @nodoc
abstract mixin class $TransferRequestCopyWith<$Res>  {
  factory $TransferRequestCopyWith(TransferRequest value, $Res Function(TransferRequest) _then) = _$TransferRequestCopyWithImpl;
@useResult
$Res call({
 String playerId, String toUserId, int price
});




}
/// @nodoc
class _$TransferRequestCopyWithImpl<$Res>
    implements $TransferRequestCopyWith<$Res> {
  _$TransferRequestCopyWithImpl(this._self, this._then);

  final TransferRequest _self;
  final $Res Function(TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? toUserId = null,Object? price = null,}) {
  return _then(TransferRequest(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferRequest].
extension TransferRequestPatterns on TransferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String toUserId,  int price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.playerId,_that.toUserId,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String toUserId,  int price)  $default,) {final _that = this;
switch (_that) {
case _TransferRequest():
return $default(_that.playerId,_that.toUserId,_that.price);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String toUserId,  int price)?  $default,) {final _that = this;
switch (_that) {
case _TransferRequest() when $default != null:
return $default(_that.playerId,_that.toUserId,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferRequest implements TransferRequest {
  const _TransferRequest({required this.playerId, required this.toUserId, required this.price});
  factory _TransferRequest.fromJson(Map<String, dynamic> json) => _$TransferRequestFromJson(json);

@override final  String playerId;
@override final  String toUserId;
@override final  int price;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferRequestCopyWith<_TransferRequest> get copyWith => __$TransferRequestCopyWithImpl<_TransferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferRequest&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,playerId,toUserId,price);
}

@override
String toString() {
    return 'TransferRequest(playerId: $playerId, toUserId: $toUserId, price: $price)';
}


}

/// @nodoc
abstract mixin class _$TransferRequestCopyWith<$Res> implements $TransferRequestCopyWith<$Res> {
  factory _$TransferRequestCopyWith(_TransferRequest value, $Res Function(_TransferRequest) _then) = __$TransferRequestCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String toUserId, int price
});




}
/// @nodoc
class __$TransferRequestCopyWithImpl<$Res>
    implements _$TransferRequestCopyWith<$Res> {
  __$TransferRequestCopyWithImpl(this._self, this._then);

  final _TransferRequest _self;
  final $Res Function(_TransferRequest) _then;

/// Create a copy of TransferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? toUserId = null,Object? price = null,}) {
  return _then(_TransferRequest(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TransfersResponse {

 List<Transfer> get transfers; int? get totalCount;
/// Create a copy of TransfersResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransfersResponseCopyWith<TransfersResponse> get copyWith => _$TransfersResponseCopyWithImpl<TransfersResponse>(this as TransfersResponse, _$identity);

  /// Serializes this TransfersResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransfersResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransfersResponse&&const DeepCollectionEquality().equals(other.transfers, _this.transfers)&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransfersResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transfers),_this.totalCount);
}

@override
String toString() {
  final _this = this as TransfersResponse;
  return 'TransfersResponse(transfers: ${_this.transfers}, totalCount: ${_this.totalCount})';
}


}

/// @nodoc
abstract mixin class $TransfersResponseCopyWith<$Res>  {
  factory $TransfersResponseCopyWith(TransfersResponse value, $Res Function(TransfersResponse) _then) = _$TransfersResponseCopyWithImpl;
@useResult
$Res call({
 List<Transfer> transfers, int? totalCount
});




}
/// @nodoc
class _$TransfersResponseCopyWithImpl<$Res>
    implements $TransfersResponseCopyWith<$Res> {
  _$TransfersResponseCopyWithImpl(this._self, this._then);

  final TransfersResponse _self;
  final $Res Function(TransfersResponse) _then;

/// Create a copy of TransfersResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transfers = null,Object? totalCount = freezed,}) {
  return _then(TransfersResponse(
transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<Transfer>,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransfersResponse].
extension TransfersResponsePatterns on TransfersResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransfersResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransfersResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransfersResponse value)  $default,){
final _that = this;
switch (_that) {
case _TransfersResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransfersResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TransfersResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transfer> transfers,  int? totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransfersResponse() when $default != null:
return $default(_that.transfers,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transfer> transfers,  int? totalCount)  $default,) {final _that = this;
switch (_that) {
case _TransfersResponse():
return $default(_that.transfers,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transfer> transfers,  int? totalCount)?  $default,) {final _that = this;
switch (_that) {
case _TransfersResponse() when $default != null:
return $default(_that.transfers,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TransfersResponse implements TransfersResponse {
  const _TransfersResponse({required  List<Transfer> transfers, this.totalCount}): _transfers = transfers;
  factory _TransfersResponse.fromJson(Map<String, dynamic> json) => _$TransfersResponseFromJson(json);

 final  List<Transfer> _transfers;
@override List<Transfer> get transfers {
  if (_transfers is EqualUnmodifiableListView) return _transfers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transfers);
}

@override final  int? totalCount;

/// Create a copy of TransfersResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransfersResponseCopyWith<_TransfersResponse> get copyWith => __$TransfersResponseCopyWithImpl<_TransfersResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransfersResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransfersResponse&&const DeepCollectionEquality().equals(other.transfers, _transfers)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transfers),totalCount);
}

@override
String toString() {
    return 'TransfersResponse(transfers: $transfers, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$TransfersResponseCopyWith<$Res> implements $TransfersResponseCopyWith<$Res> {
  factory _$TransfersResponseCopyWith(_TransfersResponse value, $Res Function(_TransfersResponse) _then) = __$TransfersResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Transfer> transfers, int? totalCount
});




}
/// @nodoc
class __$TransfersResponseCopyWithImpl<$Res>
    implements _$TransfersResponseCopyWith<$Res> {
  __$TransfersResponseCopyWithImpl(this._self, this._then);

  final _TransfersResponse _self;
  final $Res Function(_TransfersResponse) _then;

/// Create a copy of TransfersResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transfers = null,Object? totalCount = freezed,}) {
  return _then(_TransfersResponse(
transfers: null == transfers ? _self._transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<Transfer>,totalCount: freezed == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
