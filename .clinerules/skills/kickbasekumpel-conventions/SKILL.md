---
name: kickbasekumpel-conventions
description: KickbaseKumpel Code-Konventionen - Riverpod 3.x Provider, Freezed Models, Result<T>, Exception-Hierarchie, Namenskonventionen, Linting. Verwenden beim Schreiben oder Review von Dart-Code.
---

# KickbaseKumpel – Code-Konventionen

## State Management: nur Riverpod 3.x (riverpod/flutter_riverpod ^3.2.1)

| Typ | Für |
|---|---|
| `Provider<T>` | synchrone, unveränderliche Werte (Config, Constants) |
| `FutureProvider<T>` | einmalige async Datenabfrage |
| `StreamProvider<T>` | Real-time Firestore-Streams |
| `NotifierProvider<N, T>` | Zustand mit Logik (Auth-State, UI-Selections) |

```dart
final myProvider = NotifierProvider<MyNotifier, MyState>(MyNotifier.new);
class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() => const MyState();
}
```

❌ Verboten: setState/ChangeNotifier/BLoC als State-Management. Data-Provider in `lib/data/providers/`, UI-Provider in `lib/presentation/providers/`.

## Models: immer Freezed

```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({required String id, @Default(0) int count}) = _MyModel;
  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);
}
```

Nach jeder Model-Änderung: `flutter pub run build_runner build --delete-conflicting-outputs`

## Error Handling

- Repositories geben immer `Result<T>` zurück (Success/Failure, siehe kickbasekumpel-architecture)
- API-Fehler: Hierarchie in `lib/domain/exceptions/kickbase_exceptions.dart` – Basis `KickbaseException` mit Authentication, Authorization, NotFound, RateLimit, Network, Server, Timeout, Parsing, AllEndpointsFailed
- Logging über `package:logger` (`Logger()`), nicht `print`

## Namenskonventionen

Model `*_model.dart` (`*Model`), Repository `*_repository.dart` (`*Repository`), Service `*_service.dart` (`*Service`), Provider `*_providers.dart`, Screen `*_screen.dart`, Page `*_page.dart`.

## Widget-Regeln

- Widgets nur über Provider auf Daten zugreifen (nie Services direkt)
- Responsive via `presentation/widgets/responsive_layout.dart` + `lib/config/screen_size.dart`
- Wiederverwendbare Widgets nach Typ in `lib/presentation/widgets/<app_bars|buttons|cards|charts|common|forms|market|team|transfers>/`

## Qualitätssicherung

```bash
dart format lib/
flutter analyze
flutter test
```

Details: .github/copilot-instructions.md, DOCUMENTATION_GUIDELINES.md
