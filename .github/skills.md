# Repository Skills

In addition to the Copilot instructions, this repository includes a set
of helper documents that describe capabilities and tools an AI assistant
can use when interacting with the project.

## Projekt-Skills (`.clinerules/skills/`)

Acht Projekt-Skills (Format: `SKILL.md` mit YAML-Frontmatter `name`/`description`)
bündeln die wichtigsten Code-Fakten, damit Agents den Code nicht mehr erst
explorieren müssen. Sie werden von Cline automatisch geladen:

| Skill | Inhalt |
|---|---|
| `kickbasekumpel-architecture` | Clean-Architecture-Schichten, Verzeichnis-Layout, Result<T>, Datenfluss, Routing, Feature-Checkliste |
| `kickbasekumpel-conventions` | Riverpod 3.x Provider-Typen, Freezed-Modelle, Error Handling, Namenskonventionen, Linting |
| `kickbasekumpel-codebase-map` | Datei-/Ordnerkarte: wo liegen Models, Services, Provider, Screens, Tests, Docs |
| `kickbasekumpel-api` | KickbaseAPIClient (v4), Retry/Proxy-Verhalten, Demo-Client, Exception-Hierarchie, LigaInsider, Swagger-Referenz `docs/api-endpoints.json` |
| `kickbasekumpel-backend` | Firebase Auth/Firestore-Repos, Collections, Cloud Functions, Demo-Modus, Deploy |
| `kickbasekumpel-dev-workflow` | Build/Test/Lint/Codegen-Befehle, CI/CD-Workflows, Abhängigkeiten, Fastlane, Teststruktur |
| `kickbasekumpel-testing` | test/helpers (ResultMatcher, MockFirebaseSetup, TestData), Mocktail/Mockito-Codegen, fake_cloud_firestore |
| `kickbasekumpel-features` | Feature → Service/Provider/Screen-Map, Business-Logik der Empfehlungs-/Budget-Services, Roadmap (Ideen.md) |

Die Skills konsolidieren die bisherigen Dokus (ARCHITECTURE.md,
.github/copilot-instructions.md, README.md, docs/). Diese Originaldokos
bleiben die detaillierte Referenz; Skills enthalten die Kurzform für den
schnellen Zugriff.

## flutter_docs_skill

The `flutter_docs_skill` allows an assistant to answer questions about
Flutter by referencing a locally built index of the official Flutter
documentation.

See `docs/FLUTTER_DOCS_SKILL.md` for details on how to generate and
extend this index. The underlying script lives at
`tool/flutter_docs_skill.dart` and outputs `tool/docs_index.json`.

---

Add more skill descriptions here as additional utilities are created.
