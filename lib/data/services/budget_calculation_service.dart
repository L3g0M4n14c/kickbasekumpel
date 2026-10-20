import '../models/budget_calculation_model.dart';
import '../models/transfer_model.dart';

/// Ergebnis des Konkurrenz-Budget-Vergleichs für ein konkretes Gebot.
///
/// Die Budgets der Mitbieter stammen aus [BudgetCalculationService]
/// (Startbudget + Verkäufe - Käufe + Anmeldebonus) und werden genutzt, um
/// abzuschätzen, wie realistisch der Zuschlag für ein Gebot ist.
class CompetitorBudgetHint {
  /// Anzahl Konkurrenz-Manager mit mehr Budget als das eigene Gebot –
  /// sie könnten das Gebot noch überbieten.
  final int managersWithHigherBudget;

  /// Höchstes Budget aller Konkurrenz-Manager (0 ohne bekannte Konkurrenz).
  final int maxCompetitorBudget;

  const CompetitorBudgetHint({
    required this.managersWithHigherBudget,
    required this.maxCompetitorBudget,
  });

  /// true, wenn mindestens ein Mitbieter das Gebot noch überbieten kann.
  ///
  /// Nur dann wird der Konkurrenz-Hinweis angezeigt – ohne bedrohliche
  /// Konkurrenz wäre die Hinweiszeile nur Rauschen.
  bool get hasHigherBudgetCompetitors => managersWithHigherBudget > 0;
}

/// Service für die Berechnung des Manager-Budgets
///
/// Vereinfachte Version: Startbudget = 50 Mio. €
/// Dann werden verrechnet:
/// - Verkäufe (transferType == 2) werden addiert
/// - Käufe (transferType == 1) werden subtrahiert
/// - Punktgeld (Spieltagsprämie): Saison-Gesamtpunkte × 1.000 €
/// - Täglicher Anmeldebonus (siehe [calculateLoginBonus])
class BudgetCalculationService {
  /// Festes Startbudget für die vereinfachte Berechnung (50 Mio. €)
  static const int startingBudget = 50000000;

  /// Punktgeld (Spieltagsprämie) pro Saison-Punkt: 1.000 €.
  ///
  /// Kickbase vergütet Spieltagspunkte mit Budget (Trading-Advisor-Ansatz:
  /// `totalPoints × 1000 €`). Da ein Großteil des Budgetwachstums daraus
  /// resultiert, fließt es seit Story #9 in die Budget-Summe ein.
  static const int pointsMoneyPerPoint = 1000;

  /// Bonus am 1. Tag der Liga (10.000 €), steigt täglich um 10.000 €
  /// bis am 10. Tag 100.000 € erreicht sind – ab dann konstant 100.000 €.
  static const int loginBonusPerDayStep = 10000;

  /// Tag, ab dem der Tagesbonus auf dem Maximum ([loginBonusMaxPerDay])
  /// gedeckelt ist.
  static const int loginBonusMaxDay = 10;

  /// Maximaler Tagesbonus (100.000 €, ab Tag 10)
  static const int loginBonusMaxPerDay =
      loginBonusPerDayStep * loginBonusMaxDay;

  /// Aktivitäten-Feed: Typ-Code für einen erhaltenen Anmeldebonus
  /// (Betrag in `data.bn`).
  static const int activityTypeLoginBonus = 22;

  /// Hilfsfunktion: Wert als int (int/num/String), sonst 0.
  static int _asInt(Object? value) => switch (value) {
    int value => value,
    num value => value.toInt(),
    String value => int.tryParse(value) ?? 0,
    _ => 0,
  };

  /// Tagesbonus für einen bestimmten Liga-Tag (1-basiert).
  ///
  /// Tag 1 = 10.000 €, Tag 2 = 20.000 €, … Tag 10 = 100.000 €,
  /// ab Tag 10 konstant 100.000 €.
  int loginBonusForDay(int day) {
    if (day <= 0) return 0;
    final effectiveDay = day < loginBonusMaxDay ? day : loginBonusMaxDay;
    return effectiveDay * loginBonusPerDayStep;
  }

  /// Kumulierter Anmeldebonus für [days] vergangene Liga-Tage.
  ///
  /// [days] = Anzahl der Tage, für die der Bonus gewährt wurde
  /// (Tag 1 = erster Tag der Liga). Bei 0 oder negativen Tagen wird 0
  /// zurückgegeben.
  ///
  /// Beispiele:
  /// - 1 Tag  → 10.000 €
  /// - 2 Tage → 30.000 € (10.000 + 20.000)
  /// - 10 Tage → 550.000 € (10.000 + 20.000 + … + 100.000)
  /// - 11 Tage → 650.000 € (550.000 + 100.000)
  int cumulativeLoginBonus(int days) {
    if (days <= 0) return 0;
    final cappedDays = days < loginBonusMaxDay ? days : loginBonusMaxDay;
    // Summe 1 + 2 + … + n = n * (n + 1) / 2
    final rampUpTotal = cappedDays * (cappedDays + 1) ~/ 2;
    final flatDays = days > loginBonusMaxDay ? days - loginBonusMaxDay : 0;
    return rampUpTotal * loginBonusPerDayStep + flatDays * loginBonusMaxPerDay;
  }

  /// Anzahl der Liga-Tage seit dem Saison-Start bis zum Referenzzeitpunkt
  /// (1-basiert: am Tag des Saison-Starts ist man bei Liga-Tag 1).
  ///
  /// Liefert 0, wenn der Saison-Start in der Zukunft liegt.
  int loginBonusDaysSince(DateTime seasonStart, {DateTime? now}) {
    final reference = (now ?? DateTime.now().toUtc()).toUtc();
    final startDay = DateTime.utc(
      seasonStart.toUtc().year,
      seasonStart.toUtc().month,
      seasonStart.toUtc().day,
    );
    final today = DateTime.utc(reference.year, reference.month, reference.day);

    if (today.isBefore(startDay)) return 0;

    final daysElapsed = today.difference(startDay).inDays;
    // Tag 1 ist der Start-Tag selbst, daher +1
    return daysElapsed + 1;
  }

  /// Berechnet den kumulierten täglichen Anmeldebonus seit dem Liga-Start.
  ///
  /// Jeder Manager erhält am ersten Tag der Liga 10.000 €, am zweiten Tag
  /// 20.000 €, … bis zum zehnten Tag 100.000 € – und ab da an jedem Tag
  /// konstant 100.000 €. Tag 1 ist der [seasonStart]-Tag selbst.
  ///
  /// [seasonStart] - Erster Tag der Liga
  /// [now] - Referenzzeitpunkt (default: jetzt, UTC)
  ///
  /// Returns: kumulierter Bonus in € (0, wenn der Liga-Start in der Zukunft
  /// liegt).
  int calculateLoginBonus({required DateTime seasonStart, DateTime? now}) {
    final days = loginBonusDaysSince(seasonStart, now: now);
    return cumulativeLoginBonus(days);
  }

  /// Tatsächlich gutgeschriebener Anmeldebonus aus dem Aktivitäten-Feed.
  ///
  /// Der Feed (`activitiesFeed`, Feld `af`) enthält pro ERHALTENEM
  /// Anmeldebonus einen Eintrag mit Typ [activityTypeLoginBonus] und dem
  /// Betrag in `data.bn`. Anders als die Formel ([calculateLoginBonus])
  /// werden hier nur die Boni gezählt, die wirklich gutgeschrieben wurden –
  /// nicht eingesammelte Tage zählen nicht mit (wichtig: Die Formel ist eine
  /// Obergrenze und überschätzt das Budget bei verpassten Tagen).
  ///
  /// [since] - nur Einträge ab diesem Zeitpunkt (Saisonstart).
  ///
  /// Returns: `total` = Summe der Beträge, `count` = Anzahl der
  /// Gutschriften.
  ({int total, int count}) loginBonusFromActivityFeed(
    Map<String, dynamic> feedData, {
    DateTime? since,
  }) {
    final entries = (feedData['af'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>();

    var total = 0;
    var count = 0;
    for (final entry in entries) {
      if (_asInt(entry['t']) != activityTypeLoginBonus) continue;

      if (since != null) {
        final rawDate = entry['dt'];
        final date = rawDate is String
            ? DateTime.tryParse(rawDate)?.toUtc()
            : null;
        if (date == null || date.isBefore(since.toUtc())) continue;
      }

      total += _asInt((entry['data'] as Map<String, dynamic>?)?['bn']);
      count++;
    }
    return (total: total, count: count);
  }

  /// Punktgeld (Spieltagsprämie) für [seasonPoints] Saison-Gesamtpunkte.
  ///
  /// Kickbase vergütet jeden Spieltagspunkt mit 1.000 € Budget
  /// (siehe [pointsMoneyPerPoint]).
  int pointsMoneyFor(int seasonPoints) {
    if (seasonPoints <= 0) return 0;
    return seasonPoints * pointsMoneyPerPoint;
  }

  /// Saison-Gesamtpunkte (`tp`) der AKTUELLEN Saison aus der Roh-Response des
  /// Performance-Endpoints (`managers/{userId}/performance`).
  ///
  /// Die Response enthält unter `it` eine Liste von Saisons
  /// (`{sid, sn, tp, ap, pl, mdw, it: [{day, mdp, tw, cur, md}, …]}`), sortiert
  /// alt → neu. Aktuelle Saison = neueste Saison mit einem Spieltag, der
  /// `cur == true` hat; Fallback: letzte Saison der Liste (= neueste).
  ///
  /// Returns: `tp` der aktuellen Saison (0, wenn keine Daten vorhanden sind).
  int seasonTotalPoints(Map<String, dynamic> performanceData) {
    final seasons = (performanceData['it'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    if (seasons.isEmpty) return 0;

    bool hasCurrentMatchday(Map<String, dynamic> season) {
      return (season['it'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .any((matchday) => matchday['cur'] == true);
    }

    final currentSeason = seasons.lastWhere(
      hasCurrentMatchday,
      orElse: () => seasons.last,
    );
    return _asInt(currentSeason['tp']);
  }

  /// Berechnet das Budget für einen Manager
  ///
  /// [managerId] - ID des Managers
  /// [managerName] - Name des Managers
  /// [leagueId] - Liga ID
  /// [allTransfers] - Alle Transfers (Käufe und Verkäufe) des Managers
  /// [seasonPoints] - Saison-Gesamtpunkte (Punktgeld, siehe [pointsMoneyFor])
  /// [currentTimestamp] - Aktueller Zeitstempel für die Berechnung
  ///
  /// Returns [BudgetCalculationResult] mit allen Berechnungsschritten
  BudgetCalculationResult calculateManagerBudget({
    required String managerId,
    required String managerName,
    required String leagueId,
    required List<ManagerTransferHistoryEntry> allTransfers,
    int seasonPoints = 0,
    DateTime? currentTimestamp,
  }) {
    final now = currentTimestamp ?? DateTime.now().toUtc();

    // 1. Transfers nach Typ trennen
    final sales = <ManagerTransfer>[];
    final purchases = <ManagerTransfer>[];

    for (final transfer in allTransfers) {
      final managerTransfer = ManagerTransfer(
        transferId: transfer.id,
        playerId: transfer.playerId,
        playerName: transfer.playerName,
        price: transfer.price,
        transferType: transfer.transferType,
        timestamp: transfer.timestamp,
        marketValueAtTransfer: transfer.marketValueAtTransfer,
      );

      if (transfer.transferType == 2) {
        // Verkauf (transferType == 2)
        sales.add(managerTransfer);
      } else if (transfer.transferType == 1) {
        // Kauf (transferType == 1)
        purchases.add(managerTransfer);
      }
      // Andere Typen (z.B. Tausch) werden ignoriert
    }

    // 2. Summen berechnen
    final totalSales = sales.fold<int>(0, (sum, sale) => sum + sale.price);
    final totalPurchases = purchases.fold<int>(
      0,
      (sum, purchase) => sum + purchase.price,
    );

    // 3. Punktgeld (Spieltagsprämie): Saison-Punkte × 1.000 €
    final pointsMoney = pointsMoneyFor(seasonPoints);

    // 4. Aktuelles Budget berechnen:
    //    50M + Verkäufe - Käufe + Punktgeld
    final currentBudget =
        startingBudget + totalSales - totalPurchases + pointsMoney;

    return BudgetCalculationResult(
      managerId: managerId,
      managerName: managerName,
      leagueId: leagueId,
      initialBudget: startingBudget,
      initialSquadValue: 0, // Nicht verwendet in vereinfachter Version
      startingBudget: startingBudget,
      totalSales: totalSales,
      totalPurchases: totalPurchases,
      seasonPoints: seasonPoints,
      pointsMoney: pointsMoney,
      currentBudget: currentBudget,
      initialPlayers: [], // Nicht verwendet in vereinfachter Version
      sales: sales,
      purchases: purchases,
      calculatedAt: now,
    );
  }

  /// Vergleicht ein geplantes Gebot mit den Budgets der Konkurrenz-Manager.
  ///
  /// [bidAmount] - das geplante eigene Gebot in Euro
  /// [competitorBudgets] - aktuelle Budgets aller Mitbieter (ohne das eigene)
  ///
  /// Gezählt werden die Manager, die **mehr** Budget als das Gebot haben –
  /// nur sie können es noch überbieten. Ein Budget gleich dem Gebot reicht
  /// für ein Überbieten nicht aus und zählt daher nicht.
  ///
  /// Returns: [CompetitorBudgetHint] mit der Anzahl budgetstärkerer Manager
  /// und dem höchsten Konkurrenz-Budget.
  CompetitorBudgetHint analyzeCompetitorBudgets({
    required int bidAmount,
    required List<int> competitorBudgets,
  }) {
    var managersWithHigherBudget = 0;
    var maxCompetitorBudget = 0;
    for (final budget in competitorBudgets) {
      if (budget > maxCompetitorBudget) {
        maxCompetitorBudget = budget;
      }
      if (budget > bidAmount) {
        managersWithHigherBudget++;
      }
    }
    return CompetitorBudgetHint(
      managersWithHigherBudget: managersWithHigherBudget,
      maxCompetitorBudget: maxCompetitorBudget,
    );
  }

  /// Formatiere Budget für die Anzeige (in Mio. €)
  String formatBudget(int budget) {
    final inMillions = budget / 1000000;
    return '${inMillions.toStringAsFixed(2)} M €';
  }

  /// Formatiere Marktwert für die Anzeige
  String formatMarketValue(int value) {
    if (value >= 1000000) {
      final inMillions = value / 1000000;
      return '${inMillions.toStringAsFixed(2)} M €';
    } else {
      return '${(value / 1000).toStringAsFixed(0)} T €';
    }
  }
}
