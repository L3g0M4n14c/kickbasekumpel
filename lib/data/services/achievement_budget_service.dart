import '../models/achievement_model.dart';

/// Service für die Ermittlung der Budget-Einnahmen durch Kickbase-Erfolge
/// (Achievements).
///
/// ## Hintergrund
///
/// Kickbase vergütet starke Leistungen mit Budget-Boni, die NICHT in der
/// Transfer-Historie erscheinen und daher bei der Budget-Berechnung
/// (Startbudget + Verkäufe − Käufe) fehlen. Der Erfolgs-Katalog umfasst
/// Serien (Live-Dump 07.10.2026, Namen/Schwellen/Beträge siehe
/// [knownAchievementRewards]):
///
/// - **Match day winner** (t=1–5): Spieltags-Siege
/// - **Match day points** (t=100–103): ≥ 500/1000/1500/2000 Pkt. an einem Spieltag
/// - **Season points** (t=200–204): ≥ 1000 Pkt. in einer Saison (silver+ offen)
/// - **Top scorer/Match winner/World class/Football god** (t=300–303):
///   ≥ 200/300/400/500 Pkt. mit einem Spieler
/// - **Team value** (t=400–404): Teamwert ≥ 125/150 Mio. (gold+ offen)
/// - **First deal/Transfer King** (t=500–504): ≥ 1/50 Transfers pro Saison
/// - **Händchen-Serie** (t=700–704): „The right touch/Bronze/Silver/Golden
///   hand/Royal transfer" = 1/3/5/10/25 Mio. Gewinn mit einem Spieler
/// - **Champion/Runner-up** (t=2001/2002): 1./2. Platz am Saisonende
/// - Sonstige einmalige (Kreisliga, Panini, Manager license, …)
///
/// (Beträge können sich ändern; der API-Wert `er` ist maßgeblich. In privaten
/// Ligen können Erfolgs-Geldboni deaktiviert sein – dann liefert die API
/// `er = 0` und dieser Typ zählt nichts.)
///
/// ## Ermittlungswege
///
/// 1. **Eigener Manager (Kalibrierung):** `GET /leagues/{id}/user/achievements`
///    liefert `ac` (KARRIERE-Anzahl) und `dt` (letzter Erfolg) – Grundlage
///    der Schranken-Kalibrierung, NICHT der Saison-Budgets.
/// 2. **Alle Manager (Ableitung):** Die API zeigt Erfolge fremder Manager
///    nirgends (der Aktivitäten-Feed enthält laut Live-Verifikation nur die
///    eigenen). Diese werden deterministisch aus Spieltags-Ranking, Lineup-
///    Punkten und Transfer-Historie abgeleitet – siehe
///    [AchievementDerivationService].
class AchievementBudgetService {
  /// Offizieller Erfolgs-Katalog der API (Name → Belohnung in €).
  ///
  /// Quelle: Live-Dump 07.10.2026 (`/user/achievements` + Detail-Endpoints).
  /// Beträge ohne Stern sind API-bestätigt (`er`); die mit * stammen aus
  /// ac = 0-Typen (Detail nicht geladen) und sind systematische Schätzungen
  /// nach dem Muster der jeweiligen Serie.
  static const Map<String, int> knownAchievementRewards = {
    'Match day winner': 1000000, // *
    'Match day winner bronze': 250000, // *
    'Match day winner silver': 500000, // *
    'Match day winner gold': 1000000, // *
    'The Special One': 2000000, // *
    'Match day points bronze': 100000,
    'Match day points silver': 250000,
    'Match day points gold': 1000000,
    'Match of the century': 1000000, // *
    'Season points bronze': 100000,
    'Season points silver': 250000, // *
    'Season points gold': 500000, // *
    'Season points platinum': 1000000, // *
    'World cup winner': 1000000, // *
    'Top scorer': 100000,
    'Match winner': 500000,
    'World class': 1000000,
    'Football god': 2000000,
    'Team value bronze': 100000,
    'Team value silver': 250000,
    'Team value gold': 500000, // *
    'Team value platinum': 1000000, // *
    'The Galactics': 2000000, // *
    'First deal': 100000,
    'Transfer King bronze': 250000,
    'Transfer King silver': 500000, // *
    'Transfer King gold': 1000000, // *
    'F. Magath': 2000000, // *
    'Kreisliga': 1000000,
    'Regionalliga': 1000000,
    '2. Liga': 1000000, // *
    '1. Liga': 2000000, // *
    'The right touch': 100000,
    'Bronze hand': 250000,
    'Silver hand': 500000,
    'Golden hand': 1000000,
    'Royal transfer': 2000000, // *
    'Manager license': 0,
    'Champion': 2000000, // *
    'Runner-up': 1000000,
    'Long bench': 100000,
    'Panini': 100000,
    'Choreo': 100000,
    'MVP': 1000000,
    'Goal machine': 250000, // *
  };

  // ---------------------------------------------------------------------------
  // Parsing
  // ---------------------------------------------------------------------------

  /// Parst die eigene Achievements-Liste (Roh-Maps aus der API) in Modelle.
  ///
  /// Erwartet Felder: `t` (Typ), `n` (Name), `ac` (Anzahl), `ise` (einmalig).
  List<KickbaseAchievement> parseAchievements(
    List<Map<String, dynamic>> rawItems,
  ) {
    return rawItems
        .map(
          (raw) => KickbaseAchievement(
            typeId: (raw['t'] ?? '').toString(),
            name: (raw['n'] ?? '').toString(),
            achievedCount: _asInt(raw['ac']),
            isOneTime: raw['ise'] == true,
          ),
        )
        .where((a) => a.typeId.isNotEmpty)
        .toList();
  }

  /// Parst einen Detail-Endpoint-Response (Erfolg nach Typ) und ergänzt
  /// Belohnung/Anzahl/Beschreibung auf einem bestehenden Modell.
  KickbaseAchievement mergeAchievementDetail(
    KickbaseAchievement achievement,
    Map<String, dynamic> detail,
  ) {
    return achievement.copyWith(
      achievedCount: _asInt(detail['ac']),
      earnedReward: _asInt(detail['er']),
      description: detail['d']?.toString(),
      earnedAt: detail['dt']?.toString(),
      name: (detail['n'] ?? '').toString().isNotEmpty
          ? detail['n'].toString()
          : achievement.name,
    );
  }

  // ---------------------------------------------------------------------------
  // Berechnung
  // ---------------------------------------------------------------------------

  /// KARRIERE-Einnahmen des eigenen Managers durch Erfolge:
  /// Summe aus `achievedCount × earnedReward` über alle Erfolge.
  ///
  /// WICHTIG: `ac` ist eine Karriere-Summe (alle Saisons je gespielt) –
  /// dieser Wert ist eine Referenz für die Kalibrierung, NICHT die
  /// Saison-Budget-Berechnung (dort zählt die Ableitung nur Ereignisse
  /// seit dem Saisonstart).
  ///
  /// Der API-Wert `er` ist maßgeblich: `er = 0` (z.B. „Manager license"
  /// oder deaktivierte Erfolgs-Geldboni) trägt bewusst NICHTS bei.
  AchievementIncomeSummary exactOwnIncome(
    List<KickbaseAchievement> achievements,
  ) {
    final events = <AchievementEvent>[];
    var total = 0;

    for (final achievement in achievements) {
      if (achievement.achievedCount <= 0) continue;
      final reward = achievement.earnedReward;
      if (reward <= 0) continue;
      total += reward * achievement.achievedCount;
      events.add(
        AchievementEvent(
          achievementTypeId: achievement.typeId,
          name: achievement.name,
          reward: reward * achievement.achievedCount,
        ),
      );
    }

    return AchievementIncomeSummary(
      managerId: '',
      totalIncome: total,
      events: events,
      isExact: true,
    );
  }

  /// Belohnung eines Erfolgs aus dem Katalog (nur für Dokumentation/Anzeige).
  /// Die API (`er`) ist immer maßgeblich.
  int catalogReward(String name) => knownAchievementRewards[name] ?? 0;

  // ---------------------------------------------------------------------------
  // Hilfsfunktionen
  // ---------------------------------------------------------------------------

  int _asInt(Object? value) => switch (value) {
    int value => value,
    num value => value.toInt(),
    String value => int.tryParse(value) ?? 0,
    _ => 0,
  };
}
