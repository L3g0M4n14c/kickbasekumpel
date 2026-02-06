import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/market_model.dart';
import '../../data/models/transfer_model.dart';
import '../../data/providers/service_providers.dart';
import '../../data/providers/league_providers.dart';
import '../../data/providers/user_providers.dart';

// ============================================================================
// MARKET STATE & FILTER MODELS
// ============================================================================

/// Market Filter State
class MarketFilterState {
  final int? positionFilter; // null = all, 1-4 = specific position
  final double? minPrice;
  final double? maxPrice;
  final MarketSortOption sortOption;
  final String searchQuery;

  const MarketFilterState({
    this.positionFilter,
    this.minPrice,
    this.maxPrice,
    this.sortOption = MarketSortOption.price,
    this.searchQuery = '',
  });

  MarketFilterState copyWith({
    int? Function()? positionFilter,
    double? Function()? minPrice,
    double? Function()? maxPrice,
    MarketSortOption? sortOption,
    String? searchQuery,
  }) {
    return MarketFilterState(
      positionFilter: positionFilter != null
          ? positionFilter()
          : this.positionFilter,
      minPrice: minPrice != null ? minPrice() : this.minPrice,
      maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters =>
      positionFilter != null ||
      minPrice != null ||
      maxPrice != null ||
      searchQuery.isNotEmpty;
}

enum MarketSortOption {
  price,
  priceDesc,
  points,
  pointsDesc,
  averagePoints,
  averagePointsDesc,
  marketValue,
  marketValueDesc,
  name,
}

/// Market Tab Type
enum MarketTab { available, mySelling, recentTransfers, watchlist }

// ============================================================================
// FILTER STATE NOTIFIER
// ============================================================================

/// Market Filter StateNotifier
class MarketFilterNotifier extends Notifier<MarketFilterState> {
  @override
  MarketFilterState build() => const MarketFilterState();

  void setPositionFilter(int? position) {
    state = state.copyWith(positionFilter: () => position);
  }

  void setPriceRange({double? min, double? max}) {
    state = state.copyWith(minPrice: () => min, maxPrice: () => max);
  }

  void setSortOption(MarketSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = const MarketFilterState();
  }
}

final marketFilterProvider =
    NotifierProvider<MarketFilterNotifier, MarketFilterState>(
      () => MarketFilterNotifier(),
    );

// ============================================================================
// MARKET TAB PROVIDER
// ============================================================================

class MarketTabNotifier extends Notifier<MarketTab> {
  @override
  MarketTab build() => MarketTab.available;

  void setTab(MarketTab tab) {
    state = tab;
  }
}

final marketTabProvider = NotifierProvider<MarketTabNotifier, MarketTab>(
  () => MarketTabNotifier(),
);

// ============================================================================
// MARKET PLAYERS PROVIDER (WITH FILTER)
// ============================================================================

/// Get available market players with filtering and sorting
final marketPlayersProvider = StreamProvider.autoDispose<List<MarketPlayer>>((
  ref,
) async* {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) {
    yield [];
    return;
  }

  final apiClient = ref.watch(kickbaseApiClientProvider);
  final filter = ref.watch(marketFilterProvider);

  // Initial fetch
  try {
    final players = await apiClient.getMarketAvailable(leagueId);

    // Apply filters and sorting
    final filtered = _applyFiltersAndSort(players, filter);
    yield filtered;

    // Poll for updates every 30 seconds
    await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
      try {
        final updatedPlayers = await apiClient.getMarketAvailable(leagueId);
        final filteredUpdated = _applyFiltersAndSort(updatedPlayers, filter);
        yield filteredUpdated;
      } catch (e) {
        // Continue with previous data on error
      }
    }
  } catch (e, stack) {
    throw Exception('Failed to load market players: $e\n$stack');
  }
});

/// Apply filters and sorting to market players
List<MarketPlayer> _applyFiltersAndSort(
  List<MarketPlayer> players,
  MarketFilterState filter,
) {
  var filtered = players;

  // Position filter
  if (filter.positionFilter != null) {
    filtered = filtered
        .where((p) => p.position == filter.positionFilter)
        .toList();
  }

  // Price range filter
  if (filter.minPrice != null) {
    filtered = filtered
        .where((p) => p.price >= filter.minPrice! * 1000000)
        .toList();
  }
  if (filter.maxPrice != null) {
    filtered = filtered
        .where((p) => p.price <= filter.maxPrice! * 1000000)
        .toList();
  }

  // Search query
  if (filter.searchQuery.isNotEmpty) {
    final query = filter.searchQuery.toLowerCase();
    filtered = filtered.where((p) {
      final fullName = '${p.firstName} ${p.lastName}'.toLowerCase();
      final teamName = p.teamName.toLowerCase();
      return fullName.contains(query) || teamName.contains(query);
    }).toList();
  }

  // Sorting
  switch (filter.sortOption) {
    case MarketSortOption.price:
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case MarketSortOption.priceDesc:
      filtered.sort((a, b) => b.price.compareTo(a.price));
      break;
    case MarketSortOption.points:
      filtered.sort((a, b) => a.totalPoints.compareTo(b.totalPoints));
      break;
    case MarketSortOption.pointsDesc:
      filtered.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
      break;
    case MarketSortOption.averagePoints:
      filtered.sort((a, b) => a.averagePoints.compareTo(b.averagePoints));
      break;
    case MarketSortOption.averagePointsDesc:
      filtered.sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
      break;
    case MarketSortOption.marketValue:
      filtered.sort((a, b) => a.marketValue.compareTo(b.marketValue));
      break;
    case MarketSortOption.marketValueDesc:
      filtered.sort((a, b) => b.marketValue.compareTo(a.marketValue));
      break;
    case MarketSortOption.name:
      filtered.sort(
        (a, b) => '${a.firstName} ${a.lastName}'.compareTo(
          '${b.firstName} ${b.lastName}',
        ),
      );
      break;
  }

  return filtered;
}

// ============================================================================
// SELECTED PLAYER PROVIDER
// ============================================================================

class SelectedPlayerNotifier extends Notifier<MarketPlayer?> {
  @override
  MarketPlayer? build() => null;

  void select(MarketPlayer? player) {
    state = player;
  }

  void clear() {
    state = null;
  }
}

final selectedPlayerProvider =
    NotifierProvider<SelectedPlayerNotifier, MarketPlayer?>(
      () => SelectedPlayerNotifier(),
    );

// ============================================================================
// BUY PLAYER PROVIDER (WITH ERROR HANDLING)
// ============================================================================

class BuyPlayerNotifier extends Notifier<AsyncValue<BidResponse?>> {
  @override
  AsyncValue<BidResponse?> build() => const AsyncValue.data(null);

  Future<void> buyPlayer({
    required String leagueId,
    required String playerId,
    required int price,
  }) async {
    state = const AsyncValue.loading();

    try {
      final apiClient = ref.read(kickbaseApiClientProvider);
      final response = await apiClient.buyPlayer(leagueId, playerId, price);

      state = AsyncValue.data(response);

      // Refresh market players after successful purchase
      ref.invalidate(marketPlayersProvider);

      // Clear selected player
      ref.read(selectedPlayerProvider.notifier).state = null;
    } catch (e, stack) {
      // Handle errors
      String userMessage;
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('insufficient')) {
        userMessage = 'Nicht genügend Budget verfügbar';
      } else if (errorMsg.contains('already')) {
        userMessage = 'Spieler bereits im Kader';
      } else if (errorMsg.contains('expired')) {
        userMessage = 'Angebot ist abgelaufen';
      } else {
        userMessage = 'Fehler beim Kauf: $e';
      }
      state = AsyncValue.error(userMessage, stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Buy player state
final buyPlayerProvider =
    NotifierProvider<BuyPlayerNotifier, AsyncValue<BidResponse?>>(
      () => BuyPlayerNotifier(),
    );

// ============================================================================
// MY SELLING PLAYERS PROVIDER
// ============================================================================

/// Get players currently being sold by the user
final mySellingPlayersProvider = FutureProvider.autoDispose<List<MarketPlayer>>(
  (ref) async {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    if (leagueId == null) return [];

    final apiClient = ref.watch(kickbaseApiClientProvider);

    try {
      final allPlayers = await apiClient.getMarketAvailable(leagueId);
      final currentUser = ref.watch(currentUserProvider).value;

      if (currentUser == null) return [];

      // Filter for players being sold by current user
      return allPlayers.where((p) => p.seller.id == currentUser.i).toList();
    } catch (e) {
      throw Exception('Failed to load selling players: $e');
    }
  },
);

// ============================================================================
// WATCHLIST PROVIDER
// ============================================================================

/// Simple watchlist stored in StateNotifier
class WatchlistNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void addPlayer(String playerId) {
    state = {...state, playerId};
  }

  void removePlayer(String playerId) {
    state = {...state}..remove(playerId);
  }

  bool isWatched(String playerId) {
    return state.contains(playerId);
  }

  void togglePlayer(String playerId) {
    if (state.contains(playerId)) {
      removePlayer(playerId);
    } else {
      addPlayer(playerId);
    }
  }
}

final watchlistProvider = NotifierProvider<WatchlistNotifier, Set<String>>(
  () => WatchlistNotifier(),
);

/// Get watchlist players from current market
final watchlistPlayersProvider = FutureProvider.autoDispose<List<MarketPlayer>>(
  (ref) async {
    final watchlist = ref.watch(watchlistProvider);
    if (watchlist.isEmpty) return [];

    final leagueId = ref.watch(selectedLeagueIdProvider);
    if (leagueId == null) return [];

    final apiClient = ref.watch(kickbaseApiClientProvider);

    try {
      final allPlayers = await apiClient.getMarketAvailable(leagueId);
      return allPlayers.where((p) => watchlist.contains(p.id)).toList();
    } catch (e) {
      throw Exception('Failed to load watchlist: $e');
    }
  },
);
