import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';
import '../../providers/market_providers.dart';
import '../../widgets/market/market_filters.dart';
import '../../widgets/market/player_market_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Transfermarkt'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
              ],
            )
          : null,
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  /// Mobile: Single column with search and market players
  Widget _buildMobileLayout(BuildContext context) {
    final marketPlayersAsync = ref.watch(marketPlayersProvider);

    return Column(
      children: [
        _buildSearchBar(context),
        _buildTabBar(context),
        Expanded(
          child: marketPlayersAsync.when(
            data: (players) {
              if (players.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text('Keine Spieler auf dem Markt'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return PlayerMarketCard(
                    player: player,
                    onTap: () {
                      // TODO: Navigate to player detail
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: LoadingWidget()),
            error: (error, stack) => ErrorWidgetCustom(
              error: error,
              onRetry: () => ref.invalidate(marketPlayersProvider),
            ),
          ),
        ),
      ],
    );
  }

  /// Tablet: Split view with filters sidebar
  Widget _buildTabletLayout(BuildContext context) {
    final marketPlayersAsync = ref.watch(marketPlayersProvider);

    return ResponsiveSplitView(
      listFlex: 3,
      detailFlex: 1,
      list: Column(
        children: [
          _buildSearchBar(context),
          _buildTabBar(context),
          Expanded(
            child: marketPlayersAsync.when(
              data: (players) {
                if (players.isEmpty) {
                  return const Center(child: Text('Keine Spieler verfügbar'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return PlayerMarketCard(
                      player: player,
                      onTap: () {
                        // TODO: Navigate to player detail
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: LoadingWidget()),
              error: (error, stack) => ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(marketPlayersProvider),
              ),
            ),
          ),
        ],
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const MarketFilters(),
      ),
    );
  }

  /// Desktop: Grid with advanced filters and sorting
  Widget _buildDesktopLayout(BuildContext context) {
    final marketPlayersAsync = ref.watch(marketPlayersProvider);

    return Row(
      children: [
        // Filter Sidebar
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: const MarketFilters(),
          ),
        ),
        const VerticalDivider(width: 1),
        // Main Content
        Expanded(
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildTabBar(context),
              Expanded(
                child: marketPlayersAsync.when(
                  data: (players) {
                    if (players.isEmpty) {
                      return const Center(
                        child: Text('Keine Spieler verfügbar'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return PlayerMarketCard(
                          player: player,
                          onTap: () {
                            // TODO: Navigate to player detail
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: LoadingWidget()),
                  error: (error, stack) => ErrorWidgetCustom(
                    error: error,
                    onRetry: () => ref.invalidate(marketPlayersProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(marketFilterProvider.notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Spieler suchen...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(marketFilterProvider.notifier).setSearchQuery('');
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final currentTab = ref.watch(marketTabProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          _buildTabButton(
            context,
            'Verfügbar',
            MarketTab.available,
            currentTab == MarketTab.available,
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            context,
            'Zum Verkauf',
            MarketTab.mySelling,
            currentTab == MarketTab.mySelling,
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            context,
            'Kürzliche',
            MarketTab.recentTransfers,
            currentTab == MarketTab.recentTransfers,
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            context,
            'Beobachtete',
            MarketTab.watchlist,
            currentTab == MarketTab.watchlist,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String label,
    MarketTab tab,
    bool isSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(marketTabProvider.notifier).setTab(tab);
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16.0),
          child: const MarketFilters(),
        ),
      ),
    );
  }
}
