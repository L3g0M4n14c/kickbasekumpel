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

  group('AchievementBudgetService.parseFeedEvents', () {
    test('extrahiert nur Achievement-Einträge (t == 26)', () {
      final feed = {
        'af': [
          {
            'id': 'a1',
            't': 15,
            'data': {'byr': 'm1', 'slr': 'm2', 'trp': 5000000},
          },
          {
            'id': 'a2',
            't': 26,
            'dt': '2026-09-14T20:00:00Z',
            'data': {'t': 'matchday_winner', 'u': {'i': 'm1', 'n': 'Marco'}},
          },
          {
            'id': 'a3',
            't': 22,
            'data': {'bn': 100000},
          },
        ],
      };

      final events = service.parseFeedEvents(feed);

      expect(events, hasLength(1));
      expect(events[0].activityId, 'a2');
      expect(events[0].achievementTypeId, 'matchday_winner');
      expect(events[0].managerId, 'm1');
      expect(events[0].managerName, 'Marco');
      expect(events[0].timestamp, isNotNull);
    });

    test('attribuiert User auch über String- und ui-Felder', () {
      final feed = {
        'af': [
          {
            'id': 'a',
            't': 26,
            'data': {'t': 'topscorer', 'u': 'm9'},
          },
          {
            'id': 'b',
            't': 26,
            'data': {'t': 'mvp', 'ui': 'm7', 'unm': 'Lena'},
          },
        ],
      };

      final events = service.parseFeedEvents(feed);

      expect(events, hasLength(2));
      expect(events[0].managerId, 'm9');
      expect(events[1].managerId, 'm7');
      expect(events[1].managerName, 'Lena');
    });

    test('Eintrag ohne erkennbaren Empfänger bekommt leere managerId', () {
      final feed = {
        'af': [
          {'id': 'x', 't': 26, 'data': {'t': 'mvp'}},
        ],
      };

      final events = service.parseFeedEvents(feed);
      expect(events, hasLength(1));
      expect(events[0].managerId, isEmpty);
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

  group('AchievementBudgetService.attributeFeedIncome', () {
    test('attribuiert Feed-Ereignisse pro Manager', () {
      final events = [
        AchievementFeedEvent(
          activityId: 'a',
          managerId: 'm1',
          achievementTypeId: 'matchday_winner',
        ),
        AchievementFeedEvent(
          activityId: 'b',
          managerId: 'm2',
          achievementTypeId: 'topscorer',
        ),
        AchievementFeedEvent(
          activityId: 'c',
          managerId: 'm1',
          achievementTypeId: 'topscorer',
        ),
        // Unattribuiert → darf nicht gebucht werden
        AchievementFeedEvent(managerId: '', achievementTypeId: 'mvp'),
      ];

      final rewards = {
        'matchday_winner': 1000000,
        'topscorer': 100000,
        'mvp': 1000000,
      };

      final income = service.attributeFeedIncome(
        events: events,
        rewardByType: rewards,
      );

      expect(income['m1']!.totalIncome, 1100000);
      expect(income['m1']!.events, hasLength(2));
      expect(income['m2']!.totalIncome, 100000);
      expect(income.containsKey(''), isFalse);
    });

    test('unbekannte Typ-IDs ohne Belohnung werden übersprungen', () {
      final events = [
        AchievementFeedEvent(managerId: 'm1', achievementTypeId: 'unknown'),
      ];

      final income = service.attributeFeedIncome(events: events, rewardByType: {});
      expect(income, isEmpty);
    });
  });
}
