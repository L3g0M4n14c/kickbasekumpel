import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/screen_size.dart';
import '../../widgets/common/app_logo.dart';

/// Dashboard Shell mit responsiver Navigation
/// - Mobile: BottomNavigationBar
/// - Tablet: NavigationDrawer
/// - Desktop: NavigationRail (Sidebar)
class DashboardShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({required this.navigationShell, super.key});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ScreenSize.isMobile(context)) {
      return _buildMobileLayout(context);
    } else if (ScreenSize.isTablet(context)) {
      return _buildTabletLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  /// Mobile Layout: Bottom Navigation Bar
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Team',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Markt',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Liga',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_soccer),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Ligainsider',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
      ),
    );
  }

  /// Tablet Layout: Navigation Drawer
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getPageTitle()), elevation: 0),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppLogo(size: 48, backgroundColor: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Kickbase Kumpel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, 0, Icon(Icons.people), 'Team'),
            _buildDrawerItem(context, 1, Icon(Icons.store), 'Markt'),
            _buildDrawerItem(context, 2, Icon(Icons.emoji_events), 'Liga'),
            _buildDrawerItem(context, 3, Icon(Icons.sports_soccer), 'Ligainsider'),
            const Divider(),
            _buildDrawerItem(context, 4, Icon(Icons.settings), 'Einstellungen'),
          ],
        ),
      ),
      body: navigationShell,
    );
  }

  /// Desktop Layout: Navigation Rail (Sidebar)
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: AppLogo(size: 48),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Team'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store),
                label: Text('Markt'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: Text('Liga'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sports_soccer),
                selectedIcon: Icon(Icons.sports_soccer),
                label: Text('Ligainsider'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Einstellungen'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    int index,
    Widget icon,
    String title,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    return ListTile(
      leading: icon,
      title: Text(title),
      selected: isSelected,
      onTap: () {
        _onDestinationSelected(index);
        Navigator.pop(context); // Close drawer
      },
    );
  }

  String _getPageTitle() {
    switch (navigationShell.currentIndex) {
      case 0:
        return 'Team';
      case 1:
        return 'Markt';
      case 2:
        return 'Liga';
      case 3:
        return 'Ligainsider';
      case 4:
        return 'Einstellungen';
      default:
        return 'Kickbase Kumpel';
    }
  }
}
