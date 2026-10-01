import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/ligainsider_model.dart';
import '../../../data/providers/service_providers.dart';

/// Extension für Farbe/Icon/Label pro Ligainsider-Status.
///
/// Zentrale Darstellungslogik für alle Ligainsider-Status-Badges
/// (Markt-Card, Aufstellungs-Screen etc.).
extension LigainsiderPlayerStatusUI on LigainsiderPlayerStatus {
  /// Farbe des Badges.
  Color get color {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
        return Colors.green;
      case LigainsiderPlayerStatus.startWithAlternative:
        return Colors.lightGreen.shade700;
      case LigainsiderPlayerStatus.isAlternative:
        return Colors.orange;
      case LigainsiderPlayerStatus.bench:
        return Colors.blueGrey;
      case LigainsiderPlayerStatus.out:
        return Colors.red;
    }
  }

  /// Füllendes Material-Icon des Badges.
  IconData get iconData {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
        return Icons.check_circle;
      case LigainsiderPlayerStatus.startWithAlternative:
        return Icons.help;
      case LigainsiderPlayerStatus.isAlternative:
        return Icons.swap_horiz;
      case LigainsiderPlayerStatus.bench:
        return Icons.airline_seat_recline_normal;
      case LigainsiderPlayerStatus.out:
        return Icons.cancel;
    }
  }

  /// Kurzes Label (Badge-Text).
  String get shortLabel {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
        return 'S11';
      case LigainsiderPlayerStatus.startWithAlternative:
        return 'S11?';
      case LigainsiderPlayerStatus.isAlternative:
        return 'Alt.';
      case LigainsiderPlayerStatus.bench:
        return 'Bank';
      case LigainsiderPlayerStatus.out:
        return 'Fehlt';
    }
  }

  /// Farbe nur, wenn der Status kritisch ist (Bank/Alternativ/Fehlt) –
  /// für Umrandungen/Hervorhebungen, die positive Status neutral lassen.
  Color get alertColor {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
      case LigainsiderPlayerStatus.startWithAlternative:
        return Colors.transparent;
      case LigainsiderPlayerStatus.isAlternative:
        return Colors.orange;
      case LigainsiderPlayerStatus.bench:
        return Colors.blueGrey;
      case LigainsiderPlayerStatus.out:
        return Colors.red;
    }
  }

  /// true, wenn der Spieler voraussichtlich NICHT spielt bzw. fraglich ist.
  bool get isCritical {
    switch (this) {
      case LigainsiderPlayerStatus.likelyStart:
        return false;
      case LigainsiderPlayerStatus.startWithAlternative:
      case LigainsiderPlayerStatus.isAlternative:
      case LigainsiderPlayerStatus.bench:
      case LigainsiderPlayerStatus.out:
        return true;
    }
  }
}

/// Ligainsider-Status-Badge
///
/// Zeigt den tagesaktuellen Ligainsider-Status eines Spielers als kleines
/// Badge: Startelf (✓ S11), Startelf mit Alternative (S11?), Alternative
/// (Alt.), Bank (Bank) oder nicht im Kader (Fehlt).
///
/// Der Status wird über den gecachten [LigainsiderService] per Namens-Lookup
/// ermittelt – kein zusätzlicher Netzwerk-Request pro Card.
///
/// Verwendung:
/// ```dart
/// LigainsiderStatusBadge(firstName: player.firstName, lastName: player.lastName)
/// // oder kompakt ohne Label (nur Icon):
/// LigainsiderStatusBadge(firstName: '', lastName: player.name, showLabel: false)
/// ```
class LigainsiderStatusBadge extends ConsumerWidget {
  /// Vorname (kann leer sein – Lookup läuft dann nur über den Nachnamen).
  final String firstName;

  /// Nachname (Pflicht für den Lookup).
  final String lastName;

  /// Kurzes Label neben dem Icon anzeigen (default: ja).
  final bool showLabel;

  /// Optische Größe des Badges.
  final double fontSize;

  const LigainsiderStatusBadge({
    super.key,
    required this.firstName,
    required this.lastName,
    this.showLabel = true,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsync = ref.watch(ligainsiderServiceFutureProvider);
    final service = serviceAsync.asData?.value;

    // Service noch nicht initialisiert (z.B. offline) → gar nichts anzeigen.
    if (service == null || !service.isReady) return const SizedBox.shrink();

    if (lastName.trim().isEmpty) return const SizedBox.shrink();

    final status = service.getPlayerStatus(firstName, lastName);
    final color = status.color;
    final description = status.description;

    final icon = Icon(status.iconData, size: fontSize + 3, color: color);

    if (!showLabel) {
      return Tooltip(
        message: 'Ligainsider: $description',
        child: icon,
      );
    }

    return Tooltip(
      message: 'Ligainsider: $description',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 2),
            Text(
              status.shortLabel,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
