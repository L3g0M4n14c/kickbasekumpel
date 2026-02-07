import '../../data/models/user_model.dart';
import '../../data/models/league_model.dart';
import '../../data/models/player_model.dart';
import '../../data/models/transfer_model.dart';

/// Result type for repository operations
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final String? code;
  final Exception? exception;
  const Failure(this.message, {this.code, this.exception});
}

/// Base Repository Interface
abstract class BaseRepositoryInterface<T> {
  /// Get all documents
  Future<Result<List<T>>> getAll();

  /// Get document by ID
  Future<Result<T>> getById(String id);

  /// Create new document
  Future<Result<T>> create(T item);

  /// Update existing document
  Future<Result<T>> update(String id, T item);

  /// Delete document
  Future<Result<void>> delete(String id);

  /// Stream of all documents (real-time)
  Stream<Result<List<T>>> watchAll();

  /// Stream of single document (real-time)
  Stream<Result<T>> watchById(String id);
}

/// User Repository Interface
abstract class UserRepositoryInterface extends BaseRepositoryInterface<User> {
  /// Get user by email
  Future<Result<User>> getByEmail(String email);

  /// Get user by auth UID
  Future<Result<User>> getByAuthUid(String uid);

  /// Update user profile
  Future<Result<User>> updateProfile({
    required String id,
    String? name,
    String? teamName,
    String? email,
  });

  /// Update user stats
  Future<Result<User>> updateStats({
    required String id,
    int? budget,
    int? teamValue,
    int? points,
    int? placement,
  });

  /// Search users by name
  Future<Result<List<User>>> searchByName(String query);
}

/// League Repository Interface
abstract class LeagueRepositoryInterface
    extends BaseRepositoryInterface<League> {
  /// Get leagues for user
  Future<Result<List<League>>> getByUserId(String userId);

  /// Add member to league
  Future<Result<void>> addMember({
    required String leagueId,
    required String userId,
  });

  /// Remove member from league
  Future<Result<void>> removeMember({
    required String leagueId,
    required String userId,
  });

  /// Update member in league
  Future<Result<LeagueUser>> updateMember({
    required String leagueId,
    required LeagueUser member,
  });

  /// Get league members
  Future<Result<List<LeagueUser>>> getMembers(String leagueId);

  /// Update league standings
  Future<Result<void>> updateStandings({
    required String leagueId,
    required List<LeagueUser> standings,
  });

  /// Search leagues by name
  Future<Result<List<League>>> searchByName(String query);

  /// Get active leagues (current matchday)
  Future<Result<List<League>>> getActiveLeagues();
}

/// Player Repository Interface
abstract class PlayerRepositoryInterface
    extends BaseRepositoryInterface<Player> {
  /// Get players by team
  Future<Result<List<Player>>> getByTeam(String teamId);

  /// Get players by position
  Future<Result<List<Player>>> getByPosition(int position);

  /// Search players by name
  Future<Result<List<Player>>> searchByName(String query);

  /// Get top players (by points)
  Future<Result<List<Player>>> getTopPlayers({int limit = 20, String? orderBy});

  /// Filter players
  Future<Result<List<Player>>> filterPlayers({
    int? position,
    String? teamId,
    int? minMarketValue,
    int? maxMarketValue,
    double? minAveragePoints,
  });

  /// Get player ownership status
  Future<Result<bool>> isPlayerOwned({
    required String playerId,
    required String leagueId,
  });

  /// Get owned player ids for league (batched)
  Future<Result<List<String>>> getOwnedPlayerIds(String leagueId);

  /// Update player market value
  Future<Result<Player>> updateMarketValue({
    required String playerId,
    required int newMarketValue,
    required int trend,
  });

  /// Batch update players
  Future<Result<void>> batchUpdate(List<Player> players);
}

/// Transfer Repository Interface
abstract class TransferRepositoryInterface
    extends BaseRepositoryInterface<Transfer> {
  /// Get transfers for league
  Future<Result<List<Transfer>>> getByLeague(String leagueId);

  /// Get transfers for user (from or to)
  Future<Result<List<Transfer>>> getByUser(String userId);

  /// Get transfers for player
  Future<Result<List<Transfer>>> getByPlayer(String playerId);

  /// Create transfer with validation
  Future<Result<Transfer>> createTransfer({
    required String leagueId,
    required String fromUserId,
    required String toUserId,
    required String playerId,
    required int price,
    required int marketValue,
  });

  /// Validate transfer
  Future<Result<bool>> validateTransfer({
    required String leagueId,
    required String fromUserId,
    required String toUserId,
    required String playerId,
    required int price,
  });

  /// Get recent transfers
  Future<Result<List<Transfer>>> getRecentTransfers({
    required String leagueId,
    int limit = 20,
  });

  /// Get transfer statistics
  Future<Result<Map<String, dynamic>>> getTransferStats(String leagueId);

  /// Cancel/Update transfer status
  Future<Result<Transfer>> updateStatus({
    required String transferId,
    required String status,
  });
}

/// Recommendation Repository Interface
abstract class RecommendationRepositoryInterface
    extends BaseRepositoryInterface<Recommendation> {
  /// Get recommendations for league
  Future<Result<List<Recommendation>>> getByLeague(String leagueId);

  /// Get recommendations by category
  Future<Result<List<Recommendation>>> getByCategory({
    required String leagueId,
    required String category,
  });

  /// Generate recommendation
  Future<Result<Recommendation>> generateRecommendation({
    required String leagueId,
    required String playerId,
    required Map<String, dynamic> analysisData,
  });

  /// Calculate recommendation score
  Future<Result<double>> calculateScore({
    required String playerId,
    required Map<String, dynamic> playerData,
  });

  /// Get top recommendations (by score)
  Future<Result<List<Recommendation>>> getTopRecommendations({
    required String leagueId,
    int limit = 10,
    String? category,
  });

  /// Mark recommendation as seen/applied
  Future<Result<Recommendation>> markAsApplied({
    required String recommendationId,
    required bool applied,
  });

  /// Get recommendation statistics
  Future<Result<Map<String, dynamic>>> getRecommendationStats(String leagueId);

  /// Batch generate recommendations
  Future<Result<List<Recommendation>>> batchGenerate({
    required String leagueId,
    required List<String> playerIds,
  });
}
