import 'package:flutter/material.dart';

/// Helper-Funktionen für Player-Status-Darstellung
class PlayerStatusHelper {
  /// Maps Player-Status-Integer zu einem Emoji
  ///
  /// Status-Werte:
  /// - 0: Fit (💪)
  /// - 1: Fraglich/Angeschlagen (💊)
  /// - 2: Verletzt (🚑)
  /// - 32: Gelbe Karte (🟨)
  /// - default: Unbekannt (❓)
  static String getStatusEmoji(int status) {
    switch (status) {
      case 0:
        return '💪'; // Fit
      case 1:
        return '💊'; // Fraglich/Angeschlagen
      case 2:
        return '🚑'; // Verletzt
      case 32:
        return '🟨'; // Gelbe Karte
      default:
        return '❓'; // Unbekannt
    }
  }

  /// Maps Player-Status-Integer zu einer deutschen Beschreibung
  static String getStatusName(int status) {
    switch (status) {
      case 0:
        return 'Fit';
      case 1:
        return 'Fraglich';
      case 2:
        return 'Verletzt';
      case 32:
        return 'Gelbe Karte';
      default:
        return 'Unbekannt';
    }
  }

  /// Liefert die Farbe für einen Player-Status
  static Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      case 32:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  /// Formatiert die Marktwertsteigerung/-verlust als Zeichenkette
  ///
  /// Eingabe: marketValueTrend als Integer (z.B. 5000 = €5k)
  /// Rückgabe: Formatierter String mit Pfeil und Betrag (z.B. "↑ +€5k" oder "↓ -€3k")
  static String formatMarketValueTrend(int trend) {
    if (trend == 0) {
      return '→ €0';
    }

    final isPositive = trend > 0;
    final absoluteTrend = trend.abs();

    // Konvertiere zu M (Millionen), k (Tausende) oder direkte Zahl
    String formattedValue;
    if (absoluteTrend >= 1000000) {
      final mValue = absoluteTrend / 1000000;
      // Entferne Dezimalstellen wenn ganzzahlig
      if (mValue == mValue.toInt()) {
        formattedValue = '€${mValue.toInt()}M';
      } else {
        formattedValue = '€${mValue.toStringAsFixed(1)}M';
      }
    } else if (absoluteTrend >= 1000) {
      final kValue = absoluteTrend / 1000;
      // Entferne Dezimalstellen wenn ganzzahlig
      if (kValue == kValue.toInt()) {
        formattedValue = '€${kValue.toInt()}k';
      } else {
        formattedValue = '€${kValue.toStringAsFixed(1)}k';
      }
    } else {
      formattedValue = '€$absoluteTrend';
    }

    final arrow = isPositive ? '↑' : '↓';
    final sign = isPositive ? '+' : '-';

    return '$arrow $sign$formattedValue';
  }

  /// Liefert die Farbe für die Marktwertsteigerung/-verlust
  static Color getTrendColor(int trend) {
    if (trend > 0) {
      return Colors.green;
    } else if (trend < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}
