import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/ligainsider_model.dart';
import 'package:kickbasekumpel/data/models/lineup_model.dart';
import 'package:kickbasekumpel/data/models/optimal_lineup_model.dart';
import 'package:kickbasekumpel/data/services/deterministic_recommendation_service.dart';
import 'package:kickbasekumpel/data/services/lineup_recommendation_service.dart';

void main() {
  const service = LineupRecommendationService();
  // 1-1-1 erzwingt eine direkte Entscheidung um einen Mittelfeld-Platz.
  const singleMidfield = Formation(
    name: 'Test-1-1-1',
    defenders: 1,
    midfielders: 1,
    forwards: 1,
  );

  LineupPlayer buildPlayer({
    String id = 'p1',
    String name = 'Max Mustermann',
    int position = 3,
    String teamId = 'team-1',
    int averagePoints = 6,
    int matchDayStatus = 0,
    int lineupOrder = 0,
    List<PerformanceHistory>? performanceHistory,
  }) {
    return LineupPlayer(
      id: id,
      name: name,
      position: position,
      teamId: teamId,
      averagePoints: averagePoints,
      totalPoints: 100,
      matchDayStatus: matchDayStatus,
      lineupOrder: lineupOrder,
      lastTotalPoints: 0,
      hasToday: false,
      performanceHistory: performanceHistory,
    );
  }

  List<PerformanceHistory> history(List<int> points) => [
    for (final p in points) PerformanceHistory(points: p, hasPlayed: true),
  ];

  group('LineupRecommendationService', () {
    test('Form schlägt Saison-Durchschnitt', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(
            id: 'a',
            name: 'Anton Formstark',
            averagePoints: 3,
            performanceHistory: history([10, 10, 10]),
          ),
          buildPlayer(
            id: 'b',
            name: 'Bert Formschwach',
            averagePoints: 8,
            performanceHistory: history([1, 1, 1]),
          ),
        ],
        formations: const [singleMidfield],
      );

      final starterIds = result.starters.map((p) => p.id).toList();
      expect(starterIds, contains('a'));
      expect(starterIds, isNot(contains('b')));
      expect(result.scores['a']!.form, closeTo(10, 0.01));
    });

    test('leichter Heim-Gegner schlägt harten Auswärts-Gegner', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'mid', name: 'Mittelfeld', position: 3),
          buildPlayer(
            id: 'fa',
            name: 'Franz Heimvorteil',
            position: 4,
            teamId: 'team-easy',
          ),
          buildPlayer(
            id: 'fb',
            name: 'Fritz Auswaerts',
            position: 4,
            teamId: 'team-hard',
          ),
        ],
        formations: const [singleMidfield],
        fixturesByTeamKey: {
          'team-easy': const [
            FixtureInfo(
              opponentName: 'FC Schlapp',
              opponentTablePosition: 18,
              isHomeGame: true,
            ),
          ],
          'team-hard': const [
            FixtureInfo(
              opponentName: 'FC Top',
              opponentTablePosition: 1,
              isHomeGame: false,
            ),
          ],
        },
      );

      final starterIds = result.starters.map((p) => p.id).toList();
      expect(starterIds, contains('fa'));
      expect(starterIds, isNot(contains('fb')));
      expect(result.scores['fa']!.summary, contains('Heimspiel'));
      expect(result.scores['fa']!.summary, contains('Platz 18'));
    });

    test('verletzter Spieler wird nie empfohlen', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(id: 'm1', name: 'Mittelfeld Eins'),
          buildPlayer(id: 'm2', name: 'Mittelfeld Zwei', averagePoints: 4),
          buildPlayer(
            id: 'verletzt',
            name: 'Marco Superstar',
            averagePoints: 30,
            matchDayStatus: 1,
            performanceHistory: history([30, 30, 30]),
          ),
        ],
        formations: const [singleMidfield],
      );

      final starterIds = result.starters.map((p) => p.id).toList();
      expect(starterIds, isNot(contains('verletzt')));
      expect(starterIds, contains('m1'));
      expect(result.scores['verletzt']!.availabilityLabel, isNotNull);
      expect(
        result.scores['verletzt']!.summary,
        contains('Verfügbarkeitsrisiko'),
      );
    });

    test('Ligainsider-Bank-Status schließt quasi aus', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(id: 'a', name: 'Anton Ersatz'),
          buildPlayer(id: 'b', name: 'Bert Stammspieler'),
        ],
        formations: const [singleMidfield],
        ligainsiderStatusByPlayerId: {
          'a': LigainsiderPlayerStatus.bench,
          'b': LigainsiderPlayerStatus.likelyStart,
        },
      );

      final starterIds = result.starters.map((p) => p.id).toList();
      expect(starterIds, contains('b'));
      expect(starterIds, isNot(contains('a')));
      expect(result.scores['a']!.availabilityLabel, isNotNull);
      expect(result.scores['a']!.summary, contains('Bank'));
      expect(result.scores['b']!.summary, contains('S11'));
    });

    test('ohne S11-Platz (out) ist quasi K.O. – trotz Top-Form', () {
      // Pinned: Ligainsider liefert nur S11 + Alternativen. Wer dort fehlt,
      // ist nicht in der erwarteten Startelf – das ist ein Ausschlusskriterium
      // und kein neutrales Signal.
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(
            id: 'nichtS11',
            name: 'Kalle Bank',
            averagePoints: 30,
            performanceHistory: history([30, 30, 30]),
          ),
          buildPlayer(id: 's11', name: 'Sven S11', averagePoints: 6),
        ],
        formations: const [singleMidfield],
        ligainsiderStatusByPlayerId: {
          'nichtS11': LigainsiderPlayerStatus.out,
          's11': LigainsiderPlayerStatus.likelyStart,
        },
      );

      final starterIds = result.starters.map((p) => p.id).toList();
      expect(starterIds, contains('s11'));
      expect(starterIds, isNot(contains('nichtS11')));
      expect(result.scores['nichtS11']!.availabilityLabel, isNotNull);
    });

    test('Datenlücke: ohne S11-Abdeckung bleibt out neutral', () {
      // Wenn kaum ein Spieler bestätigt ist, taugt "nicht gefunden" nicht als
      // Ausschluss-Beweis (alte/partialle Ligainsider-Daten) – sonst landen
      // ALLE Spieler auf dem Ausschluss-Score.
      final result = service.recommend(
        squad: [
          buildPlayer(
            id: 'gk',
            name: 'Torwart',
            position: 1,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'def',
            name: 'Verteidiger',
            position: 2,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'st',
            name: 'Stuermer',
            position: 4,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'stark',
            name: 'Mario Stark',
            averagePoints: 45,
            performanceHistory: history([52, 50, 48]),
          ),
          buildPlayer(
            id: 'schwach',
            name: 'Mario Schwach',
            averagePoints: 20,
            performanceHistory: history([19, 18, 20]),
          ),
        ],
        formations: const [singleMidfield],
        // Nur "nicht gefunden" – keine einzige S11-Bestätigung.
        ligainsiderStatusByPlayerId: {
          for (final id in ['gk', 'def', 'st', 'stark', 'schwach'])
            id: LigainsiderPlayerStatus.out,
        },
      );

      // Kein Ausschluss, normale Bewertung – der Starke gewinnt.
      expect(result.scores['stark']!.availabilityLabel, isNull);
      expect(result.starters.map((p) => p.id), contains('stark'));
    });

    test('fehlende Ligainsider-Daten sind neutral', () {
      List<LineupPlayer> squad() => [
        buildPlayer(id: 'gk', name: 'Torwart', position: 1),
        buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
        buildPlayer(id: 'st', name: 'Stuermer', position: 4),
        buildPlayer(id: 'a', name: 'Anton Gleich'),
        buildPlayer(id: 'b', name: 'Bert Gleich'),
      ];

      final ohneDaten = service.recommend(
        squad: squad(),
        formations: const [singleMidfield],
      );

      // Gleiche Scores ohne Signal, deterministischer Tie-Break nach Name.
      expect(ohneDaten.scores['a']!.score, ohneDaten.scores['b']!.score);
      expect(ohneDaten.starters.map((p) => p.id), contains('a'));
    });

    test('empfohlene Startelf ist formation-legal mit genau einem Torwart', () {
      final result = service.recommend(
        squad: [
          buildPlayer(
            id: 'gk1',
            name: 'Torwart Stark',
            position: 1,
            averagePoints: 8,
          ),
          buildPlayer(
            id: 'gk2',
            name: 'Torwart Schwach',
            position: 1,
            averagePoints: 2,
          ),
          for (var i = 0; i < 6; i++)
            buildPlayer(
              id: 'd$i',
              name: 'Abwehr $i',
              position: 2,
              averagePoints: 5 + i,
            ),
          for (var i = 0; i < 6; i++)
            buildPlayer(
              id: 'm$i',
              name: 'Mittelfeld $i',
              position: 3,
              averagePoints: 5 + i,
            ),
          for (var i = 0; i < 4; i++)
            buildPlayer(
              id: 'f$i',
              name: 'Sturm $i',
              position: 4,
              averagePoints: 5 + i,
            ),
          buildPlayer(
            id: 'verletzt',
            name: 'Verletzter Topstuermer',
            position: 4,
            averagePoints: 30,
            matchDayStatus: 1,
            performanceHistory: history([30, 30, 30]),
          ),
        ],
      );

      expect(result.starters, hasLength(11));
      expect(result.isLegalFormation, isTrue);
      expect(result.starters.where((p) => p.position == 1), hasLength(1));
      expect(result.starters.firstWhere((p) => p.position == 1).id, 'gk1');
      expect(result.starters.map((p) => p.id), isNot(contains('verletzt')));

      final defenders = result.starters.where((p) => p.position == 2).length;
      final midfielders = result.starters.where((p) => p.position == 3).length;
      final forwards = result.starters.where((p) => p.position == 4).length;
      expect(
        Formation.allFormations.any(
          (f) =>
              f.defenders == defenders &&
              f.midfielders == midfielders &&
              f.forwards == forwards,
        ),
        isTrue,
        reason:
            '$defenders-$midfielders-$forwards ist keine bekannte Formation',
      );
    });

    test('Wechsel-Vorschlag gegenüber der aktuellen Aufstellung', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1, lineupOrder: 1),
          buildPlayer(id: 'def', name: 'Abwehr', position: 2, lineupOrder: 2),
          buildPlayer(id: 'st', name: 'Sturm', position: 4, lineupOrder: 3),
          buildPlayer(
            id: 'mid-alt',
            name: 'Mittelfeld Alt',
            lineupOrder: 4,
            averagePoints: 2,
            performanceHistory: history([1, 1, 1]),
          ),
          buildPlayer(
            id: 'mid-neu',
            name: 'Mittelfeld Neu',
            lineupOrder: 12,
            averagePoints: 9,
            performanceHistory: history([12, 12, 12]),
          ),
        ],
        formations: const [singleMidfield],
      );

      expect(result.swaps, hasLength(1));
      expect(result.swaps.first.inPlayer.id, 'mid-neu');
      expect(result.swaps.first.outPlayer.id, 'mid-alt');
      expect(result.swaps.first.gain, greaterThan(0));
      expect(result.swaps.first.reason, contains('Form'));
      expect(result.bench.map((p) => p.id), contains('mid-alt'));
    });

    test('große Punkte-Skala: Starker schlägt Schwächling trotz S11-Lärm', () {
      // Reale Kickbase-Skala (ap ~40): mit festen Konstanten (Referenz 5,
      // Band 5) sättigen Form UND Ø auf Maximum – der Ligainsider-Lärm
      // (±8) würde dann den deutlich schwächeren Spieler empfehlen.
      final result = service.recommend(
        squad: [
          buildPlayer(
            id: 'gk',
            name: 'Torwart',
            position: 1,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'def',
            name: 'Verteidiger',
            position: 2,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'st',
            name: 'Stuermer',
            position: 4,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'stark',
            name: 'Mario Stark',
            averagePoints: 45,
            performanceHistory: history([52, 50, 48]),
          ),
          buildPlayer(
            id: 'schwach',
            name: 'Mario Schwach',
            averagePoints: 20,
            performanceHistory: history([19, 18, 20]),
          ),
        ],
        formations: const [singleMidfield],
        ligainsiderStatusByPlayerId: {
          // Lärm: der Starke gilt fälschlich als Alternative, der Schwache
          // fälschlich als S11.
          'stark': LigainsiderPlayerStatus.isAlternative,
          'schwach': LigainsiderPlayerStatus.likelyStart,
        },
      );

      final starterIds = result.starters.map((p) => p.id).toList();
      expect(starterIds, contains('stark'));
      expect(starterIds, isNot(contains('schwach')));
    });

    test('Form entscheidet bei gleicher Stärke (große Punkte-Skala)', () {
      // Ohne skalierungsfreie Bewertung sättigen beide Formen auf +18 und
      // der Zufalls-Tie-Break nach Name würde den Kälteren erwählen.
      final result = service.recommend(
        squad: [
          buildPlayer(
            id: 'gk',
            name: 'Torwart',
            position: 1,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'def',
            name: 'Verteidiger',
            position: 2,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'st',
            name: 'Stuermer',
            position: 4,
            averagePoints: 40,
            performanceHistory: history([40, 40, 40]),
          ),
          buildPlayer(
            id: 'kalt',
            name: 'Anton Kalt',
            averagePoints: 40,
            performanceHistory: history([25, 25, 25]),
          ),
          buildPlayer(
            id: 'heiss',
            name: 'Bert Heiss',
            averagePoints: 40,
            performanceHistory: history([55, 55, 55]),
          ),
        ],
        formations: const [singleMidfield],
      );

      expect(result.starters.map((p) => p.id), contains('heiss'));
      expect(result.starters.map((p) => p.id), isNot(contains('kalt')));
    });

    test('Bewertung ist deterministisch', () {
      List<LineupPlayer> squad() => [
        buildPlayer(id: 'gk1', name: 'Torwart A', position: 1),
        buildPlayer(
          id: 'gk2',
          name: 'Torwart B',
          position: 1,
          averagePoints: 7,
        ),
        for (var i = 0; i < 5; i++)
          buildPlayer(
            id: 'd$i',
            name: 'Abwehr $i',
            position: 2,
            averagePoints: 4 + i,
            performanceHistory: history([i + 1, i + 2]),
          ),
        for (var i = 0; i < 5; i++)
          buildPlayer(
            id: 'm$i',
            name: 'Mittelfeld $i',
            position: 3,
            averagePoints: 9 - i,
          ),
        for (var i = 0; i < 3; i++)
          buildPlayer(
            id: 'f$i',
            name: 'Sturm $i',
            position: 4,
            averagePoints: 6,
          ),
      ];

      final first = service.recommend(squad: squad());
      final second = service.recommend(squad: squad());

      expect(
        first.starters.map((p) => p.id).toList(),
        second.starters.map((p) => p.id).toList(),
      );
      expect(
        first.swaps.map((s) => s.inPlayer.id).toList(),
        second.swaps.map((s) => s.inPlayer.id).toList(),
      );
    });
  });

  group('Erwartete Punkte & Tap-to-Swap (Story #13)', () {
    test('Tausch-Gewinn ist die erwartete Punkt-Differenz', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1, lineupOrder: 1),
          buildPlayer(id: 'def', name: 'Abwehr', position: 2, lineupOrder: 2),
          buildPlayer(id: 'st', name: 'Sturm', position: 4, lineupOrder: 3),
          buildPlayer(
            id: 'mid-alt',
            name: 'Mittelfeld Alt',
            lineupOrder: 4,
            averagePoints: 2,
          ),
          buildPlayer(
            id: 'mid-neu',
            name: 'Mittelfeld Neu',
            lineupOrder: 12,
            averagePoints: 9,
          ),
        ],
        formations: const [singleMidfield],
      );

      expect(result.swaps, hasLength(1));
      final swap = result.swaps.first;
      // Ohne Ligainsider/Gegner ist die Erwartung die reine Ø-Punkte-Differenz.
      expect(swap.expectedGain, closeTo(7.0, 0.01));
      expect(
        swap.expectedGain,
        closeTo(
          result.scores[swap.inPlayer.id]!.expectedPoints -
              result.scores[swap.outPlayer.id]!.expectedPoints,
          0.01,
        ),
      );
    });

    test('Aufstellungs-Wahrscheinlichkeit skaliert die Erwartung', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(id: 's11', name: 'Sven S11', averagePoints: 10),
          buildPlayer(id: 'alt', name: 'Anton Alternative', averagePoints: 10),
        ],
        formations: const [singleMidfield],
        ligainsiderStatusByPlayerId: {
          's11': LigainsiderPlayerStatus.likelyStart,
          'alt': LigainsiderPlayerStatus.isAlternative,
        },
      );

      expect(result.usesLigainsiderData, isTrue);
      expect(result.scores['s11']!.startProbability, closeTo(0.9, 0.001));
      expect(result.scores['alt']!.startProbability, closeTo(0.4, 0.001));
      // Ø-Punkte × Start-Wahrscheinlichkeit (× Gegner-Faktor 1.0).
      expect(result.scores['s11']!.expectedPoints, closeTo(9.0, 0.01));
      expect(result.scores['alt']!.expectedPoints, closeTo(4.0, 0.01));
    });

    test('Gegner-Stärke fließt in die Erwartung ein', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'mid', name: 'Mittelfeld', position: 3),
          buildPlayer(
            id: 'leicht',
            name: 'Lena Leicht',
            position: 4,
            teamId: 'team-easy',
            averagePoints: 10,
          ),
          buildPlayer(
            id: 'hart',
            name: 'Hans Hart',
            position: 4,
            teamId: 'team-hard',
            averagePoints: 10,
          ),
        ],
        formations: const [singleMidfield],
        fixturesByTeamKey: {
          'team-easy': const [
            FixtureInfo(
              opponentName: 'FC Schlapp',
              opponentTablePosition: 18,
              isHomeGame: true,
            ),
          ],
          'team-hard': const [
            FixtureInfo(
              opponentName: 'FC Top',
              opponentTablePosition: 1,
              isHomeGame: false,
            ),
          ],
        },
      );

      // Leichter Heim-Gegner: +20 %, Top-4 auswärts: −20 %.
      expect(result.scores['leicht']!.opponentFactor, closeTo(1.2, 0.01));
      expect(result.scores['hart']!.opponentFactor, closeTo(0.8, 0.01));
      expect(result.scores['leicht']!.expectedPoints, closeTo(12.0, 0.01));
      expect(result.scores['hart']!.expectedPoints, closeTo(8.0, 0.01));
    });

    test('Fallback ohne Ligainsider-Daten: Erwartung = Ø-Punkte', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(id: 'a', name: 'Anton Gleich', averagePoints: 7),
        ],
        formations: const [singleMidfield],
      );

      expect(result.usesLigainsiderData, isFalse);
      expect(result.scores['a']!.startProbability, isNull);
      expect(result.scores['a']!.expectedPoints, closeTo(7.0, 0.01));
    });

    test('unvollständige Ligainsider-Daten fallen auf Ø-Punkte zurück', () {
      // Nur eine einzige S11-Bestätigung unter vielen "nicht gefunden" –
      // die Abdeckung liegt unter minS11Coverage, also greift der Fallback
      // und die vermeintliche Wahrscheinlichkeit wird ignoriert.
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(id: 'a', name: 'Anton Gleich', averagePoints: 7),
          buildPlayer(id: 'b', name: 'Bert Gleich', averagePoints: 7),
        ],
        formations: const [singleMidfield],
        ligainsiderStatusByPlayerId: {
          'a': LigainsiderPlayerStatus.likelyStart,
          for (final id in ['gk', 'def', 'st', 'b'])
            id: LigainsiderPlayerStatus.out,
        },
      );

      expect(result.usesLigainsiderData, isFalse);
      expect(result.scores['a']!.startProbability, isNull);
      expect(result.scores['a']!.expectedPoints, closeTo(7.0, 0.01));
    });

    test('nicht einsatzbare Spieler haben eine minimale Einsatzchance', () {
      final result = service.recommend(
        squad: [
          buildPlayer(id: 'gk', name: 'Torwart', position: 1),
          buildPlayer(id: 'def', name: 'Verteidiger', position: 2),
          buildPlayer(id: 'st', name: 'Stuermer', position: 4),
          buildPlayer(
            id: 'verletzt',
            name: 'Marco Superstar',
            averagePoints: 30,
            matchDayStatus: 1,
          ),
        ],
        formations: const [singleMidfield],
      );

      expect(
        result.scores['verletzt']!.startProbability,
        closeTo(LineupRecommendationService.startProbabilityUnavailable, 0.001),
      );
      expect(result.scores['verletzt']!.expectedPoints, closeTo(3.0, 0.01));
    });

    test('Tap-to-Swap tauscht genau die beiden Spieler in der Aufstellung', () {
      final players = [
        buildPlayer(id: 'gk', name: 'Torwart', position: 1, lineupOrder: 1),
        buildPlayer(id: 'def', name: 'Abwehr', position: 2, lineupOrder: 2),
        buildPlayer(id: 'st', name: 'Sturm', position: 4, lineupOrder: 3),
        buildPlayer(
          id: 'mid-alt',
          name: 'Mittelfeld Alt',
          lineupOrder: 4,
          averagePoints: 2,
        ),
        buildPlayer(
          id: 'mid-neu',
          name: 'Mittelfeld Neu',
          lineupOrder: 12,
          averagePoints: 9,
        ),
        buildPlayer(
          id: 'bank',
          name: 'Bank Zwei',
          position: 2,
          lineupOrder: 13,
          averagePoints: 1,
        ),
      ];
      final swap = LineupSwap(
        inPlayer: players[4],
        outPlayer: players[3],
        gain: 1,
        expectedGain: 7,
        reason: 'Form',
      );

      final ids = LineupRecommendationService.swappedLineupIds(players, swap);

      expect(ids, ['gk', 'def', 'st', 'mid-neu', 'mid-alt', 'bank']);
    });

    test('Tap-to-Swap ohne Beteiligte lässt die Ordnung unverändert', () {
      final players = [
        buildPlayer(id: 'gk', name: 'Torwart', position: 1, lineupOrder: 1),
        buildPlayer(id: 'def', name: 'Abwehr', position: 2, lineupOrder: 2),
        buildPlayer(
          id: 'bank',
          name: 'Bank Eins',
          position: 3,
          lineupOrder: 12,
        ),
      ];
      final swap = LineupSwap(
        inPlayer: buildPlayer(id: 'unbekannt', name: 'Unbekannt'),
        outPlayer: buildPlayer(id: 'fehlt', name: 'Fehlt'),
        gain: 0,
        expectedGain: 0,
        reason: 'Test',
      );

      final ids = LineupRecommendationService.swappedLineupIds(players, swap);

      expect(ids, ['gk', 'def', 'bank']);
    });
  });

  group('Startelf-Konvention (lo) & Torwart-Regel', () {
    test('Bank-Torwart (lo=0) ist kein Starter', () {
      final benchKeeper = buildPlayer(
        id: 'gk2',
        name: 'Torwart Bank',
        position: 1,
        lineupOrder: 0,
      );
      expect(LineupRecommendationService.isStarter(benchKeeper), isFalse);
    });

    test('Aufgestellte Spieler (lo=1..11) sind Starter', () {
      expect(
        LineupRecommendationService.isStarter(
          buildPlayer(id: 'gk', position: 1, lineupOrder: 1),
        ),
        isTrue,
      );
      expect(
        LineupRecommendationService.isStarter(
          buildPlayer(id: 'st', position: 4, lineupOrder: 11),
        ),
        isTrue,
      );
      expect(
        LineupRecommendationService.isStarter(
          buildPlayer(id: 'bank', position: 3, lineupOrder: 12),
        ),
        isFalse,
      );
    });

    test('swappedLineupIds hält den Bank-Torwart auf der Bank', () {
      final players = [
        buildPlayer(
          id: 'gk1',
          name: 'Torwart Eins',
          position: 1,
          lineupOrder: 1,
        ),
        buildPlayer(id: 'def', name: 'Abwehr', position: 2, lineupOrder: 2),
        buildPlayer(
          id: 'gk2',
          name: 'Torwart Zwei',
          position: 1,
          lineupOrder: 0,
        ),
      ];
      final swap = LineupSwap(
        inPlayer: buildPlayer(id: 'unbekannt', name: 'Unbekannt'),
        outPlayer: buildPlayer(id: 'fehlt', name: 'Fehlt'),
        gain: 0,
        expectedGain: 0,
        reason: 'Test',
      );

      final ids = LineupRecommendationService.swappedLineupIds(players, swap);

      // gk2 (lo=0) gehört auf die Bank und darf die S11 nicht belegen.
      expect(ids, ['gk1', 'def', 'gk2']);
    });

    test('Empfehlung zeigt nie zwei Torhüter (auch im Fallback)', () {
      // Zu wenige Feldspieler für eine Formation → Fallback „freie Top-11".
      final result = service.recommend(
        squad: [
          buildPlayer(
            id: 'gk1',
            name: 'Torwart Eins',
            position: 1,
            lineupOrder: 1,
            averagePoints: 10,
          ),
          buildPlayer(
            id: 'gk2',
            name: 'Torwart Zwei',
            position: 1,
            lineupOrder: 0,
            averagePoints: 9,
          ),
          buildPlayer(
            id: 'def',
            name: 'Abwehr',
            position: 2,
            lineupOrder: 2,
            averagePoints: 8,
          ),
          buildPlayer(
            id: 'mid',
            name: 'Mittelfeld',
            position: 3,
            lineupOrder: 3,
            averagePoints: 7,
          ),
        ],
      );

      final keepers = result.starters.where((p) => p.position == 1).toList();
      expect(keepers, hasLength(1));
      expect(keepers.single.id, 'gk1');
      expect(result.isLegalFormation, isFalse);
    });
  });
}
