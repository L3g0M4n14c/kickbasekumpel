# Market View Screen - Dokumentation

## Übersicht
Der Market View ist der komplexeste Screen der App mit umfangreichen Features für den Spielerhandel.

## Dateien

### 1. Market Providers (`lib/presentation/providers/market_providers.dart`)
**Riverpod State Management für Market Features**

#### Provider:
- **`marketFilterProvider`** - Notifier für Filter-State (Position, Price Range, Sort, Search)
- **`marketTabProvider`** - Notifier für aktiven Tab (Available, My Selling, Recent Transfers, Watchlist)
- **`marketPlayersProvider`** - StreamProvider für verfügbare Spieler mit Filtering & Sorting
- **`selectedPlayerProvider`** - Notifier für ausgewählten Spieler
- **`buyPlayerProvider`** - Notifier für Buy Flow mit AsyncValue State
- **`mySellingPlayersProvider`** - FutureProvider für eigene Verkaufsangebote
- **`watchlistProvider`** - Notifier für Merkliste
- **`watchlistPlayersProvider`** - FutureProvider für Merkliste-Spieler

#### Enums & Models:
```dart
enum MarketSortOption {
  price, priceDesc,
  points, pointsDesc,
  averagePoints, averagePointsDesc,
  marketValue, marketValueDesc,
  name
}

enum MarketTab {
  available,
  mySelling,
  recentTransfers,
  watchlist
}
```

#### Features:
- **Filtering**: Position, Price Range, Search Query
- **Sorting**: 9 verschiedene Sort-Optionen
- **Real-time Updates**: Stream mit 30-Sekunden-Polling
- **Error Handling**: Spezifische Fehler für Insufficient Funds, Already Owned, etc.

### 2. Market Screen (`lib/presentation/screens/dashboard/market_screen.dart`)
**Hauptscreen mit Tab Navigation**

#### Features:
- **4 Tabs**: Available Players, My Selling, Recent Transfers, Watchlist
- **Search Bar**: Real-time Suche über Spielername und Team
- **Filter Button**: Zeigt aktive Filter mit rotem Dot
- **Sort Menu**: PopupMenu mit allen Sort-Optionen
- **Pull-to-Refresh**: Auf allen Tabs
- **Empty States**: Individuelle für jeden Tab

#### Tabs:
1. **Available Players**: Alle verfügbaren Markt-Spieler
2. **My Selling**: Eigene Verkaufsangebote
3. **Recent Transfers**: Transfer-Historie der Liga
4. **Watchlist**: Gemerkte Spieler

### 3. Player Market Card (`lib/presentation/widgets/market/player_market_card.dart`)
**Widget für Spieler-Darstellung**

#### Features:
- **CachedNetworkImage**: Performantes Bild-Laden mit Placeholder
- **Player Stats**: Ø Punkte, Total Points, Position Badge
- **Price Display**: Mit Trend Arrow (▲/▼)
- **Watchlist Icon**: Toggle zum Merken/Entfernen
- **Offers Badge**: Zeigt Anzahl der Gebote
- **Sell Options**: Edit Price, Cancel Sale (nur bei eigenen Verkäufen)

#### Position Colors:
- Torwart (TW): Orange
- Abwehr (ABW): Blue
- Mittelfeld (MIT): Green
- Sturm (STU): Red

### 4. Buy Player Bottom Sheet (`lib/presentation/widgets/market/buy_player_bottom_sheet.dart`)
**Buy Flow mit Validation**

#### Features:
- **Player Mini View**: Name, Team, Stats
- **Budget Display**: Aktuelles Budget & verbleibendes Budget nach Kauf
- **Price Input**: Mit Validation (Min-Price, Max-Budget)
- **Quick Price Buttons**: Mindestpreis, +5%, +10%
- **Loading State**: Progress Indicator beim Kauf
- **Error Handling**: Colored Error Container mit Retry Button
- **Success Feedback**: SnackBar mit Check Icon

#### Validations:
- Preis >= Mindestpreis
- Preis <= verfügbares Budget
- Format: nur Zahlen mit max. 2 Dezimalstellen

### 5. Market Filters (`lib/presentation/widgets/market/market_filters.dart`)
**Bottom Sheet für Filtering**

#### Features:
- **Position Filter**: Chips für alle Positionen + "Alle"
- **Price Range**: RangeSlider (0-50M €)
- **Price Presets**: Quick-Buttons (< 5M, 5M-15M, 15M-30M, > 30M)
- **Clear All**: Setzt alle Filter zurück
- **Active Indicator**: Zeigt an, wenn Filter aktiv sind

#### Position Chips:
- Icon + Label pro Position
- Selected State mit Color
- Checkmark bei aktiver Auswahl

## Riverpod Patterns

### 1. Notifier Pattern (Riverpod 3.x)
```dart
class MarketFilterNotifier extends Notifier<MarketFilterState> {
  @override
  MarketFilterState build() => const MarketFilterState();
  
  void setPositionFilter(int? position) {
    state = state.copyWith(positionFilter: () => position);
  }
}
```

### 2. StreamProvider mit Filter
```dart
final marketPlayersProvider = StreamProvider.autoDispose<List<MarketPlayer>>((ref) async* {
  final filter = ref.watch(marketFilterProvider);
  // Stream mit Filter-Logic
  yield filteredPlayers;
});
```

### 3. AsyncValue für Loading/Error States
```dart
buyState.when(
  data: (response) => /* Success UI */,
  loading: () => /* Loading UI */,
  error: (error, stack) => /* Error UI */,
);
```

### 4. FamilyModifier für Parameter
```dart
ref.watch(leagueTransfersProvider(leagueId))
```

### 5. .select() für Performance
```dart
ref.watch(watchlistProvider.select((set) => set.contains(playerId)))
```

## Error Handling

### Buy Flow Errors:
- **Insufficient Funds** → "Nicht genügend Budget verfügbar"
- **Already Owned** → "Spieler bereits im Kader"
- **Expired** → "Angebot ist abgelaufen"
- **Network Error** → "Netzwerkfehler beim Kauf" mit Retry

### UI Feedback:
- Error Container mit Icon
- Retry Button
- Success SnackBar
- Loading Indicator

## Performance Optimizations

1. **CachedNetworkImage**: Cached Bilder für schnellere Ladezeiten
2. **autoDispose**: Automatic Provider Cleanup
3. **.select()**: Minimiert Widget Rebuilds
4. **StreamProvider**: Nur Updates bei Datenänderungen
5. **Pagination Ready**: Struktur für Infinite Scroll vorbereitet

## Usage

### In anderen Screens:
```dart
import 'package:go_router/go_router.dart';

// Navigate to Market
context.push('/dashboard/market');

// Oder als Tab in DashboardScreen
```

### Provider verwenden:
```dart
import 'package:kickbasekumpel/data/providers/providers.dart';

// Filter setzen
ref.read(marketFilterProvider.notifier).setPositionFilter(2); // Abwehr

// Spieler kaufen
ref.read(buyPlayerProvider.notifier).buyPlayer(
  leagueId: leagueId,
  playerId: playerId,
  price: 5000000, // 5M €
);

// Watchlist
ref.read(watchlistProvider.notifier).addPlayer(playerId);
```

## Testing Tipps

1. **Empty States**: Teste alle 4 Tabs ohne Daten
2. **Error States**: Teste Network Errors, Insufficient Funds
3. **Filter Combinations**: Position + Price Range + Search
4. **Buy Flow**: Min Price, Max Budget, Success, Error
5. **Watchlist**: Add, Remove, Toggle

## Zukünftige Erweiterungen

- [ ] Pagination/Infinite Scroll für große Player-Listen
- [ ] Advanced Filters (Team, League, etc.)
- [ ] Price History Charts
- [ ] Push Notifications für Watchlist-Änderungen
- [ ] Bulk Actions (mehrere Spieler gleichzeitig)
- [ ] Player Comparison View
- [ ] Market Analytics Dashboard
