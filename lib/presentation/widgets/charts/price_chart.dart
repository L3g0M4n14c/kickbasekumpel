import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Price Chart für KickbaseKumpel
///
/// Zeigt einen Marktwert-Trend als Linien-Chart.
/// Benötigt das fl_chart Package.
///
/// **Verwendung:**
/// ```dart
/// PriceChart(
///   data: [
///     PricePoint(date: DateTime(...), price: 5000000),
///     PricePoint(date: DateTime(...), price: 5500000),
///   ],
///   showGrid: true,
/// )
/// ```
class PriceChart extends StatelessWidget {
  /// Preis-Datenpunkte
  final List<PricePoint> data;

  /// Zeigt Gitter-Linien
  final bool showGrid;

  /// Chart-Höhe
  final double height;

  /// Chart-Titel (optional)
  final String? title;

  const PriceChart({
    required this.data,
    this.showGrid = true,
    this.height = 250,
    this.title,
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
            SizedBox(
              height: height,
              child: LineChart(_buildChartData(context)),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Berechne Min/Max für Y-Achse
    final prices = data.map((e) => e.price).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final padding = (maxPrice - minPrice) * 0.1;

    // Erstelle Spots
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.price.toDouble());
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: showGrid,
        drawVerticalLine: false,
        horizontalInterval: (maxPrice - minPrice) / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              return Text(
                _formatCurrency(value.toInt()),
                style: theme.textTheme.bodySmall,
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < data.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatDate(data[value.toInt()].date),
                    style: theme.textTheme.bodySmall,
                  ),
                );
              }
              return const Text('');
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
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: (minPrice - padding).toDouble(),
      maxY: (maxPrice + padding).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colorScheme.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final point = data[spot.x.toInt()];
              return LineTooltipItem(
                '${_formatCurrency(point.price)}\n${_formatDate(point.date)}',
                TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  String _formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M €';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K €';
    }
    return '$value €';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}';
  }
}

/// Preis-Datenpunkt
class PricePoint {
  final DateTime date;
  final int price;

  const PricePoint({required this.date, required this.price});
}
