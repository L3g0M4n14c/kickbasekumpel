import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mocktail/mocktail.dart';

// Mock classes for Firebase Auth
class MockFirebaseAuth extends Mock implements auth.FirebaseAuth {}

class MockUser extends Mock implements auth.User {}

class MockUserCredential extends Mock implements auth.UserCredential {}

/// Mock Firebase Setup for Testing
class MockFirebaseSetup {
  static FakeFirebaseFirestore createFakeFirestore() {
    return FakeFirebaseFirestore();
  }

  static MockFirebaseAuth createMockAuth({
    auth.User? currentUser,
    Stream<auth.User?>? authStateChanges,
  }) {
    final mockAuth = MockFirebaseAuth();

    when(() => mockAuth.currentUser).thenReturn(currentUser);

    if (authStateChanges != null) {
      when(
        () => mockAuth.authStateChanges(),
      ).thenAnswer((_) => authStateChanges);
    } else {
      when(
        () => mockAuth.authStateChanges(),
      ).thenAnswer((_) => Stream.value(currentUser));
    }

    return mockAuth;
  }

  /// Creates a mock user for testing
  static MockUser createMockUser({
    String uid = 'test-uid-123',
    String? email = 'test@example.com',
    String? displayName = 'Test User',
  }) {
    final mockUser = MockUser();
    when(() => mockUser.uid).thenReturn(uid);
    when(() => mockUser.email).thenReturn(email);
    when(() => mockUser.displayName).thenReturn(displayName);
    return mockUser;
  }

  /// Creates a mock UserCredential
  static MockUserCredential createMockUserCredential(auth.User user) {
    final mockCredential = MockUserCredential();
    when(() => mockCredential.user).thenReturn(user);
    return mockCredential;
  }

  /// Setup Firestore with test data
  static Future<FakeFirebaseFirestore> setupFirestoreWithData({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? leagues,
    List<Map<String, dynamic>>? players,
    List<Map<String, dynamic>>? transfers,
  }) async {
    final firestore = FakeFirebaseFirestore();

    // Add users
    if (users != null) {
      for (final user in users) {
        await firestore.collection('users').doc(user['id']).set(user);
      }
    }

    // Add leagues
    if (leagues != null) {
      for (final league in leagues) {
        await firestore.collection('leagues').doc(league['id']).set(league);
      }
    }

    // Add players
    if (players != null) {
      for (final player in players) {
        await firestore.collection('players').doc(player['id']).set(player);
      }
    }

    // Add transfers
    if (transfers != null) {
      for (final transfer in transfers) {
        await firestore
            .collection('transfers')
            .doc(transfer['id'])
            .set(transfer);
      }
    }

    return firestore;
  }
}
