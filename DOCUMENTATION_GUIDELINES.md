# Dokumentations-Wartung Richtlinien

> **Zielgruppe**: Entwickler und AI Coding Agents  
> **Zweck**: Sicherstellen, dass die Dokumentation aktuell und vollständig bleibt  
> **Version**: 1.0

---

## 📋 Übersicht

Diese Richtlinien stellen sicher, dass die technische Dokumentation mit der Code-Entwicklung Schritt hält.

## 🔄 Wann Dokumentation aktualisiert werden muss

### Immer aktualisieren bei:

1. **Neuen Architektur-Patterns**
   - Datei: `ARCHITECTURE.md`
   - Beispiel: Neues State Management Pattern, neue Layer-Struktur

2. **Neuen Klassen**
   - In-Code: DartDoc Kommentare
   - Beispiel:
   ```dart
   /// Repository für Match-Daten.
   ///
   /// Verwaltet CRUD-Operationen für Match-Entitäten
   /// und synchronisiert mit Kickbase API v4.
   class MatchRepository { }
   ```

3. **Neuen Public Methoden**
   - In-Code: DartDoc Kommentare
   - Beispiel:
   ```dart
   /// Lädt alle Matches einer Liga für einen bestimmten Spieltag.
   ///
   /// [leagueId] Die ID der Liga
   /// [matchDay] Der Spieltag (1-34)
   /// 
   /// Returns [Result<List<Match>>] mit Erfolg oder Fehler.
   Future<Result<List<Match>>> getMatchesByMatchDay(
     String leagueId,
     int matchDay,
   ) async { }
   ```

4. **Neuen Providern**
   - In-Code: DartDoc Kommentare
   - Bei neuem Pattern: `ARCHITECTURE.md` → Abschnitt "State Management"
   - Beispiel:
   ```dart
   /// Provider für Match-Details.
   ///
   /// Lädt detaillierte Informationen zu einem Match.
   /// Auto-invalidiert bei Liga-Wechsel.
   final matchDetailsProvider = FutureProvider.family<Match, String>(
     (ref, matchId) async { },
   );
   ```

5. **Neuen Features**
   - Datei: `ARCHITECTURE.md` → Abschnitt "Wie man neuen Code hinzufügt"
   - Optional: Neue Datei in `docs/` (z.B. `docs/MATCH_SYSTEM.md`)

6. **API-Änderungen**
   - Datei: `docs/api-endpoints.json` (falls relevant)
   - In-Code: API Client Methoden Kommentare

7. **Dependency-Updates**
   - Datei: `ARCHITECTURE.md` → Abschnitt "Technologie-Stack"
   - Beispiel: Riverpod 3.2.1 → 3.3.0

8. **Breaking Changes**
   - Datei: `ARCHITECTURE.md`
   - Datei: `.github/copilot-instructions.md`
   - Beispiel: Migration von GoRouter 16.x auf 17.x

9. **Build/Setup-Änderungen**
   - Datei: `README.md`
   - Beispiel: Neue Firebase-Konfiguration erforderlich

---

## 📝 Dokumentations-Template für neue Features

### 1. In-Code Dokumentation

```dart
/// [FEATURE_NAME]
///
/// [KURZE BESCHREIBUNG DES ZWECKS]
///
/// Verwendung:
/// ```dart
/// [CODE BEISPIEL]
/// ```
///
/// Features:
/// - [FEATURE 1]
/// - [FEATURE 2]
///
/// Dependencies:
/// - [DEPENDENCY 1]
/// - [DEPENDENCY 2]
///
/// See also:
/// - [RELATED_CLASS]
/// - [RELATED_PROVIDER]
class MyNewFeature {
  /// [METHODEN BESCHREIBUNG]
  ///
  /// [PARAMETER_NAME] [PARAMETER BESCHREIBUNG]
  ///
  /// Returns [RETURN_TYPE] [RETURN BESCHREIBUNG]
  ///
  /// Throws:
  /// - [EXCEPTION_TYPE]: [WANN WIRD GEWORFEN]
  ///
  /// Example:
  /// ```dart
  /// final result = await myMethod('param');
  /// ```
  Future<Result<T>> myMethod(String param) async {
    // Implementation
  }
}
```

### 2. ARCHITECTURE.md Update

Wenn dein Feature ein neues Pattern einführt:

```markdown
### [Pattern Name]

**Zweck**: [Kurze Beschreibung]

```dart
// Code-Beispiel
```

**Verwendung**:
- [Use Case 1]
- [Use Case 2]

**Vorteile**:
- [Vorteil 1]
- [Vorteil 2]
```

### 3. Feature-spezifische Dokumentation (docs/)

Erstelle `docs/MY_FEATURE.md` für komplexe Features:

```markdown
# [Feature Name]

## Übersicht

[Beschreibung des Features]

## Architektur

[Diagramm oder Beschreibung]

## Verwendung

### Setup
[Setup-Schritte]

### Beispiele
[Code-Beispiele]

## API Referenz

### Klassen
- [Klasse 1]: [Beschreibung]
- [Klasse 2]: [Beschreibung]

### Provider
- [Provider 1]: [Beschreibung]
- [Provider 2]: [Beschreibung]

## Troubleshooting

### Problem 1
[Lösung]

### Problem 2
[Lösung]
```

---

## 🎯 Checkliste für Dokumentations-Updates

Verwende diese Checkliste bei jeder Code-Änderung:

### Für neue Klassen:
- [ ] DartDoc Klassen-Kommentar hinzugefügt
- [ ] Verwendungsbeispiel im Kommentar
- [ ] Dependencies dokumentiert
- [ ] `ARCHITECTURE.md` aktualisiert (falls neues Pattern)

### Für neue Methoden:
- [ ] DartDoc Methoden-Kommentar hinzugefügt
- [ ] Parameter dokumentiert
- [ ] Return-Wert dokumentiert
- [ ] Exceptions dokumentiert
- [ ] Beispiel-Code hinzugefügt

### Für neue Provider:
- [ ] DartDoc Provider-Kommentar hinzugefügt
- [ ] Provider-Typ dokumentiert
- [ ] Dependencies dokumentiert
- [ ] Invalidation-Strategie dokumentiert

### Für neue Features:
- [ ] `ARCHITECTURE.md` aktualisiert
- [ ] In-Code Dokumentation vollständig
- [ ] Tests dokumentiert
- [ ] Optional: Feature-Doc in `docs/` erstellt
- [ ] `README.md` aktualisiert (falls relevant)

### Für Breaking Changes:
- [ ] `ARCHITECTURE.md` aktualisiert
- [ ] `.github/copilot-instructions.md` aktualisiert
- [ ] Migration Guide erstellt (falls nötig)
- [ ] Alle betroffenen Docs aktualisiert

---

## 🔍 Dokumentations-Review

### Vor jedem Commit:

1. **Syntax Check**:
   ```bash
   # Markdown Linting (optional)
   markdownlint *.md docs/*.md
   ```

2. **Vollständigkeits-Check**:
   - Sind alle neuen Klassen dokumentiert?
   - Sind alle public Methoden dokumentiert?
   - Sind Code-Beispiele aktuell?
   - Funktionieren alle Links?

3. **Konsistenz-Check**:
   - Folgt die Doku dem Template?
   - Ist die Terminologie konsistent?
   - Sind Code-Beispiele formatiert (dart format)?

### Monatlicher Review:

- [ ] Alle Links überprüfen
- [ ] Code-Beispiele auf Aktualität prüfen
- [ ] Veraltete Patterns identifizieren
- [ ] Dependency-Versionen aktualisieren
- [ ] Feedback aus Issues/PRs einarbeiten

---

## 📚 Dokumentations-Hierarchie

### Ebene 1: README.md
- **Zweck**: Erste Anlaufstelle
- **Inhalt**: Überblick, Quick Start, Links zu detaillierter Doku
- **Update-Frequenz**: Bei Setup-Änderungen

### Ebene 2: ARCHITECTURE.md
- **Zweck**: Vollständige technische Dokumentation
- **Inhalt**: Architektur, Patterns, Code-Richtlinien, How-Tos
- **Update-Frequenz**: Bei neuen Patterns, Breaking Changes

### Ebene 3: docs/
- **Zweck**: Feature-spezifische Details
- **Inhalt**: Deep-Dives, API-Referenzen, Migrations
- **Update-Frequenz**: Bei Feature-Änderungen

### Ebene 4: In-Code (DartDoc)
- **Zweck**: API-Dokumentation
- **Inhalt**: Klassen/Methoden Beschreibungen, Beispiele
- **Update-Frequenz**: Bei jeder Code-Änderung

### Ebene 5: .github/copilot-instructions.md
- **Zweck**: AI Agent Richtlinien
- **Inhalt**: Code-Standards, Patterns, Checklisten
- **Update-Frequenz**: Bei neuen Richtlinien, Pattern-Änderungen

---

## 🤖 Für AI Coding Agents

### Automatische Dokumentations-Erweiterung

Wenn du als AI Agent Code schreibst:

1. **IMMER DartDoc Kommentare hinzufügen**:
   ```dart
   /// [BESCHREIBUNG]
   class MyClass { }
   ```

2. **Bei neuen Patterns**:
   - Frage User, ob `ARCHITECTURE.md` aktualisiert werden soll
   - Schlage Template-Text vor

3. **Bei Breaking Changes**:
   - Warne explizit
   - Schlage Updates für `.github/copilot-instructions.md` vor

4. **Bei neuen Dependencies**:
   - Aktualisiere `ARCHITECTURE.md` → "Technologie-Stack"
   - Aktualisiere `pubspec.yaml`

### Erkennungs-Pattern

Wenn du erkennst:
- `class` ohne DartDoc → Vorschlag hinzufügen
- `Future<*> method()` ohne Doc → Vorschlag hinzufügen
- `final *Provider =` ohne Doc → Vorschlag hinzufügen
- Neue Datei in `lib/` → Prüfe ob Doku nötig

---

## 🎓 Best Practices

### DO:
- ✅ Schreibe Dokumentation während des Codens (nicht nachträglich)
- ✅ Verwende Code-Beispiele
- ✅ Halte Beispiele einfach und fokussiert
- ✅ Verlinke verwandte Klassen/Methoden
- ✅ Dokumentiere "Warum", nicht nur "Was"
- ✅ Aktualisiere Doku bei jedem Refactoring

### DON'T:
- ❌ Keine veralteten Code-Beispiele
- ❌ Keine zu generischen Beschreibungen ("Diese Methode macht etwas")
- ❌ Keine fehlenden Parameter-Beschreibungen
- ❌ Keine ungetesteten Code-Beispiele
- ❌ Keine Doku für private Methoden (außer komplex)

---

## 📊 Dokumentations-Metriken

### Ziele:
- **100%** aller public Klassen dokumentiert
- **100%** aller public Methoden dokumentiert
- **100%** aller Provider dokumentiert
- **90%+** aller Code-Beispiele funktionieren
- **0** tote Links in Dokumentation

### Überprüfung:
```bash
# TODO: Script für Doku-Coverage erstellen
# dart run doc_coverage lib/
```

---

## 🔗 Verwandte Ressourcen

- [Dart Doc Guidelines](https://dart.dev/guides/language/effective-dart/documentation)
- [Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html)
- [ARCHITECTURE.md](ARCHITECTURE.md) - Main Documentation
- [.github/copilot-instructions.md](.github/copilot-instructions.md) - AI Guidelines

---

**Version**: 1.0  
**Maintainer**: KickbaseKumpel Team  
**Letzte Aktualisierung**: Februar 2026
