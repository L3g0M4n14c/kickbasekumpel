// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_calculation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ManagerBudgetCalculation {

/// Manager ID
 String get managerId;/// Manager Name
 String get managerName;/// Liga ID
 String get leagueId;/// Startbudget (150 Mio. €)
 int get initialBudget;/// Summe der Marktwerte der Anfangsspieler
 int get initialSquadValue;/// Startbudget nach Abzug der Anfangsspieler
 int get startingBudget;/// Summe aller Verkäufe (Einnahmen)
 int get totalSales;/// Summe aller Käufe (Ausgaben)
 int get totalPurchases;/// Aktuelles Budget
 int get currentBudget;/// Liste der Anfangsspieler mit Marktwert
 List<InitialPlayer> get initialPlayers;/// Liste der Transfers (Käufe und Verkäufe)
 List<ManagerTransfer> get transfers;/// Zeitstempel der Berechnung
 DateTime get calculatedAt;
/// Create a copy of ManagerBudgetCalculation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagerBudgetCalculationCopyWith<ManagerBudgetCalculation> get copyWith => _$ManagerBudgetCalculationCopyWithImpl<ManagerBudgetCalculation>(this as ManagerBudgetCalculation, _$identity);

  /// Serializes this ManagerBudgetCalculation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ManagerBudgetCalculation;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagerBudgetCalculation&&(identical(other.managerId, _this.managerId) || other.managerId == _this.managerId)&&(identical(other.managerName, _this.managerName) || other.managerName == _this.managerName)&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.initialBudget, _this.initialBudget) || other.initialBudget == _this.initialBudget)&&(identical(other.initialSquadValue, _this.initialSquadValue) || other.initialSquadValue == _this.initialSquadValue)&&(identical(other.startingBudget, _this.startingBudget) || other.startingBudget == _this.startingBudget)&&(identical(other.totalSales, _this.totalSales) || other.totalSales == _this.totalSales)&&(identical(other.totalPurchases, _this.totalPurchases) || other.totalPurchases == _this.totalPurchases)&&(identical(other.currentBudget, _this.currentBudget) || other.currentBudget == _this.currentBudget)&&const DeepCollectionEquality().equals(other.initialPlayers, _this.initialPlayers)&&const DeepCollectionEquality().equals(other.transfers, _this.transfers)&&(identical(other.calculatedAt, _this.calculatedAt) || other.calculatedAt == _this.calculatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ManagerBudgetCalculation;
  return Object.hash(runtimeType,_this.managerId,_this.managerName,_this.leagueId,_this.initialBudget,_this.initialSquadValue,_this.startingBudget,_this.totalSales,_this.totalPurchases,_this.currentBudget,const DeepCollectionEquality().hash(_this.initialPlayers),const DeepCollectionEquality().hash(_this.transfers),_this.calculatedAt);
}

@override
String toString() {
  final _this = this as ManagerBudgetCalculation;
  return 'ManagerBudgetCalculation(managerId: ${_this.managerId}, managerName: ${_this.managerName}, leagueId: ${_this.leagueId}, initialBudget: ${_this.initialBudget}, initialSquadValue: ${_this.initialSquadValue}, startingBudget: ${_this.startingBudget}, totalSales: ${_this.totalSales}, totalPurchases: ${_this.totalPurchases}, currentBudget: ${_this.currentBudget}, initialPlayers: ${_this.initialPlayers}, transfers: ${_this.transfers}, calculatedAt: ${_this.calculatedAt})';
}


}

/// @nodoc
abstract mixin class $ManagerBudgetCalculationCopyWith<$Res>  {
  factory $ManagerBudgetCalculationCopyWith(ManagerBudgetCalculation value, $Res Function(ManagerBudgetCalculation) _then) = _$ManagerBudgetCalculationCopyWithImpl;
@useResult
$Res call({
 String managerId, String managerName, String leagueId, int initialBudget, int initialSquadValue, int startingBudget, int totalSales, int totalPurchases, int currentBudget, List<InitialPlayer> initialPlayers, List<ManagerTransfer> transfers, DateTime calculatedAt
});




}
/// @nodoc
class _$ManagerBudgetCalculationCopyWithImpl<$Res>
    implements $ManagerBudgetCalculationCopyWith<$Res> {
  _$ManagerBudgetCalculationCopyWithImpl(this._self, this._then);

  final ManagerBudgetCalculation _self;
  final $Res Function(ManagerBudgetCalculation) _then;

/// Create a copy of ManagerBudgetCalculation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? managerId = null,Object? managerName = null,Object? leagueId = null,Object? initialBudget = null,Object? initialSquadValue = null,Object? startingBudget = null,Object? totalSales = null,Object? totalPurchases = null,Object? currentBudget = null,Object? initialPlayers = null,Object? transfers = null,Object? calculatedAt = null,}) {
  return _then(ManagerBudgetCalculation(
managerId: null == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,initialBudget: null == initialBudget ? _self.initialBudget : initialBudget // ignore: cast_nullable_to_non_nullable
as int,initialSquadValue: null == initialSquadValue ? _self.initialSquadValue : initialSquadValue // ignore: cast_nullable_to_non_nullable
as int,startingBudget: null == startingBudget ? _self.startingBudget : startingBudget // ignore: cast_nullable_to_non_nullable
as int,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as int,totalPurchases: null == totalPurchases ? _self.totalPurchases : totalPurchases // ignore: cast_nullable_to_non_nullable
as int,currentBudget: null == currentBudget ? _self.currentBudget : currentBudget // ignore: cast_nullable_to_non_nullable
as int,initialPlayers: null == initialPlayers ? _self.initialPlayers : initialPlayers // ignore: cast_nullable_to_non_nullable
as List<InitialPlayer>,transfers: null == transfers ? _self.transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<ManagerTransfer>,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagerBudgetCalculation].
extension ManagerBudgetCalculationPatterns on ManagerBudgetCalculation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagerBudgetCalculation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagerBudgetCalculation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagerBudgetCalculation value)  $default,){
final _that = this;
switch (_that) {
case _ManagerBudgetCalculation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagerBudgetCalculation value)?  $default,){
final _that = this;
switch (_that) {
case _ManagerBudgetCalculation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String managerId,  String managerName,  String leagueId,  int initialBudget,  int initialSquadValue,  int startingBudget,  int totalSales,  int totalPurchases,  int currentBudget,  List<InitialPlayer> initialPlayers,  List<ManagerTransfer> transfers,  DateTime calculatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagerBudgetCalculation() when $default != null:
return $default(_that.managerId,_that.managerName,_that.leagueId,_that.initialBudget,_that.initialSquadValue,_that.startingBudget,_that.totalSales,_that.totalPurchases,_that.currentBudget,_that.initialPlayers,_that.transfers,_that.calculatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String managerId,  String managerName,  String leagueId,  int initialBudget,  int initialSquadValue,  int startingBudget,  int totalSales,  int totalPurchases,  int currentBudget,  List<InitialPlayer> initialPlayers,  List<ManagerTransfer> transfers,  DateTime calculatedAt)  $default,) {final _that = this;
switch (_that) {
case _ManagerBudgetCalculation():
return $default(_that.managerId,_that.managerName,_that.leagueId,_that.initialBudget,_that.initialSquadValue,_that.startingBudget,_that.totalSales,_that.totalPurchases,_that.currentBudget,_that.initialPlayers,_that.transfers,_that.calculatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String managerId,  String managerName,  String leagueId,  int initialBudget,  int initialSquadValue,  int startingBudget,  int totalSales,  int totalPurchases,  int currentBudget,  List<InitialPlayer> initialPlayers,  List<ManagerTransfer> transfers,  DateTime calculatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagerBudgetCalculation() when $default != null:
return $default(_that.managerId,_that.managerName,_that.leagueId,_that.initialBudget,_that.initialSquadValue,_that.startingBudget,_that.totalSales,_that.totalPurchases,_that.currentBudget,_that.initialPlayers,_that.transfers,_that.calculatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagerBudgetCalculation implements ManagerBudgetCalculation {
  const _ManagerBudgetCalculation({required this.managerId, required this.managerName, required this.leagueId, this.initialBudget = 150000000, this.initialSquadValue = 0, this.startingBudget = 0, this.totalSales = 0, this.totalPurchases = 0, this.currentBudget = 0,  List<InitialPlayer> initialPlayers = const [],  List<ManagerTransfer> transfers = const [], required this.calculatedAt}): _initialPlayers = initialPlayers,_transfers = transfers;
  factory _ManagerBudgetCalculation.fromJson(Map<String, dynamic> json) => _$ManagerBudgetCalculationFromJson(json);

/// Manager ID
@override final  String managerId;
/// Manager Name
@override final  String managerName;
/// Liga ID
@override final  String leagueId;
/// Startbudget (150 Mio. €)
@override@JsonKey() final  int initialBudget;
/// Summe der Marktwerte der Anfangsspieler
@override@JsonKey() final  int initialSquadValue;
/// Startbudget nach Abzug der Anfangsspieler
@override@JsonKey() final  int startingBudget;
/// Summe aller Verkäufe (Einnahmen)
@override@JsonKey() final  int totalSales;
/// Summe aller Käufe (Ausgaben)
@override@JsonKey() final  int totalPurchases;
/// Aktuelles Budget
@override@JsonKey() final  int currentBudget;
/// Liste der Anfangsspieler mit Marktwert
 final  List<InitialPlayer> _initialPlayers;
/// Liste der Anfangsspieler mit Marktwert
@override@JsonKey() List<InitialPlayer> get initialPlayers {
  if (_initialPlayers is EqualUnmodifiableListView) return _initialPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_initialPlayers);
}

/// Liste der Transfers (Käufe und Verkäufe)
 final  List<ManagerTransfer> _transfers;
/// Liste der Transfers (Käufe und Verkäufe)
@override@JsonKey() List<ManagerTransfer> get transfers {
  if (_transfers is EqualUnmodifiableListView) return _transfers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transfers);
}

/// Zeitstempel der Berechnung
@override final  DateTime calculatedAt;

/// Create a copy of ManagerBudgetCalculation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagerBudgetCalculationCopyWith<_ManagerBudgetCalculation> get copyWith => __$ManagerBudgetCalculationCopyWithImpl<_ManagerBudgetCalculation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagerBudgetCalculationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagerBudgetCalculation&&(identical(other.managerId, managerId) || other.managerId == managerId)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.initialBudget, initialBudget) || other.initialBudget == initialBudget)&&(identical(other.initialSquadValue, initialSquadValue) || other.initialSquadValue == initialSquadValue)&&(identical(other.startingBudget, startingBudget) || other.startingBudget == startingBudget)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalPurchases, totalPurchases) || other.totalPurchases == totalPurchases)&&(identical(other.currentBudget, currentBudget) || other.currentBudget == currentBudget)&&const DeepCollectionEquality().equals(other.initialPlayers, _initialPlayers)&&const DeepCollectionEquality().equals(other.transfers, _transfers)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,managerId,managerName,leagueId,initialBudget,initialSquadValue,startingBudget,totalSales,totalPurchases,currentBudget,const DeepCollectionEquality().hash(_initialPlayers),const DeepCollectionEquality().hash(_transfers),calculatedAt);
}

@override
String toString() {
    return 'ManagerBudgetCalculation(managerId: $managerId, managerName: $managerName, leagueId: $leagueId, initialBudget: $initialBudget, initialSquadValue: $initialSquadValue, startingBudget: $startingBudget, totalSales: $totalSales, totalPurchases: $totalPurchases, currentBudget: $currentBudget, initialPlayers: $initialPlayers, transfers: $transfers, calculatedAt: $calculatedAt)';
}


}

/// @nodoc
abstract mixin class _$ManagerBudgetCalculationCopyWith<$Res> implements $ManagerBudgetCalculationCopyWith<$Res> {
  factory _$ManagerBudgetCalculationCopyWith(_ManagerBudgetCalculation value, $Res Function(_ManagerBudgetCalculation) _then) = __$ManagerBudgetCalculationCopyWithImpl;
@override @useResult
$Res call({
 String managerId, String managerName, String leagueId, int initialBudget, int initialSquadValue, int startingBudget, int totalSales, int totalPurchases, int currentBudget, List<InitialPlayer> initialPlayers, List<ManagerTransfer> transfers, DateTime calculatedAt
});




}
/// @nodoc
class __$ManagerBudgetCalculationCopyWithImpl<$Res>
    implements _$ManagerBudgetCalculationCopyWith<$Res> {
  __$ManagerBudgetCalculationCopyWithImpl(this._self, this._then);

  final _ManagerBudgetCalculation _self;
  final $Res Function(_ManagerBudgetCalculation) _then;

/// Create a copy of ManagerBudgetCalculation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? managerId = null,Object? managerName = null,Object? leagueId = null,Object? initialBudget = null,Object? initialSquadValue = null,Object? startingBudget = null,Object? totalSales = null,Object? totalPurchases = null,Object? currentBudget = null,Object? initialPlayers = null,Object? transfers = null,Object? calculatedAt = null,}) {
  return _then(_ManagerBudgetCalculation(
managerId: null == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,initialBudget: null == initialBudget ? _self.initialBudget : initialBudget // ignore: cast_nullable_to_non_nullable
as int,initialSquadValue: null == initialSquadValue ? _self.initialSquadValue : initialSquadValue // ignore: cast_nullable_to_non_nullable
as int,startingBudget: null == startingBudget ? _self.startingBudget : startingBudget // ignore: cast_nullable_to_non_nullable
as int,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as int,totalPurchases: null == totalPurchases ? _self.totalPurchases : totalPurchases // ignore: cast_nullable_to_non_nullable
as int,currentBudget: null == currentBudget ? _self.currentBudget : currentBudget // ignore: cast_nullable_to_non_nullable
as int,initialPlayers: null == initialPlayers ? _self._initialPlayers : initialPlayers // ignore: cast_nullable_to_non_nullable
as List<InitialPlayer>,transfers: null == transfers ? _self._transfers : transfers // ignore: cast_nullable_to_non_nullable
as List<ManagerTransfer>,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$InitialPlayer {

 String get playerId; String get playerName; int get marketValue; DateTime get transferDate;
/// Create a copy of InitialPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialPlayerCopyWith<InitialPlayer> get copyWith => _$InitialPlayerCopyWithImpl<InitialPlayer>(this as InitialPlayer, _$identity);

  /// Serializes this InitialPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InitialPlayer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialPlayer&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.transferDate, _this.transferDate) || other.transferDate == _this.transferDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InitialPlayer;
  return Object.hash(runtimeType,_this.playerId,_this.playerName,_this.marketValue,_this.transferDate);
}

@override
String toString() {
  final _this = this as InitialPlayer;
  return 'InitialPlayer(playerId: ${_this.playerId}, playerName: ${_this.playerName}, marketValue: ${_this.marketValue}, transferDate: ${_this.transferDate})';
}


}

/// @nodoc
abstract mixin class $InitialPlayerCopyWith<$Res>  {
  factory $InitialPlayerCopyWith(InitialPlayer value, $Res Function(InitialPlayer) _then) = _$InitialPlayerCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, int marketValue, DateTime transferDate
});




}
/// @nodoc
class _$InitialPlayerCopyWithImpl<$Res>
    implements $InitialPlayerCopyWith<$Res> {
  _$InitialPlayerCopyWithImpl(this._self, this._then);

  final InitialPlayer _self;
  final $Res Function(InitialPlayer) _then;

/// Create a copy of InitialPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? marketValue = null,Object? transferDate = null,}) {
  return _then(InitialPlayer(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,transferDate: null == transferDate ? _self.transferDate : transferDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InitialPlayer].
extension InitialPlayerPatterns on InitialPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InitialPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitialPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InitialPlayer value)  $default,){
final _that = this;
switch (_that) {
case _InitialPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InitialPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _InitialPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int marketValue,  DateTime transferDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitialPlayer() when $default != null:
return $default(_that.playerId,_that.playerName,_that.marketValue,_that.transferDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int marketValue,  DateTime transferDate)  $default,) {final _that = this;
switch (_that) {
case _InitialPlayer():
return $default(_that.playerId,_that.playerName,_that.marketValue,_that.transferDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  int marketValue,  DateTime transferDate)?  $default,) {final _that = this;
switch (_that) {
case _InitialPlayer() when $default != null:
return $default(_that.playerId,_that.playerName,_that.marketValue,_that.transferDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InitialPlayer implements InitialPlayer {
  const _InitialPlayer({required this.playerId, required this.playerName, required this.marketValue, required this.transferDate});
  factory _InitialPlayer.fromJson(Map<String, dynamic> json) => _$InitialPlayerFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  int marketValue;
@override final  DateTime transferDate;

/// Create a copy of InitialPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialPlayerCopyWith<_InitialPlayer> get copyWith => __$InitialPlayerCopyWithImpl<_InitialPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InitialPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitialPlayer&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.transferDate, transferDate) || other.transferDate == transferDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,playerId,playerName,marketValue,transferDate);
}

@override
String toString() {
    return 'InitialPlayer(playerId: $playerId, playerName: $playerName, marketValue: $marketValue, transferDate: $transferDate)';
}


}

/// @nodoc
abstract mixin class _$InitialPlayerCopyWith<$Res> implements $InitialPlayerCopyWith<$Res> {
  factory _$InitialPlayerCopyWith(_InitialPlayer value, $Res Function(_InitialPlayer) _then) = __$InitialPlayerCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, int marketValue, DateTime transferDate
});




}
/// @nodoc
class __$InitialPlayerCopyWithImpl<$Res>
    implements _$InitialPlayerCopyWith<$Res> {
  __$InitialPlayerCopyWithImpl(this._self, this._then);

  final _InitialPlayer _self;
  final $Res Function(_InitialPlayer) _then;

/// Create a copy of InitialPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? marketValue = null,Object? transferDate = null,}) {
  return _then(_InitialPlayer(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,transferDate: null == transferDate ? _self.transferDate : transferDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ManagerTransfer {

 String get transferId; String get playerId; String get playerName; int get price; int get transferType; DateTime get timestamp; int? get marketValueAtTransfer;
/// Create a copy of ManagerTransfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagerTransferCopyWith<ManagerTransfer> get copyWith => _$ManagerTransferCopyWithImpl<ManagerTransfer>(this as ManagerTransfer, _$identity);

  /// Serializes this ManagerTransfer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ManagerTransfer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagerTransfer&&(identical(other.transferId, _this.transferId) || other.transferId == _this.transferId)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.transferType, _this.transferType) || other.transferType == _this.transferType)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.marketValueAtTransfer, _this.marketValueAtTransfer) || other.marketValueAtTransfer == _this.marketValueAtTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ManagerTransfer;
  return Object.hash(runtimeType,_this.transferId,_this.playerId,_this.playerName,_this.price,_this.transferType,_this.timestamp,_this.marketValueAtTransfer);
}

@override
String toString() {
  final _this = this as ManagerTransfer;
  return 'ManagerTransfer(transferId: ${_this.transferId}, playerId: ${_this.playerId}, playerName: ${_this.playerName}, price: ${_this.price}, transferType: ${_this.transferType}, timestamp: ${_this.timestamp}, marketValueAtTransfer: ${_this.marketValueAtTransfer})';
}


}

/// @nodoc
abstract mixin class $ManagerTransferCopyWith<$Res>  {
  factory $ManagerTransferCopyWith(ManagerTransfer value, $Res Function(ManagerTransfer) _then) = _$ManagerTransferCopyWithImpl;
@useResult
$Res call({
 String transferId, String playerId, String playerName, int price, int transferType, DateTime timestamp, int? marketValueAtTransfer
});




}
/// @nodoc
class _$ManagerTransferCopyWithImpl<$Res>
    implements $ManagerTransferCopyWith<$Res> {
  _$ManagerTransferCopyWithImpl(this._self, this._then);

  final ManagerTransfer _self;
  final $Res Function(ManagerTransfer) _then;

/// Create a copy of ManagerTransfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? playerId = null,Object? playerName = null,Object? price = null,Object? transferType = null,Object? timestamp = null,Object? marketValueAtTransfer = freezed,}) {
  return _then(ManagerTransfer(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [ManagerTransfer].
extension ManagerTransferPatterns on ManagerTransfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagerTransfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagerTransfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagerTransfer value)  $default,){
final _that = this;
switch (_that) {
case _ManagerTransfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagerTransfer value)?  $default,){
final _that = this;
switch (_that) {
case _ManagerTransfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transferId,  String playerId,  String playerName,  int price,  int transferType,  DateTime timestamp,  int? marketValueAtTransfer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagerTransfer() when $default != null:
return $default(_that.transferId,_that.playerId,_that.playerName,_that.price,_that.transferType,_that.timestamp,_that.marketValueAtTransfer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transferId,  String playerId,  String playerName,  int price,  int transferType,  DateTime timestamp,  int? marketValueAtTransfer)  $default,) {final _that = this;
switch (_that) {
case _ManagerTransfer():
return $default(_that.transferId,_that.playerId,_that.playerName,_that.price,_that.transferType,_that.timestamp,_that.marketValueAtTransfer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transferId,  String playerId,  String playerName,  int price,  int transferType,  DateTime timestamp,  int? marketValueAtTransfer)?  $default,) {final _that = this;
switch (_that) {
case _ManagerTransfer() when $default != null:
return $default(_that.transferId,_that.playerId,_that.playerName,_that.price,_that.transferType,_that.timestamp,_that.marketValueAtTransfer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagerTransfer implements ManagerTransfer {
  const _ManagerTransfer({required this.transferId, required this.playerId, required this.playerName, required this.price, required this.transferType, required this.timestamp, this.marketValueAtTransfer});
  factory _ManagerTransfer.fromJson(Map<String, dynamic> json) => _$ManagerTransferFromJson(json);

@override final  String transferId;
@override final  String playerId;
@override final  String playerName;
@override final  int price;
@override final  int transferType;
@override final  DateTime timestamp;
@override final  int? marketValueAtTransfer;

/// Create a copy of ManagerTransfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagerTransferCopyWith<_ManagerTransfer> get copyWith => __$ManagerTransferCopyWithImpl<_ManagerTransfer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagerTransferToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagerTransfer&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.price, price) || other.price == price)&&(identical(other.transferType, transferType) || other.transferType == transferType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.marketValueAtTransfer, marketValueAtTransfer) || other.marketValueAtTransfer == marketValueAtTransfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,transferId,playerId,playerName,price,transferType,timestamp,marketValueAtTransfer);
}

@override
String toString() {
    return 'ManagerTransfer(transferId: $transferId, playerId: $playerId, playerName: $playerName, price: $price, transferType: $transferType, timestamp: $timestamp, marketValueAtTransfer: $marketValueAtTransfer)';
}


}

/// @nodoc
abstract mixin class _$ManagerTransferCopyWith<$Res> implements $ManagerTransferCopyWith<$Res> {
  factory _$ManagerTransferCopyWith(_ManagerTransfer value, $Res Function(_ManagerTransfer) _then) = __$ManagerTransferCopyWithImpl;
@override @useResult
$Res call({
 String transferId, String playerId, String playerName, int price, int transferType, DateTime timestamp, int? marketValueAtTransfer
});




}
/// @nodoc
class __$ManagerTransferCopyWithImpl<$Res>
    implements _$ManagerTransferCopyWith<$Res> {
  __$ManagerTransferCopyWithImpl(this._self, this._then);

  final _ManagerTransfer _self;
  final $Res Function(_ManagerTransfer) _then;

/// Create a copy of ManagerTransfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? playerId = null,Object? playerName = null,Object? price = null,Object? transferType = null,Object? timestamp = null,Object? marketValueAtTransfer = freezed,}) {
  return _then(_ManagerTransfer(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
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
mixin _$AutoSaleEvent {

/// Spieltag, an dem der Spieler die Schwelle erreicht hat
 int get matchday;/// Spieler-ID
 String get playerId;/// Spielername
 String get playerName;/// Saison-Gesamtpunkte zum Zeitpunkt des Verkaufs
 int get points;/// Punkte-Schwelle der Regel (z.B. 250)
 int get threshold;/// Marktwert zum Verkaufszeitpunkt (Einnahme)
 int get marketValue;/// true, wenn der Marktwert nicht zweifelsfrei ermittelt werden konnte
 bool get uncertain;
/// Create a copy of AutoSaleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutoSaleEventCopyWith<AutoSaleEvent> get copyWith => _$AutoSaleEventCopyWithImpl<AutoSaleEvent>(this as AutoSaleEvent, _$identity);

  /// Serializes this AutoSaleEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AutoSaleEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoSaleEvent&&(identical(other.matchday, _this.matchday) || other.matchday == _this.matchday)&&(identical(other.playerId, _this.playerId) || other.playerId == _this.playerId)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.threshold, _this.threshold) || other.threshold == _this.threshold)&&(identical(other.marketValue, _this.marketValue) || other.marketValue == _this.marketValue)&&(identical(other.uncertain, _this.uncertain) || other.uncertain == _this.uncertain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AutoSaleEvent;
  return Object.hash(runtimeType,_this.matchday,_this.playerId,_this.playerName,_this.points,_this.threshold,_this.marketValue,_this.uncertain);
}

@override
String toString() {
  final _this = this as AutoSaleEvent;
  return 'AutoSaleEvent(matchday: ${_this.matchday}, playerId: ${_this.playerId}, playerName: ${_this.playerName}, points: ${_this.points}, threshold: ${_this.threshold}, marketValue: ${_this.marketValue}, uncertain: ${_this.uncertain})';
}


}

/// @nodoc
abstract mixin class $AutoSaleEventCopyWith<$Res>  {
  factory $AutoSaleEventCopyWith(AutoSaleEvent value, $Res Function(AutoSaleEvent) _then) = _$AutoSaleEventCopyWithImpl;
@useResult
$Res call({
 int matchday, String playerId, String playerName, int points, int threshold, int marketValue, bool uncertain
});




}
/// @nodoc
class _$AutoSaleEventCopyWithImpl<$Res>
    implements $AutoSaleEventCopyWith<$Res> {
  _$AutoSaleEventCopyWithImpl(this._self, this._then);

  final AutoSaleEvent _self;
  final $Res Function(AutoSaleEvent) _then;

/// Create a copy of AutoSaleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchday = null,Object? playerId = null,Object? playerName = null,Object? points = null,Object? threshold = null,Object? marketValue = null,Object? uncertain = null,}) {
  return _then(AutoSaleEvent(
matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,uncertain: null == uncertain ? _self.uncertain : uncertain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AutoSaleEvent].
extension AutoSaleEventPatterns on AutoSaleEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutoSaleEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutoSaleEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutoSaleEvent value)  $default,){
final _that = this;
switch (_that) {
case _AutoSaleEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutoSaleEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AutoSaleEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int matchday,  String playerId,  String playerName,  int points,  int threshold,  int marketValue,  bool uncertain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutoSaleEvent() when $default != null:
return $default(_that.matchday,_that.playerId,_that.playerName,_that.points,_that.threshold,_that.marketValue,_that.uncertain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int matchday,  String playerId,  String playerName,  int points,  int threshold,  int marketValue,  bool uncertain)  $default,) {final _that = this;
switch (_that) {
case _AutoSaleEvent():
return $default(_that.matchday,_that.playerId,_that.playerName,_that.points,_that.threshold,_that.marketValue,_that.uncertain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int matchday,  String playerId,  String playerName,  int points,  int threshold,  int marketValue,  bool uncertain)?  $default,) {final _that = this;
switch (_that) {
case _AutoSaleEvent() when $default != null:
return $default(_that.matchday,_that.playerId,_that.playerName,_that.points,_that.threshold,_that.marketValue,_that.uncertain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutoSaleEvent implements AutoSaleEvent {
  const _AutoSaleEvent({required this.matchday, required this.playerId, required this.playerName, required this.points, required this.threshold, required this.marketValue, this.uncertain = false});
  factory _AutoSaleEvent.fromJson(Map<String, dynamic> json) => _$AutoSaleEventFromJson(json);

/// Spieltag, an dem der Spieler die Schwelle erreicht hat
@override final  int matchday;
/// Spieler-ID
@override final  String playerId;
/// Spielername
@override final  String playerName;
/// Saison-Gesamtpunkte zum Zeitpunkt des Verkaufs
@override final  int points;
/// Punkte-Schwelle der Regel (z.B. 250)
@override final  int threshold;
/// Marktwert zum Verkaufszeitpunkt (Einnahme)
@override final  int marketValue;
/// true, wenn der Marktwert nicht zweifelsfrei ermittelt werden konnte
@override@JsonKey() final  bool uncertain;

/// Create a copy of AutoSaleEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutoSaleEventCopyWith<_AutoSaleEvent> get copyWith => __$AutoSaleEventCopyWithImpl<_AutoSaleEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutoSaleEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutoSaleEvent&&(identical(other.matchday, matchday) || other.matchday == matchday)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.points, points) || other.points == points)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.marketValue, marketValue) || other.marketValue == marketValue)&&(identical(other.uncertain, uncertain) || other.uncertain == uncertain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,matchday,playerId,playerName,points,threshold,marketValue,uncertain);
}

@override
String toString() {
    return 'AutoSaleEvent(matchday: $matchday, playerId: $playerId, playerName: $playerName, points: $points, threshold: $threshold, marketValue: $marketValue, uncertain: $uncertain)';
}


}

/// @nodoc
abstract mixin class _$AutoSaleEventCopyWith<$Res> implements $AutoSaleEventCopyWith<$Res> {
  factory _$AutoSaleEventCopyWith(_AutoSaleEvent value, $Res Function(_AutoSaleEvent) _then) = __$AutoSaleEventCopyWithImpl;
@override @useResult
$Res call({
 int matchday, String playerId, String playerName, int points, int threshold, int marketValue, bool uncertain
});




}
/// @nodoc
class __$AutoSaleEventCopyWithImpl<$Res>
    implements _$AutoSaleEventCopyWith<$Res> {
  __$AutoSaleEventCopyWithImpl(this._self, this._then);

  final _AutoSaleEvent _self;
  final $Res Function(_AutoSaleEvent) _then;

/// Create a copy of AutoSaleEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchday = null,Object? playerId = null,Object? playerName = null,Object? points = null,Object? threshold = null,Object? marketValue = null,Object? uncertain = null,}) {
  return _then(_AutoSaleEvent(
matchday: null == matchday ? _self.matchday : matchday // ignore: cast_nullable_to_non_nullable
as int,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,marketValue: null == marketValue ? _self.marketValue : marketValue // ignore: cast_nullable_to_non_nullable
as int,uncertain: null == uncertain ? _self.uncertain : uncertain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$BudgetCalculationResult {

 String get managerId; String get managerName; String get leagueId; int get initialBudget; int get initialSquadValue; int get startingBudget; int get totalSales; int get totalPurchases; int get currentBudget; List<InitialPlayer> get initialPlayers; List<ManagerTransfer> get sales; List<ManagerTransfer> get purchases; DateTime get calculatedAt;/// Summe der Einnahmen durch automatische Verkäufe (Auto-Verkauf /
/// 250er-Regel). Diese Verkäufe erscheinen nicht in der Transfer-Historie
/// und werden daher separat ermittelt und addiert.
 int get autoSaleIncome;/// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
 List<AutoSaleEvent> get autoSaleEvents;/// Kumulierter täglicher Anmeldebonus seit dem ersten Tag der Liga
/// (Tag 1: 10.000 €, Tag 2: 20.000 €, … Tag 10: 100.000 €, ab da
/// konstant 100.000 € pro Tag). Bereits in [currentBudget] enthalten.
 int get loginBonus;/// Anzahl der Liga-Tage, für die der Anmeldebonus gewährt wurde
/// (Tag 1 = erster Tag der Liga).
 int get loginBonusDays;/// Summe der Budget-Einnahmen durch Erfolge (Achievements). Bereits in
/// [currentBudget] enthalten.
 int get achievementIncome;
/// Create a copy of BudgetCalculationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCalculationResultCopyWith<BudgetCalculationResult> get copyWith => _$BudgetCalculationResultCopyWithImpl<BudgetCalculationResult>(this as BudgetCalculationResult, _$identity);

  /// Serializes this BudgetCalculationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BudgetCalculationResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetCalculationResult&&(identical(other.managerId, _this.managerId) || other.managerId == _this.managerId)&&(identical(other.managerName, _this.managerName) || other.managerName == _this.managerName)&&(identical(other.leagueId, _this.leagueId) || other.leagueId == _this.leagueId)&&(identical(other.initialBudget, _this.initialBudget) || other.initialBudget == _this.initialBudget)&&(identical(other.initialSquadValue, _this.initialSquadValue) || other.initialSquadValue == _this.initialSquadValue)&&(identical(other.startingBudget, _this.startingBudget) || other.startingBudget == _this.startingBudget)&&(identical(other.totalSales, _this.totalSales) || other.totalSales == _this.totalSales)&&(identical(other.totalPurchases, _this.totalPurchases) || other.totalPurchases == _this.totalPurchases)&&(identical(other.currentBudget, _this.currentBudget) || other.currentBudget == _this.currentBudget)&&const DeepCollectionEquality().equals(other.initialPlayers, _this.initialPlayers)&&const DeepCollectionEquality().equals(other.sales, _this.sales)&&const DeepCollectionEquality().equals(other.purchases, _this.purchases)&&(identical(other.calculatedAt, _this.calculatedAt) || other.calculatedAt == _this.calculatedAt)&&(identical(other.autoSaleIncome, _this.autoSaleIncome) || other.autoSaleIncome == _this.autoSaleIncome)&&const DeepCollectionEquality().equals(other.autoSaleEvents, _this.autoSaleEvents)&&(identical(other.loginBonus, _this.loginBonus) || other.loginBonus == _this.loginBonus)&&(identical(other.loginBonusDays, _this.loginBonusDays) || other.loginBonusDays == _this.loginBonusDays)&&(identical(other.achievementIncome, _this.achievementIncome) || other.achievementIncome == _this.achievementIncome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BudgetCalculationResult;
  return Object.hash(runtimeType,_this.managerId,_this.managerName,_this.leagueId,_this.initialBudget,_this.initialSquadValue,_this.startingBudget,_this.totalSales,_this.totalPurchases,_this.currentBudget,const DeepCollectionEquality().hash(_this.initialPlayers),const DeepCollectionEquality().hash(_this.sales),const DeepCollectionEquality().hash(_this.purchases),_this.calculatedAt,_this.autoSaleIncome,const DeepCollectionEquality().hash(_this.autoSaleEvents),_this.loginBonus,_this.loginBonusDays,_this.achievementIncome);
}

@override
String toString() {
  final _this = this as BudgetCalculationResult;
  return 'BudgetCalculationResult(managerId: ${_this.managerId}, managerName: ${_this.managerName}, leagueId: ${_this.leagueId}, initialBudget: ${_this.initialBudget}, initialSquadValue: ${_this.initialSquadValue}, startingBudget: ${_this.startingBudget}, totalSales: ${_this.totalSales}, totalPurchases: ${_this.totalPurchases}, currentBudget: ${_this.currentBudget}, initialPlayers: ${_this.initialPlayers}, sales: ${_this.sales}, purchases: ${_this.purchases}, calculatedAt: ${_this.calculatedAt}, autoSaleIncome: ${_this.autoSaleIncome}, autoSaleEvents: ${_this.autoSaleEvents}, loginBonus: ${_this.loginBonus}, loginBonusDays: ${_this.loginBonusDays}, achievementIncome: ${_this.achievementIncome})';
}


}

/// @nodoc
abstract mixin class $BudgetCalculationResultCopyWith<$Res>  {
  factory $BudgetCalculationResultCopyWith(BudgetCalculationResult value, $Res Function(BudgetCalculationResult) _then) = _$BudgetCalculationResultCopyWithImpl;
@useResult
$Res call({
 String managerId, String managerName, String leagueId, int initialBudget, int initialSquadValue, int startingBudget, int totalSales, int totalPurchases, int currentBudget, List<InitialPlayer> initialPlayers, List<ManagerTransfer> sales, List<ManagerTransfer> purchases, DateTime calculatedAt, int autoSaleIncome, List<AutoSaleEvent> autoSaleEvents, int loginBonus, int loginBonusDays, int achievementIncome
});




}
/// @nodoc
class _$BudgetCalculationResultCopyWithImpl<$Res>
    implements $BudgetCalculationResultCopyWith<$Res> {
  _$BudgetCalculationResultCopyWithImpl(this._self, this._then);

  final BudgetCalculationResult _self;
  final $Res Function(BudgetCalculationResult) _then;

/// Create a copy of BudgetCalculationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? managerId = null,Object? managerName = null,Object? leagueId = null,Object? initialBudget = null,Object? initialSquadValue = null,Object? startingBudget = null,Object? totalSales = null,Object? totalPurchases = null,Object? currentBudget = null,Object? initialPlayers = null,Object? sales = null,Object? purchases = null,Object? calculatedAt = null,Object? autoSaleIncome = null,Object? autoSaleEvents = null,Object? loginBonus = null,Object? loginBonusDays = null,Object? achievementIncome = null,}) {
  return _then(BudgetCalculationResult(
managerId: null == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,initialBudget: null == initialBudget ? _self.initialBudget : initialBudget // ignore: cast_nullable_to_non_nullable
as int,initialSquadValue: null == initialSquadValue ? _self.initialSquadValue : initialSquadValue // ignore: cast_nullable_to_non_nullable
as int,startingBudget: null == startingBudget ? _self.startingBudget : startingBudget // ignore: cast_nullable_to_non_nullable
as int,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as int,totalPurchases: null == totalPurchases ? _self.totalPurchases : totalPurchases // ignore: cast_nullable_to_non_nullable
as int,currentBudget: null == currentBudget ? _self.currentBudget : currentBudget // ignore: cast_nullable_to_non_nullable
as int,initialPlayers: null == initialPlayers ? _self.initialPlayers : initialPlayers // ignore: cast_nullable_to_non_nullable
as List<InitialPlayer>,sales: null == sales ? _self.sales : sales // ignore: cast_nullable_to_non_nullable
as List<ManagerTransfer>,purchases: null == purchases ? _self.purchases : purchases // ignore: cast_nullable_to_non_nullable
as List<ManagerTransfer>,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,autoSaleIncome: null == autoSaleIncome ? _self.autoSaleIncome : autoSaleIncome // ignore: cast_nullable_to_non_nullable
as int,autoSaleEvents: null == autoSaleEvents ? _self.autoSaleEvents : autoSaleEvents // ignore: cast_nullable_to_non_nullable
as List<AutoSaleEvent>,loginBonus: null == loginBonus ? _self.loginBonus : loginBonus // ignore: cast_nullable_to_non_nullable
as int,loginBonusDays: null == loginBonusDays ? _self.loginBonusDays : loginBonusDays // ignore: cast_nullable_to_non_nullable
as int,achievementIncome: null == achievementIncome ? _self.achievementIncome : achievementIncome // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetCalculationResult].
extension BudgetCalculationResultPatterns on BudgetCalculationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetCalculationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetCalculationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetCalculationResult value)  $default,){
final _that = this;
switch (_that) {
case _BudgetCalculationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetCalculationResult value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetCalculationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String managerId,  String managerName,  String leagueId,  int initialBudget,  int initialSquadValue,  int startingBudget,  int totalSales,  int totalPurchases,  int currentBudget,  List<InitialPlayer> initialPlayers,  List<ManagerTransfer> sales,  List<ManagerTransfer> purchases,  DateTime calculatedAt,  int autoSaleIncome,  List<AutoSaleEvent> autoSaleEvents,  int loginBonus,  int loginBonusDays,  int achievementIncome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetCalculationResult() when $default != null:
return $default(_that.managerId,_that.managerName,_that.leagueId,_that.initialBudget,_that.initialSquadValue,_that.startingBudget,_that.totalSales,_that.totalPurchases,_that.currentBudget,_that.initialPlayers,_that.sales,_that.purchases,_that.calculatedAt,_that.autoSaleIncome,_that.autoSaleEvents,_that.loginBonus,_that.loginBonusDays,_that.achievementIncome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String managerId,  String managerName,  String leagueId,  int initialBudget,  int initialSquadValue,  int startingBudget,  int totalSales,  int totalPurchases,  int currentBudget,  List<InitialPlayer> initialPlayers,  List<ManagerTransfer> sales,  List<ManagerTransfer> purchases,  DateTime calculatedAt,  int autoSaleIncome,  List<AutoSaleEvent> autoSaleEvents,  int loginBonus,  int loginBonusDays,  int achievementIncome)  $default,) {final _that = this;
switch (_that) {
case _BudgetCalculationResult():
return $default(_that.managerId,_that.managerName,_that.leagueId,_that.initialBudget,_that.initialSquadValue,_that.startingBudget,_that.totalSales,_that.totalPurchases,_that.currentBudget,_that.initialPlayers,_that.sales,_that.purchases,_that.calculatedAt,_that.autoSaleIncome,_that.autoSaleEvents,_that.loginBonus,_that.loginBonusDays,_that.achievementIncome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String managerId,  String managerName,  String leagueId,  int initialBudget,  int initialSquadValue,  int startingBudget,  int totalSales,  int totalPurchases,  int currentBudget,  List<InitialPlayer> initialPlayers,  List<ManagerTransfer> sales,  List<ManagerTransfer> purchases,  DateTime calculatedAt,  int autoSaleIncome,  List<AutoSaleEvent> autoSaleEvents,  int loginBonus,  int loginBonusDays,  int achievementIncome)?  $default,) {final _that = this;
switch (_that) {
case _BudgetCalculationResult() when $default != null:
return $default(_that.managerId,_that.managerName,_that.leagueId,_that.initialBudget,_that.initialSquadValue,_that.startingBudget,_that.totalSales,_that.totalPurchases,_that.currentBudget,_that.initialPlayers,_that.sales,_that.purchases,_that.calculatedAt,_that.autoSaleIncome,_that.autoSaleEvents,_that.loginBonus,_that.loginBonusDays,_that.achievementIncome);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BudgetCalculationResult implements BudgetCalculationResult {
  const _BudgetCalculationResult({required this.managerId, required this.managerName, required this.leagueId, required this.initialBudget, required this.initialSquadValue, required this.startingBudget, required this.totalSales, required this.totalPurchases, required this.currentBudget, required  List<InitialPlayer> initialPlayers, required  List<ManagerTransfer> sales, required  List<ManagerTransfer> purchases, required this.calculatedAt, this.autoSaleIncome = 0,  List<AutoSaleEvent> autoSaleEvents = const [], this.loginBonus = 0, this.loginBonusDays = 0, this.achievementIncome = 0}): _initialPlayers = initialPlayers,_sales = sales,_purchases = purchases,_autoSaleEvents = autoSaleEvents;
  factory _BudgetCalculationResult.fromJson(Map<String, dynamic> json) => _$BudgetCalculationResultFromJson(json);

@override final  String managerId;
@override final  String managerName;
@override final  String leagueId;
@override final  int initialBudget;
@override final  int initialSquadValue;
@override final  int startingBudget;
@override final  int totalSales;
@override final  int totalPurchases;
@override final  int currentBudget;
 final  List<InitialPlayer> _initialPlayers;
@override List<InitialPlayer> get initialPlayers {
  if (_initialPlayers is EqualUnmodifiableListView) return _initialPlayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_initialPlayers);
}

 final  List<ManagerTransfer> _sales;
@override List<ManagerTransfer> get sales {
  if (_sales is EqualUnmodifiableListView) return _sales;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sales);
}

 final  List<ManagerTransfer> _purchases;
@override List<ManagerTransfer> get purchases {
  if (_purchases is EqualUnmodifiableListView) return _purchases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purchases);
}

@override final  DateTime calculatedAt;
/// Summe der Einnahmen durch automatische Verkäufe (Auto-Verkauf /
/// 250er-Regel). Diese Verkäufe erscheinen nicht in der Transfer-Historie
/// und werden daher separat ermittelt und addiert.
@override@JsonKey() final  int autoSaleIncome;
/// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
 final  List<AutoSaleEvent> _autoSaleEvents;
/// Einzelne Auto-Verkauf-Ereignisse des Managers in der aktuellen Saison.
@override@JsonKey() List<AutoSaleEvent> get autoSaleEvents {
  if (_autoSaleEvents is EqualUnmodifiableListView) return _autoSaleEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_autoSaleEvents);
}

/// Kumulierter täglicher Anmeldebonus seit dem ersten Tag der Liga
/// (Tag 1: 10.000 €, Tag 2: 20.000 €, … Tag 10: 100.000 €, ab da
/// konstant 100.000 € pro Tag). Bereits in [currentBudget] enthalten.
@override@JsonKey() final  int loginBonus;
/// Anzahl der Liga-Tage, für die der Anmeldebonus gewährt wurde
/// (Tag 1 = erster Tag der Liga).
@override@JsonKey() final  int loginBonusDays;
/// Summe der Budget-Einnahmen durch Erfolge (Achievements). Bereits in
/// [currentBudget] enthalten.
@override@JsonKey() final  int achievementIncome;

/// Create a copy of BudgetCalculationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCalculationResultCopyWith<_BudgetCalculationResult> get copyWith => __$BudgetCalculationResultCopyWithImpl<_BudgetCalculationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetCalculationResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetCalculationResult&&(identical(other.managerId, managerId) || other.managerId == managerId)&&(identical(other.managerName, managerName) || other.managerName == managerName)&&(identical(other.leagueId, leagueId) || other.leagueId == leagueId)&&(identical(other.initialBudget, initialBudget) || other.initialBudget == initialBudget)&&(identical(other.initialSquadValue, initialSquadValue) || other.initialSquadValue == initialSquadValue)&&(identical(other.startingBudget, startingBudget) || other.startingBudget == startingBudget)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.totalPurchases, totalPurchases) || other.totalPurchases == totalPurchases)&&(identical(other.currentBudget, currentBudget) || other.currentBudget == currentBudget)&&const DeepCollectionEquality().equals(other.initialPlayers, _initialPlayers)&&const DeepCollectionEquality().equals(other.sales, _sales)&&const DeepCollectionEquality().equals(other.purchases, _purchases)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&(identical(other.autoSaleIncome, autoSaleIncome) || other.autoSaleIncome == autoSaleIncome)&&const DeepCollectionEquality().equals(other.autoSaleEvents, _autoSaleEvents)&&(identical(other.loginBonus, loginBonus) || other.loginBonus == loginBonus)&&(identical(other.loginBonusDays, loginBonusDays) || other.loginBonusDays == loginBonusDays)&&(identical(other.achievementIncome, achievementIncome) || other.achievementIncome == achievementIncome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,managerId,managerName,leagueId,initialBudget,initialSquadValue,startingBudget,totalSales,totalPurchases,currentBudget,const DeepCollectionEquality().hash(_initialPlayers),const DeepCollectionEquality().hash(_sales),const DeepCollectionEquality().hash(_purchases),calculatedAt,autoSaleIncome,const DeepCollectionEquality().hash(_autoSaleEvents),loginBonus,loginBonusDays,achievementIncome);
}

@override
String toString() {
    return 'BudgetCalculationResult(managerId: $managerId, managerName: $managerName, leagueId: $leagueId, initialBudget: $initialBudget, initialSquadValue: $initialSquadValue, startingBudget: $startingBudget, totalSales: $totalSales, totalPurchases: $totalPurchases, currentBudget: $currentBudget, initialPlayers: $initialPlayers, sales: $sales, purchases: $purchases, calculatedAt: $calculatedAt, autoSaleIncome: $autoSaleIncome, autoSaleEvents: $autoSaleEvents, loginBonus: $loginBonus, loginBonusDays: $loginBonusDays, achievementIncome: $achievementIncome)';
}


}

/// @nodoc
abstract mixin class _$BudgetCalculationResultCopyWith<$Res> implements $BudgetCalculationResultCopyWith<$Res> {
  factory _$BudgetCalculationResultCopyWith(_BudgetCalculationResult value, $Res Function(_BudgetCalculationResult) _then) = __$BudgetCalculationResultCopyWithImpl;
@override @useResult
$Res call({
 String managerId, String managerName, String leagueId, int initialBudget, int initialSquadValue, int startingBudget, int totalSales, int totalPurchases, int currentBudget, List<InitialPlayer> initialPlayers, List<ManagerTransfer> sales, List<ManagerTransfer> purchases, DateTime calculatedAt, int autoSaleIncome, List<AutoSaleEvent> autoSaleEvents, int loginBonus, int loginBonusDays, int achievementIncome
});




}
/// @nodoc
class __$BudgetCalculationResultCopyWithImpl<$Res>
    implements _$BudgetCalculationResultCopyWith<$Res> {
  __$BudgetCalculationResultCopyWithImpl(this._self, this._then);

  final _BudgetCalculationResult _self;
  final $Res Function(_BudgetCalculationResult) _then;

/// Create a copy of BudgetCalculationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? managerId = null,Object? managerName = null,Object? leagueId = null,Object? initialBudget = null,Object? initialSquadValue = null,Object? startingBudget = null,Object? totalSales = null,Object? totalPurchases = null,Object? currentBudget = null,Object? initialPlayers = null,Object? sales = null,Object? purchases = null,Object? calculatedAt = null,Object? autoSaleIncome = null,Object? autoSaleEvents = null,Object? loginBonus = null,Object? loginBonusDays = null,Object? achievementIncome = null,}) {
  return _then(_BudgetCalculationResult(
managerId: null == managerId ? _self.managerId : managerId // ignore: cast_nullable_to_non_nullable
as String,managerName: null == managerName ? _self.managerName : managerName // ignore: cast_nullable_to_non_nullable
as String,leagueId: null == leagueId ? _self.leagueId : leagueId // ignore: cast_nullable_to_non_nullable
as String,initialBudget: null == initialBudget ? _self.initialBudget : initialBudget // ignore: cast_nullable_to_non_nullable
as int,initialSquadValue: null == initialSquadValue ? _self.initialSquadValue : initialSquadValue // ignore: cast_nullable_to_non_nullable
as int,startingBudget: null == startingBudget ? _self.startingBudget : startingBudget // ignore: cast_nullable_to_non_nullable
as int,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as int,totalPurchases: null == totalPurchases ? _self.totalPurchases : totalPurchases // ignore: cast_nullable_to_non_nullable
as int,currentBudget: null == currentBudget ? _self.currentBudget : currentBudget // ignore: cast_nullable_to_non_nullable
as int,initialPlayers: null == initialPlayers ? _self._initialPlayers : initialPlayers // ignore: cast_nullable_to_non_nullable
as List<InitialPlayer>,sales: null == sales ? _self._sales : sales // ignore: cast_nullable_to_non_nullable
as List<ManagerTransfer>,purchases: null == purchases ? _self._purchases : purchases // ignore: cast_nullable_to_non_nullable
as List<ManagerTransfer>,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,autoSaleIncome: null == autoSaleIncome ? _self.autoSaleIncome : autoSaleIncome // ignore: cast_nullable_to_non_nullable
as int,autoSaleEvents: null == autoSaleEvents ? _self._autoSaleEvents : autoSaleEvents // ignore: cast_nullable_to_non_nullable
as List<AutoSaleEvent>,loginBonus: null == loginBonus ? _self.loginBonus : loginBonus // ignore: cast_nullable_to_non_nullable
as int,loginBonusDays: null == loginBonusDays ? _self.loginBonusDays : loginBonusDays // ignore: cast_nullable_to_non_nullable
as int,achievementIncome: null == achievementIncome ? _self.achievementIncome : achievementIncome // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
