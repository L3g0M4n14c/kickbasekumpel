# Firebase Authentication - Usage Examples

## Setup

Stelle sicher, dass deine `main.dart` die Firebase und Riverpod Provider initialisiert:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

## 1. Sign In Screen - Vollständiges Beispiel

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Navigation zur Home-Screen
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Error wird automatisch vom authNotifierProvider verwaltet
      // und im UI angezeigt (siehe unten)
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Zeige Error Message wenn vorhanden
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        // Clear message nach Anzeige
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
      
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anmelden'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte E-Mail eingeben';
                  }
                  if (!value.contains('@')) {
                    return 'Ungültige E-Mail-Adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Passwort',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Passwort eingeben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _signIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Anmelden'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: const Text('Noch kein Konto? Registrieren'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/forgot-password');
                },
                child: const Text('Passwort vergessen?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 2. Sign Up Screen - Vollständiges Beispiel

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _displayNameController.text.trim().isEmpty 
          ? null 
          : _displayNameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
      
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Name (optional)',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte E-Mail eingeben';
                  }
                  if (!value.contains('@')) {
                    return 'Ungültige E-Mail-Adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Passwort',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Passwort eingeben';
                  }
                  if (value.length < 6) {
                    return 'Passwort muss mindestens 6 Zeichen haben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Passwort bestätigen',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Passwort bestätigen';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwörter stimmen nicht überein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Registrieren'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Bereits ein Konto? Anmelden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 3. Auth State Checker - Route Guard

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class AuthStateChecker extends ConsumerWidget {
  const AuthStateChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User ist angemeldet -> Home Screen
          return const HomeScreen();
        } else {
          // User ist nicht angemeldet -> Sign In Screen
          return const SignInScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Fehler: $error'),
        ),
      ),
    );
  }
}
```

## 4. User Profile Widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class UserProfileWidget extends ConsumerWidget {
  const UserProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName = ref.watch(userDisplayNameProvider);
    final email = ref.watch(userEmailProvider);
    final photoUrl = ref.watch(userPhotoUrlProvider);

    if (user == null) {
      return const Text('Nicht angemeldet');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (photoUrl != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(photoUrl),
              )
            else
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
            const SizedBox(height: 16),
            Text(
              displayName ?? 'Kein Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              email ?? 'Keine E-Mail',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 5. Sign Out Button

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return ElevatedButton.icon(
      onPressed: authState.isLoading
          ? null
          : () async {
              final authNotifier = ref.read(authNotifierProvider.notifier);
              final success = await authNotifier.signOut();
              
              if (!context.mounted) return;
              
              if (success) {
                Navigator.of(context).pushReplacementNamed('/signin');
              }
            },
      icon: authState.isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.logout),
      label: const Text('Abmelden'),
    );
  }
}
```

## 6. Forgot Password Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => 
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('E-Mail gesendet'),
          content: const Text(
            'Wir haben dir einen Link zum Zurücksetzen deines Passworts gesendet. '
            'Bitte überprüfe dein E-Mail-Postfach.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwort zurücksetzen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Gib deine E-Mail-Adresse ein und wir senden dir einen Link '
                'zum Zurücksetzen deines Passworts.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte E-Mail eingeben';
                  }
                  if (!value.contains('@')) {
                    return 'Ungültige E-Mail-Adresse';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Link senden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 7. Protected Route Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/auth_provider.dart';

class ProtectedRoute extends ConsumerWidget {
  final Widget child;
  
  const ProtectedRoute({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      // Redirect zu Sign In
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/signin');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return child;
  }
}

// Usage:
// MaterialApp(
//   routes: {
//     '/home': (context) => const ProtectedRoute(
//       child: HomeScreen(),
//     ),
//   },
// )
```

## 8. Simple Usage in any Widget

```dart
// Check if user is signed in
final isSignedIn = ref.watch(isAuthenticatedProvider);

// Get current user
final user = ref.watch(currentUserProvider);

// Get user email
final email = ref.watch(userEmailProvider);

// Get user ID
final userId = ref.watch(userIdProvider);

// Sign out
await ref.read(authNotifierProvider.notifier).signOut();

// Sign in
await ref.read(authNotifierProvider.notifier).signIn(
  email: 'test@example.com',
  password: 'password123',
);
```

## Best Practices

1. **Nutze `ref.listen` für Side Effects** (z.B. Navigation oder SnackBars)
2. **Nutze `ref.watch` für UI Updates**
3. **Nutze `ref.read` für Events** (z.B. Button Clicks)
4. **Clear Messages nach Anzeige** um wiederholte Anzeigen zu vermeiden
5. **Check `mounted`** vor Navigation/SnackBars in async Callbacks
6. **Nutze `isLoading`** um Button States zu managen
7. **Nutze StreamProvider** für Real-time Auth State
8. **Nutze Cached User** für bessere Performance

## Testing

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('Sign in succeeds with valid credentials', () async {
    final container = ProviderContainer();
    
    final authNotifier = container.read(authNotifierProvider.notifier);
    final success = await authNotifier.signIn(
      email: 'test@example.com',
      password: 'password123',
    );
    
    expect(success, true);
    expect(container.read(isAuthenticatedProvider), true);
  });
}
```
