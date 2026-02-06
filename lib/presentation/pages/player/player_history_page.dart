import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerHistoryPage extends ConsumerWidget {
  final String playerId;

  const PlayerHistoryPage({required this.playerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spieler-Historie')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Transfer History
          _HistorySection(
            title: 'Transfer-Historie',
            icon: Icons.swap_horiz,
            children: List.generate(
              5,
              (index) => _HistoryItem(
                date: '15.0${index + 1}.2024',
                title: 'Transfer ${index + 1}',
                subtitle: 'Manager A → Manager B',
                value: '${5000000 + (index * 100000)}€',
                iconData: Icons.swap_horiz,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Performance History
          _HistorySection(
            title: 'Leistungs-Historie',
            icon: Icons.trending_up,
            children: List.generate(
              10,
              (index) => _HistoryItem(
                date: 'Spieltag ${34 - index}',
                title: 'vs. Verein ${index + 1}',
                subtitle:
                    '${(index % 2 == 0) ? 'Sieg' : 'Niederlage'} • ${index % 3}:${(index + 1) % 3}',
                value: '${10 - index} Pkt',
                iconData: Icons.sports_soccer,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Value History
          _HistorySection(
            title: 'Marktwert-Entwicklung',
            icon: Icons.show_chart,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chart kommt bald',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _HistorySection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date;
  final String title;
  final String subtitle;
  final String value;
  final IconData iconData;

  const _HistoryItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(child: Icon(iconData, size: 20)),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 2),
            Text(
              date,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        isThreeLine: true,
      ),
    );
  }
}
