import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/budget_calculation_model.dart';
import '../../data/models/transfer_model.dart';
import '../../data/providers/providers.dart';
import '../../data/providers/ligainsider_photo_provider.dart';
import '../../data/providers/manager_transfer_history_providers.dart';
import '../../data/utils/parsing_utils.dart';
import '../widgets/charts/stats_bar_chart.dart';
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
    _tabController = TabController(length: 4, vsync: this);
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
            Tab(text: 'Transferhistorie', icon: Icon(Icons.history)),
            Tab(text: 'Budget', icon: Icon(Icons.account_balance_wallet)),
          ],
        ),
      ),
      body: dashboardAsync.when(
        data: (dashboardData) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: _buildManagerHeader(context, dashboardData),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildSquadTab(context),
                _buildPerformanceTab(context),
                _buildTransferHistoryTab(context),
                _buildBudgetTab(context),
              ],
            ),
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
    final uim = dashboardData['uim'] as String?;
    final photoUrl = uim != null && uim.isNotEmpty
        ? 'https://kickbase.b-cdn.net/$uim'
        : null;

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
          if (photoUrl != null)
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey.shade300,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          else
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
      managerSquadEnrichedProvider((
        leagueId: widget.leagueId,
        userId: widget.userId,
      )),
    );

    return squadAsync.when(
      data: (players) {
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
            managerSquadEnrichedProvider((
              leagueId: widget.leagueId,
              userId: widget.userId,
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchDayStartingEleven(BuildContext context) {
    // Angereicherte Spieler für den Spieltag laden:
    // - vollständige Namen (fn + ln) für Ligainsider-Foto-Lookup
    // - matchDayPoints: Punkte des Spielers an diesem Spieltag
    final lineupAsync = ref.watch(
      managerLineupEnrichedProvider((
        leagueId: widget.leagueId,
        userId: widget.userId,
        matchDay: widget.matchDay!,
      )),
    );

    return lineupAsync.when(
      data: (players) {
        if (players.isEmpty) {
          return Center(
            child: Text(
              'Keine Spieler für Spieltag ${widget.matchDay} gefunden',
            ),
          );
        }

        final sorted = List<Map<String, dynamic>>.from(players)
          ..sort(
            (a, b) => _positionOrder(
              a['pos'] ?? a['position'] ?? 0,
            ).compareTo(_positionOrder(b['pos'] ?? b['position'] ?? 0)),
          );

        return _buildPlayerList(context, sorted);
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerLineupEnrichedProvider((
              leagueId: widget.leagueId,
              userId: widget.userId,
              matchDay: widget.matchDay!,
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

    // Spieltag-spezifische Punkte (nur vorhanden wenn matchDay-Ansicht)
    final matchDayPoints =
        (player as Map<Object?, Object?>)['matchDayPoints'] as int?;

    // Positionsfarbe
    final posColor = _positionColor(context, posRaw);

    // Spielerfoto via Ligainsider
    final photoMap = ref.watch(ligainsiderPhotoMapProvider).asData?.value;
    final ligaPhoto = lookupLigainsiderPhoto(photoMap, firstName, lastName);
    final String? photoUrl = ligaPhoto != null
        ? (kIsWeb
              ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(ligaPhoto)}&w=80&h=80&fit=cover'
              : ligaPhoto)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: photoUrl != null
            ? SizedBox(
                width: 40,
                height: 40,
                child: ClipOval(
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CircleAvatar(
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
                  ),
                ),
              )
            : CircleAvatar(
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
          matchDayPoints != null
              ? 'Ø ${avgPoints.toStringAsFixed(1)} Pkt/Spieltag'
              : 'Ø ${avgPoints.toStringAsFixed(1)} Pkt/Spieltag',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: matchDayPoints != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$matchDayPoints Pkt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: matchDayPoints > 0
                          ? Colors.green.shade700
                          : Colors.grey,
                    ),
                  ),
                  Text(
                    '${(marketValue / 1_000_000).toStringAsFixed(1)}M€',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(marketValue / 1_000_000).toStringAsFixed(1)}M€',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
        // API Struktur: { it: [ { ap, tp, pl, it: [ { day, mdp, tw, cur, md } ] } ] }
        final seasons = performanceData['it'] as List? ?? [];
        if (seasons.isEmpty) {
          return const Center(child: Text('Keine Performance-Daten verfügbar'));
        }

        // Aktuelle Saison: Saisons sind alt→neu sortiert, daher von hinten suchen.
        // Neueste Saison mit cur=true nehmen; Fallback: seasons.last (= neueste).
        final currentSeason = (seasons
            .cast<Map<String, dynamic>>()
            .reversed
            .firstWhere((s) {
              final days = s['it'] as List? ?? [];
              return days.any((d) => d['cur'] == true);
            }, orElse: () => seasons.last as Map<String, dynamic>));
        final performances = currentSeason['it'] as List? ?? [];
        final seasonTotalPoints =
            (currentSeason['tp'] as num?)?.toDouble() ?? 0.0;
        final seasonAvgPoints =
            (currentSeason['ap'] as num?)?.toDouble() ?? 0.0;
        final seasonPlacement = currentSeason['pl'] ?? 0;

        if (performances.isEmpty) {
          return const Center(child: Text('Keine Performance-Daten verfügbar'));
        }

        // Nur Spieltage mit Punkte-Daten (gespielte Spieltage)
        final playedDays = performances
            .where((p) => (p['mdp'] as num? ?? 0) > 0 || p['cur'] == true)
            .toList();

        // Balkendiagramm-Datenpunkte aufbauen
        final chartData = playedDays.map<StatPoint>((p) {
          final matchDay = (p['day'] as num?)?.toInt() ?? 0;
          final points = (p['mdp'] as num?)?.toDouble() ?? 0.0;
          return StatPoint(label: '$matchDay', value: points);
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Zusammenfassung
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          seasonTotalPoints.toInt().toString(),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          'Gesamtpunkte',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          seasonAvgPoints.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Text(
                          'Ø Pkt/Spieltag',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '#$seasonPlacement',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Platz',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Balkendiagramm
            StatsBarChart(
              data: chartData,
              title: 'Punkte pro Spieltag',
              height: 220,
            ),
            const SizedBox(height: 16),
            Text(
              'Spieltag-Details',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...playedDays.map<Widget>(
              (performance) => _buildPerformanceCard(context, performance),
            ),
          ],
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
    // API Felder: day (Spieltag-Nr), mdp (Punkte), tw (Sieg), cur (aktuell)
    final matchDay = (performance['day'] as num?)?.toInt() ?? 0;
    final points = (performance['mdp'] as num?)?.toInt() ?? 0;
    final isWin = performance['tw'] as bool? ?? false;
    final isCurrent = performance['cur'] as bool? ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCurrent
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Text(
            '$matchDay',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrent
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        title: Text(
          'Spieltag $matchDay',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: isWin
            ? Text('Sieg', style: TextStyle(color: Colors.green.shade600))
            : const Text(''),
        trailing: Text(
          '$points Pkt',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: points >= 10
                ? Colors.green
                : points >= 5
                ? Colors.orange
                : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildTransferHistoryTab(BuildContext context) {
    final transfersAsync = ref.watch(
      managerTransferHistoryProvider((
        leagueId: widget.leagueId,
        managerId: widget.userId,
      )),
    );

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(child: Text('Keine Transferhistorie verfügbar'));
        }

        // Sortieren nach Timestamp (neueste zuerst)
        final sortedTransfers = List<ManagerTransferHistoryEntry>.from(
          transfers,
        )..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Tabellenheader
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Spieler',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Datum',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Gezahlt',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Marktwert',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Differenz',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Transfer-Einträge
            ...sortedTransfers.map<Widget>((transfer) {
              final playerName = transfer.playerName;
              final timestamp = transfer.timestamp;
              final price = transfer.price;
              final marketValue = transfer.marketValueAtTransfer;

              // Prozentuale Differenz berechnen (nur wenn Marktwert verfügbar)
              final differencePercent = marketValue != null && marketValue > 0
                  ? ((price - marketValue) / marketValue * 100).round()
                  : null;

              // Farbe für die Differenz
              final differenceColor = differencePercent != null
                  ? differencePercent > 0
                        ? Colors.red
                        : differencePercent < 0
                        ? Colors.green
                        : Colors.grey
                  : Colors.grey;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          playerName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${timestamp.day}.${timestamp.month}.${timestamp.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${(price / 1000000).toStringAsFixed(2)}M',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          marketValue != null
                              ? '${(marketValue / 1000000).toStringAsFixed(2)}M'
                              : 'N/A',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          differencePercent != null
                              ? '${differencePercent > 0 ? '+' : ''}$differencePercent%'
                              : 'N/A',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: differenceColor,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerTransferHistoryProvider((
              leagueId: widget.leagueId,
              managerId: widget.userId,
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetTab(BuildContext context) {
    final budgetCalculationAsync = ref.watch(
      managerBudgetCalculationProvider((
        leagueId: widget.leagueId,
        managerId: widget.userId,
      )),
    );

    return budgetCalculationAsync.when(
      data: (calculation) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Übersichtskarten
              _BudgetOverviewCards(calculation: calculation),
              const SizedBox(height: 24),

              // Transferübersicht
              _TransferOverviewSection(calculation: calculation),
              const SizedBox(height: 24),

              // Berechnungsdetails
              _CalculationDetailsSection(calculation: calculation),
            ],
          ),
        );
      },
      loading: () => const Center(child: LoadingWidget()),
      error: (error, stack) => Center(
        child: ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(
            managerBudgetCalculationProvider((
              leagueId: widget.leagueId,
              managerId: widget.userId,
            )),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BUDGET TAB WIDGETS
// ============================================================================

class _BudgetOverviewCards extends StatelessWidget {
  final BudgetCalculationResult calculation;

  const _BudgetOverviewCards({required this.calculation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Budget-Übersicht für ${calculation.managerName}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BudgetCard(
                    icon: Icons.account_balance,
                    label: 'Startbudget',
                    value:
                        '${(calculation.initialBudget / 1000000).toStringAsFixed(2)} M €',
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _BudgetCard(
                    icon: Icons.arrow_upward,
                    label: 'Verkäufe',
                    value:
                        '+${(calculation.totalSales / 1000000).toStringAsFixed(2)} M €',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _BudgetCard(
                    icon: Icons.arrow_downward,
                    label: 'Käufe',
                    value:
                        '-${(calculation.totalPurchases / 1000000).toStringAsFixed(2)} M €',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _BudgetCard(
              icon: Icons.account_balance_wallet,
              label: 'AKTUELLES BUDGET',
              value:
                  '${(calculation.currentBudget / 1000000).toStringAsFixed(2)} M €',
              color: calculation.currentBudget >= 0 ? Colors.green : Colors.red,
              isHighlighted: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isHighlighted;

  const _BudgetCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? color.withOpacity(0.2)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransferOverviewSection extends StatelessWidget {
  final BudgetCalculationResult calculation;

  const _TransferOverviewSection({required this.calculation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Transferübersicht',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Verkäufe
            if (calculation.sales.isNotEmpty) ...[
              Text(
                'Verkäufe (${calculation.sales.length}): +${(calculation.totalSales / 1000000).toStringAsFixed(2)} M €',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ...calculation.sales.map(
                (sale) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sale.playerName,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '+${(sale.price / 1000000).toStringAsFixed(2)} M €',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Käufe
            if (calculation.purchases.isNotEmpty) ...[
              Text(
                'Käufe (${calculation.purchases.length}): -${(calculation.totalPurchases / 1000000).toStringAsFixed(2)} M €',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              ...calculation.purchases.map(
                (purchase) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          purchase.playerName,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '-${(purchase.price / 1000000).toStringAsFixed(2)} M €',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CalculationDetailsSection extends StatelessWidget {
  final BudgetCalculationResult calculation;

  const _CalculationDetailsSection({required this.calculation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Berechnungsdetails',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Berechnungsschritte
            _CalculationStep(
              step: 1,
              description: 'Startbudget',
              value:
                  '${(calculation.initialBudget / 1000000).toStringAsFixed(2)} M €',
            ),
            _CalculationStep(
              step: 2,
              description: 'Verkaufserlöse',
              value:
                  '+${(calculation.totalSales / 1000000).toStringAsFixed(2)} M €',
            ),
            _CalculationStep(
              step: 3,
              description: 'Kaufausgaben',
              value:
                  '-${(calculation.totalPurchases / 1000000).toStringAsFixed(2)} M €',
            ),
            const Divider(height: 24),
            _CalculationStep(
              step: 4,
              description: 'AKTUELLES BUDGET',
              value:
                  '${(calculation.currentBudget / 1000000).toStringAsFixed(2)} M €',
              isFinal: true,
              color: calculation.currentBudget >= 0 ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),
            Text(
              'Berechnet am: ${calculation.calculatedAt.day}.${calculation.calculatedAt.month}.${calculation.calculatedAt.year}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculationStep extends StatelessWidget {
  final int step;
  final String description;
  final String value;
  final String? result;
  final bool isFinal;
  final Color? color;

  const _CalculationStep({
    required this.step,
    required this.description,
    required this.value,
    this.isFinal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$step.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(description, style: theme.textTheme.bodyMedium)),
          if (result != null) ...[
            Text(
              '= $result',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isFinal ? FontWeight.bold : FontWeight.normal,
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
