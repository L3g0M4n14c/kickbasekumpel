import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/common_models.dart';
import 'package:kickbasekumpel/data/models/league_model.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/presentation/pages/dashboard/market_page.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';

void main() {
  testWidgets('opens the buy sheet when a market player is tapped', (
    tester,
  ) async {
    // Arrange
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer(
      overrides: [
        marketPlayersProvider.overrideWith((ref) => Stream.value([_player])),
      ],
    );
    addTearDown(container.dispose);
    container.read(selectedLeagueProvider.notifier).select(_league);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MarketPage()),
      ),
    );
    await tester.pump();
    await tester.pump();

    // Act
    await tester.tap(find.text('Max Mustermann'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Assert
    expect(find.text('Spieler kaufen'), findsOneWidget);
  });
}

final _league = League(
  i: 'league-1',
  n: 'Test Liga',
  cu: const LeagueUser(
    id: 'manager-1',
    name: 'Manager',
    teamName: 'Test Team',
    budget: 0,
    teamValue: 0,
    points: 0,
    placement: 1,
    won: 0,
    drawn: 0,
    lost: 0,
    se11: 0,
    ttm: 0,
  ),
);

const _player = MarketPlayer(
  id: 'player-1',
  firstName: 'Max',
  lastName: 'Mustermann',
  profileBigUrl: '',
  teamName: 'FC Test',
  teamId: 'team-1',
  position: 3,
  number: 10,
  averagePoints: 5,
  totalPoints: 50,
  marketValue: 10000000,
  marketValueTrend: 0,
  price: 10000000,
  expiry: '',
  offers: 0,
  seller: MarketSeller(id: 'seller-1', name: 'Verkaeufer'),
  stl: 0,
  status: 0,
  exs: 0,
);
