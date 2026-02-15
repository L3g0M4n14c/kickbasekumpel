import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'firebase_options.dart';

final _logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup global error handlers
  FlutterError.onError = (FlutterErrorDetails details) {
    _logger.e('Flutter Error: ${details.exception}', stackTrace: details.stack);
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _logger.e('Platform Error: $error', stackTrace: stack);
    return true;
  };

  // Initialize Firebase BEFORE building the app (critical for startup)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _logger.i('Firebase initialized successfully');
  } catch (e, stackTrace) {
    _logger.e('Firebase initialization error: $e', stackTrace: stackTrace);
    if (kDebugMode) {
      // In debug mode, show error dialog
      runApp(const ProviderScope(child: FirebaseErrorApp()));
      return;
    }
  }

  runApp(const ProviderScope(child: KickbaseKumpelApp()));
}

/// Fallback app shown when Firebase fails to initialize
class FirebaseErrorApp extends StatelessWidget {
  const FirebaseErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Initialization Error')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Firebase Initialization Failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Check logs for details. Make sure GoogleService-Info.plist is properly installed.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KickbaseKumpelApp extends ConsumerWidget {
  const KickbaseKumpelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'KickbaseKumpel',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
