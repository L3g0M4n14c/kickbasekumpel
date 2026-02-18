import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/presentation/widgets/team/player_row_with_sale.dart';

void main() {
  group('PlayerRowWithSale Widget', () {
    late Player mockPlayer;

    setUp(() {
      mockPlayer = const Player(
        id: 'player123',
        firstName: 'Max',
        lastName: 'Mustermann',
        profileBigUrl: '', // Leer um Netzwerk-Fehler in Tests zu vermeiden
        teamName: 'FC Bayern',
        teamId: 'team123',
        position: 2, // ABW
        number: 5,
        averagePoints: 7.5,
        totalPoints: 150,
        marketValue: 8500000, // 8.5M
        marketValueTrend: 0,
        tfhmvt: 250000, // +250k
        prlo: 0,
        stl: 0,
        status: 0, // Fit
        userOwnsPlayer: true,
      );
    });

    testWidgets('displays player full name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Max Mustermann'), findsOneWidget);
    });

    testWidgets('displays team name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('FC Bayern'), findsOneWidget);
    });

    testWidgets('displays player avatar widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      // CircleAvatar wird angezeigt
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('displays player avatar with person icon when no image url', (
      WidgetTester tester,
    ) async {
      final playerWithoutPhoto = mockPlayer.copyWith(profileBigUrl: '');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: playerWithoutPhoto,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('displays status emoji for fit player', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('💪'), findsOneWidget);
    });

    testWidgets('displays status emoji for injured player', (
      WidgetTester tester,
    ) async {
      final injuredPlayer = mockPlayer.copyWith(status: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: injuredPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('🚑'), findsOneWidget);
    });

    testWidgets('displays average points', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('7.5'), findsOneWidget);
    });

    testWidgets('displays total points', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('150 gesamt'), findsOneWidget);
    });

    testWidgets('displays formatted market value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('€8.5M'), findsOneWidget);
    });

    testWidgets('displays market value trend with up arrow for positive', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('↑ +€250k'), findsOneWidget);
    });

    testWidgets('displays market value trend with down arrow for negative', (
      WidgetTester tester,
    ) async {
      final negativeTrendPlayer = mockPlayer.copyWith(tfhmvt: -100000);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: negativeTrendPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('↓ -€100k'), findsOneWidget);
    });

    testWidgets('checkbox is unchecked by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(
        (find.byType(Checkbox).evaluate().first.widget as Checkbox).value,
        false,
      );
    });

    testWidgets('checkbox is checked when isSelectedForSale is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: true,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(
        (find.byType(Checkbox).evaluate().first.widget as Checkbox).value,
        true,
      );
    });

    testWidgets('calls onToggleSale when checkbox is tapped', (
      WidgetTester tester,
    ) async {
      bool callbackValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (value) {
                callbackValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(callbackValue, true);
    });

    testWidgets('calls onTap callback when card is tapped', (
      WidgetTester tester,
    ) async {
      bool onTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Card));
      await tester.pumpAndSettle();

      expect(onTapCalled, true);
    });

    testWidgets('displays card with correct layout structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerRowWithSale(
              player: mockPlayer,
              isSelectedForSale: false,
              onToggleSale: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('handles long player names with ellipsis', (
      WidgetTester tester,
    ) async {
      final longNamePlayer = mockPlayer.copyWith(
        firstName: 'Very Very Very Long First',
        lastName: 'Name That Is Extremely Long',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              child: PlayerRowWithSale(
                player: longNamePlayer,
                isSelectedForSale: false,
                onToggleSale: (_) {},
              ),
            ),
          ),
        ),
      );

      // Widget should render without overflow
      expect(find.byType(PlayerRowWithSale), findsOneWidget);
    });
  });
}
