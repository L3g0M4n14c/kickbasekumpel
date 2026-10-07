import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/achievement_model.dart';
import 'package:kickbasekumpel/data/models/budget_calculation_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/achievement_derivation_service.dart';

ManagerTransferHistoryEntry _transfer({
  required String playerId,
  required int transferType,
  required int price,
  String managerId = 'm1',
}) {
  return ManagerTransferHistoryEntry(
    id: 't-$playerId-$transferType-$price',
    leagueId: 'l1',
    managerId: managerId,
    managerName: 'Manager $managerId',
    playerId: playerId,
    playerName: 'Spieler $playerId',
    price: price,
    transferType: transferType,
    timestamp: DateTime.utc(2026, 9, 1),
  );
}

void main() {
  group('AchievementDerivationService.deriveMatchdayEvents', () {
    test(
      'Match day winner geht an den Manager mit den meisten Spieltagspunkten',
      () {
        final service = AchievementDerivationService();
        final events = service.deriveMatchdayEvents(
          pointsByMatchday: {
            1: {'m1': 400, 'm2': 300},
            2: {'m1': 200, 'm2': 350},
          },
        );

        expect(events['m1'], hasLength(1));
        expect(events['m1']!.single.name, 'Match day winner');
        expect(events['m2'], hasLength(1));
        expect(events['m2']!.single.name, 'Match day winner');
      },
    );

    test(
      'Gleichstand: beide Manager erhalten Match day winner (tiesShare)',
      () {
        final service = AchievementDerivationService();
        final events = service.deriveMatchdayEvents(
          pointsByMatchday: {
            1: {'m1': 400, 'm2': 400},
          },
        );

        expect(events['m1'], hasLength(1));
        expect(events['m2'], hasLength(1));
      },
    );

    test('Gleichstand ohne tiesShare: nur ein Match day winner', () {
      final service = AchievementDerivationService(
        rules: const AchievementDerivationRules(tiesShare: false),
      );
      final events = service.deriveMatchdayEvents(
        pointsByMatchday: {
          1: {'m1': 800, 'm2': 800},
        },
      );

      final winners = [
        ...?events['m1'],
        ...?events['m2'],
      ].where((e) => e.name == 'Match day winner');
      expect(winners, hasLength(1));
    });

    test('Punkte-Boni: Schwellen 500/1000/1500/2000 werden gestapelt', () {
      final service = AchievementDerivationService(
        rules: const AchievementDerivationRules(stackPointBonuses: true),
      );
      final events = service.deriveMatchdayEvents(
        pointsByMatchday: {
          1: {'m1': 1200}, // Bronze + Silber
          2: {'m1': 1600}, // Bronze + Silber + Gold
          3: {'m1': 2100}, // Bronze + Silber + Gold + Match of the century
        },
      );

      final names = events['m1']!.map((e) => e.name).toList();
      expect(names.where((n) => n == 'Match day points bronze'), hasLength(3));
      expect(names.where((n) => n == 'Match day points silver'), hasLength(3));
      expect(names.where((n) => n == 'Match day points gold'), hasLength(2));
      expect(names.where((n) => n == 'Match of the century'), hasLength(1));
      // 3× Bronze + 3× Silber + 2× Gold + 1× Jahrhundert + 3× Match day winner
      expect(events['m1'], hasLength(12));
    });

    test('ohne Stapelung zählt nur die höchste erreichte Punkte-Stufe', () {
      final service = AchievementDerivationService(
        rules: const AchievementDerivationRules(stackPointBonuses: false),
      );
      final events = service.deriveMatchdayEvents(
        pointsByMatchday: {
          1: {'m1': 1600},
        },
      );

      final names = events['m1']!.map((e) => e.name).toList();
      expect(names, contains('Match day points gold'));
      expect(names, isNot(contains('Match day points bronze')));
      expect(names, isNot(contains('Match day points silver')));
      expect(names, isNot(contains('Match of the century')));
    });
  });

  group('AchievementDerivationService.derivePlayerEvents', () {
    test('Spieler-Punkte-Schwellen 200/300/400/500 werden gestapelt', () {
      final service = AchievementDerivationService(
        rules: const AchievementDerivationRules(stackPlayerBonuses: true),
      );
      final events = service.derivePlayerEvents(
        lineupsByMatchday: {
          1: {
            'm1': {'p1'},
          },
        },
        playerPointsByMatchday: {
          'p1': {1: 350},
        },
      );

      final names = events['m1']!.map((e) => e.name).toList();
      expect(names, containsAll(['Top scorer', 'Match winner']));
      expect(names, isNot(contains('World class')));
    });

    test(
      'nur Lineup-Spieler zählen – Bankspieler bleiben unberücksichtigt',
      () {
        final service = AchievementDerivationService();
        final events = service.derivePlayerEvents(
          lineupsByMatchday: {
            1: {
              'm1': {'p1'},
            },
          },
          playerPointsByMatchday: {
            'p1': {1: 50},
            'p2': {1: 550}, // nicht im Lineup
          },
        );

        // p2s 550 Pkt. zählen für keinen Bonus – p1 ist der beste
        // Lineup-Spieler und bringt m1 (Regel: ownedLeagueWide) den MVP.
        final names = events.values
            .expand((e) => e.map((x) => x.name))
            .toList();
        expect(names, isNot(contains('Football god')));
        expect(names, isNot(contains('Top scorer')));
        expect(events['m1']!.map((e) => e.name), ['MVP']);
      },
    );

    test('MVP geht an den Besitzer des besten Spielers des Spieltags', () {
      final service = AchievementDerivationService();
      final events = service.derivePlayerEvents(
        lineupsByMatchday: {
          1: {
            'm1': {'p1'},
            'm2': {'p2'},
          },
        },
        playerPointsByMatchday: {
          'p1': {1: 300},
          'p2': {1: 450},
        },
      );

      final mvpOwners = [
        ...?events['m1'],
        ...?events['m2'],
      ].where((e) => e.name == 'MVP');
      expect(mvpOwners, hasLength(1));
      expect(events['m2']!.map((e) => e.name), contains('MVP'));
    });
  });

  group('AchievementDerivationService.deriveHandEvents', () {
    test('Gewinn pro Spieler löst Händchen-Schwellen gestapelt aus', () {
      final service = AchievementDerivationService(
        rules: const AchievementDerivationRules(handThresholdsStack: true),
      );
      final events = service.deriveHandEvents(
        transfers: [
          _transfer(playerId: 'p1', transferType: 1, price: 5000000),
          _transfer(playerId: 'p1', transferType: 2, price: 11000000),
        ],
      );

      final names = events.map((e) => e.name).toList();
      // Gewinn 6 Mio. → Bronze (3 Mio.) + Silber (5 Mio.)
      expect(names, containsAll(['Bronze hand', 'Silver hand']));
      expect(names, isNot(contains('Golden hand')));
    });

    test('ohne Stapelung zählt nur die höchste Händchen-Stufe', () {
      final service = AchievementDerivationService(
        rules: const AchievementDerivationRules(handThresholdsStack: false),
      );
      final events = service.deriveHandEvents(
        transfers: [
          _transfer(playerId: 'p1', transferType: 1, price: 5000000),
          _transfer(playerId: 'p1', transferType: 2, price: 11000000),
        ],
      );

      expect(events.map((e) => e.name), ['Silver hand']);
    });

    test('Verlustgeschäft oder noch gehaltener Spieler löst nichts aus', () {
      final service = AchievementDerivationService();
      final events = service.deriveHandEvents(
        transfers: [
          _transfer(playerId: 'p1', transferType: 1, price: 8000000),
          _transfer(playerId: 'p1', transferType: 2, price: 6000000), // -2 Mio.
          _transfer(
            playerId: 'p2',
            transferType: 1,
            price: 4000000,
          ), // gehalten
        ],
      );

      expect(events, isEmpty);
    });

    test(
      'Zulostung-Spieler (ohne Kauf) zählen mit dem vollen Verkaufserlös',
      () {
        final service = AchievementDerivationService();
        final events = service.deriveHandEvents(
          transfers: [
            _transfer(playerId: 'p1', transferType: 2, price: 4000000),
          ],
        );

        expect(events.map((e) => e.name), ['Bronze hand']);
      },
    );

    test('Auto-Verkäufe zählen als Verkauf zum Marktwert', () {
      final service = AchievementDerivationService();
      final events = service.deriveHandEvents(
        transfers: [_transfer(playerId: 'p1', transferType: 1, price: 2000000)],
        autoSales: const [
          AutoSaleEvent(
            matchday: 5,
            playerId: 'p1',
            playerName: 'Spieler',
            points: 250,
            threshold: 250,
            marketValue: 6000000,
          ),
        ],
      );

      // Gewinn 4 Mio. → nur Bronze hand (keine Dopplung mit The right touch)
      expect(events.map((e) => e.name), ['Bronze hand']);
    });

    test('Gewinne eines Spielers werden über die Saison kumuliert', () {
      final service = AchievementDerivationService();
      final events = service.deriveHandEvents(
        transfers: [
          _transfer(playerId: 'p1', transferType: 1, price: 3000000),
          _transfer(playerId: 'p1', transferType: 2, price: 6000000), // +3 Mio.
          _transfer(playerId: 'p1', transferType: 1, price: 9000000),
          _transfer(
            playerId: 'p1',
            transferType: 2,
            price: 11000000,
          ), // +2 Mio.
        ],
      );

      // Gesamtgewinn 5 Mio. → nur die höchste Stufe (Silver hand).
      final names = events.map((e) => e.name).toList();
      expect(names, ['Silver hand']);
    });
  });

  group('AchievementDerivationService.deriveSeasonEvents', () {
    test('Champion/Runner-up erst nach Saisonende', () {
      final service = AchievementDerivationService();
      final seasonPoints = {'m1': 900, 'm2': 850, 'm3': 800};

      expect(
        service.deriveSeasonEvents(
          seasonPointsByManager: seasonPoints,
          seasonFinished: false,
        ),
        isEmpty,
      );

      final events = service.deriveSeasonEvents(
        seasonPointsByManager: seasonPoints,
        seasonFinished: true,
      );
      expect(events['m1']!.single.name, 'Champion');
      expect(events['m2']!.single.name, 'Runner-up');
      expect(events['m3'], isNull);
    });
  });

  group('AchievementDerivationService Belohnungen', () {
    test('Katalog-Fallback über den Namen, API-Wert (`er`) ist maßgeblich', () {
      final service = AchievementDerivationService(
        apiRewardsByName: {'Top scorer': 42000},
      );

      expect(service.rewardFor('Top scorer'), 42000); // API-Wert
      expect(service.rewardFor('Match day winner'), 1000000); // Katalog
    });

    test('er = 0 zahlt für diesen Typ nichts (z.B. „Manager license")', () {
      final service = AchievementDerivationService(
        apiRewardsByName: {'Manager license': 0},
      );

      expect(service.rewardFor('Manager license'), 0);
      // Andere Typen behalten ihre Katalog-Belohnung.
      expect(service.rewardFor('Match day winner'), 1000000);
    });

    test(
      'Events ohne gültige Belohnung bleiben erhalten, summieren aber 0',
      () {
        final service = AchievementDerivationService(
          apiRewardsByName: {'Match day winner': 0},
        );
        final events = service.deriveMatchdayEvents(
          pointsByMatchday: {
            1: {'m1': 400}, // unter allen Bonus-Schwellen
          },
        );

        final summary = service.summarize('m1', events['m1']!);
        expect(summary.events, isNotEmpty);
        expect(summary.totalIncome, 0);
      },
    );
  });

  group('AchievementDerivationService.calibrate', () {
    test('Karriere-ac ist nur obere Schranke – weniger abgeleitet ist ok', () {
      final service = AchievementDerivationService();
      // ac = 3 Karriere, aber nur 2 in dieser Saison abgeleitet – die rest-
      // lichen stammen aus alten Saisons → kein Regelverstoß.
      final mismatches = service.calibrate(
        derivedEvents: const [
          AchievementEvent(achievementTypeId: 'a', name: 'Match day winner'),
          AchievementEvent(achievementTypeId: 'a', name: 'Match day winner'),
        ],
        actualCountsByName: {'Match day winner': 3},
      );

      expect(mismatches, isEmpty);
    });

    test('meldet Unterzählen gegen die Saison-Mindest-Erwartung (dt)', () {
      final service = AchievementDerivationService();
      final mismatches = service.calibrate(
        derivedEvents: const [],
        actualCountsByName: {'Match day winner': 5},
        minExpectedByName: {'Match day winner': 1},
      );

      expect(mismatches, hasLength(1));
      expect(mismatches.single.name, 'Match day winner');
      expect(mismatches.single.derivedCount, 0);
      expect(mismatches.single.minExpected, 1);
      expect(mismatches.single.maxPossible, 5);
    });

    test('meldet Überzählen über das Karriere-Maximum', () {
      final service = AchievementDerivationService();
      final mismatches = service.calibrate(
        derivedEvents: const [
          AchievementEvent(achievementTypeId: 'a', name: 'Top scorer'),
          AchievementEvent(achievementTypeId: 'a', name: 'Top scorer'),
        ],
        actualCountsByName: {'Top scorer': 1},
      );

      expect(mismatches, hasLength(1));
      expect(mismatches.single.derivedCount, 2);
      expect(mismatches.single.maxPossible, 1);
    });

    test('Tormaschine wird ignoriert (bewusst nicht abgeleitet)', () {
      final service = AchievementDerivationService();
      final mismatches = service.calibrate(
        derivedEvents: const [],
        actualCountsByName: {'Tormaschine': 2},
        minExpectedByName: {'Tormaschine': 1},
      );

      expect(mismatches, isEmpty);
    });

    test('Typen ohne Ableitung (z.B. "Panini") sind kein Fehler', () {
      final service = AchievementDerivationService();
      final mismatches = service.calibrate(
        derivedEvents: const [],
        actualCountsByName: {'Panini': 1},
        minExpectedByName: {'Panini': 1},
      );

      expect(mismatches, isEmpty);
    });

    test('Namen ohne API-Pendant werden übersprungen (Übersetzungs-Lücke)', () {
      final service = AchievementDerivationService();
      final mismatches = service.calibrate(
        derivedEvents: const [
          AchievementEvent(achievementTypeId: 'x', name: 'Unbekannter Name'),
        ],
        actualCountsByName: {'Top scorer': 1},
      );

      expect(mismatches, isEmpty);
    });
  });

  group('AchievementDerivationService neue Typen', () {
    test('Season points bronze ab 1000 Saisonpunkten', () {
      final service = AchievementDerivationService();
      final events = service.deriveSeasonPointEvents(
        seasonPointsByManager: {'m1': 1200, 'm2': 800},
      );

      expect(events['m1']!.single.name, 'Season points bronze');
      expect(events['m2'], isNull);
    });

    test('Team value bronze/silver ab 125/150 Mio. Teamwert', () {
      final service = AchievementDerivationService();
      final events = service.deriveTeamValueEvents(
        teamValuesByManager: {'m1': 160000000, 'm2': 130000000, 'm3': 50000000},
      );

      // m1 (160 Mio.): nur die höchste Stufe – Bronze ist eine separate
      // einmalige Trophäe (keine Dopplung).
      expect(events['m1']!.map((e) => e.name), ['Team value silver']);
      expect(events['m2']!.single.name, 'Team value bronze');
      expect(events['m3'], isNull);
    });

    test('First deal ab 1 Transfer, Transfer King bronze ab 50', () {
      final service = AchievementDerivationService();

      expect(
        service.deriveTransferCountEvents(transferCount: 1).single.name,
        'First deal',
      );
      expect(
        service.deriveTransferCountEvents(transferCount: 52).map((e) => e.name),
        ['First deal', 'Transfer King bronze'],
      );
      expect(service.deriveTransferCountEvents(transferCount: 0), isEmpty);
    });

    test('derivableNames enthält alle ableitbaren API-Typen', () {
      final service = AchievementDerivationService();
      expect(
        service.derivableNames,
        containsAll([
          'Match day winner',
          'Match day points bronze',
          'Top scorer',
          'MVP',
          'The right touch',
          'Bronze hand',
          'Season points bronze',
          'Team value bronze',
          'First deal',
          'Champion',
          'Runner-up',
        ]),
      );
    });
  });

  group('AchievementDerivationService.minExpectedInSeason', () {
    test('dt in der Saison → mindestens 1, alte Saison/ohne dt → 0', () {
      final service = AchievementDerivationService();
      final result = service.minExpectedInSeason(
        earnedAtByName: {
          'Top scorer': '2026-09-01T20:00:00Z', // in der Saison
          'MVP': '2025-05-01T20:00:00Z', // alte Saison
          'Football god': null,
        },
        seasonStart: DateTime.utc(2026, 8, 21),
      );

      expect(result, {'Top scorer': 1});
    });
  });
}
