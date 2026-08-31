import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/league_model.dart';
import 'package:kickbasekumpel/data/utils/parsing_utils.dart';

void main() {
  group('League.fromJson mit Kickbase-Overview-Response', () {
    // Realistische Form der Antwort von GET /v4/leagues/{id}/overview:
    // Die Kurzkeys (i/n/tn/b/tv/p/pl) kommen so aus der echten API.
    const overviewJson = {
      'i': '123456',
      'n': 'Testliga',
      'cpi': '1',
      'md': 3,
      'dt': '2026-08-01',
      'cu': {
        'i': 7890123, // int, nicht String!
        'n': 'Marco', // Kurzkey statt 'name'
        'tn': 'FC Kumpel', // Kurzkey statt 'teamName'
        'b': 1500000,
        'tv': 34500000,
        'p': 52,
        'pl': 3,
        'lp': [111, 222, 333], // int-Liste statt String-Liste
      },
    };

    test(
      'ohne Normalisierung crasht das Parsen mit Null-as-String (Reproduktion des Bugs)',
      () {
        expect(
          () => League.fromJson(overviewJson),
          throwsA(
            isA<TypeError>().having(
              (e) => e.toString(),
              'message',
              contains("type 'Null' is not a subtype of type 'String'"),
            ),
          ),
        );
      },
    );

    test(
      'mit normalizeLeagueJson wird die Overview-Response korrekt geparst',
      () {
        final league = League.fromJson(normalizeLeagueJson(overviewJson));

        expect(league.i, '123456');
        expect(league.n, 'Testliga');
        expect(league.cu.id, '7890123');
        expect(league.cu.name, 'Marco');
        expect(league.cu.teamName, 'FC Kumpel');
        expect(league.cu.budget, 1500000);
        expect(league.cu.teamValue, 34500000);
        expect(league.cu.points, 52);
        expect(league.cu.placement, 3);
        // Pflicht-Statistiken, die die Overview nicht liefert -> 0 statt Crash
        expect(league.cu.won, 0);
        expect(league.cu.drawn, 0);
        expect(league.cu.lost, 0);
        // lp-Ids werden zu Strings normalisiert
        expect(league.cu.lp, ['111', '222', '333']);
        expect(league.seasonStartDate, '2026-08-01');
      },
    );

    test('fehlende cu-Werte werden mit Defaults abgesichert', () {
      final league = League.fromJson(
        normalizeLeagueJson({
          'i': 42, // Auch int-Ids werden zu Strings
          'n': 'Liga ohne cu-Details',
          'cu': <String, dynamic>{'i': 7},
        }),
      );

      expect(league.i, '42');
      expect(league.cu.id, '7');
      expect(league.cu.name, '');
      expect(league.cu.teamName, '');
      expect(league.cu.budget, 0);
      expect(league.cu.won, 0);
    });

    test('getLeagues-Shape (ohne cu) wird weiterhin mit Default-cu geparst', () {
      final league = League.fromJson(
        normalizeLeagueJson({'i': '999', 'n': 'Selection-Liga'}),
      );

      expect(league.i, '999');
      expect(league.cu.id, '');
      expect(league.cu.name, '');
    });
  });
}