import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/providers/ligainsider_photo_provider.dart';
import 'package:kickbasekumpel/data/utils/parsing_utils.dart';
import 'package:kickbasekumpel/presentation/utils/player_status_helper.dart';

/// Spieler-Reihe mit erweiterten Informationen und Verkaufs-Toggle
///
/// Zeigt folgende Informationen pro Spieler:
/// - Foto: Spielerfoto in Kreis (oder Person-Icon als Fallback)
/// - Spalte 1: Vor- + Nachname (groß) + Teamname (klein darunter)
/// - Spalte 2: Status-Emoji (💪 = Fit, 💊 = Fraglich, 🚑 = Verletzt, 🟨 = Gelbe Karte)
/// - Spalte 3: Durchschnittspunkte (groß) + Gesamtpunkte (klein darunter)
/// - Spalte 4: Marktwert + Trend mit Pfeil (↑ grün oder ↓ rot)
class PlayerRowWithSale extends ConsumerWidget {
  final Player player;
  final bool isSelectedForSale;
  final Function(bool) onToggleSale;
  final VoidCallback? onTap;

  const PlayerRowWithSale({
    required this.player,
    required this.isSelectedForSale,
    required this.onToggleSale,
    this.onTap,
    super.key,
  });

  String get fullName => '${player.firstName} ${player.lastName}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ligainsider-Foto-Lookup
    final photoMap = ref.watch(ligainsiderPhotoMapProvider).asData?.value;
    final ligaPhoto = lookupLigainsiderPhoto(
      photoMap,
      player.firstName,
      player.lastName,
    );
    final photoUrl = (ligaPhoto?.isNotEmpty == true)
        ? ligaPhoto!
        : (_isValidHttpUrl(player.profileBigUrl) ? player.profileBigUrl : null);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          child: Row(
            children: [
              // Spielerfoto
              CircleAvatar(
                radius: 22,
                backgroundImage: photoUrl != null
                    ? NetworkImage(photoUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: photoUrl == null
                    ? Icon(Icons.person, color: Colors.grey[600])
                    : null,
              ),
              const SizedBox(width: 10),

              // Spalte 1: Name + Teamname
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fullName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      player.teamName,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Spalte 2: Status-Emoji
              SizedBox(
                width: 28,
                child: Center(
                  child: Text(
                    PlayerStatusHelper.getStatusEmoji(player.status),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Spalte 3: Durchschnitts- und Gesamtpunkte
              SizedBox(
                width: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      player.averagePoints.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${player.totalPoints} ges.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Spalte 4: Marktwert + Trend
              SizedBox(
                width: 76,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '€${_formatValue(player.marketValue)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      PlayerStatusHelper.formatMarketValueTrend(player.tfhmvt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PlayerStatusHelper.getTrendColor(player.tfhmvt),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Sale Toggle
              SizedBox(
                width: 36,
                height: 36,
                child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: isSelectedForSale,
                  onChanged: (value) => onToggleSale(value ?? false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formatiert einen Marktwert für die Anzeige
  /// Konvertiert zu M (Millionen), k (Tausende) oder direkte Zahl
  String _formatValue(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      final kValue = value / 1000;
      return kValue < 10
          ? '${kValue.toStringAsFixed(1)}k'
          : '${kValue.toStringAsFixed(0)}k';
    }
    return value.toString();
  }

  /// Überprüft, ob eine URL gültig für NetworkImage ist
  /// Akzeptiert nur HTTP/HTTPS URLs
  bool _isValidHttpUrl(String url) {
    if (url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }
}
