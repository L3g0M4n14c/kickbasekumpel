import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Umschalter der Aufstellungs-Ansicht (UI-Selection).
class LineupViewNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void showRecommended(bool value) => state = value;
}

/// false = aktuelle Aufstellung, true = empfohlene Aufstellung.
final lineupViewProvider = NotifierProvider<LineupViewNotifier, bool>(
  LineupViewNotifier.new,
);
