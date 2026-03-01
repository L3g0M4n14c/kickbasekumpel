import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/league_model.dart';
import '../../domain/exceptions/kickbase_exceptions.dart';
import '../../domain/repositories/repository_interfaces.dart';
import 'repository_providers.dart';
import 'user_providers.dart';
import 'kickbase_auth_provider.dart';
import 'kickbase_api_provider.dart';

// ============================================================================
// LEAGUE STREAM PROVIDERS
// ============================================================================

/// All Leagues Stream Provider
/// Provides real-time updates of all leagues
/// Use sparingly - prefer user-specific leagues
final allLeaguesStreamProvider = StreamProvider<List<League>>((ref) async* {
  final leagueRepo = ref.watch(leagueRepositoryProvider);

  await for (final result in leagueRepo.watchAll()) {
    if (result is Success<List<League>>) {
      yield result.data;
    } else if (result is Failure<List<League>>) {
      throw Exception((result).message);
    }
  }
});

/// User Leagues Stream Provider
/// Provides real-time updates of leagues for the current user
/// Automatically updates when user changes
final userLeaguesStreamProvider = StreamProvider<List<League>>((ref) async* {
  final userId = ref.watch(currentAuthUserIdProvider);

  if (userId == null) {
    yield [];
    return;
  }

  final leagueRepo = ref.watch(leagueRepositoryProvider);
  final result = await leagueRepo.getByUserId(userId);

  if (result is Success<List<League>>) {
    yield result.data;
  } else if (result is Failure<List<League>>) {
    throw Exception((result).message);
  }
});

/// Leagues Provider (FutureProvider version)
/// Fetches user's leagues from Kickbase API
final userLeaguesProvider = FutureProvider<List<League>>((ref) async {
  final isAuth = ref.watch(isKickbaseAuthenticatedProvider);

  if (!isAuth) {
    return [];
  }

  final apiClient = ref.watch(kickbaseApiClientProvider);
  try {
    return await apiClient.getLeagues();
  } on AuthorizationException {
    // 403 – Token abgelaufen → Logout erzwingen
    ref.read(kickbaseAuthProvider.notifier).handleSessionExpired();
    throw Exception(
      'Deine Kickbase-Sitzung ist abgelaufen. Bitte melde dich erneut an.',
    );
  } on AuthenticationException {
    // 401 – Token ungültig → Logout erzwingen
    ref.read(kickbaseAuthProvider.notifier).handleSessionExpired();
    throw Exception(
      'Deine Kickbase-Sitzung ist abgelaufen. Bitte melde dich erneut an.',
    );
  } catch (e) {
    throw Exception('Fehler beim Laden der Ligen: $e');
  }
});

// ============================================================================
// LEAGUE SELECTION STATE
// ============================================================================

/// Selected League Notifier (Riverpod 3.x)
class SelectedLeagueNotifier extends Notifier<League?> {
  @override
  League? build() => null;

  void select(League? league) {
    state = league;
  }

  void clear() {
    state = null;
  }
}

/// Selected League State Provider
/// Manages the currently selected league
/// Use this for league context throughout the app
final selectedLeagueProvider =
    NotifierProvider<SelectedLeagueNotifier, League?>(
      () => SelectedLeagueNotifier(),
    );

/// Selected League ID Provider
/// Convenience provider for accessing selected league ID
final selectedLeagueIdProvider = Provider<String?>((ref) {
  final league = ref.watch(selectedLeagueProvider);
  return league?.i;
});

/// Auto-select first league Effect
/// Automatically selects the first league if available and none is selected
final autoSelectFirstLeagueProvider = FutureProvider<void>((ref) async {
  final leagues = await ref.watch(userLeaguesProvider.future);
  final selectedLeague = ref.watch(selectedLeagueProvider);

  if (leagues.isNotEmpty && selectedLeague == null) {
    ref.read(selectedLeagueProvider.notifier).select(leagues.first);
  }
});

// ============================================================================
// LEAGUE DETAIL PROVIDERS
// ============================================================================

/// League Details Provider Family
/// Fetches detailed league information by ID
/// Use with .family modifier for different leagues
final leagueDetailsProvider = FutureProvider.family<League, String>((
  ref,
  leagueId,
) async {
  final leagueRepo = ref.watch(leagueRepositoryProvider);
  final result = await leagueRepo.getById(leagueId);

  if (result is Success<League>) {
    return result.data;
  } else if (result is Failure<League>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching league details');
});

/// League Details Stream Provider Family
/// Provides real-time updates for a specific league
final leagueDetailsStreamProvider = StreamProvider.family<League, String>((
  ref,
  leagueId,
) async* {
  final leagueRepo = ref.watch(leagueRepositoryProvider);

  await for (final result in leagueRepo.watchById(leagueId)) {
    if (result is Success<League>) {
      yield result.data;
    } else if (result is Failure<League>) {
      throw Exception((result).message);
    }
  }
});

// ============================================================================
// LEAGUE MEMBERS PROVIDERS
// ============================================================================

/// League Members Provider Family
/// Fetches all members of a specific league
final leagueMembersProvider = FutureProvider.family<List<LeagueUser>, String>((
  ref,
  leagueId,
) async {
  final leagueRepo = ref.watch(leagueRepositoryProvider);
  final result = await leagueRepo.getMembers(leagueId);

  if (result is Success<List<LeagueUser>>) {
    return result.data;
  } else if (result is Failure<List<LeagueUser>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching league members');
});

/// League Standings Provider
/// Returns league members sorted by placement
final leagueStandingsProvider = FutureProvider.family<List<LeagueUser>, String>(
  (ref, leagueId) async {
    final members = await ref.watch(leagueMembersProvider(leagueId).future);

    // Sort by placement
    final sorted = List<LeagueUser>.from(members)
      ..sort((a, b) => a.placement.compareTo(b.placement));

    return sorted;
  },
);

// ============================================================================
// LEAGUE SEARCH PROVIDERS
// ============================================================================

/// Search Leagues by Name Provider
/// Family provider for searching leagues
final searchLeaguesProvider = FutureProvider.family<List<League>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return [];
  }

  final leagueRepo = ref.watch(leagueRepositoryProvider);
  final result = await leagueRepo.searchByName(query);

  if (result is Success<List<League>>) {
    return result.data;
  } else if (result is Failure<List<League>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error searching leagues');
});

/// Active Leagues Provider
/// Fetches leagues with current matchday active
final activeLeaguesProvider = FutureProvider<List<League>>((ref) async {
  final leagueRepo = ref.watch(leagueRepositoryProvider);
  final result = await leagueRepo.getActiveLeagues();

  if (result is Success<List<League>>) {
    return result.data;
  } else if (result is Failure<List<League>>) {
    throw Exception((result).message);
  }
  throw Exception('Unknown error fetching active leagues');
});

// ============================================================================
// COMPUTED PROVIDERS
// ============================================================================

/// Current User League Position Provider
/// Returns the current user's position in selected league
final currentUserLeaguePositionProvider = Provider<int?>((ref) {
  final league = ref.watch(selectedLeagueProvider);
  if (league == null) return null;

  return league.cu.placement;
});

/// User's Best League Provider
/// Returns the league where user has best placement
final userBestLeagueProvider = FutureProvider<League?>((ref) async {
  final leagues = await ref.watch(userLeaguesProvider.future);

  if (leagues.isEmpty) return null;

  // All leagues have a non-null `cu` now
  return leagues.reduce(
    (best, current) =>
        current.cu.placement < best.cu.placement ? current : best,
  );
});

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*
/// Example 1: Display user's leagues
class LeagueListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaguesAsync = ref.watch(userLeaguesStreamProvider);

    return leaguesAsync.when(
      data: (leagues) => ListView.builder(
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final league = leagues[index];
          return ListTile(
            title: Text(league.n),
            subtitle: Text('Matchday ${league.md}'),
            trailing: Text('${league.cu.placement}. Platz'),
            onTap: () {
              // Select this league
              ref.read(selectedLeagueProvider.notifier).state = league;
            },
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 2: Display league details with members
class LeagueDetailWidget extends ConsumerWidget {
  final String leagueId;

  const LeagueDetailWidget({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(leagueDetailsProvider(leagueId));
    final membersAsync = ref.watch(leagueStandingsProvider(leagueId));

    return leagueAsync.when(
      data: (league) => Column(
        children: [
          Text(league.n, style: Theme.of(context).textTheme.headlineMedium),
          Text('Matchday: ${league.md}'),
          SizedBox(height: 16),
          membersAsync.when(
            data: (members) => ListView.builder(
              shrinkWrap: true,
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  leading: Text('${member.placement}.'),
                  title: Text(member.teamName),
                  subtitle: Text(member.name),
                  trailing: Text('${member.points} pts'),
                );
              },
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error loading members'),
          ),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 3: Select league and navigate
class LeagueSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);

    return DropdownButton<League>(
      value: selectedLeague,
      hint: Text('Select League'),
      items: ref.watch(userLeaguesProvider).when(
        data: (leagues) => leagues.map((league) {
          return DropdownMenuItem(
            value: league,
            child: Text(league.n),
          );
        }).toList(),
        loading: () => [],
        error: (_, __) => [],
      ),
      onChanged: (league) {
        ref.read(selectedLeagueProvider.notifier).state = league;
        if (league != null) {
          Navigator.pushNamed(context, '/league/${league.i}');
        }
      },
    );
  }
}

/// Example 4: Show user's position in selected league
class UserPositionWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(currentUserLeaguePositionProvider);
    final league = ref.watch(selectedLeagueProvider);

    if (league == null) {
      return Text('No league selected');
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Position in ${league.n}'),
            Text(
              '${position ?? "?"}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text('${league.cu.points} Punkte'),
          ],
        ),
      ),
    );
  }
}

/// Example 5: Real-time league updates
class LiveLeagueWidget extends ConsumerWidget {
  final String leagueId;

  const LiveLeagueWidget({required this.leagueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(leagueDetailsStreamProvider(leagueId));

    // Listen for changes and show notifications
    ref.listen<AsyncValue<League>>(
      leagueDetailsStreamProvider(leagueId),
      (previous, next) {
        if (previous?.hasValue == true && next.hasValue) {
          final prevMatchday = previous!.value!.md;
          final newMatchday = next.value!.md;
          
          if (prevMatchday != newMatchday) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New matchday: $newMatchday')),
            );
          }
        }
      },
    );

    return leagueAsync.when(
      data: (league) => Text('Current Matchday: ${league.md}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

/// Example 6: Search leagues
class LeagueSearchWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<LeagueSearchWidget> createState() => _LeagueSearchWidgetState();
}

class _LeagueSearchWidgetState extends ConsumerState<LeagueSearchWidget> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchLeaguesProvider(searchQuery));

    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search leagues...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        Expanded(
          child: searchAsync.when(
            data: (leagues) => ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (context, index) {
                final league = leagues[index];
                return ListTile(
                  title: Text(league.n),
                  subtitle: Text('Country: ${league.cn}'),
                );
              },
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }
}
*/
