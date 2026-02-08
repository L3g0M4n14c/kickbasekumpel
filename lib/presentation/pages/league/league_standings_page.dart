import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/providers.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class LeagueStandingsPage extends ConsumerStatefulWidget {
  final String leagueId;

  const LeagueStandingsPage({required this.leagueId, super.key});

  @override
  ConsumerState<LeagueStandingsPage> createState() => _LeagueStandingsPageState();
}

class _LeagueStandingsPageState extends ConsumerState<LeagueStandingsPage> {
  int? selectedMatchDay;

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final rankingAsync = ref.watch(
      leagueRankingProvider((leagueId: widget.leagueId, matchDay: selectedMatchDay)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rangliste'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(
                leagueRankingProvider((leagueId: widget.leagueId, matchDay: selectedMatchDay)),
              );
            },
          ),
        ],
      ),
      body: rankingAsync.when(
        data: (rankingData) {
          final users = rankingData['u'] as List? ?? [];
          final matchDay = rankingData['md'] as int?;

          return ResponsiveLayout(
            mobile: _buildMobileLayout(context, currentUserAsync, users, matchDay),
            tablet: _buildTabletLayout(context, currentUserAsync, users, matchDay),
            desktop: _buildDesktopLayout(context, currentUserAsync, users, matchDay),
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(
              leagueRankingProvider((leagueId: widget.leagueId, matchDay: selectedMatchDay)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AsyncValue currentUserAsync,
    List users,
    int? matchDay,
  ) {
    return Column(
      children: [
        _buildMatchDaySelector(context, matchDay),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final isCurrentUser = currentUserAsync.value != null &&
                  user['i'] == currentUserAsync.value!.i;

              return _buildUserCard(context, user, isCurrentUser);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AsyncValue currentUserAsync,
    List users,
    int? matchDay,
  ) {
    return Column(
      children: [
        _buildMatchDaySelector(context, matchDay),
        Expanded(
          child: ResponsiveContainer(
            tabletMaxWidth: 900,
            child: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isCurrentUser = currentUserAsync.value != null &&
                    user['i'] == currentUserAsync.value!.i;
                return _buildStandingCard(context, user, isCurrentUser);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AsyncValue currentUserAsync,
    List users,
    int? matchDay,
  ) {
    return Column(
      children: [
        _buildMatchDaySelector(context, matchDay),
        Expanded(
          child: ResponsiveContainer(
            desktopMaxWidth: 1200,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Pos')),
                    DataColumn(label: Text('Manager')),
                    DataColumn(label: Text('Team')),
                    DataColumn(label: Text('Punkte'), numeric: true),
                    DataColumn(label: Text('Teamwert'), numeric: true),
                  ],
                  rows: users.map<DataRow>((user) {
                    final position = user['pl'] ?? 0;
                    final name = user['n'] ?? 'Unbekannt';
                    final teamName = user['tn'] ?? '';
                    final points = user['p'] ?? 0;
                    final teamValue = user['tv'] ?? 0;
                    final isCurrentUser = currentUserAsync.value != null &&
                        user['i'] == currentUserAsync.value!.i;

                    return DataRow(
                      color: isCurrentUser
                          ? WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                            )
                          : null,
                      cells: [
                        DataCell(
                          Text(
                            '$position',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: position <= 3 ? Colors.amber : null,
                            ),
                          ),
                        ),
                        DataCell(Text(name)),
                        DataCell(Text(teamName)),
                        DataCell(Text('$points')),
                        DataCell(Text('${(teamValue / 1000000).toStringAsFixed(1)}M€')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchDaySelector(BuildContext context, int? currentMatchDay) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          const Text('Spieltag: '),
          const SizedBox(width: 8),
          DropdownButton<int?>(
            value: selectedMatchDay,
            hint: Text('Aktuell${currentMatchDay != null ? " ($currentMatchDay)" : ""}'),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Aktuell'),
              ),
              ...List.generate(34, (index) {
                final day = index + 1;
                return DropdownMenuItem(
                  value: day,
                  child: Text('$day. Spieltag'),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                selectedMatchDay = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user, bool isCurrentUser) {
    final position = user['pl'] ?? 0;
    final name = user['n'] ?? 'Unbekannt';
    final teamName = user['tn'] ?? '';
    final points = user['p'] ?? 0;
    final teamValue = user['tv'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: isCurrentUser
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: position <= 3
              ? Colors.amber
              : Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '$position',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: position <= 3 ? Colors.white : null,
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(teamName),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$points Pkt',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${(teamValue / 1000000).toStringAsFixed(1)}M€',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandingCard(BuildContext context, Map<String, dynamic> user, bool isCurrentUser) {
    final position = user['pl'] ?? 0;
    final name = user['n'] ?? 'Unbekannt';
    final teamName = user['tn'] ?? '';
    final points = user['p'] ?? 0;
    final teamValue = user['tv'] ?? 0;

    return ResponsiveCard(
      color: isCurrentUser
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: position <= 3
                ? Colors.amber
                : Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              '$position',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: position <= 3 ? Colors.white : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  teamName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$points Pkt',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '${(teamValue / 1000000).toStringAsFixed(1)}M€',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
