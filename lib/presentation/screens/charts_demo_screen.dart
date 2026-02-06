import 'package:flutter/material.dart';
import '../widgets/charts/price_chart.dart';
import '../widgets/charts/stats_bar_chart.dart';
import '../widgets/charts/performance_line_chart.dart';
import '../widgets/app_bars/custom_app_bar.dart';

/// Charts Demo Screen
///
/// Zeigt alle Chart-Widgets mit Beispiel-Daten.
/// Benötigt das fl_chart Package in pubspec.yaml.
class ChartsDemoScreen extends StatelessWidget {
  const ChartsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Charts Demo', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(context, 'Price Chart'),
          PriceChart(
            title: 'Marktwert-Entwicklung',
            data: _generatePriceData(),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Stats Bar Chart'),
          StatsBarChart(
            title: 'Punkte pro Spieltag',
            data: _generateStatsData(),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Performance Line Chart'),
          PerformanceLineChart(
            title: 'Punkte-Verlauf',
            data: _generatePerformanceData(),
            showAverage: true,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle(context, 'Performance ohne Durchschnitt'),
          PerformanceLineChart(
            title: 'Saison-Performance',
            data: _generatePerformanceData(),
            showAverage: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  List<PricePoint> _generatePriceData() {
    final now = DateTime.now();
    return List.generate(10, (index) {
      return PricePoint(
        date: now.subtract(Duration(days: 9 - index)),
        price: 5000000 + (index * 100000) + ((index % 3) * 200000),
      );
    });
  }

  List<StatPoint> _generateStatsData() {
    return List.generate(10, (index) {
      return StatPoint(
        label: 'ST ${index + 1}',
        value: 5 + (index % 3 * 5).toDouble() + (index * 0.5),
      );
    });
  }

  List<PerformancePoint> _generatePerformanceData() {
    return List.generate(15, (index) {
      return PerformancePoint(
        matchDay: index + 1,
        points: 8 + (index % 4 * 3).toDouble() + ((index % 2) * 2),
      );
    });
  }
}
