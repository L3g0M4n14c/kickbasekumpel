import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction for token storage to make the API client testable.
abstract class TokenStorage {
  Future<void> setToken(String token);
  Future<String?> getToken();
  Future<bool> hasToken();
  Future<void> clearToken();
}

/// Default implementation using SharedPreferences (keeps current behavior)
class SharedPreferencesTokenStorage implements TokenStorage {
  static const _tokenKey = 'kickbase_token';

  @override
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove('kickbase_user_data');
  }
}

/// Optional secure storage implementation
class SecureStorageTokenStorage implements TokenStorage {
  final FlutterSecureStorage _secureStorage;
  static const _tokenKey = 'kickbase_token';

  SecureStorageTokenStorage([FlutterSecureStorage? secureStorage])
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> setToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    final tok = await getToken();
    return tok != null && tok.isNotEmpty;
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
    // Note: secure storage may not store user data; if it does, delete it here.
  }
}
