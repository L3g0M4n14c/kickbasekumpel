import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kickbasekumpel/data/models/common_models.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/providers/bid_limit_providers.dart';
import 'package:kickbasekumpel/data/providers/bid_recommendation_providers.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/providers/user_providers.dart';
import 'package:kickbasekumpel/data/services/bid_limit_service.dart';
import 'package:kickbasekumpel/data/services/bid_recommendation_service.dart';
import 'package:kickbasekumpel/data/services/budget_calculation_service.dart';
import 'package:kickbasekumpel/presentation/widgets/market/buy_player_bottom_sheet.dart';

MarketPlayer _player({int price = 4200000}) {
  return MarketPlayer(
    id: 'p1',
    firstName: 'Max',
    lastName: 'Mustermann',
    profileBigUrl: 'https://example.com/p.png',
    teamName: 'FC Test',
    teamId: 'team1',
    position: 1,
    number: 1,
    averagePoints: 5.0,
    totalPoints: 50,
    marketValue: 4000000,
    marketValueTrend: 0,
    price: price,
    expiry: '2026-02-27T00:00:00Z',
    offers: 0,
    seller: MarketSeller(id: 's1', name: 'Seller'),
    stl: 0,
    status: 0,
    exs: 0,
  );
}

BidRecommendation _recommendation() {
  return const BidRecommendation(
    amount: 5000000,
    minimumBid: 4200000,
    premium: 1.25,
    sampleSize: 12,
    method: 'quartile',
    confidence: 0.8,
    scope: 'letzte 90 Tage',
  );
}

void main() {
  Future<void> pumpSheet(
    WidgetTester tester, {
    CompetitorBudgetHint hint = const CompetitorBudgetHint(
      managersWithHigherBudget: 0,
      maxCompetitorBudget: 0,
    ),
    List<int>? observedBids,
    BidLimit? bidLimit,
    bool loadRecommendation = true,
    List<int>? recommendationRequests,
  }) async {
    final limit =
        bidLimit ??
        const BidLimitService().calculate(
          budget: 25000000,
          teamValue: 90000000,
        );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedLeagueIdProvider.overrideWithValue('league-1'),
          currentAuthUserIdProvider.overrideWithValue('manager-me'),
          currentUserProvider.overrideWith((ref) async => null),
          bidLimitProvider.overrideWith((ref, params) async => limit),
          recommendedBidProvider.overrideWith(
            (ref, params) async {
              recommendationRequests?.add(params.minimumBid);
              return _recommendation();
            },
          ),
          competitorBudgetHintProvider.overrideWith((ref, params) {
            observedBids?.add(params.bidAmount);
            return AsyncValue<CompetitorBudgetHint>.data(hint);
          }),
        ],
        child: MaterialApp(
          home: Scaffold(body: BuyPlayerBottomSheet(player: _player())),
        ),
      ),
    );
    await tester.pump();
    if (loadRecommendation) {
      // Die Empfehlung lädt nur auf Knopfdruck (Rate-Limit)
      await tester.ensureVisible(find.text('Gebotsempfehlung berechnen'));
      await tester.tap(find.text('Gebotsempfehlung berechnen'));
    }
    // Empfehlung und Hinweis sind async geladen
    await tester.pump();
    await tester.pump();
    await tester.pump();
  }

  group('BuyPlayerBottomSheet Gebotsempfehlung', () {
    testWidgets('lädt die Empfehlung erst auf Knopfdruck', (tester) async {
      final requests = <int>[];
      await pumpSheet(
        tester,
        loadRecommendation: false,
        recommendationRequests: requests,
      );

      expect(requests, isEmpty);
      expect(find.textContaining('Empfohlen:'), findsNothing);
      expect(find.text('Gebotsempfehlung berechnen'), findsOneWidget);

      await tester.ensureVisible(find.text('Gebotsempfehlung berechnen'));
      await tester.tap(find.text('Gebotsempfehlung berechnen'));
      await tester.pump();
      await tester.pump();

      expect(requests, isNotEmpty);
      expect(find.textContaining('Empfohlen:'), findsOneWidget);
      expect(find.text('Gebotsempfehlung berechnen'), findsNothing);
    });
  });

  group('BuyPlayerBottomSheet Konkurrenz-Budget-Hinweis', () {
    testWidgets('Gebots-Card zeigt den Hinweis inkl. max. Budget', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        hint: const CompetitorBudgetHint(
          managersWithHigherBudget: 3,
          maxCompetitorBudget: 6800000,
        ),
      );
      await tester.ensureVisible(find.text('Konkurrenz-Budgets prüfen'));
      await tester.tap(find.text('Konkurrenz-Budgets prüfen'));
      await tester.pump();

      expect(find.byType(CachedNetworkImage), findsOneWidget);
      expect(
        find.text(
          'Dein Gebot 4.20M € – 3 Manager haben mehr Budget, '
          'max. Konkurrenz-Budget: 6.80M €',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Hinweis entfällt, wenn kein Mitbieter mehr Budget hat', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        hint: const CompetitorBudgetHint(
          managersWithHigherBudget: 0,
          maxCompetitorBudget: 6800000,
        ),
      );

      // Die Empfehlung bleibt sichtbar, nur der Hinweis entfällt
      expect(find.textContaining('Empfohlen:'), findsOneWidget);
      expect(find.textContaining('mehr Budget'), findsNothing);
    });

    testWidgets('der Hinweis folgt dem eingegebenen Gebot', (tester) async {
      final observedBids = <int>[];
      await pumpSheet(
        tester,
        hint: const CompetitorBudgetHint(
          managersWithHigherBudget: 1,
          maxCompetitorBudget: 6800000,
        ),
        observedBids: observedBids,
      );
      await tester.ensureVisible(find.text('Konkurrenz-Budgets prüfen'));
      await tester.tap(find.text('Konkurrenz-Budgets prüfen'));
      await tester.pump();

      expect(observedBids, contains(4200000)); // Startgebot = Angebotspreis

      await tester.enterText(find.byType(TextFormField), '5.00');
      await tester.pump();

      expect(observedBids.last, 5000000);
    });

    testWidgets('Singular bei genau einem budgetstärkeren Mitbieter', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        hint: const CompetitorBudgetHint(
          managersWithHigherBudget: 1,
          maxCompetitorBudget: 6800000,
        ),
      );
      await tester.ensureVisible(find.text('Konkurrenz-Budgets prüfen'));
      await tester.tap(find.text('Konkurrenz-Budgets prüfen'));
      await tester.pump();

      expect(find.textContaining('1 Manager hat mehr Budget'), findsOneWidget);
    });
  });

  group('BuyPlayerBottomSheet Budget & 33 %-Regel', () {
    testWidgets('zeigt echtes Budget, Minus-Rahmen und max. Gebot', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        bidLimit: const BidLimitService().calculate(
          budget: 25000000,
          teamValue: 90000000,
          pendingOffers: 5000000,
        ),
      );

      expect(find.text('25.00M €'), findsOneWidget); // Budget
      expect(find.text('−5.00M €'), findsOneWidget); // offene Gebote
      expect(find.text('90.00M €'), findsOneWidget); // Teamwert
      expect(find.text('−30.00M €'), findsOneWidget); // max. Minus
      expect(find.text('50.00M €'), findsOneWidget); // max. Gebot
    });

    testWidgets('Gebot ins Minus innerhalb der Grenze ist erlaubt', (
      tester,
    ) async {
      await pumpSheet(tester);

      await tester.enterText(find.byType(TextFormField), '40.00');
      await tester.pump();

      expect(find.text('-15.00M €'), findsOneWidget); // Kontostand danach
      expect(
        find.textContaining('bis zum Spieltag wieder ausgeglichen'),
        findsOneWidget,
      );
    });

    testWidgets('Gebot über der Grenze wird abgelehnt', (tester) async {
      await pumpSheet(tester);

      await tester.enterText(find.byType(TextFormField), '60.00');
      await tester.pump();
      await tester.ensureVisible(find.text('Gebot abgeben'));
      await tester.tap(find.text('Gebot abgeben'));
      await tester.pump();

      expect(find.textContaining('Max. Gebot: 55.00M €'), findsOneWidget);
    });
  });
}
