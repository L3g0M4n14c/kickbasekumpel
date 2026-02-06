# Phase 1: KickbaseKumpel Flutter Setup ✅ ABGESCHLOSSEN

**Status:** ✅ Fertig  
**Nächster Schritt:** Phase 2 (Dart Modelle) - ✅ EBENFALLS FERTIG!

## Projektstruktur erstellt
```
kickbasekumpel/
├── lib/
│   ├── main.dart (Riverpod + Firebase init)
│   ├── config/
│   │   ├── firebase_config.dart
│   │   ├── firebase_options.dart
│   │   ├── router.dart (GoRouter)
│   │   └── theme.dart (Material Design 3)
│   ├── data/ (leer - Phase 2)
│   ├── domain/ (leer - Phase 4)
│   └── presentation/
│       └── pages/
│           └── home_page.dart
├── .devcontainer/
│   └── devcontainer.json (GitHub Codespaces)
└── pubspec.yaml (mit allen Dependencies)
```

## Was ist erledigt?
- ✅ Flutter Projekt erstellt: `de.legomaniac.kickbasekumpel`
- ✅ Dependencies hinzugefügt (Riverpod, Firebase, GoRouter, Freezed, etc.)
- ✅ .devcontainer für GitHub Codespaces konfiguriert
- ✅ Firebase Config Setup
- ✅ GoRouter Navigation
- ✅ Material Design 3 Theme
- ✅ Riverpod ProviderScope integriert

## Nächste Schritte - Phase 1b (GitHub Setup)

### 1. GitHub Repository erstellen
```bash
# Auf https://github.com/new
# Name: kickbasekumpel-flutter
# Beschreibung: "KickbaseKumpel - Kickbase Fantasy League Manager"
# Private: Ja
```

### 2. Lokal mit Git initialisieren
```bash
cd /Users/marcocorro/Documents/vscode/kickbasekumpel
git init
git add .
git commit -m "Initial: Flutter + Firebase + Riverpod Setup"
git remote add origin https://github.com/YOUR_USERNAME/kickbasekumpel-flutter.git
git branch -M main
git push -u origin main
```

### 3. Firebase Projekt erstellen
- Gehe zu https://console.firebase.google.com/
- "Projekt erstellen" → "kickbasekumpel-dev"
- Wähle kostenlos Projekt
- Registriere iOS App: Bundle ID = `de.legomaniac.kickbasekumpel`
- Registriere Android App: Package = `de.legomaniac.kickbasekumpel`
- Registriere Web App
- Download google-services.json (Android)
- Download GoogleService-Info.plist (iOS)

### 4. Kopiere Firebase Credentials
```bash
# Android
cp GoogleService-Info.plist kickbasekumpel/android/app/

# iOS  
cp google-services.json kickbasekumpel/ios/Runner/
```

### 5. Aktualisiere firebase_options.dart
Kopiere die echten Firebase Credentials von Firebase Console in:
`lib/config/firebase_options.dart`

## GitHub Copilot für Phase 2 vorbereitet

**Kopiere diesen Prompt in GitHub Copilot:**

```
Ich habe ein Flutter + Firebase Projekt "KickbaseKumpel" (Package: de.legomaniac.kickbasekumpel).

Meine iOS Swift App hat folgende Modelle in KickbaseCore:
- User, League, LeagueUser, Player, TeamPlayer
- Match, Transfer, Recommendation
- LigainsiderPlayer, MarketPlayer, Formation

Alle Modelle sind Codable mit CodingKeys für API-Feldmapping.

Erstelle jetzt Dart Freezed-Modelle in lib/data/models/ für diese Strukturen.

Anforderungen:
1. Nutze Freezed für Immutability
2. JsonSerializable für Serialisierung
3. Behalte CodingKeys-Mapping (z.B. "i" → id, "n" → name)
4. Generiere build_runner Config
5. Erstelle model_exports.dart mit allen Imports

Verwende diesen Befehl zum Generieren:
flutter pub run build_runner build --delete-conflicting-outputs
```

**Dies ist dein nächster Schritt nach Phase 1!**

---

## Troubleshooting

### Flutter Pub Get fehlgeschlagen?
```bash
cd kickbasekumpel
flutter clean
flutter pub get
```

### Fehlende Richtung bei GoRouter?
GoRouter braucht mindestens eine Route - HomePage ist platziert ✅

### Dart DevTools?
```bash
dart devtools
```

---

**Status: Phase 1 zu 70% erledigt** ⏳
- ✅ Projektstruktur
- ✅ Dependencies
- ✅ Firebase Config
- ⏳ GitHub + Credentials (manuell)
