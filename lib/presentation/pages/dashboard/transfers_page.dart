import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';

class TransfersPage extends ConsumerWidget {
  const TransfersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Transfers'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // TODO: Filter
                  },
                ),
              ],
            )
          : null,
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildRecommendationCard(context),
        const SizedBox(height: 16),
        ..._buildTransferList(context),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return ResponsiveSplitView(
      listFlex: 2,
      detailFlex: 3,
      list: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: _buildTransferList(context)),
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildRecommendationCard(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(children: _buildTransferList(context)),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _buildRecommendationCard(context),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(BuildContext context) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KI-Empfehlungen',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Icon(Icons.swap_horiz_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Erhalte KI-basierte Transfervorschläge basierend auf:'),
          const SizedBox(height: 8),
          const Text('• Spieler-Performance'),
          const Text('• Preis-Leistungs-Verhältnis'),
          const Text('• Positions-Bedarf'),
          const Text('• Budget-Optimierung'),
        ],
      ),
    );
  }

  List<Widget> _buildTransferList(BuildContext context) {
    return List.generate(5, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ResponsiveCard(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text('Transfer ${index + 1}'),
            subtitle: const Text('Empfohlen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      );
    });
  }
}
