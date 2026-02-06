import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transfer_model.dart';
import '../../domain/repositories/repository_interfaces.dart';
import 'repository_providers.dart';
import 'user_providers.dart';
import 'league_providers.dart';

// ============================================================================
// TRANSFER STREAM PROVIDERS
// ============================================================================

/// All Transfers Stream Provider
/// Provides real-time updates of all transfers
/// Warning: Can be large dataset, prefer filtered versions
final allTransfersStreamProvider = StreamProvider<List<Transfer>>((ref) async* {
  final transferRepo = ref.watch(transferRepositoryProvider);

  await for (final result in transferRepo.watchAll()) {
    if (result is Success<List<Transfer>>) {
      yield result.data;
    } else if (result is Failure<List<Transfer>>) {
      throw Exception((result).message);
    }
  }
});

// ============================================================================
// USER TRANSFER PROVIDERS
// ============================================================================

/// User Transfers Stream Provider
/// Provides real-time updates of current user's transfers (sent and received)
final userTransfersProvider = StreamProvider<List<Transfer>>((ref) async* {
  final userId = ref.watch(currentAuthUserIdProvider);

  if (userId == null) {
    yield [];
    return;
  }

  final transferRepo = ref.watch(transferRepositoryProvider);
  final result = await transferRepo.getByUser(userId);

  if (result is Success<List<Transfer>>) {
    yield result.data;
  } else if (result is Failure<List<Transfer>>) {
    throw Exception((result).message);
  }
});

/// User Transfers Provider (Future version)
/// Fetches current user's transfers once
final userTransfersFutureProvider = FutureProvider<List<Transfer>>((ref) async {
  final userId = ref.watch(currentAuthUserIdProvider);

  if (userId == null) {
    return [];
  }

  final transferRepo = ref.watch(transferRepositoryProvider);
  final result = await transferRepo.getByUser(userId);

  if (result is Success<List<Transfer>>) {
    return result.data;
  } else if (result is Failure<List<Transfer>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching user transfers');
});

// ============================================================================
// LEAGUE TRANSFER PROVIDERS
// ============================================================================

/// League Transfers Stream Provider Family
/// Provides real-time updates of all transfers in a specific league
final leagueTransfersProvider = StreamProvider.family<List<Transfer>, String>((
  ref,
  leagueId,
) async* {
  final transferRepo = ref.watch(transferRepositoryProvider);
  final result = await transferRepo.getByLeague(leagueId);

  if (result is Success<List<Transfer>>) {
    yield result.data;
  } else if (result is Failure<List<Transfer>>) {
    throw Exception((result).message);
  }
});

/// League Transfers Provider (Future version)
/// Fetches all transfers in a specific league once
final leagueTransfersFutureProvider =
    FutureProvider.family<List<Transfer>, String>((ref, leagueId) async {
      final transferRepo = ref.watch(transferRepositoryProvider);
      final result = await transferRepo.getByLeague(leagueId);

      if (result is Success<List<Transfer>>) {
        return result.data;
      } else if (result is Failure<List<Transfer>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching league transfers');
    });

/// Selected League Transfers Provider
/// Automatically fetches transfers for the currently selected league
final selectedLeagueTransfersProvider = StreamProvider<List<Transfer>>((
  ref,
) async* {
  final leagueId = ref.watch(selectedLeagueIdProvider);

  if (leagueId == null) {
    yield [];
    return;
  }

  final transferRepo = ref.watch(transferRepositoryProvider);
  final result = await transferRepo.getByLeague(leagueId);

  if (result is Success<List<Transfer>>) {
    yield result.data;
  } else if (result is Failure<List<Transfer>>) {
    throw Exception((result).message);
  }
});

// ============================================================================
// PLAYER TRANSFER PROVIDERS
// ============================================================================

/// Player Transfers Provider Family
/// Fetches all transfers involving a specific player
final playerTransfersProvider = FutureProvider.family<List<Transfer>, String>((
  ref,
  playerId,
) async {
  final transferRepo = ref.watch(transferRepositoryProvider);
  final result = await transferRepo.getByPlayer(playerId);

  if (result is Success<List<Transfer>>) {
    return result.data;
  } else if (result is Failure<List<Transfer>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching player transfers');
});

// ============================================================================
// RECENT TRANSFERS PROVIDERS
// ============================================================================

/// Recent League Transfers Provider
/// Fetches most recent transfers in a league
class RecentTransfersParams {
  final String leagueId;
  final int limit;

  const RecentTransfersParams({required this.leagueId, this.limit = 20});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTransfersParams &&
          runtimeType == other.runtimeType &&
          leagueId == other.leagueId &&
          limit == other.limit;

  @override
  int get hashCode => leagueId.hashCode ^ limit.hashCode;
}

final recentLeagueTransfersProvider =
    FutureProvider.family<List<Transfer>, RecentTransfersParams>((
      ref,
      params,
    ) async {
      final transferRepo = ref.watch(transferRepositoryProvider);
      final result = await transferRepo.getRecentTransfers(
        leagueId: params.leagueId,
        limit: params.limit,
      );

      if (result is Success<List<Transfer>>) {
        return result.data;
      } else if (result is Failure<List<Transfer>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching recent transfers');
    });

/// Recent Selected League Transfers Provider
/// Fetches recent transfers for currently selected league
final recentSelectedLeagueTransfersProvider =
    FutureProvider.family<List<Transfer>, int>((ref, limit) async {
      final leagueId = ref.watch(selectedLeagueIdProvider);

      if (leagueId == null) {
        return [];
      }

      final params = RecentTransfersParams(leagueId: leagueId, limit: limit);
      return ref.watch(recentLeagueTransfersProvider(params).future);
    });

// ============================================================================
// TRANSFER REVIEW PROVIDERS
// ============================================================================

/// Transfers to Review Provider
/// Returns transfers that need review/approval (pending status)
/// For future implementation when transfer approval system is added
final transfersToReviewProvider = StreamProvider<List<Transfer>>((ref) async* {
  final leagueId = ref.watch(selectedLeagueIdProvider);

  if (leagueId == null) {
    yield [];
    return;
  }

  // Get all league transfers
  final transferRepo = ref.watch(transferRepositoryProvider);
  final result = await transferRepo.getByLeague(leagueId);

  if (result is Success<List<Transfer>>) {
    // TODO: Filter by status when transfer status field is available
    // For now, return all transfers
    yield result.data;
  } else if (result is Failure<List<Transfer>>) {
    throw Exception((result).message);
  }
});

/// Pending Transfers Count Provider
/// Counts transfers awaiting review
final pendingTransfersCountProvider = Provider<int>((ref) {
  final transfersAsync = ref.watch(transfersToReviewProvider);
  return transfersAsync.when(
    data: (transfers) => transfers.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// ============================================================================
// TRANSFER STATISTICS PROVIDERS
// ============================================================================

/// Transfer Statistics Provider Family
/// Fetches transfer statistics for a specific league
final transferStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, leagueId) async {
      final transferRepo = ref.watch(transferRepositoryProvider);
      final result = await transferRepo.getTransferStats(leagueId);

      if (result is Success<Map<String, dynamic>>) {
        return result.data;
      } else if (result is Failure<Map<String, dynamic>>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error fetching transfer stats');
    });

/// Selected League Transfer Statistics Provider
/// Fetches statistics for currently selected league
final selectedLeagueTransferStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
      final leagueId = ref.watch(selectedLeagueIdProvider);

      if (leagueId == null) {
        return {};
      }

      return ref.watch(transferStatsProvider(leagueId).future);
    });

// ============================================================================
// COMPUTED PROVIDERS
// ============================================================================

/// User Sent Transfers Provider
/// Filters user transfers to only sent transfers
final userSentTransfersProvider = Provider<List<Transfer>>((ref) {
  final userId = ref.watch(currentAuthUserIdProvider);
  if (userId == null) return [];

  final transfersAsync = ref.watch(userTransfersProvider);
  return transfersAsync.when(
    data: (transfers) =>
        transfers.where((t) => t.fromUserId == userId).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// User Received Transfers Provider
/// Filters user transfers to only received transfers
final userReceivedTransfersProvider = Provider<List<Transfer>>((ref) {
  final userId = ref.watch(currentAuthUserIdProvider);
  if (userId == null) return [];

  final transfersAsync = ref.watch(userTransfersProvider);
  return transfersAsync.when(
    data: (transfers) => transfers.where((t) => t.toUserId == userId).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// User Total Transfer Volume Provider
/// Calculates total transfer volume (sent + received)
final userTotalTransferVolumeProvider = Provider<int>((ref) {
  final transfersAsync = ref.watch(userTransfersProvider);
  return transfersAsync.when(
    data: (transfers) =>
        transfers.fold<int>(0, (sum, transfer) => sum + transfer.price),
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// User Total Transfers Count Provider
/// Counts total number of user transfers
final userTotalTransfersCountProvider = Provider<int>((ref) {
  final transfersAsync = ref.watch(userTransfersProvider);
  return transfersAsync.when(
    data: (transfers) => transfers.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

// ============================================================================
// TRANSFER VALIDATION PROVIDER
// ============================================================================

/// Transfer Validation Parameters
class TransferValidationParams {
  final String leagueId;
  final String fromUserId;
  final String toUserId;
  final String playerId;
  final int price;

  const TransferValidationParams({
    required this.leagueId,
    required this.fromUserId,
    required this.toUserId,
    required this.playerId,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferValidationParams &&
          runtimeType == other.runtimeType &&
          leagueId == other.leagueId &&
          fromUserId == other.fromUserId &&
          toUserId == other.toUserId &&
          playerId == other.playerId &&
          price == other.price;

  @override
  int get hashCode =>
      leagueId.hashCode ^
      fromUserId.hashCode ^
      toUserId.hashCode ^
      playerId.hashCode ^
      price.hashCode;
}

/// Transfer Validation Provider
/// Validates if a transfer can be executed
final transferValidationProvider =
    FutureProvider.family<bool, TransferValidationParams>((ref, params) async {
      final transferRepo = ref.watch(transferRepositoryProvider);
      final result = await transferRepo.validateTransfer(
        leagueId: params.leagueId,
        fromUserId: params.fromUserId,
        toUserId: params.toUserId,
        playerId: params.playerId,
        price: params.price,
      );

      if (result is Success<bool>) {
        return result.data;
      } else if (result is Failure<bool>) {
        throw Exception((result).message);
      }
      throw Exception('Unknown error validating transfer');
    });

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*
/// Example 1: Display user transfers
class UserTransfersWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(userTransfersProvider);

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return Center(child: Text('No transfers yet'));
        }
        
        return ListView.builder(
          itemCount: transfers.length,
          itemBuilder: (context, index) {
            final transfer = transfers[index];
            return ListTile(
              leading: Icon(
                transfer.fromUserId == ref.watch(currentAuthUserIdProvider)
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: transfer.fromUserId == ref.watch(currentAuthUserIdProvider)
                    ? Colors.red
                    : Colors.green,
              ),
              title: Text('Player ID: ${transfer.playerId}'),
              subtitle: Text('Price: ${transfer.price}€'),
              trailing: Text(transfer.timestamp.toString()),
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 2: League transfer feed with real-time updates
class LeagueTransferFeedWidget extends ConsumerWidget {
  final String leagueId;

  const LeagueTransferFeedWidget({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(leagueTransfersProvider(leagueId));

    // Listen for new transfers and show notification
    ref.listen<AsyncValue<List<Transfer>>>(
      leagueTransfersProvider(leagueId),
      (previous, next) {
        if (previous?.hasValue == true && next.hasValue) {
          final prevCount = previous!.value!.length;
          final newCount = next.value!.length;
          
          if (newCount > prevCount) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${newCount - prevCount} new transfer(s)!')),
            );
          }
        }
      },
    );

    return transfersAsync.when(
      data: (transfers) {
        final sorted = transfers.toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by date descending
        
        return ListView.builder(
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final transfer = sorted[index];
            return Card(
              child: ListTile(
                title: Text('Transfer: ${transfer.playerId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${transfer.fromUserId}'),
                    Text('To: ${transfer.toUserId}'),
                    Text('Price: ${transfer.price}€'),
                  ],
                ),
                trailing: Text(_formatDate(transfer.timestamp)),
              ),
            );
          },
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Example 3: Recent transfers widget
class RecentTransfersWidget extends ConsumerWidget {
  final int limit;

  const RecentTransfersWidget({this.limit = 10});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(
      recentSelectedLeagueTransfersProvider(limit),
    );

    return transfersAsync.when(
      data: (transfers) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Transfers', 
            style: Theme.of(context).textTheme.headlineSmall),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              return ListTile(
                dense: true,
                title: Text('${transfer.price}€'),
                subtitle: Text('Player: ${transfer.playerId}'),
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

/// Example 4: Transfer statistics dashboard
class TransferStatsDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(selectedLeagueTransferStatsProvider);
    final userVolume = ref.watch(userTotalTransferVolumeProvider);
    final userCount = ref.watch(userTotalTransfersCountProvider);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Your Transfer Activity'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('$userCount', style: TextStyle(fontSize: 24)),
                        Text('Total Transfers'),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$userVolume€', style: TextStyle(fontSize: 24)),
                        Text('Total Volume'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        statsAsync.when(
          data: (stats) => Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('League Statistics'),
                  // Display stats from map
                  ...stats.entries.map((entry) => 
                    ListTile(
                      title: Text(entry.key),
                      trailing: Text(entry.value.toString()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => Text('Error loading stats'),
        ),
      ],
    );
  }
}

/// Example 5: Transfer validation before submission
class TransferFormWidget extends ConsumerStatefulWidget {
  final String playerId;

  const TransferFormWidget({required this.playerId});

  @override
  ConsumerState<TransferFormWidget> createState() => _TransferFormWidgetState();
}

class _TransferFormWidgetState extends ConsumerState<TransferFormWidget> {
  final priceController = TextEditingController();
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    final leagueId = ref.watch(selectedLeagueIdProvider);
    final currentUserId = ref.watch(currentAuthUserIdProvider);

    if (leagueId == null || currentUserId == null) {
      return Text('Please select a league');
    }

    return Column(
      children: [
        TextField(
          controller: priceController,
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
        // Add user selection dropdown here
        ElevatedButton(
          onPressed: () => _validateAndSubmit(context, leagueId, currentUserId),
          child: Text('Submit Transfer'),
        ),
      ],
    );
  }

  Future<void> _validateAndSubmit(
    BuildContext context,
    String leagueId,
    String fromUserId,
  ) async {
    if (selectedUserId == null) return;

    final params = TransferValidationParams(
      leagueId: leagueId,
      fromUserId: fromUserId,
      toUserId: selectedUserId!,
      playerId: widget.playerId,
      price: int.tryParse(priceController.text) ?? 0,
    );

    final validationAsync = ref.read(transferValidationProvider(params));
    
    try {
      final isValid = await validationAsync.future;
      
      if (isValid) {
        // Proceed with transfer creation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer validated, submitting...')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer validation failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

/// Example 6: Sent vs Received transfers comparison
class TransferBalanceWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sent = ref.watch(userSentTransfersProvider);
    final received = ref.watch(userReceivedTransfersProvider);

    final sentValue = sent.fold<int>(0, (sum, t) => sum + t.price);
    final receivedValue = received.fold<int>(0, (sum, t) => sum + t.price);
    final balance = receivedValue - sentValue;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Transfer Balance', 
              style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BalanceColumn('Sent', sentValue, sent.length, Colors.red),
                _BalanceColumn('Received', receivedValue, received.length, Colors.green),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Net: ${balance >= 0 ? "+" : ""}$balance€',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _BalanceColumn(String label, int value, int count, Color color) {
  return Column(
    children: [
      Text(label, style: TextStyle(color: color)),
      Text('$value€', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text('$count transfers', style: TextStyle(fontSize: 12)),
    ],
  );
}

/// Example 7: Player transfer history
class PlayerTransferHistoryWidget extends ConsumerWidget {
  final String playerId;

  const PlayerTransferHistoryWidget({required this.playerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(playerTransfersProvider(playerId));

    return transfersAsync.when(
      data: (transfers) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transfer History', 
            style: Theme.of(context).textTheme.headlineSmall),
          Text('${transfers.length} transfers'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final transfer = transfers[index];
              return ListTile(
                leading: Icon(Icons.swap_horiz),
                title: Text('${transfer.price}€'),
                subtitle: Text('${transfer.fromUserId} → ${transfer.toUserId}'),
                trailing: Text(_formatDate(transfer.timestamp)),
              );
            },
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
*/
