import 'package:kickbasekumpel/data/models/models_barrel.dart';

/// Test data generators for models
class TestData {
  // User Test Data
  static User createTestUser({
    String? id,
    String? name,
    String? teamName,
    String? email,
    int? budget,
    int? teamValue,
    int? points,
    int? placement,
  }) {
    return User(
      i: id ?? 'user-123',
      n: name ?? 'Test User',
      tn: teamName ?? 'Test Team',
      em: email ?? 'test@example.com',
      b: budget ?? 50000000,
      tv: teamValue ?? 45000000,
      p: points ?? 500,
      pl: placement ?? 1,
      f: 0,
    );
  }

  static Map<String, dynamic> createTestUserJson({
    String? id,
    String? name,
    String? teamName,
    String? email,
  }) {
    return {
      'i': id ?? 'user-123',
      'n': name ?? 'Test User',
      'tn': teamName ?? 'Test Team',
      'em': email ?? 'test@example.com',
      'b': 50000000,
      'tv': 45000000,
      'p': 500,
      'pl': 1,
      'f': 0,
    };
  }

  // LeagueUser Test Data
  static LeagueUser createTestLeagueUser({
    String? id,
    String? name,
    String? teamName,
  }) {
    return LeagueUser(
      id: id ?? 'user-123',
      name: name ?? 'Test User',
      teamName: teamName ?? 'Test Team',
      budget: 50000000,
      teamValue: 45000000,
      points: 500,
      placement: 1,
      won: 10,
      drawn: 5,
      lost: 3,
      se11: 0,
      ttm: 0,
    );
  }

  // League Test Data
  static League createTestLeague({
    String? id,
    String? name,
    LeagueUser? currentUser,
  }) {
    return League(
      i: id ?? 'league-123',
      n: name ?? 'Test League',
      cn: 'Creator Name',
      an: 'Admin Name',
      c: 'creator-123',
      s: '2023/24',
      md: 15,
      cu: currentUser ?? createTestLeagueUser(),
    );
  }

  static Map<String, dynamic> createTestLeagueJson({String? id, String? name}) {
    return {
      'i': id ?? 'league-123',
      'n': name ?? 'Test League',
      'cn': 'Creator Name',
      'an': 'Admin Name',
      'c': 'creator-123',
      's': '2023/24',
      'md': 15,
      'cu': {
        'id': 'user-123',
        'name': 'Test User',
        'teamName': 'Test Team',
        'budget': 50000000,
        'teamValue': 45000000,
        'points': 500,
        'placement': 1,
        'won': 10,
        'drawn': 5,
        'lost': 3,
        'se11': 0,
        'ttm': 0,
      },
    };
  }

  // Player Test Data
  static Player createTestPlayer({
    String? id,
    String? firstName,
    String? lastName,
    String? teamName,
    int? position,
    int? marketValue,
  }) {
    return Player(
      id: id ?? 'player-123',
      firstName: firstName ?? 'Max',
      lastName: lastName ?? 'Mustermann',
      profileBigUrl: 'https://example.com/player.jpg',
      teamName: teamName ?? 'FC Test',
      teamId: 'team-123',
      position: position ?? 1,
      number: 10,
      averagePoints: 8.5,
      totalPoints: 250,
      marketValue: marketValue ?? 15000000,
      marketValueTrend: 1,
      tfhmvt: 0,
      prlo: 0,
      stl: 1,
      status: 0,
      userOwnsPlayer: false,
    );
  }

  static Map<String, dynamic> createTestPlayerJson({
    String? id,
    String? firstName,
    String? lastName,
    int? marketValue,
  }) {
    return {
      'id': id ?? 'player-123',
      'firstName': firstName ?? 'Max',
      'lastName': lastName ?? 'Mustermann',
      'profileBigUrl': 'https://example.com/player.jpg',
      'teamName': 'FC Test',
      'teamId': 'team-123',
      'position': 1,
      'number': 10,
      'averagePoints': 8.5,
      'totalPoints': 250,
      'marketValue': marketValue ?? 15000000,
      'marketValueTrend': 1,
      'tfhmvt': 0,
      'prlo': 0,
      'stl': 1,
      'status': 0,
      'userOwnsPlayer': false,
    };
  }

  // Transfer Test Data
  static Transfer createTestTransfer({
    String? id,
    String? leagueId,
    String? fromUserId,
    String? toUserId,
    String? playerId,
    int? price,
  }) {
    return Transfer(
      id: id ?? 'transfer-123',
      leagueId: leagueId ?? 'league-123',
      fromUserId: fromUserId ?? 'user-123',
      toUserId: toUserId ?? 'user-456',
      playerId: playerId ?? 'player-123',
      price: price ?? 15000000,
      marketValue: 14000000,
      playerName: 'Max Mustermann',
      fromUsername: 'Test User 1',
      toUsername: 'Test User 2',
      timestamp: DateTime.now(),
      status: 'completed',
    );
  }

  static Map<String, dynamic> createTestTransferJson({
    String? id,
    String? leagueId,
    String? fromUserId,
    String? toUserId,
    String? playerId,
    int? price,
  }) {
    return {
      'id': id ?? 'transfer-123',
      'leagueId': leagueId ?? 'league-123',
      'fromUserId': fromUserId ?? 'user-123',
      'toUserId': toUserId ?? 'user-456',
      'playerId': playerId ?? 'player-123',
      'price': price ?? 15000000,
      'marketValue': 14000000,
      'playerName': 'Max Mustermann',
      'fromUsername': 'Test User 1',
      'toUsername': 'Test User 2',
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'completed',
    };
  }
}
