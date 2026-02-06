import 'dart:async';

import 'package:flutter/material.dart';

/// Search Field für KickbaseKumpel
///
/// Wiederverwendbares Suchfeld mit Clear-Button und Debouncing.
///
/// **Verwendung:**
/// ```dart
/// SearchField(
///   onSearch: (query) => // Handle search
///   hintText: 'Spieler suchen...',
///   debounce: Duration(milliseconds: 300),
/// )
/// ```
class SearchField extends StatefulWidget {
  /// Callback für Such-Queries
  final ValueChanged<String> onSearch;

  /// Hint-Text
  final String hintText;

  /// Initiale Such-Query
  final String? initialQuery;

  /// Debounce-Duration (verzögerte Suche)
  final Duration debounce;

  /// Autofocus
  final bool autofocus;

  /// Enabled
  final bool enabled;

  const SearchField({
    required this.onSearch,
    this.hintText = 'Suchen...',
    this.initialQuery,
    this.debounce = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel vorherigen Timer
    _debounceTimer?.cancel();

    // Starte neuen Timer für Debouncing
    _debounceTimer = Timer(widget.debounce, () {
      widget.onSearch(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
                tooltip: 'Löschen',
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
