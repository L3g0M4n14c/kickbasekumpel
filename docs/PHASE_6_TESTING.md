# Phase 6: Testing & Quality Assurance (2.5h)

**Status:** ⏳ Nach Phase 5  
**Dauer:** 2.5 Stunden | **Copilot:** 50% | **User:** 50%  

---

## 🎯 Objectives

- Unit Tests für Models & Services
- Widget Tests für UI Komponenten
- Integration Tests für Features
- Code Coverage Reports
- Firebase Emulator Tests
- CI/CD Pipeline Vorbereitung

---

## 📊 Test-Struktur

```
test/
├── data/
│   ├── models/
│   │   ├── user_model_test.dart
│   │   ├── player_model_test.dart
│   │   └── ...
│   ├── repositories/
│   │   ├── user_repository_test.dart
│   │   ├── league_repository_test.dart
│   │   └── ...
│   └── services/
│       ├── kickbase_api_client_test.dart
│       ├── ligainsider_service_test.dart
│       └── http_client_wrapper_test.dart
├── presentation/
│   ├── screens/
│   │   ├── dashboard_screen_test.dart
│   │   ├── market_screen_test.dart
│   │   └── ...
│   └── widgets/
│       ├── player_card_test.dart
│       ├── league_card_test.dart
│       └── ...
├── domain/
│   └── providers/
│       ├── auth_provider_test.dart
│       └── ...
└── integration/
    ├── auth_flow_test.dart
    ├── market_flow_test.dart
    └── transfer_flow_test.dart
```

---

## 🧪 Phase 6a: Unit Tests - Models

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Unit Tests für alle Modelle:

test/data/models/

Anforderungen:

1. test/data/models/user_model_test.dart
   - Test: fromJson() parst korrekt
   - Test: toJson() serializiert korrekt
   - Test: CodingKeys Mapping funktioniert
   - Test: copyWith() erstellt neue Instanz
   - Test: Zwei Instanzen mit gleichen Daten sind gleich (==)
   - Test: Null-Values werden korrekt gehandhabt

2. test/data/models/player_model_test.dart
   - Ähnliche Tests wie User
   - Test: Complex Fields (Stats, History, etc)
   - Test: Nested Models serialisieren

3. test/data/models/api_response_test.dart
   - Test: Error Responses parsen
   - Test: Null/Empty Handling

Nutze mockito für Fixtures:

const String userJson = '''{
  "id": "123",
  "name": "Marco",
  "email": "test@example.com"
}''';

group('UserModel', () {
  test('fromJson creates correct instance', () {
    final user = User.fromJson(jsonDecode(userJson));
    expect(user.id, '123');
    expect(user.name, 'Marco');
  });

  test('toJson serializes correctly', () {
    final user = User(id: '123', name: 'Marco', email: 'test@example.com');
    final json = user.toJson();
    expect(json['id'], '123');
  });

  test('copyWith creates new instance', () {
    final user1 = User(id: '123', name: 'Marco', email: 'test@example.com');
    final user2 = user1.copyWith(name: 'Marco2');
    expect(user1.name, 'Marco');
    expect(user2.name, 'Marco2');
    expect(user1 != user2, true);
  });
});

Mache das für alle 20+ Modelle
```

---

## 🧪 Phase 6b: Unit Tests - Services

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Unit Tests für Services:

test/data/services/

Nutze mockito für HTTP Mocking:

1. test/data/services/kickbase_api_client_test.dart

   - Mock http.Client mit mockito
   - Test: getUser() parst Response korrekt
   - Test: getLeagues() mapped mehrere Items
   - Test: 401 Response triggert AuthException
   - Test: 404 Response triggert NotFoundException
   - Test: Network Error triggert NetworkException
   - Test: Retry Logic auf 5xx (3 Attempts)
   - Test: Timeout nach 30s
   - Test: Bearer Token in Headers

   Code Struktur:

   final mockHttpClient = MockHttpClient();
   
   when(mockHttpClient.get(
     any,
     headers: anyNamed('headers'),
   )).thenAnswer((_) async => http.Response(
     jsonEncode({'id': '123', 'name': 'League1'}),
     200,
   ));
   
   final apiClient = KickbaseAPIClient(
     httpClient: mockHttpClient,
   );
   
   expect(
     () => apiClient.getLeagues(),
     completes,
   );

2. test/data/services/ligainsider_service_test.dart

   - Mock http.Client
   - Mock HTML Response
   - Test: getInjuredPlayers() parsed korrekt
   - Test: Ungültiges HTML wird abgefangen
   - Test: Leere Seite gibt Empty List

3. test/data/services/http_client_wrapper_test.dart

   - Test: Retry Logic (3 Attempts, Exponential Backoff)
   - Test: Non-retryable Errors (4xx) thrownen sofort
   - Test: 5xx Errors werden retried
   - Test: Timeout wird gemappt

Nutze:
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client, SecureStorage])
void main() { ... }
```

---

## 🧪 Phase 6c: Repository Tests

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Unit Tests für Repositories:

test/data/repositories/

Mock FirebaseFirestore & API Clients:

1. test/data/repositories/user_repository_test.dart

   - Mock FirebaseFirestore
   - Mock KickbaseAPIClient
   - Test: getUser() fetcht von API
   - Test: getUser() cached in Firestore
   - Test: API Error → Use Firestore Cache
   - Test: Offline → Return Cached Data

2. test/data/repositories/league_repository_test.dart

   - Test: getLeagues() mit Members Filter
   - Test: Batch Operations (Multiple Leagues)
   - Test: Real-time Stream auf Firestore
   - Test: Error Handling für ungültige Daten

Nutze:

final mockFirestore = MockFirebaseFirestore();
final mockApiClient = MockKickbaseAPIClient();

when(mockFirestore
    .collection('users')
    .doc(any)
    .get()
).thenAnswer((_) async => MockDocumentSnapshot());

final repository = UserRepository(
  firestore: mockFirestore,
  apiClient: mockApiClient,
);

final user = await repository.getUser();
expect(user.id, '123');
```

---

## 🎨 Phase 6d: Widget Tests

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Widget Tests für UI Komponenten:

test/presentation/widgets/

1. test/presentation/widgets/player_card_test.dart

   - Test: Zeigt Player Name korrekt
   - Test: Zeigt Market Value
   - Test: Tap ruft Callback auf
   - Test: Dark Mode Rendering

2. test/presentation/widgets/league_card_test.dart

   - Test: Zeigt League Name
   - Test: Zeigt Member Count
   - Test: Navigation bei Tap

3. test/presentation/widgets/loading_widget_test.dart

   - Test: Zeigt Loading Spinner

4. test/presentation/widgets/error_widget_test.dart

   - Test: Zeigt Error Message
   - Test: Retry Button sichtbar

Code Struktur:

void main() {
  group('PlayerCard', () {
    testWidgets('displays player name correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Player Name'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });
  });
}
```

---

## 🎯 Phase 6e: Integration Tests

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Integration Tests für komplette Features:

test/integration/

1. test/integration/auth_flow_test.dart

   Scenario: User Sign-In Flow
   - User enters email + password
   - Klick Sign In
   - Firebase Auth processes
   - App navigiert zu Dashboard
   - User Data wird geladen
   - Riverpod Providers sind updated

   Code:

   testWidgets('Complete auth flow', (WidgetTester tester) async {
     await tester.pumpWidget(const KickbaseKumpelApp());
     
     // Find Sign In Screen
     expect(find.byType(SignInScreen), findsOneWidget);
     
     // Enter Credentials
     await tester.enterText(find.byType(EmailField), 'test@example.com');
     await tester.enterText(find.byType(PasswordField), 'password123');
     
     // Sign In
     await tester.tap(find.byType(ElevatedButton));
     await tester.pumpAndSettle();
     
     // Should navigate to Dashboard
     expect(find.byType(DashboardScreen), findsOneWidget);
   });

2. test/integration/market_flow_test.dart

   Scenario: User Buys Player
   - User views Market
   - Searches/Filters Players
   - Klick auf Player
   - Klick Buy
   - Enters Price
   - Confirms
   - API Call successful
   - User Balance updated
   - Player List updated

3. test/integration/transfer_recommendation_flow_test.dart

   Scenario: User Gets & Accepts Recommendation
   - App loads recommendations
   - Shows top 5
   - User klick auf Recommendation
   - Shows Details & Reasoning
   - User klick "Make Transfer"
   - Backend processes
   - Confirmation shown
```

---

## 📊 Phase 6f: Firebase Emulator Tests

### GitHub Copilot Prompt (COPY-PASTE)

```
Teste Firebase mit Local Emulator:

Installation:
npm install -g firebase-tools
firebase init emulators

Starte Emulator:
firebase emulators:start --only firestore,auth

Test Code:

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  setUpAll(() async {
    // Connect zu Emulator
    await Firebase.initializeApp();
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  });

  group('Firebase Emulator Tests', () {
    test('Create user in Firestore', () async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('test-user')
          .set({'name': 'Test User', 'email': 'test@test.com'});

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc('test-user')
          .get();

      expect(doc.exists, true);
      expect(doc.data()?['name'], 'Test User');
    });
  });
}
```

---

## 📈 Code Coverage

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Coverage Reports:

1. Installiere Coverage Tool:
   flutter pub add dev:coverage

2. Starte Tests mit Coverage:
   flutter test --coverage

3. Generiere HTML Report:
   genhtml coverage/lcov.info -o coverage/html

4. Öffne Report:
   open coverage/html/index.html

Coverage Goals:
- Models: 100%
- Services: 85%+
- Repositories: 80%+
- Widgets: 70%+
- Screens: 60%+
- Overall: 75%+
```

---

## 🔄 CI/CD Vorbereitung

### GitHub Actions für Tests

```yaml
# .github/workflows/flutter_tests.yml

name: Flutter Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.x'
      
      - name: Get packages
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
```

---

## ✅ Validierung

### Test Checklist

- [ ] Alle Models getestet (100% Coverage)
- [ ] Services getestet (85%+ Coverage)
- [ ] Repositories getestet (80%+ Coverage)
- [ ] Widgets getestet (70%+ Coverage)
- [ ] Integration Tests laufen
- [ ] Firebase Emulator Tests bestanden
- [ ] Coverage Report: 75%+
- [ ] CI/CD Pipeline triggert Tests
- [ ] Keine flaky Tests

---

## 🎯 Success Criteria

- [x] 50+ Unit Tests
- [x] 20+ Widget Tests
- [x] 5+ Integration Tests
- [x] Firebase Emulator Setup
- [x] Coverage Reports
- [x] CI/CD Ready
- [x] Code Coverage: 75%+
- [x] All Tests Passing
- [x] Git Commit: "Phase 6: Testing & QA"

---

## 🔗 Nächster Schritt

Wenn Phase 6 fertig: → **[Phase 7: Deployment](./PHASE_7_DEPLOYMENT.md)**

---

## 📚 Referenzen

- **Flutter Testing:** https://docs.flutter.dev/testing
- **Mockito:** https://pub.dev/packages/mockito
- **Firebase Emulator:** https://firebase.google.com/docs/emulator-suite
- **Coverage Reports:** https://pub.dev/packages/coverage
- **GitHub Actions:** https://docs.github.com/en/actions

---

**Fortschritt:** Phase 1-5 (✅) → Phase 6 (⏳)  
**Copilot wird ~50% dieser Arbeit machen! Tests sind 50/50 Copilot + Human**
