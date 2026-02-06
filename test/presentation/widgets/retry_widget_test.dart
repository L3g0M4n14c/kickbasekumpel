import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/presentation/widgets/common/retry_widget.dart';

void main() {
  group('RetryWidget', () {
    const testMessage = 'Verbindungsfehler';

    testWidgets('should display message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(message: testMessage, onRetry: () {}),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should call onRetry when button is pressed', (tester) async {
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(
              message: testMessage,
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Erneut versuchen'));
      await tester.pump();

      expect(retryPressed, true);
    });

    testWidgets('should display retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(message: testMessage, onRetry: () {}),
          ),
        ),
      );

      expect(find.text('Erneut versuchen'), findsOneWidget);
    });

    testWidgets('should display refresh icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(message: testMessage, onRetry: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.refresh), findsAtLeastNWidgets(1));
    });

    testWidgets('should center the content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RetryWidget(message: testMessage, onRetry: () {}),
          ),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });
  });
}
