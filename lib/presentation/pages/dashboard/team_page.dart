import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/screen_size.dart';
import '../../screens/squad_screen.dart';
import '../../screens/live_screen.dart';
import 'lineup_page.dart';

/// Team Page with tabs for Kader, Empfohlene Aufstellung, Verkaufen, and Live
class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Team'),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Kader', icon: Icon(Icons.people)),
                  Tab(text: 'Empfohlene Aufstellung', icon: Icon(Icons.auto_awesome)),
                  Tab(text: 'Verkaufen', icon: Icon(Icons.remove_shopping_cart)),
                  Tab(text: 'Live', icon: Icon(Icons.sports_soccer)),
                ],
              ),
            )
          : AppBar(
              title: const Text('Team'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Kader', icon: Icon(Icons.people)),
                  Tab(text: 'Empfohlene Aufstellung', icon: Icon(Icons.auto_awesome)),
                  Tab(text: 'Verkaufen', icon: Icon(Icons.remove_shopping_cart)),
                  Tab(text: 'Live', icon: Icon(Icons.sports_soccer)),
                ],
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SquadScreen(), // Kader
          LineupPage(), // Empfohlene Aufstellung
          _SellTab(), // Verkaufen
          LiveScreen(), // Live
        ],
      ),
    );
  }
}

/// Sell Tab - placeholder for selling players
class _SellTab extends ConsumerWidget {
  const _SellTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_shopping_cart,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Verkaufen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Hier kannst du Spieler verkaufen',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
