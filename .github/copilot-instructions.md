# GitHub Copilot Instructions für KickbaseKumpel

> **Zielgruppe**: GitHub Copilot und andere AI Coding Agents  
> **Zweck**: Sicherstellung der Einhaltung von Architektur- und Code-Standards  
> **Version**: 1.0

---

## 🎯 Hauptrichtlinien für AI Agents

### 1. Architektur-Konformität

**WICHTIG**: Alle Code-Änderungen MÜSSEN die bestehende Clean Architecture einhalten:

```
Presentation Layer (UI) → Data Layer (Repositories/Services) → Domain Layer (Interfaces)
```

#### Bei Code-Änderungen:

- ✅ **Respektiere die Schichten-Trennung**: UI-Code gehört nach `lib/presentation/`, Geschäftslogik nach `lib/data/`, Interfaces nach `lib/domain/`
- ✅ **Dependency Rule beachten**: Abhängigkeiten zeigen immer nach innen (Presentation → Data → Domain)
- ✅ **Keine Cross-Layer Shortcuts**: Widgets dürfen NICHT direkt Services aufrufen, nur über Provider
- ✅ **Domain Layer bleibt pure**: Keine Flutter/Firebase Dependencies im `domain/` Ordner

---

### 2. State Management: Nur Riverpod 3.x

**WICHTIG**: Verwende ausschließlich Riverpod für State Management:

#### Provider-Typen (nach Use-Case):

| Verwende | Für | Beispiel |
|----------|-----|----------|
| `Provider<T>` | Synchrone, unveränderliche Werte | Config, Constants |
| `FutureProvider<T>` | Einmalige async Datenabfrage | API Calls |
| `StreamProvider<T>` | Real-time Daten | Firestore Streams |
| `NotifierProvider<N, T>` | Zustandsverwaltung mit Logik | Auth State, UI Selections |

#### Code-Muster:

```dart
// ✅ CORRECT: Riverpod Provider mit Notifier
final myProvider = NotifierProvider<MyNotifier, MyState>(MyNotifier.new);

class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() => const MyState();
  
  void updateState() {
    state = state.copyWith(newValue: 'updated');
  }
}

// ❌ INCORRECT: setState, ChangeNotifier, BLoC
class MyWidget extends StatefulWidget { ... } // Nicht für State Management!
class MyNotifier extends ChangeNotifier { ... } // Nicht verwenden!
```

---

### 3. Data Models: Immer Freezed

**WICHTIG**: Alle Data Models MÜSSEN Freezed verwenden:

```dart
// ✅ CORRECT
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    @Default(0) int count,
  }) = _MyModel;
  
  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}

// ❌ INCORRECT: Manuelle Data Classes
class MyModel {
  final String id;
  final String name;
  MyModel(this.id, this.name);
}
```

**Nach Model-Änderungen IMMER ausführen**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### 4. Error Handling: Result<T> Pattern

**WICHTIG**: Repositories MÜSSEN das Result<T> Pattern verwenden:

```dart
// ✅ CORRECT
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

// Widget Handling
final playersAsync = ref.watch(playersProvider);
return playersAsync.when(
  loading: () => const LoadingWidget(),
  error: (error, stack) => ErrorWidget(error: error),
  data: (players) => PlayersList(players: players),
);

// ❌ INCORRECT: Exceptions durchreichen ohne Wrapping
Future<List<Player>> getPlayers() async {
  return await _apiClient.fetchPlayers(); // NO!
}
```

---

### 5. Navigation: Nur GoRouter

**WICHTIG**: Verwende ausschließlich GoRouter für Navigation:

```dart
// ✅ CORRECT
context.go('/player/$playerId/stats');
context.push('/league/$leagueId/overview');
context.pop();

// Mit Extension Methods
context.goToPlayer(playerId);
context.goToLeague(leagueId);

// ❌ INCORRECT: Navigator.push, pushNamed
Navigator.push(context, MaterialPageRoute(...)); // Nicht verwenden!
Navigator.pushNamed(context, '/player'); // Nicht verwenden!
```

**Neue Routes müssen in `lib/config/router.dart` registriert werden**:
```dart
GoRoute(
  path: '/my-feature/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return MyFeaturePage(id: id);
  },
),
```

---

### 6. Widget-Struktur

**WICHTIG**: Verwende ConsumerWidget für reaktive Widgets:

```dart
// ✅ CORRECT: ConsumerWidget für Provider-Zugriff
class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);
    return Text(data.toString());
  }
}

// ✅ CORRECT: Stateless für statische Widgets
class MyStaticWidget extends StatelessWidget {
  final String title;
  const MyStaticWidget({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) => Text(title);
}

// ❌ INCORRECT: StatefulWidget für State Management
class MyWidget extends StatefulWidget { ... } // Nur für UI State (Animationen, etc.)!
```

**Extrahiere Widgets statt Builder Functions**:
```dart
// ✅ CORRECT
class _PlayerItem extends StatelessWidget {
  final Player player;
  const _PlayerItem({required this.player});
  
  @override
  Widget build(BuildContext context) => ListTile(title: Text(player.name));
}

// ❌ INCORRECT
Widget _buildPlayerItem(Player player) {
  return ListTile(title: Text(player.name));
}
```

---

### 7. File & Folder Organization

**WICHTIG**: Halte dich an die bestehende Struktur:

| Datei-Typ | Location | Namenskonvention |
|-----------|----------|------------------|
| Models | `lib/data/models/` | `*_model.dart` |
| Providers | `lib/data/providers/` oder `lib/presentation/providers/` | `*_provider.dart` |
| Repositories | `lib/data/repositories/` | `*_repository.dart` |
| Services | `lib/data/services/` | `*_service.dart` / `*_client.dart` |
| Pages | `lib/presentation/pages/` | `*_page.dart` |
| Widgets | `lib/presentation/widgets/` | `*_widget.dart` |
| Config | `lib/config/` | `*.dart` |

**Unterordner nach Feature organisieren**:
```
lib/presentation/widgets/
  ├── common/         # Generische Widgets
  ├── cards/          # Card-Komponenten
  ├── forms/          # Form Fields
  ├── market/         # Market-spezifische Widgets
  └── team/           # Team-spezifische Widgets
```

---

### 8. Code-Style & Linting

**WICHTIG**: Befolge Dart Best Practices:

```dart
// ✅ CORRECT
const MyWidget({super.key});           // const constructor
final players = <Player>[];            // Type inference
if (condition) return;                 // Early return
final name = player?.name ?? 'N/A';    // Null-aware

// ❌ INCORRECT
MyWidget({Key? key}) : super(key: key); // Alte Syntax
List<Player> players = [];              // Redundanter Typ
if (condition) { return; }              // Unnötige Klammern
final name = player != null ? player.name : 'N/A'; // Umständlich
```

**Nutze dart format vor Commits**:
```bash
dart format lib/
```

---

### 9. Testing

**WICHTIG**: Schreibe Tests für neue Funktionen:

#### Unit Tests (für Business Logic):
```dart
// test/data/repositories/my_repository_test.dart
void main() {
  group('MyRepository', () {
    late MyRepository repository;
    late MockApiClient mockApiClient;
    
    setUp(() {
      mockApiClient = MockApiClient();
      repository = MyRepository(apiClient: mockApiClient);
    });
    
    test('getData returns Success with data', () async {
      when(mockApiClient.getData()).thenAnswer((_) async => mockData);
      
      final result = await repository.getData();
      
      expect(result, isA<Success>());
    });
  });
}
```

#### Widget Tests (für UI):
```dart
// test/presentation/widgets/my_widget_test.dart
testWidgets('MyWidget displays title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: MyWidget(title: 'Test')),
  );
  
  expect(find.text('Test'), findsOneWidget);
});
```

---

### 10. Dokumentation erweitern

**WICHTIG**: Bei neuen Klassen/Methoden IMMER Dokumentation hinzufügen:

#### Klassen-Dokumentation:
```dart
/// Repository für Spieler-Daten.
///
/// Verwaltet CRUD-Operationen für Player-Entitäten
/// und integriert mit Kickbase API v4.
///
/// Verwendung:
/// ```dart
/// final repository = ref.watch(playerRepositoryProvider);
/// final result = await repository.getPlayer('player123');
/// ```
class PlayerRepository {
  // ...
}
```

#### Methoden-Dokumentation:
```dart
/// Lädt alle Spieler einer Liga.
///
/// [leagueId] Die ID der Liga.
/// Returns [Result<List<Player>>] mit Erfolg oder Fehler.
///
/// Wirft keine Exceptions, gibt stattdessen [Failure] zurück.
Future<Result<List<Player>>> getPlayers(String leagueId) async {
  // ...
}
```

#### Provider-Dokumentation:
```dart
/// Provider für Spieler-Details.
///
/// Lädt detaillierte Informationen zu einem einzelnen Spieler
/// basierend auf der [playerId].
///
/// Auto-invalidiert bei Logout.
final playerDetailsProvider = FutureProvider.family<Player, String>(
  (ref, playerId) async {
    // ...
  },
);
```

**Dokumentation in diesen Dateien aktualisieren**:
- `ARCHITECTURE.md` → Bei neuen Patterns/Strukturen
- Feature-spezifische Docs in `docs/` → Bei neuen Features
- `README.md` → Bei Änderungen am Setup/Build-Prozess

---

## 📋 Checkliste für neue Features

Wenn du ein neues Feature implementierst, gehe diese Checkliste durch:

### Data Layer
- [ ] Model mit `@freezed` erstellt (`lib/data/models/`)
- [ ] Code mit `build_runner` generiert
- [ ] API Client Methode hinzugefügt (falls extern)
- [ ] Repository mit `Result<T>` Error Handling erstellt
- [ ] Provider in `lib/data/providers/` erstellt
- [ ] Unit Tests für Repository geschrieben

### Presentation Layer
- [ ] Page/Widget mit `ConsumerWidget` erstellt
- [ ] Loading/Error States mit `AsyncValue.when()` behandelt
- [ ] Route in `lib/config/router.dart` registriert
- [ ] UI Provider für selections/filters (falls nötig)
- [ ] Widget Tests geschrieben

### Dokumentation
- [ ] Klassen mit DartDoc kommentiert
- [ ] `ARCHITECTURE.md` erweitert (falls neues Pattern)
- [ ] Feature-Docs in `docs/` aktualisiert
- [ ] Code formatiert (`dart format`)
- [ ] Linter Warnings behoben

---

## 🚫 Häufige Fehler vermeiden

### ❌ NICHT tun:

1. **Keine direkten Service-Aufrufe in Widgets**:
   ```dart
   // ❌ INCORRECT
   class MyWidget extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       final data = KickbaseAPIClient().getData(); // NO!
     }
   }
   ```

2. **Keine gemischten State Management Ansätze**:
   ```dart
   // ❌ INCORRECT
   class MyNotifier extends ChangeNotifier { ... } // Nicht mit Riverpod mischen!
   ```

3. **Keine Exceptions in Repositories durchreichen**:
   ```dart
   // ❌ INCORRECT
   Future<List<Player>> getPlayers() async {
     return await _apiClient.getPlayers(); // Exception wird durchgereicht!
   }
   ```

4. **Keine Flutter-Abhängigkeiten in Domain Layer**:
   ```dart
   // ❌ INCORRECT in lib/domain/
   import 'package:flutter/material.dart'; // NO!
   ```

5. **Keine manuellen Data Classes**:
   ```dart
   // ❌ INCORRECT
   class Player {
     final String id;
     Player(this.id);
     
     Player copyWith({String? id}) { ... } // Freezed macht das!
   }
   ```

---

## 🎓 Weitere Ressourcen

### Interne Dokumentation
- **Vollständige Architektur**: `ARCHITECTURE.md` (MAIN REFERENCE!)
- **Riverpod Patterns**: `docs/RIVERPOD_PROVIDERS.md`
- **Router Setup**: `docs/ROUTER_QUICKSTART.md`
- **Repository Usage**: `docs/REPOSITORY_USAGE_EXAMPLES.md`
- **Auth Examples**: `docs/AUTH_USAGE_EXAMPLES.md`

### Externe Links
- [Riverpod Docs](https://riverpod.dev)
- [GoRouter Docs](https://pub.dev/packages/go_router)
- [Freezed Docs](https://pub.dev/packages/freezed)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

## 🤖 AI Agent Specific Instructions

### Für GitHub Copilot:

**WICHTIG**: 
- Lese zuerst `ARCHITECTURE.md` für vollständiges Verständnis
- Nutze bestehende Patterns als Templates
- Folge der 3-Layer Architektur strikt
- Verwende IMMER Freezed für Models
- Verwende IMMER Riverpod für State
- Verwende IMMER Result<T> für Error Handling
- Schreibe IMMER Tests für neue Funktionen
- Erweitere IMMER Dokumentation bei neuen Klassen/Methoden

### Code Completion Hints:

Wenn der User schreibt:
- `class *Model` → Schlage Freezed Template vor
- `final *Provider =` → Schlage passenden Provider-Typ vor
- `class *Repository` → Schlage Result<T> Pattern vor
- `class *Page extends` → Schlage ConsumerWidget vor
- `Future<void>` in Repo → Warne, dass Result<T> verwendet werden sollte

### Auto-Refactoring Hints:

Bei Code-Änderungen:
- Erkenne veraltete Patterns (Navigator, setState in Business Logic)
- Schlage Riverpod-Migration vor
- Erkenne fehlende Error Handling
- Schlage Freezed-Migration für manuelle Data Classes vor

---

**Version**: 1.0  
**Maintainer**: KickbaseKumpel Team  
**Letzte Aktualisierung**: Februar 2026
