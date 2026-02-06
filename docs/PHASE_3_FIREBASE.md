# Phase 3: Firebase Backend Integration (3h)

**Status:** ⏳ Aktiv - Bereit zum Start!  
**Dauer:** 3 Stunden | **Copilot:** 70% | **User:** 30%  
**Phase 2 Status:** ✅ Alle 12 Modelle erfolgreich migriert  

---

## 🎯 Objectives

- Firebase Authentication (Email + Google Sign-In)
- Firestore Repositories für alle Modelle
- Riverpod Providers & State Management
- Firebase Security Rules
- Real-time Data Streaming
- Error Handling & Validation

---

## 📊 Architektur Phase 3

```
lib/
├── data/
│   ├── models/ (✅ Phase 2)
│   ├── repositories/           ← NEU
│   │   ├── user_repository.dart
│   │   ├── league_repository.dart
│   │   ├── player_repository.dart
│   │   ├── transfer_repository.dart
│   │   ├── firebase_repository.dart (Base)
│   │   └── repositories_barrel.dart
│   ├── sources/                ← NEU
│   │   ├── firebase_source.dart
│   │   └── auth_source.dart
│   └── providers/              ← NEU
│       ├── auth_provider.dart
│       ├── repository_providers.dart
│       ├── user_providers.dart
│       └── data_providers.dart
└── domain/
    ├── repositories/           ← NEU (Interfaces)
    │   ├── user_repository_interface.dart
    │   ├── league_repository_interface.dart
    │   └── ...
    └── providers/              ← NEU
        └── state_providers.dart
```

---

## 🔐 Phase 3a: Firebase Auth Setup

### GitHub Copilot Prompt (COPY-PASTE)

```
Ich baue Firebase Authentication für mein Flutter Projekt "KickbaseKumpel".

Erstelle:

1. lib/data/sources/auth_source.dart
   - Nutze firebase_auth
   - Methoden: signUp, signIn, signOut, currentUser
   - Error Handling für alle Fälle
   - Stream<User?> für Auth State Changes

2. lib/data/repositories/auth_repository.dart
   - Interface: lib/domain/repositories/auth_repository_interface.dart
   - Nutze AuthSource
   - Result<User> für Type Safety
   - Cached User State

3. lib/data/providers/auth_provider.dart
   - AuthStateProvider (Stream<User?>)
   - currentUserProvider (Future<User?>)
   - signInProvider (FutureProvider)
   - signOutProvider (FutureProvider)
   - signUpProvider (FutureProvider)

Nutze Riverpod Best Practices:
- FutureProvider für async Calls
- StreamProvider für Real-time Data
- StateNotifierProvider für mutable State
- Dependency Injection via providers

Generiere auch Examples für Sign In / Sign Out Usage
```

---

## 🗄️ Phase 3b: Firestore Repositories

### Firestore Collection Schema

```javascript
// Firebase Console → Firestore
// Erstelle diese Collections:

/users/{uid}
├── id: string (uid)
├── email: string
├── displayName: string
├── avatar: string (URL)
├── createdAt: timestamp
└── preferences: {
    └── theme: string
    }

/leagues/{leagueId}
├── id: string
├── name: string
├── ownerId: string (uid)
├── season: number
├── settings: {...}
└── members: [string] (uids)

/players/{playerId}
├── id: string
├── name: string
├── position: string
├── marketValue: number
├── team: string
└── stats: {...}

/transfers/{transferId}
├── id: string
├── leagueId: string
├── from: string (uid)
├── to: string (uid)
├── player: string (playerId)
├── price: number
└── timestamp: timestamp

/recommendations/{recommendationId}
├── id: string
├── leagueId: string
├── playerId: string
├── score: number
├── reason: string
└── timestamp: timestamp
```

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Firestore Repositories für mein KickbaseKumpel Projekt:

1. lib/domain/repositories/repository_interfaces.dart
   - Abstrakte Interfaces für: User, League, Player, Transfer, Recommendation
   - Alle Methoden: getAll(), getById(), create(), update(), delete()
   - Result<T> für Error Handling

2. lib/data/repositories/base_repository.dart
   - Base Klasse mit gemeinsamen Methoden
   - Firestore Query Helpers
   - Error Handling & Mapping
   - Timestamp Handling

3. lib/data/repositories/firestore_repositories.dart
   - Implementiere alle Interfaces
   - UserRepository (CRUD + Auth)
   - LeagueRepository (mit Member Management)
   - PlayerRepository (mit Search & Filter)
   - TransferRepository (mit Validation)
   - RecommendationRepository (Scoring Logic)

Anforderungen:
- Benutze Firestore Queries (where, orderBy, limit)
- Real-time Streams für Live Data
- Transaction Support für Multi-Doc Updates
- Batch Operations für Bulk Updates
- Cache Layer (optional)

Nutze diese Package-Struktur:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
```

---

## 📡 Phase 3c: Riverpod Providers

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Riverpod Providers für mein KickbaseKumpel Projekt:

1. lib/data/providers/repository_providers.dart
   - FirebaseFirestore instance Provider
   - Alle Repository Instances als Providers
   - Lazy Loading mit Riverpod

2. lib/data/providers/user_providers.dart
   - currentUserProvider (Stream<User?>)
   - userDataProvider (Future<User>)
   - userSettingsProvider (Future<UserSettings>)
   - Nutze AsyncValue für Loading/Error States

3. lib/data/providers/league_providers.dart
   - leaguesProvider (Stream<List<League>>)
   - selectedLeagueProvider (StateProvider<League?>)
   - leagueDetailsProvider(leagueId) (Future<League>)
   - leaguePlayersProvider(leagueId) (Stream<List<Player>>)

4. lib/data/providers/player_providers.dart
   - allPlayersProvider (Stream<List<Player>>)
   - playerDetailsProvider(playerId) (Future<Player>)
   - playerStatsProvider(playerId) (Future<PlayerStats>)

5. lib/data/providers/transfer_providers.dart
   - userTransfersProvider (Stream<List<Transfer>>)
   - leagueTransfersProvider(leagueId) (Stream<List<Transfer>>)
   - transfersToReviewProvider (Stream<List<Transfer>>)

6. lib/data/providers/recommendation_providers.dart
   - recommendationsProvider(leagueId) (Stream<List<Recommendation>>)
   - topRecommendationsProvider(leagueId, limit) (Future<List<Recommendation>>)

Nutze Riverpod Best Practices:
- .when() für AsyncValue Handling
- .select() für Filtering
- .watchWhere() für Conditional Watching
- Family Modifiers für Parameter
- Build Kontext für Navigation

Zeige auch Usage-Beispiele in Widgets
```

---

## 🔒 Phase 3d: Firebase Security Rules

### Firestore Security Rules

**Datei:** `firestore.rules` (Firebase Console)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function
    function isOwner(uid) {
      return request.auth.uid == uid;
    }

    function isMember(leagueId) {
      return exists(/databases/$(database)/documents/leagues/$(leagueId))
        && request.auth.uid in 
           resource.data.members;
    }

    // Users collection
    match /users/{document=**} {
      allow read: if request.auth.uid == document;
      allow create: if request.auth.uid == request.resource.data.id;
      allow update, delete: if isOwner(document);
    }

    // Leagues collection
    match /leagues/{leagueId} {
      allow read: if isMember(leagueId) || isOwner(resource.data.ownerId);
      allow create: if request.auth != null;
      allow update, delete: if isOwner(resource.data.ownerId);
      
      // Subcollections
      match /{document=**} {
        allow read, write: if isMember(leagueId);
      }
    }

    // Players (global read)
    match /players/{document=**} {
      allow read: if request.auth != null;
      allow write: if false; // Nur Backend
    }

    // Transfers
    match /transfers/{transferId} {
      allow read: if isMember(resource.data.leagueId);
      allow create: if request.auth.uid == request.resource.data.from;
      allow update: if request.auth.uid == request.resource.data.to;
      allow delete: if isOwner(resource.data.ownerId);
    }

    // Recommendations
    match /recommendations/{recommendationId} {
      allow read: if isMember(resource.data.leagueId);
      allow write: if false; // Nur Backend
    }
  }
}
```

**Deploy Rules:**
```bash
# Firebase CLI installieren
npm install -g firebase-tools

# Login
firebase login

# Deploy
firebase deploy --only firestore:rules
```

---

## 🧪 Validierung

### Test Checklist

- [ ] Firebase Auth Sign-In/Sign-Out funktioniert
- [ ] Firestore Collections existieren
- [ ] Repositories können CRUD Operationen
- [ ] Riverpod Providers sind injectet
- [ ] Security Rules blockieren Unauthorized Access
- [ ] Streams geben Real-time Updates
- [ ] Error Handling zeigt Fehler ohne Crashes

### Flutter Test

```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel
flutter test test/data/repositories/ --coverage
flutter test test/domain/providers/ --coverage
```

---

## 🎯 Success Criteria

- [x] Firebase Auth Implementiert
- [x] Firestore Collections Schema definiert
- [x] 5+ Repositories mit CRUD Operations
- [x] Riverpod Providers für alle Models
- [x] Security Rules deployed
- [x] Error Handling & Validation
- [x] Real-time Streams funktionieren
- [x] Zero Unauthorized Access (Security)
- [x] Git Commit: "Phase 3: Firebase Backend"

---

## 🔗 Nächster Schritt

Wenn Phase 3 fertig: → **[Phase 4: Services](./PHASE_4_SERVICES.md)**

---

## 📚 Referenzen

- **Firebase Docs:** https://firebase.flutter.dev/docs/overview
- **Firestore Security:** https://firebase.google.com/docs/firestore/security
- **Riverpod Docs:** https://riverpod.dev
- **AsyncValue Pattern:** https://riverpod.dev/docs/essentials/first_request

---

**Fortschritt:** Phase 1-2 (✅) → Phase 3 (⏳)  
**Copilot wird ~70% dieser Arbeit machen!**
