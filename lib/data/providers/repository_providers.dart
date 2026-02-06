import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/firestore_repositories.dart';
import '../repositories/auth_repository.dart';

// ============================================================================
// FIREBASE INSTANCE PROVIDERS
// ============================================================================

/// FirebaseFirestore instance Provider
/// Lazy loaded singleton instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// FirebaseAuth instance Provider
/// Lazy loaded singleton instance
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

// ============================================================================
// REPOSITORY PROVIDERS
// ============================================================================

/// User Repository Provider
/// Manages all user-related Firestore operations
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore: firestore);
});

/// League Repository Provider
/// Manages all league-related Firestore operations
final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return LeagueRepository(firestore: firestore);
});

/// Player Repository Provider
/// Manages all player-related Firestore operations
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return PlayerRepository(firestore: firestore);
});

/// Transfer Repository Provider
/// Manages all transfer-related Firestore operations
final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return TransferRepository(firestore: firestore);
});

/// Recommendation Repository Provider
/// Manages all recommendation-related Firestore operations
final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  final firestore = ref.watch(firestoreProvider);
  return RecommendationRepository(firestore: firestore);
});

/// Auth Repository Provider
/// Manages Firebase authentication operations
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
