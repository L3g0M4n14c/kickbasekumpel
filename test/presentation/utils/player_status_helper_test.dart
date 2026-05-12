import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/presentation/utils/player_status_helper.dart';
import 'package:flutter/material.dart';

void main() {
  group('PlayerStatusHelper', () {
    group('getStatusEmoji', () {
      test('returns 💪 for status 0 (Fit)', () {
        expect(PlayerStatusHelper.getStatusEmoji(0), '💪');
      });

      test('returns ❌ for status 1 (Verletzt)', () {
        expect(PlayerStatusHelper.getStatusEmoji(1), '❌');
      });

      test('returns 💊 for status 2 (Angeschlagen)', () {
        expect(PlayerStatusHelper.getStatusEmoji(2), '💊');
      });

      test('returns 🟨 for status 32 (Gelbe Karte)', () {
        expect(PlayerStatusHelper.getStatusEmoji(32), '🟨');
      });

      test('returns ✈️ for status 256 (Abwesend)', () {
        expect(PlayerStatusHelper.getStatusEmoji(256), '✈️');
      });

      test('returns ❓ for unknown status', () {
        expect(PlayerStatusHelper.getStatusEmoji(-1), '❓');
        expect(PlayerStatusHelper.getStatusEmoji(99), '❓');
      });
    });

    group('getStatusName', () {
      test('returns "Fit" for status 0', () {
        expect(PlayerStatusHelper.getStatusName(0), 'Fit');
      });

      test('returns "Verletzt" for status 1', () {
        expect(PlayerStatusHelper.getStatusName(1), 'Verletzt');
      });

      test('returns "Angeschlagen" for status 2', () {
        expect(PlayerStatusHelper.getStatusName(2), 'Angeschlagen');
      });

      test('returns "Gelbsperre" for status 32', () {
        expect(PlayerStatusHelper.getStatusName(32), 'Gelbsperre');
      });

      test('returns "Abwesend" for status 256', () {
        expect(PlayerStatusHelper.getStatusName(256), 'Abwesend');
      });

      test('returns "Unbekannt" for unknown status', () {
        expect(PlayerStatusHelper.getStatusName(-1), 'Unbekannt');
        expect(PlayerStatusHelper.getStatusName(99), 'Unbekannt');
      });
    });

    group('getStatusColor', () {
      test('returns green for status 0 (Fit)', () {
        expect(PlayerStatusHelper.getStatusColor(0), Colors.green);
      });

      test('returns red for status 1 (Verletzt)', () {
        expect(PlayerStatusHelper.getStatusColor(1), Colors.red);
      });

      test('returns orange for status 2 (Angeschlagen)', () {
        expect(PlayerStatusHelper.getStatusColor(2), Colors.orange);
      });

      test('returns yellow for status 32 (Gelbe Karte)', () {
        expect(PlayerStatusHelper.getStatusColor(32), Colors.yellow);
      });

      test('returns grey for status 256 (Abwesend)', () {
        expect(PlayerStatusHelper.getStatusColor(256), Colors.grey);
      });

      test('returns grey for unknown status', () {
        expect(PlayerStatusHelper.getStatusColor(-1), Colors.grey);
        expect(PlayerStatusHelper.getStatusColor(99), Colors.grey);
      });
    });

    group('formatMarketValueTrend', () {
      test('returns formatted string for positive trend', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(5000);
        expect(result, '↑ +€5k');
      });

      test('returns formatted string for negative trend', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(-3000);
        expect(result, '↓ -€3k');
      });

      test('returns centered arrow for zero trend', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(0);
        expect(result, '→ €0');
      });

      test('formats small positive values without k', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(500);
        expect(result, '↑ +€500');
      });

      test('formats large positive values with M', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(1500000);
        expect(result, '↑ +€1.5M');
      });

      test('formats large negative values with M', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(-2000000);
        expect(result, '↓ -€2M');
      });

      test('formats edge case 1000', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(1000);
        expect(result, '↑ +€1k');
      });

      test('formats edge case 999', () {
        final result = PlayerStatusHelper.formatMarketValueTrend(999);
        expect(result, '↑ +€999');
      });
    });

    group('getTrendColor', () {
      test('returns green for positive trend', () {
        expect(PlayerStatusHelper.getTrendColor(100), Colors.green);
        expect(PlayerStatusHelper.getTrendColor(5000), Colors.green);
      });

      test('returns red for negative trend', () {
        expect(PlayerStatusHelper.getTrendColor(-100), Colors.red);
        expect(PlayerStatusHelper.getTrendColor(-5000), Colors.red);
      });

      test('returns grey for zero trend', () {
        expect(PlayerStatusHelper.getTrendColor(0), Colors.grey);
      });
    });
  });
}
