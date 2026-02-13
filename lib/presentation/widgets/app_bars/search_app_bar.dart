import 'package:flutter/material.dart';

/// Search AppBar für KickbaseKumpel
///
/// Spezielle AppBar mit integrierter Suchfunktion.
/// Kann zwischen normalem und Such-Modus wechseln.
///
/// **Verwendung:**
/// ```dart
/// SearchAppBar(
///   title: 'Spieler',
///   onSearch: (query) => // Handle search
///   hintText: 'Spieler suchen...',
/// )
/// ```
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Titel wenn nicht im Such-Modus
  final String title;

  /// Callback für Such-Queries
  final ValueChanged<String> onSearch;

  /// Platzhalter-Text im Suchfeld
  final String hintText;

  /// Optionale Aktionen wenn nicht im Such-Modus
  final List<Widget>? actions;

  /// Zeigt automatisch das Suchfeld an
  final bool autoFocus;

  /// Initiale Such-Query
  final String? initialQuery;

  const SearchAppBar({
    required this.title,
    required this.onSearch,
    this.hintText = 'Suchen...',
    this.actions,
    this.autoFocus = false,
    this.initialQuery,
    super.key,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _controller;
  late bool _isSearching;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _isSearching =
        widget.autoFocus || (widget.initialQuery?.isNotEmpty ?? false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _controller.clear();
      widget.onSearch('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _controller,
              autofocus: widget.autoFocus,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
              onChanged: widget.onSearch,
            )
          : Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
      leading: _isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stopSearch,
              tooltip: 'Suche beenden',
            )
          : null,
      actions: _isSearching
          ? [
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                  tooltip: 'Löschen',
                ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _startSearch,
                tooltip: 'Suchen',
              ),
              ...?widget.actions,
            ],
    );
  }
}
