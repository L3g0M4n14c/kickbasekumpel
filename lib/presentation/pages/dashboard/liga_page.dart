import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../screens/league_table_screen.dart';

/// Liga Page with tab for Tabelle
class LigaPage extends ConsumerStatefulWidget {
  const LigaPage({super.key});

  @override
  ConsumerState<LigaPage> createState() => _LigaPageState();
}

class _LigaPageState extends ConsumerState<LigaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
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
              title: const Text('Liga'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tabelle', icon: Icon(Icons.table_chart)),
                ],
              ),
            )
          : AppBar(
              title: const Text('Liga'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tabelle', icon: Icon(Icons.table_chart)),
                ],
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LeagueTableScreen(competitionId: '1'), // Bundesliga table
        ],
      ),
    );
  }
}
