import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../screens/league_table_screen.dart';

/// Liga Page - Shows Bundesliga table
class LigaPage extends ConsumerWidget {
  const LigaPage({super.key});

  // Bundesliga competition ID
  static const String _bundesligaCompetitionId = '1';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Liga'),
            )
          : AppBar(
              title: const Text('Liga'),
            ),
      body: const LeagueTableScreen(competitionId: _bundesligaCompetitionId),
    );
  }
}
