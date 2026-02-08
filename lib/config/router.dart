import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/kickbase_auth_provider.dart';
import '../presentation/pages/auth/signin_page.dart';
// import '../presentation/pages/auth/signup_page.dart';
// import '../presentation/pages/auth/forgot_password_page.dart';
// import '../presentation/pages/auth/verify_email_page.dart';
import '../presentation/pages/dashboard/dashboard_shell.dart';
import '../presentation/pages/dashboard/home_page.dart';
import '../presentation/pages/dashboard/leagues_page.dart';
import '../presentation/pages/dashboard/market_page.dart';
import '../presentation/pages/dashboard/lineup_page.dart';
import '../presentation/pages/dashboard/transfers_page.dart';
import '../presentation/pages/dashboard/settings_page.dart';
import '../presentation/pages/league/league_overview_page.dart';
import '../presentation/pages/league/league_standings_page.dart';
import '../presentation/pages/league/league_players_page.dart';
import '../presentation/pages/player/player_stats_page.dart';
import '../presentation/pages/player/player_history_page.dart';
import '../presentation/pages/error_page.dart';
import '../presentation/screens/ligainsider/ligainsider_screen.dart';
import '../presentation/screens/live_screen.dart';
import '../presentation/screens/manager_detail_screen.dart';
import '../presentation/screens/league_table_screen.dart';

// ============================================================================
// ROUTER PROVIDER
// ============================================================================

/// GoRouter Provider mit Riverpod
/// Managed Routing, Deep Linking und Kickbase Authentication State
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isKickbaseAuthenticatedProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = isAuthenticated;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');

      // Wenn nicht authentifiziert und nicht auf Auth-Seite → zu /auth/signin
      if (!isAuth && !isGoingToAuth) {
        return '/auth/signin';
      }

      // Wenn authentifiziert und auf Auth-Seite → zu /dashboard
      if (isAuth && isGoingToAuth) {
        return '/dashboard';
      }

      return null; // Keine Weiterleitung
    },
    routes: [
      // ======================================================================
      // ROOT ROUTE - Auth Wrapper
      // ======================================================================
      GoRoute(
        path: '/',
        name: 'root',
        redirect: (context, state) => '/dashboard',
      ),

      // ======================================================================
      // AUTH STACK - Kickbase Login Only
      // ======================================================================
      GoRoute(
        path: '/auth',
        name: 'auth',
        redirect: (context, state) => '/auth/signin',
      ),
      GoRoute(
        path: '/auth/signin',
        name: 'signin',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignInPage()),
      ),
      // SignUp, Forgot Password, and Verify Email are not available for Kickbase API
      // Users must use kickbase.com to create accounts or reset passwords
      // GoRoute(
      //   path: '/auth/signup',
      //   name: 'signup',
      //   pageBuilder: (context, state) =>
      //       MaterialPage(key: state.pageKey, child: const SignUpPage()),
      // ),
      // GoRoute(
      //   path: '/auth/forgot-password',
      //   name: 'forgot-password',
      //   pageBuilder: (context, state) =>
      //       MaterialPage(key: state.pageKey, child: const ForgotPasswordPage()),
      // ),
      // GoRoute(
      //   path: '/auth/verify',
      //   name: 'verify',
      //   pageBuilder: (context, state) =>
      //       MaterialPage(key: state.pageKey, child: const VerifyEmailPage()),
      // ),

      // ======================================================================
      // DASHBOARD STACK - Mit StatefulShellRoute für BottomNavigationBar
      // ======================================================================
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return MaterialPage(
            key: state.pageKey,
            child: DashboardShell(navigationShell: navigationShell),
          );
        },
        branches: [
          // Home Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          // Live Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/live',
                name: 'live',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: LiveScreen()),
              ),
            ],
          ),
          // Leagues Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/leagues',
                name: 'leagues',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: LeaguesPage()),
              ),
            ],
          ),
          // Market Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/market',
                name: 'market',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MarketPage()),
              ),
            ],
          ),
          // Lineup Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/lineup',
                name: 'lineup',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: LineupPage()),
              ),
            ],
          ),
          // Transfers Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/transfers',
                name: 'transfers',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TransfersPage()),
              ),
            ],
          ),
          // Settings Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard/settings',
                name: 'settings',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsPage()),
              ),
            ],
          ),
        ],
      ),

      // ======================================================================
      // LEAGUE DETAIL STACK
      // ======================================================================
      GoRoute(
        path: '/league/:leagueId',
        name: 'league',
        redirect: (context, state) {
          final leagueId = state.pathParameters['leagueId'];
          return '/league/$leagueId/overview';
        },
      ),

      // ======================================================================
      // LIGAINSIDER - Voraussichtliche Aufstellungen
      // ======================================================================
      GoRoute(
        path: '/ligainsider/lineups',
        name: 'ligainsider',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LigainsiderScreen()),
      ),

      // ======================================================================
      // MANAGER DETAIL - Manager Profile & Squad
      // ======================================================================
      GoRoute(
        path: '/manager/:leagueId/:userId',
        name: 'manager-detail',
        pageBuilder: (context, state) {
          final leagueId = state.pathParameters['leagueId']!;
          final userId = state.pathParameters['userId']!;
          return MaterialPage(
            key: state.pageKey,
            child: ManagerDetailScreen(leagueId: leagueId, userId: userId),
          );
        },
      ),

      // ======================================================================
      // COMPETITION TABLE - Bundesliga Tabelle
      // ======================================================================
      GoRoute(
        path: '/table/:competitionId',
        name: 'competition-table',
        pageBuilder: (context, state) {
          final competitionId = state.pathParameters['competitionId']!;
          return MaterialPage(
            key: state.pageKey,
            child: LeagueTableScreen(competitionId: competitionId),
          );
        },
      ),

      // ======================================================================
      // LEAGUE DETAIL STACK
      // ======================================================================
      GoRoute(
        path: '/league/:leagueId/overview',
        name: 'league-overview',
        pageBuilder: (context, state) {
          final leagueId = state.pathParameters['leagueId']!;
          return MaterialPage(
            key: state.pageKey,
            child: LeagueOverviewPage(leagueId: leagueId),
          );
        },
      ),
      GoRoute(
        path: '/league/:leagueId/standings',
        name: 'league-standings',
        pageBuilder: (context, state) {
          final leagueId = state.pathParameters['leagueId']!;
          return MaterialPage(
            key: state.pageKey,
            child: LeagueStandingsPage(leagueId: leagueId),
          );
        },
      ),
      GoRoute(
        path: '/league/:leagueId/players',
        name: 'league-players',
        pageBuilder: (context, state) {
          final leagueId = state.pathParameters['leagueId']!;
          return MaterialPage(
            key: state.pageKey,
            child: LeaguePlayersPage(leagueId: leagueId),
          );
        },
      ),

      // ======================================================================
      // PLAYER DETAIL STACK
      // ======================================================================
      GoRoute(
        path: '/player/:playerId',
        name: 'player',
        redirect: (context, state) {
          final playerId = state.pathParameters['playerId'];
          return '/player/$playerId/stats';
        },
      ),
      GoRoute(
        path: '/player/:playerId/stats',
        name: 'player-stats',
        pageBuilder: (context, state) {
          final playerId = state.pathParameters['playerId']!;
          return MaterialPage(
            key: state.pageKey,
            child: PlayerStatsPage(playerId: playerId),
          );
        },
      ),
      GoRoute(
        path: '/player/:playerId/history',
        name: 'player-history',
        pageBuilder: (context, state) {
          final playerId = state.pathParameters['playerId']!;
          return MaterialPage(
            key: state.pageKey,
            child: PlayerHistoryPage(playerId: playerId),
          );
        },
      ),
    ],

    // Error Handler
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
  );
});

// Backward compatibility alias
final goRouterProvider = routerProvider;

// ============================================================================
// ROUTER HELPERS - Extension Methods
// ============================================================================

/// Extension für einfache Navigation mit BuildContext
extension GoRouterExtensions on BuildContext {
  /// Navigation zu einer Route mit go()
  void goTo(String path) => go(path);

  /// Navigation mit Named Route
  void goNamed(String name, {Map<String, String>? params, Object? extra}) {
    pushNamed(name, pathParameters: params ?? {}, extra: extra);
  }

  /// Zurück navigieren
  void goBack() => pop();

  /// Kann zurück navigieren?
  bool get canGoBack => canPop();

  // Dashboard Routes
  void goToDashboard() => go('/dashboard');
  void goToLive() => go('/dashboard/live');
  void goToLeagues() => go('/dashboard/leagues');
  void goToMarket() => go('/dashboard/market');
  void goToLineup() => go('/dashboard/lineup');
  void goToTransfers() => go('/dashboard/transfers');
  void goToSettings() => go('/dashboard/settings');

  // Auth Routes
  void goToSignIn() => go('/auth/signin');
  void goToSignUp() => go('/auth/signup');
  void goToForgotPassword() => go('/auth/forgot-password');
  void goToVerifyEmail() => go('/auth/verify');

  // League Routes
  void goToLeague(String leagueId) => go('/league/$leagueId/overview');
  void goToLeagueStandings(String leagueId) =>
      go('/league/$leagueId/standings');
  void goToLeaguePlayers(String leagueId) => go('/league/$leagueId/players');

  // Player Routes
  void goToPlayer(String playerId) => go('/player/$playerId/stats');
  void goToPlayerHistory(String playerId) => go('/player/$playerId/history');

  // Manager Routes
  void goToManager(String leagueId, String userId) =>
      go('/manager/$leagueId/$userId');

  // Competition Routes
  void goToTable(String competitionId) => go('/table/$competitionId');
  void goToBundesligaTable() => go('/table/1');
}

// ============================================================================
// ROUTER KEYS - Für Tests und programmatischen Zugriff
// ============================================================================

/// Router Keys für programmatischen Zugriff
class RouterKeys {
  static const root = 'root';
  static const auth = 'auth';
  static const signin = 'signin';
  static const signup = 'signup';
  static const forgotPassword = 'forgot-password';
  static const verify = 'verify';
  static const dashboard = 'dashboard';
  static const live = 'live';
  static const leagues = 'leagues';
  static const market = 'market';
  static const lineup = 'lineup';
  static const transfers = 'transfers';
  static const settings = 'settings';
  static const league = 'league';
  static const leagueOverview = 'league-overview';
  static const leagueStandings = 'league-standings';
  static const leaguePlayers = 'league-players';
  static const player = 'player';
  static const playerStats = 'player-stats';
  static const playerHistory = 'player-history';
  static const managerDetail = 'manager-detail';
  static const competitionTable = 'competition-table';
}
