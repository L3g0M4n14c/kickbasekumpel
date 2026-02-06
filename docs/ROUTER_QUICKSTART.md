# GoRouter Quick Start - KickbaseKumpel

## 🚀 Schnellstart

Das GoRouter Setup ist vollständig eingerichtet und sofort einsatzbereit!

## 📱 Verwendung in deinen Screens

### Navigation verwenden

```dart
import 'package:flutter/material.dart';
import 'package:kickbasekumpel/config/router.dart'; // Für Extensions

class MeinWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Einfache Navigation mit Extensions
      onPressed: () => context.goToDashboard(),
      child: const Text('Zum Dashboard'),
    );
  }
}
```

### Alle verfügbaren Navigation-Methoden

```dart
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
context.goToVerifyEmail();

// League (mit ID)
context.goToLeague('leagueId');
context.goToLeagueStandings('leagueId');
context.goToLeaguePlayers('leagueId');

// Player (mit ID)
context.goToPlayer('playerId');
context.goToPlayerHistory('playerId');

// Zurück
context.goBack();
if (context.canGoBack) {
  context.goBack();
}
```

## 🎨 Verfügbare Screens

### ✅ Auth Screens (Fertig)
- `/auth/signin` - SignInPage
- `/auth/signup` - SignUpPage
- `/auth/forgot-password` - ForgotPasswordPage
- `/auth/verify` - VerifyEmailPage

### ✅ Dashboard (Fertig mit BottomNav)
- `/dashboard` - HomePage
- `/dashboard/leagues` - LeaguesPage
- `/dashboard/market` - MarketPage
- `/dashboard/lineup` - LineupPage
- `/dashboard/transfers` - TransfersPage
- `/dashboard/settings` - SettingsPage

### ✅ League Details (Fertig)
- `/league/:leagueId/overview` - LeagueOverviewPage
- `/league/:leagueId/standings` - LeagueStandingsPage
- `/league/:leagueId/players` - LeaguePlayersPage

### ✅ Player Details (Fertig)
- `/player/:playerId/stats` - PlayerStatsPage
- `/player/:playerId/history` - PlayerHistoryPage

## 🔐 Authentication Flow

Der Router prüft automatisch den Auth-Status:

**Nicht angemeldet:**
- Jede Route außer `/auth/*` → Redirect zu `/auth/signin`

**Angemeldet:**
- `/auth/*` → Redirect zu `/dashboard`
- Alle anderen Routes sind zugänglich

## 📝 TODO: Screens mit echten Daten füllen

Die Screens sind als Platzhalter erstellt. Nächste Schritte:

### 1. Auth Screens verbinden
```dart
// In SignInPage
final authNotifier = ref.read(authNotifierProvider.notifier);
await authNotifier.signIn(email: email, password: password);
```

### 2. Dashboard mit Riverpod Providern füllen
```dart
// In HomePage
final userAsync = ref.watch(currentUserProvider);
final leaguesAsync = ref.watch(userLeaguesFutureProvider);
```

### 3. League Screens mit echten Daten
```dart
// In LeagueOverviewPage
final league = ref.watch(leagueDetailsProvider(leagueId));
```

### 4. Player Screens mit echten Daten
```dart
// In PlayerStatsPage
final player = ref.watch(playerDetailsProvider(playerId));
```

## 🎯 Nächste Implementierungsschritte

1. **Auth Screens funktional machen**
   - [ ] SignInPage: Auth Provider integrieren
   - [ ] SignUpPage: Registration implementieren
   - [ ] ForgotPasswordPage: Password Reset
   - [ ] VerifyEmailPage: Email Verification

2. **Dashboard mit echten Daten füllen**
   - [ ] HomePage: User Stats & Quick Actions
   - [ ] LeaguesPage: User Leagues Liste
   - [ ] MarketPage: Verfügbare Spieler
   - [ ] LineupPage: User Team Aufstellung
   - [ ] TransfersPage: Transfer Recommendations
   - [ ] SettingsPage: User Settings

3. **League Details implementieren**
   - [ ] LeagueOverviewPage: League Info & Stats
   - [ ] LeagueStandingsPage: Tabelle mit echten Daten
   - [ ] LeaguePlayersPage: League Spieler Liste

4. **Player Details implementieren**
   - [ ] PlayerStatsPage: Spieler Statistiken
   - [ ] PlayerHistoryPage: Transfer & Performance Historie

## 📚 Dokumentation

Vollständige Dokumentation: [docs/ROUTER_SETUP.md](./ROUTER_SETUP.md)

## ✨ Features

✅ Deep Linking  
✅ Named Routes  
✅ Type-safe Navigation  
✅ Authentication Redirect  
✅ Persistent BottomNavigationBar  
✅ Error Handling  
✅ Extension Methods für einfache Navigation

## 🎉 Ready to go!

Das Router-Setup ist vollständig und bereit für die Verwendung. Alle Screens sind erstellt und können jetzt mit echten Daten und Funktionen gefüllt werden!
