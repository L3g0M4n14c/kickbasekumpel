import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/screen_size.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/league_model.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? selectedLeagueId;
  bool _hasAutoSelected = false;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final leaguesAsync = ref.watch(userLeaguesProvider);

    // Auto-select first league when leagues load (only once)
    if (!_hasAutoSelected) {
      leaguesAsync.whenData((leagues) {
        if (leagues.isNotEmpty && selectedLeagueId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && selectedLeagueId == null && !_hasAutoSelected) {
              setState(() {
                selectedLeagueId = leagues[0].i;
                _hasAutoSelected = true;
              });
            }
          });
        }
      });
    }

    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // TODO: Notifications
                  },
                ),
                IconButton(
                  tooltip: 'Ligainsider',
                  icon: const Icon(Icons.insights),
                  onPressed: () {
                    // Open Ligainsider lineups screen
                    context.push('/ligainsider/lineups');
                  },
                ),
              ],
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          ref.invalidate(userLeaguesProvider);
          if (selectedLeagueId != null) {
            ref.invalidate(leagueMeProvider(selectedLeagueId!));
            ref.invalidate(myBudgetProvider(selectedLeagueId!));
            ref.invalidate(mySquadProvider(selectedLeagueId!));
          }
        },
        child: userAsync.when(
          data: (user) {
            return leaguesAsync.when(
              data: (leagues) {
                if (leagues.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ResponsiveLayout(
                  mobile: _buildMobileLayout(context, ref, user, leagues),
                  tablet: _buildTabletLayout(context, ref, user, leagues),
                  desktop: _buildDesktopLayout(context, ref, user, leagues),
                );
              },
              loading: () => const Center(child: LoadingWidget()),
              error: (error, stack) => Center(
                child: ErrorWidgetCustom(
                  error: error,
                  onRetry: () => ref.invalidate(userLeaguesProvider),
                ),
              ),
            );
          },
          loading: () => const Center(child: LoadingWidget()),
          error: (error, stack) => Center(
            child: ErrorWidgetCustom(
              error: error,
              onRetry: () => ref.invalidate(currentUserProvider),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Noch keine Ligen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tritt einer Liga bei',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Mobile: Single Column Layout
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    user,
    leagues,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(context, user),
        const SizedBox(height: 16),
        _buildLeagueSelector(context, ref, leagues),
        if (selectedLeagueId != null) ...[
          const SizedBox(height: 16),
          _buildSquadOverview(context, ref, selectedLeagueId!),
        ],
        const SizedBox(height: 16),
        _buildQuickActionsCard(context),
      ],
    );
  }

  /// Tablet: Split View with larger cards
  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    user,
    leagues,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildWelcomeCard(context, user),
                const SizedBox(height: 24),
                _buildLeagueSelector(context, ref, leagues),
                if (selectedLeagueId != null) ...[
                  const SizedBox(height: 24),
                  _buildSquadOverview(context, ref, selectedLeagueId!),
                ],
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildQuickActionsCard(context),
          ),
        ),
      ],
    );
  }

  /// Desktop: Multi-column Layout
  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    user,
    leagues,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: ResponsiveContainer(
        desktopMaxWidth: 1600,
        child: Column(
          children: [
            _buildWelcomeCard(context, user),
            const SizedBox(height: 32),
            _buildLeagueSelector(context, ref, leagues),
            if (selectedLeagueId != null) ...[
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildSquadOverview(context, ref, selectedLeagueId!),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(flex: 2, child: _buildQuickActionsCard(context)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeagueSelector(
    BuildContext context,
    WidgetRef ref,
    List<League> leagues,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meine Ligen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedLeagueId,
              decoration: const InputDecoration(
                labelText: 'Liga auswählen',
                border: OutlineInputBorder(),
              ),
              items: leagues.map((league) {
                return DropdownMenuItem(value: league.i, child: Text(league.n));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLeagueId = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadOverview(
    BuildContext context,
    WidgetRef ref,
    String leagueId,
  ) {
    final squadAsync = ref.watch(mySquadProvider(leagueId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dein Kader', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        squadAsync.when(
          data: (squadData) {
            final players = squadData['it'] as List? ?? [];

            if (players.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Keine Spieler in deinem Kader',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }

            return Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Marktwert')),
                    DataColumn(label: Text('Punkte')),
                    DataColumn(label: Text('Position')),
                  ],
                  rows: players.map((player) {
                    final name = player['n'] as String? ?? 'Unbekannt';
                    final marketValue = player['mv'] as int? ?? 0;
                    final points = player['tp'] as int? ?? 0;
                    final position = player['pos'] as int? ?? 0;

                    String posLabel = '';
                    switch (position) {
                      case 1:
                        posLabel = 'TW';
                        break;
                      case 2:
                        posLabel = 'AB';
                        break;
                      case 3:
                        posLabel = 'MF';
                        break;
                      case 4:
                        posLabel = 'ST';
                        break;
                    }

                    return DataRow(
                      cells: [
                        DataCell(Text(name)),
                        DataCell(
                          Text(
                            '€${(marketValue / 1000000).toStringAsFixed(1)}M',
                          ),
                        ),
                        DataCell(Text('⭐ $points')),
                        DataCell(Text(posLabel)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          },
          loading: () => const Center(child: LoadingWidget()),
          error: (error, stack) => Text(
            'Fehler beim Laden des Kaders: ${error.toString()}',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context, user) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Willkommen zurück, ${user?.n ?? 'Unbekannt'}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 24 * context.fontSizeMultiplier,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user?.em ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Schnellzugriff',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Rangliste'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (selectedLeagueId != null) {
                context.push('/league/$selectedLeagueId/standings');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Zum Markt'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dashboard/market'),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Transfers verwalten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/dashboard/transfers'),
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Ligainsider (Aufstellungen)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/ligainsider/lineups'),
          ),
        ],
      ),
    );
  }
}
