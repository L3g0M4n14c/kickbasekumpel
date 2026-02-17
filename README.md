# KickbaseKumpel

Eine Flutter-Anwendung für die Verwaltung von Kickbase Fantasy Football Teams mit Integration der Kickbase API v4 und Firebase Backend.

## 📚 Dokumentation

### Für Entwickler & AI Agents

**⭐ START HERE:** [ARCHITECTURE.md](ARCHITECTURE.md) - Vollständige technische Dokumentation der Anwendung

Die ARCHITECTURE.md bietet:
- ✅ Detaillierte Architektur-Übersicht (Clean Architecture)
- ✅ Technologie-Stack & Framework-Details
- ✅ Vollständige Projektstruktur mit Erklärungen
- ✅ Datenfluss-Diagramme und Code-Beispiele
- ✅ State Management Patterns (Riverpod 3.x)
- ✅ Navigation Setup (GoRouter)
- ✅ Design Patterns & Best Practices
- ✅ **Schritt-für-Schritt Anleitungen für neue Features**

### Für AI Coding Agents

**🤖 GitHub Copilot:** [.github/copilot-instructions.md](.github/copilot-instructions.md)

Diese Datei enthält:
- ✅ Architektur-Richtlinien für Code-Änderungen
- ✅ Verpflichtende Patterns (Riverpod, Freezed, Result<T>)
- ✅ Code-Style Konventionen
- ✅ Checkliste für neue Features
- ✅ Häufige Fehler & Lösungen
- ✅ Dokumentationspflichten

### Zusätzliche Dokumentation

Detaillierte Feature-spezifische Dokumentation im `docs/` Verzeichnis:

- [Phase 1: Setup](docs/PHASE_1_SETUP.md) - Projekt-Setup & Konfiguration
- [Phase 2: Models](docs/PHASE_2_MODELS.md) - Datenmodell-Definitionen
- [Phase 3: Firebase](docs/PHASE_3_FIREBASE.md) - Firebase Integration
- [Phase 4: Services](docs/PHASE_4_SERVICES.md) - Service Layer & API Client
- [Phase 5: UI](docs/PHASE_5_UI.md) - UI-Komponenten & Screens
- [Phase 6: Testing](docs/PHASE_6_TESTING.md) - Testing-Strategie
- [Phase 7: Deployment](docs/PHASE_7_DEPLOYMENT.md) - Deployment-Prozess
- [Riverpod Providers](docs/RIVERPOD_PROVIDERS.md) - Provider-Patterns
- [Router Setup](docs/ROUTER_QUICKSTART.md) - Navigation-Konfiguration
- [Repository Usage](docs/REPOSITORY_USAGE_EXAMPLES.md) - Repository-Beispiele
- [Auth Examples](docs/AUTH_USAGE_EXAMPLES.md) - Authentifizierung
- [HTTP Client](docs/HTTP_CLIENT_WRAPPER_USAGE.md) - HTTP-Wrapper Usage

## 🚀 Quick Start

### Voraussetzungen

- Flutter SDK 3.9.2+
- Dart 3.9.2+
- Firebase Account
- Kickbase Account

### Installation

1. **Repository klonen**:
   ```bash
   git clone https://github.com/L3g0M4n14c/kickbasekumpel.git
   cd kickbasekumpel
   ```

2. **Dependencies installieren**:
   ```bash
   flutter pub get
   ```

3. **Code generieren** (für Freezed Models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Firebase konfigurieren**:
   - `google-services.json` (Android) in `android/app/` platzieren
   - `GoogleService-Info.plist` (iOS) in `ios/Runner/` platzieren

5. **App starten**:
   ```bash
   flutter run
   ```

## 🏗️ Architektur-Übersicht

```
┌─────────────────────────────────────────┐
│     PRESENTATION LAYER                  │
│  (Pages, Screens, Widgets, Providers)   │
├─────────────────────────────────────────┤
│     DATA LAYER                          │
│  (Repositories, Services, Models)       │
├─────────────────────────────────────────┤
│     DOMAIN LAYER                        │
│  (Interfaces, Exceptions, Result Types) │
└─────────────────────────────────────────┘
```

**Tech Stack**:
- **Framework**: Flutter 3.9.2
- **State Management**: Riverpod 3.2.1
- **Navigation**: GoRouter 17.1.0
- **Backend**: Firebase (Auth + Firestore)
- **API**: Kickbase REST API v4
- **Code Generation**: Freezed + json_serializable

Mehr Details: [ARCHITECTURE.md](ARCHITECTURE.md)

## 🛠️ Development

### Code generieren

Nach Änderungen an `@freezed` Models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch Mode (automatische Regenerierung):
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Linting & Formatting

```bash
# Code formatieren
dart format lib/

# Linter ausführen
flutter analyze

# Tests ausführen
flutter test
```

### Neue Features hinzufügen

Siehe **"Wie man neuen Code hinzufügt"** in [ARCHITECTURE.md](ARCHITECTURE.md#wie-man-neuen-code-hinzufügt)

## 📱 Features

- ✅ Kickbase API Integration (v4)
- ✅ User Authentication (Kickbase)
- ✅ Team Management
- ✅ Player Market
- ✅ Lineup Editor
- ✅ Transfer History
- ✅ League Standings
- ✅ Player Statistics
- ✅ Real-time Updates
- ✅ Responsive Design (Mobile/Tablet/Desktop)
- ✅ Offline Support

## 🧪 Testing

```bash
# Alle Tests
flutter test

# Spezifische Tests
flutter test test/data/repositories/

# Mit Coverage
flutter test --coverage
```

## 📦 Build

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Beitragen

1. Lies [ARCHITECTURE.md](ARCHITECTURE.md) für Architektur-Verständnis
2. Lies [.github/copilot-instructions.md](.github/copilot-instructions.md) für Code-Standards
3. Erstelle einen Feature Branch
4. Implementiere dein Feature (halte dich an die Patterns!)
5. Schreibe Tests
6. Erstelle einen Pull Request

## 📄 Lizenz

Dieses Projekt ist privat und nicht für die Veröffentlichung bestimmt.

## 📞 Kontakt

Bei Fragen zur Architektur oder Implementierung:
1. Überprüfe [ARCHITECTURE.md](ARCHITECTURE.md)
2. Suche in den Feature-Docs (`docs/`)
3. Kontaktiere das Entwicklerteam

---

**Version**: 1.0.0  
**Flutter**: 3.9.2  
**Letztes Update**: Februar 2026
