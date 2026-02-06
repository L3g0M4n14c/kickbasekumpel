import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/firebase_config.dart';
import 'config/router.dart';
import 'config/theme.dart';

// DEBUG MODE - Set to true to bypass auth and see UI
const bool kDebugMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kDebugMode) {
    await FirebaseConfig.initialize();
  }

  runApp(const ProviderScope(child: KickbaseKumpelApp()));
}

class KickbaseKumpelApp extends ConsumerWidget {
  const KickbaseKumpelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      return MaterialApp(
        title: 'KickbaseKumpel',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: _DebugHomePage(),
      );
    }

    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'KickbaseKumpel',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

class _DebugHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KickbaseKumpel - Debug Mode'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDebugTile(
            context,
            'Market Screen',
            Icons.shopping_cart,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _MarketScreenWrapper()),
            ),
          ),
          _buildDebugTile(
            context,
            'Dashboard',
            Icons.dashboard,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _DashboardWrapper()),
            ),
          ),
          _buildDebugTile(
            context,
            'Widget Gallery',
            Icons.widgets,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const _WidgetGalleryWrapper()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class _MarketScreenWrapper extends ConsumerWidget {
  const _MarketScreenWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Market Screen würde hier angezeigt\n\n'
          'Benötigt Auth & Providers',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class _DashboardWrapper extends ConsumerWidget {
  const _DashboardWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
        child: Text(
          'Dashboard würde hier angezeigt\n\n'
          'Benötigt Auth & Providers',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class _WidgetGalleryWrapper extends StatelessWidget {
  const _WidgetGalleryWrapper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Buttons',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Elevated Button'),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: () {}, child: const Text('Filled Button')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            child: const Text('Outlined Button'),
          ),
          const SizedBox(height: 24),

          const Text(
            'Cards',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('This is a sample card with some content.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
