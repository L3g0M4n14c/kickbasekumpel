import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Stats Bar Chart für KickbaseKumpel
///
/// Zeigt Statistiken als Balken-Chart (z.B. Punkte pro Spieltag).
///
/// **Verwendung:**
/// ```dart
/// StatsBarChart(
///   data: [
///     StatPoint(label: 'ST 1', value: 10),
///     StatPoint(label: 'ST 2', value: 15),
///   ],
///   title: 'Punkte pro Spieltag',
/// )
/// ```
class StatsBarChart extends StatelessWidget {
  /// Statistik-Datenpunkte
  final List<StatPoint> data;

  /// Chart-Titel (optional)
  final String? title;

  /// Chart-Höhe
  final double height;

  /// Zeigt Gitter-Linien
  final bool showGrid;

  const StatsBarChart({
    required this.data,
    this.title,
    this.height = 250,
    this.showGrid = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Keine Daten verfügbar',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(height: height, child: BarChart(_buildChartData(context))),
          ],
        ),
      ),
    );
  }

  BarChartData _buildChartData(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Berechne Max-Wert für Y-Achse
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final yMax = (maxValue * 1.2).ceilToDouble();

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: yMax,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${data[group.x].label}\n${rod.toY.toInt()} Pkt',
              TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < data.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    data[value.toInt()].label,
                    style: theme.textTheme.bodySmall,
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: theme.textTheme.bodySmall,
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: FlGridData(
        show: showGrid,
        drawVerticalLine: false,
        horizontalInterval: yMax / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      barGroups: data.asMap().entries.map((entry) {
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: entry.value.value.toDouble(),
              color: _getBarColor(entry.value.value, colorScheme),
              width: 16,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Farbe basierend auf Wert
  Color _getBarColor(double value, ColorScheme colorScheme) {
    if (value >= 10) return Colors.green;
    if (value >= 5) return Colors.orange;
    return Colors.red;
  }
}

/// Statistik-Datenpunkt
class StatPoint {
  final String label;
  final double value;

  const StatPoint({required this.label, required this.value});
}
