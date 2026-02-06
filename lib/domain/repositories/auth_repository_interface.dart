import 'package:firebase_auth/firebase_auth.dart';

/// Result type for authentication operations
sealed class AuthResult<T> {
  const AuthResult();
}

class AuthSuccess<T> extends AuthResult<T> {
  final T data;
  const AuthSuccess(this.data);
}

class AuthFailure<T> extends AuthResult<T> {
  final String message;
  final String? code;
  const AuthFailure(this.message, {this.code});
}

/// Interface for authentication repository
abstract class AuthRepositoryInterface {
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Get current authenticated user
  Future<AuthResult<User?>> getCurrentUser();

  /// Sign up with email and password
  Future<AuthResult<User>> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with email and password
  Future<AuthResult<User>> signIn({
    required String email,
    required String password,
  });

  /// Sign out current user
  Future<AuthResult<void>> signOut();

  /// Send password reset email
  Future<AuthResult<void>> sendPasswordResetEmail(String email);

  /// Update user profile
  Future<AuthResult<void>> updateProfile({
    String? displayName,
    String? photoURL,
  });

  /// Delete current user account
  Future<AuthResult<void>> deleteAccount();
}
