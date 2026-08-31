import '../models/budget_calculation_model.dart';
import '../models/market_value_model.dart';
import '../models/performance_model.dart';
import '../models/transfer_model.dart';
import 'manager_transfer_history_service.dart';

/// Ergebnis der Auto-Verkauf-Auswertung (250er-Regel).
class AutoSaleComputation {
  /// Summe aller Marktwert-Einnahmen durch automatische Verkäufe.
  final int totalIncome;

  /// Die einzelnen Verkauf-Ereignisse (einmal pro Spieler).
  final List<AutoSaleEvent> events;

  const AutoSaleComputation({required this.totalIncome, required this.events});
}

/// Ein Besitz-Zeitraum eines Spielers beim Manager.
///
/// Wird aus der Transfer-Historie rekonstruiert: Ein Kauf (transferType == 1)
/// eröffnet den Besitz, ein Verkauf (transferType == 2) beendet ihn. Spieler
/// ohne Kauf im Saisonzeitraum (Initialkader / Zulostung) gehören dem Manager
/// ab Saisonbeginn. Auto-Verkäufe erscheinen NICHT in der Historie – ein
/// nicht geschlossener Zeitraum bedeutet also "bis heute im Besitz" (ein
/// eigener manueller Verkauf würde die Periode schließen).
class OwnershipPeriod {
  final String playerId;
  final String playerName;
  final DateTime start;

  /// Ende des Besitzes (Verkaufszeitpunkt) oder null, solange im Besitz.
  final DateTime? end;

  const OwnershipPeriod({
    required this.playerId,
    required this.playerName,
    required this.start,
    this.end,
  });

  /// true, wenn der Besitz den Zeitpunkt [t] umfasst.
  bool covers(DateTime t) =>
      !t.isBefore(start) && (end == null || t.isBefore(end!));
}

/// Ermittelt die Budget-Einnahmen durch den automatischen Spielerverkauf
/// ("Auto-Verkauf", 250er-Regel, Kickbase-Update 4.8.0).
///
/// Hintergrund: Aktiviert der Admin die Regel "jeden Spieler ab X Punkten",
/// wird der Spieler mit der finalen Spieltagsberechnung automatisch an den
/// Transfermarkt verkauft. Der Manager erhält den Marktwert zum Zeitpunkt des
/// Verkaufs. Diese Transfers erscheinen nicht in der Transfer-Historie des
/// Managers, daher werden sie hier spieltagweise rekonstruiert:
///
/// 1. Besitz-Zeiträume aus der Transfer-Historie ableiten.
/// 2. Pro Spieler den ersten Spieltag finden, an dem seine Saison-Gesamt-
///    punkte die Schwelle erreichen ("Crossing").
/// 3. Den zu diesem Zeitpunkt gültigen Marktwert ermitteln und als Einnahme
///    verbuchen – aber nur, wenn der Manager den Spieler zu diesem Zeitpunkt
///    noch besaß (kauft ein Manager einen bereits verkauften Spieler vom
///    Markt, entsteht ihm dafür kein Einnahmen-Posten mehr).
class AutoSaleBudgetService {
  final ManagerTransferHistoryService _mvService =
      ManagerTransferHistoryService();

  // ============================================================================
  // Besitz-Zeiträume
  // ============================================================================

  /// Ergänzt lp-basierte Besitz-Zeiträume für Spieler, die im Saisonverlauf
  /// von diesem Manager aufgestellt waren, aber NICHT in der Transfer-Historie
  /// auftauchen (z.B. Spieler aus der Zulostung zum Saisonstart – diese haben
  /// weder einen Kauf- noch einen Verkauf-Eintrag und wären sonst unsichtbar).
  ///
  /// [lineupsByMatchday]: Pro Spieltag die Spieler-IDs, die der Manager
  /// aufgestellt hat (aus dem Ranking-Endpoint, Feld `lp`).
  ///
  /// Begründung der Perioden-Definition:
  /// - Ein aufgestellter Spieler ohne jeglichen Transfer-Eintrag wurde zum
  ///   Saisonstart zugelost und nie verkauft → Besitz ab Saisonstart (offen).
  /// - Wäre er verkauft worden, gäbe es einen Verkauf-Eintrag in der
  ///   Historie (Auto-Verkäufe betreffen nur Spieler mit Punkten – und Punkte
  ///   gibt es nur als Aufgestellter, d.h. der Crossing-Spieltag liegt immer
  ///   in der Aufstellung).
  List<OwnershipPeriod> mergeLineupOwnership({
    required List<OwnershipPeriod> historyPeriods,
    required Map<int, Set<String>> lineupsByMatchday,
    required DateTime seasonStart,
  }) {
    final result = [...historyPeriods];
    final covered = historyPeriods.map((p) => p.playerId).toSet();

    final fielded = <String>{};
    for (final ids in lineupsByMatchday.values) {
      fielded.addAll(ids);
    }

    for (final playerId in fielded) {
      if (!covered.add(playerId)) continue; // bereits über Historie abgedeckt
      result.add(
        OwnershipPeriod(
          playerId: playerId,
          playerName: '', // Name wird vom Aufrufer nachgeladen
          start: seasonStart,
        ),
      );
    }

    return result;
  }

  /// Rekonstruiert die Besitz-Zeiträume eines Managers aus seinen Transfers.
  ///
  /// [transfers] müssen bereits auf den Saisonzeitraum gefiltert sein.
  /// [seasonStart] ist der Stichtag für Spieler des Initialkaders: Wird ein
  /// Spieler verkauft, ohne dass ein Kauf im Zeitraum liegt, begann der
  /// Besitz spätestens zum Saisonstart.
  List<OwnershipPeriod> ownershipPeriods({
    required List<ManagerTransferHistoryEntry> transfers,
    required DateTime seasonStart,
  }) {
    // Nach Spieler gruppieren und zeitlich sortieren.
    final byPlayer = <String, List<ManagerTransferHistoryEntry>>{};
    for (final transfer in transfers) {
      if (transfer.transferType != 1 && transfer.transferType != 2) continue;
      byPlayer.putIfAbsent(transfer.playerId, () => []).add(transfer);
    }

    final periods = <OwnershipPeriod>[];
    for (final entry in byPlayer.entries) {
      final playerTransfers = entry.value.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      var name = playerTransfers.first.playerName;
      DateTime? openStart;

      for (final transfer in playerTransfers) {
        if (transfer.playerName.isNotEmpty) name = transfer.playerName;

        if (transfer.transferType == 1) {
          // Kauf: eröffnet den Besitz (sofern nicht schon offen).
          openStart ??= transfer.timestamp;
        } else {
          // Verkauf: schließt den Besitz ab. Liegt kein Kauf vor
          // (Initialkader), begann der Besitz spätestens zum Saisonstart.
          final start = openStart ?? seasonStart;
          periods.add(
            OwnershipPeriod(
              playerId: entry.key,
              playerName: name,
              start: start.isBefore(seasonStart) ? seasonStart : start,
              end: transfer.timestamp,
            ),
          );
          openStart = null;
        }
      }

      // Noch offener Besitz (kein abschließender Verkauf in der Historie).
      if (openStart != null) {
        periods.add(
          OwnershipPeriod(
            playerId: entry.key,
            playerName: name,
            start: openStart.isBefore(seasonStart) ? seasonStart : openStart,
          ),
        );
      }
    }

    return periods;
  }

  // ============================================================================
  // Crossing-Erkennung (Schwellen-Überschreitung)
  // ============================================================================

  /// Wählt die Performance-Daten der AKTUELLEN Saison aus.
  ///
  /// Der Performance-Endpoint liefert `it` als Liste ALLER Saisons (älteste
  /// zuerst, z.B. sid "5" = 2013/2014 … sid "28" = 2026/2027). Die Saison-
  /// Punktzahl der 250er-Regel bezieht sich ausschließlich auf die aktuelle
  /// Saison, daher wählt diese Methode den Eintrag mit der höchsten `sid`.
  ///
  /// Mit [seasonStart] werden zusätzlich alle Saisons verworfen, die KEIN
  /// Spiel nach dem Saisonstart enthalten (z.B. Spieler ohne aktuelle Spiele
  /// haben nur Altsaisons in der Historie) – sonst würde die höchste
  /// Altsaison fälschlich als "aktuell" durchgehen.
  SeasonPerformance? currentSeasonPerformance(
    PlayerPerformanceResponse performance, {
    DateTime? seasonStart,
  }) {
    final candidates = seasonStart == null
        ? performance.it
        : performance.it
              .where(
                (season) => season.ph.any((match) {
                  final md = DateTime.tryParse(match.md);
                  return md != null && !md.isBefore(seasonStart);
                }),
              )
              .toList();
    if (candidates.isEmpty) return null;

    SeasonPerformance? best;
    int? bestSid;
    for (final season in candidates) {
      final sid = int.tryParse(season.sid ?? '');
      if (sid != null && (bestSid == null || sid > bestSid)) {
        bestSid = sid;
        best = season;
      }
    }

    // Fallback: letzter Eintrag (die API listet die Saisons aufsteigend).
    return best ?? candidates.last;
  }

  /// Findet den ersten Spieltag der aktuellen Saison, an dem die kumulierte
  /// Saison-Punktzahl die Schwelle [threshold] erreicht. Liefert null, wenn
  /// die Schwelle (noch) nie erreicht wurde.
  ///
  /// WICHTIG: Die Punktzahl ist die SUMME der Einzelpunkte (`p`) der Spiele
  /// der aktuellen Saison. Das Feld `tp` ist NICHT die Saison-Punktzahl,
  /// sondern die Karriere-Gesamtpunktzahl über alle Saisons – es darf für
  /// die Schwellen-Erkennung nicht verwendet werden.
  ({int day, int points})? crossingMatchday(
    List<MatchPerformance> ph,
    int threshold,
  ) {
    final entries = ph.where((e) => e.p != null).toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    var seasonPoints = 0;
    for (final entry in entries) {
      seasonPoints += entry.p ?? 0;
      if (seasonPoints >= threshold) {
        return (day: entry.day, points: seasonPoints);
      }
    }
    return null;
  }

  // ============================================================================
  // Matchday-Ende & Marktwert
  // ============================================================================

  /// Ermittelt das Ende eines Spieltags: Der Auto-Verkauf erfolgt mit der
  /// finalen Spieltagsberechnung, also nach dem letzten Spiel des Spieltags.
  /// Als Stichtag verwenden wir das Match-Datum (`md`, Kickoff) des FOLGE-
  /// spieltags: Der Marktwert an diesem Tag ist genau der Wert, der mit der
  /// finalen Berechnung des Vortagspieltags festgeschrieben wurde.
  ///
  /// Hinweis: Das Feld `mdst` ist in der Praxis unzuverlässig (liefert
  /// konstant 0 oder 2) und wird daher nicht verwendet.
  ///
  /// Ist kein Folgespieltag bekannt (z.B. letzter gespielter Spieltag),
  /// wird [fallback] (üblicherweise "jetzt") verwendet.
  DateTime matchdayEnd({
    required int day,
    required List<MatchPerformance> ph,
    required DateTime fallback,
  }) {
    DateTime? nextKickoff;
    for (final entry in ph) {
      if (entry.day <= day) continue;
      final kickoff =
          DateTime.tryParse(entry.md)?.toUtc() ?? DateTime.tryParse(entry.md);
      if (kickoff == null) continue;
      if (nextKickoff == null || kickoff.isBefore(nextKickoff)) {
        nextKickoff = kickoff;
      }
    }

    return nextKickoff ?? fallback;
  }

  /// Liefert den letzten bekannten Marktwert am oder vor [at].
  /// Delegiert an die bewährte Logik aus [ManagerTransferHistoryService]
  /// (normalisiert Tage-seit-1970 / Sekunden / Millisekunden transparent).
  int? marketValueAt(List<MarketValueEntry> marketValues, DateTime at) =>
      _mvService.marketValueAt(marketValues, at);

  // ============================================================================
  // Gesamtauswertung
  // ============================================================================

  /// Berechnet alle Auto-Verkauf-Einnahmen eines Managers für die Saison.
  ///
  /// [periods]: Besitz-Zeiträume des Managers (siehe [ownershipPeriods]).
  /// [seasonStart]: Start der aktuellen Saison (Grenze für die Saison-
  /// auswahl in [currentSeasonPerformance]).
  /// [performanceByPlayer]: Performance-Daten (key = playerId).
  /// [marketValuesByPlayer]: Marktwert-Historien (key = playerId).
  /// [now]: Referenzzeitpunkt ("jetzt") für offene Besitze und den letzten
  /// gespielten Spieltag.
  AutoSaleComputation computeAutoSales({
    required int threshold,
    required List<OwnershipPeriod> periods,
    required DateTime seasonStart,
    required Map<String, PlayerPerformanceResponse> performanceByPlayer,
    required Map<String, List<MarketValueEntry>> marketValuesByPlayer,
    required DateTime now,
  }) {
    final events = <AutoSaleEvent>[];
    final seenPlayers = <String>{};

    for (final period in periods) {
      // Pro Spieler nur EIN Auto-Verkauf: Die Saison-Punktzahl steigt
      // monoton, die Schwelle wird genau einmal überschritten.
      if (!seenPlayers.add(period.playerId)) continue;

      final performance = performanceByPlayer[period.playerId];
      if (performance == null) continue;

      // NUR die aktuelle Saison auswerten – `it` enthält alle Saisons der
      // Karriere des Spielers, die 250er-Regel zählt aber pro Saison.
      final season = currentSeasonPerformance(
        performance,
        seasonStart: seasonStart,
      );
      if (season == null) continue;
      final ph = season.ph;
      if (ph.isEmpty) continue;

      final crossing = crossingMatchday(ph, threshold);
      if (crossing == null) continue;

      // Verkauf erfolgt mit der finalen Spieltagsberechnung.
      final saleInstant = matchdayEnd(day: crossing.day, ph: ph, fallback: now);

      // Der Manager muss den Spieler zum Verkaufszeitpunkt noch besessen
      // haben (anschließender Kauf eines bereits verkauften Spielers vom
      // Markt erzeugt KEINE Einnahme).
      if (!period.covers(saleInstant)) continue;

      final marketValues = marketValuesByPlayer[period.playerId] ?? const [];
      final marketValue = marketValueAt(marketValues, saleInstant);

      events.add(
        AutoSaleEvent(
          matchday: crossing.day,
          playerId: period.playerId,
          playerName: period.playerName,
          points: crossing.points,
          threshold: threshold,
          marketValue: marketValue ?? 0,
          uncertain: marketValue == null,
        ),
      );
    }

    events.sort((a, b) => a.matchday.compareTo(b.matchday));
    final totalIncome = events.fold<int>(0, (sum, e) => sum + e.marketValue);

    return AutoSaleComputation(totalIncome: totalIncome, events: events);
  }

  /// Normalisiert Timestamps, die je nach Endpoint in Millisekunden oder
  /// Sekunden seit Epoch geliefert werden (analog zur MV-Normalisierung).
  DateTime _normalizeTimestamp(int value) {
    if (value.abs() < 100000000000) {
      // Sekunden -> Millisekunden
      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
    }
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
}
