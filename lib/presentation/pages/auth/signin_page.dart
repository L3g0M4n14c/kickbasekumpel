import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/kickbase_auth_provider.dart';
import '../../../data/services/demo_kickbase_api_client.dart';
import '../../../config/app_theme.dart';
import '../../widgets/common/app_logo.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(kickbaseAuthProvider.notifier);
    final success = await notifier.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navigation happens automatically via router redirect
      context.go('/dashboard');
    }
  }

  Future<void> _handleDemoLogin() async {
    final notifier = ref.read(kickbaseAuthProvider.notifier);
    final success = await notifier.login(
      email: DemoKickbaseAPIClient.demoEmail,
      password: DemoKickbaseAPIClient.demoPassword,
    );
    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(kickbaseAuthProvider);
    final theme = Theme.of(context);

    // Show error as SnackBar when error state changes
    ref.listen<KickbaseAuthState>(kickbaseAuthProvider, (previous, next) {
      if (next.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Clear error after showing
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(kickbaseAuthProvider.notifier).clearError();
          }
        });
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _SignInHero(),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Anpfiff!', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(
                          'Melde dich mit deinem Kickbase-Account an.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // E-Mail + Passwort in einer gemeinsamen AutofillGroup,
                        // damit Passwort-Manager beide Felder als Login-Formular
                        // erkennen und automatisch ausfüllen können.
                        AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email Field
                              TextFormField(
                                controller: _emailController,
                                autofillHints: const [
                                  AutofillHints.username,
                                  AutofillHints.email,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Kickbase E-Mail',
                                  hintText: 'deine@email.de',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                enabled: !authState.isLoading,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Bitte E-Mail eingeben';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Bitte gültige E-Mail eingeben';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                autofillHints: const [AutofillHints.password],
                                decoration: const InputDecoration(
                                  labelText: 'Kickbase Passwort',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                enabled: !authState.isLoading,
                                onFieldSubmitted: (_) => _handleLogin(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Bitte Passwort eingeben';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Sign In Button
                        FilledButton(
                          onPressed: authState.isLoading ? null : _handleLogin,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: authState.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : const Text('Mit Kickbase anmelden'),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Demo-Button
                        OutlinedButton.icon(
                          onPressed: authState.isLoading
                              ? null
                              : _handleDemoLogin,
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Demo ausprobieren'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Info Text
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer
                                .withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 20,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Verwende deine Zugangsdaten von kickbase.com',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Kickbase Website Link
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Open kickbase.com in browser
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Öffne kickbase.com im Browser'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text('Noch kein Kickbase-Account?'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fröhlicher Kopfbereich der Login-Seite: Rasen-Verlauf, Logo im
/// Sonnengelb-Ring und Claim.
class _SignInHero extends StatelessWidget {
  const _SignInHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, topPadding + 40, 24, 36),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient(theme.colorScheme),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.xxl + 8),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppColors.sun,
              shape: BoxShape.circle,
            ),
            child: const AppLogo(size: 84, scale: 1),
          ),
          const SizedBox(height: 20),
          Text(
            'KickbaseKumpel',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Dein Kumpel für Markt, Aufstellung & Punkte',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
