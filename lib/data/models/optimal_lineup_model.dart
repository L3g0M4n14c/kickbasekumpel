import 'package:freezed_annotation/freezed_annotation.dart';
import 'player_model.dart';

part 'optimal_lineup_model.freezed.dart';
part 'optimal_lineup_model.g.dart';

/// Optimale Aufstellung für einen Spieler
@freezed
class OptimalLineup with _$OptimalLineup {
  const factory OptimalLineup({
    required Player? goalkeeper,
    required List<Player> defenders,
    required List<Player> midfielders,
    required List<Player> forwards,
  }) = _OptimalLineup;

  factory OptimalLineup.fromJson(Map<String, dynamic> json) =>
      _$OptimalLineupFromJson(json);
}

/// Lineup Vergleich (Aktuell vs. Optimal)
@freezed
class LineupComparison with _$LineupComparison {
  const factory LineupComparison({
    required OptimalLineup currentLineup,
    required OptimalLineup optimalLineup,
    required double currentScore,
    required double optimalScore,
    required List<Player> suggestedAdditions,
    required List<Player> suggestedRemovals,
  }) = _LineupComparison;

  factory LineupComparison.fromJson(Map<String, dynamic> json) =>
      _$LineupComparisonFromJson(json);
}

/// Formation Definition
class Formation {
  final String name;
  final int defenders;
  final int midfielders;
  final int forwards;

  const Formation({
    required this.name,
    required this.defenders,
    required this.midfielders,
    required this.forwards,
  });

  static const List<Formation> allFormations = [
    Formation(name: '4-4-2', defenders: 4, midfielders: 4, forwards: 2),
    Formation(name: '4-2-4', defenders: 4, midfielders: 2, forwards: 4),
    Formation(name: '3-4-3', defenders: 3, midfielders: 4, forwards: 3),
    Formation(name: '4-3-3', defenders: 4, midfielders: 3, forwards: 3),
    Formation(name: '5-3-2', defenders: 5, midfielders: 3, forwards: 2),
    Formation(name: '3-5-2', defenders: 3, midfielders: 5, forwards: 2),
    Formation(name: '5-4-1', defenders: 5, midfielders: 4, forwards: 1),
    Formation(name: '4-5-1', defenders: 4, midfielders: 5, forwards: 1),
    Formation(name: '3-6-1', defenders: 3, midfielders: 6, forwards: 1),
    Formation(name: '5-2-3', defenders: 5, midfielders: 2, forwards: 3),
  ];
}

/// Optimierungs-Typ für Aufstellung
enum OptimizationType {
  averagePoints,
  totalPoints;

  String get label {
    switch (this) {
      case OptimizationType.averagePoints:
        return 'Durchschnittspunkte';
      case OptimizationType.totalPoints:
        return 'Gesamtpunkte';
    }
  }
}
