import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/presentation/screens/dashboard/market_screen.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';
import 'package:kickbasekumpel/data/providers/transfer_providers.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';

void main() {
  group('MarketScreen', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.text('Transfermarkt'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display search field', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Spieler suchen...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display TabBar with 4 tabs', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(Tab), findsNWidgets(4));
    });

    testWidgets('should display "Verfügbar" tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.text('Verfügbar'), findsOneWidget);
    });

    testWidgets('should display "Meine Verkäufe" tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.text('Meine Verkäufe'), findsOneWidget);
    });

    testWidgets('should display "Transfers" tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.text('Transfers'), findsOneWidget);
    });

    testWidgets('should display "Merkliste" tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.text('Merkliste'), findsOneWidget);
    });

    testWidgets('should update search text', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'Messi');
      await tester.pump();

      // Verify text was entered
      expect(find.text('Messi'), findsOneWidget);
    });

    testWidgets('should show filter icon button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should show sort icon button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: MarketScreen())),
      );

      expect(find.byIcon(Icons.sort), findsOneWidget);
    });
  });
}
