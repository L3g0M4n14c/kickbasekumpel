import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/presentation/providers/transfer_planner_provider.dart';
import 'package:kickbasekumpel/presentation/widgets/transfers/transfer_plan_card.dart';
import 'package:kickbasekumpel/presentation/widgets/transfers/transfer_plan_detail_sheet.dart';

class TransfersScreen extends ConsumerWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plannerState = ref.watch(transferPlannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transferplaner')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: plannerState.isLoading
                  ? null
                  : () =>
                        ref.read(transferPlannerProvider.notifier).calculate(),
              icon: const Icon(Icons.auto_graph),
              label: const Text('Beste Transferplaene berechnen'),
            ),
            const SizedBox(height: 16),
            Expanded(child: _PlannerStateView(state: plannerState)),
          ],
        ),
      ),
    );
  }
}

class _PlannerStateView extends StatelessWidget {
  const _PlannerStateView({required this.state});

  final TransferPlannerState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(state.errorMessage!, textAlign: TextAlign.center),
      );
    }

    final result = state.result;
    if (result == null) {
      return const Center(
        child: Text(
          'Berechne jetzt die besten Transfer-Szenarien fuer deinen Kader.',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (result.scenarios.isEmpty) {
      return Center(
        child: Text(
          result.noPlanReason ??
              'Aktuell wurde kein echter Verstaerkungsplan gefunden.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      itemCount: result.scenarios.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final scenario = result.scenarios[index];

        return TransferPlanCard(
          scenario: scenario,
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => TransferPlanDetailSheet(scenario: scenario),
            );
          },
        );
      },
    );
  }
}
