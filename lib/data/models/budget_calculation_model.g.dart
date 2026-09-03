// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_calculation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerBudgetCalculationImpl _$$ManagerBudgetCalculationImplFromJson(
  Map<String, dynamic> json,
) => _$ManagerBudgetCalculationImpl(
  managerId: json['managerId'] as String,
  managerName: json['managerName'] as String,
  leagueId: json['leagueId'] as String,
  initialBudget: (json['initialBudget'] as num?)?.toInt() ?? 150000000,
  initialSquadValue: (json['initialSquadValue'] as num?)?.toInt() ?? 0,
  startingBudget: (json['startingBudget'] as num?)?.toInt() ?? 0,
  totalSales: (json['totalSales'] as num?)?.toInt() ?? 0,
  totalPurchases: (json['totalPurchases'] as num?)?.toInt() ?? 0,
  currentBudget: (json['currentBudget'] as num?)?.toInt() ?? 0,
  initialPlayers:
      (json['initialPlayers'] as List<dynamic>?)
          ?.map((e) => InitialPlayer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  transfers:
      (json['transfers'] as List<dynamic>?)
          ?.map((e) => ManagerTransfer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  calculatedAt: DateTime.parse(json['calculatedAt'] as String),
);

Map<String, dynamic> _$$ManagerBudgetCalculationImplToJson(
  _$ManagerBudgetCalculationImpl instance,
) => <String, dynamic>{
  'managerId': instance.managerId,
  'managerName': instance.managerName,
  'leagueId': instance.leagueId,
  'initialBudget': instance.initialBudget,
  'initialSquadValue': instance.initialSquadValue,
  'startingBudget': instance.startingBudget,
  'totalSales': instance.totalSales,
  'totalPurchases': instance.totalPurchases,
  'currentBudget': instance.currentBudget,
  'initialPlayers': instance.initialPlayers,
  'transfers': instance.transfers,
  'calculatedAt': instance.calculatedAt.toIso8601String(),
};

_$InitialPlayerImpl _$$InitialPlayerImplFromJson(Map<String, dynamic> json) =>
    _$InitialPlayerImpl(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      marketValue: (json['marketValue'] as num).toInt(),
      transferDate: DateTime.parse(json['transferDate'] as String),
    );

Map<String, dynamic> _$$InitialPlayerImplToJson(_$InitialPlayerImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'marketValue': instance.marketValue,
      'transferDate': instance.transferDate.toIso8601String(),
    };

_$ManagerTransferImpl _$$ManagerTransferImplFromJson(
  Map<String, dynamic> json,
) => _$ManagerTransferImpl(
  transferId: json['transferId'] as String,
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  price: (json['price'] as num).toInt(),
  transferType: (json['transferType'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  marketValueAtTransfer: (json['marketValueAtTransfer'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ManagerTransferImplToJson(
  _$ManagerTransferImpl instance,
) => <String, dynamic>{
  'transferId': instance.transferId,
  'playerId': instance.playerId,
  'playerName': instance.playerName,
  'price': instance.price,
  'transferType': instance.transferType,
  'timestamp': instance.timestamp.toIso8601String(),
  'marketValueAtTransfer': instance.marketValueAtTransfer,
};

_$AutoSaleEventImpl _$$AutoSaleEventImplFromJson(Map<String, dynamic> json) =>
    _$AutoSaleEventImpl(
      matchday: (json['matchday'] as num).toInt(),
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      points: (json['points'] as num).toInt(),
      threshold: (json['threshold'] as num).toInt(),
      marketValue: (json['marketValue'] as num).toInt(),
      uncertain: json['uncertain'] as bool? ?? false,
    );

Map<String, dynamic> _$$AutoSaleEventImplToJson(_$AutoSaleEventImpl instance) =>
    <String, dynamic>{
      'matchday': instance.matchday,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'points': instance.points,
      'threshold': instance.threshold,
      'marketValue': instance.marketValue,
      'uncertain': instance.uncertain,
    };

_$BudgetCalculationResultImpl _$$BudgetCalculationResultImplFromJson(
  Map<String, dynamic> json,
) => _$BudgetCalculationResultImpl(
  managerId: json['managerId'] as String,
  managerName: json['managerName'] as String,
  leagueId: json['leagueId'] as String,
  initialBudget: (json['initialBudget'] as num).toInt(),
  initialSquadValue: (json['initialSquadValue'] as num).toInt(),
  startingBudget: (json['startingBudget'] as num).toInt(),
  totalSales: (json['totalSales'] as num).toInt(),
  totalPurchases: (json['totalPurchases'] as num).toInt(),
  currentBudget: (json['currentBudget'] as num).toInt(),
  initialPlayers: (json['initialPlayers'] as List<dynamic>)
      .map((e) => InitialPlayer.fromJson(e as Map<String, dynamic>))
      .toList(),
  sales: (json['sales'] as List<dynamic>)
      .map((e) => ManagerTransfer.fromJson(e as Map<String, dynamic>))
      .toList(),
  purchases: (json['purchases'] as List<dynamic>)
      .map((e) => ManagerTransfer.fromJson(e as Map<String, dynamic>))
      .toList(),
  calculatedAt: DateTime.parse(json['calculatedAt'] as String),
  autoSaleIncome: (json['autoSaleIncome'] as num?)?.toInt() ?? 0,
  autoSaleEvents:
      (json['autoSaleEvents'] as List<dynamic>?)
          ?.map((e) => AutoSaleEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  loginBonus: (json['loginBonus'] as num?)?.toInt() ?? 0,
  loginBonusDays: (json['loginBonusDays'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$BudgetCalculationResultImplToJson(
  _$BudgetCalculationResultImpl instance,
) => <String, dynamic>{
  'managerId': instance.managerId,
  'managerName': instance.managerName,
  'leagueId': instance.leagueId,
  'initialBudget': instance.initialBudget,
  'initialSquadValue': instance.initialSquadValue,
  'startingBudget': instance.startingBudget,
  'totalSales': instance.totalSales,
  'totalPurchases': instance.totalPurchases,
  'currentBudget': instance.currentBudget,
  'initialPlayers': instance.initialPlayers,
  'sales': instance.sales,
  'purchases': instance.purchases,
  'calculatedAt': instance.calculatedAt.toIso8601String(),
  'autoSaleIncome': instance.autoSaleIncome,
  'autoSaleEvents': instance.autoSaleEvents,
  'loginBonus': instance.loginBonus,
  'loginBonusDays': instance.loginBonusDays,
};
