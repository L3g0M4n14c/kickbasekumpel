import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/providers.dart';
import '../../../config/router.dart';
import '../../providers/manager_comparison_providers.dart';
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
    final comparisonSelection = ref.watch(managerComparisonSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rangliste'),
        actions: [
          IconButton(
            icon: Icon(
              comparisonSelection.active ? Icons.close : Icons.compare_arrows,
            ),
            tooltip: comparisonSelection.active
                ? 'Auswahl beenden'
                : 'Manager vergleichen',
            onPressed: () => ref
                .read(managerComparisonSelectionProvider.notifier)
                .toggleActive(),
          ),
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
      bottomNavigationBar: comparisonSelection.active
          ? _buildComparisonBar(context, comparisonSelection)
          : null,
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
              final name = (user['n'] ?? 'Unbekannt') as String;
              final uim = user['uim'] as String?;
              final points = _getPoints(user, matchDay: matchDay);
              final teamValue = user['tv'] ?? 0;
              final isCurrentUser =
                  currentUserAsync.value != null &&
                  user['i'] == currentUserAsync.value!.i;
              final userId = user['i'] ?? '';
              final isSelected = ref
                  .watch(managerComparisonSelectionProvider)
                  .contains(userId);

              return DataRow(
                onSelectChanged: (selected) {
                  if (selected == true) {
                    _handleUserTap(
                      context,
                      userId,
                      matchDay: matchDay,
                      matchDayNumber: matchDayNumber,
                    );
                  }
                },
                color: isSelected
                    ? WidgetStateProperty.all(
                        Theme.of(context).colorScheme.secondaryContainer,
                      )
                    : isCurrentUser
                    ? WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
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
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildManagerPhotoAvatar(
                          context,
                          uim,
                          name,
                          radius: 14,
                        ),
                        const SizedBox(width: 8),
                        Text(name),
                      ],
                    ),
                  ),
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

  Widget _buildManagerPhotoAvatar(
    BuildContext context,
    String? uim,
    String name, {
    double radius = 20,
  }) {
    final photoUrl = uim != null && uim.isNotEmpty
        ? 'https://kickbase.b-cdn.net/$uim'
        : null;
    if (photoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.8,
              ),
            ),
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: radius * 0.8),
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
    final name = (user['n'] ?? 'Unbekannt') as String;
    final teamValue = user['tv'] ?? 0;
    final userId = user['i'] ?? '';
    final uim = user['uim'] as String?;
    final isSelected = ref
        .watch(managerComparisonSelectionProvider)
        .contains(userId);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: isSelected
          ? Theme.of(context).colorScheme.secondaryContainer
          : isCurrentUser
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            )
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
        onLongPress: userId.isNotEmpty
            ? () => _handleUserLongPress(userId)
            : null,
        leading: SizedBox(
          width: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '$position',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: position <= 3 ? Colors.amber[700] : null,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _buildManagerPhotoAvatar(context, uim, name, radius: 18),
            ],
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: null,
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
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.grey),
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
    final name = (user['n'] ?? 'Unbekannt') as String;
    final teamValue = user['tv'] ?? 0;
    final userId = user['i'] ?? '';
    final uim = user['uim'] as String?;
    final isSelected = ref
        .watch(managerComparisonSelectionProvider)
        .contains(userId);

    return ResponsiveCard(
      color: isSelected
          ? Theme.of(context).colorScheme.secondaryContainer
          : isCurrentUser
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
        onLongPress: userId.isNotEmpty
            ? () => _handleUserLongPress(userId)
            : null,
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$position',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: position <= 3 ? Colors.amber[700] : null,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildManagerPhotoAvatar(context, uim, name, radius: 22),
            const SizedBox(width: 12),
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
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Colors.grey),
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
    // Im Auswahlmodus wählt der Tap den Manager für den Direktvergleich ab/zu.
    final selectionNotifier = ref.read(
      managerComparisonSelectionProvider.notifier,
    );
    if (ref.read(managerComparisonSelectionProvider).active) {
      selectionNotifier.toggle(userId);
      return;
    }

    if (matchDay && matchDayNumber != null) {
      context.push(
        '/manager/${widget.leagueId}/$userId?matchDay=$matchDayNumber',
      );
    } else {
      context.goToManager(widget.leagueId, userId);
    }
  }

  /// Long-Press: Auswahlmodus aktivieren und den Manager direkt auswählen.
  void _handleUserLongPress(String userId) {
    final selectionNotifier = ref.read(
      managerComparisonSelectionProvider.notifier,
    );
    if (!ref.read(managerComparisonSelectionProvider).active) {
      selectionNotifier.toggleActive();
    }
    selectionNotifier.toggle(userId);
  }

  /// Aktionsleiste im Auswahlmodus: Auswahl-Status + Vergleich starten.
  ///
  /// Mit einem ausgewählten Manager wird „Du vs. Rivale" verglichen, mit
  /// zweien die beiden Ausgewählten.
  Widget _buildComparisonBar(
    BuildContext context,
    ManagerComparisonSelection selection,
  ) {
    final currentUserId = ref.read(currentUserDataProvider)?.i;
    final ids = selection.selectedIds;
    final canCompare =
        ids.length == 2 ||
        (ids.length == 1 &&
            currentUserId != null &&
            ids.first != currentUserId);

    final String hint;
    if (ids.isEmpty) {
      hint = 'Manager antippen zum Auswählen (max. 2)';
    } else if (ids.length == 1) {
      hint = ids.first == currentUserId
          ? 'Du gewählt – jetzt den Rivalen antippen'
          : '1 Manager gewählt – Vergleich startet „Du vs. Rivale"';
    } else {
      hint = '2 Manager gewählt';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(hint, style: Theme.of(context).textTheme.bodyMedium),
            ),
            TextButton(
              onPressed: ids.isEmpty
                  ? null
                  : () => ref
                        .read(managerComparisonSelectionProvider.notifier)
                        .clear(),
              child: const Text('Leeren'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: canCompare ? () => _startComparison(context) : null,
              icon: const Icon(Icons.compare_arrows),
              label: const Text('Vergleichen'),
            ),
          ],
        ),
      ),
    );
  }

  /// Startet den Direktvergleich für die aktuelle Auswahl.
  ///
  /// Der eigene Manager wird dabei – falls beteiligt – als Seite A („Du")
  /// geführt; mit nur einem (fremden) Auswahl wird „Du vs. Rivale"
  /// verglichen.
  void _startComparison(BuildContext context) {
    final selection = ref.read(managerComparisonSelectionProvider);
    final currentUserId = ref.read(currentUserDataProvider)?.i;
    final ids = selection.selectedIds;

    String? managerAId;
    String? managerBId;
    if (ids.length == 2) {
      if (currentUserId != null && ids.contains(currentUserId)) {
        managerAId = currentUserId;
        managerBId = ids.firstWhere((id) => id != currentUserId);
      } else {
        managerAId = ids.first;
        managerBId = ids.last;
      }
    } else if (ids.length == 1 &&
        currentUserId != null &&
        ids.first != currentUserId) {
      managerAId = currentUserId;
      managerBId = ids.first;
    }

    if (managerAId == null || managerBId == null) return;

    ref.read(managerComparisonSelectionProvider.notifier).deactivate();
    context.goToManagerComparison(widget.leagueId, managerAId, managerBId);
  }
}
