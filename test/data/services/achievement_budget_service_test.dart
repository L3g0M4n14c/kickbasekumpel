import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/achievement_model.dart';
import 'package:kickbasekumpel/data/services/achievement_budget_service.dart';

void main() {
  late AchievementBudgetService service;

  setUp(() {
    service = AchievementBudgetService();
  });

  group('AchievementBudgetService.parseAchievements', () {
    test('parst Roh-Items in Modelle', () {
      final raw = [
        {'t': 'matchday_winner', 'n': 'Spieltagssieger', 'ac': 2, 'ise': false},
        {'t': 'topscorer', 'n': 'Topscorer', 'ac': 1, 'ise': true},
      ];

      final achievements = service.parseAchievements(raw);

      expect(achievements, hasLength(2));
      expect(achievements[0].typeId, 'matchday_winner');
      expect(achievements[0].name, 'Spieltagssieger');
      expect(achievements[0].achievedCount, 2);
      expect(achievements[0].isOneTime, isFalse);
      expect(achievements[1].achievedCount, 1);
      expect(achievements[1].isOneTime, isTrue);
    });

    test('filtert Einträge ohne Typ-ID heraus', () {
      final raw = [
        {'n': 'Ohne Typ', 'ac': 1},
      ];
      expect(service.parseAchievements(raw), isEmpty);
    });
  });

  group('AchievementBudgetService.mergeAchievementDetail', () {
    test('ergänzt Belohnung, Beschreibung und Zeitpunkt', () {
      final achievement = KickbaseAchievement(
        typeId: 'topscorer',
        name: 'Topscorer',
        achievedCount: 1,
      );
      final detail = {
        'n': 'Topscorer',
        'd': '200 Punkte für max. einen Spieler',
        'ac': 1,
        'er': 100000,
        'dt': '2026-09-01T20:00:00Z',
        'ise': false,
      };

      final merged = service.mergeAchievementDetail(achievement, detail);

      expect(merged.earnedReward, 100000);
      expect(merged.achievedCount, 1);
      expect(merged.description, '200 Punkte für max. einen Spieler');
      expect(merged.earnedAt, '2026-09-01T20:00:00Z');
    });
  });

  group('AchievementBudgetService.exactOwnIncome', () {
    test('summiert achievedCount × earnedReward', () {
      final achievements = [
        KickbaseAchievement(
          typeId: 'matchday_winner',
          name: 'Spieltagssieger',
          achievedCount: 2,
          earnedReward: 1000000,
        ),
        KickbaseAchievement(
          typeId: 'topscorer',
          name: 'Topscorer',
          achievedCount: 1,
          earnedReward: 100000,
        ),
        KickbaseAchievement(
          typeId: 'not_achieved',
          name: 'Nie erreicht',
          achievedCount: 0,
          earnedReward: 500000,
        ),
      ];

      final summary = service.exactOwnIncome(achievements);

      expect(summary.totalIncome, 2100000);
      expect(summary.isExact, isTrue);
      expect(summary.events, hasLength(2));
    });

    test('deaktivierte Boni (er = 0) tragen nichts bei', () {
      final achievements = [
        KickbaseAchievement(
          typeId: 'mvp',
          name: 'MVP',
          achievedCount: 3,
          earnedReward: 0,
        ),
      ];

      expect(service.exactOwnIncome(achievements).totalIncome, 0);
    });
  });
}
