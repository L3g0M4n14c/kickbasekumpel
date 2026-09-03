import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/market_value_model.dart';
import 'package:kickbasekumpel/data/models/performance_model.dart';
import 'package:kickbasekumpel/data/models/transfer_model.dart';
import 'package:kickbasekumpel/data/services/auto_sale_budget_service.dart';

/// Hilfs-Timestamps: Match-Kickoffs (ISO) und Marktwert-Tage.
final _day1Start = DateTime.utc(2026, 8, 22, 15, 30);
final _day2Start = DateTime.utc(2026, 8, 29, 15, 30);
final _day3Start = DateTime.utc(2026, 9, 12, 15, 30);

MatchPerformance _perf(int day, DateTime kickoff, {int? p}) {
  return MatchPerformance(
    day: day,
    p: p,
    cur: false,
    md: kickoff.toIso8601String(),
    t1: 'Team A',
    t2: 'Team B',
    st: 1,
    // In der Praxis liefert die API hier 0/2 – das Feld wird ignoriert.
    mdst: 0,
    // `tp` = KARRIERE-Gesamtpunktzahl, NICHT Saisonpunkte. Die Crossing-
    // Erkennung ignoriert es absichtlich – hier bewusst groß gewählt, um
    // genau das in Tests abzusichern.
    tp: 9999,
  );
}

SeasonPerformance _season(String sid, List<MatchPerformance> ph) {
  return SeasonPerformance(
    sid: sid,
    ti: 'Saison $sid',
    n: 'Bundesliga',
    ph: ph,
  );
}

ManagerTransferHistoryEntry _transfer({
  required String playerId,
  required int type,
  required DateTime ts,
  String name = 'Testspieler',
}) {
  return ManagerTransferHistoryEntry(
    id: 't-$playerId-$type-${ts.millisecondsSinceEpoch}',
    leagueId: 'league1',
    managerId: 'manager1',
    managerName: 'Manager',
    playerId: playerId,
    playerName: name,
    price: 1000000,
    transferType: type,
    timestamp: ts,
  );
}

int _daysSinceEpoch(DateTime dt) => dt.difference(DateTime.utc(1970)).inDays;

void main() {
  final seasonStart = DateTime.utc(2026, 8, 21);
  final now = DateTime.utc(2026, 9, 20);
  final service = AutoSaleBudgetService();

  group('AutoSaleBudgetService.ownershipPeriods', () {
    test('Kauf + Verkauf ergeben einen geschlossenen Besitz-Zeitraum', () {
      final periods = service.ownershipPeriods(
        transfers: [
          _transfer(
            playerId: 'p1',
            type: 1,
            ts: seasonStart.add(const Duration(days: 1)),
          ),
          _transfer(
            playerId: 'p1',
            type: 2,
            ts: seasonStart.add(const Duration(days: 10)),
          ),
        ],
        seasonStart: seasonStart,
      );

      expect(periods, hasLength(1));
      expect(periods.first.playerId, 'p1');
      expect(periods.first.start, seasonStart.add(const Duration(days: 1)));
      expect(periods.first.end, seasonStart.add(const Duration(days: 10)));
    });

    test('Verkauf ohne Kauf (Initialkader) beginnt zum Saisonstart', () {
      final periods = service.ownershipPeriods(
        transfers: [
          _transfer(
            playerId: 'p1',
            type: 2,
            ts: seasonStart.add(const Duration(days: 10)),
          ),
        ],
        seasonStart: seasonStart,
      );

      expect(periods, hasLength(1));
      expect(periods.first.start, seasonStart);
      expect(periods.first.end, seasonStart.add(const Duration(days: 10)));
    });

    test('Offener Kauf ohne Verkauf ist bis heute im Besitz', () {
      final periods = service.ownershipPeriods(
        transfers: [
          _transfer(
            playerId: 'p1',
            type: 1,
            ts: seasonStart.add(const Duration(days: 2)),
          ),
        ],
        seasonStart: seasonStart,
      );

      expect(periods, hasLength(1));
      expect(periods.first.end, isNull);
      expect(periods.first.covers(DateTime.utc(2026, 9, 30)), isTrue);
    });

    test('Andere Transfer-Typen werden ignoriert', () {
      final periods = service.ownershipPeriods(
        transfers: [
          _transfer(
            playerId: 'p1',
            type: 5,
            ts: seasonStart.add(const Duration(days: 2)),
          ),
        ],
        seasonStart: seasonStart,
      );

      expect(periods, isEmpty);
    });

    test('Wiederverkauf nach Rückkauf erzeugt zwei Zeiträume', () {
      final periods = service.ownershipPeriods(
        transfers: [
          _transfer(
            playerId: 'p1',
            type: 1,
            ts: seasonStart.add(const Duration(days: 1)),
          ),
          _transfer(
            playerId: 'p1',
            type: 2,
            ts: seasonStart.add(const Duration(days: 5)),
          ),
          _transfer(
            playerId: 'p1',
            type: 1,
            ts: seasonStart.add(const Duration(days: 8)),
          ),
        ],
        seasonStart: seasonStart,
      );

      expect(periods, hasLength(2));
      expect(periods.last.end, isNull);
    });
  });

  group('AutoSaleBudgetService.mergeLineupOwnership', () {
    test(
      'ergänzt Zulostung-Spieler ohne Transfer-Eintrag (Besitz ab Saisonstart)',
      () {
        final merged = service.mergeLineupOwnership(
          historyPeriods: const [],
          lineupsByMatchday: {
            1: {'p1', 'p2'},
            2: {'p1', 'p3'},
          },
          seasonStart: seasonStart,
        );

        final ids = merged.map((p) => p.playerId).toSet();
        expect(ids, containsAll(['p1', 'p2', 'p3']));
        for (final period in merged) {
          expect(period.start, seasonStart);
          expect(period.end, isNull);
        }
      },
    );

    test('überschreibt KEINE bestehenden Historie-Zeiträume', () {
      final history = [
        OwnershipPeriod(
          playerId: 'p1',
          playerName: 'Kaufspieler',
          start: seasonStart.add(const Duration(days: 1)),
          end: seasonStart.add(const Duration(days: 5)),
        ),
      ];

      final merged = service.mergeLineupOwnership(
        historyPeriods: history,
        lineupsByMatchday: {
          1: {'p1'},
          2: {'p1', 'p9'},
        },
        seasonStart: seasonStart,
      );

      final p1Periods = merged.where((p) => p.playerId == 'p1').toList();
      expect(p1Periods, hasLength(1)); // kein Duplikat
      expect(p1Periods.first.start, seasonStart.add(const Duration(days: 1)));
      expect(merged.where((p) => p.playerId == 'p9'), hasLength(1));
    });

    test('leere Lineups liefern nur die Historie-Zeiträume', () {
      final history = [
        OwnershipPeriod(playerId: 'p1', playerName: 'X', start: seasonStart),
      ];

      final merged = service.mergeLineupOwnership(
        historyPeriods: history,
        lineupsByMatchday: {},
        seasonStart: seasonStart,
      );

      expect(merged, hasLength(1));
    });
  });

  group('AutoSaleBudgetService.currentSeasonPerformance', () {
    test('wählt die Saison mit der höchsten sid (nicht die erste!)', () {
      final performance = PlayerPerformanceResponse(
        it: [
          _season('5', [_perf(1, _day1Start, p: 5000)]),
          _season('28', [_perf(1, _day1Start, p: 10)]),
        ],
      );

      final season = service.currentSeasonPerformance(performance);
      expect(season!.sid, '28');
    });

    test('Fallback: letzter Eintrag, wenn sid fehlt', () {
      final performance = PlayerPerformanceResponse(
        it: [
          SeasonPerformance(ti: 'alt', n: 'Bundesliga', ph: const []),
          SeasonPerformance(ti: 'neu', n: 'Bundesliga', ph: const []),
        ],
      );

      final season = service.currentSeasonPerformance(performance);
      expect(season!.ti, 'neu');
    });

    test('leere Liste liefert null', () {
      expect(
        service.currentSeasonPerformance(
          const PlayerPerformanceResponse(it: []),
        ),
        isNull,
      );
    });
  });

  group('AutoSaleBudgetService.crossingMatchday', () {
    test(
      'findet den ERSTEN Spieltag, an dem die kumulierte Saison-Punktzahl die Schwelle erreicht',
      () {
        final ph = [
          _perf(1, _day1Start, p: 30),
          _perf(2, _day2Start, p: 25),
          _perf(3, _day3Start, p: 40),
        ];

        // Tag 2: 55 Punkte (unter Schwelle), Tag 3: 95 Punkte → Crossing
        final crossing = service.crossingMatchday(ph, 60);

        expect(crossing, isNotNull);
        expect(crossing!.day, 3);
        expect(crossing.points, 95);
      },
    );

    test('ignoriert tp (das ist die KARRIERE-Gesamtpunktzahl!)', () {
      // p-Summe bleibt weit unter der Schwelle, tp (=9999) wäre längst drüber.
      final ph = [_perf(1, _day1Start, p: 30), _perf(2, _day2Start, p: 25)];

      expect(service.crossingMatchday(ph, 250), isNull);
    });

    test('Spieltage ohne p (nicht gespielt) zählen 0 Punkte', () {
      final ph = [
        _perf(1, _day1Start, p: 200),
        _perf(2, _day2Start), // ohne p → 0 Punkte
        _perf(3, _day3Start, p: 60),
      ];

      final crossing = service.crossingMatchday(ph, 250);
      expect(crossing!.day, 3);
      expect(crossing.points, 260);
    });

    test('liefert null, wenn die Schwelle nie erreicht wird', () {
      final ph = [_perf(1, _day1Start, p: 30), _perf(2, _day2Start, p: 25)];

      expect(service.crossingMatchday(ph, 250), isNull);
    });

    test('ist robust gegenüber unsortierten und leeren Listen', () {
      final ph = [_perf(2, _day2Start, p: 200), _perf(1, _day1Start, p: 100)];

      final crossing = service.crossingMatchday(ph, 250);
      expect(crossing!.day, 2);

      expect(service.crossingMatchday([], 250), isNull);
    });
  });

  group('AutoSaleBudgetService.matchdayEnd', () {
    test('Ende des Spieltags = Kickoff des Folgespieltags', () {
      final ph = [
        _perf(1, _day1Start),
        _perf(2, _day2Start),
        _perf(3, _day3Start),
      ];

      expect(service.matchdayEnd(day: 1, ph: ph, fallback: now), _day2Start);
    });

    test('letzter bekannter Spieltag nutzt den Fallback', () {
      final ph = [_perf(3, _day3Start)];

      expect(service.matchdayEnd(day: 3, ph: ph, fallback: now), now);
    });

    test('nicht parsebare md-Werte werden übersprungen', () {
      final broken = MatchPerformance(
        day: 2,
        cur: false,
        md: 'kein-datum',
        t1: 'A',
        t2: 'B',
        st: 1,
        mdst: 0,
      );

      expect(
        service.matchdayEnd(
          day: 1,
          ph: [broken, _perf(3, _day3Start)],
          fallback: now,
        ),
        _day3Start,
      );
    });
  });

  group('AutoSaleBudgetService.marketValueAt', () {
    test(
      'liefert den letzten bekannten Marktwert am oder vor dem Stichtag',
      () {
        final values = [
          MarketValueEntry(dt: _daysSinceEpoch(_day1Start), mv: 10000000),
          MarketValueEntry(dt: _daysSinceEpoch(_day3Start), mv: 20000000),
        ];

        expect(service.marketValueAt(values, _day2Start), 10000000);
        expect(
          service.marketValueAt(values, DateTime.utc(2026, 12, 31)),
          20000000,
        );
      },
    );

    test('liefert null, wenn kein Eintrag vor dem Stichtag liegt', () {
      final values = [
        MarketValueEntry(
          dt: _daysSinceEpoch(DateTime.utc(2026, 12, 31)),
          mv: 10000000,
        ),
      ];

      expect(service.marketValueAt(values, _day1Start), isNull);
    });
  });

  group('AutoSaleBudgetService.computeAutoSales', () {
    /// Aktuelle Saison (sid 28): ST 1–3, Crossing bei ST 3 (280 Punkte).
    final currentSeason = _season('28', [
      _perf(1, _day1Start, p: 120),
      _perf(2, _day2Start, p: 100),
      _perf(3, _day3Start, p: 60),
    ]);

    /// Alte Saison mit riesigen Punktzahlen – darf NICHT ausgewertet werden.
    final oldSeason = _season('5', [
      _perf(1, DateTime.utc(2013, 8, 24), p: 5000),
    ]);

    final performance = PlayerPerformanceResponse(
      it: [oldSeason, currentSeason],
    );

    List<MarketValueEntry> mvHistory({required int mvAtDay2, int? mvAtDay3}) {
      final values = [
        MarketValueEntry(dt: _daysSinceEpoch(_day2Start), mv: mvAtDay2),
      ];
      if (mvAtDay3 != null) {
        values.add(
          MarketValueEntry(dt: _daysSinceEpoch(_day3Start), mv: mvAtDay3),
        );
      }
      return values;
    }

    test('addiert den Marktwert zum Spieltag des Crossings', () {
      // Crossing bei ST 3 (280 Punkte) → Verkauf zum Ende von ST 3
      // (Fallback "now", da kein ST 4 bekannt).
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart,
          ),
        ],
        performanceByPlayer: {'p1': performance},
        marketValuesByPlayer: {
          'p1': mvHistory(mvAtDay2: 15000000, mvAtDay3: 18000000),
        },
        now: now,
      );

      expect(computation.events, hasLength(1));
      expect(computation.events.first.matchday, 3);
      expect(computation.events.first.points, 280);
      expect(computation.events.first.marketValue, 18000000);
      expect(computation.totalIncome, 18000000);
    });

    test(
      'alte Saisons mit hohen Karriere-Punkten lösen KEINEN Auto-Verkauf aus',
      () {
        // Ohne die Saison-Auswahl (Bug: it.first) würde die Saison 2013 mit
        // 5000 Punkten sofort ein Event auslösen.
        final onlyOldSeason = PlayerPerformanceResponse(it: [oldSeason]);

        final computation = service.computeAutoSales(
          threshold: 250,
          seasonStart: seasonStart,
          periods: [
            OwnershipPeriod(
              playerId: 'p1',
              playerName: 'Stürmer',
              start: seasonStart,
            ),
          ],
          performanceByPlayer: {'p1': onlyOldSeason},
          marketValuesByPlayer: {'p1': mvHistory(mvAtDay2: 15000000)},
          now: now,
        );

        expect(computation.events, isEmpty);
        expect(computation.totalIncome, 0);
      },
    );

    test(
      'nutzt den MV des Folgespieltags, wenn der Crossing-Spieltag nicht der letzte ist',
      () {
        // Crossing bereits bei ST 1 (300 Punkte) → Sale instant = Kickoff ST 2.
        final crossingAtDay1 = _season('28', [
          _perf(1, _day1Start, p: 300),
          _perf(2, _day2Start, p: 0),
          _perf(3, _day3Start, p: 0),
        ]);

        final computation = service.computeAutoSales(
          threshold: 250,
          seasonStart: seasonStart,
          periods: [
            OwnershipPeriod(
              playerId: 'p1',
              playerName: 'Stürmer',
              start: seasonStart,
            ),
          ],
          performanceByPlayer: {
            'p1': PlayerPerformanceResponse(it: [crossingAtDay1]),
          },
          marketValuesByPlayer: {
            'p1': [
              MarketValueEntry(dt: _daysSinceEpoch(_day1Start), mv: 10000000),
              MarketValueEntry(dt: _daysSinceEpoch(_day2Start), mv: 15000000),
              MarketValueEntry(dt: _daysSinceEpoch(_day3Start), mv: 18000000),
            ],
          },
          now: now,
        );

        // Sale instant = Kickoff ST 2 → MV von ST 2 (der mit der finalen
        // Berechnung von ST 1 festgeschriebene Wert).
        expect(computation.events, hasLength(1));
        expect(computation.events.first.matchday, 1);
        expect(computation.events.first.marketValue, 15000000);
      },
    );

    test('KEIN Event, wenn der Kauf erst NACH dem Crossing erfolgte', () {
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: now.add(const Duration(days: 1)), // Kauf nach ST 3
          ),
        ],
        performanceByPlayer: {'p1': performance},
        marketValuesByPlayer: {'p1': mvHistory(mvAtDay2: 15000000)},
        now: now,
      );

      expect(computation.events, isEmpty);
      expect(computation.totalIncome, 0);
    });

    test(
      'KEIN Event, wenn der Spieler vor dem Spieltag-Ende verkauft wurde',
      () {
        final computation = service.computeAutoSales(
          threshold: 250,
          seasonStart: seasonStart,
          periods: [
            OwnershipPeriod(
              playerId: 'p1',
              playerName: 'Stürmer',
              start: seasonStart,
              end: DateTime.utc(2026, 9, 1), // Verkauf vor dem ST-3-Ende
            ),
          ],
          performanceByPlayer: {'p1': performance},
          marketValuesByPlayer: {'p1': mvHistory(mvAtDay2: 15000000)},
          now: now,
        );

        expect(computation.events, isEmpty);
      },
    );

    test('fehlende MV-Historie erzeugt uncertain-Event mit Marktwert 0', () {
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart,
          ),
        ],
        performanceByPlayer: {'p1': performance},
        marketValuesByPlayer: {'p1': const []},
        now: now,
      );

      expect(computation.events, hasLength(1));
      expect(computation.events.first.uncertain, isTrue);
      expect(computation.events.first.marketValue, 0);
      expect(computation.totalIncome, 0);
    });

    test('mehrere Zeiträume desselben Spielers erzeugen nur EIN Event', () {
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart,
          ),
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart.add(const Duration(days: 30)),
          ),
        ],
        performanceByPlayer: {'p1': performance},
        marketValuesByPlayer: {'p1': mvHistory(mvAtDay2: 15000000)},
        now: now,
      );

      expect(computation.events, hasLength(1));
    });

    test('mehrere Spieler werden summiert und nach Spieltag sortiert', () {
      final performance2 = PlayerPerformanceResponse(
        it: [
          _season('28', [_perf(2, _day2Start, p: 260)]),
        ],
      );

      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart,
          ),
          OwnershipPeriod(
            playerId: 'p2',
            playerName: 'Mittelfeld',
            start: seasonStart,
          ),
        ],
        performanceByPlayer: {'p1': performance, 'p2': performance2},
        marketValuesByPlayer: {
          'p1': mvHistory(mvAtDay2: 15000000),
          'p2': mvHistory(mvAtDay2: 9000000),
        },
        now: now,
      );

      expect(computation.events, hasLength(2));
      expect(computation.events.first.playerId, 'p2'); // ST 2 vor ST 3
      expect(computation.events.last.playerId, 'p1');
      expect(
        computation.totalIncome,
        computation.events.fold<int>(0, (s, e) => s + e.marketValue),
      );
    });

    test('fehlende Performance-Daten überspringen den Spieler', () {
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart,
          ),
        ],
        performanceByPlayer: {},
        marketValuesByPlayer: {'p1': mvHistory(mvAtDay2: 15000000)},
        now: now,
      );

      expect(computation.events, isEmpty);
    });
  });
}
