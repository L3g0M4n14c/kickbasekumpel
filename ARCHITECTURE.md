# KickbaseKumpel - Technische Architektur Dokumentation

> **Zielgruppe**: Entwickler und KI-Coding-Agents  
> **Zweck**: Schneller Überblick über die Anwendungsarchitektur und Richtlinien für Code-Erweiterungen  
> **Version**: 1.0  
> **Letztes Update**: Februar 2026

---

## Inhaltsverzeichnis

1. [Übersicht](#übersicht)
2. [Architekturmuster](#architekturmuster)
3. [Technologie-Stack](#technologie-stack)
4. [Projektstruktur](#projektstruktur)
5. [Datenfluss](#datenfluss)
6. [State Management](#state-management)
7. [Navigation](#navigation)
8. [Design Patterns](#design-patterns)
9. [Code-Richtlinien](#code-richtlinien)
10. [Wie man neuen Code hinzufügt](#wie-man-neuen-code-hinzufügt)

---

## Übersicht

**KickbaseKumpel** ist eine Flutter-Anwendung für die Verwaltung von Kickbase Fantasy Football Teams. Die App nutzt eine moderne Clean Architecture mit Riverpod für State Management und Firebase als Backend.

### Kern-Features

- ✅ **Kickbase API Integration**: Vollständige Integration mit der Kickbase v4 API
- ✅ **Firebase Backend**: User Authentication und Firestore Datenbank
- ✅ **Real-time Updates**: Live-Daten über Firestore Streams
- ✅ **Responsive Design**: Unterstützung für Mobile, Tablet und Desktop
- ✅ **Offline-Capable**: Lokales Caching mit SharedPreferences
- ✅ **Type-Safe Navigation**: GoRouter mit Deep Linking Support

---

## Architekturmuster

Die Anwendung folgt einer **modifizierten Clean Architecture** mit drei Hauptschichten:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│    (Pages, Screens, Widgets, UI-Providers)                  │
│    - Verantwortung: UI-Rendering, User Interactions         │
│    - Technologie: Flutter Widgets, Riverpod Consumer        │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                            │
│    (Repositories, Services, Models, Data-Providers)         │
│    - Verantwortung: Datenabruf, Business Logic, Caching    │
│    - Technologie: HTTP Client, Firebase SDK                 │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                           │
│    (Interfaces, Exceptions, Result Types)                   │
│    - Verantwortung: Contracts, Error Definitions           │
│    - Technologie: Pure Dart                                 │
└─────────────────────────────────────────────────────────────┘
```

### Schichten-Regeln

1. **Dependency Rule**: Abhängigkeiten zeigen immer nach innen (Presentation → Data → Domain)
2. **Domain Layer**: Keine Flutter/Firebase Abhängigkeiten, nur Pure Dart
3. **Data Layer**: Implementiert Domain Interfaces, nutzt externe Bibliotheken
4. **Presentation Layer**: Nutzt Data Provider, keine direkte Service-Nutzung

---

## Technologie-Stack

### Kern-Frameworks

| Kategorie | Technologie | Version | Verwendung |
|-----------|------------|---------|------------|
| **Framework** | Flutter | 3.9.2 | Mobile/Web/Desktop App |
| **Sprache** | Dart | 3.9.2 | Programmiersprache |
| **State Management** | Riverpod | 3.2.1 | Reactive State & DI |
| **Navigation** | GoRouter | 17.1.0 | Deklaratives Routing |
| **Backend** | Firebase | - | Auth + Firestore |
| **API Client** | HTTP | 1.6.0 | REST API Calls |
| **Code Generation** | Freezed | 2.5.7 | Immutable Models |
| **JSON** | json_serializable | 6.8.0 | JSON ↔ Model |
| **Logging** | Logger | 2.4.0 | Debug Logging |
| **Charts** | FL Chart | 1.1.1 | Datenvisualisierung |

### Wichtige Zusatz-Pakete

- `firebase_auth` (6.1.4): Benutzer-Authentifizierung
- `cloud_firestore` (6.1.2): NoSQL Datenbank
- `shared_preferences` (2.5.4): Lokaler Key-Value Store
- `flutter_secure_storage` (10.0.0): Sichere Token-Speicherung
- `cached_network_image` (3.4.1): Bildcaching
- `connectivity_plus` (7.0.0): Netzwerk-Status
- `intl` (0.20.2): Internationalisierung

### Dev-Dependencies

- `build_runner` (2.4.0): Code-Generierung
- `mockito` (5.4.4) / `mocktail` (1.0.0): Testing
- `fake_cloud_firestore` (4.0.1): Firestore Mocking
- `flutter_lints` (6.0.0): Code-Stil Prüfung

---

## Projektstruktur

### Verzeichnis-Layout

```
lib/
├── config/                      # App-Konfiguration
│   ├── router.dart              # GoRouter Konfiguration
│   ├── theme.dart               # Material Theme Definition
│   ├── firebase_config.dart     # Firebase Setup
│   └── screen_size.dart         # Responsive Breakpoints
│
├── domain/                      # Domain Layer (Pure Dart)
│   ├── repositories/
│   │   ├── repository_interfaces.dart   # Result<T>, Success/Failure
│   │   └── auth_repository_interface.dart
│   └── exceptions/
│       └── kickbase_exceptions.dart     # Custom Exceptions
│
├── data/                        # Data Layer
│   ├── sources/
│   │   └── auth_source.dart             # Firebase Auth Wrapper
│   ├── services/
│   │   ├── kickbase_api_client.dart     # Externe Kickbase API
│   │   ├── http_client_wrapper.dart     # HTTP Retry Logic
│   │   ├── token_storage.dart           # Token Persistence
│   │   └── ligainsider_service.dart     # LigaInsider Scraping
│   ├── repositories/
│   │   ├── base_repository.dart         # Generic Firestore CRUD
│   │   ├── auth_repository.dart         # Auth Repository Impl
│   │   └── firestore_repositories.dart  # Domain Repositories
│   ├── models/
│   │   ├── user_model.dart              # @freezed Models
│   │   ├── league_model.dart
│   │   ├── player_model.dart
│   │   ├── transfer_model.dart
│   │   ├── lineup_model.dart
│   │   ├── market_model.dart
│   │   └── *.freezed.dart / *.g.dart    # Generierte Dateien
│   ├── providers/
│   │   ├── kickbase_auth_provider.dart  # Auth State Provider
│   │   ├── league_providers.dart        # League Data Providers
│   │   ├── player_providers.dart        # Player Data Providers
│   │   ├── transfer_providers.dart
│   │   ├── recommendation_providers.dart
│   │   ├── repository_providers.dart    # Repo Instanzen
│   │   └── service_providers.dart       # Service Instanzen
│   └── utils/
│       └── parsing_utils.dart           # JSON Parsing Helpers
│
└── presentation/                # Presentation Layer
    ├── pages/                   # Full-Screen Pages
    │   ├── auth/
    │   │   └── signin_page.dart
    │   ├── dashboard/
    │   │   ├── dashboard_shell.dart     # BottomNav Container
    │   │   ├── team_page.dart           # Tab 1
    │   │   ├── market_page.dart         # Tab 2
    │   │   ├── lineup_page.dart         # Tab 3
    │   │   ├── transfers_page.dart      # Tab 4
    │   │   └── settings_page.dart       # Tab 5
    │   ├── league/
    │   │   ├── league_overview_page.dart
    │   │   ├── league_standings_page.dart
    │   │   └── league_players_page.dart
    │   ├── player/
    │   │   ├── player_stats_page.dart
    │   │   └── player_history_page.dart
    │   ├── loading_screen.dart
    │   └── error_page.dart
    ├── screens/                 # Alternative Screen Implementierungen
    │   └── (ähnliche Struktur zu pages/)
    ├── providers/
    │   ├── market_providers.dart        # UI State (Filter, Selection)
    │   └── dashboard_providers.dart
    └── widgets/                 # Wiederverwendbare Komponenten
        ├── common/
        │   ├── loading_widget.dart
        │   ├── error_widget.dart
        │   ├── empty_state_widget.dart
        │   ├── retry_widget.dart
        │   └── app_logo.dart
        ├── cards/
        │   ├── player_card.dart
        │   ├── player_list_tile.dart
        │   ├── league_card.dart
        │   ├── match_card.dart
        │   └── transfer_card.dart
        ├── forms/
        │   ├── email_input_field.dart
        │   ├── password_input_field.dart
        │   ├── search_field.dart
        │   └── price_input_field.dart
        ├── charts/
        │   ├── performance_line_chart.dart
        │   ├── stats_bar_chart.dart
        │   ├── price_chart.dart
        │   └── position_badge.dart
        ├── app_bars/
        │   ├── custom_app_bar.dart
        │   ├── search_app_bar.dart
        │   └── tabbed_app_bar.dart
        ├── buttons/
        │   ├── action_button.dart
        │   ├── floating_action_menu.dart
        │   └── confirmation_dialog.dart
        ├── market/
        │   ├── player_market_card.dart
        │   ├── market_filters.dart
        │   └── buy_player_bottom_sheet.dart
        ├── team/
        │   ├── team_budget_header.dart
        │   ├── player_row_with_sale.dart
        │   ├── position_badge.dart
        │   └── player_count_overview.dart
        └── responsive_layout.dart
```

### Namenskonventionen

| Art | Konvention | Beispiel |
|-----|-----------|----------|
| **Models** | `*_model.dart` | `player_model.dart` |
| **Providers** | `*_provider.dart` | `league_providers.dart` |
| **Repositories** | `*_repository.dart` | `auth_repository.dart` |
| **Services** | `*_service.dart` / `*_client.dart` | `kickbase_api_client.dart` |
| **Pages** | `*_page.dart` | `team_page.dart` |
| **Screens** | `*_screen.dart` | `dashboard_screen.dart` |
| **Widgets** | `*_widget.dart` | `loading_widget.dart` |
| **Exceptions** | `*_exceptions.dart` | `kickbase_exceptions.dart` |

---

## Datenfluss

### Vollständiger Datenfluss: API → UI

```
┌──────────────────────────────────────────────────────────────┐
│  Externe API (Kickbase REST API v4)                          │
└────────────────────────┬─────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│  KickbaseAPIClient                                           │
│  - Token Management & Caching                                │
│  - Retry Logic (exponential backoff)                         │
│  - Error Mapping zu Custom Exceptions                        │
│  - Request/Response Logging                                  │
└────────────────────────┬─────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│  Repositories (Data Layer)                                   │
│  - Business Logic                                            │
│  - Result<T> Wrapping (Success/Failure)                      │
│  - Data Transformation (JSON → Model)                        │
│  - Optional: Firestore Persistence                           │
└────────────────────────┬─────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│  Riverpod Providers (Data Providers)                         │
│  - FutureProvider: One-time Fetch                            │
│  - StreamProvider: Real-time (Firestore)                     │
│  - StateNotifier: Mutable State (Filter, Selection)          │
└────────────────────────┬─────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│  Presentation Providers (Optional)                           │
│  - UI-spezifische Transformationen                           │
│  - Aggregierte Daten                                         │
│  - Computed Values                                           │
└────────────────────────┬─────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│  ConsumerWidget / Page                                       │
│  - ref.watch(provider) → Reaktives Listening                 │
│  - AsyncValue.when() → Loading/Data/Error Handling           │
│  - UI Rendering                                              │
└──────────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────────┐
│  User Interaction                                            │
│  - Button Click, Input, Swipe                                │
│  - ref.read(provider.notifier).method()                      │
│  - ref.invalidate(provider) → Force Refresh                  │
└──────────────────────────────────────────────────────────────┘
```

### Beispiel: Teams laden

```dart
// 1. API Client definiert Methode
class KickbaseAPIClient {
  Future<List<Player>> getTeamPlayers(String leagueId) async {
    final response = await _executeWithRetry(
      () => _httpClient.get(
        Uri.parse('$_baseUrl/$_apiVersion/leagues/$leagueId/team'),
        headers: {'Authorization': 'Bearer $_cachedToken'},
      ),
    );
    return (jsonDecode(response.body)['players'] as List)
        .map((json) => Player.fromJson(json))
        .toList();
  }
}

// 2. Repository wraps mit Error Handling
class TeamRepository {
  final KickbaseAPIClient _apiClient;
  
  Future<Result<List<Player>>> getTeamPlayers(String leagueId) async {
    try {
      final players = await _apiClient.getTeamPlayers(leagueId);
      return Success(players);
    } on KickbaseException catch (e) {
      return Failure(e.message, code: e.code);
    } catch (e) {
      return Failure('Unerwarteter Fehler: $e');
    }
  }
}

// 3. Provider exponiert Daten
final teamPlayersProvider = FutureProvider.family<List<Player>, String>(
  (ref, leagueId) async {
    final repository = ref.watch(teamRepositoryProvider);
    final result = await repository.getTeamPlayers(leagueId);
    
    return result.when(
      success: (data) => data,
      failure: (message, code) => throw Exception(message),
    );
  },
);

// 4. Widget nutzt Provider
class TeamPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final playersAsync = ref.watch(teamPlayersProvider(selectedLeague.id));
    
    return playersAsync.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(error: error),
      data: (players) => ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) => PlayerCard(player: players[index]),
      ),
    );
  }
}

// 5. Refresh triggern
ElevatedButton(
  onPressed: () {
    ref.invalidate(teamPlayersProvider(selectedLeague.id));
  },
  child: const Text('Aktualisieren'),
)
```

---

## State Management

### Riverpod 3.x Architektur

Die App nutzt **Riverpod 3.x** als State Management Lösung. Riverpod bietet:

- ✅ **Compile-Time Safety**: Keine Provider-Fehler zur Laufzeit
- ✅ **Dependency Injection**: Automatische Provider-Verwaltung
- ✅ **Testability**: Einfaches Mocking mit `ProviderContainer`
- ✅ **Auto-Dispose**: Automatisches Cleanup bei Nicht-Verwendung
- ✅ **Dev Tools**: Flutter DevTools Integration

### Provider-Typen

| Provider Typ | Verwendung | Mutability | Beispiel |
|--------------|-----------|------------|----------|
| `Provider<T>` | Synchrone, berechnete Werte | Immutable | Config, Constants |
| `FutureProvider<T>` | Asynchrone Datenabruf | Immutable | API Calls |
| `StreamProvider<T>` | Real-time Streams | Immutable | Firestore Streams |
| `NotifierProvider<N, T>` | Mutable State mit Logik | Mutable | Auth State, Selections |
| `StateNotifierProvider<N, T>` | Legacy Mutable State | Mutable | (wird ersetzt) |

### Provider Pattern: Authentication State

```dart
// 1. State Class (Immutable mit Freezed)
@freezed
class KickbaseAuthState with _$KickbaseAuthState {
  const factory KickbaseAuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    User? currentUser,
    String? error,
  }) = _KickbaseAuthState;
}

// 2. Notifier mit Business Logic
class KickbaseAuthNotifier extends Notifier<KickbaseAuthState> {
  @override
  KickbaseAuthState build() {
    // Initial state
    return const KickbaseAuthState();
  }
  
  /// Login mit Email/Passwort
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final apiClient = ref.read(kickbaseApiClientProvider);
      final user = await apiClient.login(email, password);
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// Logout
  Future<void> logout() async {
    final apiClient = ref.read(kickbaseApiClientProvider);
    await apiClient.logout();
    
    state = const KickbaseAuthState(); // Reset
  }
}

// 3. Provider Definition
final kickbaseAuthProvider = NotifierProvider<
  KickbaseAuthNotifier,
  KickbaseAuthState
>(KickbaseAuthNotifier.new);

// 4. Derived Provider (Computed)
final isKickbaseAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(kickbaseAuthProvider).isAuthenticated;
});
```

### Provider Pattern: UI Selection

```dart
// Simple Notifier für UI State
class SelectedLeagueNotifier extends Notifier<League?> {
  @override
  League? build() => null; // Initial state
  
  void select(League? league) {
    state = league;
  }
  
  void clear() {
    state = null;
  }
}

final selectedLeagueProvider = NotifierProvider<
  SelectedLeagueNotifier,
  League?
>(SelectedLeagueNotifier.new);

// Verwendung im Widget
final selectedLeague = ref.watch(selectedLeagueProvider);
if (selectedLeague == null) {
  return const Text('Keine Liga ausgewählt');
}

// Update State
ref.read(selectedLeagueProvider.notifier).select(newLeague);
```

### Provider Pattern: Data Loading

```dart
// FutureProvider für einmaliges Laden
final userLeaguesProvider = FutureProvider<List<League>>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return await apiClient.getLeagues(userId);
});

// StreamProvider für Real-time Updates
final leagueStandingsStreamProvider = StreamProvider.family<
  List<Standing>,
  String
>((ref, leagueId) {
  final repository = ref.watch(leagueRepositoryProvider);
  return repository.watchStandings(leagueId).map((result) {
    return result.when(
      success: (data) => data,
      failure: (message, _) => throw Exception(message),
    );
  });
});
```

### Best Practices

1. **Provider Location**:
   - Data Providers → `lib/data/providers/`
   - UI Providers → `lib/presentation/providers/`
   - Service Providers → `lib/data/providers/service_providers.dart`

2. **Naming**:
   - State Class: `*State` (z.B. `KickbaseAuthState`)
   - Notifier: `*Notifier` (z.B. `KickbaseAuthNotifier`)
   - Provider: `*Provider` (z.B. `kickbaseAuthProvider`)

3. **Watching vs Reading**:
   - `ref.watch()`: Reaktives Listening, Widget rebuildet bei Änderung
   - `ref.read()`: Einmaliges Lesen, kein Re-Build
   - `ref.listen()`: Side-Effect ohne Re-Build (z.B. Navigation)

4. **Invalidation**:
   ```dart
   // Single Provider
   ref.invalidate(teamPlayersProvider);
   
   // Family Provider (specific parameter)
   ref.invalidate(teamPlayersProvider('league123'));
   
   // Alle Family Instances
   ref.invalidate(teamPlayersProvider);
   ```

---

## Navigation

### GoRouter Konfiguration

Die App nutzt **GoRouter 17.x** für deklaratives, typsicheres Routing:

```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final initStatus = ref.watch(initializeAuthProvider);
  final isAuthenticated = ref.watch(isKickbaseAuthenticatedProvider);
  
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    
    // Global Redirect Logic
    redirect: (context, state) {
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isGoingToLoading = state.matchedLocation.startsWith('/loading');
      
      // Während Initialisierung → Loading Screen
      if (initStatus.isLoading && !isGoingToLoading) {
        return '/loading';
      }
      
      // Nicht authentifiziert → Login
      if (!isAuthenticated && !isGoingToAuth && !isGoingToLoading) {
        return '/auth/signin';
      }
      
      // Authentifiziert auf Auth-Seite → Dashboard
      if (isAuthenticated && isGoingToAuth) {
        return '/dashboard';
      }
      
      return null; // Keine Umleitung
    },
    
    routes: [
      // Loading Route
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      
      // Auth Routes
      GoRoute(
        path: '/auth/signin',
        builder: (context, state) => const SignInPage(),
      ),
      
      // Dashboard mit StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Team
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const TeamPage(),
              ),
            ],
          ),
          
          // Tab 2: Market
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/market',
                builder: (context, state) => const MarketPage(),
              ),
            ],
          ),
          
          // Tab 3: Lineup
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/lineup',
                builder: (context, state) => const LineupPage(),
              ),
            ],
          ),
          
          // Tab 4: Transfers
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/transfers',
                builder: (context, state) => const TransfersPage(),
              ),
            ],
          ),
          
          // Tab 5: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      
      // Deep Link Routes
      GoRoute(
        path: '/league/:leagueId/overview',
        builder: (context, state) {
          final leagueId = state.pathParameters['leagueId']!;
          return LeagueOverviewPage(leagueId: leagueId);
        },
        routes: [
          GoRoute(
            path: 'standings',
            builder: (context, state) {
              final leagueId = state.pathParameters['leagueId']!;
              return LeagueStandingsPage(leagueId: leagueId);
            },
          ),
          GoRoute(
            path: 'players',
            builder: (context, state) {
              final leagueId = state.pathParameters['leagueId']!;
              return LeaguePlayersPage(leagueId: leagueId);
            },
          ),
        ],
      ),
      
      GoRoute(
        path: '/player/:playerId/stats',
        builder: (context, state) {
          final playerId = state.pathParameters['playerId']!;
          return PlayerStatsPage(playerId: playerId);
        },
      ),
    ],
  );
});
```

### Navigation Helpers

```dart
// Extension für einfachere Navigation
extension GoRouterExtension on BuildContext {
  void goToLeague(String leagueId) {
    go('/league/$leagueId/overview');
  }
  
  void goToPlayer(String playerId) {
    go('/player/$playerId/stats');
  }
  
  void goToMarket() {
    go('/dashboard/market');
  }
  
  void goBack() {
    pop();
  }
}

// Verwendung
context.goToLeague('league123');
context.goToPlayer('player456');
```

### StatefulShellRoute Vorteile

- ✅ **State Preservation**: Jeder Tab behält seinen State
- ✅ **Separate Navigation Stack**: Jeder Tab hat eigene Navigation History
- ✅ **Lazy Loading**: Tabs werden erst beim ersten Besuch initialisiert
- ✅ **Bottom Navigation Integration**: Perfekt für BottomNavigationBar

---

## Design Patterns

### 1. Result Type Pattern

**Zweck**: Explizites Error Handling ohne Exceptions

```dart
// Definition (Domain Layer)
sealed class Result<T> {
  const Result();
  
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, String? code) failure,
  });
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
  
  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, String? code) failure,
  }) => success(data);
}

class Failure<T> extends Result<T> {
  final String message;
  final String? code;
  final Exception? exception;
  
  const Failure(this.message, {this.code, this.exception});
  
  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, String? code) failure,
  }) => failure(message, code);
}

// Verwendung
Future<Result<List<Player>>> getPlayers() async {
  try {
    final data = await _apiClient.fetchPlayers();
    return Success(data);
  } on NotFoundException catch (e) {
    return Failure(e.message, code: 'not_found');
  } catch (e) {
    return Failure('Unerwarteter Fehler', exception: e as Exception?);
  }
}

// Pattern Matching
final result = await repository.getPlayers();
result.when(
  success: (players) => print('Erfolgreich: ${players.length} Spieler'),
  failure: (message, code) => print('Fehler [$code]: $message'),
);
```

**Vorteile**:
- Erzwingt explizites Error Handling
- Keine versteckten Exceptions
- Type-safe (Compiler prüft alle Cases)

---

### 2. Repository Pattern

**Zweck**: Abstraktion der Datenquelle (API, Firestore, Cache)

```dart
// Abstract Base (für Firestore)
abstract class BaseRepository<T> {
  final FirebaseFirestore firestore;
  final String collectionPath;
  
  Future<Result<List<T>>> getAll();
  Future<Result<T>> getById(String id);
  Future<Result<T>> create(T item);
  Future<Result<T>> update(String id, T item);
  Future<Result<void>> delete(String id);
  Stream<Result<List<T>>> watchAll();
}

// Konkrete Implementierung
class LeagueRepository extends BaseRepository<League> {
  LeagueRepository({required super.firestore})
      : super(collectionPath: 'leagues');
  
  @override
  League fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return League.fromJson(doc.data()!..['id'] = doc.id);
  }
  
  @override
  Map<String, dynamic> toFirestore(League item) {
    return item.toJson()..remove('id');
  }
  
  // Custom Methoden
  Future<Result<List<League>>> getByUserId(String userId) async {
    return complexQuery(
      conditions: [
        QueryCondition(field: 'userId', isEqualTo: userId),
      ],
      orderByField: 'name',
    );
  }
}

// Provider für Dependency Injection
final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepository(
    firestore: FirebaseFirestore.instance,
  );
});
```

---

### 3. Service Locator via Riverpod

**Zweck**: Zentrale Verwaltung von Singleton-Instanzen

```dart
// Service Providers (lib/data/providers/service_providers.dart)
final httpClientWrapperProvider = Provider<HttpClientWrapper>((ref) {
  return HttpClientWrapper();
});

final kickbaseApiClientProvider = Provider<KickbaseAPIClient>((ref) {
  final httpWrapper = ref.watch(httpClientWrapperProvider);
  return KickbaseAPIClient(httpClient: httpWrapper.client);
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SharedPreferencesTokenStorage();
});

// Repository Providers (lib/data/providers/repository_providers.dart)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authSource: FirebaseAuthSource(),
  );
});

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepository(
    firestore: FirebaseFirestore.instance,
  );
});

// Verwendung überall in der App
final apiClient = ref.watch(kickbaseApiClientProvider);
final repository = ref.watch(leagueRepositoryProvider);
```

**Vorteile**:
- Keine manuelle Singleton-Verwaltung
- Einfaches Testen (Provider Override)
- Automatisches Dispose

---

### 4. Freezed für Immutable Models

**Zweck**: Typsichere, immutable Data Classes mit Code-Generation

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String firstName,
    required String lastName,
    required int marketValue,
    required String position,
    required int points,
    @JsonKey(name: 'profile_big') String? profileImage,
    @Default(0) int totalPoints,
  }) = _Player;
  
  factory Player.fromJson(Map<String, dynamic> json) =>
      _$PlayerFromJson(json);
}

// Verwendung
final player = Player(
  id: '123',
  firstName: 'Max',
  lastName: 'Mustermann',
  marketValue: 5000000,
  position: 'ST',
  points: 150,
);

// Immutable Copy
final updatedPlayer = player.copyWith(points: 160);

// JSON Serialization
final json = player.toJson();
final parsedPlayer = Player.fromJson(json);

// Pattern Matching (map, maybeMap, when)
player.map(
  (data) => print('Player: ${data.firstName} ${data.lastName}'),
);
```

**Generierte Features**:
- `copyWith()`: Immutable Updates
- `toString()`: Debug-friendly Output
- `==` und `hashCode`: Value Equality
- `toJson()` / `fromJson()`: JSON Serialization
- Union Types Support

**Code-Generation**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 5. Wrapper Pattern für External APIs

**Zweck**: Kapselung externer Services mit Retry Logic & Error Mapping

```dart
class KickbaseAPIClient {
  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;
  
  final http.Client _httpClient;
  String? _cachedToken;
  
  /// Execute Request mit Exponential Backoff
  Future<http.Response> _executeWithRetry<T>(
    Future<http.Response> Function() request,
  ) async {
    int attempt = 0;
    Duration delay = const Duration(milliseconds: 500);
    
    while (true) {
      try {
        attempt++;
        final response = await request().timeout(_timeout);
        
        // Success Cases
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        
        // Error Mapping
        if (response.statusCode == 401) {
          throw UnauthorizedException('Invalid credentials');
        }
        if (response.statusCode == 404) {
          throw NotFoundException('Resource not found');
        }
        if (response.statusCode >= 500) {
          throw ServerException('Server error: ${response.statusCode}');
        }
        
        throw ApiException('API Error: ${response.statusCode}');
        
      } on SocketException {
        if (attempt >= _maxRetries) rethrow;
        await Future.delayed(delay);
        delay *= 2; // Exponential Backoff
      } on TimeoutException {
        throw ApiException('Request timeout');
      }
    }
  }
  
  /// Login mit Token Caching
  Future<User> login(String email, String password) async {
    final response = await _executeWithRetry(
      () => _httpClient.post(
        Uri.parse('$_baseUrl/$_apiVersion/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    
    final data = jsonDecode(response.body);
    _cachedToken = data['token'];
    await _tokenStorage.setToken(_cachedToken!);
    
    return User.fromJson(data['user']);
  }
}
```

---

### 6. Responsive Layout Pattern

**Zweck**: Adaptive UIs für verschiedene Bildschirmgrößen

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth >= 1200 && desktop != null) {
      return desktop!;
    }
    if (screenWidth >= 768 && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

// Verwendung
ResponsiveLayout(
  mobile: _MobilePlayerList(),
  tablet: _TabletPlayerGrid(),
  desktop: _DesktopPlayerTable(),
)
```

**Breakpoints** (definiert in `config/screen_size.dart`):
- **Mobile**: < 768px
- **Tablet**: 768px - 1199px
- **Desktop**: ≥ 1200px

---

## Code-Richtlinien

### 1. Allgemeine Regeln

- ✅ **Dart Style Guide**: Folge dem [offiziellen Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- ✅ **Linting**: Aktiviere `flutter_lints` und behebe alle Warnings
- ✅ **Formatting**: Nutze `dart format` vor jedem Commit
- ✅ **Naming**:
  - Classes: `PascalCase` (z.B. `PlayerCard`)
  - Variables/Functions: `camelCase` (z.B. `getPlayers`)
  - Constants: `lowerCamelCase` mit `const` (z.B. `const apiBaseUrl`)
  - Private: Prefix mit `_` (z.B. `_cachedToken`)

### 2. Model-Richtlinien

**Immer Freezed verwenden für Data Classes**:

```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    @Default(0) int count,
    @JsonKey(name: 'custom_field') String? customField,
  }) = _MyModel;
  
  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**Nach Änderungen immer neu generieren**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Provider-Richtlinien

**Provider-Platzierung**:
- Data Providers → `lib/data/providers/`
- UI State Providers → `lib/presentation/providers/`
- Service Singletons → `lib/data/providers/service_providers.dart`

**Naming Convention**:
```dart
// ✅ CORRECT
final userLeaguesProvider = FutureProvider<List<League>>(...);
final selectedLeagueProvider = NotifierProvider<...>(...);
final isAuthenticatedProvider = Provider<bool>(...);

// ❌ INCORRECT
final getLeagues = FutureProvider<List<League>>(...);
final league = NotifierProvider<...>(...);
```

**Family Providers für parametrisierte Daten**:
```dart
final playerDetailsProvider = FutureProvider.family<Player, String>(
  (ref, playerId) async {
    final apiClient = ref.watch(kickbaseApiClientProvider);
    return await apiClient.getPlayerDetails(playerId);
  },
);

// Verwendung
final player = ref.watch(playerDetailsProvider('player123'));
```

### 4. Widget-Richtlinien

**ConsumerWidget für Reactive Widgets**:
```dart
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    return Text(data.toString());
  }
}
```

**Stateless/Stateful für Static Widgets**:
```dart
class MyStaticWidget extends StatelessWidget {
  final String title;
  
  const MyStaticWidget({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

**Extract Widgets statt Builder Functions**:
```dart
// ✅ CORRECT
class _PlayerListItem extends StatelessWidget {
  final Player player;
  const _PlayerListItem({required this.player});
  
  @override
  Widget build(BuildContext context) => ListTile(title: Text(player.name));
}

// ❌ INCORRECT
Widget _buildPlayerItem(Player player) {
  return ListTile(title: Text(player.name));
}
```

### 5. Error Handling

**Immer Result<T> in Repositories**:
```dart
Future<Result<T>> getData() async {
  try {
    // Success case
    return Success(data);
  } on SpecificException catch (e) {
    return Failure(e.message, code: e.code);
  } catch (e) {
    return Failure('Unerwarteter Fehler', exception: e as Exception?);
  }
}
```

**AsyncValue.when() in Widgets**:
```dart
final asyncData = ref.watch(dataProvider);
return asyncData.when(
  loading: () => const LoadingWidget(),
  error: (error, stack) => ErrorWidget(error: error),
  data: (data) => DataWidget(data: data),
);
```

### 6. Testing

**Unit Tests für Business Logic**:
```dart
void main() {
  group('LeagueRepository', () {
    test('getByUserId returns leagues for valid user', () async {
      final repository = LeagueRepository(firestore: fakeFirestore);
      final result = await repository.getByUserId('user123');
      
      expect(result, isA<Success<List<League>>>());
      result.when(
        success: (leagues) => expect(leagues, hasLength(2)),
        failure: (_, __) => fail('Should not fail'),
      );
    });
  });
}
```

**Widget Tests für UI**:
```dart
testWidgets('PlayerCard displays player name', (tester) async {
  final player = Player(id: '1', firstName: 'Max', lastName: 'Mustermann', ...);
  
  await tester.pumpWidget(
    MaterialApp(home: PlayerCard(player: player)),
  );
  
  expect(find.text('Max Mustermann'), findsOneWidget);
});
```

**Provider Overrides für Testing**:
```dart
final container = ProviderContainer(
  overrides: [
    kickbaseApiClientProvider.overrideWithValue(mockApiClient),
  ],
);

final result = await container.read(userLeaguesProvider.future);
expect(result, hasLength(3));
```

---

## Wie man neuen Code hinzufügt

### Neues Feature hinzufügen

#### 1. **Model erstellen** (falls benötigt)

**Datei**: `lib/data/models/my_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    DateTime? createdAt,
  }) = _MyModel;
  
  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**Code generieren**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

#### 2. **API Client Methode hinzufügen**

**Datei**: `lib/data/services/kickbase_api_client.dart`

```dart
/// Get my data from Kickbase API
Future<List<MyModel>> getMyData(String leagueId) async {
  final response = await _executeWithRetry(
    () => _httpClient.get(
      Uri.parse('$_baseUrl/$_apiVersion/leagues/$leagueId/mydata'),
      headers: _buildHeaders(),
    ),
  );
  
  final data = jsonDecode(response.body);
  return (data['items'] as List)
      .map((json) => MyModel.fromJson(json))
      .toList();
}
```

---

#### 3. **Repository erstellen** (optional, für komplexe Logik)

**Datei**: `lib/data/repositories/my_repository.dart`

```dart
class MyRepository {
  final KickbaseAPIClient _apiClient;
  
  MyRepository({required KickbaseAPIClient apiClient})
      : _apiClient = apiClient;
  
  Future<Result<List<MyModel>>> getMyData(String leagueId) async {
    try {
      final data = await _apiClient.getMyData(leagueId);
      return Success(data);
    } on KickbaseException catch (e) {
      return Failure(e.message, code: e.code);
    } catch (e) {
      return Failure('Fehler beim Laden', exception: e as Exception?);
    }
  }
}

// Provider
final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepository(
    apiClient: ref.watch(kickbaseApiClientProvider),
  );
});
```

---

#### 4. **Data Provider erstellen**

**Datei**: `lib/data/providers/my_providers.dart`

```dart
/// Provider für My Data
final myDataProvider = FutureProvider.family<List<MyModel>, String>(
  (ref, leagueId) async {
    final repository = ref.watch(myRepositoryProvider);
    final result = await repository.getMyData(leagueId);
    
    return result.when(
      success: (data) => data,
      failure: (message, code) => throw Exception(message),
    );
  },
);

/// Derived Provider: Selected Item
final selectedMyModelProvider = NotifierProvider<
  SelectedMyModelNotifier,
  MyModel?
>(SelectedMyModelNotifier.new);

class SelectedMyModelNotifier extends Notifier<MyModel?> {
  @override
  MyModel? build() => null;
  
  void select(MyModel? item) => state = item;
}
```

---

#### 5. **Widget/Page erstellen**

**Datei**: `lib/presentation/pages/my_feature/my_page.dart`

```dart
class MyPage extends ConsumerWidget {
  const MyPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final myDataAsync = ref.watch(myDataProvider(selectedLeague.id));
    
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: myDataAsync.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(error: error),
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(item.name),
              onTap: () {
                ref.read(selectedMyModelProvider.notifier).select(item);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Refresh data
          ref.invalidate(myDataProvider(selectedLeague.id));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

---

#### 6. **Route hinzufügen**

**Datei**: `lib/config/router.dart`

```dart
GoRoute(
  path: '/my-feature',
  builder: (context, state) => const MyPage(),
),
```

---

#### 7. **Tests schreiben**

**Datei**: `test/data/repositories/my_repository_test.dart`

```dart
void main() {
  group('MyRepository', () {
    late MyRepository repository;
    late MockKickbaseAPIClient mockApiClient;
    
    setUp(() {
      mockApiClient = MockKickbaseAPIClient();
      repository = MyRepository(apiClient: mockApiClient);
    });
    
    test('getMyData returns Success with data', () async {
      // Arrange
      final mockData = [
        MyModel(id: '1', name: 'Test'),
      ];
      when(mockApiClient.getMyData(any))
          .thenAnswer((_) async => mockData);
      
      // Act
      final result = await repository.getMyData('league123');
      
      // Assert
      expect(result, isA<Success<List<MyModel>>>());
      result.when(
        success: (data) => expect(data, hasLength(1)),
        failure: (_, __) => fail('Should not fail'),
      );
    });
  });
}
```

---

### Bestehende Funktionen erweitern

#### Provider erweitern
```dart
// Neue Methode in Notifier hinzufügen
class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() => const MyState();
  
  // Neue Methode
  Future<void> newAction() async {
    state = state.copyWith(isLoading: true);
    try {
      // Logic
      state = state.copyWith(isLoading: false, data: newData);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

#### Model erweitern
```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    // ✅ Neues Feld hinzufügen
    String? newField,
  }) = _MyModel;
  
  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**Code neu generieren**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Widget erweitern
```dart
class MyWidget extends ConsumerWidget {
  final String title;
  // ✅ Neuer Parameter
  final VoidCallback? onTap;
  
  const MyWidget({
    super.key,
    required this.title,
    this.onTap, // Optional
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Text(title),
    );
  }
}
```

---

### Debugging & Logging

#### Logger verwenden

```dart
import 'package:logger/logger.dart';

final _logger = Logger();

class MyClass {
  void myMethod() {
    _logger.d('Debug message');
    _logger.i('Info message');
    _logger.w('Warning message');
    _logger.e('Error message', error: exception, stackTrace: stackTrace);
  }
}
```

#### Provider-State debuggen

```dart
final myProvider = NotifierProvider<MyNotifier, MyState>((ref) {
  ref.listenSelf((previous, next) {
    print('State changed: $previous → $next');
  });
  return MyNotifier();
});
```

#### Flutter DevTools nutzen

- **Provider Inspector**: Alle aktiven Provider anzeigen
- **Widget Inspector**: UI-Hierarchie analysieren
- **Network Inspector**: HTTP-Requests überwachen
- **Logging View**: Alle Logger-Ausgaben

---

## Zusätzliche Ressourcen

### Interne Dokumentation

- [Phase 1: Setup](docs/PHASE_1_SETUP.md)
- [Phase 2: Models](docs/PHASE_2_MODELS.md)
- [Phase 3: Firebase](docs/PHASE_3_FIREBASE.md)
- [Phase 4: Services](docs/PHASE_4_SERVICES.md)
- [Phase 5: UI](docs/PHASE_5_UI.md)
- [Phase 6: Testing](docs/PHASE_6_TESTING.md)
- [Phase 7: Deployment](docs/PHASE_7_DEPLOYMENT.md)
- [Riverpod Providers](docs/RIVERPOD_PROVIDERS.md)
- [Router Quickstart](docs/ROUTER_QUICKSTART.md)
- [Repository Usage](docs/REPOSITORY_USAGE_EXAMPLES.md)
- [Auth Examples](docs/AUTH_USAGE_EXAMPLES.md)
- [HTTP Client Usage](docs/HTTP_CLIENT_WRAPPER_USAGE.md)

### Externe Ressourcen

- [Flutter Dokumentation](https://flutter.dev/docs)
- [Riverpod Dokumentation](https://riverpod.dev)
- [GoRouter Dokumentation](https://pub.dev/packages/go_router)
- [Freezed Dokumentation](https://pub.dev/packages/freezed)
- [Firebase Flutter](https://firebase.flutter.dev)

---

## Kontakt & Support

Bei Fragen oder Problemen:
1. Überprüfe zuerst diese Dokumentation
2. Suche in den internen Docs (`docs/` Verzeichnis)
3. Kontaktiere das Entwicklerteam

---

**Letzte Aktualisierung**: Februar 2026  
**Dokumentations-Version**: 1.0  
**Maintainer**: KickbaseKumpel Team
