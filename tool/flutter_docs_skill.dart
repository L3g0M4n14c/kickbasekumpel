/// A simple script that crawls parts of the Flutter documentation and
/// writes a very naive index to `tool/docs_index.json`.
///
/// This is the starting point for the "Flutter‑Docs‑Skill" mentioned in the
/// Copilot instructions: you can run this Dart program, let it download a
/// handful of pages from docs.flutter.dev, parse the HTML, and build a
/// lightweight JSON file that an assistant or local search tool can query.
///
/// Usage:
///
/// ```bash
/// dart run tool/flutter_docs_skill.dart
/// ```
///
/// You may wish to add additional URLs to [seedPages], persist more
/// metadata, or integrate with a real full‑text search engine.
library;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

/// the list of documentation root pages we will fetch and index.
/// extend this with any pages you care about.
final List<Uri> seedPages = [
  Uri.parse('https://docs.flutter.dev'),
  Uri.parse('https://docs.flutter.dev/ai'),
  Uri.parse('https://docs.flutter.dev/get-started'),
  Uri.parse('https://docs.flutter.dev/development'),
  Uri.parse('https://docs.flutter.dev/cookbook'),
  Uri.parse('https://docs.flutter.dev/release/whats-new'),
];

Future<void> main() async {
  final Map<String, Map<String, dynamic>> index = {};

  for (final uri in seedPages) {
    stdout.writeln('Fetching $uri');
    try {
      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        stderr.writeln('  > failed: HTTP ${resp.statusCode}');
        continue;
      }
      final doc = parse(resp.body);
      final title = _extractTitle(doc);
      final bodyText = _extractBodyText(doc);
      index[uri.toString()] = {'title': title, 'text': bodyText};
      // small pause to be polite
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      stderr.writeln('  > exception: $e');
    }
  }

  final outFile = File('tool/docs_index.json');
  await outFile.writeAsString(JsonEncoder.withIndent('  ').convert(index));
  stdout.writeln('Wrote ${index.length} entries to ${outFile.path}');
}

String _extractTitle(Document doc) {
  final titleEl = doc.querySelector('title');
  return titleEl?.text.trim() ?? '';
}

String _extractBodyText(Document doc) {
  // naive: take the body element and strip tags
  final body = doc.body;
  if (body == null) return '';
  return body.text.replaceAll(RegExp(r'\s+'), ' ').trim();
}
