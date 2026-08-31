import '../models/market_value_model.dart';
import '../models/transfer_model.dart';

/// Ermittelt historische Marktwerte fuer Manager-Transferdaten.
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
