import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Dashboard Screen
///
/// Hauptscreen mit Bottom Navigation für die App-Hauptfunktionen.
/// Verwaltet die Navigation zwischen Home, Leagues, Market, Lineup, Transfers und Settings.
class DashboardScreen extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardScreen({required this.child, super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<_NavigationDestination> _destinations = [
    _NavigationDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      route: '/dashboard/home',
    ),
    _NavigationDestination(
      icon: Icons.emoji_events_outlined,
      selectedIcon: Icons.emoji_events,
      label: 'Ligen',
      route: '/dashboard/leagues',
    ),
    _NavigationDestination(
      icon: Icons.store_outlined,
      selectedIcon: Icons.store,
      label: 'Markt',
      route: '/dashboard/market',
    ),
    _NavigationDestination(
      icon: Icons.group_outlined,
      selectedIcon: Icons.group,
      label: 'Aufstellung',
      route: '/dashboard/lineup',
    ),
    _NavigationDestination(
      icon: Icons.swap_horiz,
      selectedIcon: Icons.swap_horiz,
      label: 'Transfers',
      route: '/dashboard/transfers',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
    context.go(_destinations[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: isTablet
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: _destinations
                  .map(
                    (dest) => NavigationDestination(
                      icon: Icon(dest.icon),
                      selectedIcon: Icon(dest.selectedIcon),
                      label: dest.label,
                    ),
                  )
                  .toList(),
            ),
      drawer: isTablet
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'KickbaseKumpel',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Einstellungen'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/dashboard/settings');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Hilfe'),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to help screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Über'),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Show about dialog
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _NavigationDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
