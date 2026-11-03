# KickbaseKumpel

Flutter-App (Riverpod 3, Freezed 4, GoRouter 18, Firebase) für Kickbase Fantasy Football.

## Projekt-Skills

Das Projektwissen steckt in den Skills unter `.claude/skills/` (Symlink auf
`.clinerules/skills/`, gemeinsam mit Cline genutzt). Vor dem Erkunden des Codes
den passenden Skill laden:

- `kickbasekumpel-data-map` – IMMER bei API-Daten, JSON-Kurzkeys, Parsing
- `kickbasekumpel-architecture` / `-conventions` – bei jeder Code-Änderung
- `kickbasekumpel-codebase-map` / `-features` – wo liegt was
- `kickbasekumpel-api` / `-backend` – Kickbase-Client, Firebase, Cloud Functions
- `kickbasekumpel-testing` / `-dev-workflow` – Tests, Codegen, CI, Deploy

Skills bei Änderungen pflegen – nur in `.clinerules/skills/` editieren.

## Wichtigste Regeln

- Nach Änderungen an Freezed-/json_serializable-Modellen:
  `flutter pub run build_runner build --delete-conflicting-outputs`
- Tests gezielt laufen lassen (`test/` spiegelt `lib/`), Voll-Lauf nur am Ende
  oder bei unklarem Scope.
- Vor dem Abschluss: `dart format lib/` und `flutter analyze`.
- Sprache in Code-Kommentaren, Doku und Commits: Deutsch.
