import '../models/achievement_model.dart';
import '../models/budget_calculation_model.dart';
import '../models/transfer_model.dart';
import 'achievement_budget_service.dart';

/// Regeln für die deterministische Achievement-Ableitung.
///
/// Die Regeln beschreiben Annahmen über undokumentiertes Kickbase-Verhalten
/// (Gleichstände, kumulative Boni) und werden über die Kalibrierung gegen die
/// exakten `ac`-Werte des eigenen Managers verifiziert/justiert.
class AchievementDerivationRules {
  const AchievementDerivationRules({
    this.tiesShare = true,
    this.stackPointBonuses = true,
    this.stackPlayerBonuses = true,
    this.handThresholdsStack = true,
    this.handAutoSalesCount = true,
    this.seasonWinnerTiesShare = false,
  });

  /// Gleichstand beim Spieltagssieger: alle punktgleichen Manager erhalten
  /// den Bonus (sonst nur einer).
  final bool tiesShare;

  /// Punkte-Boni stapeln: 1600 Pkt. zählt als Silber UND Gold.
  final bool stackPointBonuses;

  /// Spieler-Boni stapeln: 350 Pkt. zählen als Topscorer UND Matchwinner.
  final bool stackPlayerBonuses;

  /// Händchen-Schwellen stapeln: 6 Mio. Gewinn zählt als Bronze UND Silber.
  final bool handThresholdsStack;

  /// Auto-Verkäufe (250er-Regel) zählen als Verkauf zum Marktwert.
  final bool handAutoSalesCount;

  /// Gleichstand um die Meisterschaft: beide erhalten „Meister".
  final bool seasonWinnerTiesShare;
}

/// Abweichung bei der Kalibrierung (Regelverstoß gegen die Schranken).
class CalibrationMismatch {
  const CalibrationMismatch({
    required this.name,
    required this.derivedCount,
    required this.minExpected,
    required this.maxPossible,
  });

  final String name;

  /// Abgeleitete Anzahl in der AKTUELLEN Saison.
  final int derivedCount;

  /// Untere Schranke: mindestens so oft in dieser Saison erreicht.
  final int minExpected;

  /// Obere Schranke: Karriere-Anzahl `ac` (alle Saisons).
  final int maxPossible;

  @override
  String toString() =>
      '$name: abgeleitet $derivedCount (Saison), erwartet $minExpected…$maxPossible';
}

/// Service für die deterministische Ableitung der Kickbase-Erfolge (Achievements)
/// ALLER Manager einer Liga aus ligaweit verfügbaren Daten.
///
/// ## Hintergrund
///
/// Die Kickbase-API stellt Erfolge nur für den authentifizierten User bereit
/// (`/user/achievements`) – der Aktivitäten-Feed zeigt laut Live-Verifikation
/// ebenfalls nur die eigenen Erfolge. Für die Budget-Berechnung aller Manager
/// werden die Erfolge daher aus den Rohdaten ABGELEITET:
///
/// | Erfolg (API-Name) | Datenquelle |
/// |---|---|
/// | Match day winner | Spieltagspunkte (`mdp`): Manager mit der Höchstpunktzahl |
/// | Match day points bronze/silver/gold, Match of the century | Spieltagspunkte ≥ 500/1000/1500/2000 |
/// | Season points bronze | Saisonpunkte (`sp`) ≥ 1000 |
/// | Top scorer/Match winner/World class/Football god | max. Lineup-Spieler-Punkte ≥ 200/300/400/500 |
/// | MVP | Besitzer des Spielers mit dem Liga-weiten Spieltags-Maximum |
/// | Team value bronze/silver | Teamwert (`tv`) ≥ 125/150 Mio. |
/// | First deal/Transfer King bronze | ≥ 1/50 Transfers pro Saison |
/// | The right touch/Bronze/Silver/Golden hand/Royal transfer | Gewinn pro Spieler ≥ 1/3/5/10/25 Mio. |
/// | Champion/Runner-up | Endtabelle (nur nach Saisonende) |
///
/// Nicht abgeleitet (bewusst): **Goal machine** (Tormaschine – Datenquelle
/// für Tore unklar), Match day winner bronze/silver/gold, The Special One,
/// Season points silver+, Team value gold+, Transfer King silver+ (Schwellen
/// unbekannt), World cup winner, Kreisliga & Co. (Liga-/Profil-Ereignisse).
/// Die Katalog-Belohnungen sind als Fallback dokumentiert; der API-Wert `er`
/// des eigenen Managers ist maßgeblich.
///
/// ## Kalibrierung
///
/// Die Ableitung wird gegen die exakten `ac`-Werte des eigenen Managers
/// (`/user/achievements`) gegengeprüft ([calibrate]). Abweichungen legen falsche
/// Regel-Annahmen offen und werden über [AchievementDerivationRules] justiert.
class AchievementDerivationService {
  AchievementDerivationService({
    this.rules = const AchievementDerivationRules(),
    Map<String, int> apiRewardsByName = const {},
  }) : _apiRewardsByName = apiRewardsByName;

  final AchievementDerivationRules rules;

  /// Belohnung (`er`) pro Erfolgs-Name aus der API (nur gesetzte Einträge
  /// sind verbindlich – auch der Wert 0, z.B. „Manager license").
  final Map<String, int> _apiRewardsByName;

  // -----------------------------------------------------------------------
  // Typ-Katalog
  // -----------------------------------------------------------------------

  /// Spieltagspunkte-Schwelle → Erfolgs-Name.
  static const Map<int, String> matchdayPointThresholds = {
    500: 'Match day points bronze',
    1000: 'Match day points silver',
    1500: 'Match day points gold',
    2000: 'Match of the century',
  };

  /// Spieler-Punkte-Schwelle → Erfolgs-Name.
  static const Map<int, String> playerPointThresholds = {
    200: 'Top scorer',
    300: 'Match winner',
    400: 'World class',
    500: 'Football god',
  };

  /// Gewinn-Schwelle (€) → Erfolgs-Name.
  static const Map<int, String> handProfitThresholds = {
    1000000: 'The right touch',
    3000000: 'Bronze hand',
    5000000: 'Silver hand',
    10000000: 'Golden hand',
    25000000: 'Royal transfer',
  };

  /// Saisonpunkte-Schwelle → Erfolgs-Name (silver+: Schwellen unbekannt).
  static const Map<int, String> seasonPointThresholds = {
    1000: 'Season points bronze',
  };

  /// Teamwert-Schwelle (€) → Erfolgs-Name (gold+: Schwellen unbekannt).
  static const Map<int, String> teamValueThresholds = {
    125000000: 'Team value bronze',
    150000000: 'Team value silver',
  };

  /// Transfer-Anzahl pro Saison → Erfolgs-Name (silver+: Schwellen unbekannt).
  static const Map<int, String> transferCountThresholds = {
    1: 'First deal',
    50: 'Transfer King bronze',
  };

  /// Alle Namen, die die Ableitung erzeugen kann.
  Set<String> get derivableNames => {
    'Match day winner',
    'MVP',
    ...matchdayPointThresholds.values,
    ...seasonPointThresholds.values,
    ...playerPointThresholds.values,
    ...teamValueThresholds.values,
    ...transferCountThresholds.values,
    ...handProfitThresholds.values,
    'Champion',
    'Runner-up',
  };

  // -----------------------------------------------------------------------
  // Belohnungen
  // -----------------------------------------------------------------------

  /// Belohnung eines Erfolgs: API-Wert (`er`) wenn bekannt, sonst Katalog.
  ///
  /// `er = 0` zahlt nichts (z.B. „Manager license" oder deaktivierte Boni).
  int rewardFor(String name) =>
      _apiRewardsByName[name] ??
      AchievementBudgetService.knownAchievementRewards[name] ??
      0;

  // -----------------------------------------------------------------------
  // Ableitung
  // -----------------------------------------------------------------------

  /// Spieltagssieger + Spieltagspunkte-Boni für alle Manager.
  ///
  /// [pointsByMatchday]: Spieltag → Manager-ID → Spieltagspunkte (`mdp`).
  /// Returns: Manager-ID → Ereignisse.
  Map<String, List<AchievementEvent>> deriveMatchdayEvents({
    required Map<int, Map<String, int>> pointsByMatchday,
  }) {
    final eventsByManager = <String, List<AchievementEvent>>{};

    void add(String managerId, String name) {
      eventsByManager.putIfAbsent(managerId, () => []).add(_event(name));
    }

    for (final byManager in pointsByMatchday.values) {
      if (byManager.isEmpty) continue;

      // Spieltagssieger: Höchstpunktzahl des Spieltags.
      final topPoints = byManager.values.fold<int>(
        0,
        (max, p) => p > max ? p : max,
      );
      for (final entry in byManager.entries) {
        if (entry.value != topPoints || topPoints <= 0) continue;
        add(entry.key, 'Match day winner');
        if (!rules.tiesShare) break;
      }

      // Punkte-Boni pro Manager.
      for (final entry in byManager.entries) {
        for (final threshold in _crossedThresholds(
          entry.value,
          matchdayPointThresholds,
          stack: rules.stackPointBonuses,
        )) {
          add(entry.key, matchdayPointThresholds[threshold]!);
        }
      }
    }

    return eventsByManager;
  }

  /// Topscorer/Matchwinner/Weltklasse/Fussballgott + MVP für alle Manager.
  ///
  /// [lineupsByMatchday]: Spieltag → Manager-ID → Spieler-IDs (`lp`).
  /// [playerPointsByMatchday]: Spieler-ID → Spieltag → Punkte (`p`).
  /// Returns: Manager-ID → Ereignisse.
  Map<String, List<AchievementEvent>> derivePlayerEvents({
    required Map<int, Map<String, Set<String>>> lineupsByMatchday,
    required Map<String, Map<int, int>> playerPointsByMatchday,
  }) {
    final eventsByManager = <String, List<AchievementEvent>>{};

    void add(String managerId, String name) {
      eventsByManager.putIfAbsent(managerId, () => []).add(_event(name));
    }

    for (final entry in lineupsByMatchday.entries) {
      final day = entry.key;
      final byManager = entry.value;

      // Beste(r) Spieler des Spieltags (Liga-weit unter allen Lineup-Spielern)
      // → MVP für den/die Besitzer.
      var topPlayerPoints = 0;
      final ownersOfTopPlayer = <String>{};
      for (final managerEntry in byManager.entries) {
        for (final playerId in managerEntry.value) {
          final points = playerPointsByMatchday[playerId]?[day] ?? 0;
          if (points > topPlayerPoints) {
            topPlayerPoints = points;
            ownersOfTopPlayer
              ..clear()
              ..add(managerEntry.key);
          } else if (points == topPlayerPoints && points > 0) {
            ownersOfTopPlayer.add(managerEntry.key);
          }
        }
      }
      if (topPlayerPoints > 0) {
        for (final managerId in ownersOfTopPlayer) {
          add(managerId, 'MVP');
        }
      }

      // Spieler-Punkte-Boni: höchste Punktzahl eines Lineup-Spielers.
      for (final managerEntry in byManager.entries) {
        var maxPoints = 0;
        for (final playerId in managerEntry.value) {
          final points = playerPointsByMatchday[playerId]?[day] ?? 0;
          if (points > maxPoints) maxPoints = points;
        }
        for (final threshold in _crossedThresholds(
          maxPoints,
          playerPointThresholds,
          stack: rules.stackPlayerBonuses,
        )) {
          add(managerEntry.key, playerPointThresholds[threshold]!);
        }
      }
    }

    return eventsByManager;
  }

  /// Händchen-/Königstransfer-Erfolge eines Managers aus seiner
  /// Transfer-Historie.
  ///
  /// Gewinn pro Spieler = Verkäufe − Käufe über die Saison kumuliert
  /// (Zulostung-Spieler ohne Kauf zählen mit dem vollen Verkaufserlös).
  List<AchievementEvent> deriveHandEvents({
    required List<ManagerTransferHistoryEntry> transfers,
    List<AutoSaleEvent> autoSales = const [],
  }) {
    final profitByPlayer = <String, int>{};
    for (final transfer in transfers) {
      final sign = switch (transfer.transferType) {
        2 => 1, // Verkauf
        1 => -1, // Kauf
        _ => 0,
      };
      if (sign == 0) continue;
      profitByPlayer.update(
        transfer.playerId,
        (profit) => profit + sign * transfer.price,
        ifAbsent: () => sign * transfer.price,
      );
    }
    if (rules.handAutoSalesCount) {
      for (final sale in autoSales) {
        profitByPlayer.update(
          sale.playerId,
          (profit) => profit + sale.marketValue,
          ifAbsent: () => sale.marketValue,
        );
      }
    }

    final events = <AchievementEvent>[];
    for (final profit in profitByPlayer.values) {
      for (final threshold in _crossedThresholds(
        profit,
        handProfitThresholds,
        stack: rules.handThresholdsStack,
      )) {
        events.add(_event(handProfitThresholds[threshold]!));
      }
    }
    return events;
  }

  /// Meister/Vizemeister aus der Endtabelle – nur nach Saisonende.
  ///
  /// [seasonPointsByManager]: Manager-ID → Saisonpunkte (`sp`).
  Map<String, List<AchievementEvent>> deriveSeasonEvents({
    required Map<String, int> seasonPointsByManager,
    required bool seasonFinished,
  }) {
    if (!seasonFinished || seasonPointsByManager.length < 2) return {};

    final ranked = seasonPointsByManager.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final first = ranked.first.value;
    final second = ranked[1].value;

    final eventsByManager = <String, List<AchievementEvent>>{};
    for (final entry in ranked) {
      if (entry.value != first) continue;
      eventsByManager.putIfAbsent(entry.key, () => []).add(_event('Champion'));
      if (!rules.seasonWinnerTiesShare) break;
    }
    for (final entry in ranked) {
      if (entry.value == first) continue; // Meister ist kein Vizemeister
      if (entry.value == second) {
        eventsByManager
            .putIfAbsent(entry.key, () => [])
            .add(_event('Runner-up'));
      }
    }
    return eventsByManager;
  }

  /// Season-Points-Boni für alle Manager (einmalig pro Saison).
  ///
  /// [seasonPointsByManager]: Manager-ID → Saisonpunkte (`sp`).
  /// Returns: Manager-ID → Ereignisse.
  Map<String, List<AchievementEvent>> deriveSeasonPointEvents({
    required Map<String, int> seasonPointsByManager,
  }) {
    final eventsByManager = <String, List<AchievementEvent>>{};
    for (final entry in seasonPointsByManager.entries) {
      for (final threshold in _crossedThresholds(
        entry.value,
        seasonPointThresholds,
        stack: true,
      )) {
        eventsByManager
            .putIfAbsent(entry.key, () => [])
            .add(_event(seasonPointThresholds[threshold]!));
      }
    }
    return eventsByManager;
  }

  /// Teamwert-Boni für alle Manager (einmalig pro Saison).
  ///
  /// [teamValuesByManager]: Manager-ID → Teamwert (`tv`). Der aktuelle Wert
  /// ist eine Näherung: fällt der Teamwert nach Erreichen wieder, wird die
  /// Schwelle hier unterschätzt (die Kalibrierung meldet das als Minimum).
  /// Returns: Manager-ID → Ereignisse.
  Map<String, List<AchievementEvent>> deriveTeamValueEvents({
    required Map<String, int> teamValuesByManager,
  }) {
    final eventsByManager = <String, List<AchievementEvent>>{};
    for (final entry in teamValuesByManager.entries) {
      for (final threshold in _crossedThresholds(
        entry.value,
        teamValueThresholds,
        stack: true,
      )) {
        eventsByManager
            .putIfAbsent(entry.key, () => [])
            .add(_event(teamValueThresholds[threshold]!));
      }
    }
    return eventsByManager;
  }

  /// Transfer-Anzahl-Boni eines Managers (einmalig pro Saison).
  ///
  /// [transferCount] = Käufe + Verkäufe in der laufenden Saison
  /// („Sell or buy X players during a season").
  List<AchievementEvent> deriveTransferCountEvents({
    required int transferCount,
  }) {
    return [
      for (final threshold in _crossedThresholds(
        transferCount,
        transferCountThresholds,
        stack: true,
      ))
        _event(transferCountThresholds[threshold]!),
    ];
  }

  /// Verdichtet Ereignisse eines Managers zu einer [AchievementIncomeSummary].
  AchievementIncomeSummary summarize(
    String managerId,
    List<AchievementEvent> events, {
    bool isExact = false,
  }) {
    return AchievementIncomeSummary(
      managerId: managerId,
      totalIncome: events.fold(0, (sum, e) => sum + e.reward),
      events: events,
      isExact: isExact,
    );
  }

  /// Mindest-Anzahl pro Erfolgs-Name in der AKTUELLEN Saison.
  ///
  /// Der Detail-Endpoint liefert pro Erfolg `dt` (Zeitpunkt des Erreichens –
  /// bei Mehrfach-Erfolgen der zuletzt erreichte). Liegt `dt` am oder nach dem
  /// Saisonstart, wurde der Erfolg mindestens einmal in dieser Saison erreicht.
  Map<String, int> minExpectedInSeason({
    required Map<String, String?> earnedAtByName,
    required DateTime seasonStart,
  }) {
    return {
      for (final entry in earnedAtByName.entries)
        if (_earnedInSeason(entry.value, seasonStart)) entry.key: 1,
    };
  }

  /// Kalibrierungs-Report: abgeleitete Saison-Anzahl vs. reale `ac`-Werte.
  ///
  /// WICHTIG: `ac` aus `/user/achievements` ist eine KARRIERE-Summe (alle
  /// Saisons, die man je gespielt hat) – die Ableitung zählt nur die aktuelle
  /// Saison. Der Vergleich läuft daher als Schranken-Check:
  /// - Untere Schranke [minExpectedByName]: mindestens so oft in der aktuellen
  ///   Saison erreicht (aus `dt`, siehe [minExpectedInSeason]).
  /// - Obere Schranke [actualCountsByName]: Karriere-Anzahl `ac`.
  ///
  /// Gemeldet wird nur ein Regelverstoß: abgeleitet < Mindest-Erwartung
  /// (Ableitung zählt zu wenig) oder abgeleitet > Karriere-Maximum (Ableitung
  /// zählt zu viel).
  List<CalibrationMismatch> calibrate({
    required List<AchievementEvent> derivedEvents,
    required Map<String, int> actualCountsByName,
    Map<String, int> minExpectedByName = const {},
  }) {
    final derivedCounts = <String, int>{};
    for (final event in derivedEvents) {
      derivedCounts.update(event.name, (count) => count + 1, ifAbsent: () => 1);
    }

    final mismatches = <CalibrationMismatch>[];
    // Nur vergleichbare Namen: abgeleitete + alle ableitbaren Typen. Andere
    // API-Typen (z.B. "First deal") werden nicht abgeleitet und sind kein
    // Fehler – Namen ohne API-Pendant (Übersetzungs-Lücken) sind nicht
    // vergleichbar und werden übersprungen.
    final comparable = {...derivedCounts.keys, ...derivableNames};
    for (final name in comparable) {
      if (!actualCountsByName.containsKey(name)) continue;
      final derived = derivedCounts[name] ?? 0;
      final minExpected = minExpectedByName[name] ?? 0;
      final maxPossible = actualCountsByName[name] ?? 0;
      if (derived < minExpected || derived > maxPossible) {
        mismatches.add(
          CalibrationMismatch(
            name: name,
            derivedCount: derived,
            minExpected: minExpected,
            maxPossible: maxPossible,
          ),
        );
      }
    }
    return mismatches;
  }

  /// true, wenn `earnedAt` (ISO-8601 oder Unix-Timestamp) am/nach
  /// [seasonStart] liegt.
  bool _earnedInSeason(String? earnedAt, DateTime seasonStart) {
    if (earnedAt == null || earnedAt.isEmpty) return false;
    final asInt = int.tryParse(earnedAt);
    final parsed =
        DateTime.tryParse(earnedAt) ??
        (asInt != null
            ? DateTime.fromMillisecondsSinceEpoch(asInt * 1000, isUtc: true)
            : null);
    if (parsed == null) return false;
    return !parsed.toUtc().isBefore(seasonStart.toUtc());
  }

  // -----------------------------------------------------------------------
  // Hilfsfunktionen
  // -----------------------------------------------------------------------

  AchievementEvent _event(String catalogName) => AchievementEvent(
    achievementTypeId: catalogName,
    name: catalogName,
    reward: rewardFor(catalogName),
  );

  /// Die erreichten Schwellen eines Wertes – gestapelt oder nur die höchste.
  List<int> _crossedThresholds(
    int value,
    Map<int, String> thresholds, {
    required bool stack,
  }) {
    final crossed = thresholds.keys.where((t) => value >= t).toList();
    if (crossed.isEmpty) return const [];
    if (stack) return crossed;
    return [crossed.last];
  }
}
