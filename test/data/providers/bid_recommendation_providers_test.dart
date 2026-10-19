import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kickbasekumpel/data/providers/bid_recommendation_providers.dart';
import 'package:kickbasekumpel/data/providers/budget_calculation_providers.dart';
import 'package:kickbasekumpel/data/providers/kickbase_api_provider.dart';
import 'package:kickbasekumpel/data/providers/user_providers.dart';
import 'package:kickbasekumpel/data/services/budget_calculation_service.dart';

import '../../helpers/mock_firebase.dart';

void main() {
  group('recommendedBidProvider', () {
    late MockKickbaseAPIClient mockApiClient;
    late ProviderContainer container;

    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      container = ProviderContainer(
        overrides: [
          kickbaseApiClientProvider.overrideWithValue(mockApiClient),
          currentAuthUserIdProvider.overrideWithValue('manager-me'),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('uses competitor purchase premiums for the recommended bid', () async {
      // Arrange
      when(() => mockApiClient.getLeagueRanking('league-1')).thenAnswer(
        (_) async => {
          'us': [
            {'i': 'manager-me'},
            {'i': 'manager-1'},
          ],
        },
      );
      when(
        () => mockApiClient.getManagerTransferHistory('league-1', 'manager-1'),
      ).thenAnswer(
        (_) async => {
          'u': 'manager-1',
          'unm': 'Konkurrent',
          'it': [
            {
              'dt': '2025-01-15T12:00:00.000Z',
              'pi': 'past-player',
              'pn': 'Vergangener Spieler',
              'tid': 'transfer-1',
              'trp': 13000000,
              'tty': 1,
            },
          ],
        },
      );
      when(
        () => mockApiClient.getPlayerMarketValue(
          'league-1',
          'past-player',
          timeframe: any(named: 'timeframe'),
        ),
      ).thenAnswer(
        (_) async => {
          'it': [
            {'dt': 1736812800000, 'mv': 10000000},
          ],
        },
      );

      // Act
      final bid = await container.read(
        recommendedBidProvider((
          leagueId: 'league-1',
          currentMarketValue: 10000000,
          minimumBid: 10500000,
        )).future,
      );

      // Assert: Ein einzelner Kauf -> Median-Pfad, Aufschlag 1.3
      expect(bid.amount, 13000000);
    });

    test('fetches league data only once for different players', () async {
      // Arrange
      when(() => mockApiClient.getLeagueRanking('league-1')).thenAnswer(
        (_) async => {
          'us': [
            {'i': 'manager-me'},
            {'i': 'manager-1'},
          ],
        },
      );
      when(
        () => mockApiClient.getManagerTransferHistory('league-1', 'manager-1'),
      ).thenAnswer(
        (_) async => {
          'u': 'manager-1',
          'unm': 'Konkurrent',
          'it': [
            {
              'dt': '2025-01-15T12:00:00.000Z',
              'pi': 'past-player',
              'pn': 'Vergangener Spieler',
              'tid': 'transfer-1',
              'trp': 13000000,
              'tty': 1,
            },
          ],
        },
      );
      when(
        () => mockApiClient.getPlayerMarketValue(
          'league-1',
          'past-player',
          timeframe: any(named: 'timeframe'),
        ),
      ).thenAnswer(
        (_) async => {
          'it': [
            {'dt': 1736812800000, 'mv': 10000000},
          ],
        },
      );

      // Act: zwei Spieler mit unterschiedlichen Marktwerten abfragen
      final bidPlayerA = await container.read(
        recommendedBidProvider((
          leagueId: 'league-1',
          currentMarketValue: 10000000,
          minimumBid: 10500000,
        )).future,
      );
      final bidPlayerB = await container.read(
        recommendedBidProvider((
          leagueId: 'league-1',
          currentMarketValue: 25000000,
          minimumBid: 20000000,
        )).future,
      );

      // Assert: Liga-Daten werden nur einmal geladen und gecacht
      verify(() => mockApiClient.getLeagueRanking('league-1')).called(1);
      verify(
        () => mockApiClient.getManagerTransferHistory('league-1', 'manager-1'),
      ).called(1);
      verify(
        () => mockApiClient.getPlayerMarketValue(
          'league-1',
          'past-player',
          timeframe: any(named: 'timeframe'),
        ),
      ).called(1);
      expect(bidPlayerA.amount, 13000000);
      expect(bidPlayerB.amount, 32500000);
    });
  });

  group('competitorBudgetHintProvider', () {
    late MockKickbaseAPIClient mockApiClient;
    late ProviderContainer container;

    // Budgets der Mitbieter: Startbudget 50 M€ ± Transfers + Anmeldebonus.
    // Der Bonus hängt vom Laufdatum ab und wird deshalb mit derselben
    // Service-Logik erwartet wie in der Budget-Berechnung.
    late int loginBonus;
    late int strongBudget; // manager-1: +20 M€ Verkauf
    late int weakBudget; // manager-2: -30 M€ Kauf

    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      container = ProviderContainer(
        overrides: [
          kickbaseApiClientProvider.overrideWithValue(mockApiClient),
          currentAuthUserIdProvider.overrideWithValue('manager-me'),
        ],
      );
      loginBonus = BudgetCalculationService().calculateLoginBonus(
        seasonStart: kLeagueSeasonStartDate,
      );
      strongBudget = 50000000 + 20000000 + loginBonus;
      weakBudget = 50000000 - 30000000 + loginBonus;

      when(() => mockApiClient.getLeagueRanking('league-1')).thenAnswer(
        (_) async => {
          'us': [
            {'i': 'manager-me'},
            {'i': 'manager-1'},
            {'i': 'manager-2'},
          ],
        },
      );
      // Kein `ptspf` -> Auto-Verkauf (250er-Regel) inaktiv.
      when(() => mockApiClient.getLeagueOverview('league-1'))
          .thenAnswer((_) async => <String, dynamic>{});

      // Eigener Manager hat ein üppiges Budget – muss als kein Mitbieter
      // ignoriert werden.
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-me',
          since: any(named: 'since'),
        ),
      ).thenAnswer(
        (_) async => {
          'u': 'manager-me',
          'unm': 'Ich',
          'it': [
            {
              'tid': 't-me',
              'pi': 'p-me',
              'pn': 'Eigener Spieler',
              'trp': 100000000,
              'tty': 2,
              'dt': '2026-09-01T12:00:00.000Z',
            },
          ],
        },
      );

      when(() => mockApiClient.getManagerDashboard('league-1', 'manager-1'))
          .thenAnswer((_) async => {'userName': 'Konkurrent Stark'});
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-1',
          since: any(named: 'since'),
        ),
      ).thenAnswer(
        (_) async => {
          'u': 'manager-1',
          'unm': 'Konkurrent Stark',
          'it': [
            {
              'tid': 't-1',
              'pi': 'p-1',
              'pn': 'Verkaufter Spieler',
              'trp': 20000000,
              'tty': 2,
              'dt': '2026-09-01T12:00:00.000Z',
            },
          ],
        },
      );

      when(() => mockApiClient.getManagerDashboard('league-1', 'manager-2'))
          .thenAnswer((_) async => {'userName': 'Konkurrent Schwach'});
      when(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-2',
          since: any(named: 'since'),
        ),
      ).thenAnswer(
        (_) async => {
          'u': 'manager-2',
          'unm': 'Konkurrent Schwach',
          'it': [
            {
              'tid': 't-2',
              'pi': 'p-2',
              'pn': 'Gekaufter Spieler',
              'trp': 30000000,
              'tty': 1,
              'dt': '2026-09-02T12:00:00.000Z',
            },
          ],
        },
      );
    });

    tearDown(() => container.dispose());

    test('vergleicht das Gebot mit den Budgets aller Mitbieter', () async {
      // Gebot liegt zwischen weakBudget und strongBudget
      await container.read(leagueCompetitorBudgetsProvider('league-1').future);
      final hint = container
          .read(
            competitorBudgetHintProvider((
              leagueId: 'league-1',
              bidAmount: weakBudget + 10000000,
            )),
          )
          .asData!
          .value;

      expect(hint.managersWithHigherBudget, 1); // nur manager-1
      expect(hint.maxCompetitorBudget, strongBudget);
      expect(hint.hasHigherBudgetCompetitors, isTrue);
    });

    test('Hinweis entfällt oberhalb aller Mitbieter-Budgets', () async {
      // Auch das üppige Budget des eigenen Managers zählt nicht mit.
      await container.read(leagueCompetitorBudgetsProvider('league-1').future);
      final hint = container
          .read(
            competitorBudgetHintProvider((
              leagueId: 'league-1',
              bidAmount: strongBudget + 10000000,
            )),
          )
          .asData!
          .value;

      expect(hint.managersWithHigherBudget, 0);
      expect(hint.hasHigherBudgetCompetitors, isFalse);
    });

    test('folgt sofort einer Gebotsänderung ohne erneutes Laden', () async {
      final lowBid = container.read(
        competitorBudgetHintProvider((
          leagueId: 'league-1',
          bidAmount: weakBudget + 10000000,
        )),
      );
      // Erstes Lesen startet das Laden der Budgets
      await container.read(leagueCompetitorBudgetsProvider('league-1').future);

      final hintLow = container
          .read(
            competitorBudgetHintProvider((
              leagueId: 'league-1',
              bidAmount: weakBudget + 10000000,
            )),
          )
          .asData!
          .value;
      final hintHigh = container
          .read(
            competitorBudgetHintProvider((
              leagueId: 'league-1',
              bidAmount: strongBudget + 10000000,
            )),
          )
          .asData!
          .value;

      expect(lowBid.hasValue, isFalse); // noch am Laden
      expect(hintLow.managersWithHigherBudget, 1);
      expect(hintHigh.managersWithHigherBudget, 0);

      // Die Budgets werden pro Liga nur einmal geladen
      verify(
        () => mockApiClient.getManagerTransferHistoryPaged(
          'league-1',
          'manager-1',
          since: any(named: 'since'),
        ),
      ).called(1);
    });
  });
}
