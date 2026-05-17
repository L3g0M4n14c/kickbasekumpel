import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/models/market_model.dart';
import 'package:kickbasekumpel/data/models/player_model.dart';
import 'package:kickbasekumpel/data/models/transfer_planner_model.dart';
import 'package:kickbasekumpel/data/providers/league_providers.dart';
import 'package:kickbasekumpel/data/services/transfer_planner_service.dart';
import 'package:kickbasekumpel/presentation/providers/dashboard_providers.dart';
import 'package:kickbasekumpel/presentation/providers/market_providers.dart';

final transferPlannerServiceProvider = Provider<TransferPlannerService>(
  (ref) => TransferPlannerService(),
);

class TransferPlannerState {
  const TransferPlannerState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
  });

  final bool isLoading;
  final TransferPlannerResult? result;
  final String? errorMessage;

  TransferPlannerState copyWith({
    bool? isLoading,
    TransferPlannerResult? Function()? result,
    String? Function()? errorMessage,
  }) {
    return TransferPlannerState(
      isLoading: isLoading ?? this.isLoading,
      result: result != null ? result() : this.result,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class TransferPlannerNotifier extends Notifier<TransferPlannerState> {
  @override
  TransferPlannerState build() => const TransferPlannerState();

  Future<void> calculate() async {
    await ref.read(autoSelectFirstLeagueProvider.future);

    final leagueId = ref.read(selectedLeagueIdProvider);
    if (leagueId == null) {
      state = const TransferPlannerState(
        errorMessage:
            'Keine Liga ausgewählt. Bitte wähle zuerst eine Liga aus.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: () => null);

    final marketPlayersSubscription = ref
        .listen<AsyncValue<List<MarketPlayer>>>(
          marketPlayersProvider,
          (previous, next) {},
        );

    try {
      final results = await Future.wait<dynamic>([
        ref.read(teamPlayersProvider.future),
        ref.read(teamBudgetProvider.future),
        ref.read(marketPlayersProvider.future),
      ]);

      final squadPlayers = results[0] as List<Player>;
      final currentBudget = results[1] as int;
      final marketPlayers = results[2] as List<MarketPlayer>;

      final plannerInput = TransferPlannerInput(
        squadPlayers: squadPlayers,
        marketPlayers: marketPlayers.map(_mapMarketPlayerToPlayer).toList(),
        currentBudget: currentBudget,
      );

      final plannerService = ref.read(transferPlannerServiceProvider);
      final plannerResult = plannerService.buildPlans(plannerInput);

      state = TransferPlannerState(result: plannerResult);
    } catch (error) {
      state = TransferPlannerState(
        errorMessage: 'Planung fehlgeschlagen: ${_readableErrorMessage(error)}',
      );
    } finally {
      marketPlayersSubscription.close();
    }
  }
}

final transferPlannerProvider =
    NotifierProvider<TransferPlannerNotifier, TransferPlannerState>(
      TransferPlannerNotifier.new,
    );

Player _mapMarketPlayerToPlayer(MarketPlayer marketPlayer) {
  return Player(
    id: marketPlayer.id,
    firstName: marketPlayer.firstName,
    lastName: marketPlayer.lastName,
    profileBigUrl: marketPlayer.profileBigUrl,
    teamName: marketPlayer.teamName,
    teamId: marketPlayer.teamId,
    position: marketPlayer.position,
    number: marketPlayer.number,
    averagePoints: marketPlayer.averagePoints,
    totalPoints: marketPlayer.totalPoints,
    marketValue: marketPlayer.price,
    marketValueTrend: marketPlayer.marketValueTrend,
    tfhmvt: marketPlayer.marketValueTrend,
    prlo: marketPlayer.prlo ?? 0,
    stl: marketPlayer.stl,
    status: marketPlayer.status,
    userOwnsPlayer: false,
  );
}

String _readableErrorMessage(Object error) {
  final raw = error.toString();
  if (raw.startsWith('Exception: ')) {
    return raw.replaceFirst('Exception: ', '');
  }
  return raw;
}
