import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/player_providers.dart';
import '../../../data/models/player_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

/// Market Screen
///
/// Zeigt den Spielermarkt an und ermöglicht Kauf/Verkauf von Spielern.
class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  String _searchQuery = '';
  int? _selectedPosition;
  String _sortBy = 'marketValue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final playersAsync = ref.watch(allPlayersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfermarkt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(allPlayersProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Spieler suchen...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          // Players List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(allPlayersProvider);
              },
              child: playersAsync.when(
                data: (players) {
                  // Filter players
                  var filteredPlayers = players.where((player) {
                    final matchesSearch =
                        _searchQuery.isEmpty ||
                        player.firstName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        player.lastName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        player.teamName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );

                    final matchesPosition =
                        _selectedPosition == null ||
                        player.position == _selectedPosition;

                    return matchesSearch && matchesPosition;
                  }).toList();

                  // Sort players
                  filteredPlayers.sort((a, b) {
                    switch (_sortBy) {
                      case 'marketValue':
                        return b.marketValue.compareTo(a.marketValue);
                      case 'points':
                        return b.totalPoints.compareTo(a.totalPoints);
                      case 'avgPoints':
                        return b.averagePoints.compareTo(a.averagePoints);
                      default:
                        return 0;
                    }
                  });

                  if (filteredPlayers.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Keine Spieler gefunden',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Versuche eine andere Suche oder Filter',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24.0 : 16.0,
                      vertical: 8.0,
                    ),
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      return _PlayerMarketCard(
                        player: player,
                        onTap: () => context.push('/player/${player.id}'),
                      );
                    },
                  );
                },
                loading: () => const LoadingWidget(),
                error: (error, stack) => ErrorWidgetCustom(
                  error: error,
                  onRetry: () => ref.invalidate(allPlayersProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter & Sortierung',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Position Filter
                Text('Position', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Alle'),
                      selected: _selectedPosition == null,
                      onSelected: (selected) {
                        setModalState(() => _selectedPosition = null);
                        setState(() => _selectedPosition = null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Torwart'),
                      selected: _selectedPosition == 1,
                      onSelected: (selected) {
                        setModalState(
                          () => _selectedPosition = selected ? 1 : null,
                        );
                        setState(() => _selectedPosition = selected ? 1 : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Abwehr'),
                      selected: _selectedPosition == 2,
                      onSelected: (selected) {
                        setModalState(
                          () => _selectedPosition = selected ? 2 : null,
                        );
                        setState(() => _selectedPosition = selected ? 2 : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Mittelfeld'),
                      selected: _selectedPosition == 3,
                      onSelected: (selected) {
                        setModalState(
                          () => _selectedPosition = selected ? 3 : null,
                        );
                        setState(() => _selectedPosition = selected ? 3 : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Sturm'),
                      selected: _selectedPosition == 4,
                      onSelected: (selected) {
                        setModalState(
                          () => _selectedPosition = selected ? 4 : null,
                        );
                        setState(() => _selectedPosition = selected ? 4 : null);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sort By
                Text('Sortieren nach', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('Marktwert'),
                  leading: Radio<String>(
                    value: 'marketValue',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setModalState(() => _sortBy = value!);
                      setState(() => _sortBy = value!);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Gesamtpunkte'),
                  leading: Radio<String>(
                    value: 'points',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setModalState(() => _sortBy = value!);
                      setState(() => _sortBy = value!);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Ø Punkte'),
                  leading: Radio<String>(
                    value: 'avgPoints',
                    groupValue: _sortBy,
                    onChanged: (value) {
                      setModalState(() => _sortBy = value!);
                      setState(() => _sortBy = value!);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Anwenden'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PlayerMarketCard extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const _PlayerMarketCard({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Player Image
              CircleAvatar(
                radius: 28,
                backgroundImage: player.profileBigUrl.isNotEmpty
                    ? NetworkImage(player.profileBigUrl)
                    : null,
                child: player.profileBigUrl.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 12),

              // Player Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${player.firstName} ${player.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      player.teamName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${player.averagePoints.toStringAsFixed(1)} Ø',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.trending_up,
                          size: 14,
                          color: _getTrendColor(player.marketValueTrend),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${player.marketValueTrend > 0 ? '+' : ''}${(player.marketValueTrend / 1000).toStringAsFixed(0)}k',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getTrendColor(player.marketValueTrend),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Market Value
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(player.marketValue / 1000000).toStringAsFixed(2)}M €',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getPositionColor(
                        player.position,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getPositionName(player.position),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getPositionColor(player.position),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTrendColor(int trend) {
    if (trend > 0) return Colors.green;
    if (trend < 0) return Colors.red;
    return Colors.grey;
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.yellow;
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
        return 'TW';
      case 2:
        return 'ABW';
      case 3:
        return 'MIT';
      case 4:
        return 'STU';
      default:
        return 'UNK';
    }
  }
}
