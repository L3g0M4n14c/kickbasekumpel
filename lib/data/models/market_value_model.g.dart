// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketValueHistoryResponseImpl _$$MarketValueHistoryResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MarketValueHistoryResponseImpl(
  it: (json['it'] as List<dynamic>)
      .map((e) => MarketValueEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  prlo: (json['prlo'] as num?)?.toInt(),
);

Map<String, dynamic> _$$MarketValueHistoryResponseImplToJson(
  _$MarketValueHistoryResponseImpl instance,
) => <String, dynamic>{'it': instance.it, 'prlo': instance.prlo};

_$MarketValueEntryImpl _$$MarketValueEntryImplFromJson(
  Map<String, dynamic> json,
) => _$MarketValueEntryImpl(
  dt: (json['dt'] as num).toInt(),
  mv: (json['mv'] as num).toInt(),
);

Map<String, dynamic> _$$MarketValueEntryImplToJson(
  _$MarketValueEntryImpl instance,
) => <String, dynamic>{'dt': instance.dt, 'mv': instance.mv};

_$DailyMarketValueChangeImpl _$$DailyMarketValueChangeImplFromJson(
  Map<String, dynamic> json,
) => _$DailyMarketValueChangeImpl(
  date: json['date'] as String,
  value: (json['value'] as num).toInt(),
  change: (json['change'] as num).toInt(),
  percentageChange: (json['percentageChange'] as num).toDouble(),
  daysAgo: (json['daysAgo'] as num).toInt(),
);

Map<String, dynamic> _$$DailyMarketValueChangeImplToJson(
  _$DailyMarketValueChangeImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'value': instance.value,
  'change': instance.change,
  'percentageChange': instance.percentageChange,
  'daysAgo': instance.daysAgo,
};

_$MarketValueChangeImpl _$$MarketValueChangeImplFromJson(
  Map<String, dynamic> json,
) => _$MarketValueChangeImpl(
  daysSinceLastUpdate: (json['daysSinceLastUpdate'] as num).toInt(),
  absoluteChange: (json['absoluteChange'] as num).toInt(),
  percentageChange: (json['percentageChange'] as num).toDouble(),
  previousValue: (json['previousValue'] as num).toInt(),
  currentValue: (json['currentValue'] as num).toInt(),
  dailyChanges: (json['dailyChanges'] as List<dynamic>)
      .map((e) => DailyMarketValueChange.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$MarketValueChangeImplToJson(
  _$MarketValueChangeImpl instance,
) => <String, dynamic>{
  'daysSinceLastUpdate': instance.daysSinceLastUpdate,
  'absoluteChange': instance.absoluteChange,
  'percentageChange': instance.percentageChange,
  'previousValue': instance.previousValue,
  'currentValue': instance.currentValue,
  'dailyChanges': instance.dailyChanges,
};
