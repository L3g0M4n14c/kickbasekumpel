/// Ein Kickbase-Erfolg (Achievement) mit Budget-Belohnung.
///
/// Datenquelle: `GET /v4/leagues/{leagueId}/user/achievements` (Liste) bzw.
/// `GET /v4/leagues/{leagueId}/user/achievements/{type}` (Detail inkl. `er`).
///
/// Die Belohnung (`er`) wird dem Manager-Budget von Kickbase direkt
/// gutgeschrieben, erscheint aber NICHT in der Transfer-Historie – daher
/// muss sie für die Budget-Berechnung separat ermittelt werden.
///
/// Hinweis: Plain-Dart-Klasse statt Freezed – interne Modelle ohne
/// JSON-Bedarf brauchen keine Code-Generierung. Struktur ist
/// freezed-kompatibel gehalten, damit ein späterer Wechsel einfach bleibt.
class KickbaseAchievement {
  /// Typ-ID des Erfolgs (Feld `t` in der API)
  final String typeId;

  /// Name des Erfolgs (Feld `n`), z.B. "Spieltagssieger"
  final String name;

  /// Anzahl, wie oft der authentifizierte User den Erfolg erreicht hat
  /// (Feld `ac`)
  final int achievedCount;

  /// Geld-Belohnung pro Erreichen in € (Feld `er`), z.B. 1000000 = 1 Mio.
  final int earnedReward;

  /// Flag aus der API (Feld `ise`) – korreliert mit `ac > 0`
  /// (vermutlich „erreicht"; keine inhaltliche Nutzung).
  final bool isOneTime;

  /// Beschreibung des Erfolgs (Feld `d`, nur im Detail-Endpoint)
  final String? description;

  /// Zeitpunkt des Erreichens (Feld `dt`, nur im Detail-Endpoint)
  final String? earnedAt;

  const KickbaseAchievement({
    required this.typeId,
    this.name = '',
    this.achievedCount = 0,
    this.earnedReward = 0,
    this.isOneTime = false,
    this.description,
    this.earnedAt,
  });

  KickbaseAchievement copyWith({
    String? typeId,
    String? name,
    int? achievedCount,
    int? earnedReward,
    bool? isOneTime,
    String? description,
    String? earnedAt,
  }) {
    return KickbaseAchievement(
      typeId: typeId ?? this.typeId,
      name: name ?? this.name,
      achievedCount: achievedCount ?? this.achievedCount,
      earnedReward: earnedReward ?? this.earnedReward,
      isOneTime: isOneTime ?? this.isOneTime,
      description: description ?? this.description,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  @override
  String toString() =>
      'KickbaseAchievement($typeId, $name, ac=$achievedCount, er=$earnedReward)';
}

/// Ein einzelner Erfolgs-Budget-Posten (bereits mit Belohnung aufgelöst).
class AchievementEvent {
  /// Erfolgs-Typ-ID
  final String achievementTypeId;

  /// Name des Erfolgs (falls bekannt)
  final String name;

  /// Budget-Belohnung in € (einmalige Gutschrift pro Ereignis)
  final int reward;

  /// Zeitpunkt des Ereignisses
  final DateTime? timestamp;

  const AchievementEvent({
    required this.achievementTypeId,
    this.name = '',
    this.reward = 0,
    this.timestamp,
  });

  @override
  String toString() => 'AchievementEvent($name, +$reward €)';
}

/// Budget-Einnahmen eines Managers durch Erfolge (Achievements).
class AchievementIncomeSummary {
  /// Manager-ID
  final String managerId;

  /// Summe der Budget-Einnahmen durch Erfolge in €
  final int totalIncome;

  /// Einzelne Erfolgs-Ereignisse, die zu [totalIncome] führten
  final List<AchievementEvent> events;

  /// true, wenn die Einnahmen aus der eigenen Achievements-Liste stammen
  /// (exakt), false bei Feed-Attribution
  final bool isExact;

  const AchievementIncomeSummary({
    required this.managerId,
    this.totalIncome = 0,
    this.events = const [],
    this.isExact = false,
  });

  AchievementIncomeSummary copyWith({
    String? managerId,
    int? totalIncome,
    List<AchievementEvent>? events,
    bool? isExact,
  }) {
    return AchievementIncomeSummary(
      managerId: managerId ?? this.managerId,
      totalIncome: totalIncome ?? this.totalIncome,
      events: events ?? this.events,
      isExact: isExact ?? this.isExact,
    );
  }
}
