// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketValueHistoryResponse _$MarketValueHistoryResponseFromJson(
  Map<String, dynamic> json,
) => _MarketValueHistoryResponse(
  it: (json['it'] as List<dynamic>)
      .map((e) => MarketValueEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  prlo: (json['prlo'] as num?)?.toInt(),
);

Map<String, dynamic> _$MarketValueHistoryResponseToJson(
  _MarketValueHistoryResponse instance,
) => <String, dynamic>{'it': instance.it, 'prlo': instance.prlo};

_MarketValueEntry _$MarketValueEntryFromJson(Map<String, dynamic> json) =>
    _MarketValueEntry(
      dt: (json['dt'] as num).toInt(),
      mv: (json['mv'] as num).toInt(),
    );

Map<String, dynamic> _$MarketValueEntryToJson(_MarketValueEntry instance) =>
    <String, dynamic>{'dt': instance.dt, 'mv': instance.mv};

_DailyMarketValueChange _$DailyMarketValueChangeFromJson(
  Map<String, dynamic> json,
) => _DailyMarketValueChange(
  date: json['date'] as String,
  value: (json['value'] as num).toInt(),
  change: (json['change'] as num).toInt(),
  percentageChange: (json['percentageChange'] as num).toDouble(),
  daysAgo: (json['daysAgo'] as num).toInt(),
);

Map<String, dynamic> _$DailyMarketValueChangeToJson(
  _DailyMarketValueChange instance,
) => <String, dynamic>{
  'date': instance.date,
  'value': instance.value,
  'change': instance.change,
  'percentageChange': instance.percentageChange,
  'daysAgo': instance.daysAgo,
};

_MarketValueChange _$MarketValueChangeFromJson(Map<String, dynamic> json) =>
    _MarketValueChange(
      daysSinceLastUpdate: (json['daysSinceLastUpdate'] as num).toInt(),
      absoluteChange: (json['absoluteChange'] as num).toInt(),
      percentageChange: (json['percentageChange'] as num).toDouble(),
      previousValue: (json['previousValue'] as num).toInt(),
      currentValue: (json['currentValue'] as num).toInt(),
      dailyChanges: (json['dailyChanges'] as List<dynamic>)
          .map(
            (e) => DailyMarketValueChange.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$MarketValueChangeToJson(_MarketValueChange instance) =>
    <String, dynamic>{
      'daysSinceLastUpdate': instance.daysSinceLastUpdate,
      'absoluteChange': instance.absoluteChange,
      'percentageChange': instance.percentageChange,
      'previousValue': instance.previousValue,
      'currentValue': instance.currentValue,
      'dailyChanges': instance.dailyChanges,
    };
