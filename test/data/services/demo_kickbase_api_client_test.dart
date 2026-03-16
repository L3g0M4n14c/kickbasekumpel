import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/lineup_model.dart';
import 'package:kickbasekumpel/data/services/demo_kickbase_api_client.dart';

void main() {
  late DemoKickbaseAPIClient client;

  setUp(() {
    client = DemoKickbaseAPIClient();
  });

  group('DemoKickbaseAPIClient – Token Management', () {
    test('hasAuthToken gibt immer true zurück', () async {
      expect(await client.hasAuthToken(), isTrue);
    });

    test('getAuthToken gibt den Demo-Token zurück', () async {
      expect(await client.getAuthToken(), DemoKickbaseAPIClient.demoToken);
    });

    test('setAuthToken und clearAuthToken sind No-Ops', () async {
      // Dürfen keine Exception werfen
      await expectLater(client.setAuthToken('beliebig'), completes);
      await expectLater(client.clearAuthToken(), completes);
      // Token bleibt weiterhin der Demo-Token
      expect(await client.getAuthToken(), DemoKickbaseAPIClient.demoToken);
    });
  });

  group('DemoKickbaseAPIClient – Auth: Login', () {
    test(
      'login mit beliebigen Credentials gibt Demo-LoginResponse zurück',
      () async {
        final response = await client.login('x@x.de', 'beliebig');
        expect(response.tkn, DemoKickbaseAPIClient.demoToken);
        expect(response.loginUser, isNotNull);
        expect(response.loginUser!.email, DemoKickbaseAPIClient.demoEmail);
      },
    );
  });

  group('DemoKickbaseAPIClient – Ligen', () {
    test('getLeagues gibt genau eine Demo-Liga zurück', () async {
      final leagues = await client.getLeagues();
      expect(leagues, hasLength(1));
      expect(leagues.first.i, DemoKickbaseAPIClient.demoLeagueId);
      expect(leagues.first.n, DemoKickbaseAPIClient.demoLeagueName);
    });

    test('getLeague gibt immer die Demo-Liga zurück', () async {
      final league = await client.getLeague('irgendeine-id');
      expect(league.i, DemoKickbaseAPIClient.demoLeagueId);
    });

    test('Demo-Liga hat einen gültigen LeagueUser', () async {
      final league = await client.getLeagues();
      final cu = league.first.cu;
      expect(cu.teamValue, greaterThan(0));
      expect(cu.budget, greaterThan(0));
      expect(cu.points, greaterThan(0));
    });
  });

  group('DemoKickbaseAPIClient – Spieler', () {
    test('getLeaguePlayers gibt mindestens 11 Spieler zurück', () async {
      final players = await client.getLeaguePlayers('demo-liga-001');
      expect(players.length, greaterThanOrEqualTo(11));
    });

    test('getLeaguePlayers enthält eigene und fremde Spieler', () async {
      final players = await client.getLeaguePlayers('demo-liga-001');
      expect(players.any((p) => p.userOwnsPlayer), isTrue);
      expect(players.any((p) => !p.userOwnsPlayer), isTrue);
    });

    test('Spieler haben gültige Positionen (1–4)', () async {
      final players = await client.getLeaguePlayers('demo-liga-001');
      for (final p in players) {
        expect(p.position, inInclusiveRange(1, 4));
      }
    });

    test('Spieler haben positive Marktwerte', () async {
      final players = await client.getLeaguePlayers('demo-liga-001');
      for (final p in players) {
        expect(p.marketValue, greaterThan(0));
      }
    });
  });

  group('DemoKickbaseAPIClient – Markt', () {
    test('getMarketAvailable gibt Markt-Spieler zurück', () async {
      final market = await client.getMarketAvailable('demo-liga-001');
      expect(market, isNotEmpty);
    });

    test('Markt-Spieler haben einen Preis und Ablaufzeitpunkt', () async {
      final market = await client.getMarketAvailable('demo-liga-001');
      for (final mp in market) {
        expect(mp.price, greaterThan(0));
        expect(mp.expiry, isNotEmpty);
        expect(mp.seller.name, isNotEmpty);
      }
    });
  });

  group('DemoKickbaseAPIClient – Aufstellung', () {
    test('getLineup gibt 11 Spieler zurück', () async {
      final lineup = await client.getLineup('demo-liga-001');
      expect(lineup.players, hasLength(11));
    });

    test('Aufstell-Spieler haben lineupOrder >= 1', () async {
      final lineup = await client.getLineup('demo-liga-001');
      for (final p in lineup.players) {
        expect(p.lineupOrder, greaterThanOrEqualTo(1));
      }
    });

    test('Aufstell-Spieler haben Performance-Historie', () async {
      final lineup = await client.getLineup('demo-liga-001');
      for (final p in lineup.players) {
        expect(p.performanceHistory, isNotNull);
        expect(p.performanceHistory!, isNotEmpty);
      }
    });
  });

  group('DemoKickbaseAPIClient – Transfers', () {
    test('getTransfers gibt Demo-Transfers zurück', () async {
      final transfers = await client.getTransfers('demo-liga-001', 'user-x');
      expect(transfers, isNotEmpty);
    });

    test('Transfers haben gültige Preise', () async {
      final transfers = await client.getTransfers('demo-liga-001', 'user-x');
      for (final t in transfers) {
        expect(t.price, greaterThan(0));
        expect(t.playerName, isNotEmpty);
      }
    });
  });

  group('DemoKickbaseAPIClient – buildDemoUser', () {
    test('buildDemoUser ohne UID nutzt Fallback-ID', () {
      final user = DemoKickbaseAPIClient.buildDemoUser();
      expect(user.i, 'demo_user_000');
      expect(user.em, DemoKickbaseAPIClient.demoEmail);
    });

    test('buildDemoUser mit UID nutzt diese UID', () {
      const testUid = 'firebase-anon-uid-123';
      final user = DemoKickbaseAPIClient.buildDemoUser(testUid);
      expect(user.i, testUid);
    });

    test('Demo-User hat realistische Werte', () {
      final user = DemoKickbaseAPIClient.buildDemoUser();
      expect(user.b, greaterThan(0));
      expect(user.tv, greaterThan(0));
      expect(user.p, greaterThan(0));
      expect(user.n, isNotEmpty);
      expect(user.tn, isNotEmpty);
    });
  });

  group('DemoKickbaseAPIClient – Mutations als No-Ops', () {
    test('updateLineup wirft keine Exception', () async {
      await expectLater(
        client.updateLineup(
          'demo-liga-001',
          const LineupUpdateRequest(playerIds: []),
        ),
        completes,
      );
    });

    test('addScoutedPlayer wirft keine Exception', () async {
      await expectLater(
        client.addScoutedPlayer('demo-liga-001', 'player-id'),
        completes,
      );
    });
  });
}
