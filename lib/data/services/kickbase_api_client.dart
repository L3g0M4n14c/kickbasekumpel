import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'token_storage.dart';

import '../../domain/exceptions/kickbase_exceptions.dart';
import '../models/league_model.dart';
import '../models/lineup_model.dart';
import '../models/market_model.dart';
import '../models/performance_model.dart';
import '../models/player_model.dart';
import '../models/transfer_model.dart';
import '../models/user_model.dart';
import '../utils/parsing_utils.dart';

/// Kickbase API Client
///
/// Handles all HTTP communication with Kickbase API v4.
/// Manages authentication token, error handling, and retry logic.
///
/// Based on KickbaseAPIClient.swift from iOS app.
class KickbaseAPIClient {
  static const String _baseUrl = 'https://api.kickbase.com';
  static const String _apiVersion = 'v4';
  static const String _userDataKey = 'kickbase_user_data';
  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(milliseconds: 500);

  final http.Client _httpClient;
  final TokenStorage _tokenStorage;

  String? _cachedToken;

  KickbaseAPIClient({http.Client? httpClient, TokenStorage? tokenStorage})
    : _httpClient = httpClient ?? http.Client(),
      _tokenStorage = tokenStorage ?? SharedPreferencesTokenStorage();

  // MARK: - Token Management

  /// Set authentication token
  Future<void> setAuthToken(String token) async {
    _cachedToken = token;
    await _tokenStorage.setToken(token);
    print('🔑 Auth token saved');
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }
    _cachedToken = await _tokenStorage.getToken();
    return _cachedToken;
  }

  /// Check if auth token exists
  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear authentication token
  Future<void> clearAuthToken() async {
    _cachedToken = null;
    await _tokenStorage.clearToken();
    print('🗑️ Auth token and user data cleared');
  }

  /// Save user data
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
    print('💾 User data saved');
  }

  /// Get saved user data
  Future<User?> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    if (userData != null) {
      try {
        return User.fromJson(jsonDecode(userData));
      } catch (e) {
        print('⚠️ Error loading user data: $e');
        return null;
      }
    }
    return null;
  }

  // MARK: - Generic API Request Methods

  /// Make HTTP request with auth token
  Future<http.Response> _makeRequest({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final token = await getAuthToken();

    if (requiresAuth && (token == null || token.isEmpty)) {
      throw const AuthenticationException('No authentication token available');
    }

    final url = Uri.parse('$_baseUrl$endpoint');
    final requestHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (requiresAuth && token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    print('📤 Making $method request to: $url');

    late http.Response response;

    try {
      final request = http.Request(method, url)..headers.addAll(requestHeaders);

      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await _httpClient
          .send(request)
          .timeout(_timeout);
      response = await http.Response.fromStream(streamedResponse);
    } on SocketException catch (e) {
      throw NetworkException('No internet connection', originalError: e);
    } on TimeoutException catch (e) {
      throw TimeoutException(
        'Request timeout after ${_timeout.inSeconds}s',
        originalError: e,
      );
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}', originalError: e);
    }

    print('📊 Response Status Code: ${response.statusCode}');
    if (response.body.isNotEmpty) {
      final preview = response.body.length > 500
          ? '${response.body.substring(0, 500)}...'
          : response.body;
      print('📥 Response: $preview');
    }

    return response;
  }

  /// Try multiple endpoints until one succeeds
  // ignore: unused_element
  Future<Map<String, dynamic>> _tryMultipleEndpoints({
    required List<String> endpoints,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await getAuthToken();

    if (token == null || token.isEmpty) {
      throw const AuthenticationException('No authentication token available');
    }

    Exception? lastError;

    for (var i = 0; i < endpoints.length; i++) {
      final endpoint = endpoints[i];

      try {
        final response = await _makeRequest(
          endpoint: endpoint,
          method: method,
          body: body,
        );

        if (response.statusCode == 200) {
          final json = _parseJson(response.body);
          if (json.isNotEmpty) {
            print(
              '✅ Found working endpoint (${i + 1}/${endpoints.length}): $endpoint',
            );
            return json;
          } else {
            print('⚠️ Could not parse JSON from endpoint: $endpoint');
            continue;
          }
        } else if (response.statusCode == 401) {
          throw const AuthenticationException('Authentication failed');
        } else if (response.statusCode == 404) {
          print('⚠️ Endpoint $endpoint not found (404), trying next...');
          continue;
        } else if (response.statusCode == 403) {
          print('⚠️ Access forbidden (403) for endpoint $endpoint');
          continue;
        } else if (response.statusCode >= 500) {
          print(
            '⚠️ Server error (${response.statusCode}) for endpoint $endpoint',
          );
          continue;
        } else {
          print('⚠️ HTTP ${response.statusCode} for endpoint $endpoint');
          continue;
        }
      } catch (e) {
        lastError = e as Exception;
        print('❌ Error with endpoint $endpoint: $e');
        continue;
      }
    }

    if (lastError != null) {
      throw lastError;
    }

    throw AllEndpointsFailedException(
      'Could not connect to Kickbase API. All endpoints failed.',
      attemptedEndpoints: endpoints,
    );
  }

  /// Make request with exponential backoff retry logic
  Future<http.Response> _makeRequestWithRetry({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? body,
    int retryCount = 0,
  }) async {
    try {
      final response = await _makeRequest(
        endpoint: endpoint,
        method: method,
        body: body,
      );

      // Retry on 5xx server errors
      if (response.statusCode >= 500 && retryCount < _maxRetries) {
        final delay =
            _initialRetryDelay * (1 << retryCount); // Exponential backoff
        print(
          '⏳ Retrying request in ${delay.inMilliseconds}ms (attempt ${retryCount + 1}/$_maxRetries)',
        );
        await Future.delayed(delay);
        return _makeRequestWithRetry(
          endpoint: endpoint,
          method: method,
          body: body,
          retryCount: retryCount + 1,
        );
      }

      return response;
    } catch (e) {
      // Retry on network errors
      if (e is NetworkException && retryCount < _maxRetries) {
        final delay = _initialRetryDelay * (1 << retryCount);
        print(
          '⏳ Retrying after network error in ${delay.inMilliseconds}ms (attempt ${retryCount + 1}/$_maxRetries)',
        );
        await Future.delayed(delay);
        return _makeRequestWithRetry(
          endpoint: endpoint,
          method: method,
          body: body,
          retryCount: retryCount + 1,
        );
      }
      rethrow;
    }
  }

  // MARK: - Response Processing

  /// Parse and handle HTTP response
  T _processResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    // Handle error status codes
    if (response.statusCode == 401) {
      throw const AuthenticationException(
        'Authentication failed. Token may be expired.',
      );
    } else if (response.statusCode == 404) {
      throw NotFoundException(
        'Resource not found',
        originalError: response.body,
      );
    } else if (response.statusCode == 429) {
      final retryAfter = response.headers['retry-after'];
      throw RateLimitException(
        'Rate limit exceeded',
        retryAfterSeconds: retryAfter != null ? int.tryParse(retryAfter) : null,
      );
    } else if (response.statusCode >= 500) {
      throw ServerException(
        'Server error occurred',
        statusCode: response.statusCode,
        originalError: response.body,
      );
    } else if (response.statusCode != 200) {
      throw KickbaseException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        code: response.statusCode.toString(),
        originalError: response.body,
      );
    }

    // Parse JSON response
    try {
      final json = _parseJson(response.body);
      return fromJson(json);
    } catch (e) {
      throw ParsingException(
        'Failed to parse response: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Parse JSON string to Map
  Map<String, dynamic> _parseJson(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'data': decoded};
    } catch (e) {
      throw ParsingException('Invalid JSON format', originalError: e);
    }
  }

  // MARK: - Network Testing

  /// Test network connectivity
  Future<bool> testNetworkConnectivity() async {
    print('🌐 Testing network connectivity...');

    try {
      final url = Uri.parse(_baseUrl);
      final response = await _httpClient
          .head(url)
          .timeout(const Duration(seconds: 5));

      print('✅ Network test successful - Status: ${response.statusCode}');
      return true;
    } catch (e) {
      print('❌ Network test failed: $e');
      return false;
    }
  }

  // MARK: - Authentication

  /// Login with Kickbase credentials
  /// POST /v4/user/login
  ///
  /// Authenticates the user with Kickbase API and stores the token.
  /// After successful login, the token is automatically stored in secure storage
  /// and will be used for all subsequent API requests.
  ///
  /// Returns [LoginResponse] containing the auth token and user data.
  /// Throws [AuthenticationException] if credentials are invalid.
  /// Throws [NetworkException] if connection fails.
  Future<LoginResponse> login(String email, String password) async {
    print('🔐 Attempting Kickbase login for: $email');

    final request = LoginRequest(
      em: email,
      pass: password,
      loy: false,
      rep: {},
    );

    try {
      final response = await _makeRequest(
        endpoint: '/$_apiVersion/user/login',
        method: 'POST',
        body: request.toJson(),
        requiresAuth: false, // Login doesn't require existing token
      );

      // Check for success status
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = _parseJson(response.body);
        final loginResponse = LoginResponse.fromJson(json);

        // Store token for future requests
        await setAuthToken(loginResponse.tkn);
        print('✅ Login successful - Token stored');

        return loginResponse;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const AuthenticationException(
          'Ungültige E-Mail oder Passwort. Bitte überprüfen Sie Ihre Kickbase-Zugangsdaten.',
        );
      } else if (response.statusCode == 429) {
        throw const RateLimitException(
          'Zu viele Login-Versuche. Bitte warten Sie einen Moment.',
        );
      } else {
        throw KickbaseException(
          'Login fehlgeschlagen: HTTP ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on AuthenticationException {
      rethrow;
    } on RateLimitException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      print('❌ Login error: $e');
      throw KickbaseException(
        'Login fehlgeschlagen: ${e.toString()}',
        originalError: e,
      );
    }
  }

  // MARK: - API Methods

  /// Get current user info
  /// GET /v4/user
  Future<User> getUser() async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/user',
      method: 'GET',
    );

    return _processResponse(response, User.fromJson);
  }

  /// Get all leagues
  /// GET /v4/leagues/selection
  Future<List<League>> getLeagues() async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/selection',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    // Some endpoints use 'it', others 'leagues'
    final leaguesData =
        json['it'] as List<dynamic>? ?? json['leagues'] as List<dynamic>?;

    if (leaguesData == null) {
      throw const ParsingException('No leagues data in response');
    }

    print('🔍 Parsing ${leaguesData.length} leagues...');
    try {
      final leagues = leaguesData
          .map(
            (e) =>
                League.fromJson(normalizeLeagueJson(e as Map<String, dynamic>)),
          )
          .toList();
      print('✅ Successfully parsed ${leagues.length} leagues');
      return leagues;
    } catch (e, stack) {
      print('❌ Error parsing leagues: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }

  /// Get league details
  /// GET /v4/leagues/{leagueId}/overview
  Future<League> getLeague(String leagueId) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/overview',
      method: 'GET',
    );

    return _processResponse(
      response,
      (json) => League.fromJson(normalizeLeagueJson(json)),
    );
  }

  /// Get all players in a league
  /// GET /v4/leagues/{leagueId}/players
  Future<List<Player>> getLeaguePlayers(String leagueId) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    final playersData = json['players'] as List<dynamic>?;

    if (playersData == null) {
      throw const ParsingException('No players data in response');
    }

    return playersData
        .map(
          (e) =>
              Player.fromJson(normalizePlayerJson(e as Map<String, dynamic>)),
        )
        .toList();
  }

  /// Get current lineup
  /// GET /v4/leagues/{leagueId}/lineup
  Future<LineupResponse> getLineup(String leagueId) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/lineup',
      method: 'GET',
    );

    return _processResponse(response, LineupResponse.fromJson);
  }

  /// Update lineup
  /// POST /v4/leagues/{leagueId}/lineup
  Future<void> updateLineup(String leagueId, LineupUpdateRequest lineup) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/lineup',
      method: 'POST',
      body: {'playerIds': lineup.playerIds},
    );

    if (response.statusCode != 200) {
      throw KickbaseException(
        'Failed to update lineup: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
  }

  /// Get available players on market
  /// GET /v4/leagues/{leagueId}/market
  Future<List<MarketPlayer>> getMarketAvailable(String leagueId) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    final playersData = json['players'] as List<dynamic>?;

    if (playersData == null) {
      throw const ParsingException('No market players data in response');
    }

    return playersData
        .map((e) => MarketPlayer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Buy player from market
  /// POST /v4/leagues/{leagueId}/market/{playerId}/offers
  Future<BidResponse> buyPlayer(
    String leagueId,
    String playerId,
    int price,
  ) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId/offers',
      method: 'POST',
      body: {'price': price},
    );

    return _processResponse(response, BidResponse.fromJson);
  }

  /// Sell player to market
  /// POST /v4/leagues/{leagueId}/market
  Future<BidResponse> sellPlayer(
    String leagueId,
    String playerId,
    int price,
  ) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market',
      method: 'POST',
      body: {'playerId': playerId, 'price': price},
    );

    return _processResponse(response, BidResponse.fromJson);
  }

  /// Get player statistics/performance
  /// GET /v4/leagues/{leagueId}/players/{playerId}/performance
  Future<PlayerPerformanceResponse> getPlayerStats(
    String leagueId,
    String playerId,
  ) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId/performance',
      method: 'GET',
    );

    return _processResponse(response, PlayerPerformanceResponse.fromJson);
  }

  /// Get transfers for a user
  /// GET /v4/leagues/{leagueId}/managers/{userId}/transfer
  Future<List<Transfer>> getTransfers(String leagueId, String userId) async {
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/transfer',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    final transfersData = json['transfers'] as List<dynamic>?;

    if (transfersData == null) {
      throw const ParsingException('No transfers data in response');
    }

    return transfersData
        .map((e) => Transfer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // MARK: - Schritt 1: Liga & User Endpoints

  /// Get user settings
  /// GET /v4/user/settings
  Future<Map<String, dynamic>> getUserSettings() async {
    print('⚙️ Getting user settings...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/user/settings',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ User settings retrieved');
    return json;
  }

  /// Get league me (own stats in league)
  /// GET /v4/leagues/{leagueId}/me
  Future<Map<String, dynamic>> getLeagueMe(String leagueId) async {
    print('👤 Getting league me for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/me',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ League me retrieved');
    return json;
  }

  /// Get my budget in league
  /// GET /v4/leagues/{leagueId}/me/budget
  Future<Map<String, dynamic>> getMyBudget(String leagueId) async {
    print('💰 Getting budget for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/me/budget',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Budget retrieved');
    return json;
  }

  /// Get my squad (own players)
  /// GET /v4/leagues/{leagueId}/squad
  Future<Map<String, dynamic>> getMySquad(String leagueId) async {
    print('👥 Getting squad for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/squad',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Squad retrieved (${(json['it'] as List?)?.length ?? 0} players)');
    return json;
  }

  /// Get league ranking
  /// GET /v4/leagues/{leagueId}/ranking
  Future<Map<String, dynamic>> getLeagueRanking(
    String leagueId, {
    int? matchDay,
  }) async {
    final dayParam = matchDay != null ? '?dayNumber=$matchDay' : '';
    print('🏆 Getting league ranking for league $leagueId$dayParam...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/ranking$dayParam',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ League ranking retrieved');
    return json;
  }

  /// Collect daily bonus
  /// GET /v4/bonus/collect
  Future<Map<String, dynamic>> collectBonus() async {
    print('🎁 Collecting daily bonus...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/bonus/collect',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Bonus collected!');
    return json;
  }

  // MARK: - Schritt 2: Spieler-Detail-Endpoints

  /// Get player details
  /// GET /v4/leagues/{leagueId}/players/{playerId}
  Future<Map<String, dynamic>> getPlayerDetails(
    String leagueId,
    String playerId,
  ) async {
    print('⚽ Getting player details for player $playerId in league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Player details retrieved');
    return json;
  }

  /// Get player market value history
  /// GET /v4/leagues/{leagueId}/players/{playerId}/marketvalue/{timeframe}
  Future<Map<String, dynamic>> getPlayerMarketValue(
    String leagueId,
    String playerId, {
    int timeframe = 365,
  }) async {
    print('📈 Getting market value for player $playerId (timeframe: $timeframe days)...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId/marketvalue/$timeframe',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Market value history retrieved');
    return json;
  }

  /// Get player transfer history
  /// GET /v4/leagues/{leagueId}/players/{playerId}/transferHistory
  Future<Map<String, dynamic>> getPlayerTransferHistory(
    String leagueId,
    String playerId, {
    int? matchDay,
  }) async {
    final dayParam = matchDay != null ? '?matchDay=$matchDay' : '';
    print('🔄 Getting transfer history for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId/transferHistory$dayParam',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Transfer history retrieved');
    return json;
  }

  /// Get player transfers
  /// GET /v4/leagues/{leagueId}/players/{playerId}/transfers
  Future<Map<String, dynamic>> getPlayerTransfers(
    String leagueId,
    String playerId,
  ) async {
    print('🔄 Getting transfers for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId/transfers',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Player transfers retrieved');
    return json;
  }

  // MARK: - Schritt 3: Manager & Transfermarkt-Endpoints

  /// Get manager dashboard
  /// GET /v4/leagues/{leagueId}/managers/{userId}/dashboard
  Future<Map<String, dynamic>> getManagerDashboard(
    String leagueId,
    String userId,
  ) async {
    print('📊 Getting manager dashboard for user $userId in league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/dashboard',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Manager dashboard retrieved');
    return json;
  }

  /// Get manager performance
  /// GET /v4/leagues/{leagueId}/managers/{userId}/performance
  Future<Map<String, dynamic>> getManagerPerformance(
    String leagueId,
    String userId,
  ) async {
    print('📈 Getting manager performance for user $userId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/performance',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Manager performance retrieved');
    return json;
  }

  /// Get manager squad
  /// GET /v4/leagues/{leagueId}/managers/{userId}/squad
  Future<Map<String, dynamic>> getManagerSquad(
    String leagueId,
    String userId,
  ) async {
    print('👥 Getting manager squad for user $userId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/squad',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Manager squad retrieved');
    return json;
  }

  /// Remove player from market
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}
  Future<Map<String, dynamic>> removePlayerFromMarket(
    String leagueId,
    String playerId,
  ) async {
    print('🔻 Removing player $playerId from market...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId',
      method: 'DELETE',
    );

    final json = _parseJson(response.body);
    print('✅ Player removed from market');
    return json;
  }

  /// Withdraw offer
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}
  Future<Map<String, dynamic>> withdrawOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    print('↩️ Withdrawing offer $offerId for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId/offers/$offerId',
      method: 'DELETE',
    );

    final json = _parseJson(response.body);
    print('✅ Offer withdrawn');
    return json;
  }

  /// Accept offer
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/accept
  Future<void> acceptOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    print('✅ Accepting offer $offerId for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId/offers/$offerId/accept',
      method: 'DELETE',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to accept offer: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    print('✅ Offer accepted');
  }

  /// Decline offer
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/decline
  Future<void> declineOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    print('❌ Declining offer $offerId for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId/offers/$offerId/decline',
      method: 'DELETE',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to decline offer: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    print('✅ Offer declined');
  }

  /// Accept Kickbase offer (sell to Kickbase)
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/sell
  Future<void> acceptKickbaseOffer(
    String leagueId,
    String playerId,
  ) async {
    print('💵 Selling player $playerId to Kickbase...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId/sell',
      method: 'DELETE',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to sell player to Kickbase: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    print('✅ Player sold to Kickbase');
  }

  // MARK: - Schritt 4: Live, Beobachtungsliste & Wettbewerb

  /// Get my eleven (live lineup)
  /// GET /v4/leagues/{leagueId}/teamcenter/myeleven
  Future<Map<String, dynamic>> getMyEleven(String leagueId) async {
    print('⚽ Getting my eleven for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/teamcenter/myeleven',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ My eleven retrieved');
    return json;
  }

  /// Get live event types
  /// GET /v4/live/eventtypes
  Future<Map<String, dynamic>> getLiveEventTypes() async {
    print('📺 Getting live event types...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/live/eventtypes',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Live event types retrieved');
    return json;
  }

  /// Get scouted players (watchlist)
  /// GET /v4/leagues/{leagueId}/scoutedplayers
  Future<Map<String, dynamic>> getScoutedPlayers(String leagueId) async {
    print('🔭 Getting scouted players for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/scoutedplayers',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Scouted players retrieved');
    return json;
  }

  /// Add scouted player (add to watchlist)
  /// POST /v4/leagues/{leagueId}/scoutedplayers/{playerId}
  Future<void> addScoutedPlayer(String leagueId, String playerId) async {
    print('➕ Adding player $playerId to watchlist...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/scoutedplayers/$playerId',
      method: 'POST',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to add scouted player: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    print('✅ Player added to watchlist');
  }

  /// Remove scouted player (remove from watchlist)
  /// DELETE /v4/leagues/{leagueId}/scoutedplayers/{playerId}
  Future<void> removeScoutedPlayer(String leagueId, String playerId) async {
    print('➖ Removing player $playerId from watchlist...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/scoutedplayers/$playerId',
      method: 'DELETE',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to remove scouted player: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    print('✅ Player removed from watchlist');
  }

  /// Get competition table (e.g., Bundesliga table)
  /// GET /v4/competitions/{competitionId}/table
  Future<Map<String, dynamic>> getCompetitionTable(String competitionId) async {
    print('🏆 Getting competition table for competition $competitionId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/competitions/$competitionId/table',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Competition table retrieved');
    return json;
  }

  /// Get competition matchdays
  /// GET /v4/competitions/{competitionId}/matchdays
  Future<Map<String, dynamic>> getCompetitionMatchdays(
    String competitionId,
  ) async {
    print('📅 Getting matchdays for competition $competitionId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/competitions/$competitionId/matchdays',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Competition matchdays retrieved');
    return json;
  }

  /// Get player event history (match details)
  /// GET /v4/competitions/{competitionId}/playercenter/{playerId}
  Future<Map<String, dynamic>> getPlayerEventHistory(
    String competitionId,
    String playerId, {
    int? matchDay,
  }) async {
    final dayParam = matchDay != null ? '?day=$matchDay' : '';
    print('📊 Getting event history for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/competitions/$competitionId/playercenter/$playerId$dayParam',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    print('✅ Player event history retrieved');
    return json;
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
