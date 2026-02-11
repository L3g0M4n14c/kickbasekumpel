# Navigation Structure Visual Guide

## Old Navigation Structure (Flat - 7 Items)

```
┌─────────────────────────────────────────────────────────────────┐
│  Bottom Navigation Bar / Drawer / Rail                         │
├─────────────────────────────────────────────────────────────────┤
│  [Home] [Live] [Ligen] [Markt] [Aufstellung] [Transfers] [⚙]  │
└─────────────────────────────────────────────────────────────────┘

Additional Access:
• Ligainsider - via button/link from various screens
```

## New Navigation Structure (Hierarchical - 5 Items with Tabs)

```
┌─────────────────────────────────────────────────────────────────┐
│  Bottom Navigation Bar / Drawer / Rail                         │
├─────────────────────────────────────────────────────────────────┤
│  [Team] [Markt] [Liga] [Ligainsider] [⚙]                      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Team - Tabs                                                     │
├─────────────────────────────────────────────────────────────────┤
│  [Kader] [Empfohlene Aufstellung] [Verkaufen] [Live]          │
│                                                                  │
│  Content Area:                                                   │
│  • Kader: Squad overview with budget and players               │
│  • Empfohlene Aufstellung: Recommended lineup editor            │
│  • Verkaufen: List of squad players with sell buttons          │
│  • Live: Live match updates and scores                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Markt - Tabs                                                    │
├─────────────────────────────────────────────────────────────────┤
│  [Transfermarkt] [Transfer-Tipps]                              │
│                                                                  │
│  Content Area:                                                   │
│  • Transfermarkt: Browse and buy players                       │
│    └─ Has own tabs: [Verfügbar] [Meine Angebote]              │
│                     [Erhaltene Angebote] [Beobachtungsliste]   │
│  • Transfer-Tipps: AI-powered recommendations                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Liga - No Tabs                                                  │
├─────────────────────────────────────────────────────────────────┤
│  Content Area:                                                   │
│  • Bundesliga standings table                                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Ligainsider - No Tabs                                          │
├─────────────────────────────────────────────────────────────────┤
│  Content Area:                                                   │
│  • Predicted lineups for upcoming matches                      │
└─────────────────────────────────────────────────────────────────┘
```

## Navigation Flow Examples

### Example 1: Viewing Squad and Selling a Player
```
User Journey (Old):
1. Tap "Home" or "Aufstellung" → View squad
2. Find sell option separately

User Journey (New):
1. Tap "Team" → Automatically on "Kader" tab
2. Swipe or tap "Verkaufen" tab → View squad with sell buttons
   ✓ All team management in one place
```

### Example 2: Browsing Market and Checking Recommendations
```
User Journey (Old):
1. Tap "Markt" → Browse players
2. Tap "Transfers" → View recommendations
   ✗ Two separate navigation items

User Journey (New):
1. Tap "Markt" → Automatically on "Transfermarkt" tab
2. Swipe or tap "Transfer-Tipps" tab → View recommendations
   ✓ All market activities in one place
```

### Example 3: Checking Live Scores
```
User Journey (Old):
1. Tap "Live" → View live scores

User Journey (New):
1. Tap "Team" → Tap "Live" tab
   ✓ Contextually grouped with team management
```

## Design Rationale

### Grouping Logic

**Team Group**
- All player/squad management features
- Live scores related to team performance
- Cohesive "my team" experience

**Markt Group**
- Market browsing and purchasing
- Transfer recommendations
- All buying/selling activities

**Liga**
- League information standalone
- Room for expansion (could add tabs for stats, schedules, etc.)

**Ligainsider**
- Specialized tool for lineup predictions
- Standalone as it's a distinct feature

**Einstellungen**
- Settings always separate
- Standard UX pattern
