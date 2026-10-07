// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_calculation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManagerBudgetCalculation _$ManagerBudgetCalculationFromJson(
  Map<String, dynamic> json,
) => _ManagerBudgetCalculation(
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

Map<String, dynamic> _$ManagerBudgetCalculationToJson(
  _ManagerBudgetCalculation instance,
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

_InitialPlayer _$InitialPlayerFromJson(Map<String, dynamic> json) =>
    _InitialPlayer(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      marketValue: (json['marketValue'] as num).toInt(),
      transferDate: DateTime.parse(json['transferDate'] as String),
    );

Map<String, dynamic> _$InitialPlayerToJson(_InitialPlayer instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'marketValue': instance.marketValue,
      'transferDate': instance.transferDate.toIso8601String(),
    };

_ManagerTransfer _$ManagerTransferFromJson(Map<String, dynamic> json) =>
    _ManagerTransfer(
      transferId: json['transferId'] as String,
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      price: (json['price'] as num).toInt(),
      transferType: (json['transferType'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      marketValueAtTransfer: (json['marketValueAtTransfer'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ManagerTransferToJson(_ManagerTransfer instance) =>
    <String, dynamic>{
      'transferId': instance.transferId,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'price': instance.price,
      'transferType': instance.transferType,
      'timestamp': instance.timestamp.toIso8601String(),
      'marketValueAtTransfer': instance.marketValueAtTransfer,
    };

_AutoSaleEvent _$AutoSaleEventFromJson(Map<String, dynamic> json) =>
    _AutoSaleEvent(
      matchday: (json['matchday'] as num).toInt(),
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      points: (json['points'] as num).toInt(),
      threshold: (json['threshold'] as num).toInt(),
      marketValue: (json['marketValue'] as num).toInt(),
      uncertain: json['uncertain'] as bool? ?? false,
    );

Map<String, dynamic> _$AutoSaleEventToJson(_AutoSaleEvent instance) =>
    <String, dynamic>{
      'matchday': instance.matchday,
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'points': instance.points,
      'threshold': instance.threshold,
      'marketValue': instance.marketValue,
      'uncertain': instance.uncertain,
    };

_BudgetCalculationResult _$BudgetCalculationResultFromJson(
  Map<String, dynamic> json,
) => _BudgetCalculationResult(
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

Map<String, dynamic> _$BudgetCalculationResultToJson(
  _BudgetCalculationResult instance,
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
