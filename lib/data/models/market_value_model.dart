import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_value_model.freezed.dart';
part 'market_value_model.g.dart';

/// Market Value History Response
@freezed
class MarketValueHistoryResponse with _$MarketValueHistoryResponse {
  const factory MarketValueHistoryResponse({
    required List<MarketValueEntry> it,
    int? prlo,
  }) = _MarketValueHistoryResponse;

  factory MarketValueHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketValueHistoryResponseFromJson(json);
}

/// Market Value Entry
@freezed
class MarketValueEntry with _$MarketValueEntry {
  const factory MarketValueEntry({required int dt, required int mv}) =
      _MarketValueEntry;

  factory MarketValueEntry.fromJson(Map<String, dynamic> json) =>
      _$MarketValueEntryFromJson(json);
}

/// Daily Market Value Change (berechnet)
@freezed
class DailyMarketValueChange with _$DailyMarketValueChange {
  const factory DailyMarketValueChange({
    required String date,
    required int value,
    required int change,
    required double percentageChange,
    required int daysAgo,
  }) = _DailyMarketValueChange;

  factory DailyMarketValueChange.fromJson(Map<String, dynamic> json) =>
      _$DailyMarketValueChangeFromJson(json);
}

/// Market Value Change (Aggregiert)
@freezed
class MarketValueChange with _$MarketValueChange {
  const factory MarketValueChange({
    required int daysSinceLastUpdate,
    required int absoluteChange,
    required double percentageChange,
    required int previousValue,
    required int currentValue,
    required List<DailyMarketValueChange> dailyChanges,
  }) = _MarketValueChange;

  factory MarketValueChange.fromJson(Map<String, dynamic> json) =>
      _$MarketValueChangeFromJson(json);
}
