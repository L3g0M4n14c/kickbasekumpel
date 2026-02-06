import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../sources/auth_source.dart';

/// Repository implementation for authentication
class AuthRepository implements AuthRepositoryInterface {
  final AuthSource _authSource;
  User? _cachedUser;

  AuthRepository({AuthSource? authSource})
    : _authSource = authSource ?? AuthSource() {
    // Initialize cached user
    _cachedUser = _authSource.currentUser;

    // Update cache when auth state changes
    _authSource.authStateChanges.listen((user) {
      _cachedUser = user;
    });
  }

  @override
  Stream<User?> get authStateChanges => _authSource.authStateChanges;

  /// Get cached user or fetch from auth source
  User? get cachedUser => _cachedUser ?? _authSource.currentUser;

  @override
  Future<AuthResult<User?>> getCurrentUser() async {
    try {
      // Try to get from cache first
      if (_cachedUser != null) {
        return AuthSuccess(_cachedUser);
      }

      // Fallback to auth source
      final user = _authSource.currentUser;
      _cachedUser = user;
      return AuthSuccess(user);
    } catch (e) {
      return AuthFailure('Fehler beim Abrufen des Benutzers: $e');
    }
  }

  @override
  Future<AuthResult<User>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final result = await _authSource.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );

    // Update cache on success
    if (result is AuthSuccess<User>) {
      _cachedUser = result.data;
    }

    return result;
  }

  @override
  Future<AuthResult<User>> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _authSource.signIn(email: email, password: password);

    // Update cache on success
    if (result is AuthSuccess<User>) {
      _cachedUser = result.data;
    }

    return result;
  }

  @override
  Future<AuthResult<void>> signOut() async {
    final result = await _authSource.signOut();

    // Clear cache on success
    if (result is AuthSuccess) {
      _cachedUser = null;
    }

    return result;
  }

  @override
  Future<AuthResult<void>> sendPasswordResetEmail(String email) async {
    return await _authSource.sendPasswordResetEmail(email);
  }

  @override
  Future<AuthResult<void>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final result = await _authSource.updateProfile(
      displayName: displayName,
      photoURL: photoURL,
    );

    // Reload user to update cache
    if (result is AuthSuccess) {
      final reloadResult = await _authSource.reloadUser();
      if (reloadResult is AuthSuccess<User>) {
        _cachedUser = reloadResult.data;
      }
    }

    return result;
  }

  @override
  Future<AuthResult<void>> deleteAccount() async {
    final result = await _authSource.deleteAccount();

    // Clear cache on success
    if (result is AuthSuccess) {
      _cachedUser = null;
    }

    return result;
  }

  /// Reload current user data and update cache
  Future<AuthResult<User>> reloadUser() async {
    final result = await _authSource.reloadUser();

    // Update cache on success
    if (result is AuthSuccess<User>) {
      _cachedUser = result.data;
    }

    return result;
  }
}
