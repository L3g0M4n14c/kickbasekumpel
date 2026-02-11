import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/screen_size.dart';
import '../../screens/dashboard/market_screen.dart';
import '../../screens/dashboard/transfers_screen.dart';

/// Markt Page with tabs for Transfermarkt and Transfer-Tipps
class MarktPage extends ConsumerStatefulWidget {
  const MarktPage({super.key});

  @override
  ConsumerState<MarktPage> createState() => _MarktPageState();
}

class _MarktPageState extends ConsumerState<MarktPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              title: const Text('Markt'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Transfermarkt', icon: Icon(Icons.store)),
                  Tab(text: 'Transfer-Tipps', icon: Icon(Icons.lightbulb_outline)),
                ],
              ),
            )
          : AppBar(
              title: const Text('Markt'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Transfermarkt', icon: Icon(Icons.store)),
                  Tab(text: 'Transfer-Tipps', icon: Icon(Icons.lightbulb_outline)),
                ],
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MarketScreen(), // Transfermarkt
          TransfersScreen(), // Transfer-Tipps
        ],
      ),
    );
  }
}
