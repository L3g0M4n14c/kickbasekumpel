# Phase 4: Services & API Integration (2h)

**Status:** ⏳ Nach Phase 3  
**Dauer:** 2 Stunden | **Copilot:** 70% | **User:** 30%  

---

## 🎯 Objectives

- KickbaseAPIClient nach Dart portieren
- LigainsiderService Web Scraping
- HTTP Client Wrapper mit Error Handling
- Retry Logic & Circuit Breaker
- Service Providers für Riverpod
- Integration mit Repositories

---

## 📊 Services-Architektur

```
lib/
├── data/
│   ├── services/                ← NEU
│   │   ├── kickbase_api_client.dart
│   │   ├── ligainsider_service.dart
│   │   ├── http_client_wrapper.dart
│   │   └── services_barrel.dart
│   └── providers/
│       └── service_providers.dart (NEU)
└── domain/
    ├── services/               ← NEU
    │   ├── kickbase_service_interface.dart
    │   ├── ligainsider_interface.dart
    │   └── http_client_interface.dart
    └── usecases/              ← NEU (Optional)
        └── ...
```

---

## 🔗 Phase 4a: Kickbase API Client

### API Endpoints Übersicht

```dart
// KickbaseAPIClient - Wichtigste Endpoints:

GET  /v1/user                    // Authenticated User
GET  /v1/leagues                 // User's Leagues
GET  /v1/league/{id}             // League Details
GET  /v1/league/{id}/players     // League Players
GET  /v1/league/{id}/lineups     // Current Lineups
POST /v1/league/{id}/lineup      // Update Lineup
GET  /v1/market/available        // Market Available Players
POST /v1/market/buy              // Buy Player
POST /v1/market/sell             // Sell Player
GET  /v1/stats/player/{id}       // Player Stats
GET  /v1/transfers               // Recent Transfers
```

### GitHub Copilot Prompt (COPY-PASTE)

```
Portiere den KickbaseAPIClient von meiner iOS Swift App nach Dart/Flutter.

Referenz (Swift):
/Users/marcocorro/Documents/xCode/Kickbasehelper/KickbaseCore/Sources/KickbaseCore/Services/KickbaseAPIClient.swift

Erstelle: lib/data/services/kickbase_api_client.dart

Anforderungen:

1. Base Configuration
   - Base URL: https://api.kickbase.com
   - API Version: v1
   - Bearer Token Authentication
   - Timeout: 30s

2. Hauptmethoden (wie in Swift):
   - Future<User> getUser()
   - Future<List<League>> getLeagues()
   - Future<League> getLeague(String leagueId)
   - Future<List<Player>> getLeaguePlayers(String leagueId)
   - Future<LineupResponse> getLineup(String leagueId)
   - Future<void> updateLineup(String leagueId, Lineup lineup)
   - Future<List<Player>> getMarketAvailable(String leagueId)
   - Future<TransferResponse> buyPlayer(String leagueId, String playerId, int price)
   - Future<TransferResponse> sellPlayer(String leagueId, String playerId, int price)
   - Future<PlayerStats> getPlayerStats(String playerId)
   - Future<List<Transfer>> getTransfers(String leagueId)

3. Error Handling
   - Custom Exception: KickbaseException(message, code, originalError)
   - Mapped: 401 → AuthenticationException
   - Mapped: 404 → NotFoundException
   - Mapped: 429 → RateLimitException
   - Mapped: Network Error → NetworkException
   - Retry Logic: Auto-Retry auf 5xx mit exponential backoff

4. JSON Deserialization
   - Nutze jsonDecode + fromJson auf Models
   - Behalte CodingKeys Mapping (@JsonKey)
   - Nullable Fields korrekt handhaben

5. Bearer Token
   - Storage: flutter_secure_storage
   - Refresh bei 401
   - Auto-inject in Headers

Struktur:
class KickbaseAPIClient {
  final http.Client httpClient;
  final FlutterSecureStorage secureStorage;
  String? _token;

  Future<T> _get<T>() ...
  Future<T> _post<T>() ...
  // etc
}

Error Handling Pattern:
try {
  final response = await http.get(...);
  if (response.statusCode == 401) {
    // Refresh token
  }
  return parseResponse<T>(response);
} on SocketException {
  throw NetworkException('No internet connection');
} catch (e) {
  throw KickbaseException(e.toString());
}
```

---

## 🕷️ Phase 4b: Ligainsider Web Scraper

### GitHub Copilot Prompt (COPY-PASTE)

```
Portiere den LigainsiderService von meiner iOS App nach Dart.

Referenz (Swift):
/Users/marcocorro/Documents/xCode/Kickbasehelper/KickbaseCore/Sources/KickbaseCore/Services/LigainsiderService.swift

Erstelle: lib/data/services/ligainsider_service.dart

Ligainsider.de ist eine Website mit Verletzungen & Form-Daten.
Der Scraper parsed HTML und extrahiert Spieler-Informationen.

Anforderungen:

1. Zielseite: https://www.ligainsider.de/
   - Endpoint: /spieler-verletzungen (Injuries)
   - Parsing: HTML mit html-Package
   - Ziel: Liste von LigainsiderPlayer Objekten

2. LigainsiderPlayer Model (bereits in Phase 2)
   - name: String
   - injuryStatus: String (fit, fraglich, ausfallrisiko, verletzt)
   - injuryDescription: String?
   - formRating: int? (1-5)
   - lastUpdate: DateTime

3. Scraper Methoden
   - Future<List<LigainsiderPlayer>> getInjuredPlayers()
   - Future<Map<String, FormRating>> getPlayerForm()
   - Future<LigainsiderPlayer> searchPlayer(String name)

4. HTML Parsing
   - Nutze: import 'package:html/parser.dart';
   - Selektoren (CSS-like):
     - Verletzungen: table.injury-list tr td.player-name
     - Form-Rating: div.form-rating
     - Update Zeit: span.last-updated
   
5. Error Handling
   - HttpException bei Server-Fehler
   - ParsingException bei HTML-Struktur-Änderung
   - Fallback: Empty List statt Crash

6. Caching (Optional)
   - Cache Dauer: 1 Stunde
   - Storage: shared_preferences
   - Update: Mit TTL checken

Code Struktur:
class LigainsiderService {
  final http.Client httpClient;

  Future<List<LigainsiderPlayer>> getInjuredPlayers() async {
    final response = await httpClient.get(...);
    final document = parse(response.body);
    
    // Parse HTML elements
    // Extract data
    // Create Models
    // Return List
  }
}

Nutze auch ConnectionChecker:
- Prüfe Konnektivität mit connectivity_plus
- Skip Request wenn offline
- Return Cached Data oder Empty List
```

---

## 🌐 Phase 4c: HTTP Client Wrapper

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle einen generischen HTTP Client Wrapper für konsistente Fehlerbehandlung:

lib/data/services/http_client_wrapper.dart

Features:

1. Base Wrapper Class
   - Wraps: http.Client
   - Nutzt: Riverpod für Singleton
   - Exponential Backoff Retry
   - Request Timeout Handling

2. Request Methods
   - Future<T> get<T>(url, parser)
   - Future<T> post<T>(url, body, parser)
   - Future<T> put<T>(url, body, parser)
   - Future<T> delete<T>(url)

3. Error Mapping
   - StatusCode 401 → UnauthorizedException
   - StatusCode 404 → NotFoundException
   - StatusCode 429 → RateLimitException
   - StatusCode 5xx → ServerException (mit retry)
   - SocketException → NetworkException
   - TimeoutException → TimeoutException

4. Retry Strategy
   - Max Attempts: 3
   - Delay: exponential (1s, 2s, 4s)
   - Nur retry auf: 5xx, Network Errors, Timeout
   - Nicht retry auf: 4xx Client Errors (außer 429)

5. Logging
   - Request: URL, Method, Headers (ohne Secrets)
   - Response: Status, Zeit
   - Error: Exception Type + Message

Nutze diese Struktur:
class HttpClientWrapper {
  final http.Client httpClient;
  
  Future<T> _executeWithRetry<T>(...) async {
    int attempts = 0;
    while (attempts < 3) {
      try {
        // execute request
      } catch (e) {
        if (shouldRetry(e)) {
          await Future.delayed(exponentialDelay(attempts++));
          continue;
        }
        rethrow;
      }
    }
  }
}
```

---

## 📦 Phase 4d: Service Providers

### GitHub Copilot Prompt (COPY-PASTE)

```
Erstelle Riverpod Providers für Services:

lib/data/providers/service_providers.dart

Providers:

1. httpClientProvider
   - Singleton: http.Client()
   - Wrapped mit HttpClientWrapper

2. kickbaseApiClientProvider
   - Nutzt: httpClientProvider
   - Nutzt: secureStorageProvider (für Token)
   - Lazy Loading

3. ligainsiderServiceProvider
   - Nutzt: httpClientProvider
   - Lazy Loading

4. servicesProvider (barrel)
   - Export aller Service Provider
   - Für Riverpod.watch()

Alle als:
final httpClientProvider = Provider((ref) => http.Client());
final apiClientProvider = Provider((ref) => KickbaseAPIClient(...));
```

---

## 🔄 Integration in Repositories

### Phase 4e: Update Repositories

**Repositories (aus Phase 3) updaten:**

```dart
// lib/data/repositories/league_repository.dart

class LeagueRepository implements LeagueRepositoryInterface {
  final KickbaseAPIClient apiClient;
  final FirebaseFirestore firestore;

  LeagueRepository({
    required this.apiClient,
    required this.firestore,
  });

  @override
  Future<List<League>> getLeagues() async {
    try {
      // 1. Fetch von Kickbase API
      final leagues = await apiClient.getLeagues();
      
      // 2. Cache in Firestore
      for (final league in leagues) {
        await firestore.collection('leagues')
            .doc(league.id)
            .set(league.toJson());
      }
      
      return leagues;
    } catch (e) {
      // Fallback: Aus Firestore Cache laden
      final cached = await firestore.collection('leagues').get();
      return cached.docs
          .map((doc) => League.fromJson(doc.data()))
          .toList();
    }
  }
}
```

---

## ✅ Validierung

### Test Checklist

- [ ] KickbaseAPIClient: Alle Endpoints funktionieren
- [ ] LigainsiderService: HTML Scraping extrahiert Daten
- [ ] HttpClientWrapper: Retry Logic funktioniert
- [ ] Error Handling: Exceptions richtig gemappt
- [ ] Token Refresh: 401 löst Refresh aus
- [ ] Offline Fallback: Cached Data wird zurückgegeben
- [ ] Riverpod Services: Singleton Instanzen

### Integration Test

```bash
flutter test test/data/services/ --coverage
```

---

## 🎯 Success Criteria

- [x] KickbaseAPIClient vollständig portiert
- [x] LigainsiderService HTML Scraper
- [x] HttpClientWrapper mit Retry
- [x] Riverpod Service Provider
- [x] Integration in Repositories
- [x] Error Handling & Exceptions
- [x] Token Management
- [x] Offline Fallback Caching
- [x] Git Commit: "Phase 4: Services & API Integration"

---

## 🔗 Nächster Schritt

Wenn Phase 4 fertig: → **[Phase 5: UI Screens](./PHASE_5_UI.md)**

---

## 📚 Referenzen

- **http Package:** https://pub.dev/packages/http
- **html Package:** https://pub.dev/packages/html
- **Riverpod Services:** https://riverpod.dev
- **Error Handling:** https://dart.dev/guides/libraries/async-await

---

**Fortschritt:** Phase 1-3 (✅) → Phase 4 (⏳)  
**Copilot wird ~70% dieser Arbeit machen!**
