import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/presentation/providers/manager_comparison_providers.dart';

void main() {
  group('ManagerComparisonSelectionNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    ManagerComparisonSelectionNotifier notifier() =>
        container.read(managerComparisonSelectionProvider.notifier);

    ManagerComparisonSelection state() =>
        container.read(managerComparisonSelectionProvider);

    test('startet und beendet den Auswahlmodus', () {
      expect(state().active, isFalse);

      notifier().toggleActive();
      expect(state().active, isTrue);

      notifier().toggleActive();
      expect(state().active, isFalse);
    });

    test('toggle wählt Manager ab und zu', () {
      notifier().toggleActive();
      notifier().toggle('m1');
      notifier().toggle('m2');

      expect(state().selectedIds, ['m1', 'm2']);

      notifier().toggle('m1');
      expect(state().selectedIds, ['m2']);
    });

    test('begrenzt die Auswahl auf zwei Manager und ersetzt die älteste', () {
      notifier().toggleActive();
      notifier().toggle('m1');
      notifier().toggle('m2');
      notifier().toggle('m3');

      expect(state().selectedIds, ['m2', 'm3']);
    });

    test('ignoriert Taps ohne aktiven Auswahlmodus', () {
      notifier().toggle('m1');

      expect(state().selectedIds, isEmpty);
    });

    test('clear leert die Auswahl, deactivate beendet den Modus', () {
      notifier().toggleActive();
      notifier().toggle('m1');
      notifier().clear();

      expect(state().active, isTrue);
      expect(state().selectedIds, isEmpty);

      notifier().toggle('m2');
      notifier().deactivate();

      expect(state().active, isFalse);
      expect(state().selectedIds, isEmpty);
    });
  });
}
