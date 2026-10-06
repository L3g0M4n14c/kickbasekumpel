import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';
import 'package:kickbasekumpel/data/utils/parsing_utils.dart';

/// E2E: Rohes Kickbase-API-JSON (Schema-Shape laut docs/api-endpoints.json)
/// durch die komplette App-Pipeline:
/// normalize -> fromJson -> _mapMarketPlayerToPlayer -> buildPlans.
void main() {
  late TransferPlannerService service;

  setUp(() {
    service = TransferPlannerService();
  });

  Player mapMarketToPlayer(MarketPlayer marketPlayer) {
    // Replikat von _mapMarketPlayerToPlayer (transfer_planner_provider.dart)
    return Player(
      id: marketPlayer.id,
      firstName: marketPlayer.firstName,
      lastName: marketPlayer.lastName,
      profileBigUrl: marketPlayer.profileBigUrl,
      teamName: marketPlayer.teamName,
      teamId: marketPlayer.teamId,
      position: marketPlayer.position,
      number: marketPlayer.number,
      averagePoints: marketPlayer.averagePoints,
      totalPoints: marketPlayer.totalPoints,
      marketValue: marketPlayer.price,
      marketValueTrend: marketPlayer.marketValueTrend,
      tfhmvt: marketPlayer.marketValueTrend,
      prlo: marketPlayer.prlo ?? 0,
      stl: marketPlayer.stl,
      status: marketPlayer.status,
      userOwnsPlayer: false,
    );
  }

  test('E2E: schema-shaped squad + market JSON yields planner scenarios', () {
    // Squad-Endpoint: /v4/leagues/{leagueId}/squad -> 'it'
    final rawSquad = <Map<String, dynamic>>[
      {'ap': 35.5, 'i': 'p01', 'mv': 5500000, 'n': 'Beier', 'pos': 1, 'p': 510, 'st': 0, 'tid': 't1'},
      {'ap': 42.0, 'i': 'p02', 'mv': 12000000, 'n': 'Hübner', 'pos': 2, 'p': 630, 'st': 0, 'tid': 't2'},
      {'ap': 38.0, 'i': 'p03', 'mv': 9800000, 'n': 'Ratzer', 'pos': 2, 'p': 580, 'st': 0, 'tid': 't3'},
      {'ap': 44.0, 'i': 'p04', 'mv': 11200000, 'n': 'Brenner', 'pos': 2, 'p': 660, 'st': 0, 'tid': 't4'},
      {'ap': 67.0, 'i': 'p05', 'mv': 24500000, 'n': 'Meier', 'pos': 3, 'p': 980, 'st': 0, 'tid': 't5'},
      {'ap': 72.0, 'i': 'p06', 'mv': 19800000, 'n': 'Schreiber', 'pos': 3, 'p': 1050, 'st': 0, 'tid': 't5'},
      {'ap': 88.0, 'i': 'p07', 'mv': 41000000, 'n': 'Vogel', 'pos': 3, 'p': 1240, 'st': 0, 'tid': 't4'},
      {'ap': 54.0, 'i': 'p08', 'mv': 14200000, 'n': 'Koch', 'pos': 3, 'p': 780, 'st': 0, 'tid': 't6'},
      {'ap': 65.0, 'i': 'p09', 'mv': 18500000, 'n': 'Kraft', 'pos': 4, 'p': 940, 'st': 0, 'tid': 't7'},
      {'ap': 78.0, 'i': 'p10', 'mv': 32000000, 'n': 'Bauer', 'pos': 4, 'p': 1120, 'st': 0, 'tid': 't5'},
      {'ap': 61.0, 'i': 'p11', 'mv': 15700000, 'n': 'Winter', 'pos': 4, 'p': 890, 'st': 0, 'tid': 't8'},
    ];

    // Markt-Endpoint: /v4/leagues/{leagueId}/market -> 'it'
    final rawMarket = <Map<String, dynamic>>[
      {
        'ap': 40.0, 'dt': '2026-10-04T10:00:00Z', 'exs': 172800,
        'fn': 'Stefan', 'i': 'p14', 'iposl': false, 'isn': true,
        'mv': 7500000, 'mvt': -1, 'n': 'Lang', 'ofc': 0,
        'p': 590, 'pos': 2, 'prc': 7300000, 'st': 0,
        'tid': 't9', 'uoid': 'u_other',
      },
      {
        'ap': 85.0, 'dt': '2026-10-04T11:00:00Z', 'exs': 172800,
        'fn': 'Star', 'i': 'p20', 'iposl': false, 'isn': true,
        'mv': 45000000, 'mvt': 2, 'n': 'Spieler', 'ofc': 3,
        'p': 1300, 'pos': 3, 'prc': 46000000, 'st': 0,
        'tid': 't10', 'uoid': 'u_other2',
      },
      {
        'ap': 59.0, 'dt': '2026-10-04T12:00:00Z', 'exs': 86400,
        'fn': 'Robin', 'i': 'p12', 'iposl': false, 'isn': true,
        'mv': 8900000, 'mvt': 1, 'n': 'Sommer', 'ofc': 0,
        'p': 860, 'pos': 4, 'prc': 9200000, 'st': 0,
        'tid': 't11', 'uoid': 'u_other3',
      },
    ];

    final squad = rawSquad
        .map((raw) => Player.fromJson(normalizePlayerJson(raw)))
        .toList();
    final market = rawMarket
        .map(
          (raw) =>
              MarketPlayer.fromJson(normalizeMarketPlayerJson(raw)),
        )
        .map(mapMarketToPlayer)
        .toList();

    expect(squad, hasLength(11), reason: 'Squad-Parsing darf nichts droppen');
    expect(market, hasLength(3), reason: 'Markt-Parsing darf nichts droppen');
    expect(squad.every((p) => p.position >= 1 && p.position <= 4), isTrue);
    expect(market.every((p) => p.position >= 1 && p.position <= 4), isTrue);
    expect(squad.every((p) => p.averagePoints > 0), isTrue);
    expect(market.every((p) => p.marketValue > 0), isTrue);

    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: market,
        currentBudget: 10000000,
      ),
    );

    // ignore: avoid_print
    print('E2E scenarios: ${result.scenarios.length} / ${result.noPlanReason}');
    for (final s in result.scenarios) {
      // ignore: avoid_print
      print('  - ${s.title} | gain=${s.score.startingElevenGain}');
    }

    expect(result.scenarios, isNotEmpty);
  });
}
