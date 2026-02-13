import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/models/sales_recommendation_model.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';

/// Sales Recommendation Page - Zeigt intelligente Verkaufsempfehlungen
class SalesRecommendationPage extends ConsumerWidget {
  const SalesRecommendationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoal = ref.watch(salesOptimizationGoalProvider);

    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Verkaufsempfehlungen'),
              actions: [
                PopupMenuButton<OptimizationGoal>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (goal) {
                    ref
                        .read(salesOptimizationGoalProvider.notifier)
                        .setGoal(goal);
                  },
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: OptimizationGoal.balancePositive,
                      checked: selectedGoal == OptimizationGoal.balancePositive,
                      child: const Text('Budget ins Plus'),
                    ),
                    CheckedPopupMenuItem(
                      value: OptimizationGoal.maximizeProfit,
                      checked: selectedGoal == OptimizationGoal.maximizeProfit,
                      child: const Text('Maximaler Profit'),
                    ),
                    CheckedPopupMenuItem(
                      value: OptimizationGoal.keepBestPlayers,
                      checked: selectedGoal == OptimizationGoal.keepBestPlayers,
                      child: const Text('Beste Spieler behalten'),
                    ),
                  ],
                ),
              ],
            )
          : null,
      body: ResponsiveLayout(
        mobile: _SalesRecommendationMobileView(ref: ref),
        tablet: _SalesRecommendationTabletView(ref: ref),
        desktop: _SalesRecommendationDesktopView(ref: ref),
      ),
    );
  }
}

/// Mobile Layout
class _SalesRecommendationMobileView extends StatelessWidget {
  final WidgetRef ref;

  const _SalesRecommendationMobileView({required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SalesGoalSelector(ref: ref),
          const SizedBox(height: 16),
          _SalesHeader(ref: ref),
          const SizedBox(height: 16),
          _PriorityOverview(ref: ref),
          const SizedBox(height: 16),
          _RecommendationsList(ref: ref),
        ],
      ),
    );
  }
}

/// Tablet Layout
class _SalesRecommendationTabletView extends StatelessWidget {
  final WidgetRef ref;

  const _SalesRecommendationTabletView({required this.ref});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSplitView(
      listFlex: 2,
      detailFlex: 3,
      list: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _SalesGoalSelector(ref: ref),
            const SizedBox(height: 16),
            _PriorityOverview(ref: ref),
          ],
        ),
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _SalesHeader(ref: ref),
            const SizedBox(height: 16),
            _RecommendationsList(ref: ref),
          ],
        ),
      ),
    );
  }
}

/// Desktop Layout
class _SalesRecommendationDesktopView extends StatelessWidget {
  final WidgetRef ref;

  const _SalesRecommendationDesktopView({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _SalesGoalSelector(ref: ref),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _SalesHeader(ref: ref),
                const SizedBox(height: 16),
                _RecommendationsList(ref: ref),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _PriorityOverview(ref: ref),
          ),
        ),
      ],
    );
  }
}

/// Goal Selector Widget
class _SalesGoalSelector extends StatelessWidget {
  final WidgetRef ref;

  const _SalesGoalSelector({required this.ref});

  @override
  Widget build(BuildContext context) {
    final selectedGoal = ref.watch(salesOptimizationGoalProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Optimierungsziel',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildGoalCard(
          context,
          'Budget ins Plus',
          'Fokus auf Spieler mit hohem Marktwert',
          OptimizationGoal.balancePositive,
          selectedGoal == OptimizationGoal.balancePositive,
        ),
        const SizedBox(height: 12),
        _buildGoalCard(
          context,
          'Maximaler Profit',
          'Verkaufe mit höchstem Gewinn',
          OptimizationGoal.maximizeProfit,
          selectedGoal == OptimizationGoal.maximizeProfit,
        ),
        const SizedBox(height: 12),
        _buildGoalCard(
          context,
          'Beste Spieler behalten',
          'Verkaufe schwächste, nicht beste',
          OptimizationGoal.keepBestPlayers,
          selectedGoal == OptimizationGoal.keepBestPlayers,
        ),
      ],
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    String title,
    String subtitle,
    OptimizationGoal goal,
    bool isSelected,
  ) {
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () {
          ref.read(salesOptimizationGoalProvider.notifier).setGoal(goal);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sales Header Widget
class _SalesHeader extends StatelessWidget {
  final WidgetRef ref;

  const _SalesHeader({required this.ref});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verkaufsempfehlungen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aktuelles Budget',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1.250.000€',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nach Verkauf',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '2.500.000€',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Priority Overview Widget
class _PriorityOverview extends StatelessWidget {
  final WidgetRef ref;

  const _PriorityOverview({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prioritäten', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        _buildPriorityItem(context, 'Hohe Priorität', '3', Colors.red[400]!),
        const SizedBox(height: 12),
        _buildPriorityItem(
          context,
          'Mittlere Priorität',
          '5',
          Colors.orange[400]!,
        ),
        const SizedBox(height: 12),
        _buildPriorityItem(
          context,
          'Niedrige Priorität',
          '2',
          Colors.blue[400]!,
        ),
      ],
    );
  }

  Widget _buildPriorityItem(
    BuildContext context,
    String label,
    String count,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// Recommendations List Widget
class _RecommendationsList extends StatelessWidget {
  final WidgetRef ref;

  const _RecommendationsList({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ResponsiveCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: index == 0
                    ? Colors.red[400]
                    : index < 3
                    ? Colors.orange[400]
                    : Colors.blue[400],
                child: Text('P${index + 1}'),
              ),
              title: Text('Spieler ${index + 1}'),
              subtitle: index == 0
                  ? const Text('Hochaktuell: Verletzt')
                  : const Text('Schwache Form'),
              trailing: Text(
                '+${(index + 1) * 50}k€',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              onTap: () {
                // TODO: Show player details
              },
            ),
          ),
        );
      }),
    );
  }
}
