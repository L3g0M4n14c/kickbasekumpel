import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kickbasekumpel/data/providers/ligainsider_provider.dart';
import 'package:kickbasekumpel/data/services/ligainsider_lineup_index.dart';
import 'package:kickbasekumpel/data/services/ligainsider_service.dart';

class _MockLigainsiderService extends Mock implements LigainsiderService {}

void main() {
  group('ligainsiderPreloadProvider', () {
    late _MockLigainsiderService service;

    setUp(() {
      service = _MockLigainsiderService();
      when(() => service.hasLineupCoverage).thenReturn(true);
    });

    test('lädt den Status-Index beim App-Start vor', () async {
      var indexCalls = 0;

      final container = ProviderContainer(
        retry: (retryCount, error) => null,
        overrides: [
          ligainsiderLineupIndexProvider.overrideWith((ref) async {
            indexCalls++;
            return LigainsiderLineupIndex.fromService(service);
          }),
        ],
      );
      addTearDown(container.dispose);

      await container.read(ligainsiderPreloadProvider.future);

      expect(indexCalls, 1);
      final index = await container.read(
        ligainsiderLineupIndexProvider.future,
      );
      expect(index.hasCoverage, true);
    });

    test('wirft nicht, wenn keine Aufstellungen verfügbar sind', () async {
      final container = ProviderContainer(
        retry: (retryCount, error) => null,
        overrides: [
          ligainsiderLineupIndexProvider.overrideWith(
            (ref) async => throw Exception('offline'),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Der Preload ist ein Komfort-Feature – er darf den App-Start nie
      // mit einem Fehler abbrechen.
      await expectLater(
        container.read(ligainsiderPreloadProvider.future),
        completes,
      );
    });
  });
}
