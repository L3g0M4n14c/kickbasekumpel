import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/services/demo_kickbase_api_client.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';
import 'package:kickbasekumpel/data/utils/parsing_utils.dart';

/// Prüft den DEMO-Modus: DemoKickbaseAPIClient liefert Squad/Budget/Markt,
/// die Pipeline (normalize -> fromJson -> Mapping -> buildPlans) muss
/// Szenarien liefern. Liefert sie keine, ist der Fehler in der App-Pipeline
/// und nicht in den Echtdaten.
void main() {
  test('demo mode: squad + market through app pipeline yields scenarios', () async {
    final client = DemoKickbaseAPIClient();

    final squadJson = await client.getMySquad(DemoKickbaseAPIClient.demoLeagueId);
    final budgetJson = await client.getMyBudget(DemoKickbaseAPIClient.demoLeagueId);
    final marketPlayers = await client.getMarketAvailable(
      DemoKickbaseAPIClient.demoLeagueId,
    );

    final rawSquad = (squadJson['it'] as List).cast<Map<String, dynamic>>();
    final squad = rawSquad
        .map((raw) => Player.fromJson(normalizePlayerJson(raw)))
        .toList();

    final budgetValue = budgetJson['b'] ?? 0;
    final budget = budgetValue is int ? budgetValue : 0;

    final mappedMarket = marketPlayers.map((m) {
      return Player(
        id: m.id,
        firstName: m.firstName,
        lastName: m.lastName,
        profileBigUrl: m.profileBigUrl,
        teamName: m.teamName,
        teamId: m.teamId,
        position: m.position,
        number: m.number,
        averagePoints: m.averagePoints,
        totalPoints: m.totalPoints,
        marketValue: m.price,
        marketValueTrend: m.marketValueTrend,
        tfhmvt: m.marketValueTrend,
        prlo: m.prlo ?? 0,
        stl: m.stl,
        status: m.status,
        userOwnsPlayer: false,
      );
    }).toList();

    // ignore: avoid_print
    print('demo squad=${squad.length} budget=$budget market=${mappedMarket.length}');
    // ignore: avoid_print
    print('squad positions: ${squad.map((p) => p.position).toList()}');
    // ignore: avoid_print
    print('squad avg: ${squad.map((p) => p.averagePoints).toList()}');
    // ignore: avoid_print
    print('market avg/price/pos: ${mappedMarket.map((p) => "${p.position}:${p.averagePoints}:${p.marketValue}").toList()}');

    final service = TransferPlannerService();
    final result = service.buildPlans(
      TransferPlannerInput(
        squadPlayers: squad,
        marketPlayers: mappedMarket,
        currentBudget: budget,
      ),
    );

    // ignore: avoid_print
    print('DEMO scenarios: ${result.scenarios.length} / ${result.noPlanReason}');
    for (final s in result.scenarios) {
      // ignore: avoid_print
      print('  - ${s.title} | gain=${s.score.startingElevenGain} | budgetAfter=${s.budgetAfter}');
    }

    expect(result.scenarios, isNotEmpty);
  });
}
