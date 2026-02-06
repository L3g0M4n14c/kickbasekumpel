import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Price Input Field für KickbaseKumpel
///
/// Spezialisiertes Eingabefeld für Preise/Geldbeträge.
///
/// **Verwendung:**
/// ```dart
/// PriceInputField(
///   controller: priceController,
///   onChanged: (value) => // Handle change
///   maxValue: 50000000,
///   currency: '€',
/// )
/// ```
class PriceInputField extends StatelessWidget {
  /// Text-Controller
  final TextEditingController? controller;

  /// Callback bei Änderungen (gibt bereinigten int-Wert zurück)
  final ValueChanged<int?>? onChanged;

  /// Callback bei Submit (Enter)
  final VoidCallback? onSubmitted;

  /// Custom Validator
  final FormFieldValidator<String>? validator;

  /// Label-Text
  final String labelText;

  /// Hint-Text
  final String hintText;

  /// Währungs-Symbol
  final String currency;

  /// Minimaler Wert
  final int? minValue;

  /// Maximaler Wert
  final int? maxValue;

  /// Autofocus
  final bool autofocus;

  /// Enabled
  final bool enabled;

  const PriceInputField({
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.labelText = 'Preis',
    this.hintText = '0',
    this.currency = '€',
    this.minValue,
    this.maxValue,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autofocus: autofocus,
      enabled: enabled,
      onChanged: (value) {
        final intValue = _parseValue(value);
        onChanged?.call(intValue);
      },
      onFieldSubmitted: (_) => onSubmitted?.call(),
      validator: validator ?? _defaultValidator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.euro_outlined),
        suffixText: currency,
        suffixStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        helperText: _getHelperText(),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _ThousandsSeparatorInputFormatter(),
      ],
    );
  }

  /// Helper-Text mit Min/Max-Werten
  String? _getHelperText() {
    if (minValue != null && maxValue != null) {
      return 'Zwischen ${_formatCurrency(minValue!)} und ${_formatCurrency(maxValue!)}';
    } else if (minValue != null) {
      return 'Mindestens ${_formatCurrency(minValue!)}';
    } else if (maxValue != null) {
      return 'Maximal ${_formatCurrency(maxValue!)}';
    }
    return null;
  }

  /// Parsed String zu int (entfernt Tausender-Trenner)
  int? _parseValue(String value) {
    if (value.isEmpty) return null;
    final cleanValue = value.replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(cleanValue);
  }

  /// Standard-Validator für Preis
  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte Preis eingeben';
    }

    final intValue = _parseValue(value);
    if (intValue == null) {
      return 'Ungültiger Preis';
    }

    if (minValue != null && intValue < minValue!) {
      return 'Mindestpreis: ${_formatCurrency(minValue!)}';
    }

    if (maxValue != null && intValue > maxValue!) {
      return 'Maximalpreis: ${_formatCurrency(maxValue!)}';
    }

    return null;
  }

  /// Formatiert Währung mit Tausender-Trenner
  String _formatCurrency(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return '$formatted $currency';
  }
}

/// InputFormatter für Tausender-Trenner
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Entferne existierende Trenner
    final cleanText = newValue.text.replaceAll('.', '');

    // Füge Tausender-Trenner hinzu
    final formatted = cleanText.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
