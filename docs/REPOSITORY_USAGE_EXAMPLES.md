import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/firestore_repositories.dart';
import '../data/models/user_model.dart';
import '../data/models/league_model.dart';
import '../data/models/player_model.dart';
import '../data/models/transfer_model.dart';
import '../domain/repositories/repository_interfaces.dart';

/// ============================================================================
/// Beispiele für die Verwendung der Firestore Repositories
/// ============================================================================

/// 1. USER REPOSITORY
/// ============================================================================

/// Beispiel: User erstellen
Future<void> createUserExample(WidgetRef ref) async {
  final userRepo = ref.read(userRepositoryProvider);

  final user = User(
    i: 'user123',
    n: 'Max Mustermann',
    tn: 'Team Thunder',
    em: 'max@example.com',
    b: 50000000, // 50M Budget
    tv: 100000000, // 100M Team Value
    p: 250, // Points
    pl: 5, // Placement
    f: 0,
  );

  final result = await userRepo.create(user);

  if (result is Success<User>) {
    print('User created: ${result.data.n}');
  } else if (result is Failure<User>) {
    print('Error: ${result.message}');
  }
}

/// Beispiel: User nach Email suchen
Future<void> getUserByEmailExample(WidgetRef ref) async {
  final userRepo = ref.read(userRepositoryProvider);

  final result = await userRepo.getByEmail('max@example.com');

  if (result is Success<User>) {
    print('User found: ${result.data.n}');
  } else if (result is Failure<User>) {
    print('Error: ${result.message}');
  }
}

/// Beispiel: User Stats aktualisieren
Future<void> updateUserStatsExample(WidgetRef ref) async {
  final userRepo = ref.read(userRepositoryProvider);

  final result = await userRepo.updateStats(
    id: 'user123',
    budget: 45000000,
    points: 275,
    placement: 4,
  );

  if (result is Success<User>) {
    print('Stats updated: ${result.data.p} points');
  }
}

/// Beispiel: Real-time User Stream
void watchUserExample(WidgetRef ref, String userId) {
  final userRepo = ref.read(userRepositoryProvider);

  userRepo.watchById(userId).listen((result) {
    if (result is Success<User>) {
      print('User updated: ${result.data.n}');
    }
  });
}

/// 2. LEAGUE REPOSITORY
/// ============================================================================

/// Beispiel: League erstellen
Future<void> createLeagueExample(WidgetRef ref) async {
  final leagueRepo = ref.read(leagueRepositoryProvider);

  final league = League(
    i: 'league123',
    cpi: '1',
    n: 'Champions Liga',
    cn: 'Max Mustermann',
    an: 'Max',
    c: 'user123',
    s: '2025/26',
    md: 20,
    cu: LeagueUser(
      id: 'user123',
      name: 'Max',
      teamName: 'Team Thunder',
      budget: 50000000,
      teamValue: 100000000,
      points: 250,
      placement: 1,
      won: 5,
      drawn: 2,
      lost: 1,
      se11: 11,
      ttm: 15,
    ),
  );

  final result = await leagueRepo.create(league);

  if (result is Success<League>) {
    print('League created: ${result.data.n}');
  }
}

/// Beispiel: Member zu League hinzufügen
Future<void> addLeagueMemberExample(WidgetRef ref) async {
  final leagueRepo = ref.read(leagueRepositoryProvider);

  final result = await leagueRepo.addMember(
    leagueId: 'league123',
    userId: 'user456',
  );

  if (result is Success<void>) {
    print('Member added successfully');
  }
}

/// Beispiel: League Standings aktualisieren
Future<void> updateStandingsExample(WidgetRef ref) async {
  final leagueRepo = ref.read(leagueRepositoryProvider);

  final standings = [
    LeagueUser(
      id: 'user123',
      name: 'Max',
      teamName: 'Team Thunder',
      budget: 50000000,
      teamValue: 100000000,
      points: 275,
      placement: 1,
      won: 6,
      drawn: 2,
      lost: 1,
      se11: 11,
      ttm: 15,
    ),
    // Weitere Spieler...
  ];

  await leagueRepo.updateStandings(leagueId: 'league123', standings: standings);
}

/// Beispiel: Real-time League Stream
void watchLeagueExample(WidgetRef ref, String leagueId) {
  final leagueRepo = ref.read(leagueRepositoryProvider);

  leagueRepo.watchById(leagueId).listen((result) {
    if (result is Success<League>) {
      print('League updated: ${result.data.n}, MD: ${result.data.md}');
    }
  });
}

/// 3. PLAYER REPOSITORY
/// ============================================================================

/// Beispiel: Players nach Position filtern
Future<void> getPlayersByPositionExample(WidgetRef ref) async {
  final playerRepo = ref.read(playerRepositoryProvider);

  final result = await playerRepo.getByPosition(1); // 1 = Torwart

  if (result is Success<List<Player>>) {
    print('Found ${result.data.length} goalkeepers');
    for (var player in result.data) {
      print('${player.firstName} ${player.lastName}');
    }
  }
}

/// Beispiel: Top Players abrufen
Future<void> getTopPlayersExample(WidgetRef ref) async {
  final playerRepo = ref.read(playerRepositoryProvider);

  final result = await playerRepo.getTopPlayers(
    limit: 10,
    orderBy: 'totalPoints',
  );

  if (result is Success<List<Player>>) {
    print('Top 10 Players:');
    for (var player in result.data) {
      print(
        '${player.firstName} ${player.lastName}: ${player.totalPoints} pts',
      );
    }
  }
}

/// Beispiel: Players mit komplexem Filter
Future<void> filterPlayersExample(WidgetRef ref) async {
  final playerRepo = ref.read(playerRepositoryProvider);

  final result = await playerRepo.filterPlayers(
    position: 3, // Mittelfeld
    minMarketValue: 5000000, // Min 5M
    maxMarketValue: 20000000, // Max 20M
    minAveragePoints: 7.0, // Min 7 Punkte/Spiel
  );

  if (result is Success<List<Player>>) {
    print('Filtered ${result.data.length} midfielders');
  }
}

/// Beispiel: Player Marktwert aktualisieren
Future<void> updatePlayerMarketValueExample(WidgetRef ref) async {
  final playerRepo = ref.read(playerRepositoryProvider);

  final result = await playerRepo.updateMarketValue(
    playerId: 'player123',
    newMarketValue: 15000000,
    trend: 2, // Aufwärtstrend
  );

  if (result is Success<Player>) {
    print(
      'Market value updated: ${result.data.marketValue} (trend: ${result.data.marketValueTrend})',
    );
  }
}

/// Beispiel: Batch Update für mehrere Spieler
Future<void> batchUpdatePlayersExample(WidgetRef ref) async {
  final playerRepo = ref.read(playerRepositoryProvider);

  final players = [
    // Liste von aktualisierten Spielern
  ];

  final result = await playerRepo.batchUpdate(players);

  if (result is Success<void>) {
    print('Batch update successful');
  }
}

/// 4. TRANSFER REPOSITORY
/// ============================================================================

/// Beispiel: Transfer erstellen mit Validation
Future<void> createTransferExample(WidgetRef ref) async {
  final transferRepo = ref.read(transferRepositoryProvider);

  final result = await transferRepo.createTransfer(
    leagueId: 'league123',
    fromUserId: 'user123',
    toUserId: 'user456',
    playerId: 'player789',
    price: 12000000,
    marketValue: 10000000,
  );

  if (result is Success<Transfer>) {
    print(
      'Transfer created: ${result.data.playerName} for ${result.data.price}',
    );
  } else if (result is Failure<Transfer>) {
    print('Transfer failed: ${result.message}');
  }
}

/// Beispiel: Transfers für League abrufen
Future<void> getLeagueTransfersExample(WidgetRef ref) async {
  final transferRepo = ref.read(transferRepositoryProvider);

  final result = await transferRepo.getByLeague('league123');

  if (result is Success<List<Transfer>>) {
    print('Total transfers: ${result.data.length}');
    for (var transfer in result.data) {
      print(
        '${transfer.playerName}: ${transfer.fromUsername} → ${transfer.toUsername} (${transfer.price})',
      );
    }
  }
}

/// Beispiel: Recent Transfers
Future<void> getRecentTransfersExample(WidgetRef ref) async {
  final transferRepo = ref.read(transferRepositoryProvider);

  final result = await transferRepo.getRecentTransfers(
    leagueId: 'league123',
    limit: 5,
  );

  if (result is Success<List<Transfer>>) {
    print('Last 5 transfers:');
    for (var transfer in result.data) {
      print('${transfer.playerName}: ${transfer.price}');
    }
  }
}

/// Beispiel: Transfer Statistics
Future<void> getTransferStatsExample(WidgetRef ref) async {
  final transferRepo = ref.read(transferRepositoryProvider);

  final result = await transferRepo.getTransferStats('league123');

  if (result is Success<Map<String, dynamic>>) {
    final stats = result.data;
    print('Total Transfers: ${stats['totalTransfers']}');
    print('Total Volume: ${stats['totalVolume']}');
    print('Average Price: ${stats['averagePrice']}');
    print('Highest Price: ${stats['highestPrice']}');
  }
}

/// Beispiel: Real-time Transfer Stream
void watchTransfersExample(WidgetRef ref, String leagueId) {
  final transferRepo = ref.read(transferRepositoryProvider);

  transferRepo.watchAll().listen((result) {
    if (result is Success<List<Transfer>>) {
      final leagueTransfers = result.data
          .where((t) => t.leagueId == leagueId)
          .toList();
      print('Transfers updated: ${leagueTransfers.length}');
    }
  });
}

/// 5. RECOMMENDATION REPOSITORY
/// ============================================================================

/// Beispiel: Recommendation generieren
Future<void> generateRecommendationExample(WidgetRef ref) async {
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  final analysisData = {
    'playerName': 'Robert Lewandowski',
    'averagePoints': 8.5,
    'marketValue': 15000000,
    'estimatedValue': 18000000,
    'marketValueTrend': 3,
    'status': 1, // Fit
    'recentPoints': [9, 8, 10, 7, 9],
  };

  final result = await recommendationRepo.generateRecommendation(
    leagueId: 'league123',
    playerId: 'player123',
    analysisData: analysisData,
  );

  if (result is Success<Recommendation>) {
    print('Recommendation: ${result.data.action} ${result.data.playerName}');
    print('Score: ${result.data.score}');
    print('Reason: ${result.data.reason}');
    print('Confidence: ${result.data.confidence}');
  }
}

/// Beispiel: Top Recommendations abrufen
Future<void> getTopRecommendationsExample(WidgetRef ref) async {
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  final result = await recommendationRepo.getTopRecommendations(
    leagueId: 'league123',
    limit: 10,
    category: 'buy',
  );

  if (result is Success<List<Recommendation>>) {
    print('Top 10 Buy Recommendations:');
    for (var rec in result.data) {
      print(
        '${rec.playerName}: ${rec.score.toStringAsFixed(1)} (${rec.action})',
      );
    }
  }
}

/// Beispiel: Recommendations nach Category
Future<void> getRecommendationsByCategoryExample(WidgetRef ref) async {
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  final result = await recommendationRepo.getByCategory(
    leagueId: 'league123',
    category: 'strong-buy',
  );

  if (result is Success<List<Recommendation>>) {
    print('Strong Buy Recommendations: ${result.data.length}');
  }
}

/// Beispiel: Batch Generate Recommendations
Future<void> batchGenerateRecommendationsExample(WidgetRef ref) async {
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  final playerIds = [
    'player1',
    'player2',
    'player3',
    // ...
  ];

  final result = await recommendationRepo.batchGenerate(
    leagueId: 'league123',
    playerIds: playerIds,
  );

  if (result is Success<List<Recommendation>>) {
    print('Generated ${result.data.length} recommendations');
  }
}

/// Beispiel: Recommendation Statistics
Future<void> getRecommendationStatsExample(WidgetRef ref) async {
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  final result = await recommendationRepo.getRecommendationStats('league123');

  if (result is Success<Map<String, dynamic>>) {
    final stats = result.data;
    print('Total Recommendations: ${stats['total']}');
    print('Average Score: ${stats['averageScore']}');
    print('Average Confidence: ${stats['averageConfidence']}');
    print('By Category: ${stats['byCategory']}');
    print('By Action: ${stats['byAction']}');
  }
}

/// Beispiel: Recommendation als angewendet markieren
Future<void> markRecommendationAppliedExample(WidgetRef ref) async {
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  final result = await recommendationRepo.markAsApplied(
    recommendationId: 'rec123',
    applied: true,
  );

  if (result is Success<Recommendation>) {
    print('Recommendation marked as applied');
  }
}

/// 6. ADVANCED EXAMPLES
/// ============================================================================

/// Beispiel: Transaction für Multi-Document Update
Future<void> transferWithTransactionExample(WidgetRef ref) async {
  final transferRepo = ref.read(transferRepositoryProvider);

  final result = await transferRepo.runTransaction((transaction) async {
    // Get buyer and seller
    // Update budgets
    // Transfer player ownership
    // Create transfer record
    return 'Transaction completed';
  });

  if (result is Success<String>) {
    print('Transaction: ${result.data}');
  }
}

/// Beispiel: Kombinierte Query mit mehreren Repositories
Future<void> complexQueryExample(WidgetRef ref) async {
  final leagueRepo = ref.read(leagueRepositoryProvider);
  final playerRepo = ref.read(playerRepositoryProvider);
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  // 1. Hole League
  final leagueResult = await leagueRepo.getById('league123');
  if (leagueResult is! Success<League>) return;

  final league = leagueResult.data;

  // 2. Hole Top Players
  final playersResult = await playerRepo.getTopPlayers(limit: 20);
  if (playersResult is! Success<List<Player>>) return;

  final players = playersResult.data;

  // 3. Generiere Recommendations
  for (var player in players) {
    await recommendationRepo.generateRecommendation(
      leagueId: league.i,
      playerId: player.id,
      analysisData: {
        'playerName': '${player.firstName} ${player.lastName}',
        'averagePoints': player.averagePoints,
        'marketValue': player.marketValue,
        'estimatedValue': player.marketValue,
      },
    );
  }

  print('Generated recommendations for ${players.length} players');
}

/// Beispiel: Error Handling Pattern
Future<void> errorHandlingExample(WidgetRef ref) async {
  final userRepo = ref.read(userRepositoryProvider);

  final result = await userRepo.getById('nonexistent');

  switch (result) {
    case Success<User>(:final data):
      print('User found: ${data.n}');
      break;
    case Failure<User>(:final message, :final code):
      if (code == 'not-found') {
        print('User not found');
      } else if (code == 'permission-denied') {
        print('Access denied');
      } else {
        print('Error: $message');
      }
      break;
  }
}

/// Beispiel: Real-time Dashboard mit mehreren Streams
void realtimeDashboardExample(WidgetRef ref, String leagueId) {
  final leagueRepo = ref.read(leagueRepositoryProvider);
  final transferRepo = ref.read(transferRepositoryProvider);
  final recommendationRepo = ref.read(recommendationRepositoryProvider);

  // League Stream
  leagueRepo.watchById(leagueId).listen((result) {
    if (result is Success<League>) {
      print('League: ${result.data.n}, MD: ${result.data.md}');
    }
  });

  // Transfers Stream
  transferRepo.watchAll().listen((result) {
    if (result is Success<List<Transfer>>) {
      final recent = result.data
          .where((t) => t.leagueId == leagueId)
          .take(5)
          .toList();
      print('Recent Transfers: ${recent.length}');
    }
  });

  // Recommendations Stream
  recommendationRepo.watchAll().listen((result) {
    if (result is Success<List<Recommendation>>) {
      final topRecs = result.data
          .where((r) => r.leagueId == leagueId)
          .take(5)
          .toList();
      print('Top Recommendations: ${topRecs.length}');
    }
  });
}
