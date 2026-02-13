import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/providers.dart';
import '../../../config/router.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class LeagueStandingsPage extends ConsumerStatefulWidget {
  final String leagueId;

  const LeagueStandingsPage({required this.leagueId, super.key});

  @override
  ConsumerState<LeagueStandingsPage> createState() =>
      _LeagueStandingsPageState();
}

class _LeagueStandingsPageState extends ConsumerState<LeagueStandingsPage> {
  int? selectedMatchDay;

  static const int maxMatchDays = 34; // Bundesliga season has 34 matchdays

  @override
  Widget build(BuildContext context) {
    final totalRankingAsync = ref.watch(
      leagueRankingProvider((leagueId: widget.leagueId, matchDay: null)),
    );
    final totalMatchDay = totalRankingAsync.asData?.value['day'] as int?;
    final resolvedMatchDay = selectedMatchDay ?? totalMatchDay;
    final AsyncValue<Map<String, dynamic>> matchdayRankingAsync =
        resolvedMatchDay == null
        ? const AsyncValue.loading()
        : ref.watch(
            leagueRankingProvider((
              leagueId: widget.leagueId,
              matchDay: resolvedMatchDay,
            )),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rangliste'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(
                leagueRankingProvider((
                  leagueId: widget.leagueId,
                  matchDay: null,
                )),
              );
              if (resolvedMatchDay != null) {
                ref.invalidate(
                  leagueRankingProvider((
                    leagueId: widget.leagueId,
                    matchDay: resolvedMatchDay,
                  )),
                );
              }
            },
          ),
        ],
      ),
      body: totalRankingAsync.when(
        data: (rankingData) {
          final totalUsers = _sortedUsers(rankingData['us'], matchDay: false);
          final currentUserAsync = ref.watch(currentUserProvider);

          return ResponsiveLayout(
            mobile: _buildMobileLayout(
              context,
              currentUserAsync,
              totalUsers,
              matchdayRankingAsync,
              resolvedMatchDay,
            ),
            tablet: _buildTabletLayout(
              context,
              currentUserAsync,
              totalUsers,
              matchdayRankingAsync,
              resolvedMatchDay,
            ),
            desktop: _buildDesktopLayout(
              context,
              currentUserAsync,
              totalUsers,
              matchdayRankingAsync,
              resolvedMatchDay,
            ),
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(
              leagueRankingProvider((
                leagueId: widget.leagueId,
                matchDay: null,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AsyncValue currentUserAsync,
    List<Map<String, dynamic>> totalUsers,
    AsyncValue<Map<String, dynamic>> matchdayRankingAsync,
    int? matchDay,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader('Gesamtpunkte'),
          _buildMobileUserList(
            context,
            currentUserAsync,
            totalUsers,
            false,
            null,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(_matchDayTitle(matchDay)),
          _buildMatchDaySelector(context, matchDay),
          matchdayRankingAsync.when(
            data: (rankingData) {
              final users = _sortedUsers(rankingData['us'], matchDay: true);
              return _buildMobileUserList(
                context,
                currentUserAsync,
                users,
                true,
                matchDay,
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: LoadingWidget(),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(
                  leagueRankingProvider((
                    leagueId: widget.leagueId,
                    matchDay: matchDay,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    AsyncValue currentUserAsync,
    List<Map<String, dynamic>> totalUsers,
    AsyncValue<Map<String, dynamic>> matchdayRankingAsync,
    int? matchDay,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader('Gesamtpunkte'),
          _buildTabletUserList(
            context,
            currentUserAsync,
            totalUsers,
            false,
            null,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(_matchDayTitle(matchDay)),
          _buildMatchDaySelector(context, matchDay),
          matchdayRankingAsync.when(
            data: (rankingData) {
              final users = _sortedUsers(rankingData['us'], matchDay: true);
              return _buildTabletUserList(
                context,
                currentUserAsync,
                users,
                true,
                matchDay,
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: LoadingWidget(),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(
                  leagueRankingProvider((
                    leagueId: widget.leagueId,
                    matchDay: matchDay,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AsyncValue currentUserAsync,
    List<Map<String, dynamic>> totalUsers,
    AsyncValue<Map<String, dynamic>> matchdayRankingAsync,
    int? matchDay,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader('Gesamtpunkte'),
          _buildDesktopTable(
            context,
            currentUserAsync,
            totalUsers,
            false,
            null,
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(_matchDayTitle(matchDay)),
          _buildMatchDaySelector(context, matchDay),
          matchdayRankingAsync.when(
            data: (rankingData) {
              final users = _sortedUsers(rankingData['us'], matchDay: true);
              return _buildDesktopTable(
                context,
                currentUserAsync,
                users,
                true,
                matchDay,
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: LoadingWidget(),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(
                  leagueRankingProvider((
                    leagueId: widget.leagueId,
                    matchDay: matchDay,
                  )),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _matchDayTitle(int? matchDay) {
    if (matchDay == null) {
      return 'Spieltag';
    }
    return 'Spieltag $matchDay';
  }

  List<Map<String, dynamic>> _sortedUsers(
    dynamic rawUsers, {
    required bool matchDay,
  }) {
    final users = (rawUsers as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    users.sort((a, b) {
      final aPoints = _getPoints(a, matchDay: matchDay);
      final bPoints = _getPoints(b, matchDay: matchDay);
      return bPoints.compareTo(aPoints);
    });
    return users;
  }

  int _getPoints(Map<String, dynamic> user, {required bool matchDay}) {
    if (matchDay) {
      return user['mdp'] ?? user['sp'] ?? 0;
    }
    return user['sp'] ?? 0;
  }

  Widget _buildMobileUserList(
    BuildContext context,
    AsyncValue currentUserAsync,
    List<Map<String, dynamic>> users,
    bool matchDay,
    int? matchDayNumber,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isCurrentUser =
            currentUserAsync.value != null &&
            user['i'] == currentUserAsync.value!.i;
        final points = _getPoints(user, matchDay: matchDay);

        return _buildUserCard(
          context,
          user,
          index + 1,
          isCurrentUser,
          points,
          matchDay,
          matchDayNumber,
        );
      },
    );
  }

  Widget _buildTabletUserList(
    BuildContext context,
    AsyncValue currentUserAsync,
    List<Map<String, dynamic>> users,
    bool matchDay,
    int? matchDayNumber,
  ) {
    return ResponsiveContainer(
      tabletMaxWidth: 900,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final isCurrentUser =
              currentUserAsync.value != null &&
              user['i'] == currentUserAsync.value!.i;
          final points = _getPoints(user, matchDay: matchDay);

          return _buildStandingCard(
            context,
            user,
            index + 1,
            isCurrentUser,
            points,
            matchDay,
            matchDayNumber,
          );
        },
      ),
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    AsyncValue currentUserAsync,
    List<Map<String, dynamic>> users,
    bool matchDay,
    int? matchDayNumber,
  ) {
    final pointsLabel = matchDay ? 'Spieltag' : 'Punkte';

    return ResponsiveContainer(
      desktopMaxWidth: 1200,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Card(
          child: DataTable(
            columns: [
              const DataColumn(label: Text('Pos')),
              const DataColumn(label: Text('Manager')),
              DataColumn(label: Text(pointsLabel), numeric: true),
              const DataColumn(label: Text('Teamwert'), numeric: true),
            ],
            rows: users.asMap().entries.map<DataRow>((entry) {
              final index = entry.key;
              final user = entry.value;
              final position = index + 1;
              final name = user['n'] ?? 'Unbekannt';
              final points = _getPoints(user, matchDay: matchDay);
              final teamValue = user['tv'] ?? 0;
              final isCurrentUser =
                  currentUserAsync.value != null &&
                  user['i'] == currentUserAsync.value!.i;

              return DataRow(
                onSelectChanged: (selected) {
                  if (selected == true) {
                    final userId = user['i'] ?? '';
                    _handleUserTap(
                      context,
                      userId,
                      matchDay: matchDay,
                      matchDayNumber: matchDayNumber,
                    );
                  }
                },
                color: isCurrentUser
                    ? WidgetStateProperty.all(
                        Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
                  DataCell(Text('$points')),
                  DataCell(
                    Text('${(teamValue / 1000000).toStringAsFixed(1)}M€'),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
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
            hint: const Text('Aktuell'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Aktuell')),
              ...List.generate(maxMatchDays, (index) {
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

  Widget _buildUserCard(
    BuildContext context,
    Map<String, dynamic> user,
    int position,
    bool isCurrentUser,
    int points,
    bool matchDay,
    int? matchDayNumber,
  ) {
    final name = user['n'] ?? 'Unbekannt';
    final teamValue = user['tv'] ?? 0;
    final userId = user['i'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: isCurrentUser
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        onTap: () {
          if (userId.isNotEmpty) {
            _handleUserTap(
              context,
              userId,
              matchDay: matchDay,
              matchDayNumber: matchDayNumber,
            );
          }
        },
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
        subtitle: const Text(''),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$points Pkt',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${(teamValue / 1000000).toStringAsFixed(1)}M€',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandingCard(
    BuildContext context,
    Map<String, dynamic> user,
    int position,
    bool isCurrentUser,
    int points,
    bool matchDay,
    int? matchDayNumber,
  ) {
    final name = user['n'] ?? 'Unbekannt';
    final teamValue = user['tv'] ?? 0;
    final userId = user['i'] ?? '';

    return ResponsiveCard(
      color: isCurrentUser
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: () {
          if (userId.isNotEmpty) {
            _handleUserTap(
              context,
              userId,
              matchDay: matchDay,
              matchDayNumber: matchDayNumber,
            );
          }
        },
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
                      fontWeight: isCurrentUser
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
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
      ),
    );
  }

  void _handleUserTap(
    BuildContext context,
    String userId, {
    required bool matchDay,
    required int? matchDayNumber,
  }) {
    if (matchDay && matchDayNumber != null) {
      context.push(
        '/manager/${widget.leagueId}/$userId?matchDay=$matchDayNumber',
      );
    } else {
      context.goToManager(widget.leagueId, userId);
    }
  }
}
