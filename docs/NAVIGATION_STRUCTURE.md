# Navigation Structure Update

## Overview
The app navigation has been reorganized from a flat structure to a hierarchical structure with main navigation items and sub-tabs.

## New Navigation Structure

### Main Navigation (Bottom Bar / Drawer / Rail)
1. **Team** - Team management
2. **Markt** - Market and transfers
3. **Liga** - League information
4. **Ligainsider** - Predicted lineups
5. **Einstellungen** - Settings

### Sub-Navigation (Tabs)

#### Team
- **Kader** - Squad overview with budget and team value
- **Empfohlene Aufstellung** - Recommended lineup
- **Verkaufen** - Sell players from your squad
- **Live** - Live match updates

#### Markt
- **Transfermarkt** - Browse and buy players (includes its own tabs: Verfügbar, Meine Angebote, Erhaltene Angebote, Beobachtungsliste)
- **Transfer-Tipps** - AI-powered transfer recommendations

#### Liga
- **Tabelle** - League standings (Bundesliga)
  - Note: Currently displays only the Bundesliga table. The tab structure was removed as there's only one view.

#### Ligainsider
- No sub-tabs, displays predicted lineups directly

## Migration from Old Structure

### Route Changes
- `/dashboard` → Now shows TeamPage (was HomePage)
- `/dashboard/live` → Now accessible via Team → Live tab
- `/dashboard/lineup` → Now accessible via Team → Empfohlene Aufstellung tab
- `/dashboard/market` → Now accessible via Markt → Transfermarkt tab
- `/dashboard/transfers` → Now accessible via Markt → Transfer-Tipps tab
- `/dashboard/leagues` → Removed (Liga info in Liga tab)
- `/ligainsider/lineups` → `/dashboard/ligainsider`

### Backward Compatibility
- Deprecated route methods are available in router.dart with `@Deprecated` annotations
- Old routes will redirect to appropriate new locations

## Implementation Details

### New Pages
- `lib/presentation/pages/dashboard/team_page.dart` - Team page with 4 tabs
- `lib/presentation/pages/dashboard/markt_page.dart` - Market page with 2 tabs
- `lib/presentation/pages/dashboard/liga_page.dart` - League page (simplified, no tabs needed)
- `lib/presentation/pages/dashboard/ligainsider_page.dart` - Ligainsider standalone page

### Updated Files
- `lib/config/router.dart` - Updated routes and navigation
- `lib/presentation/pages/dashboard/dashboard_shell.dart` - Updated main navigation items (5 instead of 7)

### Reused Components
- `SquadScreen` - Used in Team → Kader tab
- `LineupPage` - Used in Team → Empfohlene Aufstellung tab
- `LiveScreen` - Used in Team → Live tab
- `MarketScreen` - Used in Markt → Transfermarkt tab
- `LeagueTableScreen` - Used in Liga → Tabelle tab
- `LigainsiderScreen` - Used in Ligainsider page

## Benefits
1. **Cleaner Navigation** - Reduced from 7 to 5 main navigation items
2. **Logical Grouping** - Related features grouped under main categories
3. **Better UX** - Users can quickly switch between related features using tabs
4. **Scalability** - Easier to add new features under existing categories
