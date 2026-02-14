import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/team_player_counts_model.dart';
import 'package:kickbasekumpel/presentation/widgets/team/team_budget_header.dart';
import 'package:kickbasekumpel/presentation/widgets/team/player_count_overview.dart';
import 'package:kickbasekumpel/presentation/widgets/team/player_row_with_sale.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/presentation/screens/player/player_detail_screen.dart';

/// Sortierungs-Optionen für Spieler
enum SortOption { name, marketValue, points, trend, position }

/// Team Page - Zeigt den aktuellen Team des Spielers
class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  late SortOption _sortBy;

  @override
  void initState() {
    super.initState();
    _sortBy = SortOption.marketValue;
  }

  @override
  Widget build(BuildContext context) {
    // Trigger auto-select of first league
    ref.watch(autoSelectFirstLeagueProvider);
    final selectedLeague = ref.watch(selectedLeagueProvider);

    final teamPlayersAsync = ref.watch(teamPlayersProvider);
    final teamBudgetAsync = ref.watch(teamBudgetProvider);
    final selectedForSale = ref.watch(selectedTeamPlayersForSaleProvider);

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh team data
        ref.invalidate(teamPlayersProvider);
        ref.invalidate(teamBudgetProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Header
              teamBudgetAsync.when(
                data: (budget) {
                  final saleValue = _calculateSaleValue(
                    teamPlayersAsync.maybeWhen(
                      data: (players) => players,
                      orElse: () => [],
                    ),
                    selectedForSale,
                  );
                  return TeamBudgetHeader(
                    currentBudget: budget,
                    saleValue: saleValue,
                  );
                },
                loading: () => const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Player Count Overview
              teamPlayersAsync.when(
                data: (players) {
                  final availablePlayers = players
                      .where((p) => !selectedForSale.contains(p.id))
                      .toList();
                  final counts = _calculatePlayerCounts(availablePlayers);
                  return PlayerCountOverview(playerCounts: counts);
                },
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Sort Controls
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sortieren:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButton<SortOption>(
                        value: _sortBy,
                        isExpanded: true,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sortBy = value);
                          }
                        },
                        items: SortOption.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(_getSortLabel(e)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Team Players List
              teamPlayersAsync.when(
                data: (players) {
                  final sortedPlayers = _sortPlayers(players, _sortBy);
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedPlayers.length,
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (context, index) {
                      final player = sortedPlayers[index];
                      return PlayerRowWithSale(
                        player: player,
                        isSelectedForSale: selectedForSale.contains(player.id),
                        onToggleSale: (isSelected) {
                          if (isSelected) {
                            ref
                                .read(
                                  selectedTeamPlayersForSaleProvider.notifier,
                                )
                                .togglePlayer(player.id);
                          } else {
                            ref
                                .read(
                                  selectedTeamPlayersForSaleProvider.notifier,
                                )
                                .togglePlayer(player.id);
                          }
                        },
                        onTap: selectedLeague != null
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayerDetailScreen(
                                      playerId: player.id,
                                      leagueId: selectedLeague.i,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    children: [
                      const Text('Fehler beim Laden der Spieler'),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(teamPlayersProvider),
                        child: const Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Player> _sortPlayers(List<Player> players, SortOption sortBy) {
    switch (sortBy) {
      case SortOption.name:
        return [...players]..sort((a, b) => a.lastName.compareTo(b.lastName));
      case SortOption.marketValue:
        return [...players]
          ..sort((a, b) => b.marketValue.compareTo(a.marketValue));
      case SortOption.points:
        return [...players]
          ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
      case SortOption.trend:
        return [...players]..sort((a, b) => b.tfhmvt.compareTo(a.tfhmvt));
      case SortOption.position:
        return [...players]..sort((a, b) => a.position.compareTo(b.position));
    }
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.name:
        return 'Name';
      case SortOption.marketValue:
        return 'Marktwert';
      case SortOption.points:
        return 'Punkte';
      case SortOption.trend:
        return 'Trend';
      case SortOption.position:
        return 'Position';
    }
  }

  TeamPlayerCounts _calculatePlayerCounts(List<Player> players) {
    final goalkeepers = players.where((p) => p.position == 1).length;
    final defenders = players.where((p) => p.position == 2).length;
    final midfielders = players.where((p) => p.position == 3).length;
    final forwards = players.where((p) => p.position == 4).length;

    return TeamPlayerCounts(
      total: players.length,
      goalkeepers: goalkeepers,
      defenders: defenders,
      midfielders: midfielders,
      forwards: forwards,
    );
  }

  int _calculateSaleValue(List<Player> players, Set<String> selectedIds) {
    return players
        .where((p) => selectedIds.contains(p.id))
        .fold(0, (sum, p) => sum + p.marketValue);
  }
}
