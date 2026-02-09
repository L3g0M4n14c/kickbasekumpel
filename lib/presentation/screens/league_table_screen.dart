import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/responsive_layout.dart';

class LeagueTableScreen extends ConsumerWidget {
  final String competitionId;

  const LeagueTableScreen({
    required this.competitionId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableAsync = ref.watch(competitionTableProvider(competitionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bundesliga-Tabelle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(competitionTableProvider(competitionId)),
          ),
        ],
      ),
      body: tableAsync.when(
        data: (tableData) {
          final teams = tableData['t'] as List? ?? tableData['teams'] as List? ?? [];

          if (teams.isEmpty) {
            return const Center(
              child: Text('Keine Tabellendaten verfügbar'),
            );
          }

          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, teams),
            tablet: _buildTabletLayout(context, teams),
            desktop: _buildDesktopLayout(context, teams),
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(competitionTableProvider(competitionId)),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List teams) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return _buildTeamCard(context, team);
      },
    );
  }

  Widget _buildTabletLayout(BuildContext context, List teams) {
    return ResponsiveContainer(
      tabletMaxWidth: 900,
      child: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return _buildTeamCardExpanded(context, team);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List teams) {
    return ResponsiveContainer(
      desktopMaxWidth: 1200,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Platz')),
              DataColumn(label: Text('Verein')),
              DataColumn(label: Text('Sp'), numeric: true),
              DataColumn(label: Text('S'), numeric: true),
              DataColumn(label: Text('U'), numeric: true),
              DataColumn(label: Text('N'), numeric: true),
              DataColumn(label: Text('Tore')),
              DataColumn(label: Text('Diff'), numeric: true),
              DataColumn(label: Text('Pkt'), numeric: true),
            ],
            rows: teams.map<DataRow>((team) {
              final position = team['p'] ?? team['position'] ?? 0;
              final teamName = team['n'] ?? team['name'] ?? 'Unbekannt';
              final matchesPlayed = team['m'] ?? team['matches'] ?? 0;
              final wins = team['w'] ?? team['wins'] ?? 0;
              final draws = team['d'] ?? team['draws'] ?? 0;
              final losses = team['l'] ?? team['losses'] ?? 0;
              final goalsFor = team['gf'] ?? team['goalsFor'] ?? 0;
              final goalsAgainst = team['ga'] ?? team['goalsAgainst'] ?? 0;
              final goalDiff = goalsFor - goalsAgainst;
              final points = team['pts'] ?? team['points'] ?? 0;

              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      '$position',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getPositionColor(context, position),
                      ),
                    ),
                  ),
                  DataCell(Text(teamName)),
                  DataCell(Text('$matchesPlayed')),
                  DataCell(Text('$wins')),
                  DataCell(Text('$draws')),
                  DataCell(Text('$losses')),
                  DataCell(Text('$goalsFor:$goalsAgainst')),
                  DataCell(
                    Text(
                      goalDiff >= 0 ? '+$goalDiff' : '$goalDiff',
                      style: TextStyle(
                        color: goalDiff >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$points',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, dynamic team) {
    final position = team['p'] ?? team['position'] ?? 0;
    final teamName = team['n'] ?? team['name'] ?? 'Unbekannt';
    final matchesPlayed = team['m'] ?? team['matches'] ?? 0;
    final wins = team['w'] ?? team['wins'] ?? 0;
    final draws = team['d'] ?? team['draws'] ?? 0;
    final losses = team['l'] ?? team['losses'] ?? 0;
    final goalsFor = team['gf'] ?? team['goalsFor'] ?? 0;
    final goalsAgainst = team['ga'] ?? team['goalsAgainst'] ?? 0;
    final points = team['pts'] ?? team['points'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPositionColor(context, position),
          child: Text(
            '$position',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          teamName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('$matchesPlayed Sp | $wins S - $draws U - $losses N | $goalsFor:$goalsAgainst Tore'),
        trailing: Text(
          '$points Pkt',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCardExpanded(BuildContext context, dynamic team) {
    final position = team['p'] ?? team['position'] ?? 0;
    final teamName = team['n'] ?? team['name'] ?? 'Unbekannt';
    final matchesPlayed = team['m'] ?? team['matches'] ?? 0;
    final wins = team['w'] ?? team['wins'] ?? 0;
    final draws = team['d'] ?? team['draws'] ?? 0;
    final losses = team['l'] ?? team['losses'] ?? 0;
    final goalsFor = team['gf'] ?? team['goalsFor'] ?? 0;
    final goalsAgainst = team['ga'] ?? team['goalsAgainst'] ?? 0;
    final goalDiff = goalsFor - goalsAgainst;
    final points = team['pts'] ?? team['points'] ?? 0;

    return ResponsiveCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _getPositionColor(context, position),
              child: Text(
                '$position',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Text(
                teamName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$matchesPlayed Sp | $wins-$draws-$losses',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: Text(
                '$goalsFor:$goalsAgainst',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                goalDiff >= 0 ? '+$goalDiff' : '$goalDiff',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: goalDiff >= 0 ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '$points Pkt',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(BuildContext context, int position) {
    if (position <= 4) {
      // Champions League
      return Colors.green;
    } else if (position == 5) {
      // Europa League
      return Colors.blue;
    } else if (position == 6) {
      // Conference League
      return Colors.lightBlue;
    } else if (position >= 16) {
      // Relegation / Abstieg
      return Colors.red;
    }
    return Theme.of(context).colorScheme.primaryContainer;
  }
}
