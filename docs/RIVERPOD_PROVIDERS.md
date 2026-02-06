# Riverpod Providers - KickbaseKumpel

Comprehensive Riverpod provider setup for the KickbaseKumpel application.

## 📁 Struktur

```
lib/data/providers/
├── providers.dart                    # Barrel file - import all providers
├── repository_providers.dart         # Firebase & Repository instances
├── user_providers.dart              # User authentication & data
├── league_providers.dart            # League data & selection
├── player_providers.dart            # Player data & filtering
├── transfer_providers.dart          # Transfer tracking & validation
└── recommendation_providers.dart    # AI recommendations
```

## 🚀 Quick Start

### 1. Setup in main.dart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2. Use in Widgets

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/providers/providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch provider
    final userAsync = ref.watch(currentUserProvider);
    
    return userAsync.when(
      data: (user) => Text(user?.n ?? 'No user'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## 📦 Provider Overview

### Repository Providers (`repository_providers.dart`)

Grundlegende Firebase- und Repository-Instanzen:

- `firestoreProvider` - FirebaseFirestore instance
- `firebaseAuthProvider` - FirebaseAuth instance
- `userRepositoryProvider` - User repository
- `leagueRepositoryProvider` - League repository
- `playerRepositoryProvider` - Player repository
- `transferRepositoryProvider` - Transfer repository
- `recommendationRepositoryProvider` - Recommendation repository
- `authRepositoryProvider` - Auth repository

### User Providers (`user_providers.dart`)

Benutzer-Authentifizierung und -Daten:

**Auth State:**
- `authUserStreamProvider` - Stream<String?> - Auth user ID stream
- `currentAuthUserIdProvider` - String? - Current auth user ID (sync)

**User Data:**
- `currentUserProvider` - Stream<User?> - Current user data stream
- `currentUserDataProvider` - User? - Current user data (sync)
- `userDataProvider(userId)` - Future<User> - Specific user by ID
- `userSettingsProvider` - Future<User?> - User settings

**Search:**
- `searchUsersProvider(query)` - Future<List<User>> - Search users
- `userByEmailProvider(email)` - Future<User> - User by email

### League Providers (`league_providers.dart`)

Liga-Daten und -Verwaltung:

**Streams:**
- `userLeaguesStreamProvider` - Stream<List<League>> - User's leagues (real-time)
- `allLeaguesStreamProvider` - Stream<List<League>> - All leagues

**State:**
- `selectedLeagueProvider` - StateProvider<League?> - Selected league
- `selectedLeagueIdProvider` - String? - Selected league ID (computed)

**Details:**
- `leagueDetailsProvider(leagueId)` - Future<League> - League details
- `leagueDetailsStreamProvider(leagueId)` - Stream<League> - Real-time league
- `leagueMembersProvider(leagueId)` - Future<List<LeagueUser>> - Members
- `leagueStandingsProvider(leagueId)` - Future<List<LeagueUser>> - Sorted standings

**Search:**
- `searchLeaguesProvider(query)` - Future<List<League>> - Search leagues
- `activeLeaguesProvider` - Future<List<League>> - Active leagues

**Computed:**
- `currentUserLeaguePositionProvider` - int? - User's position
- `userBestLeagueProvider` - Future<League?> - Best league by placement

### Player Providers (`player_providers.dart`)

Spieler-Daten und Filter:

**All Players:**
- `allPlayersProvider` - Future<List<Player>> - All players
- `allPlayersStreamProvider` - Stream<List<Player>> - All players (real-time)

**Details:**
- `playerDetailsProvider(playerId)` - Future<Player> - Player details
- `playerDetailsStreamProvider(playerId)` - Stream<Player> - Real-time player
- `playerStatsProvider(playerId)` - Future<Player> - Player stats

**Filters:**
- `playersByTeamProvider(teamId)` - Future<List<Player>> - By team
- `playersByPositionProvider(position)` - Future<List<Player>> - By position
- `filteredPlayersProvider(params)` - Future<List<Player>> - Advanced filter
- `searchPlayersProvider(query)` - Future<List<Player>> - Search

**Top Players:**
- `topPlayersProvider(limit)` - Future<List<Player>> - Top by points
- `topPlayersByPointsProvider` - Future<List<Player>> - Top 20 by points
- `topPlayersByValueProvider(limit)` - Future<List<Player>> - Top by value

**Ownership:**
- `playerOwnershipProvider(params)` - Future<bool> - Check ownership

**Computed:**
- `availablePlayersProvider` - Future<List<Player>> - Not owned
- `affordablePlayersProvider` - Future<List<Player>> - Within budget
- `bestValuePlayersProvider(limit)` - Future<List<Player>> - Best points/€

### Transfer Providers (`transfer_providers.dart`)

Transfer-Tracking und -Validierung:

**User Transfers:**
- `userTransfersProvider` - Stream<List<Transfer>> - User transfers (real-time)
- `userTransfersFutureProvider` - Future<List<Transfer>> - User transfers

**League Transfers:**
- `leagueTransfersProvider(leagueId)` - Stream<List<Transfer>> - League transfers
- `selectedLeagueTransfersProvider` - Stream<List<Transfer>> - Selected league

**Player Transfers:**
- `playerTransfersProvider(playerId)` - Future<List<Transfer>> - Player history

**Recent:**
- `recentLeagueTransfersProvider(params)` - Future<List<Transfer>> - Recent
- `recentSelectedLeagueTransfersProvider(limit)` - Recent for selected league

**Review:**
- `transfersToReviewProvider` - Stream<List<Transfer>> - Pending transfers
- `pendingTransfersCountProvider` - int - Count of pending

**Statistics:**
- `transferStatsProvider(leagueId)` - Future<Map> - League stats
- `selectedLeagueTransferStatsProvider` - Future<Map> - Selected league stats

**Validation:**
- `transferValidationProvider(params)` - Future<bool> - Validate transfer

**Computed:**
- `userSentTransfersProvider` - List<Transfer> - Sent transfers
- `userReceivedTransfersProvider` - List<Transfer> - Received transfers
- `userTotalTransferVolumeProvider` - int - Total volume
- `userTotalTransfersCountProvider` - int - Total count

### Recommendation Providers (`recommendation_providers.dart`)

KI-Empfehlungen:

**Streams:**
- `recommendationsProvider(leagueId)` - Stream<List<Recommendation>> - League recommendations
- `selectedLeagueRecommendationsProvider` - Stream<List<Recommendation>> - Selected league

**Top:**
- `topRecommendationsProvider(params)` - Future<List<Recommendation>> - Top recommendations
- `topSelectedLeagueRecommendationsProvider(limit)` - Top for selected league

**Details:**
- `recommendationDetailsProvider(id)` - Future<Recommendation> - Details
- `recommendationDetailsStreamProvider(id)` - Stream<Recommendation> - Real-time

**Filtered:**
- `buyRecommendationsProvider(leagueId)` - Future<List<Recommendation>> - Buy only
- `sellRecommendationsProvider(leagueId)` - Future<List<Recommendation>> - Sell only
- `highConfidenceRecommendationsProvider(leagueId)` - High confidence only
- `recommendationsByCategoryProvider(params)` - By category

**Statistics:**
- `recommendationStatsProvider(leagueId)` - Future<Map> - Stats
- `selectedLeagueRecommendationStatsProvider` - Selected league stats

**Computed:**
- `recommendationsCountProvider` - int - Total count
- `averageRecommendationScoreProvider` - double - Average score
- `bestRecommendationProvider` - Recommendation? - Highest score
- `recommendationsByActionCountProvider` - Map<String, int> - Count by action

## 🎯 Best Practices

### 1. Use AsyncValue.when() for Loading States

```dart
final dataAsync = ref.watch(someProvider);

return dataAsync.when(
  data: (data) => YourWidget(data: data),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
);
```

### 2. Listen for Changes with ref.listen()

```dart
ref.listen<AsyncValue<User?>>(
  currentUserProvider,
  (previous, next) {
    next.when(
      data: (user) {
        if (user != null) {
          // Navigate or show notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome ${user.n}!')),
          );
        }
      },
      loading: () {},
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    );
  },
);
```

### 3. Use Family Modifiers for Parameters

```dart
// Define provider with family
final playerDetailsProvider = FutureProvider.family<Player, String>(
  (ref, playerId) async {
    // Fetch player by ID
  },
);

// Use in widget
final player = ref.watch(playerDetailsProvider('player-123'));
```

### 4. Computed Providers for Derived State

```dart
final userBudgetProvider = Provider<int>((ref) {
  final user = ref.watch(currentUserDataProvider);
  return user?.b ?? 0;
});

final canBuyPlayerProvider = Provider.family<bool, int>((ref, price) {
  final budget = ref.watch(userBudgetProvider);
  return budget >= price;
});
```

### 5. StateProvider for Simple State

```dart
final selectedLeagueProvider = StateProvider<League?>((ref) => null);

// Update state
ref.read(selectedLeagueProvider.notifier).state = league;

// Watch state
final league = ref.watch(selectedLeagueProvider);
```

### 6. Stream Providers for Real-time Data

```dart
final leagueTransfersProvider = StreamProvider.family<List<Transfer>, String>(
  (ref, leagueId) async* {
    final repo = ref.watch(transferRepositoryProvider);
    await for (final result in repo.watchByLeague(leagueId)) {
      if (result is Success<List<Transfer>>) {
        yield result.data;
      }
    }
  },
);
```

### 7. Dispose Resources Properly

Riverpod automatically disposes providers when not in use. For custom disposal:

```dart
final myProvider = Provider.autoDispose<MyClass>((ref) {
  final instance = MyClass();
  
  ref.onDispose(() {
    instance.dispose();
  });
  
  return instance;
});
```

### 8. Use select() for Optimization

```dart
// Only rebuild when user name changes
final userName = ref.watch(
  currentUserProvider.select((user) => user.value?.n),
);
```

### 9. Dependency Injection Pattern

```dart
// Repository depends on Firestore
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore: firestore);
});

// Service depends on Repository
final userServiceProvider = Provider<UserService>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return UserService(repository: userRepo);
});
```

### 10. Error Handling

```dart
final dataProvider = FutureProvider<Data>((ref) async {
  try {
    final result = await fetchData();
    if (result is Success<Data>) {
      return result.data;
    } else if (result is Failure<Data>) {
      throw Exception(result.message);
    }
    throw Exception('Unknown error');
  } catch (e) {
    // Log error
    print('Error in dataProvider: $e');
    rethrow;
  }
});
```

## 🔄 Common Patterns

### Pattern 1: Master-Detail Navigation

```dart
class LeagueListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagues = ref.watch(userLeaguesStreamProvider);
    
    return leagues.when(
      data: (leagues) => ListView.builder(
        itemCount: leagues.length,
        itemBuilder: (context, index) {
          final league = leagues[index];
          return ListTile(
            title: Text(league.n),
            onTap: () {
              // Set selected league
              ref.read(selectedLeagueProvider.notifier).state = league;
              
              // Navigate to detail
              Navigator.pushNamed(context, '/league-detail');
            },
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

class LeagueDetailScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final league = ref.watch(selectedLeagueProvider);
    
    if (league == null) {
      return Text('No league selected');
    }
    
    // Use selected league
    final transfers = ref.watch(selectedLeagueTransfersProvider);
    // ...
  }
}
```

### Pattern 2: Search with Debouncing

```dart
class PlayerSearchScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<PlayerSearchScreen> createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends ConsumerState<PlayerSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(() => _searchQuery = query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchPlayersProvider(_searchQuery));

    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(hintText: 'Search players...'),
        ),
        Expanded(
          child: searchResults.when(
            data: (players) => ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('${players[index].firstName} ${players[index].lastName}'),
              ),
            ),
            loading: () => CircularProgressIndicator(),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }
}
```

### Pattern 3: Conditional Provider Loading

```dart
final conditionalDataProvider = FutureProvider<Data?>((ref) async {
  // Only load if user is authenticated
  final userId = ref.watch(currentAuthUserIdProvider);
  
  if (userId == null) {
    return null;
  }
  
  // Load data
  final result = await fetchData(userId);
  return result;
});
```

### Pattern 4: Combining Multiple Providers

```dart
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  // Wait for all data in parallel
  final results = await Future.wait([
    ref.watch(currentUserProvider.future),
    ref.watch(userLeaguesProvider.future),
    ref.watch(topPlayersProvider(10).future),
  ]);

  return DashboardData(
    user: results[0] as User?,
    leagues: results[1] as List<League>,
    topPlayers: results[2] as List<Player>,
  );
});
```

## 📚 Additional Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Riverpod Samples](https://github.com/rrousselGit/riverpod/tree/master/examples)
- [State Management with Riverpod](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options#riverpod)

## 🐛 Troubleshooting

### Problem: Provider not updating

**Solution:** Ensure you're using `ref.watch()` not `ref.read()` in build methods.

### Problem: Too many rebuilds

**Solution:** Use `.select()` to watch only specific parts of the data.

### Problem: Memory leaks

**Solution:** Use `.autoDispose` modifier for providers that should be cleaned up.

```dart
final myProvider = FutureProvider.autoDispose<Data>((ref) async {
  // Will be disposed when no longer used
});
```

## ✅ Checklist for Adding New Providers

- [ ] Define provider with appropriate type (Provider, FutureProvider, StreamProvider, etc.)
- [ ] Add family modifier if parameters needed
- [ ] Implement proper error handling
- [ ] Add usage examples in comments
- [ ] Consider autoDispose if appropriate
- [ ] Export from `providers.dart` barrel file
- [ ] Test in UI with loading/error states
- [ ] Document in this README
