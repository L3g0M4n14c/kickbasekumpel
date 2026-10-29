import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kickbasekumpel/data/models/ligainsider_match_model.dart';
import 'package:kickbasekumpel/data/providers/ligainsider_provider.dart';
import 'package:kickbasekumpel/data/providers/service_providers.dart';
import 'package:kickbasekumpel/data/services/ligainsider_service.dart';

class _MockLigainsiderService extends Mock implements LigainsiderService {}

void main() {
  group('ligainsiderPreloadProvider', () {
    test('lädt die Aufstellungen genau einmal vor', () async {
      final service = _MockLigainsiderService();
      when(() => service.ensureLoaded()).thenAnswer((_) async {});

      final container = ProviderContainer(
        retry: (retryCount, error) => null,
        overrides: [
          ligainsiderServiceFutureProvider.overrideWith((ref) async => service),
          ligainsiderMatchesProvider.overrideWith(
            (ref) async => const <LigainsiderMatch>[],
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(ligainsiderPreloadProvider.future);

      verify(() => service.ensureLoaded()).called(1);
    });

    test('wirft nicht, wenn der Service nicht verfügbar ist', () async {
      final container = ProviderContainer(
        retry: (retryCount, error) => null,
        overrides: [
          ligainsiderServiceFutureProvider.overrideWith(
            (ref) async => throw Exception('offline'),
          ),
          ligainsiderMatchesProvider.overrideWith(
            (ref) async => const <LigainsiderMatch>[],
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
