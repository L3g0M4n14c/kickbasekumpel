# Flutter Docs Skill

This repository contains a minimal example of a "skill file" that helps an
assistant index the official Flutter documentation. The purpose is to provide
a starting point for building a searchable local copy of docs.flutter.dev.

## `tool/flutter_docs_skill.dart`

The Dart script iterates over a small set of seed URLs, downloads the HTML,
extracts the page title and plain text, and writes everything to
`tool/docs_index.json`.

### Usage

1. Ensure dependencies are available:
   ```bash
   flutter pub get
   ```

2. Run the script:
   ```bash
   dart run tool/flutter_docs_skill.dart
   ```

3. Inspect `tool/docs_index.json`:
   ```json
   {
     "https://docs.flutter.dev": {
       "title": "Flutter ",
       "text": "Flutter makes it ..."
     },
     ...
   }
   ```

### Extending

- Add additional URIs to `seedPages` in the script.
- Persist more metadata (e.g. headings, links).
- Integrate with an embedding/search engine or a chatbot.
- Use `dart pub add http html` if additional packages are needed.

> **Note:** the crawl is intentionally naive. For a production-grade skill,
> you might want to respect `robots.txt`, throttle requests, and recurse
> through links.

---

This document and the script collectively form the "skill file" you asked for.
You can adapt them to your own indexing or AI‑assistant workflow.