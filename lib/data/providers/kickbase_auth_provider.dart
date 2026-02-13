import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../services/kickbase_api_client.dart';
import 'kickbase_api_provider.dart';

final _logger = Logger();

// ============================================================================
// Kickbase Authentication State Management
// ============================================================================

/// State für Kickbase Authentication
class KickbaseAuthState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final bool isAuthenticated;
  final User? currentUser;
  final LoginResponse? loginResponse;

  const KickbaseAuthState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.isAuthenticated = false,
    this.currentUser,
    this.loginResponse,
  });

  KickbaseAuthState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? isAuthenticated,
    User? currentUser,
    LoginResponse? loginResponse,
  }) {
    return KickbaseAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }

  /// Clear messages
  KickbaseAuthState clearMessages() {
    return KickbaseAuthState(
      isLoading: isLoading,
      isAuthenticated: isAuthenticated,
      currentUser: currentUser,
      loginResponse: loginResponse,
    );
  }
}

// ============================================================================
// Kickbase Auth Notifier
// ============================================================================

/// Notifier für Kickbase Authentication Operations
class KickbaseAuthNotifier extends Notifier<KickbaseAuthState> {
  KickbaseAPIClient get _apiClient => ref.read(kickbaseApiClientProvider);

  @override
  KickbaseAuthState build() {
    // Check if token exists on initialization
    _checkAuthStatus();
    return const KickbaseAuthState();
  }

  /// Check authentication status by verifying token existence
  Future<void> _checkAuthStatus() async {
    final hasToken = await _apiClient.hasAuthToken();

    if (hasToken) {
      // Token exists - load saved user data
      final savedUser = await _apiClient.getSavedUserData();

      state = state.copyWith(isAuthenticated: true, currentUser: savedUser);

      if (savedUser != null) {
        _logger.d(
          '🔑 Existing token and user data found - user: ${savedUser.n}',
        );
      } else {
        _logger.d('🔑 Existing token found but no user data');
      }
    } else {
      state = state.copyWith(isAuthenticated: false);
      _logger.d('🔓 No token found - user needs to login');
    }
  }

  /// Login with Kickbase credentials
  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final loginResponse = await _apiClient.login(email, password);

      // User data should be included in login response
      final user = loginResponse.user;

      if (user == null) {
        throw Exception(
          'Login erfolgreich, aber keine Benutzerdaten erhalten. '
          'Bitte kontaktieren Sie den Support.',
        );
      }

      // Save user data to SharedPreferences
      await _apiClient.saveUserData(user);

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: user,
        loginResponse: loginResponse,
        successMessage: 'Erfolgreich bei Kickbase angemeldet',
      );

      _logger.i('✅ Kickbase login successful for user: ${user.n}');
      return true;
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception:', '').trim();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: errorMessage,
      );

      _logger.e('❌ Kickbase login failed: $errorMessage');
      return false;
    }
  }

  /// Logout and clear token
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _apiClient.clearAuthToken();

      state = const KickbaseAuthState(
        isAuthenticated: false,
        successMessage: 'Erfolgreich abgemeldet',
      );

      _logger.i('✅ Kickbase logout successful');
    } catch (e) {
      _logger.w('⚠️ Logout error (still clearing state): $e');

      // Even if error, clear the state
      state = const KickbaseAuthState(
        isAuthenticated: false,
        error: 'Abmeldung abgeschlossen (mit Warnung)',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.clearMessages();
  }

  /// Refresh user data
  /// Note: Currently not available as /v4/user endpoint returns 405
  /// User data is only available from login response
  Future<void> refreshUserData() async {
    if (!state.isAuthenticated) return;

    _logger.w(
      '⚠️ User data refresh not available - /v4/user endpoint not supported',
    );
    _logger.i('💡 User data is loaded from login response only');

    // try {
    //   final user = await _apiClient.getUser();
    //   state = state.copyWith(currentUser: user);
    //   _logger.i('✅ User data refreshed');
    // } catch (e) {
    //   _logger.w('⚠️ Failed to refresh user data: $e');
    //   // Don't change auth state, just log the error
    // }
  }
}

// ============================================================================
// Providers
// ============================================================================

/// Main Kickbase Auth Provider
final kickbaseAuthProvider =
    NotifierProvider<KickbaseAuthNotifier, KickbaseAuthState>(
      KickbaseAuthNotifier.new,
    );

/// Convenience Provider: Is user authenticated?
final isKickbaseAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(kickbaseAuthProvider);
  return authState.isAuthenticated;
});

/// Convenience Provider: Current Kickbase user
final currentKickbaseUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(kickbaseAuthProvider);
  return authState.currentUser;
});

/// Convenience Provider: User ID
final kickbaseUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentKickbaseUserProvider);
  return user?.i;
});

/// Convenience Provider: User name
final kickbaseUserNameProvider = Provider<String?>((ref) {
  final user = ref.watch(currentKickbaseUserProvider);
  return user?.n;
});

/// Convenience Provider: Team name
final kickbaseTeamNameProvider = Provider<String?>((ref) {
  final user = ref.watch(currentKickbaseUserProvider);
  return user?.tn;
});

/// FutureProvider: Has Kickbase token?
final hasKickbaseTokenProvider = FutureProvider<bool>((ref) async {
  final apiClient = ref.watch(kickbaseApiClientProvider);
  return await apiClient.hasAuthToken();
});
