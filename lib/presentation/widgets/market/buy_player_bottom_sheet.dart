import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/models/market_model.dart';
import '../../../data/providers/bid_limit_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../../data/providers/kickbase_api_provider.dart';
import '../../../data/providers/bid_recommendation_providers.dart';
import '../../../data/services/bid_limit_service.dart';
import '../../../domain/exceptions/kickbase_exceptions.dart';
import '../../../data/services/bid_recommendation_service.dart';
import '../../../data/services/budget_calculation_service.dart';
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

  /// Konkurrenz-Budget-Prüfung nur auf Wunsch: Sie löst ligaweit hunderte
  /// Kickbase-Requests aus (Rate-Limit) und startet daher nicht automatisch.
  bool _checkCompetitorBudgets = false;

  /// Gebotsempfehlung ebenfalls nur auf Wunsch: Sie lädt ligaweit alle
  /// Konkurrenz-Käufe samt Marktwert-Verläufen (ein Request pro gekauftem
  /// Spieler) und hat beim automatischen Start das Rate-Limit ausgelöst.
  bool _loadRecommendation = false;

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
    final leagueId = ref.watch(selectedLeagueIdProvider);
    // Echter Kontostand + 33 %-Regel (Teamwert, offene Gebote) aus der API.
    // Vorher wurde `currentUser.b` gelesen – das Feld ist im Firestore-User
    // nie gesetzt, daher stand dort immer 0,00M €.
    final bidLimitAsync = leagueId == null
        ? null
        : ref.watch(
            bidLimitProvider((leagueId: leagueId, playerId: widget.player.id)),
          );
    final bidLimit = bidLimitAsync?.asData?.value;
    final bidAmount = _selectedPrice ?? widget.player.price;
    final recommendedBid = leagueId == null || !_loadRecommendation
        ? null
        : ref.watch(
            recommendedBidProvider((
              leagueId: leagueId,
              currentMarketValue: widget.player.marketValue,
              minimumBid: widget.player.price,
            )),
          );
    // Konkurrenz-Budget-Hinweis folgt sofort jeder Gebots-Änderung; die
    // Budgets der Mitbieter werden pro Liga nur einmal geladen.
    final competitorHintAsync = leagueId == null || !_checkCompetitorBudgets
        ? null
        : ref.watch(
            competitorBudgetHintProvider((
              leagueId: leagueId,
              bidAmount: bidAmount,
            )),
          );
    final competitorHint = competitorHintAsync?.asData?.value;

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
                _BudgetDisplay(
                  limitAsync: bidLimitAsync,
                  selectedPrice: _selectedPrice,
                  onRetry: leagueId == null
                      ? null
                      : () => ref.invalidate(bidLimitProvider),
                ),
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
                    final priceInCents = (price * 1000000).round();
                    if (priceInCents < widget.player.price) {
                      return 'Mindestpreis: ${(widget.player.price / 1000000).toStringAsFixed(2)}M €';
                    }
                    if (bidLimit != null && !bidLimit.allows(priceInCents)) {
                      return 'Max. Gebot: ${(bidLimit.maxBid / 1000000).toStringAsFixed(2)}M € '
                          '(Kontostand + 33 % Minus-Rahmen)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final price = double.tryParse(value);
                    if (price != null) {
                      setState(() {
                        _selectedPrice = (price * 1000000).round();
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
                if (leagueId != null && recommendedBid == null) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _loadRecommendation = true),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Gebotsempfehlung berechnen'),
                  ),
                ],
                if (recommendedBid != null) ...[
                  const SizedBox(height: 16),
                  recommendedBid.when(
                    data: (recommendation) => _RecommendedBid(
                      recommendation: recommendation,
                      bidAmount: bidAmount,
                      competitorHint: competitorHint,
                      competitorLoading:
                          competitorHintAsync?.isLoading ?? false,
                      onCheckCompetitors: _checkCompetitorBudgets
                          ? null
                          : () =>
                                setState(() => _checkCompetitorBudgets = true),
                      onApply: () {
                        setState(() {
                          _selectedPrice = recommendation.amount;
                          _priceController.text =
                              (recommendation.amount / 1000000).toStringAsFixed(
                                2,
                              );
                        });
                      },
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stackTrace) => _RecommendationError(
                      error: error,
                      onRetry: () => ref.invalidate(
                        leagueCompetitorPurchasesProvider(leagueId!),
                      ),
                    ),
                  ),
                ],
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
                      // Erst bieten, wenn die Gebotsgrenze geladen ist –
                      // sonst könnte ein ungültiges Gebot rausgehen.
                      onPressed: bidLimit == null ? null : _handleBuy,
                      icon: const Icon(Icons.gavel),
                      label: const Text('Gebot abgeben'),
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
                      label: const Text('Biete...'),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Keine Liga ausgewählt')));
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
                'Gebot über ${((_selectedPrice ?? widget.player.price) / 1000000).toStringAsFixed(2)}M € '
                'für ${widget.player.firstName} ${widget.player.lastName} abgegeben!',
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fehler: $e')));
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
  final AsyncValue<BidLimit>? limitAsync;
  final int? selectedPrice;
  final VoidCallback? onRetry;

  const _BudgetDisplay({
    required this.limitAsync,
    this.selectedPrice,
    this.onRetry,
  });

  String _m(int value) => '${(value / 1000000).toStringAsFixed(2)}M €';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = limitAsync;
    if (async == null) {
      return const SizedBox.shrink();
    }
    return async.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Budget konnte nicht geladen werden',
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
            if (onRetry != null)
              IconButton(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                tooltip: 'Erneut laden',
              ),
          ],
        ),
      ),
      data: (limit) => _buildLimit(theme, limit),
    );
  }

  Widget _buildLimit(ThemeData theme, BidLimit limit) {
    final price = selectedPrice;
    final exceedsLimit = price != null && !limit.allows(price);
    final remaining = price != null
        ? limit.balanceAfterBid(price)
        : limit.balanceAfterPendingOffers;
    final onColor = exceedsLimit
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onPrimaryContainer;
    final remainingColor = exceedsLimit
        ? theme.colorScheme.error
        : remaining < 0
        ? Colors.orange.shade800
        : Colors.green;

    Widget row(String label, String value, {Color? color, bool bold = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onColor,
                  fontWeight: bold ? FontWeight.bold : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              value,
              style:
                  (bold
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color ?? onColor,
                      ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: exceedsLimit
            ? theme.colorScheme.errorContainer
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          row(
            'Aktuelles Budget',
            _m(limit.budget),
            color: limit.budget < 0
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            bold: true,
          ),
          if (limit.pendingOffers > 0)
            row('Offene Gebote', '−${_m(limit.pendingOffers)}'),
          row('Teamwert', _m(limit.teamValue)),
          row('Max. Minus (33 %)', '−${_m(limit.overdraftAllowance)}'),
          row(
            'Max. Gebot',
            _m(limit.maxBid),
            color: theme.colorScheme.primary,
            bold: true,
          ),
          if (price != null) ...[
            const Divider(),
            row(
              'Kontostand nach Zuschlag',
              _m(remaining),
              color: remainingColor,
              bold: true,
            ),
            if (!exceedsLimit && remaining < 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Das Konto muss bis zum Spieltag wieder ausgeglichen sein.',
                  style: theme.textTheme.bodySmall?.copyWith(color: onColor),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// RECOMMENDED BID
// ============================================================================

class _RecommendedBid extends StatelessWidget {
  final BidRecommendation recommendation;
  final VoidCallback onApply;

  /// Das aktuell geplante eigene Gebot (für den Konkurrenz-Hinweis).
  final int bidAmount;

  /// Konkurrenz-Budget-Hinweis zum geplanten Gebot (null, solange die
  /// Budgets der Mitbieter noch geladen werden).
  final CompetitorBudgetHint? competitorHint;

  /// Läuft die (teure) Konkurrenz-Budget-Prüfung gerade?
  final bool competitorLoading;

  /// Startet die Prüfung; null, sobald sie angefordert wurde.
  final VoidCallback? onCheckCompetitors;

  const _RecommendedBid({
    required this.recommendation,
    required this.onApply,
    required this.bidAmount,
    this.competitorHint,
    this.competitorLoading = false,
    this.onCheckCompetitors,
  });

  String _formatInMillions(int value) =>
      '${(value / 1000000).toStringAsFixed(2)}M €';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailParts = <String>[
      '${recommendation.sampleSize} Käufe',
      recommendation.scope,
    ];
    // Der Hinweis entfällt, wenn kein Mitbieter mehr Budget als das eigene
    // Gebot hat – dann ist der Zuschlag nicht gefährdet.
    final showCompetitorHint =
        competitorHint != null && competitorHint!.hasHigherBudgetCompetitors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insights_outlined,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Empfohlen: '
                  '${(recommendation.amount / 1000000).toStringAsFixed(2)}M €',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  detailParts.join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (onCheckCompetitors != null)
                  TextButton(
                    onPressed: onCheckCompetitors,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 28),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Konkurrenz-Budgets prüfen'),
                  )
                else if (competitorLoading)
                  Text(
                    'Konkurrenz-Budgets werden geladen …',
                    style: theme.textTheme.bodySmall,
                  ),
                if (showCompetitorHint) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Dein Gebot ${_formatInMillions(bidAmount)} – '
                    '${competitorHint!.managersWithHigherBudget} '
                    '${competitorHint!.managersWithHigherBudget == 1 ? 'Manager hat' : 'Manager haben'} '
                    'mehr Budget, max. Konkurrenz-Budget: '
                    '${_formatInMillions(competitorHint!.maxCompetitorBudget)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onApply,
            icon: const Icon(Icons.check),
            tooltip: 'Empfohlenes Gebot übernehmen',
          ),
        ],
      ),
    );
  }
}

/// Fehlerhinweis der Gebotsempfehlung mit manuellem Neuversuch.
class _RecommendationError extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _RecommendationError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = error is RateLimitException
        ? 'Kickbase-Limit erreicht – bitte gleich nochmal versuchen.'
        : 'Gebotsempfehlung konnte nicht geladen werden.';
    return Row(
      children: [
        Icon(Icons.info_outline, size: 18, color: theme.colorScheme.error),
        const SizedBox(width: 8),
        Expanded(child: Text(message, style: theme.textTheme.bodySmall)),
        TextButton(onPressed: onRetry, child: const Text('Erneut')),
      ],
    );
  }
}

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
