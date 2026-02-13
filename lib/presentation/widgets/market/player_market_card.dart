import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/market_model.dart';

/// Player Market Card Widget
///
/// Zeigt einen Spieler auf dem Transfermarkt mit allen wichtigen Infos:
/// - Foto (CachedNetworkImage)
/// - Name, Team, Position
/// - Market Value mit Trend Arrow
/// - Punkte (aktuell und durchschnitt)
/// - Buy Button / Watchlist Icon
class PlayerMarketCard extends ConsumerWidget {
  final MarketPlayer player;
  final VoidCallback onTap;
  final bool showSellOptions;
  final bool showOfferOptions;
  final bool showWatchlistRemove;
  final VoidCallback? onRemoveFromMarket;
  final VoidCallback? onAcceptKickbaseOffer;
  final VoidCallback? onRemoveFromWatchlist;

  const PlayerMarketCard({
    super.key,
    required this.player,
    required this.onTap,
    this.showSellOptions = false,
    this.showOfferOptions = false,
    this.showWatchlistRemove = false,
    this.onRemoveFromMarket,
    this.onAcceptKickbaseOffer,
    this.onRemoveFromWatchlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player Image
                  _PlayerImage(imageUrl: player.profileBigUrl),
                  const SizedBox(width: 12),

                  // Player Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Text(
                          '${player.firstName} ${player.lastName}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Team & Position
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                player.teamName,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _PositionBadge(position: player.position),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Stats Row
                        _PlayerStats(player: player),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Price & Actions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Market Value
                      _PriceDisplay(
                        price: player.price,
                        trend: player.marketValueTrend,
                      ),
                    ],
                  ),
                ],
              ),

              // Offers Badge (if any)
              if (player.offers > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${player.offers} ${player.offers == 1 ? 'Gebot' : 'Gebote'}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Sell Options (Meine Verkäufe)
              if (showSellOptions) ...[
                const SizedBox(height: 8),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.store),
                      label: const Text('An Kickbase'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: onAcceptKickbaseOffer,
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('Vom Markt nehmen'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                      onPressed: onRemoveFromMarket,
                    ),
                  ],
                ),
              ],

              // Offer Options (Erhaltene Angebote)
              if (showOfferOptions) ...[
                const SizedBox(height: 8),
                const Divider(),
                Text(
                  'Angebote anzeigen und annehmen/ablehnen',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],

              // Watchlist Remove Option
              if (showWatchlistRemove) ...[
                const SizedBox(height: 8),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('Entfernen'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    onPressed: onRemoveFromWatchlist,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PLAYER IMAGE WIDGET
// ============================================================================

class _PlayerImage extends StatelessWidget {
  final String imageUrl;

  const _PlayerImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 64,
          height: 64,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          width: 64,
          height: 64,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.person,
            size: 32,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// POSITION BADGE WIDGET
// ============================================================================

class _PositionBadge extends StatelessWidget {
  final int position;

  const _PositionBadge({required this.position});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positionColor = _getPositionColor(position);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: positionColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getPositionName(position),
        style: theme.textTheme.labelSmall?.copyWith(
          color: positionColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPositionName(int position) {
    switch (position) {
      case 1:
        return 'TW';
      case 2:
        return 'ABW';
      case 3:
        return 'MIT';
      case 4:
        return 'STU';
      default:
        return 'UNK';
    }
  }
}

// ============================================================================
// PLAYER STATS WIDGET
// ============================================================================

class _PlayerStats extends StatelessWidget {
  final MarketPlayer player;

  const _PlayerStats({required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Average Points
        Icon(Icons.star, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          '${player.averagePoints.toStringAsFixed(1)} Ø',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),

        // Total Points
        Icon(Icons.emoji_events, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text('${player.totalPoints} Pkt', style: theme.textTheme.bodySmall),
      ],
    );
  }
}

// ============================================================================
// PRICE DISPLAY WIDGET
// ============================================================================

class _PriceDisplay extends StatelessWidget {
  final int price;
  final int trend;

  const _PriceDisplay({required this.price, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Price
        Text(
          '${(price / 1000000).toStringAsFixed(2)}M €',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),

        // Trend
        if (trend != 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                trend > 0 ? Icons.trending_up : Icons.trending_down,
                size: 14,
                color: _getTrendColor(trend),
              ),
              const SizedBox(width: 2),
              Text(
                '${trend > 0 ? '+' : ''}${(trend / 1000).toStringAsFixed(0)}k',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getTrendColor(trend),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Color _getTrendColor(int trend) {
    if (trend > 0) return Colors.green;
    if (trend < 0) return Colors.red;
    return Colors.grey;
  }
}
