import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:logger/logger.dart';

import '../models/league_model.dart';
import '../models/lineup_model.dart';
import '../models/market_model.dart';
import '../models/player_model.dart';
import '../models/transfer_model.dart';
import '../models/user_model.dart';
import '../models/common_models.dart';
import 'kickbase_api_client.dart';

/// Demo-Modus API-Client
///
/// Ersetzt den echten KickbaseAPIClient, wenn ein Demonutzer eingeloggt ist.
/// Gibt statische Demodaten zurück, ohne jemals Kickbase zu kontaktieren.
///
/// Demo-Zugangsdaten: demo@kickbasekumpel.de / demo1234
class DemoKickbaseAPIClient extends KickbaseAPIClient {
  static const String demoEmail = 'demo@kickbasekumpel.de';
  static const String demoPassword = 'demo1234';
  static const String demoToken = '__KICKBASE_KUMPEL_DEMO__';
  static const String demoLeagueId = 'demo-liga-001';
  static const String demoLeagueName = 'Demo Liga';

  final Logger _log = Logger();

  DemoKickbaseAPIClient() : super() {
    _log.i('🎮 DemoKickbaseAPIClient aktiv – keine echten API-Anfragen');
  }

  /// Gibt die Firebase Anonymous User-ID zurück, oder den Fallback-Wert.
  /// Der try-catch schützt vor dem Fall, dass Firebase in der Test-Umgebung
  /// nicht initialisiert wurde.
  String get _currentUid {
    try {
      return firebase_auth.FirebaseAuth.instance.currentUser?.uid ??
          'demo_user_000';
    } catch (_) {
      return 'demo_user_000';
    }
  }

  // ── Demo-Nutzer ─────────────────────────────────────────────────────

  /// Gibt den Demo-Nutzer zurück.
  /// Die User-ID entspricht der Firebase Anonymous UID, damit
  /// Firestore-Writes unter users/{uid} funktionieren.
  static User buildDemoUser([String? uid]) => User(
    i: uid ?? 'demo_user_000',
    n: 'Max Mustermann',
    tn: 'FC Demo',
    em: demoEmail,
    b: 25200000,
    tv: 47830000,
    p: 1547,
    pl: 2,
    f: 0,
  );

  // ── Token-Management (in-memory, kein SharedPreferences-Write) ──────

  @override
  Future<bool> hasAuthToken() async => true;

  @override
  Future<String?> getAuthToken() async => demoToken;

  @override
  Future<void> setAuthToken(String token) async {}

  @override
  Future<void> clearAuthToken() async {}

  @override
  Future<void> saveUserData(User user) async {}

  @override
  Future<User?> getSavedUserData() async {
    return buildDemoUser(_currentUid);
  }

  // ── Auth: Login ──────────────────────────────────────────────────────

  @override
  Future<LoginResponse> login(String email, String password) async {
    final loginUser = LoginUser(
      id: _currentUid,
      name: 'Max Mustermann',
      email: demoEmail,
    );
    return LoginResponse(tkn: demoToken, loginUser: loginUser);
  }

  // ── Ligen ────────────────────────────────────────────────────────────

  @override
  Future<List<League>> getLeagues() async => [_buildDemoLeague()];

  @override
  Future<League> getLeague(String leagueId) async => _buildDemoLeague();

  League _buildDemoLeague() {
    final uid = _currentUid;
    return League(
      i: demoLeagueId,
      cpi: '1',
      n: demoLeagueName,
      cn: 'Max Mustermann',
      an: 'Max Mustermann',
      c: uid,
      s: '2025/26',
      md: 24,
      cu: LeagueUser(
        id: uid,
        name: 'Max Mustermann',
        teamName: 'FC Demo',
        budget: 25200000,
        teamValue: 47830000,
        points: 1547,
        placement: 2,
        won: 14,
        drawn: 5,
        lost: 5,
        se11: 11,
        ttm: 24,
        lp: [],
      ),
      b: 25200000,
      tv: 47830000,
      pl: 2,
      adm: true,
      lim: null,
    );
  }

  // ── Spieler (Squad) ──────────────────────────────────────────────────

  @override
  Future<List<Player>> getLeaguePlayers(String leagueId) async {
    return [
      ..._demoSquad(userOwns: true),
      ..._demoSquad(userOwns: false).take(3),
    ];
  }

  List<Player> _demoSquad({bool userOwns = true}) => [
    _player(
      'p01',
      'Oliver',
      'Beier',
      'Hoffenheim',
      't_tsg',
      1,
      1,
      35,
      510,
      5500000,
      0,
      userOwns: userOwns,
    ),
    _player(
      'p02',
      'Niklas',
      'Hübner',
      'Dortmund',
      't_bvb',
      2,
      5,
      42,
      630,
      12000000,
      1,
      userOwns: userOwns,
    ),
    _player(
      'p03',
      'David',
      'Ratzer',
      'Leipzig',
      't_rbl',
      2,
      3,
      38,
      580,
      9800000,
      -1,
      userOwns: userOwns,
    ),
    _player(
      'p04',
      'Lukas',
      'Brenner',
      'Leverkusen',
      't_b04',
      2,
      4,
      44,
      660,
      11200000,
      1,
      userOwns: userOwns,
    ),
    _player(
      'p05',
      'Thomas',
      'Meier',
      'Bayern',
      't_fcb',
      3,
      25,
      67,
      980,
      24500000,
      2,
      userOwns: userOwns,
    ),
    _player(
      'p06',
      'Leon',
      'Schreiber',
      'Bayern',
      't_fcb',
      3,
      6,
      72,
      1050,
      19800000,
      1,
      userOwns: userOwns,
    ),
    _player(
      'p07',
      'Florian',
      'Vogel',
      'Leverkusen',
      't_b04',
      3,
      10,
      88,
      1240,
      41000000,
      3,
      userOwns: userOwns,
    ),
    _player(
      'p08',
      'Jonas',
      'Koch',
      'Gladbach',
      't_bmg',
      3,
      8,
      54,
      780,
      14200000,
      0,
      userOwns: userOwns,
    ),
    _player(
      'p09',
      'Serge',
      'Kraft',
      'Frankfurt',
      't_sge',
      4,
      7,
      65,
      940,
      18500000,
      2,
      userOwns: userOwns,
    ),
    _player(
      'p10',
      'Karim',
      'Bauer',
      'Bayern',
      't_fcb',
      4,
      9,
      78,
      1120,
      32000000,
      1,
      userOwns: userOwns,
    ),
    _player(
      'p11',
      'Luca',
      'Winter',
      'Stuttgart',
      't_vfb',
      4,
      11,
      61,
      890,
      15700000,
      -1,
      userOwns: userOwns,
    ),
  ];

  Player _player(
    String id,
    String first,
    String last,
    String team,
    String teamId,
    int pos,
    int number,
    double avg,
    int total,
    int mv,
    int mvTrend, {
    bool userOwns = true,
  }) => Player(
    id: id,
    firstName: first,
    lastName: last,
    profileBigUrl: '',
    teamName: team,
    teamId: teamId,
    position: pos,
    number: number,
    averagePoints: avg,
    totalPoints: total,
    marketValue: mv,
    marketValueTrend: mvTrend,
    tfhmvt: 0,
    prlo: mv,
    stl: 0,
    status: 0,
    userOwnsPlayer: userOwns,
    ligainsiderPhotoUrl: '',
  );

  // ── Markt ────────────────────────────────────────────────────────────

  @override
  Future<List<MarketPlayer>> getMarketAvailable(String leagueId) async {
    final expiry = DateTime.now()
        .add(const Duration(days: 2))
        .toIso8601String();
    const seller = MarketSeller(id: 'demo_user_002', name: 'Karl Demomann');
    return [
      _marketPlayer(
        'p12',
        'Robin',
        'Sommer',
        'Wolfsburg',
        't_wob',
        4,
        14,
        59.0,
        860,
        8900000,
        1,
        9200000,
        expiry,
        seller,
      ),
      _marketPlayer(
        'p13',
        'Marco',
        'Klein',
        'Schalke',
        't_s04',
        3,
        22,
        47.0,
        680,
        6200000,
        0,
        6400000,
        expiry,
        seller,
      ),
      _marketPlayer(
        'p14',
        'Stefan',
        'Lang',
        'Bremen',
        't_svw',
        2,
        16,
        40.0,
        590,
        7500000,
        -1,
        7300000,
        expiry,
        seller,
      ),
    ];
  }

  MarketPlayer _marketPlayer(
    String id,
    String first,
    String last,
    String team,
    String teamId,
    int pos,
    int number,
    double avg,
    int total,
    int mv,
    int mvTrend,
    int price,
    String expiry,
    MarketSeller seller,
  ) => MarketPlayer(
    id: id,
    firstName: first,
    lastName: last,
    profileBigUrl: '',
    teamName: team,
    teamId: teamId,
    position: pos,
    number: number,
    averagePoints: avg,
    totalPoints: total,
    marketValue: mv,
    marketValueTrend: mvTrend,
    price: price,
    expiry: expiry,
    offers: 0,
    seller: seller,
    stl: 0,
    status: 0,
    exs: 0,
  );

  // ── Aufstellung ──────────────────────────────────────────────────────

  @override
  Future<LineupResponse> getLineup(String leagueId) async {
    return LineupResponse(players: _demoLineup());
  }

  List<LineupPlayer> _demoLineup() => [
    _lineupPlayer('p01', 'O. Beier', 1, 't_tsg', lo: 1),
    _lineupPlayer('p02', 'N. Hübner', 2, 't_bvb', lo: 2),
    _lineupPlayer('p03', 'D. Ratzer', 2, 't_rbl', lo: 3),
    _lineupPlayer('p04', 'L. Brenner', 2, 't_b04', lo: 4),
    _lineupPlayer('p05', 'T. Meier', 3, 't_fcb', lo: 5),
    _lineupPlayer('p06', 'L. Schreiber', 3, 't_fcb', lo: 6),
    _lineupPlayer('p07', 'F. Vogel', 3, 't_b04', lo: 7),
    _lineupPlayer('p08', 'J. Koch', 3, 't_bmg', lo: 8),
    _lineupPlayer('p09', 'S. Kraft', 4, 't_sge', lo: 9),
    _lineupPlayer('p10', 'K. Bauer', 4, 't_fcb', lo: 10),
    _lineupPlayer('p11', 'L. Winter', 4, 't_vfb', lo: 11),
  ];

  LineupPlayer _lineupPlayer(
    String id,
    String name,
    int pos,
    String teamId, {
    int lo = 0,
  }) => LineupPlayer(
    id: id,
    name: name,
    position: pos,
    teamId: teamId,
    averagePoints: 55,
    totalPoints: 800,
    lineupOrder: lo,
    performanceHistory: [
      const PerformanceHistory(points: 65, hasPlayed: true),
      const PerformanceHistory(points: 42, hasPlayed: true),
      const PerformanceHistory(points: 0, hasPlayed: false),
      const PerformanceHistory(points: 78, hasPlayed: true),
      const PerformanceHistory(points: 55, hasPlayed: true),
    ],
  );

  // ── Transfers ────────────────────────────────────────────────────────

  @override
  Future<List<Transfer>> getTransfers(String leagueId, String userId) async {
    return [
      Transfer(
        id: 'tr01',
        leagueId: demoLeagueId,
        fromUserId: 'demo_user_002',
        toUserId: userId,
        playerId: 'p07',
        price: 38500000,
        marketValue: 41000000,
        playerName: 'F. Vogel',
        fromUsername: 'Karl Demomann',
        toUsername: 'Max Mustermann',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        status: 'completed',
      ),
      Transfer(
        id: 'tr02',
        leagueId: demoLeagueId,
        fromUserId: userId,
        toUserId: 'demo_user_003',
        playerId: 'p_old',
        price: 12000000,
        marketValue: 11500000,
        playerName: 'R. Alt',
        fromUsername: 'Max Mustermann',
        toUsername: 'Lisa Spielerin',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        status: 'completed',
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> getManagerTransferHistory(
    String leagueId,
    String userId, {
    String? start,
  }) async {
    return {
      'u': userId,
      'unm': userId == 'demo_user_002' ? 'Karl Demomann' : 'Demo Manager',
      'it': [
        {
          'dt': DateTime.now()
              .subtract(const Duration(days: 14))
              .toUtc()
              .toIso8601String(),
          'pi': 'p07',
          'pn': 'F. Vogel',
          'tid': 'demo-history-$userId',
          'trp': 45000000,
          'tty': 1,
        },
      ],
    };
  }

  // ── Sonstige Endpunkte (Mindest-Implementierungen) ───────────────────

  @override
  Future<Map<String, dynamic>> getLeagueRanking(
    String leagueId, {
    int? matchDay,
  }) async {
    final uid = _currentUid;
    return {
      'it': [
        {
          'id': uid,
          'name': 'Max Mustermann',
          'tn': 'FC Demo',
          'tv': 47830000,
          'b': 25200000,
          'p': 1547,
          'pl': 2,
        },
        {
          'id': 'demo_user_002',
          'name': 'Karl Demomann',
          'tn': 'Demoklub',
          'tv': 52100000,
          'b': 18700000,
          'p': 1682,
          'pl': 1,
        },
        {
          'id': 'demo_user_003',
          'name': 'Lisa Spielerin',
          'tn': 'Demo United',
          'tv': 39400000,
          'b': 31200000,
          'p': 1345,
          'pl': 3,
        },
        {
          'id': 'demo_user_004',
          'name': 'Peter Tester',
          'tn': 'Test FC',
          'tv': 35800000,
          'b': 28900000,
          'p': 1198,
          'pl': 4,
        },
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> getMySquad(String leagueId) async {
    return {
      'it': _demoSquad(userOwns: true).map((p) => _playerToJson(p)).toList(),
    };
  }

  @override
  Future<Map<String, dynamic>> getMyBudget(String leagueId) async {
    return {'b': 25200000, 'tv': 47830000};
  }

  @override
  Future<Map<String, dynamic>> getLeagueMe(String leagueId) async {
    final uid = _currentUid;
    return {
      'id': uid,
      'name': 'Max Mustermann',
      'teamName': 'FC Demo',
      'budget': 25200000,
      'teamValue': 47830000,
      'points': 1547,
      'placement': 2,
    };
  }

  @override
  Future<Map<String, dynamic>> getPlayerDetails(
    String leagueId,
    String playerId,
  ) async {
    return {'id': playerId, 'mv': 15000000, 'mvt': 0};
  }

  @override
  Future<Map<String, dynamic>> getPlayerMarketValue(
    String leagueId,
    String playerId, {
    int timeframe = 365,
  }) async {
    final timestamp = DateTime.now()
        .subtract(const Duration(days: 15))
        .millisecondsSinceEpoch;
    return {
      'it': [
        {'dt': timestamp, 'mv': 40000000},
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> getPlayerTransferHistory(
    String leagueId,
    String playerId, {
    int? matchDay,
  }) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getPlayerTransfers(
    String leagueId,
    String playerId,
  ) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getManagerDashboard(
    String leagueId,
    String userId,
  ) async {
    return {'tv': 47830000, 'b': 25200000, 'p': 1547, 'pl': 2};
  }

  @override
  Future<Map<String, dynamic>> getManagerPerformance(
    String leagueId,
    String userId,
  ) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getManagerSquad(
    String leagueId,
    String userId,
  ) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getMyEleven(String leagueId) async {
    return {
      'it': _demoLineup()
          .map((p) => {'i': p.id, 'n': p.name, 'lo': p.lineupOrder})
          .toList(),
    };
  }

  @override
  Future<Map<String, dynamic>> getScoutedPlayers(String leagueId) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getCompetitionTable(String competitionId) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getCompetitionMatchdays(
    String competitionId,
  ) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getLiveEventTypes() async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getPlayerEventHistory(
    String competitionId,
    String playerId, {
    int? matchDay,
  }) async {
    return {'it': []};
  }

  @override
  Future<Map<String, dynamic>> getUserSettings() async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> collectBonus() async {
    return {'ok': true};
  }

  // Mutations: No-ops im Demo-Modus (geben Erfolg zurück ohne etwas zu tun)

  @override
  Future<void> updateLineup(
    String leagueId,
    LineupUpdateRequest lineup,
  ) async {}

  @override
  Future<void> addScoutedPlayer(String leagueId, String playerId) async {}

  @override
  Future<void> removeScoutedPlayer(String leagueId, String playerId) async {}

  @override
  Future<void> acceptOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {}

  @override
  Future<void> declineOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {}

  @override
  Future<void> acceptKickbaseOffer(String leagueId, String playerId) async {}

  @override
  Future<Map<String, dynamic>> removePlayerFromMarket(
    String leagueId,
    String playerId,
  ) async {
    return {'ok': true};
  }

  @override
  Future<Map<String, dynamic>> withdrawOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    return {'ok': true};
  }

  @override
  Future<User> getUser() async {
    return buildDemoUser(_currentUid);
  }

  @override
  void dispose() {}

  // ── Hilfsmethode ────────────────────────────────────────────────────

  Map<String, dynamic> _playerToJson(Player p) => {
    'id': p.id,
    'firstName': p.firstName,
    'lastName': p.lastName,
    'teamName': p.teamName,
    'teamId': p.teamId,
    'position': p.position,
    'number': p.number,
    'averagePoints': p.averagePoints,
    'totalPoints': p.totalPoints,
    'marketValue': p.marketValue,
    'marketValueTrend': p.marketValueTrend,
    'status': p.status,
    'userOwnsPlayer': p.userOwnsPlayer,
  };
}
