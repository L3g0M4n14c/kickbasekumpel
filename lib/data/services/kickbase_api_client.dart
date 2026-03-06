import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
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
  final Logger _logger = Logger();

  String? _cachedToken;

  KickbaseAPIClient({http.Client? httpClient, TokenStorage? tokenStorage})
    : _httpClient = httpClient ?? http.Client(),
      _tokenStorage = tokenStorage ?? SharedPreferencesTokenStorage();

  // MARK: - Token Management

  /// Set authentication token
  Future<void> setAuthToken(String token) async {
    _cachedToken = token;
    await _tokenStorage.setToken(token);
    _logger.d('🔑 Auth token saved');
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
    _logger.i('🗑️ Auth token and user data cleared');
  }

  /// Save user data
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(user.toJson()));
    _logger.i('💾 User data saved');
  }

  /// Get saved user data
  Future<User?> getSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userDataKey);
    if (userData != null) {
      try {
        return User.fromJson(jsonDecode(userData));
      } catch (e) {
        _logger.w('⚠️ Error loading user data: $e');
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

    _logger.d('📤 Making $method request to: $url');

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

    _logger.d('📊 Response Status Code: ${response.statusCode}');
    if (response.body.isNotEmpty) {
      final preview = response.body.length > 500
          ? '${response.body.substring(0, 500)}...'
          : response.body;
      _logger.d('📥 Response: $preview');
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
            _logger.d(
              '✅ Found working endpoint (${i + 1}/${endpoints.length}): $endpoint',
            );
            return json;
          } else {
            _logger.w('⚠️ Could not parse JSON from endpoint: $endpoint');
            continue;
          }
        } else if (response.statusCode == 401) {
          throw const AuthenticationException('Authentication failed');
        } else if (response.statusCode == 404) {
          _logger.w('⚠️ Endpoint $endpoint not found (404), trying next...');
          continue;
        } else if (response.statusCode == 403) {
          _logger.w('⚠️ Access forbidden (403) for endpoint $endpoint');
          continue;
        } else if (response.statusCode >= 500) {
          _logger.w(
            '⚠️ Server error (${response.statusCode}) for endpoint $endpoint',
          );
          continue;
        } else {
          _logger.w('⚠️ HTTP ${response.statusCode} for endpoint $endpoint');
          continue;
        }
      } catch (e) {
        lastError = e as Exception;
        _logger.e('❌ Error with endpoint $endpoint: $e');
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

      // Handle authentication/authorization errors immediately (no retry)
      if (response.statusCode == 401) {
        throw const AuthenticationException(
          'Authentication failed. Token may be expired.',
        );
      } else if (response.statusCode == 403) {
        throw const AuthorizationException(
          'Access forbidden. Your token may be revoked or you lack permissions.',
        );
      }

      // Retry on 5xx server errors
      if (response.statusCode >= 500 && retryCount < _maxRetries) {
        final delay =
            _initialRetryDelay * (1 << retryCount); // Exponential backoff
        _logger.w(
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
      // Don't retry authentication/authorization errors
      if (e is AuthenticationException || e is AuthorizationException) {
        rethrow;
      }

      // Retry on network errors
      if (e is NetworkException && retryCount < _maxRetries) {
        final delay = _initialRetryDelay * (1 << retryCount);
        _logger.w(
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
    } else if (response.statusCode == 403) {
      throw const AuthorizationException(
        'Access forbidden. Your token may be revoked or you lack permissions for this endpoint.',
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
    _logger.d('🌐 Testing network connectivity...');

    try {
      final url = Uri.parse(_baseUrl);
      final response = await _httpClient
          .head(url)
          .timeout(const Duration(seconds: 5));

      _logger.i('✅ Network test successful - Status: ${response.statusCode}');
      return true;
    } catch (e) {
      _logger.e('❌ Network test failed: $e');
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
    _logger.i('🔐 Attempting Kickbase login for: $email');

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
        _logger.i('✅ Login successful - Token stored');

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
      _logger.e('❌ Login error: $e');
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

    _logger.d('🔍 Parsing ${leaguesData.length} leagues...');
    try {
      final leagues = leaguesData
          .map(
            (e) =>
                League.fromJson(normalizeLeagueJson(e as Map<String, dynamic>)),
          )
          .toList();
      _logger.i('✅ Successfully parsed ${leagues.length} leagues');
      return leagues;
    } catch (e, stack) {
      _logger.e('❌ Error parsing leagues: $e');
      _logger.e('Stack trace: $stack');
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

  /// Get all players relevant for a league (squad + market).
  ///
  /// Kombiniert:
  ///   GET /v4/leagues/{leagueId}/squad  → eigene Spieler (Response-Key 'it')
  ///   GET /v4/leagues/{leagueId}/market → Markt-Spieler  (Response-Key 'it')
  ///
  /// Squad-Spieler erhalten [userOwnsPlayer] = true,
  /// Markt-Spieler erhalten [userOwnsPlayer] = false.
  Future<List<Player>> getLeaguePlayers(String leagueId) async {
    final squadResponse = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/squad',
      method: 'GET',
    );
    final marketResponse = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market',
      method: 'GET',
    );

    final List<Player> players = [];

    // 1. Eigene Spieler (squad)
    if (squadResponse.statusCode == 200) {
      final squadJson = _parseJson(squadResponse.body);
      final squadData = squadJson['it'] as List<dynamic>? ?? [];
      for (final e in squadData) {
        try {
          final raw = Map<String, dynamic>.from(e as Map<String, dynamic>);
          raw['userOwnsPlayer'] = true;
          players.add(Player.fromJson(normalizePlayerJson(raw)));
        } catch (err) {
          _logger.w('⚠️ Skipping unparseable squad player: $err | raw: $e');
        }
      }
      _logger.i('✅ Squad: ${squadData.length} eigene Spieler geladen');
    } else {
      _logger.w('⚠️ Squad-Endpoint HTTP ${squadResponse.statusCode}');
    }

    // 2. Markt-Spieler (market)
    if (marketResponse.statusCode == 200) {
      final marketJson = _parseJson(marketResponse.body);
      final marketData = marketJson['it'] as List<dynamic>? ?? [];
      for (final e in marketData) {
        try {
          final raw = Map<String, dynamic>.from(e as Map<String, dynamic>);
          raw['userOwnsPlayer'] = false;
          players.add(Player.fromJson(normalizePlayerJson(raw)));
        } catch (err) {
          _logger.w('⚠️ Skipping unparseable market player: $err | raw: $e');
        }
      }
      _logger.i('✅ Market: ${marketData.length} Markt-Spieler geladen');
    } else {
      _logger.w('⚠️ Market-Endpoint HTTP ${marketResponse.statusCode}');
    }

    if (players.isEmpty) {
      throw const ParsingException(
        'Keine Spielerdaten in /squad und /market gefunden',
      );
    }

    _logger.i('✅ getLeaguePlayers: ${players.length} Spieler gesamt');
    return players;
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
    _logger.i('📦 Getting available market players for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market',
      method: 'GET',
    );

    // At this point, response.statusCode is guaranteed to be 200 or other non-auth error
    // because _makeRequestWithRetry throws on 401/403
    if (response.statusCode != 200) {
      throw KickbaseException(
        'Failed to load market players: HTTP ${response.statusCode}',
        code: response.statusCode.toString(),
        originalError: response.body,
      );
    }

    final json = _parseJson(response.body);
    // API returns market players under key 'it' (not 'players')
    final playersData =
        json['it'] as List<dynamic>? ?? json['players'] as List<dynamic>?;

    if (playersData == null) {
      _logger.w('⚠️ Market response keys: ${json.keys.toList()}');
      // Empty market is valid – return empty list instead of throwing
      return [];
    }

    _logger.i('✅ Found ${playersData.length} market players');
    return playersData
        .map((e) {
          try {
            final normalized = normalizeMarketPlayerJson(
              e as Map<String, dynamic>,
            );
            return MarketPlayer.fromJson(normalized);
          } catch (err) {
            _logger.w('⚠️ Skipping unparseable market player: $err | raw: $e');
            return null;
          }
        })
        .whereType<MarketPlayer>()
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
    _logger.i('⚙️ Getting user settings...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/user/settings',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ User settings retrieved');
    return json;
  }

  /// Get league me (own stats in league)
  /// GET /v4/leagues/{leagueId}/me
  Future<Map<String, dynamic>> getLeagueMe(String leagueId) async {
    _logger.i('👤 Getting league me for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/me',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ League me retrieved');
    return json;
  }

  /// Get my budget in league
  /// GET /v4/leagues/{leagueId}/me/budget
  Future<Map<String, dynamic>> getMyBudget(String leagueId) async {
    _logger.i('💰 Getting budget for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/me/budget',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Budget retrieved');
    return json;
  }

  /// Get my squad (own players)
  /// GET /v4/leagues/{leagueId}/squad
  Future<Map<String, dynamic>> getMySquad(String leagueId) async {
    _logger.i('👥 Getting squad for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/squad',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i(
      '✅ Squad retrieved (${(json['it'] as List?)?.length ?? 0} players)',
    );
    return json;
  }

  /// Get league ranking
  /// GET /v4/leagues/{leagueId}/ranking
  Future<Map<String, dynamic>> getLeagueRanking(
    String leagueId, {
    int? matchDay,
  }) async {
    final dayParam = matchDay != null ? '?dayNumber=$matchDay' : '';
    _logger.i('🏆 Getting league ranking for league $leagueId$dayParam...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/ranking$dayParam',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ League ranking retrieved');
    return json;
  }

  /// Collect daily bonus
  /// GET /v4/bonus/collect
  Future<Map<String, dynamic>> collectBonus() async {
    _logger.i('🎁 Collecting daily bonus...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/bonus/collect',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Bonus collected!');
    return json;
  }

  // MARK: - Schritt 2: Spieler-Detail-Endpoints

  /// Get player details
  /// GET /v4/leagues/{leagueId}/players/{playerId}
  Future<Map<String, dynamic>> getPlayerDetails(
    String leagueId,
    String playerId,
  ) async {
    _logger.i(
      '⚽ Getting player details for player $playerId in league $leagueId...',
    );
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Player details retrieved');
    return json;
  }

  /// Get player market value history
  /// GET /v4/leagues/{leagueId}/players/{playerId}/marketvalue/{timeframe}
  Future<Map<String, dynamic>> getPlayerMarketValue(
    String leagueId,
    String playerId, {
    int timeframe = 365,
  }) async {
    _logger.i(
      '📈 Getting market value for player $playerId (timeframe: $timeframe days)...',
    );
    final response = await _makeRequestWithRetry(
      endpoint:
          '/$_apiVersion/leagues/$leagueId/players/$playerId/marketvalue/$timeframe',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Market value history retrieved');
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
    _logger.i('🔄 Getting transfer history for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint:
          '/$_apiVersion/leagues/$leagueId/players/$playerId/transferHistory$dayParam',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Transfer history retrieved');
    return json;
  }

  /// Get player transfers
  /// GET /v4/leagues/{leagueId}/players/{playerId}/transfers
  Future<Map<String, dynamic>> getPlayerTransfers(
    String leagueId,
    String playerId,
  ) async {
    _logger.i('🔄 Getting transfers for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/players/$playerId/transfers',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Player transfers retrieved');
    return json;
  }

  // MARK: - Schritt 3: Manager & Transfermarkt-Endpoints

  /// Get manager dashboard
  /// GET /v4/leagues/{leagueId}/managers/{userId}/dashboard
  Future<Map<String, dynamic>> getManagerDashboard(
    String leagueId,
    String userId,
  ) async {
    _logger.i(
      '📊 Getting manager dashboard for user $userId in league $leagueId...',
    );
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/dashboard',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Manager dashboard retrieved');
    return json;
  }

  /// Get manager performance
  /// GET /v4/leagues/{leagueId}/managers/{userId}/performance
  Future<Map<String, dynamic>> getManagerPerformance(
    String leagueId,
    String userId,
  ) async {
    _logger.i('📈 Getting manager performance for user $userId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/performance',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Manager performance retrieved');
    return json;
  }

  /// Get manager squad
  /// GET /v4/leagues/{leagueId}/managers/{userId}/squad
  Future<Map<String, dynamic>> getManagerSquad(
    String leagueId,
    String userId,
  ) async {
    _logger.i('👥 Getting manager squad for user $userId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/managers/$userId/squad',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Manager squad retrieved');
    return json;
  }

  /// Remove player from market
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}
  Future<Map<String, dynamic>> removePlayerFromMarket(
    String leagueId,
    String playerId,
  ) async {
    _logger.i('🔻 Removing player $playerId from market...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/market/$playerId',
      method: 'DELETE',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Player removed from market');
    return json;
  }

  /// Withdraw offer
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}
  Future<Map<String, dynamic>> withdrawOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    _logger.i('↩️ Withdrawing offer $offerId for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint:
          '/$_apiVersion/leagues/$leagueId/market/$playerId/offers/$offerId',
      method: 'DELETE',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Offer withdrawn');
    return json;
  }

  /// Accept offer
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/accept
  Future<void> acceptOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    _logger.d('✅ Accepting offer $offerId for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint:
          '/$_apiVersion/leagues/$leagueId/market/$playerId/offers/$offerId/accept',
      method: 'DELETE',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to accept offer: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    _logger.i('✅ Offer accepted');
  }

  /// Decline offer
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/offers/{offerId}/decline
  Future<void> declineOffer(
    String leagueId,
    String playerId,
    String offerId,
  ) async {
    _logger.w('❌ Declining offer $offerId for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint:
          '/$_apiVersion/leagues/$leagueId/market/$playerId/offers/$offerId/decline',
      method: 'DELETE',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KickbaseException(
        'Failed to decline offer: ${response.statusCode}',
        code: response.statusCode.toString(),
      );
    }
    _logger.i('✅ Offer declined');
  }

  /// Accept Kickbase offer (sell to Kickbase)
  /// DELETE /v4/leagues/{leagueId}/market/{playerId}/sell
  Future<void> acceptKickbaseOffer(String leagueId, String playerId) async {
    _logger.i('💵 Selling player $playerId to Kickbase...');
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
    _logger.i('✅ Player sold to Kickbase');
  }

  // MARK: - Schritt 4: Live, Beobachtungsliste & Wettbewerb

  /// Get my eleven (live lineup)
  /// GET /v4/leagues/{leagueId}/teamcenter/myeleven
  Future<Map<String, dynamic>> getMyEleven(String leagueId) async {
    _logger.i('⚽ Getting my eleven for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/teamcenter/myeleven',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ My eleven retrieved');
    return json;
  }

  /// Get live event types
  /// GET /v4/live/eventtypes
  Future<Map<String, dynamic>> getLiveEventTypes() async {
    _logger.d('📺 Getting live event types...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/live/eventtypes',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Live event types retrieved');
    return json;
  }

  /// Get scouted players (watchlist)
  /// GET /v4/leagues/{leagueId}/scoutedplayers
  Future<Map<String, dynamic>> getScoutedPlayers(String leagueId) async {
    _logger.d('🔭 Getting scouted players for league $leagueId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/leagues/$leagueId/scoutedplayers',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Scouted players retrieved');
    return json;
  }

  /// Add scouted player (add to watchlist)
  /// POST /v4/leagues/{leagueId}/scoutedplayers/{playerId}
  Future<void> addScoutedPlayer(String leagueId, String playerId) async {
    _logger.i('➕ Adding player $playerId to watchlist...');
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
    _logger.i('✅ Player added to watchlist');
  }

  /// Remove scouted player (remove from watchlist)
  /// DELETE /v4/leagues/{leagueId}/scoutedplayers/{playerId}
  Future<void> removeScoutedPlayer(String leagueId, String playerId) async {
    _logger.i('➖ Removing player $playerId from watchlist...');
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
    _logger.i('✅ Player removed from watchlist');
  }

  /// Get competition table (e.g., Bundesliga table)
  /// GET /v4/competitions/{competitionId}/table
  Future<Map<String, dynamic>> getCompetitionTable(String competitionId) async {
    _logger.i('🏆 Getting competition table for competition $competitionId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/competitions/$competitionId/table',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Competition table retrieved');
    return json;
  }

  /// Get competition matchdays
  /// GET /v4/competitions/{competitionId}/matchdays
  Future<Map<String, dynamic>> getCompetitionMatchdays(
    String competitionId,
  ) async {
    _logger.i('📅 Getting matchdays for competition $competitionId...');
    final response = await _makeRequestWithRetry(
      endpoint: '/$_apiVersion/competitions/$competitionId/matchdays',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Competition matchdays retrieved');
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
    _logger.i('📊 Getting event history for player $playerId...');
    final response = await _makeRequestWithRetry(
      endpoint:
          '/$_apiVersion/competitions/$competitionId/playercenter/$playerId$dayParam',
      method: 'GET',
    );

    final json = _parseJson(response.body);
    _logger.i('✅ Player event history retrieved');
    return json;
  }

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }
}
