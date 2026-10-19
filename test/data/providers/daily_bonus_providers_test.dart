import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/providers/daily_bonus_providers.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  late MockKickbaseAPIClient mockApi;

  /// Collect-Response der echten API (Auszug)
  Map<String, dynamic> collectResponse() => {
    'it': [
      {
        'li': '1',
        'lnm': 'Test Liga',
        'v': 10000,
        'day': 2,
        'b': 50000000,
        'lim': 'league/bild.png',
      },
    ],
  };

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [kickbaseApiClientProvider.overrideWithValue(mockApi)],
    );
  }

  setUp(() {
    mockApi = MockKickbaseAPIClient();
    SharedPreferences.setMockInitialValues({});
    when(() => mockApi.getBaseOverview())
        .thenAnswer((_) async => {'stg': [], 'sect': []});
    when(() => mockApi.collectBonus())
        .thenAnswer((_) async => collectResponse());
  });

  test(
    'Banner erscheint, wenn Bonus aussteht und noch nicht eingesammelt',
    () async {
      final container = createContainer();
      addTearDown(container.dispose);

      container.read(dailyBonusProvider);
      await pumpEventQueue();

      final state = container.read(dailyBonusProvider);
      expect(state.isAvailable, isTrue);
      expect(state.isLoading, isFalse);
      verify(() => mockApi.getBaseOverview()).called(1);
    },
  );

  test(
    'API ohne Bonus-Hinweis (leeres it) → lokaler Stand entscheidet',
    () async {
      // Die Beispiel-Response der Doku zeigt {"it": []} – das ist KEIN
      // „kein Bonus"-Signal, der Banner darf also nicht verschwinden.
      when(() => mockApi.getBaseOverview()).thenAnswer((_) async => {'it': []});

      final container = createContainer();
      addTearDown(container.dispose);

      container.read(dailyBonusProvider);
      await pumpEventQueue();

      expect(container.read(dailyBonusProvider).isAvailable, isTrue);
    },
  );

  test(
    'Tap sammelt ein: Ergebnis, Bestätigungs-Daten und Ausblenden',
    () async {
      final container = createContainer();
      addTearDown(container.dispose);

      container.read(dailyBonusProvider);
      await pumpEventQueue();

      final result = await container
          .read(dailyBonusProvider.notifier)
          .collect();

      expect(result, isNotNull);
      expect(result!.totalValue, 10000);
      expect(result.maxDay, 2);

      final state = container.read(dailyBonusProvider);
      expect(state.isAvailable, isFalse);
      expect(state.isCollecting, isFalse);
      expect(state.lastResult, result);
      expect(state.lastCollected, isNotNull);

      // Einsammel-Zeitpunkt wurde persistiert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(kDailyBonusLastCollectedKey), isNotNull);
    },
  );

  test('Banner bleibt bis zum nächsten Tag ausgeblendet', () async {
    // Heute bereits eingesammelt
    SharedPreferences.setMockInitialValues({
      kDailyBonusLastCollectedKey: DateTime.now().toIso8601String(),
    });

    final container = createContainer();
    addTearDown(container.dispose);

    container.read(dailyBonusProvider);
    await pumpEventQueue();

    expect(container.read(dailyBonusProvider).isAvailable, isFalse);
  });

  test(
    'Nach dem letzten Einsammeln am Vortag ist der Bonus wieder da',
    () async {
      SharedPreferences.setMockInitialValues({
        kDailyBonusLastCollectedKey: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      });

      final container = createContainer();
      addTearDown(container.dispose);

      container.read(dailyBonusProvider);
      await pumpEventQueue();

      expect(container.read(dailyBonusProvider).isAvailable, isTrue);
    },
  );

  test('Fehlende Overview-API bricht den Status-Check nicht ab', () async {
    when(() => mockApi.getBaseOverview()).thenThrow(Exception('offline'));

    final container = createContainer();
    addTearDown(container.dispose);

    container.read(dailyBonusProvider);
    await pumpEventQueue();

    // Lokaler Stand entscheidet: nicht eingesammelt → verfügbar
    expect(container.read(dailyBonusProvider).isAvailable, isTrue);
  });

  test(
    'Fehler beim Einsammeln: Fehler-State, Banner bleibt sichtbar',
    () async {
      when(() => mockApi.collectBonus()).thenThrow(Exception('boom'));

      final container = createContainer();
      addTearDown(container.dispose);

      container.read(dailyBonusProvider);
      await pumpEventQueue();

      final result = await container
          .read(dailyBonusProvider.notifier)
          .collect();

      expect(result, isNull);
      final state = container.read(dailyBonusProvider);
      expect(state.error, contains('boom'));
      expect(state.isCollecting, isFalse);
      expect(state.isAvailable, isTrue);
    },
  );

  test('Leeres Collect-Ergebnis: Banner aus, bis zum nächsten Tag', () async {
    when(() => mockApi.collectBonus()).thenAnswer((_) async => {'it': []});

    final container = createContainer();
    addTearDown(container.dispose);

    container.read(dailyBonusProvider);
    await pumpEventQueue();

    final result = await container.read(dailyBonusProvider.notifier).collect();

    expect(result, isNotNull);
    expect(result!.collections, isEmpty);
    expect(container.read(dailyBonusProvider).isAvailable, isFalse);

    // Persistiert → auch beim nächsten Start ausgeblendet
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(kDailyBonusLastCollectedKey), isNotNull);
  });
}
