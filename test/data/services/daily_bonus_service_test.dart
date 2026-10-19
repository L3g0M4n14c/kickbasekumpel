import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/daily_bonus_model.dart';
import 'package:kickbasekumpel/data/services/daily_bonus_service.dart';

void main() {
  final now = DateTime(2026, 3, 5, 18, 30);

  group('DailyBonusService.isCollectedToday', () {
    test('ohne bisheriges Einsammeln → false', () {
      expect(DailyBonusService.isCollectedToday(null, now), isFalse);
    });

    test('gleicher Kalendertag (andere Uhrzeit) → true', () {
      final sameDay = DateTime(2026, 3, 5, 0, 5);
      expect(DailyBonusService.isCollectedToday(sameDay, now), isTrue);
    });

    test('gestern eingesammelt → false (Banner wieder sichtbar)', () {
      final yesterday = DateTime(2026, 3, 4, 23, 59);
      expect(DailyBonusService.isCollectedToday(yesterday, now), isFalse);
    });

    test('morgen (Zeitzonen-Versatz) → false', () {
      final tomorrow = DateTime(2026, 3, 6, 0, 1);
      expect(DailyBonusService.isCollectedToday(tomorrow, now), isFalse);
    });
  });

  group('DailyBonusService.isBonusAvailable', () {
    final service = DailyBonusService();

    test('kein API-Hinweis, nicht eingesammelt → verfügbar', () {
      expect(
        service.isBonusAvailable(
          apiStatus: null,
          lastCollected: null,
          now: now,
        ),
        isTrue,
      );
    });

    test('API meldet ausstehenden Bonus → verfügbar', () {
      expect(
        service.isBonusAvailable(
          apiStatus: true,
          lastCollected: DateTime(2026, 3, 4),
          now: now,
        ),
        isTrue,
      );
    });

    test('API meldet keinen Bonus → nicht verfügbar', () {
      expect(
        service.isBonusAvailable(
          apiStatus: false,
          lastCollected: null,
          now: now,
        ),
        isFalse,
      );
    });

    test(
      'heute bereits eingesammelt → nicht verfügbar (auch bei API-Hinweis)',
      () {
        expect(
          service.isBonusAvailable(
            apiStatus: true,
            lastCollected: DateTime(2026, 3, 5, 9),
            now: now,
          ),
          isFalse,
        );
      },
    );
  });

  group('DailyBonusService.parseBaseOverview', () {
    final service = DailyBonusService();

    test('Bonus-Einträge in `it` → verfügbar', () {
      final status = service.parseBaseOverview({
        'it': [
          {'li': '1', 'lnm': 'Liga', 'v': 10000, 'day': 1, 'b': 100},
        ],
      });
      expect(status.isAvailable, isTrue);
    });

    test('leeres `it` → unbekannt (lokaler Stand entscheidet)', () {
      expect(service.parseBaseOverview({'it': []}).isAvailable, isNull);
    });

    test('News-Form (stg/sect) → unbekannt (lokaler Stand entscheidet)', () {
      final status = service.parseBaseOverview({
        'stg': [
          {'i': 'x', 'ti': 'News'},
        ],
        'sect': [],
      });
      expect(status.isAvailable, isNull);
    });

    test('unbekannte Struktur → unbekannt', () {
      expect(service.parseBaseOverview({}).isAvailable, isNull);
      expect(
        service.parseBaseOverview({
          'it': [
            {'i': 'x', 'ti': 'News ohne Bonus-Felder'},
          ],
        }).isAvailable,
        isNull,
      );
    });
  });

  group('DailyBonusService.parseCollectResult', () {
    final service = DailyBonusService();

    test('parst die echte Collect-Response inkl. Summe und Streak-Tag', () {
      final result = service.parseCollectResult({
        'it': [
          {
            'li': '2609146',
            'lnm': 'HaramLig',
            'v': 10000,
            'day': 1,
            'b': 59344981,
            'lim': 'league/bild.jpeg',
          },
          {
            'li': '5668220',
            'lnm': 'Acid League',
            'v': 15000,
            'day': 2,
            'b': 76826753,
            'lim': 'league/bild.png',
          },
        ],
        'url': 'https://go.kickbase.com/xyz',
        'btt': 'Jetzt Startbonus sichern!',
      });

      expect(result.collections, hasLength(2));
      expect(result.collections.first.leagueId, '2609146');
      expect(result.collections.first.leagueName, 'HaramLig');
      expect(result.collections.first.value, 10000);
      expect(result.collections.first.day, 1);
      expect(result.collections.first.budget, 59344981);
      expect(result.totalValue, 25000);
      expect(result.maxDay, 2);
    });

    test('fehlendes `it` → leeres Ergebnis', () {
      final result = service.parseCollectResult({'ok': true});
      expect(result.collections, isEmpty);
      expect(result.totalValue, 0);
      expect(result.maxDay, 0);
    });
  });

  group('BonusCollectResult.fromJson', () {
    test('Default-Werte bei unvollständigen Einträgen', () {
      final result = BonusCollectResult.fromJson({
        'it': [
          {'li': '1'},
        ],
      });
      expect(result.collections.single.value, 0);
      expect(result.collections.single.day, 1);
      expect(result.collections.single.leagueName, '');
    });
  });
}
