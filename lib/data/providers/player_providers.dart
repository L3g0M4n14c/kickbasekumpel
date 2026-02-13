import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/player_model.dart';
import '../models/lineup_model.dart';
import '../../domain/repositories/repository_interfaces.dart';
import 'repository_providers.dart';
import 'league_providers.dart';
import 'live_providers.dart';

// ============================================================================
// PLAYER STREAM PROVIDERS
// ============================================================================

/// All Players Stream Provider
/// Provides real-time updates of all players
/// Warning: Can be large dataset, use with filters
final allPlayersStreamProvider = StreamProvider<List<Player>>((ref) async* {
  final playerRepo = ref.watch(playerRepositoryProvider);

  await for (final result in playerRepo.watchAll()) {
    if (result is Success<List<Player>>) {
      yield result.data;
    } else if (result is Failure<List<Player>>) {
      throw Exception((result).message);
    }
  }
});

/// All Players Provider (Future version)
/// Fetches all players once
final allPlayersProvider = FutureProvider<List<Player>>((ref) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getAll();

  if (result is Success<List<Player>>) {
    return result.data;
  } else if (result is Failure<List<Player>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching players');
});

// ============================================================================
// PLAYER DETAIL PROVIDERS
// ============================================================================

/// Player Details Provider Family
/// Fetches specific player by ID
final playerDetailsProvider = FutureProvider.family<Player, String>((
  ref,
  playerId,
) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getById(playerId);

  if (result is Success<Player>) {
    return result.data;
  } else if (result is Failure<Player>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching player');
});

/// Player Details Stream Provider Family
/// Provides real-time updates for a specific player
final playerDetailsStreamProvider = StreamProvider.family<Player, String>((
  ref,
  playerId,
) async* {
  final playerRepo = ref.watch(playerRepositoryProvider);

  await for (final result in playerRepo.watchById(playerId)) {
    if (result is Success<Player>) {
      yield result.data;
    } else if (result is Failure<Player>) {
      throw Exception((result).message);
    }
  }
});

// ============================================================================
// PLAYER STATS PROVIDERS
// ============================================================================

/// Player Stats Provider Family
/// For future implementation of detailed player statistics
/// Currently returns Player data, extend with PlayerStats model
final playerStatsProvider = FutureProvider.family<Player, String>((
  ref,
  playerId,
) async {
  // TODO: Implement dedicated stats endpoint when available
  return ref.watch(playerDetailsProvider(playerId).future);
});

// ============================================================================
// PLAYER FILTER PROVIDERS
// ============================================================================

/// Players by Team Provider Family
/// Filters players by team ID
final playersByTeamProvider = FutureProvider.family<List<Player>, String>((
  ref,
  teamId,
) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getByTeam(teamId);

  if (result is Success<List<Player>>) {
    return result.data;
  } else if (result is Failure<List<Player>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching players by team');
});

/// Players by Position Provider Family
/// Filters players by position (1=Goalkeeper, 2=Defender, 3=Midfielder, 4=Forward)
final playersByPositionProvider = FutureProvider.family<List<Player>, int>((
  ref,
  position,
) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getByPosition(position);

  if (result is Success<List<Player>>) {
    return result.data;
  } else if (result is Failure<List<Player>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching players by position');
});

/// Player Filter Parameters
class PlayerFilterParams {
  final int? position;
  final String? teamId;
  final int? minMarketValue;
  final int? maxMarketValue;
  final double? minAveragePoints;

  const PlayerFilterParams({
    this.position,
    this.teamId,
    this.minMarketValue,
    this.maxMarketValue,
    this.minAveragePoints,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerFilterParams &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          teamId == other.teamId &&
          minMarketValue == other.minMarketValue &&
          maxMarketValue == other.maxMarketValue &&
          minAveragePoints == other.minAveragePoints;

  @override
  int get hashCode =>
      position.hashCode ^
      teamId.hashCode ^
      minMarketValue.hashCode ^
      maxMarketValue.hashCode ^
      minAveragePoints.hashCode;
}

/// Filtered Players Provider
/// Advanced filtering with multiple parameters
final filteredPlayersProvider =
    FutureProvider.family<List<Player>, PlayerFilterParams>((
      ref,
      params,
    ) async {
      final playerRepo = ref.watch(playerRepositoryProvider);
      final result = await playerRepo.filterPlayers(
        position: params.position,
        teamId: params.teamId,
        minMarketValue: params.minMarketValue,
        maxMarketValue: params.maxMarketValue,
        minAveragePoints: params.minAveragePoints,
      );

      if (result is Success<List<Player>>) {
        return result.data;
      } else if (result is Failure<List<Player>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error filtering players');
    });

// ============================================================================
// TOP PLAYERS PROVIDERS
// ============================================================================

/// Top Players Provider
/// Fetches top performing players
final topPlayersProvider = FutureProvider.family<List<Player>, int>((
  ref,
  limit,
) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getTopPlayers(limit: limit);

  if (result is Success<List<Player>>) {
    return result.data;
  } else if (result is Failure<List<Player>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching top players');
});

/// Top Players by Points (default 20)
final topPlayersByPointsProvider = FutureProvider<List<Player>>((ref) async {
  return ref.watch(topPlayersProvider(20).future);
});

/// Top Players by Market Value
final topPlayersByValueProvider = FutureProvider.family<List<Player>, int>((
  ref,
  limit,
) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getTopPlayers(
    limit: limit,
    orderBy: 'marketValue',
  );

  if (result is Success<List<Player>>) {
    return result.data;
  } else if (result is Failure<List<Player>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching top players by value');
});

// ============================================================================
// PLAYER SEARCH PROVIDERS
// ============================================================================

/// Search Players by Name Provider
/// Family provider for searching players
final searchPlayersProvider = FutureProvider.family<List<Player>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }

  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.searchByName(query);

  if (result is Success<List<Player>>) {
    return result.data;
  } else if (result is Failure<List<Player>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error searching players');
});

// ============================================================================
// PLAYER OWNERSHIP PROVIDERS
// ============================================================================

/// Player Ownership Provider
/// Checks if a player is owned in a specific league
class PlayerOwnershipParams {
  final String playerId;
  final String leagueId;

  const PlayerOwnershipParams({required this.playerId, required this.leagueId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerOwnershipParams &&
          runtimeType == other.runtimeType &&
          playerId == other.playerId &&
          leagueId == other.leagueId;

  @override
  int get hashCode => playerId.hashCode ^ leagueId.hashCode;
}

final playerOwnershipProvider =
    FutureProvider.family<bool, PlayerOwnershipParams>((ref, params) async {
      final playerRepo = ref.watch(playerRepositoryProvider);
      final result = await playerRepo.isPlayerOwned(
        playerId: params.playerId,
        leagueId: params.leagueId,
      );

      if (result is Success<bool>) {
        return result.data;
      } else if (result is Failure<bool>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error checking player ownership');
    });

// ============================================================================
// COMPUTED PROVIDERS
// ============================================================================

/// Owned Player IDs Provider
/// Returns list of owned player ids for given league
final ownedPlayerIdsProvider = FutureProvider.family<List<String>, String>((
  ref,
  leagueId,
) async {
  final playerRepo = ref.watch(playerRepositoryProvider);
  final result = await playerRepo.getOwnedPlayerIds(leagueId);

  if (result is Success<List<String>>) {
    return result.data;
  } else if (result is Failure<List<String>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching owned player ids');
});

/// Available Players Provider
/// Returns players not owned by current user in selected league
final availablePlayersProvider = FutureProvider<List<Player>>((ref) async {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return [];

  final players = await ref.watch(allPlayersProvider.future);
  final ownedIds = await ref.watch(ownedPlayerIdsProvider(leagueId).future);

  return players.where((player) => !ownedIds.contains(player.id)).toList();
});

/// Affordable Players Provider
/// Returns players within user's budget in selected league
final affordablePlayersProvider = FutureProvider<List<Player>>((ref) async {
  final leagueId = ref.watch(selectedLeagueIdProvider);
  if (leagueId == null) return [];

  final league = ref.watch(selectedLeagueProvider);
  if (league == null) return [];

  final userBudget = league.cu.budget;
  final players = await ref.watch(availablePlayersProvider.future);

  return players.where((player) => player.marketValue <= userBudget).toList();
});

/// Best Value Players Provider
/// Players sorted by points per million market value
final bestValuePlayersProvider = FutureProvider.family<List<Player>, int>((
  ref,
  limit,
) async {
  final players = await ref.watch(allPlayersProvider.future);

  final playersWithValue = players.map((player) {
    final pointsPerMillion = player.marketValue > 0
        ? player.totalPoints / (player.marketValue / 1000000)
        : 0.0;
    return MapEntry(player, pointsPerMillion);
  }).toList()..sort((a, b) => b.value.compareTo(a.value));

  return playersWithValue.take(limit).map((entry) => entry.key).toList();
});

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*
/// Example 1: Display all players
class PlayerListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(allPlayersProvider);

    return playersAsync.when(
      data: (players) => ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(player.profileBigUrl),
            ),
            title: Text('${player.firstName} ${player.lastName}'),
            subtitle: Text('${player.teamName} - Pos: ${player.position}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${player.marketValue}€'),
                Text('${player.totalPoints} pts'),
              ],
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 2: Player detail view with real-time updates
class PlayerDetailWidget extends ConsumerWidget {
  final String playerId;

  const PlayerDetailWidget({required this.playerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerDetailsStreamProvider(playerId));

    return playerAsync.when(
      data: (player) => Column(
        children: [
          Image.network(player.profileBigUrl, height: 200),
          Text(
            '${player.firstName} ${player.lastName}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text('${player.teamName} - #${player.number}'),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatCard('Market Value', '${player.marketValue}€'),
              _StatCard('Total Points', '${player.totalPoints}'),
              _StatCard('Avg Points', '${player.averagePoints.toStringAsFixed(1)}'),
            ],
          ),
          if (player.marketValueTrend != 0)
            Icon(
              player.marketValueTrend > 0 
                ? Icons.trending_up 
                : Icons.trending_down,
              color: player.marketValueTrend > 0 
                ? Colors.green 
                : Colors.red,
            ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 3: Filter players by position
class PlayersByPositionWidget extends ConsumerWidget {
  final int position;

  const PlayersByPositionWidget({required this.position});

  String get positionName {
    switch (position) {
      case 1: return 'Goalkeepers';
      case 2: return 'Defenders';
      case 3: return 'Midfielders';
      case 4: return 'Forwards';
      default: return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersByPositionProvider(position));

    return playersAsync.when(
      data: (players) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(positionName, style: Theme.of(context).textTheme.headlineSmall),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text('${player.firstName} ${player.lastName}'),
                subtitle: Text(player.teamName),
                trailing: Text('${player.totalPoints} pts'),
              );
            },
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 4: Search players
class PlayerSearchWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<PlayerSearchWidget> createState() => _PlayerSearchWidgetState();
}

class _PlayerSearchWidgetState extends ConsumerState<PlayerSearchWidget> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchPlayersProvider(searchQuery));

    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search players...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        Expanded(
          child: searchAsync.when(
            data: (players) => ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(player.profileBigUrl),
                  ),
                  title: Text('${player.firstName} ${player.lastName}'),
                  subtitle: Text(player.teamName),
                );
              },
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }
}

/// Example 5: Top players leaderboard
class TopPlayersWidget extends ConsumerWidget {
  final int limit;

  const TopPlayersWidget({this.limit = 10});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPlayersAsync = ref.watch(topPlayersProvider(limit));

    return topPlayersAsync.when(
      data: (players) => ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text('${player.firstName} ${player.lastName}'),
            subtitle: Text(player.teamName),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${player.totalPoints} pts', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${player.averagePoints.toStringAsFixed(1)} avg'),
              ],
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 6: Advanced player filtering
class FilteredPlayersWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = PlayerFilterParams(
      position: 4, // Forwards
      minMarketValue: 1000000,
      maxMarketValue: 5000000,
      minAveragePoints: 5.0,
    );

    final playersAsync = ref.watch(filteredPlayersProvider(params));

    return playersAsync.when(
      data: (players) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Forwards (€1M-5M, >5 avg pts): ${players.length} found'),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  title: Text('${player.firstName} ${player.lastName}'),
                  subtitle: Text('${player.teamName} - ${player.averagePoints.toStringAsFixed(1)} avg'),
                  trailing: Text('${player.marketValue}€'),
                );
              },
            ),
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 7: Check player ownership
class PlayerOwnershipChecker extends ConsumerWidget {
  final String playerId;

  const PlayerOwnershipChecker({required this.playerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    
    if (leagueId == null) {
      return Text('Select a league first');
    }

    final params = PlayerOwnershipParams(
      playerId: playerId,
      leagueId: leagueId,
    );
    
    final ownershipAsync = ref.watch(playerOwnershipProvider(params));

    return ownershipAsync.when(
      data: (isOwned) => Chip(
        label: Text(isOwned ? 'Owned' : 'Available'),
        backgroundColor: isOwned ? Colors.red : Colors.green,
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error'),
    );
  }
}

/// Example 8: Best value players
class BestValuePlayersWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(bestValuePlayersProvider(10));

    return playersAsync.when(
      data: (players) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Best Value Players', 
            style: Theme.of(context).textTheme.headlineSmall),
          ListView.builder(
            shrinkWrap: true,
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final pointsPerMillion = player.marketValue > 0 
                  ? player.totalPoints / (player.marketValue / 1000000)
                  : 0.0;
              
              return ListTile(
                title: Text('${player.firstName} ${player.lastName}'),
                subtitle: Text('${player.totalPoints} pts / €${player.marketValue}'),
                trailing: Text(
                  '${pointsPerMillion.toStringAsFixed(1)} pts/M€',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
*/

// ============================================================================
// LINEUP PROVIDERS
// ============================================================================

/// My Lineup Provider
/// Fetches current lineup with player details
final myLineupProvider = FutureProvider.family<List<LineupPlayer>, String>((
  ref,
  leagueId,
) async {
  final myElevenData = await ref.watch(myElevenProvider(leagueId).future);

  try {
    final response = LineupResponse.fromJson(myElevenData);
    return response.players;
  } catch (e) {
    throw Exception('Failed to parse lineup: $e');
  }
});
