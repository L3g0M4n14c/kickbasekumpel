import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kickbasekumpel/data/models/league_model.dart';
import 'package:kickbasekumpel/data/models/lineup_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/providers/player_providers.dart';
import 'package:kickbasekumpel/data/providers/service_providers.dart';
import 'package:kickbasekumpel/data/services/ligainsider_service.dart';
import 'package:kickbasekumpel/data/models/ligainsider_model.dart';
import 'package:kickbasekumpel/presentation/pages/dashboard/lineup_page.dart';

class _MockLigainsiderService extends Mock implements LigainsiderService {}

LineupPlayer _player({required String id, required String name, int lo = 0}) {
  return LineupPlayer(
    id: id,
    name: name,
    position: 2,
    teamId: 'team-1',
    averagePoints: 5,
    totalPoints: 50,
    lineupOrder: lo,
  );
}

void main() {
  group('Ligainsider-Rolle in der Aufstellung', () {
    late _MockLigainsiderService service;

    setUp(() {
      service = _MockLigainsiderService();
      when(() => service.isReady).thenReturn(true);
      when(() => service.getPlayerStatus(any(), any())).thenReturn(
        LigainsiderPlayerStatus.out,
      );
    });

    Future<void> pumpLineup(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        retry: (failureCount, error) => null,
        overrides: [
          ligainsiderServiceFutureProvider.overrideWith((ref) async => service),
          myLineupProvider.overrideWith(
            (ref, leagueId) async => [
              _player(id: 's11', name: 'Stammspieler', lo: 1),
              _player(id: 'opt1', name: 'Erste Option', lo: 2),
              _player(id: 'opt2', name: 'Zweite Option', lo: 0),
            ],
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(selectedLeagueProvider.notifier).select(
        const League(
          i: 'league-1',
          n: 'Test Liga',
          cu: LeagueUser(
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
        ),
      );

      when(
        () => service.getPlayerStatus('', 'Stammspieler'),
      ).thenReturn(LigainsiderPlayerStatus.likelyStart);
      when(
        () => service.getPlayerStatus('', 'Erste Option'),
      ).thenReturn(LigainsiderPlayerStatus.startWithAlternative);
      when(
        () => service.getPlayerStatus('', 'Zweite Option'),
      ).thenReturn(LigainsiderPlayerStatus.isAlternative);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: LineupPage()),
        ),
      );
      await tester.pump();
      await tester.pump();
    }

    testWidgets('zeigt Stamm / 1. Option / 2. Option für Startelf und Bank', (
      tester,
    ) async {
      await pumpLineup(tester);

      // Zwei sichtbare Vorkommen: Formations-Plakette (ohne Label) und
      // Bank-Zeile (mit Label) – der Starter steht nur auf dem Platz.
      expect(find.text('Stamm'), findsWidgets);
      expect(find.text('1. Opt.'), findsWidgets);
      expect(find.text('2. Opt.'), findsWidgets);
    });

    testWidgets('Bank-Spieler zeigt die Rolle als Label', (tester) async {
      await pumpLineup(tester);

      // 'Zweite Option' (lo=0) sitzt auf der Bank → Label im Bank-Tile.
      final bankLabels = find
          .descendant(
            of: find.byType(ListTile),
            matching: find.text('2. Opt.'),
          )
          .evaluate();
      expect(bankLabels, isNotEmpty);
    });
  });
}