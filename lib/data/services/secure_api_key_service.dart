import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Service für Laden des Mistral API-Keys aus Firebase Remote Config.
///
/// **Funktionsweise:**
/// - Der API-Key wird **einmalig** in Firebase Remote Config gespeichert
/// - Alle App-Nutzer teilen sich diesen Key
/// - Der Key wird beim ersten Zugriff automatisch geladen
/// - Keine individuelle Konfiguration pro Nutzer nötig
///
/// **Einrichtung in Firebase Console:**
/// 1. Gehe zu: Firebase Console → Remote Config → Parameter hinzufügen
/// 2. Parameter-Schlüssel: `mistral_api_key`
/// 3. Standardwert: Dein Mistral API-Key (z.B. `sk_xxx...`)
/// 4. Veröffentlichen (wichtig!)
///
/// **Verwendung:**
/// ```dart
/// // Key abrufen (asynchron, z.B. beim App-Start)
/// final apiKey = await SecureApiKeyService.getApiKey();
/// 
/// // Oder synchron (nach fetchAndActivate)
/// final apiKey = SecureApiKeyService.getApiKeySync();
/// ```
class SecureApiKeyService {
  static FirebaseRemoteConfig? _remoteConfig;
  static String? _cachedApiKey;

  /// Initialisiert Remote Config und lädt den API-Key.
  /// **Sollte beim App-Start aufgerufen werden.**
  static Future<void> init() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.fetchAndActivate();
      _cachedApiKey = _remoteConfig!.getString('mistral_api_key');
      
      if (_cachedApiKey != null && _cachedApiKey!.isNotEmpty) {
        debugPrint('✅ SecureApiKeyService: Mistral API-Key aus Remote Config geladen');
      } else {
        debugPrint('⚠️ SecureApiKeyService: Kein Mistral API-Key in Remote Config gefunden');
      }
    } catch (e) {
      debugPrint('❌ SecureApiKeyService: Fehler beim Laden: $e');
      _cachedApiKey = null;
    }
  }

  /// Gibt den API-Key asynchron zurück.
  /// Lädt den Key automatisch, falls noch nicht geschehen.
  static Future<String?> getApiKey() async {
    if (_cachedApiKey != null) {
      return _cachedApiKey;
    }
    
    if (_remoteConfig == null) {
      await init();
    }
    
    return _cachedApiKey;
  }

  /// Gibt den API-Key synchron zurück.
  /// **ACHTUNG: Nur nach `init()` aufrufen!**
  static String? getApiKeySync() {
    return _cachedApiKey;
  }

  /// Prüft, ob ein API-Key verfügbar ist.
  static bool get hasApiKey => _cachedApiKey != null && _cachedApiKey!.isNotEmpty;
}
