import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/providers/budget_calculation_providers.dart';

void main() {
  group('leagueSeasonStartDateProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('liefert die fest hinterlegte Saisonstart-Konstante (21.08.2026)',
        () async {
      final result = await container.read(
        leagueSeasonStartDateProvider('league-1').future,
      );

      expect(result, DateTime.utc(2026, 8, 21));
      expect(result, kLeagueSeasonStartDate);
    });

    test('liefert für jede Liga dasselbe Datum (kein API-Call nötig)', () async {
      final a = await container.read(leagueSeasonStartDateProvider('league-1').future);
      final b = await container.read(leagueSeasonStartDateProvider('league-2').future);

      expect(a, b);
    });
  });
}
