import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/league_providers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Leagues Screen
///
/// Zeigt alle Ligen des Benutzers an und ermöglicht die Auswahl einer Liga.
class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final leaguesAsync = ref.watch(userLeaguesProvider);
    final selectedLeague = ref.watch(selectedLeagueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Ligen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(userLeaguesProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userLeaguesProvider);
        },
        child: leaguesAsync.when(
          data: (leagues) {
            if (leagues.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 80,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Keine Ligen gefunden',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tritt einer Liga bei oder erstelle eine neue Liga in Kickbase.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                final league = leagues[index];
                final isSelected = selectedLeague?.i == league.i;

                return Card(
                  elevation: isSelected ? 4 : 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ref.read(selectedLeagueProvider.notifier).select(league);
                      context.push('/league/${league.i}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.emoji_events,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      league.n,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Matchday ${league.md}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatColumn(
                                icon: Icons.emoji_events,
                                label: 'Platz',
                                value: '#${league.cu.placement}',
                                color: Colors.amber,
                              ),
                              _StatColumn(
                                icon: Icons.stars,
                                label: 'Punkte',
                                value: '${league.cu.points}',
                                color: Colors.blue,
                              ),
                              _StatColumn(
                                icon: Icons.attach_money,
                                label: 'Budget',
                                value:
                                    '${((league.cu.budget) / 1000000).toStringAsFixed(1)}M',
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const LoadingWidget(),
          error: (error, stack) => ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(userLeaguesProvider),
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
