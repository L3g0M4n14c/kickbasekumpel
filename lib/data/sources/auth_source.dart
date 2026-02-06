import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository_interface.dart';

/// Exception types for authentication errors
class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Data source for Firebase Authentication operations
class AuthSource {
  final FirebaseAuth _firebaseAuth;

  AuthSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Get current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign up with email and password
  Future<AuthResult<User>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        return const AuthFailure(
          'E-Mail und Passwort dürfen nicht leer sein',
          code: 'invalid-input',
        );
      }

      if (password.length < 6) {
        return const AuthFailure(
          'Passwort muss mindestens 6 Zeichen lang sein',
          code: 'weak-password',
        );
      }

      // Create user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const AuthFailure(
          'Benutzer konnte nicht erstellt werden',
          code: 'user-creation-failed',
        );
      }

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
        await user.reload();
        return AuthSuccess(_firebaseAuth.currentUser!);
      }

      return AuthSuccess(user);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Ein unerwarteter Fehler ist aufgetreten: $e',
      );
    }
  }

  /// Sign in with email and password
  Future<AuthResult<User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        return const AuthFailure(
          'E-Mail und Passwort dürfen nicht leer sein',
          code: 'invalid-input',
        );
      }

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return const AuthFailure(
          'Anmeldung fehlgeschlagen',
          code: 'sign-in-failed',
        );
      }

      return AuthSuccess(user);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Ein unerwarteter Fehler ist aufgetreten: $e',
      );
    }
  }

  /// Sign out current user
  Future<AuthResult<void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Fehler beim Abmelden: $e',
      );
    }
  }

  /// Send password reset email
  Future<AuthResult<void>> sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        return const AuthFailure(
          'E-Mail darf nicht leer sein',
          code: 'invalid-input',
        );
      }

      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Fehler beim Senden der Passwort-Reset-E-Mail: $e',
      );
    }
  }

  /// Update user profile
  Future<AuthResult<void>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const AuthFailure(
          'Kein Benutzer angemeldet',
          code: 'no-user',
        );
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Fehler beim Aktualisieren des Profils: $e',
      );
    }
  }

  /// Delete current user account
  Future<AuthResult<void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const AuthFailure(
          'Kein Benutzer angemeldet',
          code: 'no-user',
        );
      }

      await user.delete();
      return const AuthSuccess(null);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Fehler beim Löschen des Kontos: $e',
      );
    }
  }

  /// Reload current user data
  Future<AuthResult<User>> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const AuthFailure(
          'Kein Benutzer angemeldet',
          code: 'no-user',
        );
      }

      await user.reload();
      final reloadedUser = _firebaseAuth.currentUser;
      if (reloadedUser == null) {
        return const AuthFailure(
          'Benutzer konnte nicht neu geladen werden',
          code: 'reload-failed',
        );
      }

      return AuthSuccess(reloadedUser);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(
        _getErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      return AuthFailure(
        'Fehler beim Neuladen des Benutzers: $e',
      );
    }
  }

  /// Get localized error messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Die E-Mail-Adresse ist ungültig';
      case 'user-disabled':
        return 'Dieses Konto wurde deaktiviert';
      case 'user-not-found':
        return 'Kein Benutzer mit dieser E-Mail gefunden';
      case 'wrong-password':
        return 'Falsches Passwort';
      case 'email-already-in-use':
        return 'Diese E-Mail-Adresse wird bereits verwendet';
      case 'operation-not-allowed':
        return 'Diese Operation ist nicht erlaubt';
      case 'weak-password':
        return 'Das Passwort ist zu schwach';
      case 'too-many-requests':
        return 'Zu viele Anfragen. Bitte versuche es später erneut';
      case 'network-request-failed':
        return 'Netzwerkfehler. Überprüfe deine Internetverbindung';
      case 'requires-recent-login':
        return 'Diese Aktion erfordert eine erneute Anmeldung';
      case 'invalid-credential':
        return 'Die Anmeldedaten sind ungültig';
      default:
        return 'Ein Fehler ist aufgetreten: $code';
    }
  }
}
