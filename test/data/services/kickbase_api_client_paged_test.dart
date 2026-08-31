import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/services/kickbase_api_client.dart';

/// Test-Client, der [getManagerTransferHistory] mit skriptierten Seiten
/// beantwortet und alle Aufrufe (inkl. `start`-Cursor) aufzeichnet.
class _ScriptedTransferClient extends KickbaseAPIClient {
  _ScriptedTransferClient(this.pages);

  /// Seiten in der Reihenfolge, in der die API sie liefert.
  final List<Map<String, dynamic>> pages;
  final List<String?> startArgs = [];

  @override
  Future<Map<String, dynamic>> getManagerTransferHistory(
    String leagueId,
    String userId, {
    String? start,
  }) async {
    startArgs.add(start);
    final index = startArgs.length - 1;
    return pages[index < pages.length ? index : pages.length - 1];
  }
}

Map<String, dynamic> _transfer(
  String tid,
  Object dt, {
  int trp = 1000000,
  int tty = 1,
}) => {
  'tid': tid,
  'dt': dt,
  'pi': 'p1',
  'pn': 'Spieler',
  'trp': trp,
  'tty': tty,
};

void main() {
  group('getManagerTransferHistoryPaged', () {
    test(
      'lädt alle Seiten nach und vereint sie (inkl. Header-Erhalt)',
      () async {
        final client = _ScriptedTransferClient([
          {
            'u': 'user-1',
            'unm': 'Manager',
            'it': [
              _transfer('t3', '2026-08-20T10:00:00Z'),
              _transfer('t2', '2026-08-15T10:00:00Z'),
              _transfer('t1', '2026-08-10T10:00:00Z'), // ältester der Seite 1
            ],
          },
          {
            'u': 'user-1',
            'unm': 'Manager',
            'it': [
              _transfer(
                't1',
                '2026-08-10T10:00:00Z',
              ), // Overlap wird dedupliziert
              _transfer('t0', '2026-08-05T10:00:00Z'),
            ],
          },
          {'u': 'user-1', 'unm': 'Manager', 'it': []}, // Ende
        ]);

        final result = await client.getManagerTransferHistoryPaged(
          'liga',
          'user-1',
        );

        // Cursor: 1. Aufruf ohne start, dann Offset = Anzahl geladener Transfers
        expect(client.startArgs[0], isNull);
        expect(client.startArgs[1], '3');

        final ids = (result['it'] as List).map((t) => t['tid']).toList();
        expect(ids, ['t3', 't2', 't1', 't0']); // t1 nur einmal
        expect(result['u'], 'user-1'); // Header aus erster Seite
        expect(result['unm'], 'Manager');
      },
    );

    test(
      'bricht ab, wenn die API den Offset ignoriert (gleiche Seite erneut)',
      () async {
        final page = {
          'u': 'user-1',
          'it': [_transfer('t3', '2026-08-20T10:00:00Z')],
        };
        final client = _ScriptedTransferClient([
          page,
          page, // identische Antwort: Offset wirkungslos
          page, // müsste Endlosschleife erzeugen – tut es nicht
        ]);

        final result = await client.getManagerTransferHistoryPaged(
          'liga',
          'user-1',
        );

        expect((result['it'] as List).length, 1); // kein Duplikat
        expect(client.startArgs.length, 2); // sauber gestoppt
      },
    );

    test('übergibt fortlaufende Offsets als start-Parameter', () async {
      Map<String, dynamic> t(String id, String dt) => _transfer(id, dt);
      Map<String, dynamic> mkPage(List<Map<String, dynamic>> it) => {
        'u': 'user-1',
        'it': it,
      };
      final client = _ScriptedTransferClient([
        mkPage([
          t('t4', '2026-08-20T10:00:00Z'),
          t('t3', '2026-08-19T10:00:00Z'),
        ]),
        mkPage([
          t('t2', '2026-08-18T10:00:00Z'),
          t('t1', '2026-08-17T10:00:00Z'),
        ]),
        mkPage([t('t0', '2026-08-16T10:00:00Z')]),
        mkPage([]),
      ]);

      final result = await client.getManagerTransferHistoryPaged(
        'liga',
        'user-1',
      );

      // 1. Aufruf ohne Offset, dann 2, 4, 5 Transfers geladen → Offsets 2/4/5
      expect(client.startArgs, [null, '2', '4', '5']);
      expect((result['it'] as List).length, 5);
    });

    test('bricht früh ab, sobald Transfers älter als [since] sind', () async {
      final client = _ScriptedTransferClient([
        {
          'u': 'user-1',
          'it': [_transfer('t3', '2026-08-20T10:00:00Z')],
        },
        {
          'u': 'user-1',
          'it': [
            _transfer('t2', '2026-08-15T10:00:00Z'),
            _transfer('t1', '2026-07-01T10:00:00Z'), // vor Saison-Start
          ],
        },
        {
          'u': 'user-1',
          'it': [_transfer('tX', '2026-06-01T10:00:00Z')], // darf nicht kommen
        },
      ]);

      final seasonStart = DateTime.utc(2026, 8, 1);
      final result = await client.getManagerTransferHistoryPaged(
        'liga',
        'user-1',
        since: seasonStart,
      );

      final ids = (result['it'] as List).map((t) => t['tid']).toList();
      expect(ids, ['t3', 't2', 't1']);
      expect(client.startArgs.length, 2); // Seite 3 nie angefragt
    });

    test('Regression: gleiche tid (Team-ID) verwirft keine Transfers mehr', () async {
      // Realer API-Fall: tid ist die Team-/Klub-ID (z.B. "5" = Freiburg),
      // nicht die Transfer-ID. 50 Einträge haben i.d.R. nur ~16 eindeutige
      // tid-Werte – der frühere Dedup über tid allein warf daher bis zu 34
      // legitime Transfers still weg. Identität ist jetzt pi+tty+dt+trp.
      Map<String, dynamic> t(String pi, String dt, int trp) => {
        'tid': '5', // identische Team-ID für alle Transfers
        'dt': dt,
        'pi': pi,
        'pn': 'Spieler $pi',
        'trp': trp,
        'tty': 1,
      };
      final client = _ScriptedTransferClient([
        {
          'u': 'user-1',
          'it': [
            t('3218', '2026-08-23T18:23:57Z', 18000000),
            t('8227', '2026-08-23T16:47:38Z', 17466499),
            t('7721', '2026-08-23T14:44:44Z', 7588899),
          ],
        },
        {'u': 'user-1', 'it': []},
      ]);

      final result = await client.getManagerTransferHistoryPaged('liga', 'user-1');

      // Alle drei Transfers trotz identischer tid behalten
      expect((result['it'] as List).length, 3);
      final pis = (result['it'] as List).map((t) => t['pi']).toList();
      expect(pis, ['3218', '8227', '7721']);
    });

    test('unterstützt numerische dt-Werte (Tage seit 1970)', () async {
      final client = _ScriptedTransferClient([
        {
          'u': 'user-1',
          'it': [
            // Tag 20670 ≈ 2026-08-05, Tag 20660 ≈ 2026-07-26
            _transfer('t2', 20670),
            _transfer('t1', 20660),
          ],
        },
        {'u': 'user-1', 'it': []},
      ]);

      final result = await client.getManagerTransferHistoryPaged(
        'liga',
        'user-1',
        since: DateTime.utc(2026, 7, 1),
      );

      expect((result['it'] as List).length, 2);
      expect(client.startArgs.length, 2); // Seite 2 wegen leerer Antwort
    });

    test('numerische dt-Werte: früher Abbruch bei Tag vor [since]', () async {
      final client = _ScriptedTransferClient([
        {
          'u': 'user-1',
          'it': [
            // Tag 20645 ≈ 2026-07-11, Tag 20630 ≈ 2026-06-26 → vor Saison-Start
            _transfer('t2', 20645),
            _transfer('t1', 20630),
          ],
        },
        {'u': 'user-1', 'it': []}, // darf nie angefragt werden
      ]);

      final result = await client.getManagerTransferHistoryPaged(
        'liga',
        'user-1',
        since: DateTime.utc(2026, 7, 1),
      );

      expect((result['it'] as List).length, 2); // beide Transfers behalten
      expect(client.startArgs.length, 1); // kein zweiter Aufruf nötig
    });
  });
}
