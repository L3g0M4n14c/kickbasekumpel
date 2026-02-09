import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../data/providers/ligainsider_provider.dart';
import '../../../data/models/ligainsider_match_model.dart';

class LigainsiderScreen extends ConsumerStatefulWidget {
  const LigainsiderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LigainsiderScreenState();
}

class _LigainsiderScreenState extends ConsumerState<LigainsiderScreen> {
  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(ligainsiderMatchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voraussichtliche Aufstellungen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(ligainsiderMatchesProvider),
          ),
        ],
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Keine Aufstellungen gefunden.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.refresh(ligainsiderMatchesProvider),
                      child: const Text('Erneut versuchen'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: matches.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final match = matches[index];
              return _MatchTile(match: match);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Fehler beim Laden: $err'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.refresh(ligainsiderMatchesProvider),
                  child: const Text('Erneut versuchen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MatchTile extends StatefulWidget {
  final LigainsiderMatch match;
  const _MatchTile({required this.match});

  @override
  State<_MatchTile> createState() => _MatchTileState();
}

class _MatchTileState extends State<_MatchTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.match;

    return Column(
      children: [
        ListTile(
          onTap: () => setState(() => isExpanded = !isExpanded),
          leading: m.homeLogo != null
              ? Image.network(
                  (kIsWeb
                      ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(m.homeLogo!.replaceFirst(RegExp(r'^https?:\/\/'), ''))}&w=60&h=60&fit=cover'
                      : m.homeLogo!),
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                )
              : const CircleAvatar(child: Icon(Icons.shield)),
          title: Row(
            children: [
              Expanded(child: Text(m.homeTeam, textAlign: TextAlign.left)),
              const Text('vs', style: TextStyle(color: Colors.grey)),
              Expanded(child: Text(m.awayTeam, textAlign: TextAlign.right)),
            ],
          ),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: [
                _PitchView(label: 'Heim: ${m.homeTeam}', rows: m.homeLineup),
                const Divider(height: 24),
                _PitchView(label: 'Gast: ${m.awayTeam}', rows: m.awayLineup),
              ],
            ),
          ),
      ],
    );
  }
}

class _PitchView extends StatelessWidget {
  final String label;
  final List<LineupRow> rows;
  const _PitchView({required this.label, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.green.shade400],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: rows.map((r) => _LineupRowView(row: r)).toList(),
          ),
        ),
      ],
    );
  }
}

class _LineupRowView extends StatelessWidget {
  final LineupRow row;
  const _LineupRowView({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: row.players.map((p) => _PlayerPill(player: p)).toList(),
      ),
    );
  }
}

class _PlayerPill extends StatelessWidget {
  final LineupPlayer player;
  const _PlayerPill({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          if (player.imageUrl != null)
            ClipOval(
              child: Image.network(
                (kIsWeb
                    ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(player.imageUrl!.replaceFirst(RegExp(r'^https?:\/\/'), ''))}&w=72&h=72&fit=cover'
                    : player.imageUrl!),
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => CircleAvatar(
                  child: Text(player.name.isNotEmpty ? player.name[0] : '?'),
                ),
              ),
            )
          else
            CircleAvatar(
              child: Text(player.name.isNotEmpty ? player.name[0] : '?'),
            ),
          const SizedBox(height: 4),
          Text(
            player.name,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (player.alternative != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Alt: ${player.alternative}',
                style: const TextStyle(fontSize: 9),
              ),
            ),
        ],
      ),
    );
  }
}
