# Widget Gallery - KickbaseKumpel

Diese Verzeichnisse enthalten alle wiederverwendbaren Widgets für die KickbaseKumpel App.

## 📂 Struktur

```
lib/presentation/widgets/
├── app_bars/          # AppBar-Varianten
├── cards/             # Karten & Listen-Tiles
├── forms/             # Eingabefelder
├── common/            # Loading, Error, Empty States
├── charts/            # Charts & Statistiken
└── buttons/           # Buttons & Dialoge
```

## 🎨 Widget-Kategorien

### 1. AppBars (`app_bars/`)
- **CustomAppBar** - Standard AppBar mit Anpassungen
- **SearchAppBar** - AppBar mit integrierter Suche
- **TabbedAppBar** - AppBar mit Tabs

### 2. Cards & Lists (`cards/`)
- **PlayerCard** - Spieler-Karte mit Statistiken
- **LeagueCard** - Liga-Karte mit Details
- **TransferCard** - Transfer-Anzeige
- **MatchCard** - Spiel-Anzeige
- **PlayerListTile** - Kompakte Spieler-Liste
- **LeagueListTile** - Kompakte Liga-Liste

### 3. Forms & Input (`forms/`)
- **EmailInputField** - E-Mail Eingabefeld mit Validierung
- **PasswordInputField** - Passwort-Feld mit Stärke-Indikator
- **PriceInputField** - Preis-Eingabe mit Formatierung
- **SearchField** - Such-Feld mit Debouncing

### 4. Loading & Error (`common/`)
- **LoadingWidget** - Loading-Indikator
- **ErrorWidget** - Fehler-Anzeige
- **EmptyStateWidget** - Leerer Zustand
- **RetryWidget** - Fehler mit Retry-Button

### 5. Charts & Stats (`charts/`)
- **PriceChart** - Marktwert-Trend (Line Chart)
- **StatsBarChart** - Statistiken (Bar Chart)
- **PerformanceLineChart** - Performance-Verlauf (Line Chart)
- **PositionBadge** - Positions-Anzeige

### 6. Buttons & Actions (`buttons/`)
- **ActionButton** - Wiederverwendbarer Button
- **FloatingActionMenu** - Erweiterbares FAB-Menü
- **ConfirmationDialog** - Bestätigungs-Dialoge

## 🚀 Usage

### Beispiel: PlayerCard
```dart
PlayerCard(
  player: player,
  onTap: () => Navigator.push(...),
  showStats: true,
  compact: false,
)
```

### Beispiel: LoadingWidget
```dart
LoadingWidget(
  message: 'Lade Spieler...',
  size: LoadingSize.medium,
)
```

### Beispiel: ConfirmationDialog
```dart
await showConfirmationDialog(
  context: context,
  title: 'Spieler verkaufen?',
  message: 'Möchtest du den Spieler wirklich verkaufen?',
  confirmText: 'Verkaufen',
  isDangerous: true,
);
```

## 🎭 Demo Screens

Zwei Demo-Screens zum Testen der Widgets:

1. **WidgetGalleryScreen** - Zeigt alle Widgets außer Charts
2. **ChartsDemoScreen** - Zeigt alle Chart-Widgets

### Demo öffnen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WidgetGalleryScreen(),
  ),
);
```

## 📦 Dependencies

Die meisten Widgets benötigen nur Flutter Standard-Pakete.

Für **Charts** wird zusätzlich benötigt:
```yaml
dependencies:
  fl_chart: ^0.66.0
```

## ✨ Features

- ✅ Material Design 3
- ✅ Dark Mode Support
- ✅ Null Safety
- ✅ Dokumentierte API
- ✅ Usage Examples
- ✅ Responsive Design
- ✅ Accessibility Support

## 🎨 Theming

Alle Widgets nutzen das Theme des Contexts:
```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;
```

Custom Colors können über Parameter überschrieben werden.

## 🔧 Customization

Jedes Widget bietet verschiedene Parameter zur Anpassung:

```dart
PlayerCard(
  player: player,
  showStats: true,      // Statistiken anzeigen
  compact: false,       // Kompakte Darstellung
  showTrend: true,      // Trend-Icon anzeigen
  elevation: 2,         // Card-Elevation
)
```

## 📱 Responsive Design

Widgets passen sich automatisch an:
- Screen-Größe
- Dark/Light Mode
- Text-Skalierung
- Accessibility-Einstellungen

## 🐛 Troubleshooting

### Charts zeigen nicht an
Stelle sicher, dass `fl_chart` in `pubspec.yaml` hinzugefügt ist:
```bash
flutter pub add fl_chart
```

### Imports fehlen
Alle Widget-Importe folgen dem Schema:
```dart
import 'package:kickbasekumpel/presentation/widgets/[category]/[widget_name].dart';
```

## 📚 Weitere Dokumentation

Jedes Widget enthält ausführliche Inline-Dokumentation mit:
- Beschreibung
- Parameter-Erklärungen
- Usage Examples
- Best Practices

## 🤝 Contributing

Bei Erweiterungen oder Verbesserungen:
1. Dokumentation hinzufügen
2. Usage Example erstellen
3. Demo-Screen aktualisieren
4. Dark Mode testen
