import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-State der Manager-Auswahl für den Direktvergleich.
///
/// In der Rangliste (`LeagueStandingsPage`) kann der Auswahlmodus aktiviert
/// werden; per Tap werden dann bis zu zwei Manager für den Vergleich
/// („Du vs. Rivale") ausgewählt.
class ManagerComparisonSelection {
  /// Erstellt den Auswahl-Zustand.
  const ManagerComparisonSelection({
    this.active = false,
    this.selectedIds = const [],
  });

  /// Maximale Anzahl gleichzeitig auswählbarer Manager.
  static const int maxSelection = 2;

  /// Auswahlmodus aktiv?
  final bool active;

  /// Ausgewählte Manager-IDs (max. [maxSelection], in Auswahlreihenfolge).
  final List<String> selectedIds;

  /// Sind bereits [maxSelection] Manager ausgewählt?
  bool get isFull => selectedIds.length >= maxSelection;

  /// Ist [managerId] aktuell ausgewählt?
  bool contains(String managerId) => selectedIds.contains(managerId);
}

/// Notifier für die Manager-Auswahl des Direktvergleichs.
///
/// Reine UI-Zustandslogik (Auswahlmodus, ab-/zugeschaltete Manager) – die
/// Vergleichsdaten selbst lädt der `managerComparisonProvider`.
class ManagerComparisonSelectionNotifier
    extends Notifier<ManagerComparisonSelection> {
  @override
  ManagerComparisonSelection build() => const ManagerComparisonSelection();

  /// Schaltet den Auswahlmodus an/aus.
  ///
  /// Beim Deaktivieren wird die Auswahl geleert.
  void toggleActive() {
    if (state.active) {
      state = const ManagerComparisonSelection();
    } else {
      state = const ManagerComparisonSelection(active: true);
    }
  }

  /// Beendet den Auswahlmodus und leert die Auswahl.
  void deactivate() {
    state = const ManagerComparisonSelection();
  }

  /// Wählt [managerId] ab bzw. zu.
  ///
  /// Bei voller Auswahl ([ManagerComparisonSelection.maxSelection]) wird die
  /// älteste Auswahl ersetzt (FIFO), damit ein Wechsel des Rivalen per Tap
  /// möglich bleibt.
  void toggle(String managerId) {
    if (!state.active || managerId.isEmpty) return;

    final selected = List<String>.of(state.selectedIds);
    if (selected.contains(managerId)) {
      selected.remove(managerId);
    } else {
      if (selected.length >= ManagerComparisonSelection.maxSelection) {
        selected.removeAt(0);
      }
      selected.add(managerId);
    }
    state = ManagerComparisonSelection(active: true, selectedIds: selected);
  }

  /// Leert die Auswahl (bleibt im Auswahlmodus).
  void clear() {
    if (!state.active) return;
    state = const ManagerComparisonSelection(active: true);
  }
}

/// Provider für die Manager-Auswahl des Direktvergleichs.
final managerComparisonSelectionProvider =
    NotifierProvider<
      ManagerComparisonSelectionNotifier,
      ManagerComparisonSelection
    >(ManagerComparisonSelectionNotifier.new);
