import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaguePlayersPage extends ConsumerWidget {
  final String leagueId;

  const LeaguePlayersPage({required this.leagueId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spieler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Filter players
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search players
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Spieler ${index + 1}'),
              subtitle: Text('Verein ${(index % 3) + 1}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${100 - index} Pkt',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${5000000 - (index * 100000)}€',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Show player details
              },
            ),
          );
        },
      ),
    );
  }
}
