import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/presentation/widgets/common/error_widget.dart';

void main() {
  group('AppErrorWidget', () {
    const testMessage = 'Ein Fehler ist aufgetreten';
    const testDetails = 'Details zum Fehler';

    testWidgets('should display error message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: testMessage)),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should display details when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(message: testMessage, details: testDetails),
          ),
        ),
      );

      expect(find.text(testMessage), findsOneWidget);
      expect(find.text(testDetails), findsOneWidget);
    });

    testWidgets('should display retry button when onRetry is provided', (
      tester,
    ) async {
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(
              message: testMessage,
              onRetry: () => retryPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Erneut versuchen'), findsOneWidget);

      await tester.tap(find.text('Erneut versuchen'));
      await tester.pump();

      expect(retryPressed, true);
    });

    testWidgets('should not display retry button when onRetry is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: testMessage)),
        ),
      );

      expect(find.text('Erneut versuchen'), findsNothing);
    });

    testWidgets('should display custom icon when provided', (tester) async {
      const customIcon = Icons.cloud_off;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(message: testMessage, icon: customIcon),
          ),
        ),
      );

      expect(find.byIcon(customIcon), findsOneWidget);
    });

    testWidgets('should display default error icon when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: testMessage)),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should use compact mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppErrorWidget(message: testMessage, compact: true),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.widgetWithText(Padding, testMessage).first,
      );
      expect((padding.padding as EdgeInsets).top, 16);
    });

    testWidgets('should use normal mode by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: testMessage)),
        ),
      );

      final padding = tester.widget<Padding>(
        find.widgetWithText(Padding, testMessage).first,
      );
      expect((padding.padding as EdgeInsets).top, 32);
    });

    testWidgets('should center the content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppErrorWidget(message: testMessage)),
        ),
      );

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });
  });
}
