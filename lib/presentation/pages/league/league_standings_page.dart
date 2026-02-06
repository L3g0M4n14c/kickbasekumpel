import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/responsive_layout.dart';

class LeagueStandingsPage extends ConsumerWidget {
  final String leagueId;

  const LeagueStandingsPage({required this.leagueId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabelle')),
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        final position = index + 1;
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: position <= 3
                  ? Colors.amber
                  : Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                '$position',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: position <= 3 ? Colors.white : null,
                ),
              ),
            ),
            title: Text('Manager $position'),
            subtitle: Text('Team $position'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${1000 - (position * 50)} Pkt',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${50000 - (position * 1000)}€',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              // TODO: Show manager details
            },
          ),
        );
      },
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return ResponsiveContainer(
      tabletMaxWidth: 900,
      child: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: 10,
        itemBuilder: (context, index) => _buildStandingCard(context, index),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return ResponsiveContainer(
      desktopMaxWidth: 1200,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Card(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Pos')),
              DataColumn(label: Text('Manager')),
              DataColumn(label: Text('Team')),
              DataColumn(label: Text('Punkte'), numeric: true),
              DataColumn(label: Text('Wert'), numeric: true),
            ],
            rows: List.generate(10, (index) {
              final position = index + 1;
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      '$position',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: position <= 3 ? Colors.amber : null,
                      ),
                    ),
                  ),
                  DataCell(Text('Manager $position')),
                  DataCell(Text('Team $position')),
                  DataCell(Text('${1000 - (position * 50)}')),
                  DataCell(Text('${50000 - (position * 1000)}€')),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildStandingCard(BuildContext context, int index) {
    final position = index + 1;
    return ResponsiveCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: position <= 3
                ? Colors.amber
                : Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              '$position',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: position <= 3 ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manager $position',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Team $position',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${1000 - (position * 50)} Pkt',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '${50000 - (position * 1000)}€',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
