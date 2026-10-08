---
name: kickbasekumpel-testing
description: KickbaseKumpel Test-Architektur - test/helpers (ResultMatcher, MockFirebaseSetup, TestData), Mocktail vs Mockito-Codegen, fake_cloud_firestore, Test-Struktur und -Befehle. Verwenden beim Schreiben oder Debugging von Tests.
---

# KickbaseKumpel – Testing

## Struktur (`test/` spiegelt `lib/`)

```
test/
├── helpers/          # Wiederverwendbare Test-Helfer (s.u.)
├── data/{models,providers,repositories,services,utils}/
├── presentation/{pages,providers,screens,utils,widgets}/
├── widget_test.dart
└── README.md         # Detaillierte Test-Doku
```

## Test-Helpers (`test/helpers/`) – VOR Eigenbau immer prüfen!

| Helper | Nutzen |
|---|---|
| `matchers.dart` | `ResultMatchers.isSuccess()`, `isSuccessWith(data)`, `isFailure()`, `isFailureWith(msg)`, `isFailureContaining(substring)` – Custom Matcher für `Result<T>` |
| `result_extension.dart` | `result.when(success: ..., failure: ...)` Extension für Pattern-Matching |
| `mock_firebase.dart` | `MockFirebaseSetup.createFakeFirestore()` (FakeFirebaseFirestore), `createMockAuth(...)`, Mocks: `MockFirebaseAuth`, `MockUser`, `MockUserCredential`, `MockKickbaseAPIClient` |
| `test_data.dart` | `TestData.createTestUser(...)` etc. – Generatoren für alle Modelle (Kurzschlüssel wie `i`, `n`, `tn`, `em` beachten) |

```dart
expect(result, ResultMatchers.isSuccessWith(expectedUser));
expect(result, ResultMatchers.isFailureContaining('not found'));
```

## Mocking-Strategie

- **mocktail** (vorwiegend): handgeschriebene `class MockX extends Mock implements X {}` in `test/helpers/mock_firebase.dart`
- **mockito-Codegen**: `@GenerateMocks([http.Client, TokenStorage, ...])` in der Testdatei → nach `flutter pub run build_runner build --delete-conflicting-outputs` entstehen `*.mocks.dart` (Beispiele: kickbase_api_client_test, http_client_wrapper_test, ligainsider_service_test)
- **Firestore**: immer `fake_cloud_firestore` (kein Emitter nötig)

## Befehle

```bash
# Default: gezielt – nur Tests, die betroffen sein können
flutter test test/data/services/lineup_recommendation_service_test.dart
flutter test test/data/services/        # betroffene Gruppe
flutter test                            # Voll-Lauf NUR bei breitem/unklarem Scope (s.u.)
flutter test --coverage
```

## Test-Regel: Scope statt Voll-Lauf

Während der Entwicklung NUR die Tests ausführen, die von den Änderungen betroffen
sein können. `test/` spiegelt `lib/` – der geänderte Pfad verrät den Scope:

| Änderung in `lib/` | Ausführen |
|---|---|
| einzelne Datei (z. B. `services/x.dart`) | spiegelnde Testdatei + Tests direkter Nutzer |
| `models/`, `providers/`, `utils/`, gemeinsame Widgets | betroffener Ordner-Baum (`flutter test test/data/...`) |
| Rename/Refactor über Dateigrenzen, unklarer Blast Radius, Abschluss-Check | `flutter test` (Voll-Lauf) |

Faustregel: roter/grüner Lauf = gezielt und schnell; der Voll-Lauf passiert
höchstens einmal am Ende (CI führt ihn ohnehin aus). Niemals nach jeder
kleinen Änderung die gesamte Suite starten.

⚠️ CI führt VOR den Tests `build_runner build` aus – bei neuen `@GenerateMocks`/Freezed-Änderungen lokal denselben Schritt ausführen, sonst schlagen Tests fehl.

Abgedeckte Services (Referenz): kickbase_api_client(_paged), http_client_wrapper, alle Budget-/Empfehlungs-Services, ligainsider, squad_benchmark, transfer_planner (inkl. e2e/diagnostics/demo_pipeline), demo_kickbase_api_client.
