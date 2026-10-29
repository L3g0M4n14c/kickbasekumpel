import '../models/ligainsider_match_model.dart';
import '../models/ligainsider_model.dart';
import '../utils/parsing_utils.dart';
import 'ligainsider_service.dart';

/// Index über die voraussichtlichen Aufstellungen, der einen Spieler per Name
/// auf seine Ligainsider-Rolle abbildet.
///
/// Zwei Quellen werden unterstützt:
/// - [LigainsiderLineupIndex.fromMatches] – Daten der `getLigainsiderLineups`
///   Cloud Function (Firestore-Cache, funktioniert auch im Web). Das ist die
///   primäre Quelle, weil sie serverseitig scraped.
/// - [LigainsiderLineupIndex.fromService] – lokaler Scrape als Fallback.
///
/// `statusFor` liefert `null`, wenn keine verlässliche Aussage möglich ist
/// (z. B. Aufstellungen noch nicht veröffentlicht). Nur so kann die UI
/// zwischen „kein S11-Platz“ („Fehlt“) und „Daten fehlen“ unterscheiden.
class LigainsiderLineupIndex {
  LigainsiderLineupIndex._({
    required this.hasCoverage,
    required LigainsiderPlayerStatus? Function(String firstName, String lastName)
    statusResolver,
  }) : _statusFor = statusResolver;

  /// Ein leerer Index: keine Daten, keine Aussage.
  factory LigainsiderLineupIndex.empty() => LigainsiderLineupIndex._(
    hasCoverage: false,
    statusResolver: (_, _) => null,
  );

  /// Baut den Index aus den Cloud-Function-Aufstellungen.
  factory LigainsiderLineupIndex.fromMatches(List<LigainsiderMatch> matches) {
    final starters = <_LineupEntry>[];
    final alternatives = <_LineupEntry>[];

    for (final match in matches) {
      for (final row in [...match.homeLineup, ...match.awayLineup]) {
        for (final player in row.players) {
          final name = _entryName(player.name, player.ligainsiderId);
          final segments = _segments(name);
          if (segments.isEmpty) continue;

          starters.add(
            _LineupEntry(
              segments: segments,
              // Ligainsider liefert nur S11 + Alternativen. Wer eine
              // Alternative neben sich hat, ist die „1. Option“.
              hasAlternative: player.alternative != null,
            ),
          );

          final alternative = player.alternative?.trim();
          if (alternative != null && alternative.isNotEmpty) {
            final alternativeSegments = _segments(alternative);
            if (alternativeSegments.isNotEmpty) {
              alternatives.add(_LineupEntry(segments: alternativeSegments));
            }
          }
        }
      }
    }

    final hasCoverage =
        starters.length >= LigainsiderService.minPlayersForFullCoverage;

    return LigainsiderLineupIndex._(
      hasCoverage: hasCoverage,
      statusResolver: (firstName, lastName) {
        final query = _segments('$firstName $lastName');
        if (query.isEmpty) return null;

        // Mehrere Namensformen probieren: kompletter Name, dann nur der
        // Nachname (Widgets übergeben teils den vollen Namen als Nachnamen).
        final queries = <Set<String>>[
          query,
          if (query.length > 1) {query.last},
        ];

        for (final candidateQuery in queries) {
          final isAlternative = alternatives.any(
            (entry) => entry.segments.containsAll(candidateQuery),
          );
          if (isAlternative) return LigainsiderPlayerStatus.isAlternative;

          final hits = starters
              .where((entry) => entry.segments.containsAll(candidateQuery))
              .toList(growable: false);

          if (hits.length == 1) {
            return hits.first.hasAlternative
                ? LigainsiderPlayerStatus.startWithAlternative
                : LigainsiderPlayerStatus.likelyStart;
          }
          if (hits.length > 1) {
            // Mehrdeutig (z. B. „Kim“): exakter Volltreffer oder keine Aussage.
            final exact = hits
                .where((entry) => entry.segments.containsAll(query))
                .toList(growable: false);
            if (exact.length != 1) return null;
            return exact.first.hasAlternative
                ? LigainsiderPlayerStatus.startWithAlternative
                : LigainsiderPlayerStatus.likelyStart;
          }
        }

        // 3) Kurznamen-Fuzzy (nur Alternativen): Ligainsider liefert dort
        //    teils nur den Kurznamen („Minjae“ für „Min-jae Kim“).
        final queryConcat = query.join();
        if (queryConcat.length >= 6) {
          final matchedAlternative = alternatives.any(
            (entry) =>
                entry.concat.length >= 5 &&
                (queryConcat.contains(entry.concat) ||
                    entry.concat.contains(queryConcat)),
          );
          if (matchedAlternative) {
            return LigainsiderPlayerStatus.isAlternative;
          }
        }

        // Kein Treffer: bei vollständiger Abdeckung ist das ein echter
        // Ausschluss („nicht in der erwarteten Startelf“), sonst eine
        // Datenlücke.
        return hasCoverage ? LigainsiderPlayerStatus.out : null;
      },
    );
  }

  /// Nutzt den lokalen Service als Quelle (Fallback, wenn die Cloud Function
  /// nicht erreichbar ist oder noch keine Daten hat).
  factory LigainsiderLineupIndex.fromService(LigainsiderService service) {
    return LigainsiderLineupIndex._(
      hasCoverage: service.hasLineupCoverage,
      statusResolver: (firstName, lastName) {
        final hasCoverage = service.hasLineupCoverage;
        final status = service.getPlayerStatus(firstName, lastName);
        if (status == LigainsiderPlayerStatus.out && !hasCoverage) {
          return null;
        }
        return status;
      },
    );
  }

  /// true, wenn die Daten die Startelf der Liga weitgehend abdecken.
  final bool hasCoverage;

  final LigainsiderPlayerStatus? Function(String firstName, String lastName)
  _statusFor;

  /// Rolle des Spielers – `null`, wenn keine verlässliche Aussage möglich ist.
  LigainsiderPlayerStatus? statusFor(String firstName, String lastName) =>
      _statusFor(firstName, lastName);

  /// Name aus dem Slug (voller Name) oder ersatzweise der Anzeigename.
  static String _entryName(String displayName, String? slug) {
    if (slug != null && slug.contains('_')) {
      final fromSlug = playerNameFromLigainsiderSlug(slug);
      if (fromSlug != null && fromSlug.isNotEmpty) return fromSlug;
    }
    return displayName.trim();
  }

  /// Namens-Segmente (lowercase, ohne Diakritika).
  static Set<String> _segments(String raw) {
    if (raw.trim().isEmpty) return const <String>{};
    return normalizeForLigainsider(raw)
        .split(RegExp(r'[^a-z0-9]+'))
        .where((segment) => segment.isNotEmpty)
        .toSet();
  }
}

/// Ein Startelf- oder Alternativen-Eintrag mit seinen Namens-Segmenten.
class _LineupEntry {
  _LineupEntry({required this.segments, this.hasAlternative = false})
    : concat = segments.join();

  final Set<String> segments;

  /// Zusammengezogene Namensform (`min-jae` → `minjae`) – für Kurznamen-Fuzzy.
  final String concat;

  final bool hasAlternative;
}
