import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/services/manager_transfer_history_service.dart';
import 'package:kickbasekumpel/presentation/widgets/cards/demand_hint_card.dart';

void main() {
  group('DemandHintCard', () {
    testWidgets('zeigt Nachfrage-Intensität und aktuelles Zeitfenster', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DemandHintCard(
              profile: _profile(intensity: DemandIntensity.high),
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.textContaining('Verkaufs-Timing: Nachfrage hoch'),
        findsOneWidget,
      );
      expect(find.textContaining('Sonntag, 18-24 Uhr'), findsOneWidget);
      expect(find.textContaining('6 Käufe'), findsOneWidget);
      expect(
        find.textContaining('42 Käufe der Liga seit 20.09.2026'),
        findsOneWidget,
      );
    });

    testWidgets('zeigt mittlere Nachfrage mit Handlungsempfehlung', (
      tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DemandHintCard(
              profile: _profile(intensity: DemandIntensity.medium),
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.textContaining('Verkaufs-Timing: Nachfrage mittel'),
        findsOneWidget,
      );
      expect(
        find.textContaining('keinen klaren Timing-Vorteil'),
        findsOneWidget,
      );
    });

    testWidgets('zeigt niedrige Nachfrage mit Wartehinweis', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DemandHintCard(
              profile: _profile(intensity: DemandIntensity.low),
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.textContaining('Verkaufs-Timing: Nachfrage niedrig'),
        findsOneWidget,
      );
      expect(find.textContaining('besser etwas abwarten'), findsOneWidget);
    });

    testWidgets('entfällt bei zu wenigen Daten', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DemandHintCard(profile: _profile(intensity: null)),
          ),
        ),
      );

      // Assert: kein Hinweis, kein Platzhalter-Abstand.
      expect(find.textContaining('Verkaufs-Timing'), findsNothing);
      expect(find.byType(Card), findsNothing);
    });
  });
}

TransferDemandProfile _profile({required DemandIntensity? intensity}) {
  return TransferDemandProfile(
    purchasesByWindow: const {},
    totalPurchases: 42,
    oldestPurchase: DateTime(2026, 9, 20),
    currentWindow: const DemandWindow(weekday: 7, slot: DemandTimeSlot.evening),
    currentWindowPurchases: 6,
    averagePurchasesPerWindow: 1.5,
    intensity: intensity,
  );
}
