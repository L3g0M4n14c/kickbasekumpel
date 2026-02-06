import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeagueStandingsPage extends ConsumerWidget {
  final String leagueId;

  const LeagueStandingsPage({required this.leagueId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabelle')),
      body: ListView.builder(
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
      ),
    );
  }
}
