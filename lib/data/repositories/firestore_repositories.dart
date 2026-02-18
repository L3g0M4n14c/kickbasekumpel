import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/repository_interfaces.dart';
import '../models/user_model.dart';
import '../models/league_model.dart';
import '../models/player_model.dart';
import '../models/transfer_model.dart';
import '../services/kickbase_api_client.dart';
import '../providers/kickbase_api_provider.dart';
import 'base_repository.dart';

// Firestore Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Repository Providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    firestore: ref.watch(firestoreProvider),
    apiClient: ref.watch(kickbaseApiClientProvider),
  );
});

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepository(
    firestore: ref.watch(firestoreProvider),
    apiClient: ref.watch(kickbaseApiClientProvider),
  );
});

final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  return PlayerRepository(
    firestore: ref.watch(firestoreProvider),
    apiClient: ref.watch(kickbaseApiClientProvider),
  );
});

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepository(
    firestore: ref.watch(firestoreProvider),
    apiClient: ref.watch(kickbaseApiClientProvider),
  );
});

final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return RecommendationRepository(firestore: ref.watch(firestoreProvider));
});

// ============================================================================
// USER REPOSITORY
// ============================================================================

class UserRepository extends BaseRepository<User>
    implements UserRepositoryInterface {
  final KickbaseAPIClient apiClient;

  UserRepository({required super.firestore, required this.apiClient})
    : super(collectionPath: 'users');

  @override
  User fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User(
      i: doc.id,
      n: data['name'] ?? '',
      tn: data['teamName'] ?? '',
      em: data['email'] ?? '',
      b: data['budget'] ?? 0,
      tv: data['teamValue'] ?? 0,
      p: data['points'] ?? 0,
      pl: data['placement'] ?? 0,
      f: data['flags'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toFirestore(User user) {
    return {
      'name': user.n,
      'teamName': user.tn,
      'email': user.em,
      'budget': user.b,
      'teamValue': user.tv,
      'points': user.p,
      'placement': user.pl,
      'flags': user.f,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Get current user with API-first pattern
  Future<Result<User>> getCurrent() async {
    try {
      // 1. Fetch from Kickbase API
      final user = await apiClient.getUser();

      // 2. Cache in Firestore
      await collection.doc(user.i).set(toFirestore(user));

      return Success(user);
    } catch (e) {
      // 3. Fallback: Load from Firestore cache
      debugPrint('⚠️ API error, falling back to Firestore cache: $e');
      // Since we don't have user ID, this will fail - API is required
      return Failure(
        'Unable to get current user: $e',
        exception: e as Exception?,
      );
    }
  }

  @override
  Future<Result<User>> getByEmail(String email) async {
    return await queryWhere(field: 'email', value: email.toLowerCase()).then((
      result,
    ) {
      if (result is Success<List<User>>) {
        final users = result.data;
        if (users.isEmpty) {
          return Failure('User not found', code: 'not-found');
        }
        return Success(users.first);
      }
      final failure = result as Failure<List<User>>;
      return Failure(
        failure.message,
        code: failure.code,
        exception: failure.exception,
      );
    });
  }

  @override
  Future<Result<User>> getByAuthUid(String uid) async {
    return await getById(uid);
  }

  @override
  Future<Result<User>> updateProfile({
    required String id,
    String? name,
    String? teamName,
    String? email,
  }) async {
    final fields = <String, dynamic>{};
    if (name != null) fields['name'] = name;
    if (teamName != null) fields['teamName'] = teamName;
    if (email != null) fields['email'] = email.toLowerCase();
    fields['updatedAt'] = FieldValue.serverTimestamp();

    return await updateFields(id, fields);
  }

  @override
  Future<Result<User>> updateStats({
    required String id,
    int? budget,
    int? teamValue,
    int? points,
    int? placement,
  }) async {
    final fields = <String, dynamic>{};
    if (budget != null) fields['budget'] = budget;
    if (teamValue != null) fields['teamValue'] = teamValue;
    if (points != null) fields['points'] = points;
    if (placement != null) fields['placement'] = placement;
    fields['updatedAt'] = FieldValue.serverTimestamp();

    return await updateFields(id, fields);
  }

  @override
  Future<Result<List<User>>> searchByName(String query) async {
    // Firestore doesn't support full-text search, so we use a simple approach
    // For better search, consider using Algolia or Elasticsearch
    try {
      final snapshot = await collection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      final users = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(users);
    } on FirebaseException catch (e) {
      return Failure('Search failed: ${e.message}', code: e.code, exception: e);
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }
}

// ============================================================================
// LEAGUE REPOSITORY
// ============================================================================

class LeagueRepository extends BaseRepository<League>
    implements LeagueRepositoryInterface {
  final KickbaseAPIClient apiClient;

  LeagueRepository({required super.firestore, required this.apiClient})
    : super(collectionPath: 'leagues');

  @override
  League fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return League(
      i: doc.id,
      cpi: data['competitionId'] ?? '1',
      n: data['name'] ?? '',
      cn: data['creatorName'] ?? '',
      an: data['adminName'] ?? '',
      c: data['creator'] ?? '',
      s: data['season'] ?? '',
      md: data['matchday'] ?? 0,
      cu: LeagueUser.fromJson(data['currentUser'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toFirestore(League league) {
    return {
      'competitionId': league.cpi,
      'name': league.n,
      'creatorName': league.cn,
      'adminName': league.an,
      'creator': league.c,
      'season': league.s,
      'matchday': league.md,
      'currentUser': league.cu.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Get all leagues with API-first pattern
  ///
  /// 1. Fetch from Kickbase API
  /// 2. Cache in Firestore
  /// 3. Fallback to Firestore cache on error
  @override
  Future<Result<List<League>>> getAll() async {
    try {
      // 1. Fetch from Kickbase API
      final leagues = await apiClient.getLeagues();

      // 2. Cache in Firestore
      for (final league in leagues) {
        await collection.doc(league.i).set(toFirestore(league));
      }

      return Success(leagues);
    } catch (e) {
      // 3. Fallback: Load from Firestore cache
      debugPrint('⚠️ API error, falling back to Firestore cache: $e');
      return await super.getAll();
    }
  }

  /// Get league by ID with API-first pattern
  @override
  Future<Result<League>> getById(String id) async {
    try {
      // 1. Fetch from Kickbase API
      final league = await apiClient.getLeague(id);

      // 2. Cache in Firestore
      await collection.doc(league.i).set(toFirestore(league));

      return Success(league);
    } catch (e) {
      // 3. Fallback: Load from Firestore cache
      debugPrint('⚠️ API error, falling back to Firestore cache: $e');
      return await super.getById(id);
    }
  }

  @override
  Future<Result<List<League>>> getByUserId(String userId) async {
    return await queryWhere(field: 'members', value: userId);
  }

  @override
  Future<Result<void>> addMember({
    required String leagueId,
    required String userId,
  }) async {
    try {
      await collection.doc(leagueId).update({
        'members': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to add member: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<void>> removeMember({
    required String leagueId,
    required String userId,
  }) async {
    try {
      await collection.doc(leagueId).update({
        'members': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to remove member: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<LeagueUser>> updateMember({
    required String leagueId,
    required LeagueUser member,
  }) async {
    try {
      final leagueDoc = await collection.doc(leagueId).get();
      if (!leagueDoc.exists) {
        return Failure('League not found', code: 'not-found');
      }

      final data = leagueDoc.data()!;
      final members = List<Map<String, dynamic>>.from(data['standings'] ?? []);

      // Find and update member
      final index = members.indexWhere((m) => m['id'] == member.id);
      if (index != -1) {
        members[index] = member.toJson();
      } else {
        members.add(member.toJson());
      }

      await collection.doc(leagueId).update({
        'standings': members,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return Success(member);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to update member: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<LeagueUser>>> getMembers(String leagueId) async {
    try {
      final doc = await collection.doc(leagueId).get();
      if (!doc.exists) {
        return Failure('League not found', code: 'not-found');
      }

      final data = doc.data()!;
      final membersData = List<Map<String, dynamic>>.from(
        data['standings'] ?? [],
      );
      final members = membersData.map((m) => LeagueUser.fromJson(m)).toList();

      return Success(members);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get members: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<void>> updateStandings({
    required String leagueId,
    required List<LeagueUser> standings,
  }) async {
    try {
      await collection.doc(leagueId).update({
        'standings': standings.map((s) => s.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Success(null);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to update standings: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<League>>> searchByName(String query) async {
    try {
      final snapshot = await collection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      final leagues = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(leagues);
    } on FirebaseException catch (e) {
      return Failure('Search failed: ${e.message}', code: e.code, exception: e);
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<League>>> getActiveLeagues() async {
    return await queryWhere(field: 'active', value: true);
  }
}

// ============================================================================
// PLAYER REPOSITORY
// ============================================================================

class PlayerRepository extends BaseRepository<Player>
    implements PlayerRepositoryInterface {
  final KickbaseAPIClient apiClient;

  PlayerRepository({required super.firestore, required this.apiClient})
    : super(collectionPath: 'players');

  @override
  Player fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Player(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      profileBigUrl: data['profileBigUrl'] ?? '',
      teamName: data['teamName'] ?? '',
      teamId: data['teamId'] ?? '',
      position: data['position'] ?? 0,
      number: data['number'] ?? 0,
      averagePoints: (data['averagePoints'] ?? 0).toDouble(),
      totalPoints: data['totalPoints'] ?? 0,
      marketValue: data['marketValue'] ?? 0,
      marketValueTrend: data['marketValueTrend'] ?? 0,
      tfhmvt: data['tfhmvt'] ?? 0,
      prlo: data['prlo'] ?? 0,
      stl: data['stl'] ?? 0,
      status: data['status'] ?? 0,
      userOwnsPlayer: data['userOwnsPlayer'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toFirestore(Player player) {
    return {
      'firstName': player.firstName,
      'lastName': player.lastName,
      'profileBigUrl': player.profileBigUrl,
      'teamName': player.teamName,
      'teamId': player.teamId,
      'position': player.position,
      'number': player.number,
      'averagePoints': player.averagePoints,
      'totalPoints': player.totalPoints,
      'marketValue': player.marketValue,
      'marketValueTrend': player.marketValueTrend,
      'tfhmvt': player.tfhmvt,
      'prlo': player.prlo,
      'stl': player.stl,
      'status': player.status,
      'userOwnsPlayer': player.userOwnsPlayer,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Get players by league with API-first pattern
  /// Note: API method is getLeaguePlayers(leagueId)
  Future<Result<List<Player>>> getByLeague(String leagueId) async {
    try {
      // 1. Fetch from Kickbase API
      final players = await apiClient.getLeaguePlayers(leagueId);

      // 2. Cache in Firestore
      for (final player in players) {
        await collection.doc(player.id).set(toFirestore(player));
      }

      return Success(players);
    } catch (e) {
      // 3. Fallback: Load from Firestore cache
      debugPrint('⚠️ API error, falling back to Firestore cache: $e');
      return await queryWhere(field: 'leagueId', value: leagueId);
    }
  }

  @override
  Future<Result<List<Player>>> getByTeam(String teamId) async {
    return await queryWhere(field: 'teamId', value: teamId);
  }

  @override
  Future<Result<List<Player>>> getByPosition(int position) async {
    return await queryWhere(field: 'position', value: position);
  }

  @override
  Future<Result<List<Player>>> searchByName(String query) async {
    try {
      final lowerQuery = query.toLowerCase();
      final snapshot = await collection
          .where('searchName', isGreaterThanOrEqualTo: lowerQuery)
          .where('searchName', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .limit(20)
          .get();

      final players = snapshot.docs.map((doc) => fromFirestore(doc)).toList();
      return Success(players);
    } on FirebaseException catch (e) {
      return Failure('Search failed: ${e.message}', code: e.code, exception: e);
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<Player>>> getTopPlayers({
    int limit = 20,
    String? orderBy,
  }) async {
    return await queryOrderBy(
      field: orderBy ?? 'totalPoints',
      descending: true,
      limit: limit,
    );
  }

  @override
  Future<Result<List<Player>>> filterPlayers({
    int? position,
    String? teamId,
    int? minMarketValue,
    int? maxMarketValue,
    double? minAveragePoints,
  }) async {
    final conditions = <QueryCondition>[];

    if (position != null) {
      conditions.add(QueryCondition(field: 'position', isEqualTo: position));
    }
    if (teamId != null) {
      conditions.add(QueryCondition(field: 'teamId', isEqualTo: teamId));
    }
    if (minMarketValue != null) {
      conditions.add(
        QueryCondition(
          field: 'marketValue',
          isGreaterThanOrEqualTo: minMarketValue,
        ),
      );
    }
    if (maxMarketValue != null) {
      conditions.add(
        QueryCondition(
          field: 'marketValue',
          isLessThanOrEqualTo: maxMarketValue,
        ),
      );
    }
    if (minAveragePoints != null) {
      conditions.add(
        QueryCondition(
          field: 'averagePoints',
          isGreaterThanOrEqualTo: minAveragePoints,
        ),
      );
    }

    return await complexQuery(
      conditions: conditions,
      orderByField: 'totalPoints',
      descending: true,
      limit: 50,
    );
  }

  @override
  Future<Result<bool>> isPlayerOwned({
    required String playerId,
    required String leagueId,
  }) async {
    try {
      final doc = await firestore
          .collection('leagues')
          .doc(leagueId)
          .collection('ownedPlayers')
          .doc(playerId)
          .get();

      return Success(doc.exists);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to check ownership: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<String>>> getOwnedPlayerIds(String leagueId) async {
    try {
      final snapshot = await firestore
          .collection('leagues')
          .doc(leagueId)
          .collection('ownedPlayers')
          .get();

      final ids = snapshot.docs.map((d) => d.id).toList();
      return Success(ids);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get owned player IDs: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<Player>> updateMarketValue({
    required String playerId,
    required int newMarketValue,
    required int trend,
  }) async {
    return await updateFields(playerId, {
      'marketValue': newMarketValue,
      'marketValueTrend': trend,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Result<void>> batchUpdate(List<Player> players) async {
    final operations = players.map((player) {
      return BatchOperation<Player>(
        id: player.id,
        type: BatchOperationType.update,
        data: player,
      );
    }).toList();

    return await batchWrite(operations);
  }

  /// Triggert die Cloud Function für Ligainsider Photo-Updates
  ///
  /// Ruft die Google Cloud Function auf, die automatisch Spielerfotos
  /// von ligainsider.de scraped und in Firestore speichert.
  ///
  /// Die Cloud Function läuft auch automatisch täglich um 02:00 UTC via Cloud Scheduler.
  ///
  /// Returns: Success wenn die Function erfolgreich triggered wurde
  Future<Result<void>> triggerCloudFunctionPhotoUpdate() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return Failure('User not authenticated');
      }

      // Hole Firebase ID Token
      final idToken = await currentUser.getIdToken();

      // Rufe Cloud Function auf
      final response = await http
          .post(
            Uri.parse(
              'https://europe-west1-kickbasekumpel.cloudfunctions.net/updateLigainsiderPhotos',
            ),
            headers: {
              'Authorization': 'Bearer $idToken',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(minutes: 10),
            onTimeout: () => throw TimeoutException(
              'Cloud Function timeout',
              const Duration(minutes: 10),
            ),
          );

      if (response.statusCode == 200) {
        debugPrint('✅ Cloud Function triggered successfully');
        return const Success(null);
      } else {
        debugPrint('❌ Cloud Function returned status ${response.statusCode}');
        return Failure('Cloud Function failed: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error triggering Cloud Function: $e\n$stackTrace');
      return Failure(
        'Error triggering photo update: $e',
        exception: e as Exception?,
      );
    }
  }
}

// ============================================================================
// TRANSFER REPOSITORY
// ============================================================================

class TransferRepository extends BaseRepository<Transfer>
    implements TransferRepositoryInterface {
  final KickbaseAPIClient apiClient;

  TransferRepository({required super.firestore, required this.apiClient})
    : super(collectionPath: 'transfers');

  @override
  Transfer fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Transfer(
      id: doc.id,
      leagueId: data['leagueId'] ?? '',
      fromUserId: data['fromUserId'] ?? '',
      toUserId: data['toUserId'] ?? '',
      playerId: data['playerId'] ?? '',
      price: data['price'] ?? 0,
      marketValue: data['marketValue'] ?? 0,
      playerName: data['playerName'] ?? '',
      fromUsername: data['fromUsername'] ?? '',
      toUsername: data['toUsername'] ?? '',
      timestamp: timestampToDateTime(data['timestamp']) ?? DateTime.now(),
      status: data['status'] ?? 'pending',
    );
  }

  @override
  Map<String, dynamic> toFirestore(Transfer transfer) {
    return {
      'leagueId': transfer.leagueId,
      'fromUserId': transfer.fromUserId,
      'toUserId': transfer.toUserId,
      'playerId': transfer.playerId,
      'price': transfer.price,
      'marketValue': transfer.marketValue,
      'playerName': transfer.playerName,
      'fromUsername': transfer.fromUsername,
      'toUsername': transfer.toUsername,
      'timestamp': dateTimeToTimestamp(transfer.timestamp),
      'status': transfer.status,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Get transfers by league with API-first pattern
  @override
  Future<Result<List<Transfer>>> getByLeague(String leagueId) async {
    // Note: API method requires both leagueId and userId
    // For now, use Firestore as primary source for league transfers
    return await complexQuery(
      conditions: [QueryCondition(field: 'leagueId', isEqualTo: leagueId)],
      orderByField: 'timestamp',
      descending: true,
    );
  }

  /// Get transfers by user with API-first pattern
  @override
  Future<Result<List<Transfer>>> getByUser(String userId) async {
    // First try to get from API if we have a league context
    // For now, use Firestore as we need leagueId for API call

    try {
      // Get transfers where user is sender or receiver
      final sentSnapshot = await collection
          .where('fromUserId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      final receivedSnapshot = await collection
          .where('toUserId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      final transfers = [
        ...sentSnapshot.docs.map((doc) => fromFirestore(doc)),
        ...receivedSnapshot.docs.map((doc) => fromFirestore(doc)),
      ];

      // Sort by timestamp
      transfers.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return Success(transfers);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get transfers: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  /// Get transfers by league and user with API-first pattern
  /// This method uses the API's getTransfers endpoint
  Future<Result<List<Transfer>>> getByLeagueAndUser(
    String leagueId,
    String userId,
  ) async {
    try {
      // 1. Fetch from Kickbase API
      final transfers = await apiClient.getTransfers(leagueId, userId);

      // 2. Cache in Firestore
      for (final transfer in transfers) {
        await collection.doc(transfer.id).set(toFirestore(transfer));
      }

      return Success(transfers);
    } catch (e) {
      // 3. Fallback: Load from Firestore cache
      debugPrint('⚠️ API error, falling back to Firestore cache: $e');
      return await complexQuery(
        conditions: [
          QueryCondition(field: 'leagueId', isEqualTo: leagueId),
          QueryCondition(field: 'fromUserId', isEqualTo: userId),
        ],
        orderByField: 'timestamp',
        descending: true,
      );
    }
  }

  @override
  Future<Result<List<Transfer>>> getByPlayer(String playerId) async {
    return await complexQuery(
      conditions: [QueryCondition(field: 'playerId', isEqualTo: playerId)],
      orderByField: 'timestamp',
      descending: true,
    );
  }

  @override
  Future<Result<Transfer>> createTransfer({
    required String leagueId,
    required String fromUserId,
    required String toUserId,
    required String playerId,
    required int price,
    required int marketValue,
  }) async {
    // Validate first
    final validation = await validateTransfer(
      leagueId: leagueId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      playerId: playerId,
      price: price,
    );

    if (validation is Failure) {
      final failure = validation as Failure<bool>;
      return Failure(
        failure.message,
        code: failure.code,
        exception: failure.exception,
      );
    }

    // Get user names and player name
    final fromUserDoc = await firestore
        .collection('users')
        .doc(fromUserId)
        .get();
    final toUserDoc = await firestore.collection('users').doc(toUserId).get();
    final playerDoc = await firestore.collection('players').doc(playerId).get();

    final transfer = Transfer(
      id: '',
      leagueId: leagueId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      playerId: playerId,
      price: price,
      marketValue: marketValue,
      playerName:
          '${playerDoc.data()?['firstName']} ${playerDoc.data()?['lastName']}',
      fromUsername: fromUserDoc.data()?['name'] ?? 'Unknown',
      toUsername: toUserDoc.data()?['name'] ?? 'Unknown',
      timestamp: DateTime.now(),
      status: 'completed',
    );

    return await create(transfer);
  }

  @override
  Future<Result<bool>> validateTransfer({
    required String leagueId,
    required String fromUserId,
    required String toUserId,
    required String playerId,
    required int price,
  }) async {
    try {
      // Check if buyer has enough budget
      final toUserDoc = await firestore.collection('users').doc(toUserId).get();
      if (!toUserDoc.exists) {
        return Failure('Buyer not found', code: 'not-found');
      }

      final budget = toUserDoc.data()?['budget'] ?? 0;
      if (budget < price) {
        return Failure('Insufficient budget', code: 'insufficient-funds');
      }

      // Check if player exists and is owned by seller
      final playerDoc = await firestore
          .collection('leagues')
          .doc(leagueId)
          .collection('ownedPlayers')
          .doc(playerId)
          .get();

      if (!playerDoc.exists) {
        return Failure('Player not found in league', code: 'not-found');
      }

      final ownerId = playerDoc.data()?['ownerId'];
      if (ownerId != fromUserId) {
        return Failure('Player not owned by seller', code: 'invalid-owner');
      }

      return const Success(true);
    } on FirebaseException catch (e) {
      return Failure(
        'Validation failed: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<Transfer>>> getRecentTransfers({
    required String leagueId,
    int limit = 20,
  }) async {
    return await complexQuery(
      conditions: [
        QueryCondition(field: 'leagueId', isEqualTo: leagueId),
        QueryCondition(field: 'status', isEqualTo: 'completed'),
      ],
      orderByField: 'timestamp',
      descending: true,
      limit: limit,
    );
  }

  @override
  Future<Result<Map<String, dynamic>>> getTransferStats(String leagueId) async {
    try {
      final snapshot = await collection
          .where('leagueId', isEqualTo: leagueId)
          .where('status', isEqualTo: 'completed')
          .get();

      final transfers = snapshot.docs.map((doc) => fromFirestore(doc)).toList();

      final stats = {
        'totalTransfers': transfers.length,
        'totalVolume': transfers.fold<int>(0, (sum, t) => sum + t.price),
        'averagePrice': transfers.isEmpty
            ? 0
            : transfers.fold<int>(0, (sum, t) => sum + t.price) /
                  transfers.length,
        'highestPrice': transfers.isEmpty
            ? 0
            : transfers.map((t) => t.price).reduce((a, b) => a > b ? a : b),
        'lowestPrice': transfers.isEmpty
            ? 0
            : transfers.map((t) => t.price).reduce((a, b) => a < b ? a : b),
      };

      return Success(stats);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get stats: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<Transfer>> updateStatus({
    required String transferId,
    required String status,
  }) async {
    return await updateFields(transferId, {
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

// ============================================================================
// RECOMMENDATION REPOSITORY
// ============================================================================

class RecommendationRepository extends BaseRepository<Recommendation>
    implements RecommendationRepositoryInterface {
  RecommendationRepository({required super.firestore})
    : super(collectionPath: 'recommendations');

  @override
  Recommendation fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Recommendation(
      id: doc.id,
      leagueId: data['leagueId'] ?? '',
      playerId: data['playerId'] ?? '',
      playerName: data['playerName'] ?? '',
      score: (data['score'] ?? 0).toDouble(),
      reason: data['reason'] ?? '',
      action: data['action'] ?? '',
      suggestedPrice: data['suggestedPrice'],
      currentMarketValue: data['currentMarketValue'] ?? 0,
      estimatedValue: data['estimatedValue'] ?? 0,
      confidence: (data['confidence'] ?? 0).toDouble(),
      timestamp: timestampToDateTime(data['timestamp']) ?? DateTime.now(),
      category: data['category'] ?? 'general',
    );
  }

  @override
  Map<String, dynamic> toFirestore(Recommendation recommendation) {
    return {
      'leagueId': recommendation.leagueId,
      'playerId': recommendation.playerId,
      'playerName': recommendation.playerName,
      'score': recommendation.score,
      'reason': recommendation.reason,
      'action': recommendation.action,
      'suggestedPrice': recommendation.suggestedPrice,
      'currentMarketValue': recommendation.currentMarketValue,
      'estimatedValue': recommendation.estimatedValue,
      'confidence': recommendation.confidence,
      'timestamp': dateTimeToTimestamp(recommendation.timestamp),
      'category': recommendation.category,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  Future<Result<List<Recommendation>>> getByLeague(String leagueId) async {
    return await complexQuery(
      conditions: [QueryCondition(field: 'leagueId', isEqualTo: leagueId)],
      orderByField: 'score',
      descending: true,
    );
  }

  @override
  Future<Result<List<Recommendation>>> getByCategory({
    required String leagueId,
    required String category,
  }) async {
    return await complexQuery(
      conditions: [
        QueryCondition(field: 'leagueId', isEqualTo: leagueId),
        QueryCondition(field: 'category', isEqualTo: category),
      ],
      orderByField: 'score',
      descending: true,
    );
  }

  @override
  Future<Result<Recommendation>> generateRecommendation({
    required String leagueId,
    required String playerId,
    required Map<String, dynamic> analysisData,
  }) async {
    // Calculate score based on analysis data
    final scoreResult = await calculateScore(
      playerId: playerId,
      playerData: analysisData,
    );

    if (scoreResult is Failure) {
      final failure = scoreResult as Failure<double>;
      return Failure(
        failure.message,
        code: failure.code,
        exception: failure.exception,
      );
    }

    final score = (scoreResult as Success<double>).data;

    // Determine action and category
    String action = 'hold';
    String category = 'general';
    if (score > 80) {
      action = 'buy';
      category = 'strong-buy';
    } else if (score > 60) {
      action = 'buy';
      category = 'buy';
    } else if (score < 40) {
      action = 'sell';
      category = 'sell';
    } else if (score < 20) {
      action = 'sell';
      category = 'strong-sell';
    }

    final recommendation = Recommendation(
      id: '',
      leagueId: leagueId,
      playerId: playerId,
      playerName: analysisData['playerName'] ?? '',
      score: score,
      reason: _generateReason(analysisData, score),
      action: action,
      suggestedPrice: analysisData['suggestedPrice'],
      currentMarketValue: analysisData['currentMarketValue'] ?? 0,
      estimatedValue: analysisData['estimatedValue'] ?? 0,
      confidence: _calculateConfidence(analysisData),
      timestamp: DateTime.now(),
      category: category,
    );

    return await create(recommendation);
  }

  @override
  Future<Result<double>> calculateScore({
    required String playerId,
    required Map<String, dynamic> playerData,
  }) async {
    try {
      // Scoring algorithm based on multiple factors
      double score = 50.0; // Base score

      // Form factor (30% weight)
      final avgPoints = (playerData['averagePoints'] ?? 0).toDouble();
      score += (avgPoints / 10) * 30;

      // Value factor (25% weight)
      final marketValue = playerData['marketValue'] ?? 0;
      final estimatedValue = playerData['estimatedValue'] ?? marketValue;
      final valueDiff = estimatedValue - marketValue;
      final valuePercent = (valueDiff / marketValue) * 100;
      score += (valuePercent / 50) * 25;

      // Trend factor (20% weight)
      final trend = playerData['marketValueTrend'] ?? 0;
      score += (trend.toDouble() / 5) * 20;

      // Status factor (15% weight)
      final status = playerData['status'] ?? 0;
      if (status == 1) score += 15; // Fit
      if (status == 2) score -= 5; // Injured
      if (status == 8) score -= 10; // Suspended

      // Recent performance (10% weight)
      final recentPoints = playerData['recentPoints'] ?? [];
      if (recentPoints.isNotEmpty) {
        final avgRecent =
            recentPoints.fold<double>(0.0, (sum, p) => sum + p) /
            recentPoints.length;
        score += (avgRecent / 10) * 10;
      }

      // Normalize score to 0-100
      score = score.clamp(0.0, 100.0);

      return Success(score);
    } catch (e) {
      return Failure(
        'Failed to calculate score: $e',
        exception: e as Exception?,
      );
    }
  }

  @override
  Future<Result<List<Recommendation>>> getTopRecommendations({
    required String leagueId,
    int limit = 10,
    String? category,
  }) async {
    final conditions = <QueryCondition>[
      QueryCondition(field: 'leagueId', isEqualTo: leagueId),
    ];

    if (category != null) {
      conditions.add(QueryCondition(field: 'category', isEqualTo: category));
    }

    return await complexQuery(
      conditions: conditions,
      orderByField: 'score',
      descending: true,
      limit: limit,
    );
  }

  @override
  Future<Result<Recommendation>> markAsApplied({
    required String recommendationId,
    required bool applied,
  }) async {
    return await updateFields(recommendationId, {
      'applied': applied,
      'appliedAt': applied ? FieldValue.serverTimestamp() : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<Result<Map<String, dynamic>>> getRecommendationStats(
    String leagueId,
  ) async {
    try {
      final snapshot = await collection
          .where('leagueId', isEqualTo: leagueId)
          .get();

      final recommendations = snapshot.docs
          .map((doc) => fromFirestore(doc))
          .toList();

      final stats = {
        'total': recommendations.length,
        'averageScore': recommendations.isEmpty
            ? 0.0
            : recommendations.fold<double>(0.0, (sum, r) => sum + r.score) /
                  recommendations.length,
        'averageConfidence': recommendations.isEmpty
            ? 0.0
            : recommendations.fold<double>(
                    0.0,
                    (sum, r) => sum + r.confidence,
                  ) /
                  recommendations.length,
        'byCategory': _groupByCategory(recommendations),
        'byAction': _groupByAction(recommendations),
      };

      return Success(stats);
    } on FirebaseException catch (e) {
      return Failure(
        'Failed to get stats: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  @override
  Future<Result<List<Recommendation>>> batchGenerate({
    required String leagueId,
    required List<String> playerIds,
  }) async {
    try {
      final recommendations = <Recommendation>[];

      for (var playerId in playerIds) {
        // Get player data
        final playerDoc = await firestore
            .collection('players')
            .doc(playerId)
            .get();
        if (!playerDoc.exists) continue;

        final playerData = playerDoc.data()!;
        final result = await generateRecommendation(
          leagueId: leagueId,
          playerId: playerId,
          analysisData: playerData,
        );

        if (result is Success<Recommendation>) {
          recommendations.add(result.data);
        }
      }

      return Success(recommendations);
    } on FirebaseException catch (e) {
      return Failure(
        'Batch generation failed: ${e.message}',
        code: e.code,
        exception: e,
      );
    } catch (e) {
      return Failure('Unexpected error: $e', exception: e as Exception?);
    }
  }

  // Helper methods
  String _generateReason(Map<String, dynamic> data, double score) {
    final reasons = <String>[];

    if (score > 70) {
      reasons.add('Strong performance indicators');
    }
    if (data['marketValueTrend'] > 3) {
      reasons.add('Rising market value');
    }
    if (data['averagePoints'] > 8) {
      reasons.add('High average points');
    }

    return reasons.isEmpty ? 'Based on analysis' : reasons.join(', ');
  }

  double _calculateConfidence(Map<String, dynamic> data) {
    double confidence = 0.5;

    // More data points = higher confidence
    if (data.containsKey('averagePoints')) confidence += 0.1;
    if (data.containsKey('marketValueTrend')) confidence += 0.1;
    if (data.containsKey('recentPoints')) confidence += 0.15;
    if (data.containsKey('estimatedValue')) confidence += 0.15;

    return confidence.clamp(0.0, 1.0);
  }

  Map<String, int> _groupByCategory(List<Recommendation> recommendations) {
    final groups = <String, int>{};
    for (var rec in recommendations) {
      groups[rec.category] = (groups[rec.category] ?? 0) + 1;
    }
    return groups;
  }

  Map<String, int> _groupByAction(List<Recommendation> recommendations) {
    final groups = <String, int>{};
    for (var rec in recommendations) {
      groups[rec.action] = (groups[rec.action] ?? 0) + 1;
    }
    return groups;
  }
}
