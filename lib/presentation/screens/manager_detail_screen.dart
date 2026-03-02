import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/providers.dart';
import '../../data/utils/parsing_utils.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class ManagerDetailScreen extends ConsumerStatefulWidget {
  final String leagueId;
  final String userId;
  final int? matchDay;

  const ManagerDetailScreen({
    required this.leagueId,
    required this.userId,
    this.matchDay,
    super.key,
  });

  @override
  ConsumerState<ManagerDetailScreen> createState() =>
      _ManagerDetailScreenState();
}

class _ManagerDetailScreenState extends ConsumerState<ManagerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(
      managerDashboardProvider((
        leagueId: widget.leagueId,
        userId: widget.userId,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard/table');
            }
          },
        ),
        title: const Text('Manager-Profil'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Kader', icon: Icon(Icons.people)),
            Tab(text: 'Performance', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: dashboardAsync.when(
        data: (dashboardData) {
          return Column(
            children: [
              _buildManagerHeader(context, dashboardData),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSquadTab(context),
                    _buildPerformanceTab(context),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(
              managerDashboardProvider((
                leagueId: widget.leagueId,
                userId: widget.userId,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManagerHeader(
    BuildContext context,
    Map<String, dynamic> dashboardData,
  ) {
    final name =
        dashboardData['userName'] ?? dashboardData['name'] ?? 'Unbekannt';
    final teamValue = dashboardData['teamValue'] ?? dashboardData['tv'] ?? 0;
    final budget = dashboardData['budget'] ?? dashboardData['b'] ?? 0;
    final points = dashboardData['points'] ?? dashboardData['p'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                context,
                'Teamwert',
                '${(teamValue / 1000000).toStringAsFixed(2)}M€',
                Icons.workspace_premium,
              ),
              _buildStatCard(
                context,
                'Budget',
                '${(budget / 1000000).toStringAsFixed(2)}M€',
                Icons.account_balance_wallet,
              ),
              _buildStatCard(context, 'Punkte', '$points', Icons.emoji_events),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSquadTab(BuildContext context) {
    // Bei Spieltag zeigen wir nur die Startelf, ansonsten den ganzen Kader
    if (widget.matchDay != null) {
      return _buildMatchDayStartingEleven(context);
    }

    final squadAsync = ref.watch(
      managerSquadProvider((leagueId: widget.leagueId, userId: widget.userId)),
    );

    return squadAsync.when(
      data: (squadData) {
        // API liefert Spielerliste unter 'it'
        final players =
            squadData['it'] as List? ?? squadData['p'] as List? ?? [];

        if (players.isEmpty) {
          return const Center(child: Text('Keine Spieler im Kader'));
        }

        // Nach Position sortieren: 1=TW, 2=ABW, 3=MF, 4=ST
        final sorted = List<dynamic>.from(players)
          ..sort(
            (a, b) => _positionOrder(
              a['pos'] ?? a['position'] ?? 0,
            ).compareTo(_positionOrder(b['pos'] ?? b['position'] ?? 0)),
          );

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final player = sorted[index];
            return _buildPlayerCard(context, player);
          },
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerSquadProvider((
              leagueId: widget.leagueId,
              userId: widget.userId,
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchDayStartingEleven(BuildContext context) {
    // Kader des Managers laden (aktueller Stand)
    final squadAsync = ref.watch(
      managerSquadProvider((leagueId: widget.leagueId, userId: widget.userId)),
    );

    // Rangliste mit Spieltag laden → enthält 'lp' (Startelf-IDs für den Spieltag)
    final rankingAsync = ref.watch(
      leagueRankingProvider((
        leagueId: widget.leagueId,
        matchDay: widget.matchDay,
      )),
    );

    return squadAsync.when(
      data: (squadData) {
        // API liefert Spielerliste unter 'it'
        final players =
            squadData['it'] as List? ?? squadData['p'] as List? ?? [];

        if (players.isEmpty) {
          return const Center(child: Text('Keine Spieler im Kader'));
        }

        // Startelf-IDs aus der Rangliste ermitteln
        return rankingAsync.when(
          data: (rankingData) {
            final users = (rankingData['us'] as List? ?? [])
                .whereType<Map<String, dynamic>>()
                .toList();

            final currentUser = users.firstWhere(
              (u) => u['i'] == widget.userId,
              orElse: () => <String, dynamic>{},
            );

            // lp = Array von numerischen Spieler-IDs (Startelf des Spieltags)
            final lineupIds = (currentUser['lp'] as List? ?? [])
                .map((id) => id.toString())
                .toSet();

            if (lineupIds.isEmpty) {
              // Kein lp-Eintrag → ganzen Kader anzeigen
              final sorted = List<dynamic>.from(players)
                ..sort(
                  (a, b) => _positionOrder(
                    a['pos'] ?? a['position'] ?? 0,
                  ).compareTo(_positionOrder(b['pos'] ?? b['position'] ?? 0)),
                );
              return _buildPlayerList(
                context,
                sorted,
                hint:
                    'Spieltag ${widget.matchDay} – Startelf nicht verfügbar, zeige aktuellen Kader',
              );
            }

            // Startelf filtern: 'pi' ist die Spieler-ID im Kader-Endpunkt
            final lineupPlayers =
                players.where((player) {
                  final playerId =
                      (player['pi'] ?? player['i'] ?? player['id'])
                          ?.toString() ??
                      '';
                  return lineupIds.contains(playerId);
                }).toList()..sort(
                  (a, b) => _positionOrder(
                    a['pos'] ?? a['position'] ?? 0,
                  ).compareTo(_positionOrder(b['pos'] ?? b['position'] ?? 0)),
                );

            if (lineupPlayers.isEmpty) {
              return Center(
                child: Text(
                  'Keine Startelf für Spieltag ${widget.matchDay} gefunden',
                ),
              );
            }

            return _buildPlayerList(context, lineupPlayers);
          },
          loading: () => const Center(child: LoadingWidget()),
          error: (error, stack) => Center(
            child: ErrorWidgetCustom(
              error: error,
              onRetry: () => ref.invalidate(
                leagueRankingProvider((
                  leagueId: widget.leagueId,
                  matchDay: widget.matchDay,
                )),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerSquadProvider((
              leagueId: widget.leagueId,
              userId: widget.userId,
            )),
          ),
        ),
      ),
    );
  }

  /// Rendert eine ListView mit den übergebenen Spielern.
  Widget _buildPlayerList(
    BuildContext context,
    List<dynamic> players, {
    String? hint,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: players.length + (hint != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (hint != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              hint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        final player = players[hint != null ? index - 1 : index];
        return _buildPlayerCard(context, player);
      },
    );
  }

  /// Reihenfolge der Positionen: TW → ABW → MF → ST
  int _positionOrder(dynamic rawPos) {
    final pos = int.tryParse(rawPos.toString()) ?? 0;
    switch (pos) {
      case 1:
        return 0; // Torwart
      case 2:
        return 1; // Abwehr
      case 3:
        return 2; // Mittelfeld
      case 4:
        return 3; // Sturm
      default:
        return 4;
    }
  }

  /// Positionsbezeichnung als Kurztext
  String _positionLabel(dynamic rawPos) {
    final pos = int.tryParse(rawPos.toString()) ?? 0;
    switch (pos) {
      case 1:
        return 'TW';
      case 2:
        return 'ABW';
      case 3:
        return 'MF';
      case 4:
        return 'ST';
      default:
        return '?';
    }
  }

  Widget _buildPlayerCard(BuildContext context, dynamic player) {
    // Normalisierung der abgekürzten API-Felder
    final normalized = normalizePlayerJson(
      Map<String, dynamic>.from(player as Map),
    );

    final firstName = normalized['firstName'] as String? ?? '';
    final lastName = normalized['lastName'] as String? ?? '';
    final name = '$firstName $lastName'.trim().isEmpty
        ? (normalized['id'] as String? ?? 'Unbekannt')
        : '$firstName $lastName'.trim();
    final posRaw = normalized['position'] ?? player['pos'] ?? 0;
    final posLabel = _positionLabel(posRaw);
    final marketValue = (normalized['marketValue'] as int?) ?? 0;
    final points = (normalized['totalPoints'] as int?) ?? 0;
    final avgPoints = (normalized['averagePoints'] as double?) ?? 0.0;

    // Positionsfarbe
    final posColor = _positionColor(context, posRaw);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: posColor.withValues(alpha: 0.2),
          child: Text(
            posLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: posColor,
            ),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Ø ${avgPoints.toStringAsFixed(1)} Pkt/Spieltag',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(marketValue / 1_000_000).toStringAsFixed(1)}M€',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '$points Pkt',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Color _positionColor(BuildContext context, dynamic rawPos) {
    final pos = int.tryParse(rawPos.toString()) ?? 0;
    switch (pos) {
      case 1:
        return Colors.yellow.shade800; // TW
      case 2:
        return Colors.blue.shade600; // ABW
      case 3:
        return Colors.green.shade600; // MF
      case 4:
        return Colors.red.shade600; // ST
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  Widget _buildPerformanceTab(BuildContext context) {
    final performanceAsync = ref.watch(
      managerPerformanceProvider((
        leagueId: widget.leagueId,
        userId: widget.userId,
      )),
    );

    return performanceAsync.when(
      data: (performanceData) {
        final performances = performanceData['performances'] as List? ?? [];

        if (performances.isEmpty) {
          return const Center(child: Text('Keine Performance-Daten verfügbar'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: performances.length,
          itemBuilder: (context, index) {
            final performance = performances[index];
            return _buildPerformanceCard(context, performance);
          },
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerPerformanceProvider((
              leagueId: widget.leagueId,
              userId: widget.userId,
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context, dynamic performance) {
    final matchDay = performance['matchDay'] ?? performance['md'] ?? 0;
    final points = performance['points'] ?? performance['p'] ?? 0;
    final rank = performance['rank'] ?? performance['r'] ?? 0;
    final teamValue = performance['teamValue'] ?? performance['tv'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '$matchDay',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(
          'Spieltag $matchDay',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Platz $rank'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$points Pkt',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '${(teamValue / 1000000).toStringAsFixed(1)}M€',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
