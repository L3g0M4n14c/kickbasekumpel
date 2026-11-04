import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/bid_limit_service.dart';
import 'kickbase_api_provider.dart';
import 'league_detail_providers.dart';

/// Provider für die reine Gebotsgrenzen-Berechnung.
final bidLimitServiceProvider = Provider<BidLimitService>(
  (ref) => const BidLimitService(),
);

/// Summe der Marktwerte des eigenen Kaders (= Teamwert für die 33 %-Regel).
///
/// Quelle: `GET /v4/leagues/{id}/squad` → `it[].mv`. Fallback auf `tv` aus
/// der Budget-Antwort (Demo-Modus liefert ihn dort).
final myTeamValueProvider = FutureProvider.autoDispose.family<int, String>((
  ref,
  leagueId,
) async {
  final squad = await ref.watch(mySquadProvider(leagueId).future);
  final players = (squad['it'] as List<dynamic>? ?? const [])
      .whereType<Map<String, dynamic>>();
  final sum = players.fold<int>(
    0,
    (total, player) => total + _asInt(player['mv'] ?? player['marketValue']),
  );
  if (sum > 0) return sum;
  final budget = await ref.watch(myBudgetProvider(leagueId).future);
  return _asInt(budget['tv'] ?? budget['teamValue']);
});

/// Echter Kontostand der Liga (`b` aus `GET /v4/leagues/{id}/me/budget`).
final myLeagueBudgetProvider = FutureProvider.autoDispose.family<int, String>((
  ref,
  leagueId,
) async {
  final budget = await ref.watch(myBudgetProvider(leagueId).future);
  return _asInt(budget['b'] ?? budget['budget']);
});

/// Gebotsgrenze für ein Gebot auf [playerId] in [leagueId].
///
/// Kombiniert Kontostand, Teamwert und alle eigenen offenen Gebote
/// (`uop` in der Marktliste, ohne den Spieler selbst – ein neues Gebot
/// ersetzt das bestehende).
final bidLimitProvider = FutureProvider.autoDispose
    .family<BidLimit, ({String leagueId, String playerId})>((ref, args) async {
      final service = ref.watch(bidLimitServiceProvider);
      final apiClient = ref.watch(kickbaseApiClientProvider);

      final budget = await ref.watch(
        myLeagueBudgetProvider(args.leagueId).future,
      );
      final teamValue = await ref.watch(
        myTeamValueProvider(args.leagueId).future,
      );
      final market = await apiClient.getMarketAvailable(args.leagueId);
      final pendingOffers = service.sumOpenOffers(
        market.map((p) => (playerId: p.id, ownOfferPrice: p.ownOfferPrice)),
        excludePlayerId: args.playerId,
      );

      return service.calculate(
        budget: budget,
        teamValue: teamValue,
        pendingOffers: pendingOffers,
      );
    });

int _asInt(Object? value) => switch (value) {
  int value => value,
  num value => value.toInt(),
  String value => int.tryParse(value) ?? (double.tryParse(value)?.toInt() ?? 0),
  _ => 0,
};
