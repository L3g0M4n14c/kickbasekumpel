import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/budget_calculation_service.dart';

void main() {
  group('BudgetCalculationService', () {
    late BudgetCalculationService service;

    setUp(() {
      service = BudgetCalculationService();
    });

    test('calculateManagerBudget with no transfers', () {
      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: [],
      );

      expect(result.managerId, 'manager1');
      expect(result.managerName, 'Test Manager');
      expect(result.leagueId, 'league1');
      expect(result.initialBudget, 50000000);
      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 0);
      expect(result.totalPurchases, 0);
      expect(result.currentBudget, 50000000);
      expect(result.sales, isEmpty);
      expect(result.purchases, isEmpty);
    });

    test('calculateManagerBudget with sales only', () {
      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Sold Player',
          price: 20000000,
          transferType: 2, // Sale
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
      );

      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 20000000);
      expect(result.totalPurchases, 0);
      expect(result.currentBudget, 70000000); // 50M + 20M
      expect(result.sales.length, 1);
      expect(result.purchases.length, 0);
    });

    test('calculateManagerBudget with purchases only', () {
      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Bought Player',
          price: 30000000,
          transferType: 1, // Purchase
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
      );

      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 0);
      expect(result.totalPurchases, 30000000);
      expect(result.currentBudget, 20000000); // 50M - 30M
      expect(result.sales.length, 0);
      expect(result.purchases.length, 1);
    });

    test('calculateManagerBudget with mixed transfers', () {
      // Beispiel: Startbudget 50M + Verkauf 20M - Kauf 30M = 40M

      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Sold Player',
          price: 20000000,
          transferType: 2, // Sale
          timestamp: DateTime.now(),
        ),
        ManagerTransferHistoryEntry(
          id: '2',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '3',
          playerName: 'Bought Player',
          price: 30000000,
          transferType: 1, // Purchase
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
      );

      expect(result.startingBudget, 50000000);
      expect(result.totalSales, 20000000);
      expect(result.totalPurchases, 30000000);
      expect(result.currentBudget, 40000000); // 50M + 20M - 30M = 40M
    });

    test('formatBudget formats correctly', () {
      expect(service.formatBudget(50000000), '50.00 M €');
      expect(service.formatBudget(70000000), '70.00 M €');
      expect(service.formatBudget(1234567), '1.23 M €');
    });

    test('formatMarketValue formats correctly', () {
      expect(service.formatMarketValue(50000000), '50.00 M €');
      expect(service.formatMarketValue(500000), '500 T €');
      expect(service.formatMarketValue(1234567), '1.23 M €');
    });
  });

  group('BudgetCalculationService – Anmeldebonus', () {
    late BudgetCalculationService service;

    setUp(() {
      service = BudgetCalculationService();
    });

    test(
      'loginBonusForDay steigt täglich bis Tag 10 und bleibt dann konstant',
      () {
        expect(service.loginBonusForDay(1), 10000);
        expect(service.loginBonusForDay(2), 20000);
        expect(service.loginBonusForDay(3), 30000);
        expect(service.loginBonusForDay(9), 90000);
        expect(service.loginBonusForDay(10), 100000);
        expect(service.loginBonusForDay(11), 100000);
        expect(service.loginBonusForDay(25), 100000);
        expect(service.loginBonusForDay(0), 0);
        expect(service.loginBonusForDay(-5), 0);
      },
    );

    test('cumulativeLoginBonus summiert die Tagesboni korrekt', () {
      expect(service.cumulativeLoginBonus(0), 0);
      expect(service.cumulativeLoginBonus(-3), 0);
      // Tag 1: 10.000 €
      expect(service.cumulativeLoginBonus(1), 10000);
      // Tag 1+2: 10.000 + 20.000 = 30.000 €
      expect(service.cumulativeLoginBonus(2), 30000);
      // Tag 1+2+3: 10.000 + 20.000 + 30.000 = 60.000 €
      expect(service.cumulativeLoginBonus(3), 60000);
      // Tag 1..10: 10.000 + 20.000 + … + 100.000 = 550.000 €
      expect(service.cumulativeLoginBonus(10), 550000);
      // Ab Tag 10 kommen täglich 100.000 € hinzu
      expect(service.cumulativeLoginBonus(11), 650000);
      expect(
        service.cumulativeLoginBonus(20),
        1550000,
      ); // 550.000 + 10 × 100.000
    });

    test('calculateLoginBonus am ersten Tag der Liga', () {
      final seasonStart = DateTime.utc(2026, 8, 21);
      final result = service.calculateLoginBonus(
        seasonStart: seasonStart,
        now: DateTime.utc(2026, 8, 21, 23, 59),
      );

      expect(result, 10000);
      expect(
        service.loginBonusDaysSince(
          seasonStart,
          now: DateTime.utc(2026, 8, 21, 23, 59),
        ),
        1,
      );
    });

    test('calculateLoginBonus am zweiten Tag der Liga', () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 22, 12, 0),
      );

      expect(result, 30000); // 10.000 + 20.000
    });

    test('calculateLoginBonus am zehnten Tag der Liga', () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 30, 6, 0),
      );

      expect(result, 550000); // 10.000 + … + 100.000
    });

    test('calculateLoginBonus nach dem zehnten Tag: täglich 100.000 €', () {
      final result = service.calculateLoginBonus(
        seasonStart: DateTime.utc(2026, 8, 21),
        now: DateTime.utc(2026, 8, 31, 18, 30),
      );

      expect(result, 650000); // 550.000 + 100.000
    });

    test(
      'calculateLoginBonus ist 0, wenn die Liga noch nicht gestartet ist',
      () {
        final result = service.calculateLoginBonus(
          seasonStart: DateTime.utc(2026, 8, 21),
          now: DateTime.utc(2026, 8, 20, 23, 59),
        );

        expect(result, 0);
      },
    );

    test(
      'calculateLoginBonus normalisiert Zeitanteile (UTC, Tagesgrenzen)',
      () {
        // Saisonstart mit Uhrzeit – muss trotzdem als Tag 21.08. gelten
        final result = service.calculateLoginBonus(
          seasonStart: DateTime.utc(2026, 8, 21, 14, 30),
          now: DateTime.utc(2026, 8, 23, 1, 0),
        );

        expect(result, 60000); // 10.000 + 20.000 + 30.000
      },
    );
  });

  group('BudgetCalculationService – Punktgeld (Spieltagsprämie)', () {
    late BudgetCalculationService service;

    setUp(() {
      service = BudgetCalculationService();
    });

    test('pointsMoneyFor zahlt 1.000 € pro Saison-Punkt', () {
      expect(BudgetCalculationService.pointsMoneyPerPoint, 1000);
      expect(service.pointsMoneyFor(0), 0);
      expect(service.pointsMoneyFor(-5), 0);
      expect(service.pointsMoneyFor(1), 1000);
      expect(service.pointsMoneyFor(1547), 1547000);
    });

    test('seasonTotalPoints liest tp der aktuellen Saison (cur=true)', () {
      final performance = {
        'it': [
          {
            // alte Saison (alt → neu sortiert)
            'sid': 's1',
            'tp': 2500,
            'it': [
              {'day': 34, 'mdp': 100, 'tw': true, 'cur': false},
            ],
          },
          {
            // aktuelle Saison
            'sid': 's2',
            'tp': 1547,
            'it': [
              {'day': 1, 'mdp': 120, 'tw': true, 'cur': false},
              {'day': 2, 'mdp': 95, 'tw': false, 'cur': true},
            ],
          },
        ],
      };

      expect(service.seasonTotalPoints(performance), 1547);
    });

    test('seasonTotalPoints Fallback: letzte Saison ohne cur-Markierung', () {
      final performance = {
        'it': [
          {
            'sid': 's1',
            'tp': 2500,
            'it': [
              {'day': 34, 'mdp': 100, 'tw': true, 'cur': false},
            ],
          },
          {
            'sid': 's2',
            'tp': 800,
            'it': [
              {'day': 1, 'mdp': 120, 'tw': true, 'cur': false},
            ],
          },
        ],
      };

      expect(service.seasonTotalPoints(performance), 800);
    });

    test('seasonTotalPoints parst tp als num und String', () {
      expect(
        service.seasonTotalPoints({
          'it': [
            {'tp': 1200.0, 'it': []},
          ],
        }),
        1200,
      );
      expect(
        service.seasonTotalPoints({
          'it': [
            {'tp': '750', 'it': []},
          ],
        }),
        750,
      );
    });

    test('seasonTotalPoints ist 0 bei leerer/fehlender Response', () {
      expect(service.seasonTotalPoints({'it': []}), 0);
      expect(service.seasonTotalPoints({}), 0);
      expect(
        service.seasonTotalPoints({
          'it': [
            {'it': []}, // tp fehlt
          ],
        }),
        0,
      );
    });

    test('calculateManagerBudget rechnet Punktgeld in die Summe ein', () {
      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: [],
        seasonPoints: 1547,
      );

      expect(result.seasonPoints, 1547);
      expect(result.pointsMoney, 1547000);
      expect(result.currentBudget, 51547000); // 50M + 1.547.000
    });

    test('calculateManagerBudget: Punktgeld + Verkäufe - Käufe', () {
      final allTransfers = [
        ManagerTransferHistoryEntry(
          id: '1',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '2',
          playerName: 'Sold Player',
          price: 20000000,
          transferType: 2, // Sale
          timestamp: DateTime.now(),
        ),
        ManagerTransferHistoryEntry(
          id: '2',
          leagueId: 'league1',
          managerId: 'manager1',
          managerName: 'Test Manager',
          playerId: '3',
          playerName: 'Bought Player',
          price: 30000000,
          transferType: 1, // Purchase
          timestamp: DateTime.now(),
        ),
      ];

      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: allTransfers,
        seasonPoints: 500,
      );

      expect(result.pointsMoney, 500000);
      expect(result.currentBudget, 40500000); // 50M + 20M - 30M + 500.000
    });

    test('calculateManagerBudget ohne seasonPoints zahlt kein Punktgeld', () {
      final result = service.calculateManagerBudget(
        managerId: 'manager1',
        managerName: 'Test Manager',
        leagueId: 'league1',
        allTransfers: [],
      );

      expect(result.seasonPoints, 0);
      expect(result.pointsMoney, 0);
      expect(result.currentBudget, 50000000);
    });
  });

  group('BudgetCalculationService – Anmeldebonus aus Aktivitäten-Feed', () {
    late BudgetCalculationService service;

    setUp(() {
      service = BudgetCalculationService();
    });

    test('summiert nur Anmeldebonus-Einträge (Typ 22) über data.bn', () {
      final feed = {
        'af': [
          {
            // Anmeldebonus
            't': 22,
            'dt': '2026-08-22T10:00:00Z',
            'data': {'bn': 10000, 'day': 2},
          },
          {
            // Transfer – muss ignoriert werden
            't': 15,
            'dt': '2026-08-23T10:00:00Z',
            'data': {'trp': 5000000, 'pn': 'Spieler'},
          },
          {
            // Erfolg – muss ignoriert werden
            't': 26,
            'dt': '2026-08-24T10:00:00Z',
            'data': {'t': 7},
          },
          {
            // weiterer Anmeldebonus
            't': 22,
            'dt': '2026-08-24T10:00:00Z',
            'data': {'bn': 30000, 'day': 4},
          },
        ],
      };

      final result = service.loginBonusFromActivityFeed(feed);

      expect(result.total, 40000);
      expect(result.count, 2);
    });

    test('filtert Einträge vor dem Saisonstart (since)', () {
      final feed = {
        'af': [
          {
            't': 22,
            'dt': '2026-08-10T10:00:00Z', // vor Saisonstart
            'data': {'bn': 100000},
          },
          {
            't': 22,
            'dt': '2026-08-21T00:00:00Z', // genau am Saisonstart
            'data': {'bn': 10000},
          },
          {
            't': 22,
            'dt': '2026-09-05T10:00:00Z', // danach
            'data': {'bn': 20000},
          },
        ],
      };

      final result = service.loginBonusFromActivityFeed(
        feed,
        since: DateTime.utc(2026, 8, 21),
      );

      expect(result.total, 30000);
      expect(result.count, 2);
    });

    test('robust bei fehlenden Feldern', () {
      expect(service.loginBonusFromActivityFeed({}).total, 0);
      expect(service.loginBonusFromActivityFeed({'af': []}).count, 0);

      final result = service.loginBonusFromActivityFeed({
        'af': [
          {'t': 22}, // data fehlt
          {'t': 22, 'dt': '2026-09-01T00:00:00Z'}, // data fehlt
          {
            't': 22,
            'dt': '2026-09-02T00:00:00Z',
            'data': {'bn': 5000},
          },
        ],
      });

      expect(result.total, 5000);
      expect(result.count, 3);
    });

    test('Einträge ohne parsbares Datum fallen bei since raus', () {
      final feed = {
        'af': [
          {
            't': 22,
            'data': {'bn': 10000},
          }, // dt fehlt
          {
            't': 22,
            'dt': 'garbage',
            'data': {'bn': 20000},
          },
          {
            't': 22,
            'dt': '2026-09-01T00:00:00Z',
            'data': {'bn': 30000},
          },
        ],
      };

      final result = service.loginBonusFromActivityFeed(
        feed,
        since: DateTime.utc(2026, 8, 21),
      );

      expect(result.total, 30000);
      expect(result.count, 1);
    });
  });
}
