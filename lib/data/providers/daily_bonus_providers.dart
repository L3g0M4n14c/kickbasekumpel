import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_bonus_model.dart';
import '../services/daily_bonus_service.dart';
import 'kickbase_api_provider.dart';
import 'league_detail_providers.dart';

final _logger = Logger();

// ============================================================================
// DAILY BONUS PROVIDERS - Story #17 (Daily-Bonus-Erinnerung mit Tap-to-Collect)
// ============================================================================

/// SharedPreferences-Key für den Zeitpunkt des letzten Einsammelns.
const String kDailyBonusLastCollectedKey = 'daily_bonus_last_collected';

/// State des Tagesbonus-Banners.
class DailyBonusState {
  /// true, solange der Bonus-Status geprüft wird
  final bool isLoading;

  /// true, wenn ein Tagesbonus verfügbar ist (Banner anzeigen)
  final bool isAvailable;

  /// true, während der Bonus gerade eingesammelt wird
  final bool isCollecting;

  /// Zeitpunkt des letzten Einsammelns (lokal gespeichert)
  final DateTime? lastCollected;

  /// Ergebnis des letzten Einsammelns (für die Bestätigung)
  final BonusCollectResult? lastResult;

  /// Fehlermeldung des letzten Fehlschlags
  final String? error;

  const DailyBonusState({
    this.isLoading = false,
    this.isAvailable = false,
    this.isCollecting = false,
    this.lastCollected,
    this.lastResult,
    this.error,
  });

  DailyBonusState copyWith({
    bool? isLoading,
    bool? isAvailable,
    bool? isCollecting,
    DateTime? lastCollected,
    BonusCollectResult? lastResult,
    String? error,
  }) {
    return DailyBonusState(
      isLoading: isLoading ?? this.isLoading,
      isAvailable: isAvailable ?? this.isAvailable,
      isCollecting: isCollecting ?? this.isCollecting,
      lastCollected: lastCollected ?? this.lastCollected,
      lastResult: lastResult ?? this.lastResult,
      error: error,
    );
  }
}

/// Provider für den Tagesbonus-Service (überschreibbar in Tests).
final dailyBonusServiceProvider = Provider<DailyBonusService>(
  (ref) => DailyBonusService(),
);

/// State-Provider für den Tagesbonus.
///
/// Steuert das Erinnerungs-Banner auf dem Home-Screen:
/// [DailyBonusState.isAvailable] ist nur true, wenn ein Bonus aussteht und
/// dieser noch nicht heute eingesammelt wurde.
final dailyBonusProvider =
    NotifierProvider<DailyBonusNotifier, DailyBonusState>(
      DailyBonusNotifier.new,
    );

/// Notifier für den Tagesbonus (Status-Check + Tap-to-Collect).
class DailyBonusNotifier extends Notifier<DailyBonusState> {
  DailyBonusService get _service => ref.read(dailyBonusServiceProvider);

  @override
  DailyBonusState build() {
    // Beim ersten Anzeigen Bonus-Status prüfen (API + lokale Persistenz)
    Future.microtask(refresh);
    return const DailyBonusState();
  }

  /// Prüft, ob ein Tagesbonus verfügbar ist.
  ///
  /// Kombiniert den API-Hinweis aus `GET /v4/base/overview` mit dem lokal
  /// gespeicherten Einsammel-Zeitpunkt (Banner bleibt bis zum nächsten Tag
  /// ausgeblendet). Fällt die Overview-Abfrage aus, entscheidet der
  /// lokale Stand.
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCollected = _readLastCollected(prefs);

      bool? apiStatus;
      try {
        final overview = await ref
            .read(kickbaseApiClientProvider)
            .getBaseOverview();
        apiStatus = _service.parseBaseOverview(overview).isAvailable;
      } catch (e) {
        _logger.w('⚠️ Bonus-Status aus /base/overview nicht lesbar: $e');
      }

      final available = _service.isBonusAvailable(
        apiStatus: apiStatus,
        lastCollected: lastCollected,
        now: DateTime.now(),
      );
      _logger.d(
        available ? '🎁 Tagesbonus verfügbar' : '🎁 Kein Tagesbonus ausstehend',
      );
      state = state.copyWith(
        isLoading: false,
        isAvailable: available,
        lastCollected: lastCollected,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Sammelt den Tagesbonus ein (Tap-to-Collect).
  ///
  /// Gibt das [BonusCollectResult] mit der Bonus-Summe zurück oder `null`
  /// bei einem Fehler. Auch ein leeres Ergebnis (nichts zu sammeln, z. B.
  /// bereits in der Kickbase-App eingesammelt) blendet das Banner bis zum
  /// nächsten Tag aus, damit es nicht stört.
  Future<BonusCollectResult?> collect() async {
    if (state.isCollecting) return null;
    state = state.copyWith(isCollecting: true, error: null);
    try {
      final json = await ref.read(kickbaseApiClientProvider).collectBonus();
      final result = _service.parseCollectResult(json);

      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kDailyBonusLastCollectedKey, now.toIso8601String());
      _logger.i('🎁 Tagesbonus eingesammelt: ${result.totalValue}€');

      state = state.copyWith(
        isCollecting: false,
        isAvailable: false,
        lastCollected: now,
        lastResult: result,
      );

      // Budget hat sich geändert → Budget-Anzeigen neu laden
      ref.invalidate(leagueMeProvider);
      ref.invalidate(myBudgetProvider);
      return result;
    } catch (e) {
      _logger.e('❌ Bonus sammeln fehlgeschlagen: $e');
      state = state.copyWith(isCollecting: false, error: e.toString());
      return null;
    }
  }

  DateTime? _readLastCollected(SharedPreferences prefs) {
    final raw = prefs.getString(kDailyBonusLastCollectedKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }
}
