import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';

class MarketPage extends ConsumerWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Transfermarkt'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterBottomSheet(context),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO: Search
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

  /// Mobile: Single column grid with bottom sheet for filters
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: ResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            children: List.generate(
              10,
              (index) => _buildPlayerCard(context, index),
            ),
          ),
        ),
      ],
    );
  }

  /// Tablet: Split view with filters sidebar
  Widget _buildTabletLayout(BuildContext context) {
    return ResponsiveSplitView(
      listFlex: 3,
      detailFlex: 1,
      list: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: ResponsiveGrid(
              mobileColumns: 1,
              tabletColumns: 2,
              desktopColumns: 2,
              children: List.generate(
                10,
                (index) => _buildPlayerCard(context, index),
              ),
            ),
          ),
        ],
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildFilterPanel(context),
      ),
    );
  }

  /// Desktop: Grid with advanced filters and sorting
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Filter Sidebar
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildFilterPanel(context),
          ),
        ),
        const VerticalDivider(width: 1),
        // Main Content
        Expanded(
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildSortingBar(context),
              Expanded(
                child: ResponsiveGrid(
                  mobileColumns: 1,
                  tabletColumns: 2,
                  desktopColumns: 3,
                  children: List.generate(
                    20,
                    (index) => _buildPlayerCard(context, index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.horizontalPadding),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Spieler suchen...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
        ),
      ),
    );
  }

  Widget _buildSortingBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          const Text('Sortieren:'),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: 'Preis',
            items: const [
              DropdownMenuItem(value: 'Preis', child: Text('Preis')),
              DropdownMenuItem(value: 'Punkte', child: Text('Punkte')),
              DropdownMenuItem(value: 'Name', child: Text('Name')),
            ],
            onChanged: (value) {
              // TODO: Sort
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {
              // TODO: Toggle view
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, int index) {
    final isMobile = context.isMobile;

    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: isMobile ? 24 : 32,
                child: Text('P${index + 1}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spieler ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Team ${index % 4 + 1}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(index + 1) * 100}k€',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${(index + 1) * 10} Pkt',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          if (!isMobile) ...[
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatChip('Position', '${index % 4 + 1}'),
                _buildStatChip('Form', '${(index % 5 + 1) * 20}%'),
              ],
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Buy player
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Kaufen'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildFilterPanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Position'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Torwart'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Abwehr'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Mittelfeld'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Sturm'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ],
                ),
                const Divider(),
                const Text('Preisbereich'),
                const SizedBox(height: 8),
                RangeSlider(
                  values: const RangeValues(0, 1000000),
                  min: 0,
                  max: 10000000,
                  divisions: 100,
                  labels: const RangeLabels('0€', '10M€'),
                  onChanged: (values) {},
                ),
                const Divider(),
                const Text('Status'),
                CheckboxListTile(
                  title: const Text('Verfügbar'),
                  value: true,
                  onChanged: (value) {},
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('Fit'),
                  value: true,
                  onChanged: (value) {},
                  dense: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16.0),
          child: _buildFilterPanel(context),
        ),
      ),
    );
  }
}
