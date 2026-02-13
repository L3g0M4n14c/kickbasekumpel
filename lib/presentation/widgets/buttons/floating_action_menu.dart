import 'package:flutter/material.dart';

/// Floating Action Menu für KickbaseKumpel
///
/// Erweitertes FAB-Menü mit mehreren Aktionen.
///
/// **Verwendung:**
/// ```dart
/// FloatingActionMenu(
///   actions: [
///     FABAction(
///       icon: Icons.add,
///       label: 'Spieler kaufen',
///       onPressed: () => // Handle action
///     ),
///     FABAction(
///       icon: Icons.sell,
///       label: 'Spieler verkaufen',
///       onPressed: () => // Handle action
///     ),
///   ],
/// )
/// ```
class FloatingActionMenu extends StatefulWidget {
  /// Liste der verfügbaren Aktionen
  final List<FABAction> actions;

  /// Haupt-Icon (wenn geschlossen)
  final IconData icon;

  /// Tooltip
  final String? tooltip;

  const FloatingActionMenu({
    required this.actions,
    this.icon = Icons.add,
    this.tooltip,
    super.key,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleAction(VoidCallback onPressed) {
    _toggle();
    Future.delayed(const Duration(milliseconds: 100), onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // Backdrop (schließt Menu wenn außerhalb getippt)
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),

        // Action-Buttons
        ...List.generate(widget.actions.length, (index) {
          return _buildActionButton(index, widget.actions[index]);
        }),

        // Haupt-FAB
        FloatingActionButton(
          onPressed: _toggle,
          tooltip: widget.tooltip,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0, // 45° Rotation
            duration: const Duration(milliseconds: 200),
            child: Icon(widget.icon),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(int index, FABAction action) {
    final theme = Theme.of(context);
    final offset = (index + 1) * 72.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          bottom: offset * _animation.value,
          right: 0,
          child: Opacity(
            opacity: _animation.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label
                if (action.label != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      action.label!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),

                // Action-FAB
                FloatingActionButton(
                  mini: true,
                  heroTag: 'fab_${action.label}_$index',
                  onPressed: () => _handleAction(action.onPressed),
                  backgroundColor: action.backgroundColor,
                  foregroundColor: action.foregroundColor,
                  tooltip: action.tooltip ?? action.label,
                  child: Icon(action.icon),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// FAB Action
class FABAction {
  /// Icon der Aktion
  final IconData icon;

  /// Label (optional)
  final String? label;

  /// Callback wenn gedrückt
  final VoidCallback onPressed;

  /// Tooltip (optional)
  final String? tooltip;

  /// Hintergrundfarbe (optional)
  final Color? backgroundColor;

  /// Vordergrundfarbe (optional)
  final Color? foregroundColor;

  const FABAction({
    required this.icon,
    required this.onPressed,
    this.label,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });
}
