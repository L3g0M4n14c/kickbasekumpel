# Phase 5: UI Screens & Navigation (3h)

**Status:** ⏳ Nach Phase 4  
**Dauer:** 3 Stunden | **Copilot:** 60% | **User:** 40%  

---

## 🎯 Objectives

- GoRouter Navigation Setup mit Named Routes
- 6+ Flutter Screens implementieren
- Shared Widgets & Komponenten
- Material Design 3 Theme
- Responsive Layout
- State Management mit Riverpod

---

## 📱 Screen-Übersicht

Aus der iOS App MainDashboardView (3800+ Zeilen) migieren zu Flutter:

| Screen | Zweck | Complexity | Status |
|--------|-------|-----------|--------|
| 1. Auth Flow | Sign In, Sign Up, Verify | Low | ⏳ |
| 2. Dashboard / Tabs | Navigation Hub | Medium | ⏳ |
| 3. League List | Alle Ligen anzeigen | Low | ⏳ |
| 4. Market | Spieler kaufen/verkaufen | High | ⏳ |
| 5. Lineup Manager | Formation & Spieler | High | ⏳ |
| 6. Player Details | Stats & Trend Charts | Medium | ⏳ |
| 7. Transfers | Empfehlungen | High | ⏳ |
| 8. Ligainsider | Verletzungen & Form | Low | ⏳ |

---

## 🗺️ Phase 5a: GoRouter Navigation Setup

### GitHub Copilot Prompt (COPY-PASTE)

```
Ich habe ein Flutter Projekt mit Material Design 3 und Riverpod.

Erstelle ein komplettes GoRouter Setup für KickbaseKumpel:

lib/config/router.dart

Routes:

1. / (root)
   - AuthWrapper (prüfe: Logged in? → Dashboard : Auth)
   - Name: 'root'

2. /auth (Auth Stack)
   - /signin (Sign In Screen)
   - /signup (Sign Up Screen)
   - /forgot-password (Password Reset)
   - /verify (Email Verification)
   - Name: 'auth'

3. /dashboard (Main Stack - mit BottomNavBar)
   - /dashboard/home (Dashboard Overview)
   - /dashboard/leagues (League List)
   - /dashboard/market (Market)
   - /dashboard/lineup (Lineup Manager)
   - /dashboard/transfers (Transfer Recommendations)
   - /dashboard/settings (Settings)
   - Name: 'dashboard'

4. /league/:leagueId (League Detail Stack)
   - /league/:leagueId/overview
   - /league/:leagueId/standings
   - /league/:leagueId/players
   - Name: 'league'

5. /player/:playerId (Player Detail Stack)
   - /player/:playerId/stats
   - /player/:playerId/history
   - Name: 'player'

Features:

- Deep Linking support
- Named Routes für push(), canPop()
- Error Page bei ungültigen Routes
- AuthWrapper für Protected Routes
- BottomNavigationBar für Dashboard
- Nested Navigation für Tabs

Nutze:
- GoRouter für Routing
- Riverpod FutureProvider für Auth State
- StatefulShellRoute für Persistent BottomNav

Generiere auch Router Helper:
- context.go('/dashboard')
- context.pushNamed('player', extra: playerId)
- context.pop()
```

---

## 🖥️ Phase 5b: Screens Implementieren

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle die 6 Hauptscreens für KickbaseKumpel:

1. lib/presentation/screens/auth/
   ├── sign_in_screen.dart
   ├── sign_up_screen.dart
   ├── forgot_password_screen.dart
   └── email_verification_screen.dart

2. lib/presentation/screens/dashboard/
   ├── dashboard_screen.dart (Main mit Tabs)
   ├── home_screen.dart (Overview)
   ├── leagues_screen.dart (League List)
   ├── market_screen.dart (Buy/Sell Players)
   ├── lineup_screen.dart (Lineup Manager)
   ├── transfers_screen.dart (Recommendations)
   └── settings_screen.dart

3. lib/presentation/screens/league/
   ├── league_detail_screen.dart
   ├── league_standings_screen.dart
   └── league_players_screen.dart

4. lib/presentation/screens/player/
   ├── player_detail_screen.dart
   ├── player_stats_screen.dart
   └── player_history_screen.dart

Anforderungen für jeden Screen:

✅ ConsumerWidget für Riverpod Integration
✅ AsyncValue.when() für Loading/Error/Data States
✅ Material Design 3 Components (Card, Elevated Button, etc)
✅ Responsive: Mobile + Tablet support
✅ Bottom Sheet Modals
✅ RefreshIndicator für Pull-to-Refresh
✅ Error Handling mit Snackbars

Template pro Screen:

class XyzScreen extends ConsumerWidget {
  const XyzScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: asyncData.when(
        data: (data) => ListView(...),
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(error: error),
      ),
    );
  }
}

Wichtige Provider zu nutzen (aus Phase 3-4):
- authStateProvider (currentUser)
- leaguesProvider
- selectedLeagueProvider
- playersProvider
- recommendationsProvider
- userTransfersProvider
```

---

## 🎨 Phase 5c: Shared Widgets

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Wiederverwendbare Widgets für KickbaseKumpel:

lib/presentation/widgets/

1. AppBar Variants
   ├── custom_app_bar.dart
   ├── search_app_bar.dart
   └── tabbed_app_bar.dart

2. Cards & Lists
   ├── player_card.dart
   ├── league_card.dart
   ├── transfer_card.dart
   ├── match_card.dart
   ├── player_list_tile.dart
   └── league_list_tile.dart

3. Forms & Input
   ├── email_input_field.dart
   ├── password_input_field.dart
   ├── price_input_field.dart
   └── search_field.dart

4. Loading & Error
   ├── loading_widget.dart
   ├── error_widget.dart
   ├── empty_state_widget.dart
   └── retry_widget.dart

5. Charts & Stats
   ├── price_chart.dart (für MarketValue Trends)
   ├── stats_bar_chart.dart (für Points)
   ├── performance_line_chart.dart
   └── position_badge.dart

6. Buttons & Actions
   ├── action_button.dart
   ├── floating_action_menu.dart
   └── confirmation_dialog.dart

Anforderungen:

- Nutze Material Design 3 Components
- Dark Mode Support
- Null Safety überall
- Parameterized für Reusability
- Dokumentation in Comments
- Usage Examples

Template:

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;
  final bool showStats;

  const PlayerCard({
    required this.player,
    required this.onTap,
    this.showStats = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player Name, Image, etc
            ],
          ),
        ),
      ),
    );
  }
}

Diese Widgets sollen auch Preview/Demo Screens haben
```

---

## 🎨 Phase 5d: Theme & Styling

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle ein komplettes Material Design 3 Theme System:

lib/config/app_theme.dart

Features:

1. Color Scheme
   - Seed Color: #6366F1 (Indigo)
   - Light Theme Colors
   - Dark Theme Colors
   - Error/Warning/Success Colors

2. Typography
   - Display (Large, Medium, Small)
   - Headline (1-6)
   - Body (Large, Medium, Small)
   - Label (Large, Medium, Small)
   - Custom Fonts: Roboto

3. Component Themes
   - AppBar Theme (elevated, centered title)
   - Bottom Navigation Theme
   - Card Theme (radius, elevation)
   - Button Theme (style, padding)
   - Input Theme (outline borders, hints)
   - Dialog Theme

4. Custom Extensions
   - context.theme.primaryColor
   - context.theme.errorColor
   - textTheme.bodyLarge?.copyWith(...)
   - Custom Spacing Constants

5. Adaptive Themes
   - Light Mode (hell)
   - Dark Mode (dunkel)
   - Auto-detect System Preference

Code Struktur:

class AppTheme {
  static ColorScheme _lightColorScheme() => ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1),
    brightness: Brightness.light,
  );

  static ThemeData lightTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme(),
    appBarTheme: const AppBarTheme(...),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(...),
    // ... rest of theme
  );
}

Nutze auch Custom Color Extensions für Zugriff:
extension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;
}
```

---

## 📐 Phase 5e: Responsive Layout

### GitHub Copilot Prompt (COPY-PASTE)

```
Implementiere Responsive Design für alle Screens:

1. Mobile (< 600dp)
   - Full width Single Column
   - Bottom Sheets für Details
   - Bottom Navigation Bar

2. Tablet (600dp - 1200dp)
   - Split View (List + Details)
   - Drawer Navigation
   - Larger Cards

3. Desktop (> 1200dp)
   - Multi-column Layout
   - Sidebar Navigation
   - Advanced Filtering

Nutze:
- MediaQuery.of(context).size
- Breakpoints Constants
- LayoutBuilder für adaptive Widgets
- Responsive Grid System

Constants:

class ScreenSize {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;
  
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMaxWidth &&
      MediaQuery.of(context).size.width < tabletMaxWidth;
}

Implementiere in jedem Screen:
if (ScreenSize.isTablet(context)) {
  // Tablet Layout
} else {
  // Mobile Layout
}
```

---

## 📊 Screen Details: Market Screen (Komplexestes)

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle das komplexeste Screen - Market View:

lib/presentation/screens/dashboard/market_screen.dart

Features:

1. Tab Navigation
   - Available Players
   - My Selling Players
   - Recent Transfers
   - Watchlist

2. Filtering & Sorting
   - Position Filter
   - Price Range
   - Sort by: Price, Points, Form, etc
   - Search Bar (top)

3. Player List
   - Player Card mit:
     * Foto (CachedNetworkImage)
     * Name, Team, Position
     * Market Value (mit trend arrow)
     * Points (aktuell)
     * Buy Button
   - Pull-to-Refresh
   - Pagination / Infinite Scroll

4. Buy Flow (Bottom Sheet)
   - Player Details Mini-View
   - Price Input
   - Confirm Button
   - Loading State
   - Success Message

5. State Management (Riverpod)
   - marketPlayersProvider (Stream)
   - selectedPlayerProvider (StateProvider)
   - filterProvider (StateNotifier)
   - buyerProgressProvider (AsyncValue)

Nutze Riverpod Patterns:
- FamilyModifier für Filter Parameter
- AsyncValue.when() für States
- .select() für Performance
- StateNotifier für Filters

Error Handling:
- Insufficient Funds → Show Error
- Network Error → Retry Button
- Player Already Owned → Show Info
```

---

## ✅ Validierung

### Screen Checklist

- [ ] Alle 6+ Screens navigierbar
- [ ] GoRouter Deep Linking funktioniert
- [ ] Riverpod Provider korrekt integriert
- [ ] AsyncValue Loading/Error States
- [ ] Responsive auf Mobile & Tablet
- [ ] Dark Mode funktioniert
- [ ] Keine UI Glitches
- [ ] Snackbars für Fehler & Erfolg
- [ ] Pull-to-Refresh funktioniert

### Flutter Test

```bash
flutter test test/presentation/screens/ --coverage
flutter test test/presentation/widgets/ --coverage
```

---

## 🎯 Success Criteria

- [x] GoRouter vollständig konfiguriert
- [x] 6+ Screens implementiert
- [x] 15+ Wiederverwendbare Widgets
- [x] Material Design 3 Theme
- [x] Responsive Layouts (Mobile + Tablet)
- [x] Riverpod State Management
- [x] Dark Mode Support
- [x] Error Handling mit UI Feedback
- [x] Git Commit: "Phase 5: UI Screens & Navigation"

---

## 🔗 Nächster Schritt

Wenn Phase 5 fertig: → **[Phase 6: Testing](./PHASE_6_TESTING.md)**

---

## 📚 Referenzen

- **GoRouter:** https://pub.dev/packages/go_router
- **Material Design 3:** https://m3.material.io
- **Flutter Widgets:** https://docs.flutter.dev/ui/widgets
- **Responsive Design:** https://docs.flutter.dev/development/ui/layout/responsive

---

**Fortschritt:** Phase 1-4 (✅) → Phase 5 (⏳)  
**Copilot wird ~60% dieser Arbeit machen! User UI-Design input ~40%**
