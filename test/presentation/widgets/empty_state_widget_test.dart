import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/presentation/widgets/common/empty_state_widget.dart';

void main() {
  group('EmptyStateWidget', () {
    const testMessage = 'Keine Daten verfügbar';
    const testDescription = 'Es wurden keine Einträge gefunden';

    testWidgets('should display message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(message: testMessage, icon: Icons.inbox),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should display details when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              message: testMessage,
              icon: Icons.inbox,
              details: testDescription,
            ),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
    });

    testWidgets('should display action button when provided', (tester) async {
      var actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              message: testMessage,
              icon: Icons.inbox,
              actionLabel: 'Aktion',
              onAction: () => actionPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Aktion'), findsOneWidget);

      await tester.tap(find.text('Aktion'));
      await tester.pump();

      expect(actionPressed, true);
    });

    testWidgets('should display custom icon when provided', (tester) async {
      const customIcon = Icons.inbox;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(message: testMessage, icon: customIcon),
          ),
        ),
      );

      expect(find.byIcon(customIcon), findsOneWidget);
    });

    testWidgets('should display provided icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              message: testMessage,
              icon: Icons.inbox_outlined,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('should center the content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(message: testMessage, icon: Icons.inbox),
          ),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });
  });
}
