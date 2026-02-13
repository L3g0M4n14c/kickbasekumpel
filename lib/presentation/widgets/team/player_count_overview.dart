import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/team_player_counts_model.dart';

/// Überblick über die Spieleranzahl nach Position
class PlayerCountOverview extends StatelessWidget {
  final TeamPlayerCounts playerCounts;

  const PlayerCountOverview({required this.playerCounts, super.key});

  Color _getPositionColor(String position, int count) {
    final minRequired = _getMinRequired(position);
    return count >= minRequired ? Colors.green : Colors.red;
  }

  int _getMinRequired(String position) {
    switch (position) {
      case 'TW':
        return 1;
      case 'ABW':
        return 3;
      case 'MF':
        return 2;
      case 'ST':
        return 1;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPositionCard(
          context,
          label: 'Gesamt',
          count: playerCounts.total,
          color: playerCounts.total >= 11 ? Colors.green : Colors.red,
        ),
        _buildPositionCard(
          context,
          label: 'TW',
          count: playerCounts.goalkeepers,
          color: _getPositionColor('TW', playerCounts.goalkeepers),
        ),
        _buildPositionCard(
          context,
          label: 'ABW',
          count: playerCounts.defenders,
          color: _getPositionColor('ABW', playerCounts.defenders),
        ),
        _buildPositionCard(
          context,
          label: 'MF',
          count: playerCounts.midfielders,
          color: _getPositionColor('MF', playerCounts.midfielders),
        ),
        _buildPositionCard(
          context,
          label: 'ST',
          count: playerCounts.forwards,
          color: _getPositionColor('ST', playerCounts.forwards),
        ),
      ],
    );
  }

  Widget _buildPositionCard(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          child: Column(
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
