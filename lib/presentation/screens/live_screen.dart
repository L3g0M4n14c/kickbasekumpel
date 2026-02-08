import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/live_providers.dart';
import '../../data/providers/providers.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

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

  @override
  void initState() {
    super.initState();
    // Auto-Refresh alle 60 Sekunden starten
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      if (mounted && _selectedLeagueId != null) {
        ref.refresh(myElevenProvider(_selectedLeagueId!));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live-Spieltag'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_selectedLeagueId != null) {
                ref.refresh(myElevenProvider(_selectedLeagueId!));
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
              // Live-Punkte Anzeige
              if (_selectedLeagueId != null)
                Expanded(
                  child: _buildLiveView(context, _selectedLeagueId!),
                ),
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
        ref.refresh(myElevenProvider(leagueId));
        // Kurze Verzögerung für besseres UX
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: myElevenAsync.when(
        data: (data) {
          final players = (data['it'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          
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

  Widget _buildPlayersByPosition(BuildContext context, List<Map<String, dynamic>> players) {
    // Gruppiere Spieler nach Position
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
      statusIcon = const Icon(Icons.play_circle, color: Colors.orange, size: 20);
    } else if (status == 2) {
      statusIcon = const Icon(Icons.check_circle, color: Colors.green, size: 20);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: pointsColor.withOpacity(0.2),
          child: Text(
            '$points',
            style: TextStyle(
              color: pointsColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '$firstName $lastName',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(teamName),
        trailing: statusIcon,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Noch keine Ligen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tritt einer Liga bei',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
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
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Aufstellung',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Stelle deine Mannschaft auf',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
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
}
