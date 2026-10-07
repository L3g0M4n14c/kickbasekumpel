import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/presentation/pages/dashboard/team_page.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/presentation/widgets/team/player_row_with_sale.dart';

Player _buildPlayer({
  required String id,
  required int position,
  required int marketValue,
}) {
  return Player(
    id: id,
    firstName: 'Vorname',
    lastName: 'Nachname-$id',
    profileBigUrl: '', // Kein Netzwerk in Tests
    teamName: 'FC Test',
    teamId: 'team1',
    position: position,
    number: 1,
    averagePoints: 5,
    totalPoints: 50,
    marketValue: marketValue,
    marketValueTrend: 0,
    tfhmvt: 0,
    prlo: 0,
    stl: 0,
    status: 0,
    userOwnsPlayer: true,
  );
}

void main() {
  group('TeamPage Sortierung', () {
    testWidgets('sortiert standardmäßig nach Position (TW→ABW→MF→ST), '
        'innerhalb der Position nach Marktwert absteigend', (tester) async {
      final players = [
        _buildPlayer(id: 'st', position: 4, marketValue: 50000000),
        _buildPlayer(id: 'abw-arm', position: 2, marketValue: 5000000),
        _buildPlayer(id: 'mf', position: 3, marketValue: 10000000),
        _buildPlayer(id: 'tw', position: 1, marketValue: 1000000),
        _buildPlayer(id: 'abw-reich', position: 2, marketValue: 50000000),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            autoSelectFirstLeagueProvider.overrideWith((ref) async {}),
            teamPlayersProvider.overrideWith((ref) async => players),
            teamBudgetProvider.overrideWith((ref) async => 150000000),
          ],
          child: const MaterialApp(home: TeamPage()),
        ),
      );
      await tester.pumpAndSettle();

      final shownIds = tester
          .widgetList<PlayerRowWithSale>(find.byType(PlayerRowWithSale))
          .map((row) => row.player.id)
          .toList();

      expect(shownIds, ['tw', 'abw-reich', 'abw-arm', 'mf', 'st']);
    });
  });
}
