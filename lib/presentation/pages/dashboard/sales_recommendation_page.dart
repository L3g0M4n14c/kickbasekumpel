import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kickbasekumpel/config/router.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/providers/recommendation_providers.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/presentation/widgets/charts/position_badge.dart';
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
    await ref
        .read(generateRecommendationsNotifierProvider.notifier)
        .generateForPlayers(leagueId, ownedSquad);
  }

  @override
  Widget build(BuildContext context) {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    final genState = ref.watch(generateRecommendationsNotifierProvider);
    final recommendations = leagueId == null
        ? const <Recommendation>[]
        : ref.watch(recommendationsForLeagueProvider(leagueId));
    final players =
        ref.watch(teamPlayersProvider).asData?.value ?? const <Player>[];
    final playersById = {for (final player in players) player.id: player};

    return Scaffold(
      appBar: AppBar(title: const Text('Verkaufen')),
      body: leagueId == null
          ? const Center(child: Text('Keine Liga ausgewählt.'))
          : _buildBody(context, genState, recommendations, playersById),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GenerateRecommendationsState genState,
    List<Recommendation> recommendations,
    Map<String, Player> playersById,
  ) {
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

    if (recommendations.isEmpty) {
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

    final ranked = rankForSale(recommendations);
    final candidates = ranked.where(isSaleCandidate).toList();
    final keepers = ranked.where((rec) => !isSaleCandidate(rec)).toList();

    return RefreshIndicator(
      onRefresh: _analyze,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (candidates.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Aktuell gibt es keine klaren Verkaufskandidaten – '
                  'alle Spieler sind mindestens „halten" wert.',
                ),
              ),
            )
          else ...[
            const _SectionTitle('Verkaufskandidaten'),
            for (final rec in candidates)
              _SaleRecommendationTile(
                recommendation: rec,
                player: playersById[rec.playerId],
              ),
          ],
          if (keepers.isNotEmpty) ...[
            const SizedBox(height: 8),
            ExpansionTile(
              title: Text('Behalten (${keepers.length})'),
              initiallyExpanded: candidates.isEmpty,
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
  const _SaleRecommendationTile({required this.recommendation, this.player});

  final Recommendation recommendation;
  final Player? player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = this.player;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: player == null
            ? null
            : PositionBadge(
                position: player.position,
                size: PositionBadgeSize.small,
              ),
        title: Text(recommendation.playerName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recommendation.reason),
            const SizedBox(height: 4),
            Text(
              'Marktwert ${formatTransferCurrency(recommendation.currentMarketValue)}'
              ' · Erlös ca. ${formatTransferCurrency(recommendation.estimatedValue)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        trailing: _ScoreBadge(score: recommendation.score),
        onTap: () => context.goToPlayer(recommendation.playerId),
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
