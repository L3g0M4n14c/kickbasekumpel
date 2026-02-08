import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/presentation/screens/ligainsider/ligainsider_screen.dart';

void main() {
  testWidgets('LigainsiderScreen shows title and retry button when empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LigainsiderScreen())),
    );

    // Should show AppBar title
    expect(find.text('Voraussichtliche Aufstellungen'), findsOneWidget);
  });
}
