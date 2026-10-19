import 'package:logger/logger.dart';

import '../models/daily_bonus_model.dart';

/// Service für den Tagesbonus (Story #17: Daily-Bonus-Erinnerung mit
/// Tap-to-Collect).
///
/// Verfügbarkeit eines Tagesbonus:
/// 1. **API-Hinweis** aus `GET /v4/base/overview` – die dokumentierte Response
///    enthält News-Inhalte (`stg`, `sect`); Bonus-Einträge werden aber erkannt,
///    falls die API sie liefert (siehe [parseBaseOverview]).
/// 2. **Lokale Persistenz** – nach dem Einsammeln wird der Kalendertag
///    gespeichert; das Banner bleibt bis zum nächsten Tag ausgeblendet.
///
/// Beide Quellen werden in [isBonusAvailable] kombiniert.
class DailyBonusService {
  DailyBonusService({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  /// true, wenn [lastCollected] am selben Kalendertag wie [now] liegt.
  static bool isCollectedToday(DateTime? lastCollected, DateTime now) {
    if (lastCollected == null) return false;
    return lastCollected.year == now.year &&
        lastCollected.month == now.month &&
        lastCollected.day == now.day;
  }

  /// Kombiniert API-Hinweis und lokalen Einsammel-Stand.
  ///
  /// [apiStatus]: `true` = Bonus ausstehend, `false` = keiner ausstehend,
  /// `null` = API liefert keinen Hinweis (lokaler Stand entscheidet).
  bool isBonusAvailable({
    required bool? apiStatus,
    required DateTime? lastCollected,
    required DateTime now,
  }) {
    if (isCollectedToday(lastCollected, now)) return false;
    return apiStatus ?? true;
  }

  /// Parst die Antwort von `GET /v4/base/overview` in einen [DailyBonusStatus].
  ///
  /// Auswertung (defensiv, da die dokumentierte Response keinen eindeutigen
  /// Bonus-Status enthält):
  /// - `it` mit Bonus-Einträgen (`v`/`day`, wie bei `GET /v4/bonus/collect`)
  ///   → `isAvailable: true`
  /// - sonst (leeres `it`, News-Form `stg`/`sect`, unbekannte Struktur)
  ///   → `isAvailable: null` (unbekannt – der lokale Einsammel-Stand entscheidet)
  ///
  /// Hinweis: Ein leeres `it` wird bewusst NICHT als „kein Bonus" gewertet –
  /// die Beispiel-Response der Doku zeigt genau diese Form, ohne dass das
  /// etwas über den Bonus-Status aussagt.
  DailyBonusStatus parseBaseOverview(Map<String, dynamic> json) {
    final items = json['it'];
    if (items is List) {
      final bonusItems = items
          .whereType<Map<String, dynamic>>()
          .where((e) => e.containsKey('v') || e.containsKey('day'))
          .toList();
      if (bonusItems.isNotEmpty) {
        _logger.d('🎁 Overview meldet ${bonusItems.length} Bonus-Einträge');
        return const DailyBonusStatus(isAvailable: true);
      }
    }
    // Kein eindeutiger Hinweis → lokaler Stand entscheidet
    return const DailyBonusStatus(isAvailable: null);
  }

  /// Parst die Antwort von `GET /v4/bonus/collect` in ein [BonusCollectResult].
  BonusCollectResult parseCollectResult(Map<String, dynamic> json) {
    final result = BonusCollectResult.fromJson(json);
    _logger.i(
      '🎁 Bonus geparst: ${result.collections.length} Ligen, '
      'Summe ${result.totalValue}€ (Tag ${result.maxDay})',
    );
    return result;
  }
}
