# GoRouter Setup - KickbaseKumpel

Vollständiges GoRouter Setup mit Material Design 3, Riverpod, Authentication und Nested Navigation.

## 📁 Struktur

```
lib/
├── config/
│   └── router.dart                    # GoRouter Provider & Extensions
└── presentation/
    └── pages/
        ├── auth/                       # Auth Screens
        │   ├── signin_page.dart
        │   ├── signup_page.dart
        │   ├── forgot_password_page.dart
        │   └── verify_email_page.dart
        ├── dashboard/                  # Dashboard mit BottomNav
        │   ├── dashboard_shell.dart    # Shell mit BottomNavigationBar
        │   ├── leagues_page.dart
        │   ├── market_page.dart
        │   ├── lineup_page.dart
        │   ├── transfers_page.dart
        │   └── settings_page.dart
        ├── league/                     # Liga Details
        │   ├── league_overview_page.dart
        │   ├── league_standings_page.dart
        │   └── league_players_page.dart
        ├── player/                     # Spieler Details
        │   ├── player_stats_page.dart
        │   └── player_history_page.dart
        └── error_page.dart             # Error Handler
```

## 🚀 Features

✅ **Authentication Redirect**
- Automatische Weiterleitung zu `/auth/signin` wenn nicht angemeldet
- Automatische Weiterleitung zu `/dashboard` wenn angemeldet

✅ **Persistent BottomNavigationBar**
- StatefulShellRoute für Tab-Navigation
- State bleibt erhalten beim Tab-Wechsel
- NoTransitionPage für nahtlose Übergänge

✅ **Deep Linking Support**
- Alle Routes unterstützen Deep Links
- URL-Parameter für dynamische IDs

✅ **Named Routes**
- Type-safe Navigation mit Named Routes
- RouterKeys für programmatischen Zugriff

✅ **Error Handling**
- Automatische Error Page bei ungültigen Routes
- Benutzerfreundliche Fehlermeldungen

## 📍 Routes Übersicht

### Root & Auth
```
/ (root)                  → Redirect zu /dashboard
/auth                     → Redirect zu /auth/signin
/auth/signin              → Sign In Screen
/auth/signup              → Sign Up Screen
/auth/forgot-password     → Password Reset
/auth/verify              → Email Verification
```

### Dashboard (mit BottomNav)
```
/dashboard                → Home Overview
/dashboard/leagues        → League List
/dashboard/market         → Market
/dashboard/lineup         → Lineup Manager
/dashboard/transfers      → Transfer Recommendations
/dashboard/settings       → Settings
```

### League Details
```
/league/:leagueId         → Redirect zu /league/:leagueId/overview
/league/:leagueId/overview    → League Overview
/league/:leagueId/standings   → League Standings
/league/:leagueId/players     → League Players
```

### Player Details
```
/player/:playerId         → Redirect zu /player/:playerId/stats
/player/:playerId/stats       → Player Stats
/player/:playerId/history     → Player History
```

## 💻 Verwendung

### 1. Basic Navigation

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Mit go()
context.go('/dashboard');
context.go('/league/abc123/overview');

// Mit Named Routes
context.pushNamed('player-stats', pathParameters: {'playerId': '12345'});
context.pushNamed('league-standings', pathParameters: {'leagueId': 'xyz'});

// Zurück navigieren
context.pop();
if (context.canPop()) {
  context.pop();
}
```

### 2. Mit Extension Methods

```dart
import 'package:kickbasekumpel/config/router.dart';

// Dashboard
context.goToDashboard();
context.goToLeagues();
context.goToMarket();
context.goToLineup();
context.goToTransfers();
context.goToSettings();

// Auth
context.goToSignIn();
context.goToSignUp();
context.goToForgotPassword();

// League
context.goToLeague('leagueId');
context.goToLeagueStandings('leagueId');
context.goToLeaguePlayers('leagueId');

// Player
context.goToPlayer('playerId');
context.goToPlayerHistory('playerId');

// Zurück
context.goBack();
if (context.canGoBack) {
  context.goBack();
}
```

### 3. Mit RouterKeys

```dart
import 'package:kickbasekumpel/config/router.dart';

context.pushNamed(RouterKeys.dashboard);
context.pushNamed(RouterKeys.playerStats, pathParameters: {'playerId': '123'});
context.pushNamed(RouterKeys.leagueStandings, pathParameters: {'leagueId': 'abc'});
```

### 4. In ConsumerWidget mit ref

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/config/router.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Router ist bereits in main.dart eingebunden
    // Direkt context.go() verwenden
    
    return ElevatedButton(
      onPressed: () => context.goToDashboard(),
      child: const Text('Zum Dashboard'),
    );
  }
}
```

### 5. Navigation mit Parametern

```dart
// League Details mit ID
final leagueId = 'my-league-123';
context.goToLeague(leagueId);

// Player Details mit ID
final playerId = 'player-456';
context.goToPlayer(playerId);

// Oder mit go()
context.go('/league/$leagueId/standings');
context.go('/player/$playerId/history');
```

### 6. BottomNavigationBar Navigation

Die Dashboard-Tabs werden automatisch über die `DashboardShell` verwaltet:

```dart
// Tabs werden über StatefulShellRoute verwaltet
// State bleibt bei Tab-Wechsel erhalten
// Einfach zu den jeweiligen Routes navigieren:

context.go('/dashboard');           // Tab 0: Home
context.go('/dashboard/leagues');   // Tab 1: Leagues
context.go('/dashboard/market');    // Tab 2: Market
context.go('/dashboard/lineup');    // Tab 3: Lineup
context.go('/dashboard/transfers'); // Tab 4: Transfers
context.go('/dashboard/settings');  // Tab 5: Settings
```

### 7. Deep Links

Deep Links werden automatisch unterstützt:

```
kickbasekumpel://league/abc123/overview
kickbasekumpel://player/12345/stats
kickbasekumpel://dashboard/market
```

### 8. Authentication Redirect

Der Router prüft automatisch den Auth-Status:

```dart
// In lib/config/router.dart
redirect: (context, state) {
  final isAuth = isAuthenticated;
  final isGoingToAuth = state.matchedLocation.startsWith('/auth');

  // Nicht angemeldet → /auth/signin
  if (!isAuth && !isGoingToAuth) {
    return '/auth/signin';
  }

  // Angemeldet → /dashboard
  if (isAuth && isGoingToAuth) {
    return '/dashboard';
  }

  return null;
}
```

## 🎯 Beispiele

### Navigation nach Login

```dart
// In SignInPage
Future<void> _handleSignIn() async {
  final success = await ref.read(authNotifierProvider.notifier).signIn(
    email: _emailController.text,
    password: _passwordController.text,
  );

  if (success && mounted) {
    context.goToDashboard(); // Automatisch zu /dashboard
  }
}
```

### Navigation zu Liga-Details

```dart
// In LeaguesPage
ListTile(
  title: Text(league.name),
  onTap: () => context.goToLeague(league.id),
)
```

### Navigation zu Spieler-Details

```dart
// In MarketPage
ListTile(
  title: Text(player.name),
  onTap: () => context.goToPlayer(player.id),
)
```

### Tab-Wechsel im Dashboard

```dart
// In HomePage
ElevatedButton(
  onPressed: () => context.goToMarket(),
  child: const Text('Zum Markt'),
)
```

### Logout

```dart
// In SettingsPage
Future<void> _handleLogout() async {
  await ref.read(authNotifierProvider.notifier).signOut();
  
  if (mounted) {
    context.goToSignIn(); // Automatisch zu /auth/signin
  }
}
```

## 🔧 Anpassungen

### Neue Route hinzufügen

1. Screen erstellen in `lib/presentation/pages/`
2. Route in `router.dart` hinzufügen:

```dart
GoRoute(
  path: '/meine-route/:id',
  name: 'meine-route',
  pageBuilder: (context, state) {
    final id = state.pathParameters['id']!;
    return MaterialPage(
      key: state.pageKey,
      child: MeineRoutePage(id: id),
    );
  },
)
```

3. Extension Method hinzufügen:

```dart
extension GoRouterExtensions on BuildContext {
  void goToMeineRoute(String id) => go('/meine-route/$id');
}
```

4. Router Key hinzufügen:

```dart
class RouterKeys {
  static const meineRoute = 'meine-route';
}
```

### BottomNav Tab hinzufügen

1. Screen erstellen
2. In `DashboardShell` NavigationDestination hinzufügen
3. In `StatefulShellRoute.indexedStack` neue Branch hinzufügen

## 📚 Weitere Infos

- [GoRouter Dokumentation](https://pub.dev/packages/go_router)
- [Riverpod Dokumentation](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)

## ✅ Checkliste

- [x] GoRouter Provider mit Riverpod
- [x] Authentication Redirect
- [x] StatefulShellRoute für BottomNav
- [x] Named Routes
- [x] Deep Linking Support
- [x] Error Page
- [x] Extension Methods
- [x] Router Keys
- [x] Auth Screens (4)
- [x] Dashboard Screens (6)
- [x] League Screens (3)
- [x] Player Screens (2)
- [x] Error Page
