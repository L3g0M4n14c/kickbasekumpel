import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kickbasekumpel/config/router.dart';
import 'package:kickbasekumpel/data/models/performance_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/providers/budget_calculation_providers.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/providers/recommendation_providers.dart';
import 'package:kickbasekumpel/data/services/auto_sale_budget_service.dart';
import 'package:kickbasekumpel/data/services/kickbase_api_client.dart';
import 'package:kickbasekumpel/data/services/sales_goal_service.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/presentation/widgets/charts/position_badge.dart';
import 'package:kickbasekumpel/presentation/widgets/team/team_budget_header.dart';
import 'package:kickbasekumpel/presentation/widgets/transfers/transfer_plan_formatters.dart';

/// Sortiert Empfehlungen für die Verkaufs-Ansicht: der dringendste
/// Verkaufskandidat (niedrigster Score) zuerst.
List<Recommendation> rankForSale(List<Recommendation> recommendations) =>
    [...recommendations]..sort((a, b) => a.score.compareTo(b.score));

/// true, wenn die Empfehlung zum Verkauf des Spielers rät.
bool isSaleCandidate(Recommendation recommendation) =>
    recommendation.action == 'sell' || recommendation.action == 'strong-sell';

/// Verkaufen-Screen: analysiert den eigenen Kader und zeigt, welchen Spieler
/// es sich am ehesten lohnt zu verkaufen – mit Begründung.
///
/// Die Analyse läuft deterministisch über den
/// [generateRecommendationsNotifierProvider] (Form, Effizienz, Verfügbarkeit,
/// Spielplan, Marktwert-Trend) und wird beim Öffnen sowie per Pull-to-Refresh
/// neu berechnet.
class SalesRecommendationPage extends ConsumerStatefulWidget {
  const SalesRecommendationPage({super.key});

  @override
  ConsumerState<SalesRecommendationPage> createState() =>
      _SalesRecommendationPageState();
}

class _SalesRecommendationPageState
    extends ConsumerState<SalesRecommendationPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_analyze);
  }

  Future<void> _analyze() async {
    final leagueId = ref.read(selectedLeagueIdProvider);
    if (leagueId == null) return;

    final squad = await ref.read(teamPlayersProvider.future);
    if (!mounted) return;

    // Der Squad-Endpunkt liefert Besitz nicht zuverlässig mit – für die
    // Verkaufsanalyse sind alle Kader-Spieler eigene Spieler.
    final ownedSquad = [
      for (final player in squad) player.copyWith(userOwnsPlayer: true),
    ];
    // Letzte Performances laden, damit die Form auf den letzten Spieltagen
    // basiert und nicht auf den Saison-Schnitt ausweicht.
    final recentPerformances = await _loadRecentPerformances(
      ref.read(kickbaseApiClientProvider),
      leagueId,
      ownedSquad,
    );
    if (!mounted) return;
    await ref
        .read(generateRecommendationsNotifierProvider.notifier)
        .generateForPlayers(
          leagueId,
          ownedSquad,
          recentPerformances: recentPerformances,
        );
  }

  @override
  Widget build(BuildContext context) {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    final genState = ref.watch(generateRecommendationsNotifierProvider);
    final goal = ref.watch(saleGoalProvider);
    final recommendations = leagueId == null
        ? const <Recommendation>[]
        : ref.watch(recommendationsForLeagueProvider(leagueId));
    final players =
        ref.watch(teamPlayersProvider).asData?.value ?? const <Player>[];
    final playersById = {for (final player in players) player.id: player};
    final outcome = leagueId == null
        ? null
        : ref.watch(saleAdvicesProvider(leagueId)).asData?.value;
    final budget = ref.watch(teamBudgetProvider).asData?.value ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Verkaufen')),
      body: leagueId == null
          ? const Center(child: Text('Keine Liga ausgewählt.'))
          : _buildBody(
              context,
              genState: genState,
              goal: goal,
              outcome: outcome,
              recommendations: recommendations,
              playersById: playersById,
              budget: budget,
            ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required GenerateRecommendationsState genState,
    required SaleGoal goal,
    required SalesGoalOutcome? outcome,
    required List<Recommendation> recommendations,
    required Map<String, Player> playersById,
    required int budget,
  }) {
    if (genState.isGenerating) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analysiere deinen Kader …'),
          ],
        ),
      );
    }

    if (genState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(genState.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _analyze,
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    if (outcome == null || recommendations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Noch keine Analyse vorhanden.'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _analyze,
              icon: const Icon(Icons.sell_outlined),
              label: const Text('Kader analysieren'),
            ),
          ],
        ),
      );
    }

    final advisedIds = outcome.sales.map((sale) => sale.playerId).toSet();
    final keepers = rankForSale(
      recommendations
          .where((rec) => !advisedIds.contains(rec.playerId))
          .toList(),
    );

    return RefreshIndicator(
      onRefresh: _analyze,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<SaleGoal>(
            segments: [
              for (final value in SaleGoal.values)
                ButtonSegment(value: value, label: Text(value.label)),
            ],
            selected: {goal},
            showSelectedIcon: false,
            onSelectionChanged: (selection) =>
                ref.read(saleGoalProvider.notifier).set(selection.first),
          ),
          const SizedBox(height: 12),
          TeamBudgetHeader(
            currentBudget: budget,
            saleValue: outcome.totalProceeds,
          ),
          const SizedBox(height: 8),
          Text(
            'Spieler nach Verkauf: '
            '${(playersById.length - outcome.sales.length).clamp(0, playersById.length)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (outcome.info != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(outcome.info!),
              ),
            ),
            const SizedBox(height: 12),
          ] else if (outcome.sales.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Aktuell gibt es keine klaren Verkaufskandidaten – '
                  'alle Spieler sind mindestens „halten" wert.',
                ),
              ),
            ),
          if (outcome.sales.isNotEmpty) ...[
            const _SectionTitle('Verkaufsempfehlungen'),
            for (final advice in outcome.sales)
              _SaleRecommendationTile(
                advice: advice,
                player: playersById[advice.playerId],
              ),
          ],
          if (keepers.isNotEmpty) ...[
            const SizedBox(height: 8),
            ExpansionTile(
              title: Text('Behalten (${keepers.length})'),
              initiallyExpanded: outcome.sales.isEmpty,
              children: [
                for (final rec in keepers)
                  _SaleRecommendationTile(
                    recommendation: rec,
                    player: playersById[rec.playerId],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Kachel für eine Verkaufsempfehlung: Spieler, Begründung, Werte, Score.
class _SaleRecommendationTile extends StatelessWidget {
  const _SaleRecommendationTile({
    this.advice,
    this.recommendation,
    required this.player,
  });

  /// Zielbasierte Verkaufsempfehlung (Verkaufs-Liste).
  final SaleAdvice? advice;

  /// Analyse-Empfehlung (Behalten-Liste).
  final Recommendation? recommendation;
  final Player? player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = this.player;
    final advice = this.advice;
    final recommendation = this.recommendation;

    final name = advice?.playerName ?? recommendation?.playerName ?? '';
    final playerId = advice?.playerId ?? recommendation?.playerId;
    final score = advice?.score ?? recommendation?.score ?? 0.0;
    final marketValue =
        player?.marketValue ?? recommendation?.currentMarketValue ?? 0;
    final proceeds = advice?.proceeds ?? recommendation?.estimatedValue ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: player == null
            ? null
            : PositionBadge(
                position: player.position,
                size: PositionBadgeSize.small,
              ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(advice?.reason ?? recommendation?.reason ?? ''),
            const SizedBox(height: 4),
            Text(
              'Marktwert ${formatTransferCurrency(marketValue)}'
              ' · Erlös ca. ${formatTransferCurrency(proceeds)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (advice != null) ...[
              _PriorityChip(priority: advice.priority),
              const SizedBox(width: 6),
            ],
            _ScoreBadge(score: score),
          ],
        ),
        onTap: playerId == null ? null : () => context.goToPlayer(playerId),
      ),
    );
  }
}

/// Prioritäts-Badge (Hoch/Mittel/Niedrig) für Verkaufsempfehlungen.
class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final SalePriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      SalePriority.high => Colors.red,
      SalePriority.medium => Colors.orange,
      SalePriority.low => Colors.blue,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority.label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Score-Badge (0–100), eingefärbt nach Action-Schwelle des
/// DeterministicRecommendationService (20/40/60/80).
class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final color = score < 20
        ? Colors.red
        : score < 40
        ? Colors.orange
        : score < 60
        ? Colors.blue
        : score < 80
        ? Colors.green
        : Colors.green.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        score.round().toString(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Lädt die Spieltagspunkte der aktuellen Saison pro Spieler parallel und
/// toleriert Fehler einzelner Spieler (dann greift der Saison-Schnitt-
/// Fallback der Analyse).
///
/// Der Performance-Endpunkt liefert `p` als KUMULIERTE Saison-Gesamtpunktzahl
/// (siehe [AutoSaleBudgetService.crossingMatchday]), die Form-Berechnung
/// erwartet jedoch Punkte pro Spieltag – daher wird in
/// [_perMatchDayPoints] auf Differenzen umgerechnet.
Future<Map<String, List<MatchPerformance>>> _loadRecentPerformances(
  KickbaseAPIClient apiClient,
  String leagueId,
  List<Player> players,
) async {
  final budgetService = AutoSaleBudgetService();
  final entries = await Future.wait(
    players.map((player) async {
      try {
        final stats = await apiClient.getPlayerStats(leagueId, player.id);
        final season = budgetService.currentSeasonPerformance(
          stats,
          seasonStart: kLeagueSeasonStartDate,
        );
        return MapEntry(player.id, _perMatchDayPoints(season?.ph ?? const []));
      } catch (_) {
        return MapEntry(player.id, const <MatchPerformance>[]);
      }
    }),
  );
  return {for (final entry in entries) entry.key: entry.value};
}

/// Rechnet kumulierte Saisonpunkte ([ph]) in Punkte pro Spieltag um.
///
/// ponytail: Setzt voraus, dass [ph] die komplette Saison ab dem ersten
/// Spieltag umfasst (erster Wert = Punkte des ersten Spieltags).
/// Upgrade-Pfad, falls die API je nur Ausschnitte liefert: Startwert aus dem
/// Saisonstart rekonstruieren.
List<MatchPerformance> _perMatchDayPoints(List<MatchPerformance> ph) {
  final sorted = [...ph]..sort((a, b) => a.day.compareTo(b.day));
  final result = <MatchPerformance>[];
  var previous = 0;
  for (final match in sorted) {
    final cumulative = match.p;
    if (cumulative == null) continue;
    result.add(match.copyWith(p: cumulative - previous));
    previous = cumulative;
  }
  return result;
}
