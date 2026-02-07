import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/kickbase_auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text('Möchten Sie sich wirklich von Kickbase abmelden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(kickbaseAuthProvider.notifier).logout();
      // Router redirect happens automatically
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(kickbaseAuthProvider);
    final currentUser = authState.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          // Profile Section with Kickbase user info
          Card(
            margin: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(currentUser?.n ?? 'Kickbase Benutzer'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentUser?.tn != null && currentUser!.tn.isNotEmpty)
                    Text('Team: ${currentUser.tn}'),
                  if (currentUser?.em != null && currentUser!.em.isNotEmpty)
                    Text(currentUser.em),
                ],
              ),
              isThreeLine: currentUser != null,
            ),
          ),

          // Settings Sections
          _SettingsSection(
            title: 'Allgemein',
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Benachrichtigungen'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Toggle notifications
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Sprache'),
                subtitle: const Text('Deutsch'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Change language
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // TODO: Toggle dark mode
                  },
                ),
              ),
            ],
          ),

          _SettingsSection(
            title: 'Über',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Datenschutz'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text('Nutzungsbedingungen'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show terms
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton.icon(
              onPressed: authState.isLoading
                  ? null
                  : () => _showLogoutDialog(context, ref),
              icon: authState.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout),
              label: Text(authState.isLoading ? 'Abmelden...' : 'Abmelden'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ),

          // Kickbase Account Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Verbunden mit Kickbase',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: children),
        ),
      ],
    );
  }
}
