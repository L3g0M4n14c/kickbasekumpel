import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/common_models.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';
import 'package:kickbasekumpel/presentation/widgets/market/player_market_card.dart';

void main() {
  testWidgets('zeigt den Euro-Tagestrend statt des mvt-Richtungscodes', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          marketDailyTrendsProvider.overrideWith(
            (ref) async => {'player-1': 348000},
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PlayerMarketCard(player: _player, onTap: () {}),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('↑ +€348k'), findsOneWidget);
  });
}

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
  marketValue: 11600000,
  marketValueTrend: 1,
  price: 12000000,
  expiry: '2026-02-27T00:00:00Z',
  offers: 0,
  seller: MarketSeller(id: 'seller-1', name: 'Seller'),
  stl: 0,
  status: 0,
  exs: 172800,
);
