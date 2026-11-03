import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/market_model.dart';
import '../../data/models/transfer_model.dart';
import '../../data/providers/bid_limit_providers.dart';
import '../../data/providers/kickbase_api_provider.dart';
import '../../data/providers/kickbase_auth_provider.dart';
import '../../data/providers/league_detail_providers.dart';
import '../../data/providers/league_providers.dart';
import '../../data/providers/user_providers.dart';
import '../../domain/exceptions/kickbase_exceptions.dart';

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
    this.sortOption = MarketSortOption.expiry,
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
  expiry,
  marketValue,
  marketValueDesc,
  marketValueTrendDesc,
  points,
  pointsDesc,
  position,
  price,
  priceDesc,
  averagePoints,
  averagePointsDesc,
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

    // Tagestrends nur laden, wenn danach sortiert wird
    final trends = filter.sortOption == MarketSortOption.marketValueTrendDesc
        ? await ref.watch(marketDailyTrendsProvider.future)
        : const <String, int>{};

    // Apply filters and sorting
    final filtered = _applyFiltersAndSort(players, filter, trends);
    yield filtered;

    // Poll for updates every 30 seconds
    await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
      try {
        final updatedPlayers = await apiClient.getMarketAvailable(leagueId);
        final filteredUpdated = _applyFiltersAndSort(
          updatedPlayers,
          filter,
          trends,
        );
        yield filteredUpdated;
      } catch (e) {
        // Continue with previous data on polling error
        if (e is AuthenticationException || e is AuthorizationException) {
          rethrow; // Re-throw auth errors to notify user
        }
      }
    }
  } on AuthenticationException catch (e) {
    // 401 – Token ungültig → Logout erzwingen
    ref.read(kickbaseAuthProvider.notifier).handleSessionExpired();
    throw Exception(
      'Deine Kickbase-Sitzung ist abgelaufen. Bitte melde dich erneut an.\n(${e.message})',
    );
  } on AuthorizationException catch (e) {
    // 403 – Token abgelaufen/widerrufen → Logout erzwingen
    ref.read(kickbaseAuthProvider.notifier).handleSessionExpired();
    throw Exception(
      'Deine Kickbase-Sitzung ist abgelaufen. Bitte melde dich erneut an.\n(${e.message})',
    );
  } catch (e) {
    throw Exception('Fehler beim Laden der Spieler: $e');
  }
});

/// Anzahl paralleler Spielerdetail-Requests beim Laden der Tagestrends
const _dailyTrendBatchSize = 5;

/// Echter Marktwert-Tagestrend in Euro (Kickbase `tfhmvt`) je Spieler-ID der
/// aktuellen Marktspieler.
///
/// Der Markt-Endpunkt liefert nur `mvt` – einen Richtungs-Code (steigend/
/// fallend), keinen Betrag. Den Euro-Trend der letzten 24 h gibt es nur über
/// `GET /leagues/{id}/players/{playerId}`. Spieler, deren Details nicht geladen
/// werden konnten, fehlen in der Map.
final marketDailyTrendsProvider = FutureProvider.autoDispose<Map<String, int>>((
  ref,
) async {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return {};

  final apiClient = ref.watch(kickbaseApiClientProvider);
  final players = await apiClient.getMarketAvailable(leagueId);

  final trends = <String, int>{};
  for (var i = 0; i < players.length; i += _dailyTrendBatchSize) {
    final batch = players.skip(i).take(_dailyTrendBatchSize);
    await Future.wait(
      batch.map((player) async {
        try {
          final details = await apiClient.getPlayerDetails(leagueId, player.id);
          final trend = details['tfhmvt'];
          if (trend is num) trends[player.id] = trend.toInt();
        } catch (_) {
          // Einzelne fehlende Details blockieren die übrigen Trends nicht
        }
      }),
    );
  }
  return trends;
});

/// Apply filters and sorting to market players
///
/// [dailyTrends]: Euro-Tagestrend je Spieler-ID (siehe
/// [marketDailyTrendsProvider]), nur für die Trend-Sortierung nötig.
List<MarketPlayer> _applyFiltersAndSort(
  List<MarketPlayer> players,
  MarketFilterState filter, [
  Map<String, int> dailyTrends = const {},
]) {
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
    case MarketSortOption.expiry:
      filtered.sort((a, b) {
        final dateA = DateTime.tryParse(a.expiry) ?? DateTime.utc(9999);
        final dateB = DateTime.tryParse(b.expiry) ?? DateTime.utc(9999);
        return dateA.compareTo(dateB);
      });
      break;
    case MarketSortOption.marketValue:
      filtered.sort((a, b) => a.marketValue.compareTo(b.marketValue));
      break;
    case MarketSortOption.marketValueDesc:
      filtered.sort((a, b) => b.marketValue.compareTo(a.marketValue));
      break;
    case MarketSortOption.marketValueTrendDesc:
      // Spieler ohne geladenen Trend landen am Ende
      filtered.sort((a, b) {
        final trendA = dailyTrends[a.id];
        final trendB = dailyTrends[b.id];
        if (trendA == null || trendB == null) {
          return (trendA == null ? 1 : 0) - (trendB == null ? 1 : 0);
        }
        return trendB.compareTo(trendA);
      });
      break;
    case MarketSortOption.points:
      filtered.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
      break;
    case MarketSortOption.pointsDesc:
      filtered.sort((a, b) => a.totalPoints.compareTo(b.totalPoints));
      break;
    case MarketSortOption.position:
      filtered.sort((a, b) => a.position.compareTo(b.position));
      break;
    case MarketSortOption.price:
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case MarketSortOption.priceDesc:
      filtered.sort((a, b) => b.price.compareTo(a.price));
      break;
    case MarketSortOption.averagePoints:
      filtered.sort((a, b) => b.averagePoints.compareTo(a.averagePoints));
      break;
    case MarketSortOption.averagePointsDesc:
      filtered.sort((a, b) => a.averagePoints.compareTo(b.averagePoints));
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

class BuyPlayerNotifier extends Notifier<AsyncValue<OfferResponse?>> {
  @override
  AsyncValue<OfferResponse?> build() => const AsyncValue.data(null);

  /// Gibt ein Gebot über [price] € auf [playerId] ab.
  ///
  /// Kickbase versteigert Marktspieler: das Gebot wird erst bei Ablauf des
  /// Angebots entschieden. Der Kontostand ändert sich daher nicht sofort,
  /// das Gebot zählt aber ab jetzt zu den offenen Geboten (33 %-Regel).
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

      // Markt (eigene Gebote) und Budget-Grenzen neu laden
      ref.invalidate(marketPlayersProvider);
      ref.invalidate(myBudgetProvider(leagueId));
      ref.invalidate(bidLimitProvider);

      // Clear selected player
      ref.read(selectedPlayerProvider.notifier).state = null;
    } catch (e, stack) {
      state = AsyncValue.error(buyErrorMessage(e), stack);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Nutzerfreundliche Fehlermeldung für ein fehlgeschlagenes Gebot.
String buyErrorMessage(Object error) {
  if (error is AuthenticationException) {
    return 'Sitzung abgelaufen – bitte erneut anmelden';
  }
  if (error is NetworkException || error is TimeoutException) {
    return 'Keine Verbindung zu Kickbase – bitte später erneut versuchen';
  }
  if (error is RateLimitException) {
    return 'Zu viele Anfragen – bitte kurz warten';
  }
  final message = error is KickbaseException ? error.message : '$error';
  final lower = message.toLowerCase();
  if (lower.contains('insufficient') || lower.contains('budget')) {
    return 'Nicht genügend Budget verfügbar ($message)';
  }
  if (lower.contains('expired')) {
    return 'Angebot ist abgelaufen';
  }
  return message;
}

/// Buy player state
final buyPlayerProvider =
    NotifierProvider<BuyPlayerNotifier, AsyncValue<OfferResponse?>>(
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
// WATCHLIST PROVIDER (using API)
// ============================================================================

/// Get watchlist players from API
final watchlistPlayersProvider = FutureProvider.autoDispose<List<MarketPlayer>>(
  (ref) async {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    if (leagueId == null) return [];

    final apiClient = ref.watch(kickbaseApiClientProvider);

    try {
      final response = await apiClient.getScoutedPlayers(leagueId);
      final playersList = response['players'] as List?;

      if (playersList == null || playersList.isEmpty) return [];

      return playersList
          .map((p) => MarketPlayer.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load watchlist: $e');
    }
  },
);

// ============================================================================
// MY OFFERS PROVIDER (Players with bids from others)
// ============================================================================

/// Get players where the user is the seller and has received offers
final myOffersPlayersProvider = FutureProvider.autoDispose<List<MarketPlayer>>((
  ref,
) async {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return [];

  final apiClient = ref.watch(kickbaseApiClientProvider);
  final currentUser = ref.watch(currentUserProvider).value;

  if (currentUser == null) return [];

  try {
    final allPlayers = await apiClient.getMarketAvailable(leagueId);

    // Filter for players being sold by current user WITH offers
    return allPlayers
        .where((p) => p.seller.id == currentUser.i && p.offers > 0)
        .toList();
  } catch (e) {
    throw Exception('Failed to load offers: $e');
  }
});
