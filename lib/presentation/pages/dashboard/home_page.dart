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
  void initState() {
    super.initState();
  }

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
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Noch keine Ligen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tritt einer Liga bei',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile: Single Column Layout
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, user, leagues) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(context, user),
        const SizedBox(height: 16),
        _buildLeagueSelector(context, ref, leagues),
        if (selectedLeagueId != null) ...[
          const SizedBox(height: 16),
          _buildLeagueStats(context, ref, selectedLeagueId!),
          const SizedBox(height: 16),
          _buildSquadOverview(context, ref, selectedLeagueId!),
        ],
        const SizedBox(height: 16),
        _buildQuickActionsCard(context),
      ],
    );
  }

  /// Tablet: Split View with larger cards
  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, user, leagues) {
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
                  _buildLeagueStats(context, ref, selectedLeagueId!),
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
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, user, leagues) {
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
                        _buildLeagueStats(context, ref, selectedLeagueId!),
                        const SizedBox(height: 32),
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

  Widget _buildLeagueSelector(BuildContext context, WidgetRef ref, List<League> leagues) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meine Ligen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedLeagueId,
              decoration: const InputDecoration(
                labelText: 'Liga auswählen',
                border: OutlineInputBorder(),
              ),
              items: leagues.map((league) {
                return DropdownMenuItem(
                  value: league.i,
                  child: Text(league.n),
                );
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

  Widget _buildLeagueStats(BuildContext context, WidgetRef ref, String leagueId) {
    final leagueMeAsync = ref.watch(leagueMeProvider(leagueId));
    final budgetAsync = ref.watch(myBudgetProvider(leagueId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liga-Statistiken',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            leagueMeAsync.when(
              data: (leagueMeData) {
                final teamValue = leagueMeData['tv'] ?? 0;
                final points = leagueMeData['p'] ?? 0;
                final placement = leagueMeData['pl'] ?? 0;

                return budgetAsync.when(
                  data: (budgetData) {
                    final budget = budgetData['b'] ?? 0;
                    final availableBudget = budgetData['ab'] ?? 0;

                    return GridView.count(
                      crossAxisCount: ScreenSize.isMobile(context) ? 2 : 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _StatCard(
                          title: 'Budget',
                          value: '${(budget / 1000000).toStringAsFixed(1)}M€',
                          icon: Icons.account_balance_wallet,
                          color: Colors.green,
                        ),
                        _StatCard(
                          title: 'Verfügbar',
                          value: '${(availableBudget / 1000000).toStringAsFixed(1)}M€',
                          icon: Icons.euro,
                          color: Colors.teal,
                        ),
                        _StatCard(
                          title: 'Team-Wert',
                          value: '${(teamValue / 1000000).toStringAsFixed(1)}M€',
                          icon: Icons.trending_up,
                          color: Colors.blue,
                        ),
                        _StatCard(
                          title: 'Platzierung',
                          value: '#$placement',
                          icon: Icons.emoji_events,
                          color: Colors.amber,
                        ),
                        _StatCard(
                          title: 'Punkte',
                          value: '$points',
                          icon: Icons.stars,
                          color: Colors.purple,
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: LoadingWidget()),
                  error: (error, stack) => Text(
                    'Budget-Fehler: ${error.toString()}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                );
              },
              loading: () => const Center(child: LoadingWidget()),
              error: (error, stack) => Text(
                'Fehler: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadOverview(BuildContext context, WidgetRef ref, String leagueId) {
    final squadAsync = ref.watch(mySquadProvider(leagueId));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mein Kader',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            squadAsync.when(
              data: (squadData) {
                final players = squadData['it'] as List? ?? [];
                // tp = total points (Gesamtpunkte des Spielers)
                final totalPoints = players.fold<int>(
                  0,
                  (sum, player) => sum + (player['tp'] as int? ?? 0),
                );
                final avgPoints = players.isEmpty 
                    ? 0.0 
                    : totalPoints / players.length;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSquadStat(
                          context,
                          'Spieler',
                          '${players.length}',
                          Icons.people,
                        ),
                        _buildSquadStat(
                          context,
                          'Ø Punkte',
                          avgPoints.toStringAsFixed(1),
                          Icons.star,
                        ),
                        _buildSquadStat(
                          context,
                          'Gesamt',
                          '$totalPoints',
                          Icons.emoji_events,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        // Navigate to lineup/squad page
                        context.push('/dashboard/lineup');
                      },
                      icon: const Icon(Icons.groups),
                      label: const Text('Kader anzeigen'),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: LoadingWidget()),
              error: (error, stack) => Text(
                'Fehler beim Laden des Kaders: ${error.toString()}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquadStat(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
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
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
