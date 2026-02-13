import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/providers.dart';
import '../../data/models/ligainsider_model.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'package:flutter/foundation.dart';

// Sortier-Modus für Live-Ansicht
enum _SortMode { position, pointsDesc, nameAsc }

/// Live-Spieltag Screen
/// Zeigt die aktuelle Aufstellung mit Live-Punkten und Auto-Refresh
class LiveScreen extends ConsumerStatefulWidget {
  const LiveScreen({super.key});

  @override
  ConsumerState<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends ConsumerState<LiveScreen> {
  Timer? _refreshTimer;
  String? _selectedLeagueId;
  _SortMode _sortMode = _SortMode.position;

  @override
  void initState() {
    super.initState();
    // Auto-Refresh alle 60 Sekunden starten
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted && _selectedLeagueId != null) {
        final _ = ref.refresh(myElevenProvider(_selectedLeagueId!));
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaguesAsync = ref.watch(userLeaguesProvider);
    // Ensure Ligainsider data is initialized (fetches in background if needed)
    ref.watch(ligainsiderInitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live-Spieltag'),
        actions: [
          // Current sort mode label + menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    _sortMode == _SortMode.position
                        ? 'Position'
                        : _sortMode == _SortMode.pointsDesc
                        ? 'Punkte'
                        : 'Name',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                PopupMenuButton<_SortMode>(
                  tooltip: 'Sortieren',
                  icon: const Icon(Icons.sort),
                  onSelected: (mode) {
                    setState(() {
                      _sortMode = mode;
                    });
                  },
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: _SortMode.position,
                      checked: _sortMode == _SortMode.position,
                      child: const Text('Nach Position'),
                    ),
                    CheckedPopupMenuItem(
                      value: _SortMode.pointsDesc,
                      checked: _sortMode == _SortMode.pointsDesc,
                      child: const Text('Nach Punkten (absteigend)'),
                    ),
                    CheckedPopupMenuItem(
                      value: _SortMode.nameAsc,
                      checked: _sortMode == _SortMode.nameAsc,
                      child: const Text('Nach Name (A-Z)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_selectedLeagueId != null) {
                final _ = ref.refresh(myElevenProvider(_selectedLeagueId!));
              }
            },
          ),
        ],
      ),
      body: leaguesAsync.when(
        data: (leagues) {
          if (leagues.isEmpty) {
            return _buildEmptyState(context);
          }

          // Auto-select erste Liga wenn noch nicht ausgewählt
          if (_selectedLeagueId == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedLeagueId = leagues[0].i;
                });
              }
            });
          }

          return Column(
            children: [
              // Liga-Auswahl
              if (leagues.length > 1)
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: _selectedLeagueId,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: leagues.map((league) {
                        return DropdownMenuItem(
                          value: league.i,
                          child: Text(league.n),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLeagueId = value;
                        });
                      },
                    ),
                  ),
                ),
              // Hinweis: Wenn Web + kein Ligainsider-Cache vorhanden
              if (kIsWeb &&
                  (ref.watch(ligainsiderCacheCountProvider).asData?.value ??
                          0) ==
                      0)
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  color: Colors.yellow[50],
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text(
                      'Ligainsider-Bilder nicht verfügbar (Web / CORS)',
                    ),
                    subtitle: const Text(
                      'Setze LIGAINSIDER_PROXY_URL oder starte App nativ.',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => ref.refresh(ligainsiderInitProvider),
                    ),
                  ),
                ),
              // Live-Punkte Anzeige
              if (_selectedLeagueId != null)
                Expanded(child: _buildLiveView(context, _selectedLeagueId!)),
            ],
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.invalidate(userLeaguesProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildLiveView(BuildContext context, String leagueId) {
    final myElevenAsync = ref.watch(myElevenProvider(leagueId));

    return RefreshIndicator(
      onRefresh: () async {
        final _ = ref.refresh(myElevenProvider(leagueId));
        // Kurze Verzögerung für besseres UX
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: myElevenAsync.when(
        data: (data) {
          // Support different API response shapes:
          // - GET /v4/leagues/{leagueId}/lineup returns 'it' (lineup items)
          // - GET /v4/leagues/{leagueId}/teamcenter/myeleven returns 'lp' (live players)
          final rawPlayers =
              (data['it'] as List?) ??
              (data['lp'] as List?) ??
              (data['players'] as List?) ??
              [];

          final players = rawPlayers.map<Map<String, dynamic>>((raw) {
            final p = Map<String, dynamic>.from(raw as Map<String, dynamic>);

            // Names: prefer fn/ln, fall back to full name 'n'
            String firstName = (p['fn'] as String?) ?? '';
            String lastName = (p['ln'] as String?) ?? '';
            final fullName = (p['n'] as String?) ?? '';
            if (firstName.isEmpty && fullName.isNotEmpty) {
              final parts = fullName.split(' ');
              firstName = parts.isNotEmpty ? parts.first : fullName;
              lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
            }

            final teamName = (p['tn'] as String?) ?? '';

            // Points
            final points = p['p'] is int
                ? p['p'] as int
                : int.tryParse('${p['p']}') ?? 0;

            // Status (s or st)
            final status = p['s'] is int
                ? p['s'] as int
                : (p['st'] is int
                      ? p['st'] as int
                      : int.tryParse('${p['st']}') ?? 0);

            // Position: ps, pos or position
            final posVal = p['ps'] ?? p['pos'] ?? p['position'] ?? 0;
            final position = posVal is int
                ? posVal
                : int.tryParse('$posVal') ?? 0;

            // Player IDs (possible keys: i or mi) and team id (tid)
            final playerId = (p['i'] ?? p['mi'])?.toString() ?? '';
            final teamId = (p['tid'] ?? p['teamId'])?.toString() ?? '';

            return {
              'i': playerId,
              'fn': firstName,
              'ln': lastName,
              'tn': teamName,
              'tid': teamId,
              'p': points,
              's': status,
              'ps': position,
            };
          }).toList();

          if (players.isEmpty) {
            return _buildNoPlayersState(context);
          }

          // Berechne Gesamtpunkte des Spieltags
          final totalPoints = players.fold<int>(
            0,
            (sum, player) => sum + ((player['p'] as int?) ?? 0),
          );

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Gesamtpunktzahl
              _buildTotalPointsCard(context, totalPoints),
              const SizedBox(height: 16),

              // Spieler nach Position gruppiert
              _buildPlayersByPosition(context, players),
            ],
          );
        },
        loading: () => const Center(child: LoadingWidget()),
        error: (error, stack) => Center(
          child: ErrorWidgetCustom(
            error: error,
            onRetry: () => ref.refresh(myElevenProvider(leagueId)),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPointsCard(BuildContext context, int totalPoints) {
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Gesamtpunkte',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalPoints',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersByPosition(
    BuildContext context,
    List<Map<String, dynamic>> players,
  ) {
    // Position-mode: gruppierte Anzeige
    if (_sortMode == _SortMode.position) {
      final Map<int, List<Map<String, dynamic>>> playersByPosition = {};

      for (final player in players) {
        final position = player['ps'] as int? ?? 0;
        playersByPosition.putIfAbsent(position, () => []);
        playersByPosition[position]!.add(player);
      }

      // Sortiere Positionen (1=TW, 2=ABW, 3=MIT, 4=STU)
      final sortedPositions = playersByPosition.keys.toList()..sort();

      return Column(
        children: sortedPositions.map((position) {
          final positionPlayers = playersByPosition[position]!;
          return _buildPositionSection(context, position, positionPlayers);
        }).toList(),
      );
    }

    // Global-mode: flache Liste, global sortiert
    final allPlayers = List<Map<String, dynamic>>.from(players);

    if (_sortMode == _SortMode.pointsDesc) {
      allPlayers.sort(
        (a, b) => ((b['p'] as int?) ?? 0).compareTo((a['p'] as int?) ?? 0),
      );
    } else if (_sortMode == _SortMode.nameAsc) {
      allPlayers.sort((a, b) {
        final aName = '${a['ln'] ?? ''} ${a['fn'] ?? ''}'.trim();
        final bName = '${b['ln'] ?? ''} ${b['fn'] ?? ''}'.trim();
        return aName.compareTo(bName);
      });
    }

    final header = _sortMode == _SortMode.pointsDesc
        ? 'Nach Punkten'
        : 'Nach Name';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            header,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...allPlayers.map((player) => _buildPlayerCard(context, player)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPositionSection(
    BuildContext context,
    int position,
    List<Map<String, dynamic>> players,
  ) {
    final positionName = _getPositionName(position);
    final positionIcon = _getPositionIcon(position);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(positionIcon, size: 20),
              const SizedBox(width: 8),
              Text(
                positionName,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        ...players.map((player) => _buildPlayerCard(context, player)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlayerCard(BuildContext context, Map<String, dynamic> player) {
    final firstName = player['fn'] as String? ?? '';
    final lastName = player['ln'] as String? ?? '';
    final teamName = player['tn'] as String? ?? '';
    final points = player['p'] as int? ?? 0;
    final status = player['s'] as int? ?? 0;

    // Farbkodierung basierend auf Punkten
    Color pointsColor;
    if (points > 0) {
      pointsColor = Colors.green;
    } else if (points < 0) {
      pointsColor = Colors.red;
    } else {
      pointsColor = Colors.grey;
    }

    // Status-Icon (0 = nicht gespielt, 1 = spielt gerade, 2 = gespielt)
    Widget? statusIcon;
    if (status == 1) {
      statusIcon = const Icon(
        Icons.play_circle,
        color: Colors.orange,
        size: 20,
      );
    } else if (status == 2) {
      statusIcon = const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 20,
      );
    }

    // Resolve Ligainsider image (if available)
    final ligainsiderAsync = ref.watch(ligainsiderServiceFutureProvider);
    LigainsiderPlayer? ligPlayer;
    ligainsiderAsync.maybeWhen(
      data: (service) =>
          ligPlayer = service.getLigainsiderPlayer(firstName, lastName),
      orElse: () {},
    );

    final ligImageRaw = ligPlayer?.imageUrl;
    final String? ligImage = (ligImageRaw != null && ligImageRaw.isNotEmpty)
        ? (ligImageRaw.startsWith('/')
              ? 'https://www.ligainsider.de$ligImageRaw'
              : ligImageRaw)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: () =>
            _showPlayerEventsDialog(context, player, _selectedLeagueId),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: ligImage != null
              ? (() {
                  final displayImage = kIsWeb
                      ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(ligImage.replaceFirst(RegExp(r'^https?:\/\/'), ''))}&w=80&h=80&fit=cover'
                      : ligImage;
                  return ClipOval(
                    child: Image.network(
                      displayImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => CircleAvatar(
                        child: Text(
                          firstName.isNotEmpty ? firstName[0] : '?',
                          style: TextStyle(
                            color: pointsColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }())
              : CircleAvatar(
                  backgroundColor: pointsColor.withValues(alpha: 0.2),
                  child: Text(
                    firstName.isNotEmpty ? firstName[0] : '?',
                    style: TextStyle(
                      color: pointsColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        title: Text(
          '$firstName $lastName',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(teamName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              points >= 0 ? '+$points' : '-${points.abs()}',
              style: TextStyle(color: pointsColor, fontWeight: FontWeight.bold),
            ),
            if (statusIcon != null) ...[const SizedBox(width: 8), statusIcon],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Noch keine Ligen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tritt einer Liga bei',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPlayersState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Keine Aufstellung',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Stelle deine Mannschaft auf',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getPositionName(int position) {
    switch (position) {
      case 1:
        return 'Torwart';
      case 2:
        return 'Abwehr';
      case 3:
        return 'Mittelfeld';
      case 4:
        return 'Sturm';
      default:
        return 'Unbekannt';
    }
  }

  IconData _getPositionIcon(int position) {
    switch (position) {
      case 1:
        return Icons.sports_handball;
      case 2:
        return Icons.shield;
      case 3:
        return Icons.group;
      case 4:
        return Icons.sports_soccer;
      default:
        return Icons.person;
    }
  }

  String _formatEventMinute(Map<String, dynamic> event) {
    // Only use 'mt' (match time) as source for event minute
    final value = event['mt'];

    int? minute;
    if (value is int) {
      minute = value;
    } else if (value is double) {
      minute = value.toInt();
    } else if (value is String) {
      minute = int.tryParse(value);
    }

    if (minute != null) {
      return "$minute'"; // e.g. 45'
    }

    // No minute info available
    return '-';
  }

  Widget _buildEventsListSection(
    BuildContext context,
    BuildContext dialogCtx,
    Map<String, dynamic> player,
    AsyncValue<Map<String, dynamic>> eventsAsync,
    AsyncValue<Map<String, dynamic>> eventTypesAsync,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${player['fn'] ?? ''} ${player['ln'] ?? ''}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        eventsAsync.when(
          data: (data) {
            final events =
                (data['events'] as List?)?.cast<Map<String, dynamic>>() ?? [];

            // Build a map of event type id => title
            final Map<int, String> etiToTitle = {};
            eventTypesAsync.maybeWhen(
              data: (etData) {
                final itList =
                    (etData['it'] as List?)?.cast<Map<String, dynamic>>() ?? [];
                for (final item in itList) {
                  final id = item['i'];
                  final title = item['ti'] as String? ?? '';
                  if (id is int) etiToTitle[id] = title;
                }
              },
              orElse: () {},
            );

            // Filter out events without a meaningful name (remove numeric IDs like "0")
            final filteredEvents = events.where((ev) {
              final eti = ev['eti'] is int
                  ? ev['eti'] as int
                  : int.tryParse('${ev['eti']}') ?? 0;

              final titleFromEti = (etiToTitle[eti] ?? '').toString().trim();
              final eiRaw = ev['ei'];
              final ei = (eiRaw is String)
                  ? eiRaw.trim()
                  : (eiRaw?.toString().trim() ?? '');
              final pn = (ev['pn'] as String?)?.trim();

              // If the eti mapping provides a non-empty title, keep event
              if (titleFromEti.isNotEmpty) return true;

              // Keep events that have a textual 'ei' (not just numeric IDs)
              final eiIsNumeric =
                  ei.isNotEmpty && RegExp(r'^\d+$').hasMatch(ei);
              if (ei.isNotEmpty && !eiIsNumeric) return true;

              // Keep if we have a player name or other textual field
              if (pn != null && pn.isNotEmpty) return true;

              // Otherwise drop (this removes events shown only as numbers like '0')
              return false;
            }).toList();

            if (filteredEvents.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Text('Keine Ereignisse für diesen Spieler'),
              );
            }

            return SizedBox(
              width: 500,
              height: 380,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filteredEvents.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final ev = filteredEvents[idx];
                  final minuteLabel = _formatEventMinute(ev);
                  final eti = ev['eti'] is int
                      ? ev['eti'] as int
                      : int.tryParse('${ev['eti']}') ?? 0;

                  // Resolve title: prefer eti mapping, then 'ei' or 'pn'
                  String evTitle = etiToTitle[eti] ?? '';
                  if (evTitle.isEmpty) {
                    evTitle =
                        (ev['ei'] as String?) ?? (ev['pn'] as String?) ?? '';
                  }
                  final evPointsNum = ev['p'] is int
                      ? ev['p'] as int
                      : int.tryParse('${ev['p']}') ?? 0;
                  final evPointsStr = evPointsNum >= 0
                      ? '+$evPointsNum'
                      : '-${evPointsNum.abs()}';
                  final pointsColor = evPointsNum > 0
                      ? Colors.green
                      : evPointsNum < 0
                      ? Colors.red
                      : Colors.grey;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      child: Text(
                        minuteLabel,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    title: Text(evTitle),
                    trailing: Text(
                      evPointsStr,
                      style: TextStyle(
                        color: pointsColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, st) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text('Fehler beim Laden: $err'),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Schließen'),
          ),
        ),
      ],
    );
  }

  Future<void> _showPlayerEventsDialog(
    BuildContext context,
    Map<String, dynamic> player,
    String? leagueId,
  ) async {
    final playerId = (player['i'] ?? '') as String;

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer(
              builder: (ctx, dialogRef, _) {
                // Resolve competitionId robustly:
                final selectedLeague = dialogRef.watch(selectedLeagueProvider);
                final userLeaguesAsync = dialogRef.watch(userLeaguesProvider);

                String? competitionId;
                if (selectedLeague != null) {
                  competitionId = selectedLeague.cpi;
                } else if (leagueId != null) {
                  // Try to find league in cached user leagues
                  userLeaguesAsync.maybeWhen(
                    data: (leagues) {
                      try {
                        final found = leagues.firstWhere(
                          (l) => l.i == leagueId,
                        );
                        competitionId = found.cpi;
                      } catch (_) {
                        // not found
                      }
                    },
                    orElse: () {},
                  );
                }

                if (competitionId == null && leagueId != null) {
                  // Fallback: fetch league details
                  final leagueDetailsAsync = dialogRef.watch(
                    leagueDetailsProvider(leagueId),
                  );

                  return leagueDetailsAsync.when(
                    data: (leagueDetail) {
                      final compId = leagueDetail.cpi;
                      final eventsAsync = dialogRef.watch(
                        currentPlayerEventHistoryProvider((
                          competitionId: compId,
                          playerId: playerId,
                        )),
                      );
                      final eventTypesAsync = dialogRef.watch(
                        liveEventTypesProvider,
                      );

                      return _buildEventsListSection(
                        context,
                        dialogCtx,
                        player,
                        eventsAsync,
                        eventTypesAsync,
                      );
                    },
                    loading: () => const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, st) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Fehler beim Laden der Ligendaten: $err'),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(dialogCtx).pop(),
                            child: const Text('Schließen'),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (competitionId == null) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [Text('Keine Liga ausgewählt')],
                  );
                }

                final eventsAsync = dialogRef.watch(
                  currentPlayerEventHistoryProvider((
                    competitionId: competitionId!,
                    playerId: playerId,
                  )),
                );
                final eventTypesAsync = dialogRef.watch(liveEventTypesProvider);

                return _buildEventsListSection(
                  context,
                  dialogCtx,
                  player,
                  eventsAsync,
                  eventTypesAsync,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
