import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/market_providers.dart';
import '../common/app_logo.dart';

/// Market Filters Widget
///
/// Bottom Sheet für Market Filtering mit:
/// - Position Filter (Torwart, Abwehr, Mittelfeld, Sturm)
/// - Price Range Slider (Min/Max)
/// - Clear All Button
/// - Apply Button
class MarketFilters extends ConsumerStatefulWidget {
  const MarketFilters({super.key});

  @override
  ConsumerState<MarketFilters> createState() => _MarketFiltersState();
}

class _MarketFiltersState extends ConsumerState<MarketFilters> {
  int? _selectedPosition;
  RangeValues _priceRange = const RangeValues(0, 50); // In Millionen

  @override
  void initState() {
    super.initState();
    // Load current filter state
    final currentFilter = ref.read(marketFilterProvider);
    _selectedPosition = currentFilter.positionFilter;
    _priceRange = RangeValues(
      currentFilter.minPrice ?? 0,
      currentFilter.maxPrice ?? 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filter = ref.watch(marketFilterProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title & Clear Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (filter.hasActiveFilters)
                      TextButton.icon(
                        icon: const Icon(Icons.clear_all, size: 20),
                        label: const Text('Zurücksetzen'),
                        onPressed: () {
                          ref
                              .read(marketFilterProvider.notifier)
                              .clearFilters();
                          setState(() {
                            _selectedPosition = null;
                            _priceRange = const RangeValues(0, 50);
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Position Filter Section
                _FilterSection(
                  title: 'Position',
                  icon: AppLogo(
                    size: 20,
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PositionChip(
                        label: 'Alle',
                        isSelected: _selectedPosition == null,
                        onSelected: () {
                          setState(() => _selectedPosition = null);
                        },
                      ),
                      _PositionChip(
                        label: 'Torwart',
                        icon: AppLogo(size: 16, backgroundColor: Colors.orange),
                        color: Colors.orange,
                        isSelected: _selectedPosition == 1,
                        onSelected: () {
                          setState(() => _selectedPosition = 1);
                        },
                      ),
                      _PositionChip(
                        label: 'Abwehr',
                        icon: Icon(Icons.shield),
                        color: Colors.blue,
                        isSelected: _selectedPosition == 2,
                        onSelected: () {
                          setState(() => _selectedPosition = 2);
                        },
                      ),
                      _PositionChip(
                        label: 'Mittelfeld',
                        icon: Icon(
                          Icons.swap_horiz,
                          size: 16,
                          color: _selectedPosition == 3
                              ? Colors.white
                              : Colors.green,
                        ),
                        color: Colors.green,
                        isSelected: _selectedPosition == 3,
                        onSelected: () {
                          setState(() => _selectedPosition = 3);
                        },
                      ),
                      _PositionChip(
                        label: 'Sturm',
                        icon: Icon(
                          Icons.flash_on,
                          size: 16,
                          color: _selectedPosition == 4
                              ? Colors.white
                              : Colors.red,
                        ),
                        color: Colors.red,
                        isSelected: _selectedPosition == 4,
                        onSelected: () {
                          setState(() => _selectedPosition = 4);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Price Range Filter Section
                _FilterSection(
                  title: 'Preisspanne',
                  icon: Icon(
                    Icons.euro,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  child: Column(
                    children: [
                      // Price Range Display
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_priceRange.start.toStringAsFixed(1)}M €',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '${_priceRange.end.toStringAsFixed(1)}M €',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Range Slider
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 50,
                        divisions: 100,
                        labels: RangeLabels(
                          '${_priceRange.start.toStringAsFixed(1)}M',
                          '${_priceRange.end.toStringAsFixed(1)}M',
                        ),
                        onChanged: (values) {
                          setState(() => _priceRange = values);
                        },
                      ),

                      // Quick Price Presets
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _PricePresetChip(
                            label: '< 5M',
                            onTap: () {
                              setState(() {
                                _priceRange = const RangeValues(0, 5);
                              });
                            },
                          ),
                          _PricePresetChip(
                            label: '5M - 15M',
                            onTap: () {
                              setState(() {
                                _priceRange = const RangeValues(5, 15);
                              });
                            },
                          ),
                          _PricePresetChip(
                            label: '15M - 30M',
                            onTap: () {
                              setState(() {
                                _priceRange = const RangeValues(15, 30);
                              });
                            },
                          ),
                          _PricePresetChip(
                            label: '> 30M',
                            onTap: () {
                              setState(() {
                                _priceRange = const RangeValues(30, 50);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Apply Button
                FilledButton.icon(
                  onPressed: _applyFilters,
                  icon: const Icon(Icons.check),
                  label: const Text('Filter anwenden'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                ),
                const SizedBox(height: 12),

                // Cancel Button
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Abbrechen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _applyFilters() {
    // Apply position filter
    ref
        .read(marketFilterProvider.notifier)
        .setPositionFilter(_selectedPosition);

    // Apply price range filter (only if not at default values)
    if (_priceRange.start > 0 || _priceRange.end < 50) {
      ref
          .read(marketFilterProvider.notifier)
          .setPriceRange(
            min: _priceRange.start > 0 ? _priceRange.start : null,
            max: _priceRange.end < 50 ? _priceRange.end : null,
          );
    } else {
      ref
          .read(marketFilterProvider.notifier)
          .setPriceRange(min: null, max: null);
    }

    Navigator.pop(context);
  }
}

// ============================================================================
// FILTER SECTION WIDGET
// ============================================================================

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

// ============================================================================
// POSITION CHIP WIDGET
// ============================================================================

class _PositionChip extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onSelected;

  const _PositionChip({
    required this.label,
    this.icon,
    this.color,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 6)],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: chipColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : chipColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: chipColor, width: 1.5),
    );
  }
}

// ============================================================================
// PRICE PRESET CHIP WIDGET
// ============================================================================

class _PricePresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PricePresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
