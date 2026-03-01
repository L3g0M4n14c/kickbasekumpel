import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/screen_size.dart';
import '../../../data/models/lineup_model.dart';
import '../../../data/providers/player_providers.dart';
import '../../../data/providers/league_providers.dart';
import '../../widgets/responsive_layout.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class LineupPage extends ConsumerWidget {
  const LineupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLeague = ref.watch(selectedLeagueProvider);
    final leagueId = selectedLeague?.i;
    final lineupAsync = leagueId != null
        ? ref.watch(myLineupProvider(leagueId))
        : const AsyncValue<List<LineupPlayer>>.loading();

    return Scaffold(
      appBar: ScreenSize.isMobile(context)
          ? AppBar(
              title: const Text('Aufstellung'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.sports_soccer),
                  onPressed: () => context.go('/ligainsider/lineups'),
                  tooltip: 'Ligainsider Aufstellungen',
                ),
                if (leagueId != null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref.invalidate(myLineupProvider(leagueId)),
                  ),
              ],
            )
          : null,
      body: selectedLeague == null
          ? const Center(child: Text('Keine Liga ausgewählt'))
          : lineupAsync.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => ErrorWidgetCustom(
                error: error,
                onRetry: () => ref.invalidate(myLineupProvider(leagueId!)),
              ),
              data: (players) {
                // Kickbase-Konvention: Torwart hat lo=0, Feldspieler lo=1..11
                // Bench: lo > 11 oder (lo == 0 und kein Torwart)
                bool isStarter(LineupPlayer p) {
                  if (p.position == 1 && p.lineupOrder == 0) return true;
                  return p.lineupOrder >= 1 && p.lineupOrder <= 11;
                }

                final starters = players.where(isStarter).toList()
                  ..sort((a, b) {
                    // Torwart (lo=0) ans Ende der Sortierung (unterste Reihe)
                    final aOrder = a.lineupOrder == 0 ? 11 : a.lineupOrder;
                    final bOrder = b.lineupOrder == 0 ? 11 : b.lineupOrder;
                    return aOrder.compareTo(bOrder);
                  });

                final bench = players.where((p) => !isStarter(p)).toList();

                return ResponsiveLayout(
                  mobile: _buildMobileLayout(context, starters, bench),
                  tablet: _buildTabletLayout(context, starters, bench),
                  desktop: _buildDesktopLayout(
                    context,
                    ref,
                    starters,
                    bench,
                    selectedLeague,
                    leagueId!,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<LineupPlayer> starters,
    List<LineupPlayer> bench,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FormationField(starters: starters, compact: true),
          const SizedBox(height: 16),
          if (bench.isNotEmpty) _BenchSection(players: bench),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    List<LineupPlayer> starters,
    List<LineupPlayer> bench,
  ) {
    return ResponsiveSplitView(
      listFlex: 3,
      detailFlex: 2,
      list: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _FormationField(starters: starters, compact: false),
      ),
      detail: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _BenchSection(players: bench),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    List<LineupPlayer> starters,
    List<LineupPlayer> bench,
    dynamic selectedLeague,
    String leagueId,
  ) {
    final avgPoints = starters.isEmpty
        ? 0.0
        : starters.map((p) => p.averagePoints).reduce((a, b) => a + b) /
              starters.length;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _FormationField(starters: starters, compact: false),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _BenchSection(players: bench),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: _StatsPanel(
              teamValue: selectedLeague.cu.teamValue,
              starterCount: starters.length,
              benchCount: bench.length,
              avgPoints: avgPoints,
            ),
          ),
        ),
      ],
    );
  }
}

/// Visuelles Formationsfeld das Starter-Spieler nach Position anzeigt
class _FormationField extends StatelessWidget {
  final List<LineupPlayer> starters;
  final bool compact;

  const _FormationField({required this.starters, required this.compact});

  @override
  Widget build(BuildContext context) {
    final goalkeepers = starters.where((p) => p.position == 1).toList();
    final defenders = starters.where((p) => p.position == 2).toList();
    final midfielders = starters.where((p) => p.position == 3).toList();
    final forwards = starters.where((p) => p.position == 4).toList();

    final fieldHeight = compact ? 380.0 : 560.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.sports_soccer, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Startelf (${starters.length}/11)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: fieldHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2E7D32),
                  const Color(0xFF388E3C),
                  const Color(0xFF2E7D32),
                  const Color(0xFF388E3C),
                  const Color(0xFF2E7D32),
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
            child: CustomPaint(
              painter: _PitchLinePainter(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 8.0,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _PositionRow(
                        players: forwards,
                        label: 'Sturm',
                        emptyLabel: 'ST',
                        targetCount: 3,
                      ),
                    ),
                    Expanded(
                      child: _PositionRow(
                        players: midfielders,
                        label: 'Mittelfeld',
                        emptyLabel: 'MF',
                        targetCount: 4,
                      ),
                    ),
                    Expanded(
                      child: _PositionRow(
                        players: defenders,
                        label: 'Abwehr',
                        emptyLabel: 'ABW',
                        targetCount: 4,
                      ),
                    ),
                    Expanded(
                      child: _PositionRow(
                        players: goalkeepers,
                        label: 'Torwart',
                        emptyLabel: 'TW',
                        targetCount: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionRow extends StatelessWidget {
  final List<LineupPlayer> players;
  final String label;
  final String emptyLabel;
  final int targetCount;

  const _PositionRow({
    required this.players,
    required this.label,
    required this.emptyLabel,
    required this.targetCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (players.isEmpty)
              ...List.generate(
                targetCount,
                (_) => _EmptyPlayerSlot(label: emptyLabel),
              )
            else
              ...players.map((p) => _FieldPlayerBadge(player: p)),
          ],
        ),
      ],
    );
  }
}

class _FieldPlayerBadge extends StatelessWidget {
  final LineupPlayer player;

  const _FieldPlayerBadge({required this.player});

  @override
  Widget build(BuildContext context) {
    // Nachname (letztes Wort) – keine Kürzung, FittedBox passt die Schrift an
    final nameParts = player.name.trim().split(' ');
    final displayName = nameParts.length > 1 ? nameParts.last : nameParts.first;

    final statusColor = switch (player.matchDayStatus) {
      1 => Colors.red,
      2 => Colors.orange,
      _ => null,
    };

    // Aufstellungsnummer: Torwart (lo=0) zeigt 'TW' statt '0'
    final orderLabel = player.lineupOrder == 0 ? 'TW' : '${player.lineupOrder}';

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: Text(
                  orderLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
              if (statusColor != null)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              if (player.hasToday)
                Positioned(
                  left: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            '${player.averagePoints}Ø',
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlayerSlot extends StatelessWidget {
  final String label;

  const _EmptyPlayerSlot({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '—',
            style: TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// Fußballplatz-Linien zeichnen
class _PitchLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Mittellinie
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paint);

    // Mittelkreis
    canvas.drawCircle(Offset(cx, cy), size.width * 0.12, paint);

    // Strafräume
    final penaltyW = size.width * 0.45;
    final penaltyH = size.height * 0.14;
    canvas.drawRect(
      Rect.fromLTWH((size.width - penaltyW) / 2, 0, penaltyW, penaltyH),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyW) / 2,
        size.height - penaltyH,
        penaltyW,
        penaltyH,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_PitchLinePainter oldDelegate) => false;
}

/// Bank-Sektion mit Reservespielern
class _BenchSection extends StatelessWidget {
  final List<LineupPlayer> players;

  const _BenchSection({required this.players});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.weekend, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Bank (${players.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (players.isEmpty)
              Text(
                'Keine Reservespieler',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...players.map((p) => _BenchPlayerTile(player: p)),
          ],
        ),
      ),
    );
  }
}

class _BenchPlayerTile extends StatelessWidget {
  final LineupPlayer player;

  const _BenchPlayerTile({required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posLabel = switch (player.position) {
      1 => 'TW',
      2 => 'ABW',
      3 => 'MF',
      4 => 'ST',
      _ => '?',
    };

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Text(
          posLabel,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: Text(
        player.name,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      trailing: Text(
        '${player.averagePoints} Ø',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Stats-Panel für Desktop
class _StatsPanel extends StatelessWidget {
  final int teamValue;
  final int starterCount;
  final int benchCount;
  final double avgPoints;

  const _StatsPanel({
    required this.teamValue,
    required this.starterCount,
    required this.benchCount,
    required this.avgPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiken',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _StatRow(
                  'Teamwert',
                  '${(teamValue / 1000000).toStringAsFixed(1)}M €',
                ),
                const Divider(),
                _StatRow('Startelf', '$starterCount Spieler'),
                const Divider(),
                _StatRow('Bank', '$benchCount Spieler'),
                const Divider(),
                _StatRow('Ø Punkte', avgPoints.toStringAsFixed(1)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
