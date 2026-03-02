import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/player_detail_providers.dart';
import '../../../data/providers/competition_providers.dart';
import '../../../data/providers/league_detail_providers.dart';
import '../../../data/models/player_model.dart';
import '../../../data/models/performance_model.dart';
import '../../../data/utils/parsing_utils.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/charts/performance_line_chart.dart';
import '../../widgets/charts/price_chart.dart';

/// Player Detail Screen
///
/// Zeigt detaillierte Informationen zu einem Spieler an.
class PlayerDetailScreen extends ConsumerStatefulWidget {
  final String playerId;
  final String leagueId;

  const PlayerDetailScreen({
    required this.playerId,
    required this.leagueId,
    super.key,
  });

  @override
  ConsumerState<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends ConsumerState<PlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final playerAsync = ref.watch(
      playerDetailsProvider((
        leagueId: widget.leagueId,
        playerId: widget.playerId,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spieler Details'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Übersicht', icon: Icon(Icons.info_outline)),
            Tab(text: 'Performance', icon: Icon(Icons.bar_chart)),
            Tab(text: 'Marktwert', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: playerAsync.when(
        data: (playerData) {
          final player = _parsePlayer(playerData);

          // mvgl = Marktwertsteigerung/-verlust seit Kauf (aus Squad-Endpoint)
          final squadAsync = ref.watch(mySquadProvider(widget.leagueId));
          final mvgl = squadAsync.maybeWhen(
            data: (squadData) {
              final items = squadData['it'] as List? ?? [];
              for (final item in items) {
                final itemId = (item['i'] ?? item['id'] ?? '').toString();
                if (itemId == widget.playerId) {
                  final raw = item['mvgl'];
                  if (raw == null) return null;
                  if (raw is int) return raw;
                  if (raw is double) return raw.toInt();
                  return int.tryParse(raw.toString());
                }
              }
              return null;
            },
            orElse: () => null,
          );

          return TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(
                player: player,
                isTablet: isTablet,
                marketValueGainLoss: mvgl,
              ),
              _PerformanceTab(
                leagueId: widget.leagueId,
                playerId: widget.playerId,
                teamId: player.teamId,
                isTablet: isTablet,
              ),
              _MarketValueTab(
                leagueId: widget.leagueId,
                playerId: widget.playerId,
                isTablet: isTablet,
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            playerDetailsProvider((
              leagueId: widget.leagueId,
              playerId: widget.playerId,
            )),
          ),
        ),
      ),
    );
  }

  /// Normalisiert die rohen API-Daten zu einem [Player]-Objekt.
  ///
  /// Verwendet [normalizePlayerJson] aus parsing_utils.dart, das alle
  /// Kickbase-Kurznamen (ap, tp, mv, mvt, pos, shn, tid, st, …)
  /// auf die Model-Felder mappt.
  Player _parsePlayer(Map<String, dynamic> data) {
    final normalized = normalizePlayerJson(data);
    return Player.fromJson(normalized);
  }
}

class _OverviewTab extends StatelessWidget {
  final Player player;
  final bool isTablet;

  /// Marktwertsteigerung/-verlust seit Kauf des Spielers (aus mvgl-Variable).
  /// Null, wenn der Spieler nicht im eigenen Kader ist oder die Daten fehlen.
  final int? marketValueGainLoss;

  const _OverviewTab({
    required this.player,
    required this.isTablet,
    this.marketValueGainLoss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      children: [
        // Player Header Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: player.profileBigUrl.isNotEmpty
                      ? NetworkImage(player.profileBigUrl)
                      : null,
                  child: player.profileBigUrl.isEmpty
                      ? const Icon(Icons.person, size: 64)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  '${player.firstName} ${player.lastName}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  player.teamName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Chip(
                  label: Text(_getPositionName(player.position)),
                  backgroundColor: _getPositionColor(player.position),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Market Value Card
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Marktwert',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(player.marketValue / 1000000).toStringAsFixed(2)} M €',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                // Trend (tägliche Änderung)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      player.marketValueTrend > 0
                          ? Icons.trending_up
                          : player.marketValueTrend < 0
                          ? Icons.trending_down
                          : Icons.remove,
                      color: player.marketValueTrend > 0
                          ? Colors.green
                          : player.marketValueTrend < 0
                          ? Colors.red
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${player.marketValueTrend > 0 ? '+' : ''}${(player.marketValueTrend / 1000).toStringAsFixed(0)}k',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: player.marketValueTrend > 0
                            ? Colors.green
                            : player.marketValueTrend < 0
                            ? Colors.red
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Gewinn/Verlust seit Kauf
                if (marketValueGainLoss != null)
                  ..._buildGainLossRow(marketValueGainLoss!, theme),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Stats Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard(
              icon: Icons.stars,
              label: 'Ø Punkte',
              value: player.averagePoints.toStringAsFixed(1),
              color: Colors.amber,
            ),
            _StatCard(
              icon: Icons.event,
              label: 'Gesamtpunkte',
              value: '${player.totalPoints}',
              color: Colors.blue,
            ),
            _StatCard(
              icon: Icons.confirmation_number,
              label: 'Trikotnummer',
              value: '${player.number}',
              color: Colors.green,
            ),
            _StatCard(
              icon: Icons.health_and_safety,
              label: 'Status',
              value: _getStatusName(player.status),
              color: _getStatusColor(player.status),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Ownership Status
        if (player.userOwnsPlayer)
          Card(
            color: Colors.green.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Du besitzt diesen Spieler',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Baut die Zeile für Gewinn/Verlust seit Kauf.
  List<Widget> _buildGainLossRow(int gainLoss, ThemeData theme) {
    final isGain = gainLoss >= 0;
    final color = gainLoss > 0
        ? Colors.green
        : gainLoss < 0
        ? Colors.red
        : Colors.grey;
    final sign = isGain ? '+' : '';
    final formatted = gainLoss.abs() >= 1000000
        ? '$sign${(gainLoss / 1000000).toStringAsFixed(2)} M €'
        : '$sign${(gainLoss / 1000).toStringAsFixed(0)} K €';
    return [
      const SizedBox(height: 8),
      const Divider(height: 1, color: Colors.white24),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            gainLoss > 0
                ? Icons.arrow_upward
                : gainLoss < 0
                ? Icons.arrow_downward
                : Icons.remove,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            formatted,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'seit Kauf',
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    ];
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.yellow.shade700;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPositionName(int position) {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusName(int status) {
    switch (status) {
      case 0:
        return 'Fit';
      case 1:
        return 'Fraglich';
      case 2:
        return 'Verletzt';
      default:
        return 'Unbekannt';
    }
  }
}

// ============================================================================
// Hilfsdaten für die Tabellen-Zuordnung
// ============================================================================

/// Tabellenplatz und Name eines Teams, extrahiert aus der Wettbewerbstabelle.
class _TableEntry {
  final String name;
  final int placement;
  const _TableEntry({required this.name, required this.placement});
}

/// Baut einen Index {teamId/teamName → _TableEntry} aus den rohen API-Daten
/// der Bundesliga-Tabelle. Unterstützt verschiedene Feldnamen-Varianten.
Map<String, _TableEntry> _buildTeamIndex(Map<String, dynamic> tableData) {
  List teams = [];
  // Per API-Spec: tableData['value']['it']
  final value = tableData['value'];
  if (value is Map) teams = value['it'] as List? ?? [];
  // Fallback-Varianten, die aus dem Live-Betrieb bekannt sind
  if (teams.isEmpty) {
    teams =
        tableData['it'] as List? ??
        tableData['t'] as List? ??
        tableData['teams'] as List? ??
        [];
  }
  final index = <String, _TableEntry>{};
  for (var i = 0; i < teams.length; i++) {
    final team = teams[i] as Map<String, dynamic>;
    final tid = (team['tid'] ?? team['id'] ?? '').toString();
    final tname = (team['tn'] ?? team['n'] ?? team['name'] ?? '').toString();
    // 'cpl' = current placement (Tabellenplatz)
    // 'cp'  = competition points (Punkte) – NICHT der Platz!
    // Fallback: Index i+1, da die API-Liste bereits nach Platz sortiert ist.
    final rawPlacement = team['cpl'];
    final placement =
        (rawPlacement != null && _parseTableInt(rawPlacement, 0) > 0)
        ? _parseTableInt(rawPlacement, i + 1)
        : i + 1;
    if (tid.isNotEmpty) {
      index[tid] = _TableEntry(name: tname, placement: placement);
    }
    // Zusätzlich Name als Key – Fallback, falls t1/t2 Kurzname statt ID
    if (tname.isNotEmpty && !index.containsKey(tname)) {
      index[tname] = _TableEntry(name: tname, placement: placement);
    }
  }
  return index;
}

int _parseTableInt(dynamic v, int fallback) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString()) ?? fallback;
}

// ============================================================================
// Performance-Tab
// ============================================================================

class _PerformanceTab extends ConsumerWidget {
  final String leagueId;
  final String playerId;

  /// Team-ID des Spielers (für Heim/Auswärts-Erkennung).
  final String teamId;
  final bool isTablet;

  const _PerformanceTab({
    required this.leagueId,
    required this.playerId,
    required this.teamId,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(
      playerPerformanceProvider((leagueId: leagueId, playerId: playerId)),
    );
    // Bundesliga-Tabelle für Tabellenplätze (competitionId = "1")
    final tableAsync = ref.watch(bundesligaTableProvider);

    return performanceAsync.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            playerPerformanceProvider((leagueId: leagueId, playerId: playerId)),
          ),
        ),
      ),
      data: (performanceData) {
        if (performanceData.it.isEmpty) {
          return const Center(child: Text('Keine Performance-Daten verfügbar'));
        }

        // Tabellen-Index (best-effort)
        final tableIndex = tableAsync.maybeWhen(
          data: (td) => _buildTeamIndex(td),
          orElse: () => <String, _TableEntry>{},
        );

        // Aktuelle Saison ermitteln:
        // 1. Saison, die einen Spieltag mit cur == true enthält (laufender Spieltag)
        // 2. Saison, in der zukünftige Spiele (noch kein Ergebnis) vorkommen
        // 3. Fallback: letzte Saison in der Liste (neueste)
        final currentSeason = performanceData.it.firstWhere(
          (s) => s.ph.any((m) => m.cur),
          orElse: () => performanceData.it.firstWhere(
            (s) => s.ph.any((m) => m.t1g == null && m.p == null),
            orElse: () => performanceData.it.last,
          ),
        );
        final allMatches = currentSeason.ph;

        // Gespielte Spiele: Ergebnis vorhanden (t1g != null) ODER Punkte vorhanden
        final played = allMatches
            .where((m) => m.t1g != null || m.p != null)
            .toList();

        // Zukünftige Spiele: noch kein Ergebnis und keine Punkte
        final upcoming = allMatches
            .where((m) => m.t1g == null && m.p == null)
            .toList();

        // Chart-Datenpunkte (nur wo Punkte vorhanden)
        final chartPoints = played
            .where((m) => m.p != null)
            .map(
              (m) => PerformancePoint(matchDay: m.day, points: m.p!.toDouble()),
            )
            .toList();

        final last5 = played.length > 5
            ? played.sublist(played.length - 5)
            : played;
        final next3 = upcoming.length > 3 ? upcoming.sublist(0, 3) : upcoming;

        return ListView(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          children: [
            if (chartPoints.isNotEmpty) ...[
              Text(
                'Leistungsverlauf',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              PerformanceLineChart(
                data: chartPoints,
                title: 'Punkte pro Spieltag',
                height: 260,
              ),
              const SizedBox(height: 24),
            ],
            if (last5.isNotEmpty) ...[
              _LastGamesCard(
                matches: last5,
                playerTeamId: teamId,
                tableIndex: tableIndex,
              ),
              const SizedBox(height: 16),
            ],
            if (next3.isNotEmpty)
              _UpcomingGamesCard(
                matches: next3,
                playerTeamId: teamId,
                tableIndex: tableIndex,
              ),
            if (chartPoints.isEmpty && last5.isEmpty && next3.isEmpty)
              const Center(child: Text('Keine Performance-Daten verfügbar')),
          ],
        );
      },
    );
  }
}

// ============================================================================
// Letzte 5 Spiele
// ============================================================================

class _LastGamesCard extends StatelessWidget {
  final List<MatchPerformance> matches;
  final String playerTeamId;
  final Map<String, _TableEntry> tableIndex;

  const _LastGamesCard({
    required this.matches,
    required this.playerTeamId,
    required this.tableIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Letzte 5 Spiele',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            // Neueste zuerst
            ...matches.reversed.map(
              (m) => _MatchRow(
                match: m,
                playerTeamId: playerTeamId,
                tableIndex: tableIndex,
                isUpcoming: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Nächste 3 Spiele
// ============================================================================

class _UpcomingGamesCard extends StatelessWidget {
  final List<MatchPerformance> matches;
  final String playerTeamId;
  final Map<String, _TableEntry> tableIndex;

  const _UpcomingGamesCard({
    required this.matches,
    required this.playerTeamId,
    required this.tableIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_available, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Nächste 3 Spiele',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            ...matches.map(
              (m) => _MatchRow(
                match: m,
                playerTeamId: playerTeamId,
                tableIndex: tableIndex,
                isUpcoming: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Einzelne Spielzeile (vergangenes & zukünftiges Spiel)
// ============================================================================

class _MatchRow extends StatelessWidget {
  final MatchPerformance match;
  final String playerTeamId;
  final Map<String, _TableEntry> tableIndex;
  final bool isUpcoming;

  const _MatchRow({
    required this.match,
    required this.playerTeamId,
    required this.tableIndex,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final t1Entry = tableIndex[match.t1];
    final t2Entry = tableIndex[match.t2];

    final t1Name = t1Entry?.name.isNotEmpty == true ? t1Entry!.name : match.t1;
    final t2Name = t2Entry?.name.isNotEmpty == true ? t2Entry!.name : match.t2;

    // Spielerteam-Erkennung: vergleiche per ID und per aufgelöstem Namen
    final isPlayerT1 =
        playerTeamId.isNotEmpty &&
        (match.t1 == playerTeamId ||
            (t1Entry != null && t1Entry.name == playerTeamId));

    // Ergebnis aus Spieler-Perspektive
    String scoreText = '';
    Color? resultColor;
    String resultBadge = '';
    if (match.t1g != null && match.t2g != null) {
      scoreText = '${match.t1g}:${match.t2g}';
      final playerGoals = isPlayerT1 ? match.t1g! : match.t2g!;
      final opponentGoals = isPlayerT1 ? match.t2g! : match.t1g!;
      if (playerGoals > opponentGoals) {
        resultColor = Colors.green;
        resultBadge = 'S';
      } else if (playerGoals < opponentGoals) {
        resultColor = Colors.red;
        resultBadge = 'N';
      } else {
        resultColor = Colors.orange;
        resultBadge = 'U';
      }
    }

    final points = match.p;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        children: [
          // Spieltags-Nummer
          SizedBox(
            width: 36,
            child: Column(
              children: [
                Text(
                  'ST',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${match.day}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Mannschaftsanzeige (beide Teams mit Tabellenplatz)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _TeamNameRow(
                  name: t1Name,
                  placement: t1Entry?.placement,
                  highlight: isPlayerT1,
                  theme: theme,
                ),
                const SizedBox(height: 1),
                _TeamNameRow(
                  name: t2Name,
                  placement: t2Entry?.placement,
                  highlight: !isPlayerT1 && playerTeamId.isNotEmpty,
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Ergebnis / Datum
          if (!isUpcoming && scoreText.isNotEmpty)
            _ResultBadge(
              score: scoreText,
              badge: resultBadge,
              color: resultColor ?? Colors.grey,
              theme: theme,
            )
          else if (isUpcoming)
            Text(
              _fmtDate(match.md),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.right,
            ),
          const SizedBox(width: 8),
          // Punkte (nur bei vergangenen Spielen)
          if (!isUpcoming)
            SizedBox(
              width: 50,
              child: points != null
                  ? Text(
                      '$points Pkt',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _ptsColor(points),
                      ),
                      textAlign: TextAlign.right,
                    )
                  : Text(
                      '-',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.right,
                    ),
            ),
        ],
      ),
    );
  }

  String _fmtDate(String md) {
    try {
      final dt = DateTime.parse(md).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.';
    } catch (_) {
      return md.length >= 10 ? md.substring(5, 10).replaceAll('-', '.') : md;
    }
  }

  Color _ptsColor(int pts) {
    if (pts >= 20) return Colors.green;
    if (pts >= 11) return Colors.lightGreen;
    if (pts >= 6) return Colors.orange;
    return Colors.red;
  }
}

class _TeamNameRow extends StatelessWidget {
  final String name;
  final int? placement;
  final bool highlight;
  final ThemeData theme;

  const _TeamNameRow({
    required this.name,
    this.placement,
    required this.highlight,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (placement != null) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: _plColor(placement!).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _plColor(placement!).withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              '$placement.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _plColor(placement!),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _plColor(int p) {
    if (p <= 4) return Colors.green;
    if (p <= 6) return Colors.blue;
    if (p >= 16) return Colors.red;
    return Colors.grey;
  }
}

class _ResultBadge extends StatelessWidget {
  final String score;
  final String badge;
  final Color color;
  final ThemeData theme;

  const _ResultBadge({
    required this.score,
    required this.badge,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            score,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        if (badge.isNotEmpty)
          Text(
            badge,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
      ],
    );
  }
}

/// Verfügbare Zeitraum-Optionen für den Marktwert-Tab.
enum _MarketValueRange {
  week(7, '7T'),
  month(30, '30T'),
  threeMonths(90, '90T'),
  year(365, '1J');

  const _MarketValueRange(this.days, this.label);

  /// Anzahl der Tage die der Zeitraum umfasst.
  final int days;

  /// Beschriftung des Chips.
  final String label;
}

class _MarketValueTab extends ConsumerStatefulWidget {
  final String leagueId;
  final String playerId;
  final bool isTablet;

  const _MarketValueTab({
    required this.leagueId,
    required this.playerId,
    required this.isTablet,
  });

  @override
  ConsumerState<_MarketValueTab> createState() => _MarketValueTabState();
}

class _MarketValueTabState extends ConsumerState<_MarketValueTab> {
  /// Aktuell ausgewählter Zeitraum (Standard: 1 Jahr).
  _MarketValueRange _selectedRange = _MarketValueRange.year;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final marketValueAsync = ref.watch(
      playerMarketValueYearProvider((
        leagueId: widget.leagueId,
        playerId: widget.playerId,
      )),
    );

    return marketValueAsync.when(
      data: (data) {
        // Die Kickbase API liefert die Verlaufsliste unter 'it',
        // jeder Eintrag hat 'd' (Datum) und 'm' (Marktwert als Zahl).
        // 'mv' im selben Response ist der aktuelle Einzelwert, keine Liste.
        final rawList =
            data['it'] as List? ??
            data['mv'] as List? ??
            data['values'] as List? ??
            [];
        final allMarketValues = rawList
            .map((item) {
              final rawDt = item['dt'];
              final rawMv = item['mv'];
              if (rawDt == null || rawMv == null) return null;
              // 'dt' = Tage seit 1.1.1970
              final days = rawDt is int ? rawDt : (rawDt as num).toInt();
              final price = rawMv is int ? rawMv : (rawMv as num).toInt();
              return PricePoint(
                date: DateTime.utc(1970).add(Duration(days: days)),
                price: price,
              );
            })
            .whereType<PricePoint>()
            .toList();

        if (allMarketValues.isEmpty) {
          // Debug: Keys im Response ausgeben damit man sehen kann was die API liefert
          assert(() {
            debugPrint('⚠️ Marktwert-Response Keys: ${data.keys.toList()}');
            if (rawList.isNotEmpty) {
              debugPrint('⚠️ Marktwert-Response erstes Item: ${rawList.first}');
            }
            return true;
          }());
          return Center(
            child: Text(
              'Keine Marktwert-Daten verfügbar',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        // Daten auf den ausgewählten Zeitraum einschränken.
        final cutoff = DateTime.now().subtract(
          Duration(days: _selectedRange.days),
        );
        final marketValues = allMarketValues
            .where((p) => p.date.isAfter(cutoff))
            .toList();

        // Falls im gewählten Zeitraum keine Datenpunkte vorhanden, alle anzeigen.
        final displayValues = marketValues.isNotEmpty
            ? marketValues
            : allMarketValues;

        return ListView(
          padding: EdgeInsets.all(widget.isTablet ? 24.0 : 16.0),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Marktwert-Entwicklung',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _TimeRangeSelector(
              selected: _selectedRange,
              onSelected: (range) => setState(() => _selectedRange = range),
            ),
            const SizedBox(height: 16),
            PriceChart(
              data: displayValues,
              title: 'Marktwert (${_selectedRange.label})',
              height: 300,
            ),
            const SizedBox(height: 24),
            _buildMarketValueStats(context, displayValues),
          ],
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Text(
          'Fehler beim Laden der Marktwert-Daten',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildMarketValueStats(BuildContext context, List<PricePoint> data) {
    final theme = Theme.of(context);

    if (data.isEmpty) return const SizedBox.shrink();

    final currentValue = data.last.price;
    final oldestValue = data.first.price;
    final change = currentValue - oldestValue;
    final changePercent = (change / oldestValue * 100);
    final maxValue = data.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((p) => p.price).reduce((a, b) => a < b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiken (${_selectedRange.label})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Aktueller Wert',
              value: _formatCurrency(currentValue),
              icon: Icons.attach_money,
            ),
            const Divider(),
            _StatRow(
              label: 'Veränderung',
              value:
                  '${change > 0 ? '+' : ''}${_formatCurrency(change)} (${changePercent.toStringAsFixed(1)}%)',
              icon: Icons.trending_up,
              valueColor: change > 0
                  ? Colors.green
                  : change < 0
                  ? Colors.red
                  : null,
            ),
            const Divider(),
            _StatRow(
              label: 'Maximum',
              value: _formatCurrency(maxValue),
              icon: Icons.arrow_upward,
            ),
            const Divider(),
            _StatRow(
              label: 'Minimum',
              value: _formatCurrency(minValue),
              icon: Icons.arrow_downward,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)} M €';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} K €';
    }
    return '$value €';
  }
}

/// Zeitraum-Auswahl als Chip-Leiste für den Marktwert-Tab.
class _TimeRangeSelector extends StatelessWidget {
  /// Aktuell ausgewählter Zeitraum.
  final _MarketValueRange selected;

  /// Callback wenn ein Zeitraum ausgewählt wird.
  final ValueChanged<_MarketValueRange> onSelected;

  const _TimeRangeSelector({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: _MarketValueRange.values.map((range) {
          final isSelected = range == selected;
          return ChoiceChip(
            label: Text(range.label),
            selected: isSelected,
            selectedColor: colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (_) => onSelected(range),
          );
        }).toList(),
      ),
    );
  }
}

// ignore: unused_element
class _StatsTab extends StatelessWidget {
  final Player player;
  final bool isTablet;

  const _StatsTab({required this.player, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      children: [
        Text(
          'Weitere Informationen',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _StatRow(
                  label: 'Verein',
                  value: player.teamName,
                  icon: Icons.shield,
                ),
                const Divider(),
                _StatRow(
                  label: 'Position',
                  value: _getPositionName(player.position),
                  icon: Icons.sports,
                ),
                const Divider(),
                _StatRow(
                  label: 'Trikotnummer',
                  value: '${player.number}',
                  icon: Icons.confirmation_number,
                ),
                const Divider(),
                _StatRow(
                  label: 'Durchschnittspunkte',
                  value: player.averagePoints.toStringAsFixed(2),
                  icon: Icons.stars,
                ),
                const Divider(),
                _StatRow(
                  label: 'Gesamtpunkte',
                  value: '${player.totalPoints}',
                  icon: Icons.event,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getPositionName(int position) {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
