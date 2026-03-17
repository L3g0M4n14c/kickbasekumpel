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

  /// Mappt Branch-Index (0–8) auf NavBar-Slot (0–5).
  /// Branches 2, 6, 7, 8 (Verkaufen, Tabelle, Live, Einstellungen)
  /// landen alle auf Slot 5 = „Mehr".
  int _getNavBarIndex(int branchIndex) {
    // Slot-Reihenfolge: 0=Team, 1=Markt, 2=Lineup, 3=Insider, 4=Tipps, 5=Mehr
    // Branch-Reihen: 0=Team,1=Markt,2=Verkaufen,3=Lineup,4=Transfers,5=Ligainsider,6-8=Mehr
    const mapping = [0, 1, 5, 2, 4, 3, 5, 5, 5];
    if (branchIndex < mapping.length) return mapping[branchIndex];
    return 5;
  }

  /// Wertet einen NavBar-Tap aus und navigiert zum Branch oder öffnet das More-Sheet.
  void _onNavBarTap(int navIndex, BuildContext context) {
    switch (navIndex) {
      case 0:
        _onDestinationSelected(0); // Team
      case 1:
        _onDestinationSelected(1); // Markt
      case 2:
        _onDestinationSelected(3); // Aufstellung
      case 3:
        _onDestinationSelected(5); // Ligainsider
      case 4:
        _onDestinationSelected(4); // Transfer-Tipps
      case 5:
        _showMoreMenu(context); // Mehr
    }
  }

  /// Zeigt das „Mehr"-Bottom-Sheet mit den versteckten Tabs.
  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.sell_outlined),
              title: const Text('Verkaufen'),
              selected: navigationShell.currentIndex == 2,
              onTap: () {
                Navigator.pop(sheetContext);
                _onDestinationSelected(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard_outlined),
              title: const Text('Tabelle'),
              selected: navigationShell.currentIndex == 6,
              onTap: () {
                Navigator.pop(sheetContext);
                _onDestinationSelected(6);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_soccer_outlined),
              title: const Text('Live'),
              selected: navigationShell.currentIndex == 7,
              onTap: () {
                Navigator.pop(sheetContext);
                _onDestinationSelected(7);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Einstellungen'),
              selected: navigationShell.currentIndex == 8,
              onTap: () {
                Navigator.pop(sheetContext);
                _onDestinationSelected(8);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
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

  /// Mobile Layout: Bottom Navigation Bar (5 sichtbare Items + Mehr-Button)
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getNavBarIndex(navigationShell.currentIndex),
        onDestinationSelected: (index) => _onNavBarTap(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Team',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Markt',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Lineup',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Insider',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Tipps',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Mehr'),
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
            _buildDrawerItem(context, 0, Icon(Icons.person), 'Team'),
            _buildDrawerItem(context, 1, Icon(Icons.store), 'Markt'),
            _buildDrawerItem(context, 2, Icon(Icons.sell), 'Verkaufen'),
            _buildDrawerItem(context, 3, Icon(Icons.people), 'Aufstellung'),
            _buildDrawerItem(
              context,
              4,
              Icon(Icons.trending_up),
              'Transfer-Tipps',
            ),
            _buildDrawerItem(context, 5, Icon(Icons.list), 'Ligainsider'),
            _buildDrawerItem(context, 6, Icon(Icons.leaderboard), 'Tabelle'),
            _buildDrawerItem(context, 7, Icon(Icons.sports_soccer), 'Live'),
            _buildDrawerItem(context, 8, Icon(Icons.settings), 'Einstellungen'),
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
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: Text('Team'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store),
                label: Text('Markt'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sell_outlined),
                selectedIcon: Icon(Icons.sell),
                label: Text('Verkaufen'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Aufstellung'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.trending_up_outlined),
                selectedIcon: Icon(Icons.trending_up),
                label: Text('Transfer-Tipps'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_outlined),
                selectedIcon: Icon(Icons.list),
                label: Text('Ligainsider'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.leaderboard_outlined),
                selectedIcon: Icon(Icons.leaderboard),
                label: Text('Tabelle'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sports_soccer_outlined),
                selectedIcon: Icon(Icons.sports_soccer),
                label: Text('Live'),
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
        return 'Verkaufen';
      case 3:
        return 'Aufstellung';
      case 4:
        return 'Transfer-Tipps';
      case 5:
        return 'Ligainsider';
      case 6:
        return 'Tabelle';
      case 7:
        return 'Live';
      default:
        return 'Kickbase Kumpel';
    }
  }
}
