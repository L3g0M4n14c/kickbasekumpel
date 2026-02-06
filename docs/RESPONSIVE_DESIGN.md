# Responsive Design Implementation

## Übersicht

Die Kickbase Kumpel App unterstützt nun vollständig responsive Layouts für Mobile, Tablet und Desktop-Geräte.

## Breakpoints

```dart
- Mobile:  < 600dp
- Tablet:  600dp - 1200dp  
- Desktop: > 1200dp
```

## Implementierte Features

### 1. Navigation

#### Mobile (< 600dp)
- **Bottom Navigation Bar** mit 6 Tabs
- Kompakte Darstellung
- Touch-optimierte Bedienung

#### Tablet (600dp - 1200dp)
- **Navigation Drawer** (Hamburger Menu)
- AppBar mit Titel
- Größere Touch-Targets

#### Desktop (> 1200dp)
- **Navigation Rail** (Sidebar)
- Immer sichtbare Navigation
- Erweiterte Beschriftungen

### 2. Layout-Patterns

#### Mobile Layout
- Single Column
- Full Width Content
- Bottom Sheets für Details
- Stacked Sections

#### Tablet Layout
- Split View (List + Details)
- Two Column Grid
- Drawer Navigation
- Vergrößerte Cards

#### Desktop Layout
- Multi-Column Layout (bis zu 3 Spalten)
- Sidebar Navigation
- Advanced Filtering
- Data Tables
- Maximale Inhaltsbreite (1400-1600px)

## Verwendete Komponenten

### Core Files

#### `/lib/config/screen_size.dart`
Zentrale Breakpoint-Definitionen und Helper-Methoden:

```dart
// Screen Type prüfen
ScreenSize.isMobile(context)
ScreenSize.isTablet(context)
ScreenSize.isDesktop(context)

// Grid Spalten berechnen
ScreenSize.getGridColumns(context, mobile: 1, tablet: 2, desktop: 3)

// Padding anpassen
ScreenSize.getHorizontalPadding(context)

// Extension Methods
context.isMobile
context.isTablet
context.isDesktop
context.horizontalPadding
```

#### `/lib/presentation/widgets/responsive_layout.dart`
Responsive Widgets für flexible Layouts:

```dart
// Basis Layout Switcher
ResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)

// Responsive Grid
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  children: [...],
)

// Split View (Tablet/Desktop)
ResponsiveSplitView(
  list: ListView(...),
  detail: DetailWidget(),
)

// Responsive Container mit Max-Width
ResponsiveContainer(
  desktopMaxWidth: 1400,
  child: Content(),
)

// Adaptive Card
ResponsiveCard(
  child: CardContent(),
)
```

## Implementierte Pages

### Dashboard Pages
- ✅ **Home Page**: Mobile (Single), Tablet (Split), Desktop (Multi-column)
- ✅ **Lineup Page**: Mobile (Stacked), Tablet (Split), Desktop (3-Column)
- ✅ **Market Page**: Mobile (List), Tablet (Grid + Filter), Desktop (Grid + Sidebar)
- ✅ **Transfers Page**: Mobile (List), Tablet (Split), Desktop (Side-by-side)

### League Pages
- ✅ **League Overview**: Mobile (Stacked), Tablet (2-Column Grid), Desktop (3-Column Grid)
- ✅ **League Players**: Mobile (List), Tablet (2-Column Grid), Desktop (3-Column Grid)
- ✅ **League Standings**: Mobile (List), Tablet (Cards), Desktop (DataTable)

### Player Pages
- ✅ **Player Stats**: Mobile (Stacked), Tablet (Split), Desktop (3-Column)
- ✅ **Player History**: Mobile (Stacked), Tablet (2-Column), Desktop (Chart + 2-Column)

## Best Practices

### 1. Layout-Struktur

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    appBar: ScreenSize.isMobile(context) ? AppBar(...) : null,
    body: ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    ),
  );
}
```

### 2. Adaptive Spacing

```dart
// Verwende context extensions
padding: EdgeInsets.all(context.horizontalPadding)

// Oder direkt
padding: EdgeInsets.all(ScreenSize.getHorizontalPadding(context))
```

### 3. Responsive Grids

```dart
ResponsiveGrid(
  mobileColumns: 1,   // Single column auf Mobile
  tabletColumns: 2,   // Two columns auf Tablet
  desktopColumns: 3,  // Three columns auf Desktop
  spacing: 16.0,
  children: items.map((item) => ItemCard(item)).toList(),
)
```

### 4. Split Views (Tablet/Desktop)

```dart
ResponsiveSplitView(
  listFlex: 2,      // 40% für Liste
  detailFlex: 3,    // 60% für Details
  list: ListView(...),
  detail: DetailView(...),
  placeholder: EmptyStateWidget(), // Optional
)
```

### 5. Conditional Rendering

```dart
// Elemente nur auf größeren Screens anzeigen
if (!context.isMobile) ...[
  const Divider(),
  DetailedStats(),
],

// Alternative: Ternary
context.isMobile 
  ? CompactView() 
  : ExpandedView(),
```

### 6. Bottom Sheets (Mobile)

```dart
void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) => FilterPanel(),
    ),
  );
}
```

## Testing

### Breakpoint Testing

1. **Mobile**: iPhone SE (375 x 667)
2. **Tablet**: iPad (768 x 1024)
3. **Desktop**: 1920 x 1080

### Flutter DevTools

```bash
# Verschiedene Geräte testen
flutter run -d chrome
flutter run -d macos
flutter run -d ios
```

### Responsive Inspector
- Flutter DevTools > Layout Inspector
- Toggle Device Frame
- Teste verschiedene Orientierungen

## Migration Guide

### Bestehende Pages anpassen

1. Import hinzufügen:
```dart
import '../../../config/screen_size.dart';
import '../../widgets/responsive_layout.dart';
```

2. Layout refactoren:
```dart
// Vorher
body: ListView(...)

// Nachher
body: ResponsiveLayout(
  mobile: _buildMobileLayout(context),
  tablet: _buildTabletLayout(context),
  desktop: _buildDesktopLayout(context),
)
```

3. Helper Methods erstellen:
```dart
Widget _buildMobileLayout(BuildContext context) {
  return ListView(...);
}

Widget _buildTabletLayout(BuildContext context) {
  return ResponsiveSplitView(...);
}

Widget _buildDesktopLayout(BuildContext context) {
  return Row(...);
}
```

## Performance Tipps

1. **LayoutBuilder** verwenden bei dynamischen Layouts
2. **const Constructors** wo möglich
3. **ResponsiveGrid** für Listen mit vielen Items
4. **ListView.builder** für lange Listen
5. **Cached Widgets** für teure Berechnungen

## Weitere Features

### Geplante Erweiterungen
- [ ] Landscape Orientation Support
- [ ] Foldable Device Support  
- [ ] Dynamic Type Scaling
- [ ] Accessibility Improvements
- [ ] Theme-aware Responsive Design

## Ressourcen

- [Flutter Responsive Design](https://docs.flutter.dev/development/ui/layout/responsive)
- [Material Design Responsive Layout Grid](https://material.io/design/layout/responsive-layout-grid.html)
- [Adaptive Design Best Practices](https://flutter.dev/docs/development/ui/layout/adaptive-responsive)
