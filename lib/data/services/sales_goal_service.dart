import 'dart:math';

import '../models/optimal_lineup_model.dart';
import '../models/player_model.dart';
import '../models/transfer_model.dart';
import 'deterministic_recommendation_service.dart';

/// Ziel der Verkaufsempfehlungen (docs/UI_MIGRATION.md, Screen 3).
enum SaleGoal {
  budgetBoost('Budget ins Plus'),
  maxProfit('Maximaler Profit'),
  keepBest('Beste Spieler behalten');

  const SaleGoal(this.label);

  /// Deutsche Bezeichnung für die Ziel-Auswahl im UI.
  final String label;
}

/// Priorität einer Verkaufsempfehlung.
enum SalePriority {
  high('Hoch'),
  medium('Mittel'),
  low('Niedrig');

  const SalePriority(this.label);

  /// Deutsche Bezeichnung für das UI.
  final String label;
}

/// Ein einzelner Verkaufsvorschlag für einen Kader-Spieler.
class SaleAdvice {
  const SaleAdvice({
    required this.playerId,
    required this.playerName,
    required this.priority,
    required this.reason,
    required this.proceeds,
    required this.score,
  });

  final String playerId;
  final String playerName;
  final SalePriority priority;
  final String reason;

  /// Erwarteter Erlös (Marktwert + kurzfristiger Trend).
  final int proceeds;

  /// Score der zugrunde liegenden Spieleranalyse (0-100).
  final double score;
}

/// Ergebnis der zielbasierten Verkaufsanalyse.
class SalesGoalOutcome {
  const SalesGoalOutcome({required this.sales, this.info});

  /// Verkaufsvorschläge in empfohlener Reihenfolge ("als Erstes verkaufen").
  final List<SaleAdvice> sales;

  /// Optionaler Hinweis (z. B. bei fehlender Budget-Lücke).
  final String? info;

  /// Summe der erwarteten Erlöse aller Vorschläge.
  int get totalProceeds => sales.fold(0, (sum, sale) => sum + sale.proceeds);
}

/// Zielbasierte Verkaufsempfehlungen ohne Markt-Ersatzspieler.
///
/// Die Bewertung jedes Spielers kommt unverändert aus dem
/// [DeterministicRecommendationService] (Score/Action); hier wird nur je Ziel
/// entschieden, WER verkauft werden soll, in welcher Reihenfolge und mit
/// welcher Priorität.
class SalesGoalService {
  const SalesGoalService();

  static const Map<int, String> _positionNames = {
    1: 'Torwart',
    2: 'Abwehr',
    3: 'Mittelfeld',
    4: 'Sturm',
  };

  /// Berechnet die Verkaufsvorschläge für das gewählte [goal].
  SalesGoalOutcome rankForGoal({
    required SaleGoal goal,
    required List<Player> squad,
    required List<Recommendation> recommendations,
    required int budget,
    List<Formation>? formations,
  }) {
    final lineupFormations = formations ?? Formation.allFormations;
    final recByPlayerId = {
      for (final rec in recommendations) rec.playerId: rec,
    };
    switch (goal) {
      case SaleGoal.budgetBoost:
        return _budgetBoost(squad, recByPlayerId, budget, lineupFormations);
      case SaleGoal.maxProfit:
        return _maxProfit(squad, recByPlayerId, lineupFormations);
      case SaleGoal.keepBest:
        return _keepBest(squad, recByPlayerId, lineupFormations);
    }
  }

  /// "Budget ins Plus": kritische Spieler zuerst, danach die schwächsten
  /// Spieler – die Besten bleiben im Kader. Es werden nur so viele Verkäufe
  /// empfohlen, bis die Budget-Lücke gedeckt ist. Die Priorität folgt der
  /// jeweils verbleibenden Lücke. Spieler, die für die Startelf gebraucht
  /// werden, gehen nie über die Kante.
  SalesGoalOutcome _budgetBoost(
    List<Player> squad,
    Map<String, Recommendation> recs,
    int budget,
    List<Formation> formations,
  ) {
    if (budget >= 0) {
      return const SalesGoalOutcome(
        sales: [],
        info: 'Budget ist bereits im Plus – keine Verkäufe nötig.',
      );
    }

    final sellable = _sellableIds(squad, recs, formations);
    final ranked = _sortBySellOrder(squad, recs);

    final gap = -budget;
    var accumulated = 0;
    final sales = <SaleAdvice>[];
    for (final player in ranked) {
      if (!sellable.contains(player.id)) continue;
      final critical = _isCritical(player);
      final proceeds = _proceeds(player, recs[player.id]);
      final remaining = gap - accumulated;
      final priority = critical
          ? SalePriority.high
          : remaining <= 0
          ? SalePriority.low
          : proceeds >= remaining
          ? SalePriority.high
          : proceeds * 2 >= remaining
          ? SalePriority.medium
          : SalePriority.low;
      accumulated += proceeds;
      sales.add(
        _advice(
          player: player,
          rec: recs[player.id],
          priority: priority,
          reason: critical
              ? 'Verfügbarkeitsrisiko – zuerst verkaufen.'
              : 'Deckt die Budget-Lücke.',
        ),
      );
      // Nur so viele Verkäufe wie nötig – die Besten bleiben im Kader.
      if (accumulated >= gap) break;
    }
    if (accumulated < gap) {
      return SalesGoalOutcome(
        sales: sales,
        info:
            'Die Budget-Lücke ist mit den möglichen Verkäufen nicht '
            'vollständig gedeckt (Mindestantiefe pro Position).',
      );
    }
    return SalesGoalOutcome(sales: sales);
  }

  /// "Maximaler Profit": Verkaufskandidaten mit dem größten Erlös zuerst.
  /// Spieler der Startelf bleiben unverkäuflich.
  SalesGoalOutcome _maxProfit(
    List<Player> squad,
    Map<String, Recommendation> recs,
    List<Formation> formations,
  ) {
    final sellable = _sellableIds(squad, recs, formations);
    final candidates =
        [
          for (final player in squad)
            if (_isSellAction(recs[player.id]?.action) &&
                sellable.contains(player.id))
              player,
        ]..sort(
          (a, b) =>
              _proceeds(b, recs[b.id]).compareTo(_proceeds(a, recs[a.id])),
        );

    final sales = [
      for (final player in candidates)
        _advice(
          player: player,
          rec: recs[player.id],
          priority: (recs[player.id]?.score ?? 50) < 20
              ? SalePriority.high
              : SalePriority.medium,
          reason: 'Realisiert den größten Erlös bei schwachem Punkteschnitt.',
        ),
    ];
    return SalesGoalOutcome(sales: sales);
  }

  /// "Beste Spieler behalten": Kandidaten sind nur Spieler über der Startelf
  /// (11 + spielbare Formation) sowie kritische Spieler – sortiert nach
  /// Priorität, dann Score aufsteigend.
  SalesGoalOutcome _keepBest(
    List<Player> squad,
    Map<String, Recommendation> recs,
    List<Formation> formations,
  ) {
    double scoreOf(Player player) => recs[player.id]?.score ?? 50;

    SalePriority priorityFor(Player player) => _isCritical(player)
        ? SalePriority.high
        : scoreOf(player) < 20
        ? SalePriority.medium
        : SalePriority.low;

    final sellable = _sellableIds(squad, recs, formations);
    final sortedCandidates =
        [
          for (final player in squad)
            if (sellable.contains(player.id)) player,
        ]..sort((a, b) {
          final priority = _priorityIndex(
            priorityFor(a),
          ).compareTo(_priorityIndex(priorityFor(b)));
          if (priority != 0) return priority;
          return scoreOf(a).compareTo(scoreOf(b));
        });

    final sales = [
      for (final player in sortedCandidates)
        _advice(
          player: player,
          rec: recs[player.id],
          priority: priorityFor(player),
          reason: _isCritical(player)
              ? 'Verfügbarkeitsrisiko – besser abgeben.'
              : 'Überbestand auf ${_positionNames[player.position] ?? 'Position'} – '
                    'für den Spieltag nicht nötig.',
        ),
    ];
    return SalesGoalOutcome(sales: sales);
  }

  /// Sortiert Spieler in Verkaufsreihenfolge: kritische zuerst, dann
  /// niedrigster Score, bei Gleichstand der größere Erlös.
  List<Player> _sortBySellOrder(
    List<Player> players,
    Map<String, Recommendation> recs,
  ) => [...players]
    ..sort((a, b) {
      final critical = (_isCritical(a) ? 0 : 1).compareTo(
        _isCritical(b) ? 0 : 1,
      );
      if (critical != 0) return critical;
      final score = _score(a, recs[a.id]).compareTo(_score(b, recs[b.id]));
      if (score != 0) return score;
      return _proceeds(b, recs[b.id]).compareTo(_proceeds(a, recs[a.id]));
    });

  /// IDs der Spieler, die verkauft werden dürfen, ohne dass die Startelf
  /// auseinanderbricht: Es müssen mindestens 11 Spieler übrig bleiben und
  /// eine der [formations] aufstellbar sein (schützt u. a. den letzten
  /// Torwart und Stürmer). In Verkaufsreihenfolge gehen die Entbehrlichsten
  /// zuerst.
  Set<String> _sellableIds(
    List<Player> squad,
    Map<String, Recommendation> recs,
    List<Formation> formations,
  ) {
    final remaining = <int, int>{};
    for (final player in squad) {
      remaining[player.position] = (remaining[player.position] ?? 0) + 1;
    }
    final sellable = <String>{};
    for (final player in _sortBySellOrder(squad, recs)) {
      remaining[player.position] = remaining[player.position]! - 1;
      if (_canFieldXI(remaining, formations)) {
        sellable.add(player.id);
      } else {
        remaining[player.position] = remaining[player.position]! + 1;
      }
    }
    return sellable;
  }

  /// true, wenn mit [remaining] noch eine Startelf aufgestellt werden kann
  /// (1 Torwart + eine der Formationen). Eine leere [formations]-Liste
  /// deaktiviert die Prüfung (z. B. in Tests).
  bool _canFieldXI(Map<int, int> remaining, List<Formation> formations) {
    if (formations.isEmpty) return true;
    if ((remaining[1] ?? 0) < 1) return false;
    for (final formation in formations) {
      if ((remaining[2] ?? 0) >= formation.defenders &&
          (remaining[3] ?? 0) >= formation.midfielders &&
          (remaining[4] ?? 0) >= formation.forwards) {
        return true;
      }
    }
    return false;
  }

  SaleAdvice _advice({
    required Player player,
    required Recommendation? rec,
    required SalePriority priority,
    required String reason,
  }) {
    return SaleAdvice(
      playerId: player.id,
      playerName: '${player.firstName} ${player.lastName}'.trim(),
      priority: priority,
      reason: reason,
      proceeds: _proceeds(player, rec),
      score: rec?.score ?? 50,
    );
  }

  /// Erwarteter Erlös: Marktwert plus kurzfristiger Trend.
  int _proceeds(Player player, Recommendation? rec) =>
      rec?.estimatedValue ?? max(0, player.marketValue + player.tfhmvt);

  /// Analyse-Score des Spielers (Fallback 50 = neutral).
  double _score(Player player, Recommendation? rec) => rec?.score ?? 50;

  bool _isCritical(Player player) =>
      DeterministicRecommendationService.isUnavailable(player.status);

  bool _isSellAction(String? action) =>
      action == 'sell' || action == 'strong-sell';

  int _priorityIndex(SalePriority priority) => switch (priority) {
    SalePriority.high => 0,
    SalePriority.medium => 1,
    SalePriority.low => 2,
  };
}
