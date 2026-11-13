import 'package:flutter/material.dart';

import '../../../config/app_theme.dart';

/// Position Badge - Zeigt die Position des Spielers farbig an
class PositionBadge extends StatelessWidget {
  final int position;

  const PositionBadge({required this.position, super.key});

  String get positionLabel {
    switch (position) {
      case 1:
        return 'TW';
      case 2:
        return 'ABW';
      case 3:
        return 'MF';
      case 4:
        return 'ST';
      default:
        return '?';
    }
  }

  Color get positionColor => AppColors.position(position);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: positionColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          positionLabel,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
