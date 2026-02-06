import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../repositories/auth_repository.dart';
import '../sources/auth_source.dart';

// ============================================================================
// Provider für Dependencies
// ============================================================================

/// Provider für AuthSource
final authSourceProvider = Provider<AuthSource>((ref) {
  return AuthSource();
});

/// Provider für AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authSource = ref.watch(authSourceProvider);
  return AuthRepository(authSource: authSource);
});

// ============================================================================
// StreamProvider für Auth State
// ============================================================================

/// StreamProvider für Authentication State Changes
/// Gibt den aktuellen User zurück oder null wenn nicht angemeldet
final authStateProvider = StreamProvider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

// ============================================================================
// Provider für aktuellen User
// ============================================================================

/// Provider für den aktuell angemeldeten User
/// Nutzt den cached User für bessere Performance
final currentUserProvider = Provider<User?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.cachedUser;
});

/// FutureProvider für den aktuellen User mit Result
final currentUserResultProvider = FutureProvider<AuthResult<User?>>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.getCurrentUser();
});

// ============================================================================
// StateNotifier für Auth Operations
// ============================================================================

/// State für Auth Operations
class AuthState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }

  /// Clear messages
  AuthState clearMessages() {
    return AuthState(isLoading: isLoading);
  }
}

/// StateNotifier für Authentication Operations
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState());

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result is AuthSuccess<User>) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Konto erfolgreich erstellt',
      );
      return true;
    } else if (result is AuthFailure<User>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Unbekannter Fehler',
    );
    return false;
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.signIn(
      email: email,
      password: password,
    );

    if (result is AuthSuccess<User>) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Erfolgreich angemeldet',
      );
      return true;
    } else if (result is AuthFailure<User>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Unbekannter Fehler',
    );
    return false;
  }

  /// Sign out current user
  Future<bool> signOut() async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.signOut();

    if (result is AuthSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Erfolgreich abgemeldet',
      );
      return true;
    } else if (result is AuthFailure) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Unbekannter Fehler',
    );
    return false;
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.sendPasswordResetEmail(email);

    if (result is AuthSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Passwort-Reset-E-Mail gesendet',
      );
      return true;
    } else if (result is AuthFailure) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Unbekannter Fehler',
    );
    return false;
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.updateProfile(
      displayName: displayName,
      photoURL: photoURL,
    );

    if (result is AuthSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Profil aktualisiert',
      );
      return true;
    } else if (result is AuthFailure) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Unbekannter Fehler',
    );
    return false;
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.deleteAccount();

    if (result is AuthSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Konto gelöscht',
      );
      return true;
    } else if (result is AuthFailure) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: false,
      error: 'Unbekannter Fehler',
    );
    return false;
  }

  /// Clear error and success messages
  void clearMessages() {
    state = state.clearMessages();
  }
}

/// Provider für AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// ============================================================================
// Convenience Provider für häufige Checks
// ============================================================================

/// Provider für Check ob User angemeldet ist
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

/// Provider für User ID
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.uid;
});

/// Provider für User Email
final userEmailProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.email;
});

/// Provider für User Display Name
final userDisplayNameProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.displayName;
});

/// Provider für User Photo URL
final userPhotoUrlProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.photoURL;
});
