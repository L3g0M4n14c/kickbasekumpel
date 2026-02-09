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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_soccer),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Live',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Ligen',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Markt',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Aufstellung',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transfers',
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
            _buildDrawerItem(context, 0, Icon(Icons.home), 'Home'),
            _buildDrawerItem(context, 1, Icon(Icons.sports_soccer), 'Live'),
            _buildDrawerItem(context, 2, Icon(Icons.emoji_events), 'Ligen'),
            _buildDrawerItem(context, 3, Icon(Icons.store), 'Markt'),
            _buildDrawerItem(context, 4, Icon(Icons.people), 'Aufstellung'),
            _buildDrawerItem(context, 5, Icon(Icons.swap_horiz), 'Transfers'),
            ListTile(
              leading: Icon(Icons.sports_soccer),
              title: Text('Voraussichtliche Aufstellungen'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Ligainsider screen
                context.go('/ligainsider/lineups');
              },
            ),
            const Divider(),
            _buildDrawerItem(context, 6, Icon(Icons.settings), 'Einstellungen'),
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
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sports_soccer),
                selectedIcon: Icon(Icons.sports_soccer),
                label: Text('Live'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: Text('Ligen'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store),
                label: Text('Markt'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Aufstellung'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.swap_horiz_outlined),
                selectedIcon: Icon(Icons.swap_horiz),
                label: Text('Transfers'),
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
        return 'Home';
      case 1:
        return 'Live';
      case 2:
        return 'Ligen';
      case 3:
        return 'Markt';
      case 4:
        return 'Aufstellung';
      case 5:
        return 'Transfers';
      case 6:
        return 'Einstellungen';
      default:
        return 'Kickbase Kumpel';
    }
  }
}
