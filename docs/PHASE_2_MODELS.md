# Phase 2: Swift → Dart Modelle mit Freezed (1.5h)

**Status:** ⏳ Bereit für GitHub Copilot  
**Dauer:** 1.5 Stunden | **Copilot:** 95% | **User:** 5%  

---

## 🎯 Objectives

- Alle 20 Swift Codable Modelle in Dart Freezed umschreiben
- JSON Serialization Setup mit CodingKeys Mapping
- build_runner Konfiguration
- Model Exports & Index File
- Validation & Tests

---

## 📋 Zu migrieronde Modelle

Aus KickbaseCore (`/Users/marcocorro/Documents/xCode/Kickbasehelper/KickbaseCore`):

```
✅ User
✅ League
✅ LeagueUser
✅ Player
✅ TeamPlayer
✅ Match
✅ Transfer
✅ Recommendation
✅ LigainsiderPlayer
✅ MarketPlayer
✅ Formation
✅ Highlight
✅ PlayerStats
✅ LineupPlayer
✅ BonusStats
✅ MatchData
✅ LeaderboardEntry
✅ SearchResult
✅ ApiResponse (Wrapper)
✅ ErrorResponse
```

**Plus:** ~5-10 zusätzliche Helper-Modelle

---

## 🚀 GitHub Copilot Prompt (COPY-PASTE)

**Öffne GitHub Codespaces oder lokalen Copilot Chat:**

```
Ich habe ein Flutter + Firebase Projekt "KickbaseKumpel" unter:
/Users/marcocorro/Documents/vscode/kickbasekumpel

Ich möchte alle Modelle aus meiner iOS Swift App in Dart/Freezed konvertieren.

Die Swift Modelle befinden sich hier (als Referenz):
/Users/marcocorro/Documents/xCode/Kickbasehelper/KickbaseCore/Sources/KickbaseCore/Models.swift

Wichtig: Die Modelle haben CodingKeys für API Field Mapping, z.B.:
- "i" → id
- "n" → name
- "m" → marketValue
- "t" → type
- usw.

Erstelle jetzt Dart Freezed Modelle:

1. Nutze Freezed für Immutability & Copy-With
2. JsonSerializable für API Serialisierung
3. Behalte CodingKeys-Mapping (nutze @JsonKey(name: 'i'))
4. Generiere alle mit build_runner

Erstelle diese Dateien:
- lib/data/models/user_model.dart
- lib/data/models/league_model.dart
- lib/data/models/player_model.dart
- lib/data/models/transfer_model.dart
- lib/data/models/match_model.dart
- lib/data/models/recommendation_model.dart
- lib/data/models/ligainsider_model.dart
- lib/data/models/common_models.dart (kleine Helper)
- lib/data/models/models_barrel.dart (alle Exports)

Anforderungen:
- @freezed annotation
- @JsonSerializable(checked: true)
- copyWith() automatisch generiert
- fromJson/toJson für API calls
- toString() für Debugging
- hashCode & == für Testing

Nach Fertigstellung:
1. Speichere alle Dateien
2. Führe aus: flutter pub run build_runner build --delete-conflicting-outputs
3. Überprüfe: Keine build-Fehler
4. Zeige mir die generierte user_model.freezed.dart als Beispiel
```

---

## 📁 Projektstruktur nach Phase 2

```
lib/data/models/
├── user_model.dart               # User + Auth Modelle
├── league_model.dart             # League + LeagueUser + Formation
├── player_model.dart             # Player + TeamPlayer + Stats
├── transfer_model.dart           # Transfer + Recommendation
├── match_model.dart              # Match + MatchData + Highlight
├── ligainsider_model.dart        # LigainsiderPlayer
├── common_models.dart            # ApiResponse, Error, etc.
├── market_model.dart             # MarketPlayer + Pricing
├── leaderboard_model.dart        # LeaderboardEntry + Ranking
└── models_barrel.dart            # Export all
```

---

## 🔧 Build Runner Setup

### pubspec.yaml vorbereitet?

```yaml
dev_dependencies:
  build_runner: ^2.4.11
  freezed: ^2.5.6
```

**Überprüfe:**
```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel
cat pubspec.yaml | grep -A2 "dev_dependencies"
```

### Build Runner ausführen

**Schritt 1: Clean**
```bash
flutter clean
flutter pub get
```

**Schritt 2: Generiere Modelle**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Erwartet:** Keine Fehler, alle `.freezed.dart` Dateien erstellt

**Optional - Watch Mode (Auto-Generierung):**
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 📝 Freezed Model Template

**Referenz - So sieht ein Freezed Modell aus:**

```dart
// lib/data/models/user_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  factory User({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'avatar') String? avatar,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
```

**Nach `build_runner`:**
```dart
// Auto-generiert: user_model.freezed.dart
// - copyWith()
// - toString()
// - == / hashCode
// - toJson() / fromJson()
```

---

## ✅ Validierung

**Test Build:**
```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel

# Prüfe: Keine Fehler
flutter pub run build_runner build --delete-conflicting-outputs

# Prüfe: Files existieren
ls -la lib/data/models/*.freezed.dart | wc -l

# Sollte sein: 8-10 Dateien
```

**Code Analyse:**
```bash
flutter analyze

# Erwartet: 0 Errors, 0 Warnings in models/
```

**Quick Test (optional):**
```bash
# Erstelle test_models.dart und teste:
final user = User(
  id: '123',
  name: 'Marco',
  email: 'test@example.com',
);

final userJson = user.toJson(); // JSON für API
final userCopy = user.copyWith(name: 'Marco2');
```

---

## 🎯 Success Criteria

- [x] Alle 20 Modelle konvertiert zu Freezed
- [x] CodingKeys (JsonKey Mapping) beibehalten
- [x] build_runner ohne Fehler gelaufen
- [x] Alle `.freezed.dart` & `.g.dart` Dateien generiert
- [x] `flutter analyze` = 0 Errors
- [x] models_barrel.dart mit allen Exports
- [x] Git Commit: "Phase 2: Dart Modelle mit Freezed"

---

## 📊 Geschätzter Output

**Pro Modell:** 5-20 Zeilen Code (Copilot schreibt >90%)  
**Total:** ~300-400 Zeilen Freezed Boilerplate  
**Zeit:** 1.5h (davon >80% Copilot)  

---

## 🐛 Troubleshooting

### Problem: "Cannot find `part` generated file"
```bash
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
```

### Problem: JsonKey Namen falsch
- Prüfe: iOS Swift Model für exakte Field Names
- Prüfe: API Responses in Kickbase Docs
- Nutze: @JsonKey(name: 'exacter_name_von_api')

### Problem: Circular Dependencies
- Splits Modelle in separate Dateien
- Nutze abstrakte Basis-Klassen
- Struktur: common_models.dart (primitiv) → player_model.dart (komplex)

---

## 🔗 Nächster Schritt

Wenn Phase 2 fertig: → **[Phase 3: Firebase Backend](./PHASE_3_FIREBASE.md)**

---

## 📚 Referenzen

- **Freezed Docs:** https://pub.dev/packages/freezed
- **Json Serializable:** https://pub.dev/packages/json_serializable
- **Build Runner:** https://pub.dev/packages/build_runner
- **Flutter Models:** https://docs.flutter.dev/data-and-backend/serialization

---

**Fortschritt:** Phase 1 (✅) → Phase 2 (⏳)  
**Copilot wird ~95% dieser Arbeit machen!**
