import 'package:flutter/material.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/presentation/utils/player_status_helper.dart';

/// Spieler-Reihe mit erweiterten Informationen und Verkaufs-Toggle
///
/// Zeigt folgende Informationen pro Spieler:
/// - Foto: Spielerfoto in Kreis (oder Person-Icon als Fallback)
/// - Spalte 1: Vor- + Nachname (groß) + Teamname (klein darunter)
/// - Spalte 2: Status-Emoji (💪 = Fit, 💊 = Fraglich, 🚑 = Verletzt, 🟨 = Gelbe Karte)
/// - Spalte 3: Durchschnittspunkte (groß) + Gesamtpunkte (klein darunter)
/// - Spalte 4: Marktwert + Trend mit Pfeil (↑ grün oder ↓ rot)
class PlayerRowWithSale extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spielerfoto
              CircleAvatar(
                radius: 20,
                backgroundImage: _isValidHttpUrl(player.profileBigUrl)
                    ? NetworkImage(player.profileBigUrl)
                    : null,
                backgroundColor: Colors.grey[300],
                child: !_isValidHttpUrl(player.profileBigUrl)
                    ? Icon(Icons.person, color: Colors.grey[600])
                    : null,
              ),
              const SizedBox(width: 12),

              // Spalte 1: Name + Teamname
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      player.teamName,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Spalte 2: Status-Emoji
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    PlayerStatusHelper.getStatusEmoji(player.status),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              // Spalte 3: Durchschnitts- und Gesamtpunkte
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      player.averagePoints.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${player.totalPoints} gesamt',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Spalte 4: Marktwert + Trend
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '€${_formatValue(player.marketValue)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      PlayerStatusHelper.formatMarketValueTrend(player.tfhmvt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PlayerStatusHelper.getTrendColor(player.tfhmvt),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Sale Toggle
              Checkbox(
                value: isSelectedForSale,
                onChanged: (value) => onToggleSale(value ?? false),
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
