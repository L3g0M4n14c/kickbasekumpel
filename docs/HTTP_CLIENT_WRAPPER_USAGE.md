# HTTP Client Wrapper - Usage Examples

## Übersicht

Der `HttpClientWrapper` ist ein generischer HTTP-Client für konsistente Fehlerbehandlung, automatisches Retry und strukturiertes Logging in der KickbaseKumpel App.

## Features

✅ **Exponential Backoff Retry** (1s → 2s → 4s)  
✅ **Automatisches Error Mapping** zu benutzerdefinierten Exceptions  
✅ **Request Timeout Handling** (Standard: 30s)  
✅ **Strukturiertes Logging** (Request, Response, Error)  
✅ **Riverpod Integration** für Dependency Injection  
✅ **Generic Parser** für flexible Response-Verarbeitung  

---

## Basic Usage

### 1. GET Request

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/http_client_wrapper_provider.dart';

class UserRepository {
  final HttpClientWrapper _httpClient;

  UserRepository(this._httpClient);

  Future<User> getUser(String userId) async {
    return _httpClient.get(
      'https://api.kickbase.com/users/$userId',
      headers: {'Authorization': 'Bearer $token'},
      parser: (response) => User.fromJson(jsonDecode(response.body)),
    );
  }
}

// Riverpod Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final httpClient = ref.watch(httpClientWrapperProvider);
  return UserRepository(httpClient);
});
```

### 2. POST Request

```dart
Future<League> createLeague(LeagueRequest request) async {
  return _httpClient.post(
    'https://api.kickbase.com/leagues',
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(request.toJson()),
    parser: (response) => League.fromJson(jsonDecode(response.body)),
  );
}
```

### 3. PUT Request

```dart
Future<Player> updatePlayer(String playerId, PlayerUpdate update) async {
  return _httpClient.put(
    'https://api.kickbase.com/players/$playerId',
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(update.toJson()),
    parser: (response) => Player.fromJson(jsonDecode(response.body)),
  );
}
```

### 4. DELETE Request

```dart
Future<void> deletePlayer(String playerId) async {
  return _httpClient.delete(
    'https://api.kickbase.com/players/$playerId',
    headers: {'Authorization': 'Bearer $token'},
    parser: (response) => null, // No response body
  );
}
```

---

## Error Handling

### Automatisches Error Mapping

Der Wrapper mappt HTTP Status Codes automatisch zu benutzerdefinierten Exceptions:

| Status Code | Exception | Retry? |
|-------------|-----------|--------|
| 401 | `AuthenticationException` | ❌ No |
| 404 | `NotFoundException` | ❌ No |
| 429 | `RateLimitException` | ✅ Yes (2x delay) |
| 400-499 | `KickbaseException` | ❌ No |
| 500-599 | `ServerException` | ✅ Yes |
| Timeout | `TimeoutException` | ✅ Yes |
| Network | `NetworkException` | ✅ Yes |

### Error Handling Example

```dart
try {
  final user = await _httpClient.get(
    'https://api.kickbase.com/users/123',
    parser: (response) => User.fromJson(jsonDecode(response.body)),
  );
  return user;
} on AuthenticationException catch (e) {
  // Token expired - redirect to login
  print('Auth failed: ${e.message}');
  throw e;
} on NotFoundException catch (e) {
  // User not found - show error message
  print('User not found: ${e.message}');
  return null;
} on RateLimitException catch (e) {
  // Rate limit hit - wait and retry
  print('Rate limited: ${e.message}');
  if (e.retryAfterSeconds != null) {
    await Future.delayed(Duration(seconds: e.retryAfterSeconds!));
    return getUser(userId); // Retry manually
  }
} on ServerException catch (e) {
  // Server error - show generic error
  print('Server error [${e.statusCode}]: ${e.message}');
  throw e;
} on NetworkException catch (e) {
  // No internet - show offline message
  print('Network error: ${e.message}');
  throw e;
} on TimeoutException catch (e) {
  // Request timed out
  print('Timeout: ${e.message}');
  throw e;
}
```

---

## Retry Strategy

### Automatisches Retry für:
- ✅ **5xx Server Errors** (500-599)
- ✅ **Network Errors** (SocketException)
- ✅ **Timeouts** (TimeoutException)
- ✅ **Rate Limits** (429) mit 2x Delay

### Kein Retry für:
- ❌ **4xx Client Errors** (außer 429)
- ❌ **Authentication Errors** (401)
- ❌ **Not Found** (404)

### Exponential Backoff

```
Attempt 1: Sofort
Attempt 2: Nach 1s  (2^0 * 1s)
Attempt 3: Nach 2s  (2^1 * 1s)
Attempt 4: Nach 4s  (2^2 * 1s)
```

### Custom Retry Configuration

```dart
final customWrapper = HttpClientWrapper(
  httpClient: http.Client(),
  timeout: const Duration(seconds: 60),  // 60s timeout
  maxRetries: 5,                          // 5 attempts
  initialRetryDelay: const Duration(milliseconds: 500),  // 500ms initial delay
);
```

---

## Advanced Usage

### Custom Parser

```dart
// Parse zu custom Type
Future<List<String>> getPlayerIds() async {
  return _httpClient.get(
    'https://api.kickbase.com/players',
    parser: (response) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final players = json['players'] as List;
      return players.map((p) => p['id'] as String).toList();
    },
  );
}

// Parse zu Status Code
Future<bool> checkHealth() async {
  return _httpClient.get(
    'https://api.kickbase.com/health',
    parser: (response) => response.statusCode == 200,
  );
}

// Parse zu Raw String
Future<String> getRawHtml() async {
  return _httpClient.get(
    'https://www.ligainsider.de/bundesliga/spieltage/',
    parser: (response) => response.body,
  );
}
```

### Stream mit Pagination

```dart
Stream<List<Player>> getAllPlayers() async* {
  int page = 1;
  bool hasMore = true;

  while (hasMore) {
    final response = await _httpClient.get(
      'https://api.kickbase.com/players?page=$page',
      parser: (response) {
        final json = jsonDecode(response.body);
        return {
          'players': (json['players'] as List)
              .map((p) => Player.fromJson(p))
              .toList(),
          'hasMore': json['hasMore'] as bool,
        };
      },
    );

    yield response['players'] as List<Player>;
    hasMore = response['hasMore'] as bool;
    page++;
  }
}
```

---

## Logging Output

### Erfolgreicher Request
```
🌐 HTTP GET: https://api.kickbase.com/users/123
✅ HTTP GET: https://api.kickbase.com/users/123 → 200 (142ms)
```

### Fehlgeschlagener Request mit Retry
```
🌐 HTTP GET: https://api.kickbase.com/leagues
⚠️ HTTP GET: https://api.kickbase.com/leagues → 500 (89ms)
❌ HTTP GET: https://api.kickbase.com/leagues → ServerException: Internal Server Error
🔄 HTTP GET: https://api.kickbase.com/leagues → Retrying (attempt 1) after 1s
🌐 HTTP GET: https://api.kickbase.com/leagues (Attempt 2)
✅ HTTP GET: https://api.kickbase.com/leagues → 200 (156ms)
```

### Fehlgeschlagener Request ohne Retry
```
🌐 HTTP GET: https://api.kickbase.com/users/999
⚠️ HTTP GET: https://api.kickbase.com/users/999 → 404 (45ms)
❌ HTTP GET: https://api.kickbase.com/users/999 → NotFoundException: Resource not found
```

---

## Testing

### Mock HttpClientWrapper

```dart
class MockHttpClientWrapper extends Mock implements HttpClientWrapper {}

void main() {
  late MockHttpClientWrapper mockHttpClient;
  late UserRepository repository;

  setUp(() {
    mockHttpClient = MockHttpClientWrapper();
    repository = UserRepository(mockHttpClient);
  });

  test('should get user successfully', () async {
    final user = User(id: '123', name: 'Test User');
    
    when(mockHttpClient.get(
      any,
      headers: anyNamed('headers'),
      parser: anyNamed('parser'),
    )).thenAnswer((_) async => user);

    final result = await repository.getUser('123');
    
    expect(result, user);
  });
}
```

---

## Riverpod Integration

### Provider Setup

```dart
// Automatische Nutzung des Wrappers
final apiServiceProvider = Provider<ApiService>((ref) {
  final httpClient = ref.watch(httpClientWrapperProvider);
  return ApiService(httpClient);
});

// In Widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.watch(apiServiceProvider);
    
    return FutureBuilder(
      future: apiService.fetchData(),
      builder: (context, snapshot) {
        // ...
      },
    );
  }
}
```

---

## Best Practices

### ✅ DO

```dart
// ✅ Use custom parser for type safety
Future<User> getUser(String id) async {
  return _httpClient.get(
    'https://api.kickbase.com/users/$id',
    parser: (response) => User.fromJson(jsonDecode(response.body)),
  );
}

// ✅ Handle specific exceptions
try {
  final user = await getUser('123');
} on NotFoundException {
  // Show "User not found" message
} on NetworkException {
  // Show "No internet" message
}

// ✅ Use Riverpod for dependency injection
final repositoryProvider = Provider((ref) {
  return UserRepository(ref.watch(httpClientWrapperProvider));
});
```

### ❌ DON'T

```dart
// ❌ Don't catch generic Exception
try {
  final user = await getUser('123');
} catch (e) {
  // Too generic - can't handle different cases
}

// ❌ Don't create multiple HttpClientWrapper instances
final wrapper1 = HttpClientWrapper(httpClient: http.Client());
final wrapper2 = HttpClientWrapper(httpClient: http.Client());
// Use Riverpod instead!

// ❌ Don't parse inside repository
Future<dynamic> getUser(String id) async {
  return _httpClient.get(
    'https://api.kickbase.com/users/$id',
    parser: (response) => jsonDecode(response.body), // Return dynamic
  );
}
```

---

## Performance

### Request Timing

Mit Exponential Backoff:
- **1 Attempt**: 0s (sofort)
- **2 Attempts**: ~1s (0s + 1s retry)
- **3 Attempts**: ~3s (0s + 1s + 2s retry)
- **4 Attempts**: ~7s (0s + 1s + 2s + 4s retry)

### Optimierung

```dart
// Parallele Requests für unabhängige Daten
final results = await Future.wait([
  _httpClient.get('https://api.kickbase.com/users/1', parser: parseUser),
  _httpClient.get('https://api.kickbase.com/users/2', parser: parseUser),
  _httpClient.get('https://api.kickbase.com/users/3', parser: parseUser),
]);

// Batch Request für abhängige Daten
final batchResponse = await _httpClient.post(
  'https://api.kickbase.com/batch',
  body: jsonEncode({
    'requests': [
      {'method': 'GET', 'path': '/users/1'},
      {'method': 'GET', 'path': '/users/2'},
      {'method': 'GET', 'path': '/users/3'},
    ],
  }),
  parser: (response) => BatchResponse.fromJson(jsonDecode(response.body)),
);
```

---

## Migration von bestehendem Code

### Vorher (ohne Wrapper)

```dart
Future<User> getUser(String id) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.kickbase.com/users/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw AuthenticationException('Unauthorized');
    } else if (response.statusCode == 404) {
      throw NotFoundException('User not found');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('No internet');
  } catch (e) {
    rethrow;
  }
}
```

### Nachher (mit Wrapper)

```dart
Future<User> getUser(String id) async {
  return _httpClient.get(
    'https://api.kickbase.com/users/$id',
    headers: {'Authorization': 'Bearer $token'},
    parser: (response) => User.fromJson(jsonDecode(response.body)),
  );
  // Error Handling + Retry automatisch! 🎉
}
```

---

## Zusammenfassung

Der `HttpClientWrapper` vereinfacht HTTP-Requests durch:

1. **Konsistente Fehlerbehandlung** - Keine if/else Cascades mehr
2. **Automatisches Retry** - Bei transienten Fehlern (5xx, Network, Timeout)
3. **Strukturiertes Logging** - Besseres Debugging
4. **Type-Safe Parsing** - Generics für Typsicherheit
5. **Riverpod Integration** - Saubere Dependency Injection

**Weniger Code, mehr Features, bessere Wartbarkeit!** 🚀
