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
  int? marketValueAt(
    List<MarketValueEntry> marketValues,
    DateTime transferTimestamp,
  ) {
    // entry.dt ist in Tagen seit 1.1.1970 (Unix-Timestamp in Tagen)
    // transferTimestamp ist ein DateTime-Objekt
    // Wir müssen entry.dt in DateTime umwandeln, um es zu vergleichen
    final transferDaysSinceEpoch =
        transferTimestamp.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

    MarketValueEntry? closestEntry;

    for (final entry in marketValues) {
      // entry.dt ist bereits in Tagen seit 1.1.1970
      if (entry.dt > transferDaysSinceEpoch) continue;
      if (closestEntry == null || entry.dt > closestEntry.dt) {
        closestEntry = entry;
      }
    }

    return closestEntry?.mv;
  }

  int _asInt(Object? value) => switch (value) {
    int value => value,
    num value => value.toInt(),
    String value => int.tryParse(value) ?? 0,
    _ => 0,
  };

  DateTime _asDateTime(Object? value) {
    if (value is num) {
      final milliseconds = value.abs() < 100000000000
          ? value.toInt() * 1000
          : value.toInt();
      return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
    }
    return DateTime.tryParse(value?.toString() ?? '')?.toUtc() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
