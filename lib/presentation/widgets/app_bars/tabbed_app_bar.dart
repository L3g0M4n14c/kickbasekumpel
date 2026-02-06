import 'package:flutter/material.dart';

/// Tabbed AppBar für KickbaseKumpel
///
/// AppBar mit integrierten Tabs für Navigation zwischen verschiedenen Views.
///
/// **Verwendung:**
/// ```dart
/// TabbedAppBar(
///   title: 'Statistiken',
///   tabs: ['Punkte', 'Marktwert', 'Trend'],
///   onTabChanged: (index) => // Handle tab change
/// )
/// ```
class TabbedAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Titel der AppBar
  final String title;

  /// Liste der Tab-Titel
  final List<String> tabs;

  /// Callback wenn Tab gewechselt wird
  final ValueChanged<int>? onTabChanged;

  /// TabController (optional, wird automatisch erstellt wenn nicht übergeben)
  final TabController? controller;

  /// Optionale Aktionen
  final List<Widget>? actions;

  /// Zeigt Zurück-Button
  final bool showBackButton;

  const TabbedAppBar({
    required this.title,
    required this.tabs,
    this.onTabChanged,
    this.controller,
    this.actions,
    this.showBackButton = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Zurück',
            )
          : null,
      actions: actions,
      bottom: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => Tab(text: tab, height: 48)).toList(),
        onTap: onTabChanged,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);
}
