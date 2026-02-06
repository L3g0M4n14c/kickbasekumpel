import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/presentation/screens/dashboard/dashboard_screen.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(child: const Text('Test Content')),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('should display provided child widget', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(
              child: const Center(child: Text('Dashboard Child')),
            ),
          ),
        ),
      );

      expect(find.text('Dashboard Child'), findsOneWidget);
    });
  });
}
