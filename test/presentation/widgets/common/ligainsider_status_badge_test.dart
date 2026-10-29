import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kickbasekumpel/data/models/ligainsider_model.dart';
import 'package:kickbasekumpel/data/providers/ligainsider_provider.dart';
import 'package:kickbasekumpel/data/services/ligainsider_lineup_index.dart';
import 'package:kickbasekumpel/data/services/ligainsider_service.dart';
import 'package:kickbasekumpel/presentation/widgets/common/ligainsider_status_badge.dart';

class _MockLigainsiderService extends Mock implements LigainsiderService {}

void main() {
  group('LigainsiderPlayerStatusUI', () {
    test('benennt die drei Ligainsider-Rollen explizit', () {
      expect(
        LigainsiderPlayerStatus.likelyStart.roleLabel,
        'Stammspieler',
      );
      expect(
        LigainsiderPlayerStatus.startWithAlternative.roleLabel,
        'Erste Option',
      );
      expect(
        LigainsiderPlayerStatus.isAlternative.roleLabel,
        'Zweite Option',
      );
      expect(LigainsiderPlayerStatus.bench.roleLabel, 'Bank');
      expect(LigainsiderPlayerStatus.out.roleLabel, 'Nicht im Kader');
    });

    test('Kurzlabels unterscheiden Stamm / 1. Option / 2. Option', () {
      expect(LigainsiderPlayerStatus.likelyStart.shortLabel, 'Stamm');
      expect(LigainsiderPlayerStatus.startWithAlternative.shortLabel, '1. Opt.');
      expect(LigainsiderPlayerStatus.isAlternative.shortLabel, '2. Opt.');
    });

    test('Icons zeigen die Options-Nummer an', () {
      expect(
        LigainsiderPlayerStatus.startWithAlternative.iconData,
        Icons.looks_one,
      );
      expect(
        LigainsiderPlayerStatus.isAlternative.iconData,
        Icons.looks_two,
      );
    });
  });

  group('LigainsiderStatusBadge', () {
    late _MockLigainsiderService service;

    Widget wrap(Widget child) => ProviderScope(
      overrides: [
        ligainsiderLineupIndexProvider.overrideWith(
            (ref) async => LigainsiderLineupIndex.fromService(service),
          ),
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );

    setUp(() {
      service = _MockLigainsiderService();
      when(() => service.isReady).thenReturn(true);
      // Volle Abdeckung: 'out' heißt 'kein S11-Platz' (nicht 'Daten fehlen').
      when(() => service.hasLineupCoverage).thenReturn(true);
    });

    testWidgets('zeigt Stammspieler-Rolle als Label', (tester) async {
      when(
        () => service.getPlayerStatus('Max', 'Mustermann'),
      ).thenReturn(LigainsiderPlayerStatus.likelyStart);

      await tester.pumpWidget(
        wrap(
          LigainsiderStatusBadge(firstName: 'Max', lastName: 'Mustermann'),
        ),
      );
      await tester.pump();

      expect(find.text('Stamm'), findsOneWidget);
    });

    testWidgets('zeigt erste und zweite Option als Label', (tester) async {
      when(
        () => service.getPlayerStatus('Max', 'Mustermann'),
      ).thenReturn(LigainsiderPlayerStatus.startWithAlternative);
      when(
        () => service.getPlayerStatus('Erika', 'Musterfrau'),
      ).thenReturn(LigainsiderPlayerStatus.isAlternative);

      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              LigainsiderStatusBadge(
                firstName: 'Max',
                lastName: 'Mustermann',
              ),
              LigainsiderStatusBadge(
                firstName: 'Erika',
                lastName: 'Musterfrau',
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('1. Opt.'), findsOneWidget);
      expect(find.text('2. Opt.'), findsOneWidget);
    });

    testWidgets('Tooltip benennt die Rolle ausgeschrieben', (tester) async {
      when(
        () => service.getPlayerStatus('Max', 'Mustermann'),
      ).thenReturn(LigainsiderPlayerStatus.isAlternative);

      await tester.pumpWidget(
        wrap(
          LigainsiderStatusBadge(firstName: 'Max', lastName: 'Mustermann'),
        ),
      );
      await tester.pump();

      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(
        tooltip.message,
        'Ligainsider: Zweite Option – Alternative',
      );
    });

    testWidgets('blendet Icon auf Wunsch aus', (tester) async {
      when(
        () => service.getPlayerStatus('Max', 'Mustermann'),
      ).thenReturn(LigainsiderPlayerStatus.likelyStart);

      await tester.pumpWidget(
        wrap(
          LigainsiderStatusBadge(
            firstName: 'Max',
            lastName: 'Mustermann',
            showIcon: false,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Stamm'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('ohne geladenen Service wird nichts angezeigt', (
      tester,
    ) async {
      when(() => service.isReady).thenReturn(false);

      await tester.pumpWidget(
        wrap(
          LigainsiderStatusBadge(firstName: 'Max', lastName: 'Mustermann'),
        ),
      );
      await tester.pump();

      expect(find.text('Stamm'), findsNothing);
    });
  });
}