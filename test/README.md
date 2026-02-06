# Repository Tests

Umfangreiche Test-Suite für alle Firestore Repositories und Authentication.

## Test-Struktur

```
test/
├── helpers/
│   ├── mock_firebase.dart       # Firebase Mocking Setup
│   ├── test_data.dart           # Test Data Generatoren
│   └── matchers.dart            # Custom Matchers für Result-Type
└── data/
    └── repositories/
        ├── auth_repository_test.dart
        ├── base_repository_test.dart
        ├── user_repository_test.dart
        ├── league_repository_test.dart
        ├── player_repository_test.dart
        └── transfer_repository_test.dart
```

## Voraussetzungen

Installiere zuerst die Test-Dependencies:

```bash
flutter pub get
```

## Tests ausführen

### Alle Tests
```bash
flutter test
```

### Spezifische Repository-Tests
```bash
flutter test test/data/repositories/auth_repository_test.dart
flutter test test/data/repositories/user_repository_test.dart
```

### Mit Coverage
```bash
flutter test --coverage
```

## Test-Dependencies

- `mocktail`: Mocking ohne Code-Generation
- `fake_cloud_firestore`: Firebase Firestore Mocking
- `firebase_auth_mocks`: Firebase Auth Mocking

## Test-Coverage

Jedes Repository wird getestet auf:
- ✅ CRUD Operationen (Create, Read, Update, Delete)
- ✅ Query-Methoden (where, orderBy, komplexe Queries)
- ✅ Real-time Streams
- ✅ Error Handling
- ✅ Daten-Serialisierung (toFirestore/fromFirestore)
- ✅ Repository-spezifische Methoden

## Besondere Test-Cases

### AuthRepository
- User Caching
- Stream Updates (authStateChanges)
- Firebase Exception Handling
- Eingabevalidierung

### BaseRepository
- Generische CRUD-Operationen
- Timestamp-Konvertierungen
- Batch Operations
- Transaktionen

### UserRepository
- Email-basierte Suche
- Profil-Updates
- Statistik-Updates
- Name-basierte Suche

### LeagueRepository
- Member-Management
- User-Liga Zuordnung
- Aktive Ligen filtern

### PlayerRepository
- Team-basierte Filter
- Positions-Filter
- Market Value Range Filter
- Top Player Queries
- Batch Updates

### TransferRepository
- Transfer-Validierung
- Statistik-Aggregation
- Multi-Collection Queries
- Status-Updates
