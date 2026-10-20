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
    test('findet den ERSTEN Spieltag, an dem die Saison-Punktzahl die Schwelle erreicht', () {
      // `p` ist die kumulierte Saison-Gesamtpunktzahl zum Spieltag.
      final ph = [
        _perf(1, _day1Start, p: 30),
        _perf(2, _day2Start, p: 55),
        _perf(3, _day3Start, p: 95),
      ];

      // Tag 2: 55 Punkte (unter Schwelle), Tag 3: 95 Punkte → Crossing
      final crossing = service.crossingMatchday(ph, 60);

      expect(crossing, isNotNull);
      expect(crossing!.day, 3);
      expect(crossing.points, 95);
    });

    test(
      'summiert p NICHT (das wäre die mehrfach gezählte Gesamtpunktzahl)',
      () {
        // Würde p summiert, wäre die Laufsumme nach ST 2 bereits 85 – bei einer
        // Schwelle von 60 fälschlich ST 2 statt ST 3.
        final ph = [
          _perf(1, _day1Start, p: 30),
          _perf(2, _day2Start, p: 55),
          _perf(3, _day3Start, p: 95),
        ];

        final crossing = service.crossingMatchday(ph, 60);

        expect(crossing!.day, 3);
      },
    );

    test('ignoriert tp (das ist die KARRIERE-Gesamtpunktzahl!)', () {
      // p bleibt kumuliert weit unter der Schwelle, tp (=9999) wäre längst drüber.
      final ph = [_perf(1, _day1Start, p: 30), _perf(2, _day2Start, p: 55)];

      expect(service.crossingMatchday(ph, 250), isNull);
    });

    test('Spieltage ohne p (nicht gespielt) werden übersprungen', () {
      final ph = [
        _perf(1, _day1Start, p: 200),
        _perf(2, _day2Start), // ohne p → kein Crossing-Kandidat
        _perf(3, _day3Start, p: 260),
      ];

      final crossing = service.crossingMatchday(ph, 250);
      expect(crossing!.day, 3);
      expect(crossing.points, 260);
    });

    test('liefert null, wenn die Schwelle nie erreicht wird', () {
      final ph = [_perf(1, _day1Start, p: 30), _perf(2, _day2Start, p: 55)];

      expect(service.crossingMatchday(ph, 250), isNull);
    });

    test('ist robust gegenüber unsortierten und leeren Listen', () {
      final ph = [_perf(2, _day2Start, p: 250), _perf(1, _day1Start, p: 100)];

      final crossing = service.crossingMatchday(ph, 250);
      expect(crossing!.day, 2);
      expect(crossing.points, 250);

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

  group('AutoSaleBudgetService.matchdayKickoff', () {
    test('liefert den Anpfiff des Spieltags', () {
      final ph = [_perf(1, _day1Start), _perf(2, _day2Start)];

      expect(service.matchdayKickoff(ph, 2), _day2Start);
      expect(service.matchdayKickoff(ph, 1), _day1Start);
    });

    test('null bei fehlendem oder unparsebarem md', () {
      final broken = MatchPerformance(
        day: 1,
        cur: false,
        md: 'kein-datum',
        t1: 'A',
        t2: 'B',
        st: 1,
        mdst: 0,
      );

      expect(service.matchdayKickoff([broken], 1), isNull);
      expect(service.matchdayKickoff([_perf(2, _day2Start)], 1), isNull);
      expect(service.matchdayKickoff([], 1), isNull);
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

  group('AutoSaleBudgetService.saleMarketValue', () {
    // Feldbeobachtung (Caci): Am 5. Spieltag für 9,6 Mio verkauft – die
    // Historie enthält den Stand VOR dem Spieltag (11,0 Mio), den mit der
    // finalen Berechnung festgeschriebenen Wert (9,6 Mio) und spätere Stände.
    final kickoff = DateTime.utc(2026, 10, 11, 15, 30); // Anpfiff ST 5
    final caciHistory = [
      // dt = Tage seit 1970 (normalisiert auf 00:00 UTC des Tages)
      MarketValueEntry(
        dt: _daysSinceEpoch(DateTime.utc(2026, 10, 11)),
        mv: 11000000,
      ), // "Wert vom Start des Spieltags"
      MarketValueEntry(
        dt: _daysSinceEpoch(DateTime.utc(2026, 10, 12)),
        mv: 9600000,
      ), // festgeschrieben mit der finalen Berechnung
      MarketValueEntry(
        dt: _daysSinceEpoch(DateTime.utc(2026, 10, 18)),
        mv: 11000000,
      ), // später wieder gestiegen
    ];

    test('liefert den mit der Verkaufs-Berechnung festgeschriebenen Wert', () {
      expect(
        service.saleMarketValue(
          caciHistory,
          matchdayKickoff: kickoff,
          now: DateTime.utc(2026, 10, 18),
        ),
        9600000,
      );
    });

    test('auch bei späterer Erholung des Marktwerts (kein "jetzt"-Wert)', () {
      // Ohne Folgespieltag in `ph` nutzte die alte Logik den Fallback "jetzt"
      // und zeigte den AKTUELLEN Stand (11,0 Mio) statt des Verkaufswerts.
      expect(
        service.saleMarketValue(
          caciHistory,
          matchdayKickoff: kickoff,
          now: DateTime.utc(2026, 10, 18), // Marktwert wieder bei 11,0 Mio
        ),
        9600000,
      );
    });

    test('greift auch bei grober Historie (Eintrag erst Tage später)', () {
      // Sparse-Historie: der Verkaufswert erscheint erst mit dem nächsten
      // Eintrag – deutlich NACH dem Kickoff des Folgespieltags (die alte
      // "letzter Eintrag ≤ Stichtag"-Logik lieferte 11,0 Mio).
      final sparse = [
        MarketValueEntry(
          dt: _daysSinceEpoch(DateTime.utc(2026, 10, 11)),
          mv: 11000000,
        ),
        MarketValueEntry(
          dt: _daysSinceEpoch(DateTime.utc(2026, 10, 18)),
          mv: 9600000,
        ),
      ];

      expect(
        service.saleMarketValue(
          sparse,
          matchdayKickoff: kickoff,
          now: DateTime.utc(2026, 10, 20),
        ),
        9600000,
      );
    });

    test(
      'Fallback: laufender Spieltag ohne Folge-Eintrag → aktueller Stand',
      () {
        // Verkauf gerade erst erfolgt, die Historie hat noch keinen Eintrag ab
        // dem Verkaufstag → bester verfügbarer Wert = aktueller Stand.
        expect(
          service.saleMarketValue(
            [
              MarketValueEntry(
                dt: _daysSinceEpoch(DateTime.utc(2026, 10, 11)),
                mv: 11000000,
              ),
            ],
            matchdayKickoff: kickoff,
            now: DateTime.utc(2026, 10, 12),
          ),
          11000000,
        );
      },
    );

    test('leere Historie liefert null', () {
      expect(
        service.saleMarketValue(
          const [],
          matchdayKickoff: kickoff,
          now: DateTime.utc(2026, 10, 12),
        ),
        isNull,
      );
    });
  });

  group('AutoSaleBudgetService.computeAutoSales', () {
    /// Aktuelle Saison (sid 28): ST 1–3, Crossing bei ST 3 (280 Punkte).
    /// `p` ist die kumulierte Saison-Gesamtpunktzahl zum Spieltag.
    final currentSeason = _season('28', [
      _perf(1, _day1Start, p: 120),
      _perf(2, _day2Start, p: 220),
      _perf(3, _day3Start, p: 280),
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

    test('Regression Caci: Verkaufswert statt Start-Spieltags-Wert', () {
      // Feldbeobachtung: Crossing an ST 5 (Anpfiff 11.10.), danach keine
      // Spiele mehr in `ph`. Historie: 11,0 Mio (Stand Start ST 5) → 9,6 Mio
      // (festgeschrieben mit der finalen Berechnung = tatsächliche Einnahme)
      // → 11,0 Mio (Erholung bis heute). Die alte Logik zeigte den Fallback-
      // "jetzt"-Wert (11,0 Mio), angezeigt werden muss 9,6 Mio.
      final caciKickoff = DateTime.utc(2026, 10, 11, 15, 30);
      final today = DateTime.utc(2026, 10, 18);

      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Caci',
            start: seasonStart,
          ),
        ],
        performanceByPlayer: {
          'p1': PlayerPerformanceResponse(
            it: [
              _season('28', [
                _perf(4, DateTime.utc(2026, 10, 4, 15, 30), p: 220),
                _perf(5, caciKickoff, p: 260),
              ]),
            ],
          ),
        },
        marketValuesByPlayer: {
          'p1': [
            MarketValueEntry(
              dt: _daysSinceEpoch(DateTime.utc(2026, 10, 11)),
              mv: 11000000,
            ),
            MarketValueEntry(
              dt: _daysSinceEpoch(DateTime.utc(2026, 10, 12)),
              mv: 9600000,
            ),
            MarketValueEntry(
              dt: _daysSinceEpoch(DateTime.utc(2026, 10, 18)),
              mv: 11000000,
            ),
          ],
        },
        now: today,
      );

      expect(computation.events, hasLength(1));
      expect(computation.events.first.matchday, 5);
      expect(computation.events.first.marketValue, 9600000);
      expect(computation.totalIncome, 9600000);
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

    test('nutzt den MV des Folgespieltags, wenn der Crossing-Spieltag nicht der letzte ist', () {
      // Crossing bereits bei ST 1 (300 Punkte) → Sale instant = Kickoff ST 2.
      final crossingAtDay1 = _season('28', [
        _perf(1, _day1Start, p: 300),
        _perf(2, _day2Start, p: 300),
        _perf(3, _day3Start, p: 300),
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
    });

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

    test('KEIN Event für Rückkauf vom Markt nach dem Auto-Verkauf', () {
      // Crossing bei ST 3 (12.09) – letzter bekannter Spieltag, der Verkauf
      // erfolgte also mit der finalen Berechnung von ST 3. Der Spieler wurde
      // am 15.09 vom Markt gekauft (Rückkauf NACH dem Auto-Verkauf) und ist
      // jetzt im Kader – beim Crossing-Spieltag hatte man ihn aber noch
      // nicht. Vor dem Fix wurde der Besitz fälschlich erst zum Fallback-
      // Instant "now" (20.09) geprüft und der Rückkauf bekam die Einnahme
      // zugeschrieben.
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: _day3Start.add(const Duration(days: 3)), // Kauf nach ST 3
          ),
        ],
        performanceByPlayer: {'p1': performance},
        marketValuesByPlayer: {
          'p1': mvHistory(mvAtDay2: 15000000, mvAtDay3: 18000000),
        },
        now: now,
      );

      expect(computation.events, isEmpty);
      expect(computation.totalIncome, 0);
    });

    test(
      'KEIN Event für Rückkauf zwischen Crossing-Spieltag und Folgespieltag',
      () {
        // Crossing bei ST 1 (22.08), Verkauf mit der finalen Berechnung von
        // ST 1. Der Rückkauf vom Markt erfolgte am 24.08 – vor dem Fix wurde
        // der Besitz erst zum Kickoff von ST 2 (29.08) geprüft und der
        // Rückkauf fälschlich als Besitz beim Verkauf gewertet.
        final crossingAtDay1 = _season('28', [
          _perf(1, _day1Start, p: 300),
          _perf(2, _day2Start, p: 300),
          _perf(3, _day3Start, p: 300),
        ]);

        final computation = service.computeAutoSales(
          threshold: 250,
          seasonStart: seasonStart,
          periods: [
            OwnershipPeriod(
              playerId: 'p1',
              playerName: 'Stürmer',
              start: _day1Start.add(const Duration(days: 2)), // Kauf nach ST 1
            ),
          ],
          performanceByPlayer: {
            'p1': PlayerPerformanceResponse(it: [crossingAtDay1]),
          },
          marketValuesByPlayer: {
            'p1': [
              MarketValueEntry(dt: _daysSinceEpoch(_day1Start), mv: 10000000),
              MarketValueEntry(dt: _daysSinceEpoch(_day2Start), mv: 15000000),
            ],
          },
          now: now,
        );

        expect(computation.events, isEmpty);
        expect(computation.totalIncome, 0);
      },
    );

    test('Event auch bei ZWEI Besitz-Phasen, wenn nur die ZWEITE den Verkauf abdeckt', () {
      // Feldfall-Form: Initialkader → manueller Verkauf 01.09 → Rückkauf
      // 03.09. Das Crossing (ST 3, 12.09) liegt ausschließlich in der
      // ZWEITEN Besitz-Phase. Vor dem Fix wurde nur die ERSTE Periode
      // geprüft (seenPlayers-Gate vor den Covers-Prüfungen) und das Event
      // still verworfen.
      final computation = service.computeAutoSales(
        threshold: 250,
        seasonStart: seasonStart,
        periods: [
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: seasonStart,
            end: DateTime.utc(2026, 9, 1),
          ),
          OwnershipPeriod(
            playerId: 'p1',
            playerName: 'Stürmer',
            start: DateTime.utc(2026, 9, 3),
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
    });

    test(
      'Event für Rückkauf eines bereits über der Schwelle liegenden Spielers',
      () {
        // Feldbeobachtung (Kickbase verkauft Rückkäufe erneut): Spieler am
        // 09.09. vom Markt gekauft, als er bereits 260 Saisonpunkte hatte
        // (Crossing also VOR dem Kauf). Mit der Punkt-Aktualisierung von
        // ST 3 (19.09., 310 P.) wurde er erneut automatisch verkauft.
        // Vor dem Fix verwarf die Crossing-Kickoff-Prüfung das Event, weil
        // das Crossing (ST 1, 22.08.) vor dem Kauf lag.
        final rebuySeason = _season('28', [
          _perf(1, _day1Start, p: 260), // Crossing vor dem Kauf (09.09.)
          _perf(2, _day3Start), // nicht gespielt (p null) → keine Aktualis.
          _perf(3, DateTime.utc(2026, 9, 19, 15, 30), p: 310),
        ]);

        final computation = service.computeAutoSales(
          threshold: 250,
          seasonStart: seasonStart,
          periods: [
            OwnershipPeriod(
              playerId: 'p1',
              playerName: 'Stürmer',
              start: DateTime.utc(2026, 9, 9),
            ),
          ],
          performanceByPlayer: {
            'p1': PlayerPerformanceResponse(it: [rebuySeason]),
          },
          marketValuesByPlayer: {
            'p1': mvHistory(mvAtDay2: 15000000, mvAtDay3: 18000000),
          },
          now: now,
        );

        expect(computation.events, hasLength(1));
        expect(computation.events.first.matchday, 3);
        expect(computation.events.first.points, 310);
        expect(computation.events.first.marketValue, 18000000);
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
