import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/firestore_repositories.dart';
import '../repositories/auth_repository.dart';
import '../services/deterministic_recommendation_service.dart';
import 'kickbase_api_provider.dart';

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
/// Manages all user-related Firestore operations with API-first pattern
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return UserRepository(firestore: firestore, apiClient: apiClient);
});

/// League Repository Provider
/// Manages all league-related Firestore operations with API-first pattern
final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return LeagueRepository(firestore: firestore, apiClient: apiClient);
});

/// Player Repository Provider
/// Manages all player-related Firestore operations with API-first pattern
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return PlayerRepository(firestore: firestore, apiClient: apiClient);
});

/// Transfer Repository Provider
/// Manages all transfer-related Firestore operations with API-first pattern
final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return TransferRepository(firestore: firestore, apiClient: apiClient);
});

/// Deterministic Recommendation Service Provider
/// Rein lokale, deterministische Empfehlungsberechnung (kein KI-Service)
final deterministicRecommendationServiceProvider =
    Provider<DeterministicRecommendationService>((ref) {
  return const DeterministicRecommendationService();
});

/// Recommendation Repository Provider
/// Manages all recommendation-related operations
/// Empfehlungen werden rein deterministisch lokal berechnet
/// Ergebnisse werden NICHT in Firestore gespeichert, sondern direkt zurückgegeben
final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  final firestore = ref.watch(firestoreProvider);
  final recommendationService = ref.watch(
    deterministicRecommendationServiceProvider,
  );
  
  return RecommendationRepository(
    firestore: firestore,
    recommendationService: recommendationService,
  );
});

/// Auth Repository Provider
/// Manages Firebase authentication operations
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
