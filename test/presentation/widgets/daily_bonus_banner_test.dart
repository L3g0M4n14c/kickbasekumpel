import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/providers/daily_bonus_providers.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/presentation/widgets/common/daily_bonus_banner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  late MockKickbaseAPIClient mockApi;

  Widget buildApp() {
    return ProviderScope(
      overrides: [kickbaseApiClientProvider.overrideWithValue(mockApi)],
      child: MaterialApp(
        home: Scaffold(
          body: ListView(
            children: const [DailyBonusBanner(), Text('Home-Content')],
          ),
        ),
      ),
    );
  }

  setUp(() {
    mockApi = MockKickbaseAPIClient();
    when(() => mockApi.getBaseOverview())
        .thenAnswer((_) async => {'stg': [], 'sect': []});
    when(() => mockApi.collectBonus()).thenAnswer(
      (_) async => {
        'it': [
          {'li': '1', 'lnm': 'Test Liga', 'v': 10000, 'day': 2, 'b': 100},
        ],
      },
    );
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Banner erscheint bei verfügbarem Bonus, Tap sammelt ein '
      'und zeigt den Betrag als Bestätigung', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Akzeptanzkriterium 1: Banner erscheint
    expect(find.text('Tagesbonus verfügbar'), findsOneWidget);
    expect(find.text('Tippen zum Einsammeln'), findsOneWidget);

    // Akzeptanzkriterium 2: Tap sammelt ein + Bestätigung mit Bonus-Betrag
    await tester.tap(find.byType(DailyBonusBanner));
    await tester.pumpAndSettle();

    expect(find.textContaining('10k€'), findsOneWidget);
    expect(find.textContaining('Tag 2'), findsOneWidget);
    verify(() => mockApi.collectBonus()).called(1);

    // Akzeptanzkriterium 3: Banner bleibt (bis zum nächsten Tag) ausgeblendet
    expect(find.text('Tagesbonus verfügbar'), findsNothing);
  });

  testWidgets('Banner erscheint nicht, wenn heute bereits eingesammelt wurde', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      kDailyBonusLastCollectedKey: DateTime.now().toIso8601String(),
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Tagesbonus verfügbar'), findsNothing);
    expect(find.text('Home-Content'), findsOneWidget);
  });

  testWidgets('Banner bleibt auch ohne API-Bonus-Hinweis sichtbar', (
    tester,
  ) async {
    // {"it": []} ist die Beispiel-Response der Doku und sagt nichts über
    // den Bonus-Status aus → lokaler Stand entscheidet (nicht eingesammelt).
    when(() => mockApi.getBaseOverview()).thenAnswer((_) async => {'it': []});

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Tagesbonus verfügbar'), findsOneWidget);
    verifyNever(() => mockApi.collectBonus());
  });

  testWidgets('Leeres Collect-Ergebnis: Hinweis statt Betrag, Banner aus', (
    tester,
  ) async {
    when(() => mockApi.collectBonus()).thenAnswer((_) async => {'it': []});

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DailyBonusBanner));
    await tester.pumpAndSettle();

    expect(find.text('Heute ist kein Tagesbonus verfügbar.'), findsOneWidget);
    expect(find.text('Tagesbonus verfügbar'), findsNothing);
  });

  testWidgets('Banner erscheint wieder, wenn zuletzt am Vortag eingesammelt '
      'wurde', (tester) async {
    SharedPreferences.setMockInitialValues({
      kDailyBonusLastCollectedKey: DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Tagesbonus verfügbar'), findsOneWidget);
  });
}
