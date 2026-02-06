import 'package:flutter/material.dart';

/// Password Input Field für KickbaseKumpel
///
/// Spezialisiertes Eingabefeld für Passwörter mit Anzeige-Toggle.
///
/// **Verwendung:**
/// ```dart
/// PasswordInputField(
///   controller: passwordController,
///   labelText: 'Passwort',
///   validator: (value) => // Custom validation
/// )
/// ```
class PasswordInputField extends StatefulWidget {
  /// Text-Controller
  final TextEditingController? controller;

  /// Callback bei Änderungen
  final ValueChanged<String>? onChanged;

  /// Callback bei Submit (Enter)
  final VoidCallback? onSubmitted;

  /// Custom Validator
  final FormFieldValidator<String>? validator;

  /// Label-Text
  final String labelText;

  /// Hint-Text
  final String hintText;

  /// Autofocus
  final bool autofocus;

  /// Enabled
  final bool enabled;

  /// Zeigt Passwort-Stärke-Indikator
  final bool showStrengthIndicator;

  const PasswordInputField({
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.labelText = 'Passwort',
    this.hintText = '••••••••',
    this.autofocus = false,
    this.enabled = true,
    this.showStrengthIndicator = false,
    super.key,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;
  double _strength = 0.0;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onPasswordChanged(String value) {
    if (widget.showStrengthIndicator) {
      setState(() {
        _strength = _calculatePasswordStrength(value);
      });
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          onChanged: _onPasswordChanged,
          onFieldSubmitted: (_) => widget.onSubmitted?.call(),
          validator: widget.validator ?? _defaultValidator,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: _toggleObscureText,
              tooltip: _obscureText
                  ? 'Passwort anzeigen'
                  : 'Passwort verstecken',
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
        ),

        // Passwort-Stärke-Indikator
        if (widget.showStrengthIndicator &&
            widget.controller?.text.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          _buildStrengthIndicator(context),
        ],
      ],
    );
  }

  /// Passwort-Stärke-Indikator
  Widget _buildStrengthIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getStrengthColor();
    final label = _getStrengthLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _strength,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          color: color,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Berechnet Passwort-Stärke (0.0 - 1.0)
  double _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;

    // Länge
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.15;

    // Großbuchstaben
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;

    // Kleinbuchstaben
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;

    // Zahlen
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;

    // Sonderzeichen
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;

    return strength.clamp(0.0, 1.0);
  }

  /// Farbe basierend auf Stärke
  Color _getStrengthColor() {
    if (_strength < 0.33) return Colors.red;
    if (_strength < 0.67) return Colors.orange;
    return Colors.green;
  }

  /// Label basierend auf Stärke
  String _getStrengthLabel() {
    if (_strength < 0.33) return 'Schwaches Passwort';
    if (_strength < 0.67) return 'Mittleres Passwort';
    return 'Starkes Passwort';
  }

  /// Standard-Validator für Passwort
  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte Passwort eingeben';
    }

    if (value.length < 8) {
      return 'Passwort muss mindestens 8 Zeichen haben';
    }

    return null;
  }
}
