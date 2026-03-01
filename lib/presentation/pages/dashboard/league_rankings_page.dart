import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/league_providers.dart';
import '../league/league_standings_page.dart';

/// Tab-Seite für die Kickbase-Liga-Rangliste.
///
/// Liest die aktuell ausgewählte Liga und zeigt
/// die [LeagueStandingsPage] für diese Liga an.
/// Falls keine Liga ausgewählt ist, wird ein
/// entsprechender Hinweis angezeigt.
class LeagueRankingsPage extends ConsumerWidget {
  const LeagueRankingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSelectFirstLeagueProvider);

    final leagueId = ref.watch(selectedLeagueIdProvider);

    if (leagueId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rangliste')),
        body: const Center(child: Text('Keine Liga ausgewählt')),
      );
    }

    return LeagueStandingsPage(leagueId: leagueId);
  }
}
