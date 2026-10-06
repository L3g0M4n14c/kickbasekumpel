---
name: kickbasekumpel-api
description: KickbaseKumpel API-Integration - KickbaseAPIClient (v4), HTTP-Wrapper, Retry/Proxy-Verhalten, Demo-Client, Exception-Hierarchie, LigaInsider-Scraper. Verwenden bei API-, HTTP-, Netzwerk- oder Scraper-Fragen.
---

# KickbaseKumpel – API-Integration

## KickbaseAPIClient (`lib/data/services/kickbase_api_client.dart`)

```dart
class KickbaseAPIClient {
  static const String _baseUrl = 'https://api.kickbase.com';
  static const String _apiVersion = 'v4';
  static const Duration _timeout = Duration(seconds: 30);
  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(milliseconds: 500);
  static const String _webProxyUrl = ...; // Cloud Function kickbaseProxy
}
```

- **Web**: Auf `kIsWeb` läuft jeder Request über den `kickbaseProxy` (Cloud Function, siehe kickbasekumpel-backend) statt direkt gegen api.kickbase.com (CORS)
- **Retries**: `_makeRequestWithRetry` mit exponentiellem Backoff (3 Versuche) – das ist die einzige Retry-Stelle; Riverpod-Auto-Retry ist in main.dart deaktiviert
- **Caching**: User-Daten unter SharedPreferences-Key `kickbase_user_data`
- Provider: `lib/data/providers/kickbase_api_provider.dart`

## HTTP-Wrapper

`lib/data/services/http_client_wrapper.dart` + `http_client_wrapper_provider.dart` – Wrapper-Pattern für externe APIs (Doku: docs/HTTP_CLIENT_WRAPPER_USAGE.md).

## Demo-Client

`DemoKickbaseAPIClient extends KickbaseAPIClient` – statische Demodaten, siehe kickbasekumpel-backend.

## Fehlerbehandlung (`lib/domain/exceptions/kickbase_exceptions.dart`)

`KickbaseException` (Basis) → `AuthenticationException`, `AuthorizationException`, `NotFoundException`, `RateLimitException`, `NetworkException`, `ServerException`, `TimeoutException`, `ParsingException`, `AllEndpointsFailedException`. Für exhaustive `switch`-Muster.

## LigaInsider

- App-seitig: `lib/data/services/ligainsider_service.dart`, `ligainsider_photo_provider.dart`, Model `ligainsider_model.dart`, `ligainsider_match_model.dart`
- Serverseitig Scraper: `functions/src/ligainsider-scraper.ts`, `ligainsider-lineup-scraper.ts` (cheerio)
- Doku: docs/LIGAINSIDER_SCRAPER.md

## Parsing

JSON → Modell-Helfer in `lib/data/utils/parsing_utils.dart`; Models nutzen `fromJson` (json_serializable).

## Endpunkt-Referenz

**`docs/api-endpoints.json`** – vollständige Swagger-Spezifikation der Kickbase v4 (von kevinskyba/kickbase-api-doc). IMMER hier nachsehen, wenn ein neuer Endpunkt angebunden oder Parameters/Responses geprüft werden sollen, statt die API blind zu erkunden. Ungenutzte Endpunkte der Roadmap: siehe kickbasekumpel-features + Ideen.md.
