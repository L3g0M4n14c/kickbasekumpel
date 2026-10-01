import '../models/achievement_model.dart';

/// Service für die Ermittlung der Budget-Einnahmen durch Kickbase-Erfolge
/// (Achievements).
///
/// ## Hintergrund
///
/// Kickbase vergütet starke Leistungen mit Budget-Boni, die NICHT in der
/// Transfer-Historie erscheinen und daher bei der Budget-Berechnung
/// (Startbudget + Verkäufe − Käufe) fehlen:
///
/// | Erfolg | Bedingung | Gewinn |
/// |---|---|---|
/// | Spieltagssieger | Spieltag gewinnen | 1 Mio. |
/// | Spieltagspunkte Silber | ≥ 1000 Pkt. an einem Spieltag | 250.000 |
/// | Spieltagspunkte Gold | ≥ 1500 Pkt. an einem Spieltag | 500.000 |
/// | Jahrhundertspiel | ≥ 2000 Pkt. an einem Spieltag | 1 Mio. |
/// | Topscorer | 200 Pkt. für max. einen Spieler | 100.000 |
/// | Matchwinner | 300 Pkt. für max. einen Spieler | 500.000 |
/// | Weltklasse | 400 Pkt. für max. einen Spieler | 1 Mio. |
/// | Fussballgott | 500 Pkt. für max. einen Spieler | 2 Mio. |
/// | MVP | Stärkster Spieler eines Spieltags | 1 Mio. |
/// | Tormaschine | Meiste Tore der Liga am Spieltag | 250.000 |
/// | Bronzenes Händchen | 3 Mio. Gewinn mit einem Spieler | 250.000 |
/// | Silbernes Händchen | 5 Mio. Gewinn mit einem Spieler | 500.000 |
/// | Goldenes Händchen | 10 Mio. Gewinn mit einem Spieler | 1 Mio. |
/// | Königstransfer | 25 Mio. Gewinn mit einem Spieler | 2 Mio. |
/// | Meister (Saison) | 1. Platz am Saisonende | 2 Mio. |
/// | Vizemeister (Saison) | 2. Platz am Saisonende | 1 Mio. |
///
/// (Quelle: Kickbase Help Center – Beträge können sich ändern; der API-Wert
/// `er` ist maßgeblich. In privaten Ligen können Erfolgs-Geldboni deaktiviert
/// sein – dann liefert die API `er = 0` und dieser Service zählt nichts.)
///
/// ## Ermittlungswege
///
/// 1. **Eigener Manager (exakt):** `GET /leagues/{id}/user/achievements`
///    liefert alle Erfolge des authentifizierten Users mit `ac` (Anzahl) –
///    multipliziert mit `er` (Belohnung aus dem Detail-Endpoint) ergibt das
///    die exakten Budget-Einnahmen.
/// 2. **Andere Manager (Feed-Attribution):** Der Aktivitäten-Feed
///    (`GET /leagues/{id}/activitiesFeed`) enthält ligaweit die Erfolgs-
///    Ereignisse aller Manager (Einträge mit `t == 26`). Diese werden pro
///    Manager attribuiert und mit der Belohnung des jeweiligen Erfolgs-Typs
///    aufgelöst.
class AchievementBudgetService {
  /// Feed-Eintragstyp „Achievement erhalten".
  static const int feedTypeAchievement = 26;

  /// Offizieller Erfolgs-Katalog (Name → Belohnung in €).
  ///
  /// Als Fallback/Dokumentation. Die Belohnung aus der API (`er`) ist immer
  /// maßgeblich – dieser Katalog wird nur verwendet, wenn die API keine
  /// Belohnung liefert und der Erfolgs-Name bekannt ist.
  static const Map<String, int> knownAchievementRewards = {
    'Spieltagssieger': 1000000,
    'Spieltagspunkte Silber': 250000,
    'Spieltagspunkte Gold': 500000,
    'Jahrhundertspiel': 1000000,
    'Topscorer': 100000,
    'Matchwinner': 500000,
    'Weltklasse': 1000000,
    'Fussballgott': 2000000,
    'MVP': 1000000,
    'Tormaschine': 250000,
    'Bronzenes Händchen': 250000,
    'Silbernes Händchen': 500000,
    'Goldenes Händchen': 1000000,
    'Königstransfer': 2000000,
    'Meister': 2000000,
    'Vizemeister': 1000000,
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

  /// Extrahiert alle Achievement-Ereignisse aus dem Aktivitäten-Feed.
  ///
  /// Erkennt Einträge mit `t == 26` (Erfolg erhalten). Die User-Attribution
  /// im Eintrag ist undokumentiert und wird defensiv über mehrere Kandidaten-
  /// Felder ermittelt:
  /// - `data.u` als Map (`{'i': id, 'n': name}`) oder als String (ID)
  /// - `data.ui` / `data.unm` (ID / Name)
  ///
  /// Einträge ohne erkennbaren Empfänger werden NICHT verworfen, sondern mit
  /// leerem [AchievementFeedEvent.managerId] zurückgegeben (sollten bei der
  /// Buchung übersprungen werden).
  List<AchievementFeedEvent> parseFeedEvents(Map<String, dynamic> feedResponse) {
    final entries = (feedResponse['af'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final events = <AchievementFeedEvent>[];
    for (final entry in entries) {
      if (_asInt(entry['t']) != feedTypeAchievement) continue;

      final data = entry['data'];
      final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

      final typeId = (dataMap['t'] ?? entry['at'] ?? '').toString();
      if (typeId.isEmpty) continue;

      final user = _extractUser(dataMap);
      events.add(
        AchievementFeedEvent(
          activityId: (entry['id'] ?? entry['i'] ?? '').toString(),
          managerId: user.$1,
          managerName: user.$2,
          achievementTypeId: typeId,
          timestamp: _asDateTime(entry['dt'] ?? dataMap['dt']),
        ),
      );
    }
    return events;
  }

  /// Versucht, Empfänger (ID, Name) aus einem Feed-`data`-Objekt zu ziehen.
  (String, String) _extractUser(Map<String, dynamic> data) {
    final u = data['u'];
    if (u is Map) {
      return ((u['i'] ?? u['id'] ?? '').toString(), (u['n'] ?? '').toString());
    }
    if (u is String && u.isNotEmpty) {
      return (u, (data['un'] ?? '').toString());
    }
    final ui = data['ui'];
    if (ui != null) {
      return (ui.toString(), (data['unm'] ?? data['un'] ?? '').toString());
    }
    return ('', '');
  }

  // ---------------------------------------------------------------------------
  // Berechnung
  // ---------------------------------------------------------------------------

  /// Exakte Budget-Einnahmen des eigenen Managers durch Erfolge:
  /// Summe aus `achievedCount × earnedReward` über alle Erfolge.
  ///
  /// Der API-Wert `er` ist maßgeblich: `er = 0` (z.B. deaktivierte
  /// Erfolgs-Geldboni in der Liga) trägt bewusst NICHTS bei – hier greift
  /// kein Katalog-Fallback, sonst würden deaktivierte Boni fälschlich
  /// gezählt.
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

  /// Attribuiert Feed-Ereignisse pro Manager und löst die Belohnungen auf.
  ///
  /// [rewardByType] - Belohnung pro Erfolgs-Typ-ID (aus der eigenen
  ///   Achievements-Liste + Detail-Endpoints; die Belohnungen sind ligaweit
  ///   identisch, auch wenn die `ac`-Zahlen user-spezifisch sind).
  /// [events] - Feed-Ereignisse (siehe [parseFeedEvents]).
  ///
  /// Returns: Map managerId → Summary. Ereignisse ohne Empfänger werden
  /// übersprungen (nicht gebucht).
  Map<String, AchievementIncomeSummary> attributeFeedIncome({
    required List<AchievementFeedEvent> events,
    required Map<String, int> rewardByType,
  }) {
    final byManager = <String, List<AchievementEvent>>{};
    for (final event in events) {
      if (event.managerId.isEmpty) continue; // unattribuiert → nicht buchen
      final reward = rewardByType[event.achievementTypeId] ?? 0;
      if (reward <= 0) continue;
      byManager.putIfAbsent(event.managerId, () => []).add(
            AchievementEvent(
              achievementTypeId: event.achievementTypeId,
              name: event.managerName,
              reward: reward,
              timestamp: event.timestamp,
            ),
          );
    }

    return {
      for (final entry in byManager.entries)
        entry.key: AchievementIncomeSummary(
          managerId: entry.key,
          totalIncome: entry.value.fold(0, (sum, e) => sum + e.reward),
          events: entry.value,
        ),
    };
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

  DateTime? _asDateTime(Object? value) {
    if (value == null) return null;
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(
        value.toInt() * 1000,
        isUtc: true,
      );
    }
    return DateTime.tryParse(value.toString())?.toUtc();
  }
}
