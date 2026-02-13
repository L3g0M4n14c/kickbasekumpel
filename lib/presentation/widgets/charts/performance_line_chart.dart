import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Performance Line Chart für KickbaseKumpel
///
/// Zeigt Performance-Verlauf als Linien-Chart.
///
/// **Verwendung:**
/// ```dart
/// PerformanceLineChart(
///   data: [
///     PerformancePoint(matchDay: 1, points: 10),
///     PerformancePoint(matchDay: 2, points: 15),
///   ],
///   title: 'Punkte-Verlauf',
/// )
/// ```
class PerformanceLineChart extends StatelessWidget {
  /// Performance-Datenpunkte
  final List<PerformancePoint> data;

  /// Chart-Titel (optional)
  final String? title;

  /// Chart-Höhe
  final double height;

  /// Zeigt Gitter-Linien
  final bool showGrid;

  /// Zeigt Durchschnitts-Linie
  final bool showAverage;

  const PerformanceLineChart({
    required this.data,
    this.title,
    this.height = 250,
    this.showGrid = true,
    this.showAverage = true,
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

    // Berechne Durchschnitt
    final average =
        data.map((e) => e.points).reduce((a, b) => a + b) / data.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showAverage)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ø ${average.toStringAsFixed(1)} Pkt',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: height,
              child: LineChart(_buildChartData(context, average)),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context, double average) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Berechne Min/Max für Y-Achse
    final points = data.map((e) => e.points).toList();
    final minPoints = points.reduce((a, b) => a < b ? a : b);
    final maxPoints = points.reduce((a, b) => a > b ? a : b);
    final yMin = (minPoints - 5).clamp(0.0, double.infinity);
    final yMax = (maxPoints + 5).toDouble();

    // Erstelle Spots
    final spots = data.map((point) {
      return FlSpot(point.matchDay.toDouble(), point.points);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: showGrid,
        drawVerticalLine: false,
        horizontalInterval: (yMax - yMin) / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
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
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'ST ${value.toInt()}',
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
          left: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      minY: yMin,
      maxY: yMax,
      lineBarsData: [
        // Performance-Linie
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colorScheme.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: colorScheme.primary,
                strokeWidth: 2,
                strokeColor: colorScheme.surface,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        // Durchschnitts-Linie
        if (showAverage)
          LineChartBarData(
            spots: [
              FlSpot(data.first.matchDay.toDouble(), average),
              FlSpot(data.last.matchDay.toDouble(), average),
            ],
            isCurved: false,
            color: colorScheme.secondary,
            barWidth: 2,
            dashArray: [5, 5],
            dotData: const FlDotData(show: false),
          ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (spot.barIndex == 0) {
                // Performance-Linie
                return LineTooltipItem(
                  'ST ${spot.x.toInt()}\n${spot.y.toStringAsFixed(1)} Pkt',
                  TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                // Durchschnitts-Linie
                return LineTooltipItem(
                  'Durchschnitt\n${spot.y.toStringAsFixed(1)} Pkt',
                  TextStyle(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }).toList();
          },
        ),
      ),
    );
  }
}

/// Performance-Datenpunkt
class PerformancePoint {
  final int matchDay;
  final double points;

  const PerformancePoint({required this.matchDay, required this.points});
}
