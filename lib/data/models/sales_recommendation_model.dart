import 'package:freezed_annotation/freezed_annotation.dart';
import 'player_model.dart';

part 'sales_recommendation_model.freezed.dart';
part 'sales_recommendation_model.g.dart';

/// Sales Recommendation Model für Verkaufs-Empfehlungen
@freezed
class SalesRecommendation with _$SalesRecommendation {
  const factory SalesRecommendation({
    required String id,
    required Player player,
    required String reason,
    required SalesPriority priority,
    required int expectedValue,
    required LineupImpact impact,
  }) = _SalesRecommendation;

  factory SalesRecommendation.fromJson(Map<String, dynamic> json) =>
      _$SalesRecommendationFromJson(json);
}

/// Priorität der Verkaufsempfehlung
enum SalesPriority {
  high,
  medium,
  low;

  String get label {
    switch (this) {
      case SalesPriority.high:
        return 'Hoch';
      case SalesPriority.medium:
        return 'Mittel';
      case SalesPriority.low:
        return 'Niedrig';
    }
  }
}

/// Impact auf die Aufstellung
enum LineupImpact {
  minimal,
  moderate,
  significant;

  String get label {
    switch (this) {
      case LineupImpact.minimal:
        return 'Minimal';
      case LineupImpact.moderate:
        return 'Moderat';
      case LineupImpact.significant:
        return 'Erheblich';
    }
  }
}

/// Optimierungsziel für Verkaufs-Empfehlungen
enum OptimizationGoal {
  balancePositive,
  maximizeProfit,
  keepBestPlayers;

  String get label {
    switch (this) {
      case OptimizationGoal.balancePositive:
        return 'Budget ins Plus';
      case OptimizationGoal.maximizeProfit:
        return 'Maximaler Profit';
      case OptimizationGoal.keepBestPlayers:
        return 'Beste Spieler behalten';
    }
  }
}
