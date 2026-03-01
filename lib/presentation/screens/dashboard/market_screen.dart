import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/market_model.dart';
import '../../../data/models/transfer_model.dart';
import '../../../data/providers/kickbase_api_provider.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/providers/transfer_providers.dart';
import '../../providers/market_providers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/market/player_market_card.dart';
import '../../widgets/market/buy_player_bottom_sheet.dart';
import '../../widgets/market/market_filters.dart';

/// Market Screen
///
/// Komplexer Screen mit Tab Navigation, Filtering, Sorting und Buy Flow.
/// Features:
/// - 4 Tabs: Available, My Selling, Recent Transfers, Watchlist
/// - Filter: Position, Price Range, Search
/// - Sort: Multiple Options
/// - Pull-to-Refresh & Pagination
/// - Buy Flow with Bottom Sheet
class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref
            .read(marketTabProvider.notifier)
            .setTab(MarketTab.values[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // make sure a league is auto‑selected
    ref.watch(autoSelectFirstLeagueProvider);

    final leagueId = ref.watch(selectedLeagueIdProvider);
    if (leagueId == null) {
      // still render the app bar so user can change league
      return Scaffold(
        appBar: AppBar(title: const Text('Transfermarkt')),
        body: const Center(child: Text('Keine Liga ausgewählt')),
      );
    }

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfermarkt'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Spieler suchen...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(marketFilterProvider.notifier)
                                  .setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onChanged: (value) {
                    ref
                        .read(marketFilterProvider.notifier)
                        .setSearchQuery(value);
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Tabs
              TabBar(
                controller: _tabController,
                isScrollable: !isTablet,
                tabs: const [
                  Tab(text: 'Verfügbar', icon: Icon(Icons.shopping_cart)),
                  Tab(text: 'Meine Angebote', icon: Icon(Icons.sell)),
                  Tab(
                    text: 'Erhaltene Angebote',
                    icon: Icon(Icons.local_offer),
                  ),
                  Tab(text: 'Beobachtungsliste', icon: Icon(Icons.bookmark)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          // Filter Button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                Consumer(
                  builder: (context, ref, child) {
                    final filter = ref.watch(marketFilterProvider);
                    if (filter.hasActiveFilters) {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
          // Sort Menu
          PopupMenuButton<MarketSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) {
              ref.read(marketFilterProvider.notifier).setSortOption(option);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MarketSortOption.price,
                child: Text('Preis (aufsteigend)'),
              ),
              const PopupMenuItem(
                value: MarketSortOption.priceDesc,
                child: Text('Preis (absteigend)'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: MarketSortOption.points,
                child: Text('Punkte (aufsteigend)'),
              ),
              const PopupMenuItem(
                value: MarketSortOption.pointsDesc,
                child: Text('Punkte (absteigend)'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: MarketSortOption.averagePoints,
                child: Text('Ø Punkte (aufsteigend)'),
              ),
              const PopupMenuItem(
                value: MarketSortOption.averagePointsDesc,
                child: Text('Ø Punkte (absteigend)'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: MarketSortOption.marketValue,
                child: Text('Marktwert (aufsteigend)'),
              ),
              const PopupMenuItem(
                value: MarketSortOption.marketValueDesc,
                child: Text('Marktwert (absteigend)'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: MarketSortOption.name,
                child: Text('Name (A-Z)'),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AvailablePlayersTab(),
          _MySellingPlayersTab(),
          _MyOffersTab(),
          _WatchlistTab(),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const MarketFilters(),
    );
  }
}

// ============================================================================
// AVAILABLE PLAYERS TAB
// ============================================================================

class _AvailablePlayersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    if (leagueId == null) {
      return const Center(child: Text('Keine Liga ausgewählt'));
    }

    final playersAsync = ref.watch(marketPlayersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(marketPlayersProvider);
      },
      child: playersAsync.when(
        data: (players) {
          if (players.isEmpty) {
            return _EmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'Keine Spieler verfügbar',
              subtitle: 'Aktuell sind keine Spieler auf dem Markt',
            );
          }

          return _PlayerList(players: players);
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(marketPlayersProvider),
        ),
      ),
    );
  }
}

// ============================================================================
// MY SELLING PLAYERS TAB
// ============================================================================

class _MySellingPlayersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(mySellingPlayersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(mySellingPlayersProvider);
      },
      child: playersAsync.when(
        data: (players) {
          if (players.isEmpty) {
            return _EmptyState(
              icon: Icons.sell_outlined,
              message: 'Keine aktiven Verkäufe',
              subtitle: 'Du hast aktuell keine Spieler zum Verkauf angeboten',
            );
          }

          return _PlayerList(players: players, showSellOptions: true);
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(mySellingPlayersProvider),
        ),
      ),
    );
  }
}

// ============================================================================
// MY OFFERS TAB (Erhaltene Angebote)
// ============================================================================

class _MyOffersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(myOffersPlayersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myOffersPlayersProvider);
      },
      child: playersAsync.when(
        data: (players) {
          if (players.isEmpty) {
            return _EmptyState(
              icon: Icons.local_offer_outlined,
              message: 'Keine Angebote erhalten',
              subtitle: 'Du hast aktuell keine Angebote für deine Spieler',
            );
          }

          return _PlayerList(players: players, showOfferOptions: true);
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(myOffersPlayersProvider),
        ),
      ),
    );
  }
}

// ============================================================================
// RECENT TRANSFERS TAB
// ============================================================================

// ignore: unused_element
class _RecentTransfersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueId = ref.watch(selectedLeagueIdProvider);

    if (leagueId == null) {
      return const Center(child: Text('Keine Liga ausgewählt'));
    }

    final transfersAsync = ref.watch(leagueTransfersProvider(leagueId));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(leagueTransfersProvider(leagueId));
      },
      child: transfersAsync.when(
        data: (transfers) {
          if (transfers.isEmpty) {
            return _EmptyState(
              icon: Icons.swap_horiz_outlined,
              message: 'Keine Transfers',
              subtitle: 'Es gab noch keine Transfers in dieser Liga',
            );
          }

          return _TransferList(transfers: transfers);
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(leagueTransfersProvider(leagueId)),
        ),
      ),
    );
  }
}

// ============================================================================
// WATCHLIST TAB
// ============================================================================

class _WatchlistTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(watchlistPlayersProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(watchlistPlayersProvider);
      },
      child: playersAsync.when(
        data: (players) {
          if (players.isEmpty) {
            return _EmptyState(
              icon: Icons.bookmark_outline,
              message: 'Keine Spieler beobachtet',
              subtitle:
                  'Füge Spieler zur Beobachtungsliste hinzu, um sie hier zu sehen',
            );
          }

          return _PlayerList(players: players, showWatchlistRemove: true);
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => ErrorWidgetCustom(
          error: error,
          onRetry: () => ref.invalidate(watchlistPlayersProvider),
        ),
      ),
    );
  }
}

// ============================================================================
// PLAYER LIST WIDGET
// ============================================================================

class _PlayerList extends ConsumerWidget {
  final List<MarketPlayer> players;
  final bool showSellOptions;
  final bool showOfferOptions;
  final bool showWatchlistRemove;

  const _PlayerList({
    required this.players,
    this.showSellOptions = false,
    this.showOfferOptions = false,
    this.showWatchlistRemove = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return PlayerMarketCard(
          player: player,
          showSellOptions: showSellOptions,
          showOfferOptions: showOfferOptions,
          showWatchlistRemove: showWatchlistRemove,
          onTap: () => _showBuyBottomSheet(context, ref, player),
          onRemoveFromMarket: showSellOptions
              ? () => _handleRemoveFromMarket(context, ref, player)
              : null,
          onAcceptKickbaseOffer: showSellOptions
              ? () => _handleAcceptKickbaseOffer(context, ref, player)
              : null,
          onRemoveFromWatchlist: showWatchlistRemove
              ? () => _handleRemoveFromWatchlist(context, ref, player)
              : null,
        );
      },
    );
  }

  void _showBuyBottomSheet(
    BuildContext context,
    WidgetRef ref,
    MarketPlayer player,
  ) {
    // Set selected player
    ref.read(selectedPlayerProvider.notifier).select(player);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BuyPlayerBottomSheet(player: player),
    );
  }

  Future<void> _handleRemoveFromMarket(
    BuildContext context,
    WidgetRef ref,
    MarketPlayer player,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Vom Markt nehmen',
      message:
          'Möchtest du ${player.firstName} ${player.lastName} wirklich vom Markt nehmen?',
      confirmText: 'Ja, entfernen',
      isDangerous: false,
    );

    if (!confirmed) return;

    try {
      final leagueId = ref.read(selectedLeagueIdProvider);
      if (leagueId == null) return;

      final apiClient = ref.read(kickbaseApiClientProvider);
      await apiClient.removePlayerFromMarket(leagueId, player.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Spieler vom Markt genommen')),
        );
      }

      ref.invalidate(mySellingPlayersProvider);
      ref.invalidate(marketPlayersProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }

  Future<void> _handleAcceptKickbaseOffer(
    BuildContext context,
    WidgetRef ref,
    MarketPlayer player,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'An Kickbase verkaufen',
      message:
          'Möchtest du ${player.firstName} ${player.lastName} wirklich an Kickbase verkaufen?\n\nVerkaufspreis: ${(player.marketValue / 1000000).toStringAsFixed(2)}M €',
      confirmText: 'Ja, verkaufen',
      isDangerous: true,
    );

    if (!confirmed) return;

    try {
      final leagueId = ref.read(selectedLeagueIdProvider);
      if (leagueId == null) return;

      final apiClient = ref.read(kickbaseApiClientProvider);
      await apiClient.acceptKickbaseOffer(leagueId, player.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Spieler an Kickbase verkauft')),
        );
      }

      ref.invalidate(mySellingPlayersProvider);
      ref.invalidate(marketPlayersProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }

  Future<void> _handleRemoveFromWatchlist(
    BuildContext context,
    WidgetRef ref,
    MarketPlayer player,
  ) async {
    try {
      final leagueId = ref.read(selectedLeagueIdProvider);
      if (leagueId == null) return;

      final apiClient = ref.read(kickbaseApiClientProvider);
      await apiClient.removeScoutedPlayer(leagueId, player.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Von Beobachtungsliste entfernt')),
        );
      }

      ref.invalidate(watchlistPlayersProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required bool isDangerous,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDangerous
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

// ============================================================================
// TRANSFER LIST WIDGET
// ============================================================================

class _TransferList extends StatelessWidget {
  final List<Transfer> transfers;

  const _TransferList({required this.transfers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transfers.length,
      itemBuilder: (context, index) {
        final transfer = transfers[index];
        // Determine if it's a buy (to current user) or sell
        final isBuy = transfer.status == 'completed';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isBuy
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.errorContainer,
              child: Icon(
                isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                color: isBuy
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
            title: Text(
              transfer.playerName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${transfer.fromUsername} → ${transfer.toUsername}',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(transfer.price / 1000000).toStringAsFixed(1)}M €',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatDate(transfer.timestamp.toIso8601String()),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Heute';
      } else if (difference.inDays == 1) {
        return 'Gestern';
      } else if (difference.inDays < 7) {
        return 'vor ${difference.inDays} Tagen';
      } else {
        return '${date.day}.${date.month}.${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }
}

// ============================================================================
// EMPTY STATE WIDGET
// ============================================================================

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: theme.colorScheme.outline),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
