import '../models/market_value_model.dart';
import '../models/transfer_model.dart';

/// Ermittelt historische Marktwerte fuer Manager-Transferdaten und
/// aggregiert Käufe pro Wochentag/Zeitfenster für die Nachfrage-Analyse
/// des Verkaufs-Timings (Story #15).
class ManagerTransferHistoryService {
  /// Normalisiert die Kurzfelder der Manager-Transferantwort.
  List<ManagerTransferHistoryEntry> transfersFromResponse({
    required String leagueId,
    required Map<String, dynamic> response,
  }) {
    final managerId = response['u']?.toString() ?? '';
    final managerName = response['unm']?.toString() ?? '';
    final rawTransfers = response['it'] as List<dynamic>? ?? const [];

    return rawTransfers
        .whereType<Map<String, dynamic>>()
        .map(
          (rawTransfer) => ManagerTransferHistoryEntry(
            id: rawTransfer['tid']?.toString() ?? '',
            leagueId: leagueId,
            managerId: managerId,
            managerName: managerName,
            playerId: rawTransfer['pi']?.toString() ?? '',
            playerName: rawTransfer['pn']?.toString() ?? '',
            price: _asInt(rawTransfer['trp']),
            transferType: _asInt(rawTransfer['tty']),
            timestamp: _asDateTime(rawTransfer['dt']),
          ),
        )
        .toList();
  }

  /// Ergaenzt jeden Transfer um den Marktwert zum Transferzeitpunkt.
  List<ManagerTransferHistoryEntry> enrichWithMarketValues(
    List<ManagerTransferHistoryEntry> transfers,
    Map<String, List<MarketValueEntry>> marketValuesByPlayer,
  ) {
    return transfers
        .map(
          (transfer) => transfer.copyWith(
            marketValueAtTransfer: marketValueAt(
              marketValuesByPlayer[transfer.playerId] ?? const [],
              transfer.timestamp,
            ),
          ),
        )
        .toList();
  }

  /// Liefert den letzten bekannten Marktwert am oder vor [transferTimestamp].
  ///
  /// Die entry.dt Felder in MarketValueEntry sind laut API teils Tage seit 1970 (altes Format, z.B. 19343)
  /// und teils Unix-Timestamps in Millisekunden (z.B. 1736812800000, siehe demo_kickbase_api_client).
  /// Diese Methode normalisiert beide transparent.
  int? marketValueAt(
    List<MarketValueEntry> marketValues,
    DateTime transferTimestamp,
  ) {
    final transferMillisSinceEpoch = transferTimestamp.millisecondsSinceEpoch;

    MarketValueEntry? closestEntry;
    int? closestMs;

    for (final entry in marketValues) {
      final entryMs = _normalizeMarketValueDt(entry.dt);
      if (entryMs > transferMillisSinceEpoch) continue;
      if (closestEntry == null || entryMs > closestMs!) {
        closestEntry = entry;
        closestMs = entryMs;
      }
    }

    return closestEntry?.mv;
  }

  /// Liefert den ersten Marktwert ab [from] (chronologisch nächster Eintrag).
  ///
  /// Gegenstück zu [marketValueAt]: Werte, die mit einer Berechnung
  /// festgeschrieben wurden (z.B. Auto-Verkauf mit der finalen
  /// Spieltagsberechnung), erscheinen in der Marktwert-Historie erst AB dem
  /// Berechnungszeitpunkt – ein "letzter Eintrag ≤ Stichtag" würde den Stand
  /// DAVOR liefern.
  int? marketValueOnOrAfter(
    List<MarketValueEntry> marketValues,
    DateTime from,
  ) {
    final fromMillis = from.toUtc().millisecondsSinceEpoch;

    MarketValueEntry? earliestEntry;
    int? earliestMs;

    for (final entry in marketValues) {
      final entryMs = _normalizeMarketValueDt(entry.dt);
      if (entryMs < fromMillis) continue;
      if (earliestEntry == null || entryMs < earliestMs!) {
        earliestEntry = entry;
        earliestMs = entryMs;
      }
    }

    return earliestEntry?.mv;
  }

  /// Der von Kickbase fuer einen Kauf verwendete Transfer-Typ.
  static const int purchaseTransferType = 1;

  /// Mindest-Zeitspanne der ausgewerteten Käufe, damit die Nachfrage-Aussage
  /// belastbar ist (Akzeptanzkriterium Story #15: mindestens 4 Wochen Daten).
  static const Duration minDemandDataSpan = Duration(days: 28);

  /// Mindestanzahl Käufe, damit der Vergleich der Zeitfenster
  /// aussagekräftig ist – darunter entfaellt der Hinweis.
  static const int minDemandPurchases = 7;

  /// Ab diesem Vielfachen des Durchschnitts gilt ein Zeitfenster als
  /// „Nachfrage hoch".
  static const double highDemandRatio = 1.5;

  /// Bis zu diesem Vielfachen des Durchschnitts gilt ein Zeitfenster als
  /// „Nachfrage niedrig".
  static const double lowDemandRatio = 0.5;

  /// Aggregiert die Käufe ([purchaseTransferType]) pro Wochentag und
  /// Zeitfenster. Verkäufe und andere Transfer-Typen bleiben unberücksichtigt.
  ///
  /// Wochentag/Stunde werden in lokaler Zeit des Geräts bestimmt, damit das
  /// aktuelle Zeitfenster zur Uhrzeit des Nutzers passt.
  Map<DemandWindow, int> purchasesByTimeWindow(
    List<ManagerTransferHistoryEntry> transfers,
  ) {
    final counts = <DemandWindow, int>{};
    for (final transfer in transfers) {
      if (transfer.transferType != purchaseTransferType) continue;
      final local = transfer.timestamp.toLocal();
      final window = DemandWindow(
        weekday: local.weekday,
        slot: DemandTimeSlot.ofHour(local.hour),
      );
      counts[window] = (counts[window] ?? 0) + 1;
    }
    return counts;
  }

  /// Berechnet die Nachfrage-Intensität des Zeitfensters von [now] aus der
  /// aggregierten Transferhistorie der Liga.
  ///
  /// Die Intensität vergleicht die Käufe im aktuellen Zeitfenster mit dem
  /// Durchschnitt über alle 28 Zeitfenster (7 Wochentage x 4 Tagesblöcke):
  /// ab [highDemandRatio] x Durchschnitt „hoch", bis [lowDemandRatio] x
  /// Durchschnitt „niedrig", dazwischen „mittel".
  ///
  /// [TransferDemandProfile.intensity] ist `null`, wenn die Datenlage zu dünn
  /// ist (weniger als [minDemandDataSpan] zurückreichend oder weniger als
  /// [minDemandPurchases] Käufe) – dann soll der Hinweis entfallen.
  ///
  /// [now] ist nur für Tests gedacht (sonst aktuelle Zeit).
  TransferDemandProfile demandProfile({
    required List<ManagerTransferHistoryEntry> transfers,
    DateTime? now,
  }) {
    final referenceDate = now ?? DateTime.now();
    final purchases = transfers
        .where(
          (transfer) =>
              transfer.transferType == purchaseTransferType &&
              !transfer.timestamp.isAfter(referenceDate),
        )
        .toList();
    final purchasesByWindow = purchasesByTimeWindow(purchases);
    final totalPurchases = purchases.length;

    DateTime? oldestPurchase;
    for (final purchase in purchases) {
      if (oldestPurchase == null ||
          purchase.timestamp.isBefore(oldestPurchase)) {
        oldestPurchase = purchase.timestamp;
      }
    }

    final current = referenceDate.toLocal();
    final currentWindow = DemandWindow(
      weekday: current.weekday,
      slot: DemandTimeSlot.ofHour(current.hour),
    );
    final currentWindowPurchases = purchasesByWindow[currentWindow] ?? 0;
    final averagePurchasesPerWindow =
        totalPurchases / (DateTime.daysPerWeek * DemandTimeSlot.values.length);

    final hasSufficientData =
        totalPurchases >= minDemandPurchases &&
        oldestPurchase != null &&
        referenceDate.difference(oldestPurchase) >= minDemandDataSpan;

    DemandIntensity? intensity;
    if (hasSufficientData && averagePurchasesPerWindow > 0) {
      final ratio = currentWindowPurchases / averagePurchasesPerWindow;
      intensity = ratio >= highDemandRatio
          ? DemandIntensity.high
          : ratio <= lowDemandRatio
          ? DemandIntensity.low
          : DemandIntensity.medium;
    }

    return TransferDemandProfile(
      purchasesByWindow: purchasesByWindow,
      totalPurchases: totalPurchases,
      oldestPurchase: oldestPurchase,
      currentWindow: currentWindow,
      currentWindowPurchases: currentWindowPurchases,
      averagePurchasesPerWindow: averagePurchasesPerWindow,
      intensity: intensity,
    );
  }

  int _normalizeMarketValueDt(int dt) {
    // < 100000 -> Tage seit 1970
    if (dt.abs() < 100000) return dt * Duration.millisecondsPerDay;
    // < 1e11 -> Sekunden -> Millisekunden
    if (dt.abs() < 100000000000) return dt * 1000;
    return dt;
  }

  int _asInt(Object? value) => switch (value) {
    int value => value,
    num value => value.toInt(),
    String value => int.tryParse(value) ?? 0,
    _ => 0,
  };

  /// Konvertiere Wert in DateTime
  ///
  /// Das dt-Feld kommt als ISO-8601 String (z.B. "2026-08-21T08:59:41Z")
  /// oder als Unix-Timestamp (Millisekunden, Sekunden oder Tage) – letzteres für MarketValueEntry.
  DateTime _asDateTime(Object? value) {
    if (value is num) {
      int ms;
      if (value.abs() < 100000) {
        // Tage seit 1.1.1970
        ms = value.toInt() * Duration.millisecondsPerDay;
      } else if (value.abs() < 100000000000) {
        // Sekunden -> Millisekunden
        ms = value.toInt() * 1000;
      } else {
        ms = value.toInt();
      }
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    }
    if (value is String) {
      // ISO-8601 String parsen
      return DateTime.tryParse(value)?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}

/// 6-Stunden-Zeitfenster eines Tages für die Nachfrage-Aggregation.
enum DemandTimeSlot {
  night('Nacht', 0, '0-6 Uhr'),
  morning('Vormittag', 6, '6-12 Uhr'),
  afternoon('Nachmittag', 12, '12-18 Uhr'),
  evening('Abend', 18, '18-24 Uhr');

  const DemandTimeSlot(this.label, this.startHour, this.hourRange);

  /// Kurzlabel für das UI (z. B. „Abend").
  final String label;

  /// Erste Stunde des Fensters (0, 6, 12, 18).
  final int startHour;

  /// Stundenbereich für das UI (z. B. „18-24 Uhr").
  final String hourRange;

  /// Ordnet eine Stunde (0-23) dem passenden Zeitfenster zu.
  static DemandTimeSlot ofHour(int hour) => values[hour ~/ 6];
}

/// Ein Zeitfenster aus Wochentag und 6h-Tagesblock, in das Käufe fallen.
class DemandWindow {
  const DemandWindow({required this.weekday, required this.slot});

  /// Wochentag in DateTime-Numerierung (1 = Montag ... 7 = Sonntag).
  final int weekday;

  /// Tagesblock des Fensters.
  final DemandTimeSlot slot;

  /// Deutsche Wochentagsnamen, indexiert über `weekday - 1`.
  static const List<String> weekdayNames = [
    'Montag',
    'Dienstag',
    'Mittwoch',
    'Donnerstag',
    'Freitag',
    'Samstag',
    'Sonntag',
  ];

  /// Lesbares Label für das UI (z. B. „Sonntag, 18-24 Uhr").
  String get label => '${weekdayNames[weekday - 1]}, ${slot.hourRange}';

  @override
  bool operator ==(Object other) =>
      other is DemandWindow && other.weekday == weekday && other.slot == slot;

  @override
  int get hashCode => Object.hash(weekday, slot);

  @override
  String toString() => 'DemandWindow($label)';
}

/// Nachfrage-Intensität eines Zeitfensters relativ zum Liga-Durchschnitt.
enum DemandIntensity {
  high('hoch'),
  medium('mittel'),
  low('niedrig');

  const DemandIntensity(this.label);

  /// Deutsche Bezeichnung für das UI.
  final String label;
}

/// Aggregierte Nachfrage der Liga pro Wochentag/Zeitfenster.
///
/// Basis für den Nachfrage-Hinweis der Verkaufsempfehlung: zeigt, wie hoch
/// die Nachfrage im aktuellen Zeitfenster im Vergleich zum Durchschnitt der
/// Liga ist („Verkaufe jetzt" statt „Verkaufe irgendwann").
class TransferDemandProfile {
  const TransferDemandProfile({
    required this.purchasesByWindow,
    required this.totalPurchases,
    required this.oldestPurchase,
    required this.currentWindow,
    required this.currentWindowPurchases,
    required this.averagePurchasesPerWindow,
    required this.intensity,
  });

  /// Anzahl Käufe je Wochentag/Zeitfenster.
  final Map<DemandWindow, int> purchasesByWindow;

  /// Anzahl der ausgewerteten Käufe der gesamten Liga.
  final int totalPurchases;

  /// Zeitpunkt des ältesten ausgewerteten Kaufs (Beginn der Datenbasis).
  final DateTime? oldestPurchase;

  /// Zeitfenster, für das die Intensität bestimmt wurde.
  final DemandWindow currentWindow;

  /// Käufe im aktuellen Zeitfenster.
  final int currentWindowPurchases;

  /// Durchschnittliche Käufe pro Zeitfenster über alle 28 Fenster.
  final double averagePurchasesPerWindow;

  /// Nachfrage-Intensität des aktuellen Zeitfensters.
  ///
  /// `null` bei zu wenigen Daten (weniger als 4 Wochen Historie oder zu
  /// wenige Käufe) – dann soll der Hinweis entfallen.
  final DemandIntensity? intensity;
}
