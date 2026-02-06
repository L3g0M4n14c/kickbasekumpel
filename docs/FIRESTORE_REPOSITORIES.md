# Firestore Repositories - KickbaseKumpel

Vollständige Firestore Repository-Implementierung für die KickbaseKumpel App mit CRUD-Operationen, Real-time Streams, Transactions und komplexen Queries.

## 📁 Struktur

```
lib/
├── domain/
│   └── repositories/
│       ├── auth_repository_interface.dart      # Auth Repository (bereits vorhanden)
│       └── repository_interfaces.dart          # Alle Repository Interfaces ✨ NEU
│
├── data/
│   ├── models/                                 # Freezed Models (bereits vorhanden)
│   │   ├── user_model.dart
│   │   ├── league_model.dart
│   │   ├── player_model.dart
│   │   └── transfer_model.dart
│   │
│   └── repositories/
│       ├── base_repository.dart                # Base Klasse ✨ NEU
│       └── firestore_repositories.dart         # Implementierungen ✨ NEU
│
└── docs/
    └── REPOSITORY_USAGE_EXAMPLES.md            # Code-Beispiele ✨ NEU
```

## 🎯 Features

### Base Repository (`base_repository.dart`)
- ✅ Generische CRUD-Operationen
- ✅ Real-time Streams (watchAll, watchById)
- ✅ Complex Queries (where, orderBy, limit)
- ✅ Batch Operations
- ✅ Transactions
- ✅ Error Handling mit Result<T>
- ✅ Timestamp Conversion Helpers

### Repository Interfaces (`repository_interfaces.dart`)
1. **BaseRepositoryInterface<T>**
   - getAll(), getById(), create(), update(), delete()
   - watchAll(), watchById() - Real-time Streams

2. **UserRepositoryInterface**
   - getByEmail(), getByAuthUid()
   - updateProfile(), updateStats()
   - searchByName()

3. **LeagueRepositoryInterface**
   - getByUserId()
   - addMember(), removeMember(), updateMember()
   - getMembers(), updateStandings()
   - searchByName(), getActiveLeagues()

4. **PlayerRepositoryInterface**
   - getByTeam(), getByPosition()
   - searchByName(), getTopPlayers()
   - filterPlayers() - Komplexer Filter
   - isPlayerOwned(), updateMarketValue()
   - batchUpdate()

5. **TransferRepositoryInterface**
   - getByLeague(), getByUser(), getByPlayer()
   - createTransfer() - Mit Validation
   - validateTransfer()
   - getRecentTransfers(), getTransferStats()
   - updateStatus()

6. **RecommendationRepositoryInterface**
   - getByLeague(), getByCategory()
   - generateRecommendation(), calculateScore()
   - getTopRecommendations()
   - markAsApplied()
   - getRecommendationStats()
   - batchGenerate()

## 🚀 Verwendung

### Setup
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kickbasekumpel/data/repositories/firestore_repositories.dart';

// Provider sind bereits in firestore_repositories.dart definiert
final userRepo = ref.read(userRepositoryProvider);
final leagueRepo = ref.read(leagueRepositoryProvider);
final playerRepo = ref.read(playerRepositoryProvider);
final transferRepo = ref.read(transferRepositoryProvider);
final recommendationRepo = ref.read(recommendationRepositoryProvider);
```

### Beispiel: User erstellen
```dart
final userRepo = ref.read(userRepositoryProvider);

final user = User(
  i: 'user123',
  n: 'Max Mustermann',
  tn: 'Team Thunder',
  em: 'max@example.com',
  b: 50000000,
  tv: 100000000,
  p: 250,
  pl: 5,
  f: 0,
);

final result = await userRepo.create(user);

if (result is Success<User>) {
  print('User created: ${result.data.n}');
} else if (result is Failure<User>) {
  print('Error: ${result.message}');
}
```

### Beispiel: Real-time Stream
```dart
final leagueRepo = ref.read(leagueRepositoryProvider);

leagueRepo.watchById('league123').listen((result) {
  if (result is Success<League>) {
    print('League updated: ${result.data.n}');
    print('Matchday: ${result.data.md}');
  }
});
```

### Beispiel: Complex Query
```dart
final playerRepo = ref.read(playerRepositoryProvider);

final result = await playerRepo.filterPlayers(
  position: 3,              // Mittelfeld
  minMarketValue: 5000000,  // Min 5M
  maxMarketValue: 20000000, // Max 20M
  minAveragePoints: 7.0,    // Min 7 Punkte/Spiel
);

if (result is Success<List<Player>>) {
  print('Found ${result.data.length} players');
}
```

### Beispiel: Transfer mit Validation
```dart
final transferRepo = ref.read(transferRepositoryProvider);

final result = await transferRepo.createTransfer(
  leagueId: 'league123',
  fromUserId: 'seller123',
  toUserId: 'buyer456',
  playerId: 'player789',
  price: 12000000,
  marketValue: 10000000,
);

if (result is Success<Transfer>) {
  print('Transfer successful: ${result.data.playerName}');
} else if (result is Failure<Transfer>) {
  if (result.code == 'insufficient-funds') {
    print('Buyer has insufficient budget');
  }
}
```

### Beispiel: Recommendation generieren
```dart
final recommendationRepo = ref.read(recommendationRepositoryProvider);

final result = await recommendationRepo.generateRecommendation(
  leagueId: 'league123',
  playerId: 'player123',
  analysisData: {
    'playerName': 'Robert Lewandowski',
    'averagePoints': 8.5,
    'marketValue': 15000000,
    'estimatedValue': 18000000,
    'marketValueTrend': 3,
    'status': 1,
    'recentPoints': [9, 8, 10, 7, 9],
  },
);

if (result is Success<Recommendation>) {
  print('Action: ${result.data.action}');
  print('Score: ${result.data.score}');
  print('Confidence: ${result.data.confidence}');
}
```

## 🔧 Error Handling

Alle Repository-Methoden geben `Result<T>` zurück:

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final String? code;
  final Exception? exception;
  const Failure(this.message, {this.code, this.exception});
}
```

### Pattern Matching
```dart
switch (result) {
  case Success<User>(:final data):
    print('Success: ${data.n}');
    break;
  case Failure<User>(:final message, :final code):
    if (code == 'not-found') {
      print('User not found');
    } else {
      print('Error: $message');
    }
    break;
}
```

## 📊 Firestore Collections

Die Repositories verwenden folgende Firestore Collections:

```
/users/{userId}
  - name, teamName, email, budget, teamValue, points, placement

/leagues/{leagueId}
  - name, creator, season, matchday, standings[]
  - members[] (array of user IDs)

/players/{playerId}
  - firstName, lastName, teamId, position
  - marketValue, averagePoints, totalPoints

/transfers/{transferId}
  - leagueId, fromUserId, toUserId, playerId
  - price, marketValue, timestamp, status

/recommendations/{recommendationId}
  - leagueId, playerId, score, action
  - reason, confidence, category, timestamp
```

## 🎨 Advanced Features

### 1. Batch Operations
```dart
final operations = [
  BatchOperation<Player>(
    id: 'player1',
    type: BatchOperationType.update,
    data: player1,
  ),
  BatchOperation<Player>(
    id: 'player2',
    type: BatchOperationType.update,
    data: player2,
  ),
];

await playerRepo.batchWrite(operations);
```

### 2. Transactions
```dart
final result = await transferRepo.runTransaction((transaction) async {
  // Multi-document update
  // All-or-nothing guarantee
  return result;
});
```

### 3. Complex Queries
```dart
final result = await baseRepo.complexQuery(
  conditions: [
    QueryCondition(field: 'status', isEqualTo: 'active'),
    QueryCondition(field: 'points', isGreaterThan: 100),
  ],
  orderByField: 'points',
  descending: true,
  limit: 50,
);
```

## 📖 Weitere Beispiele

Siehe [REPOSITORY_USAGE_EXAMPLES.md](REPOSITORY_USAGE_EXAMPLES.md) für:
- ✅ 50+ Code-Beispiele
- ✅ Alle Repository-Methoden
- ✅ Real-time Streams
- ✅ Complex Queries
- ✅ Error Handling Patterns
- ✅ Advanced Use Cases

## 🔐 Security Rules

Vergiss nicht, Firestore Security Rules zu definieren:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    match /leagues/{leagueId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    match /players/{playerId} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only
    }
    
    match /transfers/{transferId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if false;
      allow delete: if false;
    }
  }
}
```

## 🧪 Testing

Um die Repositories zu testen:

```dart
// Mock Firestore für Tests
final mockFirestore = FakeFirebaseFirestore();

final userRepo = UserRepository(firestore: mockFirestore);

// Test
await userRepo.create(testUser);
final result = await userRepo.getById('test-id');

expect(result, isA<Success<User>>());
```

## 🚧 TODOs

- [ ] Offline Persistence Configuration
- [ ] Cache Layer Implementation
- [ ] Indexes für Complex Queries definieren
- [ ] Unit Tests für alle Repositories
- [ ] Integration Tests
- [ ] Performance Monitoring
- [ ] Rate Limiting für API Calls
- [ ] Pagination Support

## 📝 Notes

- **Firestore Indexes**: Für complex queries müssen Composite Indexes in Firebase Console erstellt werden
- **Limits**: Beachte Firestore Limits (1 write/second per document, 10K documents per query)
- **Costs**: Firestore berechnet pro Read/Write/Delete - optimiere Queries!
- **Real-time**: Streams verbrauchen mehr Resources - verwende sie nur wo nötig

## 🎓 Best Practices

1. **Result Type**: Immer Result<T> für Error Handling verwenden
2. **Streams**: Nur für UI-relevante Real-time Updates
3. **Batch Operations**: Für Multiple Updates verwenden
4. **Transactions**: Für kritische Multi-Document Updates
5. **Error Codes**: Spezifische Error Codes für besseres Handling
6. **Validation**: Immer vor kritischen Operations validieren
7. **Null Safety**: Alle optionalen Felder mit ?? behandeln

## 📚 Ressourcen

- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Riverpod Documentation](https://riverpod.dev)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Flutter Fire](https://firebase.flutter.dev)
