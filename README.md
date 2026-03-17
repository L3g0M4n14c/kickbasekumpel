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

Detaillierte technische Dokumentation im `docs/` Verzeichnis:

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

## 📱 Views & Features

### Authentifizierung

| View | Beschreibung |
|------|-------------|
| **Anmelden** | Melde dich mit E-Mail und Passwort an. Alternativ steht ein Demo-Login zur Verfügung. |
| **Registrieren** | Erstelle ein neues Konto mit E-Mail-Adresse und Passwort. |
| **Passwort vergessen** | Gib deine E-Mail ein und erhalte einen Link zum Zurücksetzen deines Passworts. |
| **E-Mail bestätigen** | Nach der Registrierung erhältst du eine Bestätigungs-E-Mail – klicke auf den Link, um dein Konto zu aktivieren. |

### Dashboard

| View | Beschreibung |
|------|-------------|
| **Home** | Dein persönliches Dashboard mit einer Übersicht deiner Ligen, Benachrichtigungen und nützlichen Links. |
| **Ligen** | Alle deine Kickbase-Ligen auf einen Blick. Tritt bestehenden Ligen bei oder erstelle eine neue. |
| **Team** | Zeigt dein aktuelles Team mit allen Spielern, deinem Budget und Gesamtmarktwert. Sortierbar nach Name, Marktwert oder Punkte. |
| **Transfermarkt** | Durchsuche und filtere alle verfügbaren Spieler im Markt – kaufe gezielt nach Preis, Position oder Verein. |
| **Aufstellung** | Deine aktuelle Startelf und die Ersatzspieler in einer übersichtlichen Felddarstellung – für alle Bildschirmgrößen optimiert. |
| **Transfers** | Smarte Kauf- und Verkaufsempfehlungen mit verschiedenen Optimierungszielen wie Budgetausgleich oder Gewinnmaximierung. |
| **Liga-Rangliste** | Deine aktuelle Platzierung in der Liga mit einer Übersicht aller Teilnehmer und deren Punktestand. |
| **Verkaufsempfehlungen** | KI-gestützte Empfehlungen, welche Spieler du verkaufen solltest – mit wählbaren Zielen wie Budgetausgleich oder maximaler Gewinn. |
| **Einstellungen** | Verwalte dein Profil, sammle Boni und melde dich ab. |

### Liga-Details

| View | Beschreibung |
|------|-------------|
| **Liga-Übersicht** | Detaillierte Infos zu einer einzelnen Liga: Schnellzugriffe, Statistiken und aktuelle Ligaaktivitäten. |
| **Liga-Spieler** | Alle Spieler einer Liga mit Such- und Filteroptionen – z. B. nach Position, Verein oder Verfügbarkeit. |
| **Liga-Tabelle** | Die aktuelle Tabelle deiner Liga mit Platzierungen für ausgewählte Spieltage. |

### Spieler

| View | Beschreibung |
|------|-------------|
| **Spieler-Statistiken** | Detaillierte Statistiken eines Spielers: Punkte, Marktwertentwicklung und Leistungskennzahlen. Spieler können als Favorit gespeichert oder geteilt werden. |
| **Spieler-Historie** | Vollständige Transferhistorie, Leistungsverlauf und Marktwertentwicklung eines Spielers im Zeitverlauf. |

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
