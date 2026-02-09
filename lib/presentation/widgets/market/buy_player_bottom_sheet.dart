import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/market_model.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/providers/user_providers.dart';
import '../../../data/providers/kickbase_api_provider.dart';
import '../../providers/market_providers.dart';

/// Buy Player Bottom Sheet
///
/// Bottom Sheet für den Kauf eines Spielers mit:
/// - Player Details Mini-View
/// - Price Input mit Vorschlägen
/// - Current Budget Display
/// - Confirm Button mit Loading State
/// - Success/Error Messages
/// - Error Handling (Insufficient Funds, Already Owned, etc.)
class BuyPlayerBottomSheet extends ConsumerStatefulWidget {
  final MarketPlayer player;

  const BuyPlayerBottomSheet({super.key, required this.player});

  @override
  ConsumerState<BuyPlayerBottomSheet> createState() =>
      _BuyPlayerBottomSheetState();
}

class _BuyPlayerBottomSheetState extends ConsumerState<BuyPlayerBottomSheet> {
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedPrice;

  @override
  void initState() {
    super.initState();
    // Set initial price to player's asking price
    _selectedPrice = widget.player.price;
    _priceController.text = (widget.player.price / 1000000).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    final buyState = ref.watch(buyPlayerProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final budget = currentUser?.b ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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

                // Title
                Text(
                  'Spieler kaufen',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Player Mini View
                _PlayerMiniView(player: widget.player),
                const SizedBox(height: 24),

                // Budget Display
                _BudgetDisplay(budget: budget, selectedPrice: _selectedPrice),
                const SizedBox(height: 24),

                // Price Input
                Text(
                  'Gebotspreis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Preis in Mio. €',
                    prefixText: '€ ',
                    suffixText: 'M',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen Preis eingeben';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Ungültiger Preis';
                    }
                    final priceInCents = (price * 1000000).toInt();
                    if (priceInCents < widget.player.price) {
                      return 'Mindestpreis: ${(widget.player.price / 1000000).toStringAsFixed(2)}M €';
                    }
                    if (priceInCents > budget) {
                      return 'Nicht genügend Budget';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final price = double.tryParse(value);
                    if (price != null) {
                      setState(() {
                        _selectedPrice = (price * 1000000).toInt();
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Quick Price Buttons
                _QuickPriceButtons(
                  basePrice: widget.player.price,
                  onPriceSelected: (price) {
                    setState(() {
                      _selectedPrice = price;
                      _priceController.text = (price / 1000000).toStringAsFixed(
                        2,
                      );
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Buy State Handler
                buyState.when(
                  data: (response) {
                    // Success state
                    if (response != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showSuccessAndClose(context);
                      });
                    }

                    // Normal buy button
                    return FilledButton.icon(
                      onPressed: _handleBuy,
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Kaufen'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                    );
                  },
                  loading: () {
                    // Loading state
                    return FilledButton.icon(
                      onPressed: null,
                      icon: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      label: const Text('Kaufe...'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                    );
                  },
                  error: (error, stack) {
                    // Error state
                    return Column(
                      children: [
                        // Error Message
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  error.toString(),
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Retry Button
                        FilledButton.icon(
                          onPressed: () {
                            ref.read(buyPlayerProvider.notifier).reset();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Erneut versuchen'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Watch Button
                OutlinedButton.icon(
                  onPressed: () => _handleAddToWatchlist(context, ref),
                  icon: const Icon(Icons.bookmark_add),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  label: const Text('Zur Beobachtungsliste'),
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

  void _handleBuy() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final leagueId = ref.read(selectedLeagueIdProvider);
    if (leagueId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keine Liga ausgewählt')));
      return;
    }

    if (_selectedPrice == null) {
      return;
    }

    // Execute buy
    ref
        .read(buyPlayerProvider.notifier)
        .buyPlayer(
          leagueId: leagueId,
          playerId: widget.player.id,
          price: _selectedPrice!,
        );
  }

  void _showSuccessAndClose(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.player.firstName} ${widget.player.lastName} erfolgreich gekauft!',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Reset buy state and close
    ref.read(buyPlayerProvider.notifier).reset();
    Navigator.pop(context);
  }

  void _handleAddToWatchlist(BuildContext context, WidgetRef ref) async {
    try {
      final leagueId = ref.read(selectedLeagueIdProvider);
      if (leagueId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Keine Liga ausgewählt')));
        return;
      }

      final apiClient = ref.read(kickbaseApiClientProvider);
      await apiClient.addScoutedPlayer(leagueId, widget.player.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.bookmark_added, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${widget.player.firstName} ${widget.player.lastName} zur Beobachtungsliste hinzugefügt!',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Refresh watchlist
        ref.invalidate(watchlistPlayersProvider);

        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }
}

// ============================================================================
// PLAYER MINI VIEW
// ============================================================================

class _PlayerMiniView extends StatelessWidget {
  final MarketPlayer player;

  const _PlayerMiniView({required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Player Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: player.profileBigUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                color: theme.colorScheme.surface,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: theme.colorScheme.surface,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${player.firstName} ${player.lastName}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  player.teamName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${player.averagePoints.toStringAsFixed(1)} Ø',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.emoji_events, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${player.totalPoints} Pkt',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BUDGET DISPLAY
// ============================================================================

class _BudgetDisplay extends StatelessWidget {
  final int budget;
  final int? selectedPrice;

  const _BudgetDisplay({required this.budget, this.selectedPrice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = selectedPrice != null ? budget - selectedPrice! : budget;
    final isInsufficient = remaining < 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isInsufficient
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aktuelles Budget',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isInsufficient
                      ? theme.colorScheme.onErrorContainer
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${(budget / 1000000).toStringAsFixed(2)}M €',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isInsufficient
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (selectedPrice != null) ...[
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nach Kauf',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isInsufficient
                        ? theme.colorScheme.onErrorContainer
                        : theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(remaining / 1000000).toStringAsFixed(2)}M €',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isInsufficient
                        ? theme.colorScheme.error
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// QUICK PRICE BUTTONS
// ============================================================================

class _QuickPriceButtons extends StatelessWidget {
  final int basePrice;
  final Function(int) onPriceSelected;

  const _QuickPriceButtons({
    required this.basePrice,
    required this.onPriceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate suggested prices
    final minPrice = basePrice;
    final plus5 = (basePrice * 1.05).toInt();
    final plus10 = (basePrice * 1.10).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schnellauswahl',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onPriceSelected(minPrice),
                child: Text('${(minPrice / 1000000).toStringAsFixed(2)}M'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onPriceSelected(plus5),
                child: Text(
                  '+5%\n${(plus5 / 1000000).toStringAsFixed(2)}M',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onPriceSelected(plus10),
                child: Text(
                  '+10%\n${(plus10 / 1000000).toStringAsFixed(2)}M',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
