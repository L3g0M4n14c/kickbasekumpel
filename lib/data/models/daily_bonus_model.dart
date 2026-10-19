import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_bonus_model.freezed.dart';
part 'daily_bonus_model.g.dart';

/// Ein pro Liga eingesammelter Tagesbonus (Eintrag aus `it` der
/// Antwort von `GET /v4/bonus/collect`).
@freezed
abstract class BonusCollection with _$BonusCollection {
  const factory BonusCollection({
    /// Liga-ID (`li`)
    @JsonKey(name: 'li') @Default('') String leagueId,

    /// Liga-Name (`lnm`)
    @JsonKey(name: 'lnm') @Default('') String leagueName,

    /// Bonus-Betrag in € (`v`)
    @JsonKey(name: 'v') @Default(0) int value,

    /// Tag der Bonus-Serie (`day`)
    @JsonKey(name: 'day') @Default(1) int day,

    /// Budget nach dem Einsammeln in € (`b`)
    @JsonKey(name: 'b') @Default(0) int budget,

    /// Pfad zum Liga-Bild (`lim`)
    @JsonKey(name: 'lim') @Default('') String leagueImage,
  }) = _BonusCollection;

  factory BonusCollection.fromJson(Map<String, dynamic> json) =>
      _$BonusCollectionFromJson(json);
}

/// Ergebnis des Bonus-Einsammelns (`GET /v4/bonus/collect`).
///
/// Die Antwort enthält pro Liga einen Eintrag (`it`) mit Bonus-Betrag (`v`),
/// Streak-Tag (`day`) und dem Budget nach dem Einsammeln (`b`).
@freezed
abstract class BonusCollectResult with _$BonusCollectResult {
  const BonusCollectResult._();

  const factory BonusCollectResult({
    /// Pro Liga eingesammelte Boni (`it`)
    @JsonKey(name: 'it') @Default([]) List<BonusCollection> collections,
  }) = _BonusCollectResult;

  factory BonusCollectResult.fromJson(Map<String, dynamic> json) =>
      _$BonusCollectResultFromJson(json);

  /// Summe aller eingesammelten Bonus-Beträge in €.
  int get totalValue => collections.fold(0, (sum, c) => sum + c.value);

  /// Höchster Tag der Bonus-Serie (0, wenn nichts eingesammelt wurde).
  int get maxDay => collections.fold(0, (max, c) => c.day > max ? c.day : max);
}

/// Bonus-Status, abgeleitet aus `GET /v4/base/overview`.
///
/// Die dokumentierte Overview-Response enthält News-Inhalte (`stg`, `sect`);
/// Bonus-Einträge (`it` mit `v`/`day`, wie bei `GET /v4/bonus/collect`) werden
/// aber erkannt, falls die API sie liefert. Fehlt ein eindeutiger Hinweis, wird
/// [DailyBonusStatus.isAvailable] als `null` (unbekannt) gesetzt.
@freezed
abstract class DailyBonusStatus with _$DailyBonusStatus {
  const factory DailyBonusStatus({
    /// true = Bonus ausstehend (Overview meldet Bonus-Einträge),
    /// null = Overview liefert keinen Bonus-Hinweis – dann entscheidet der
    /// lokale Einsammel-Stand (siehe `DailyBonusService`).
    /// false = Bonus ausdrücklich nicht ausstehend (derzeit nicht erkennbar,
    /// für künftige API-Hinweise reserviert).
    required bool? isAvailable,
  }) = _DailyBonusStatus;
}
