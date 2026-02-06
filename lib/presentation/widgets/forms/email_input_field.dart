import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Email Input Field für KickbaseKumpel
///
/// Spezialisiertes Eingabefeld für E-Mail-Adressen mit Validierung.
///
/// **Verwendung:**
/// ```dart
/// EmailInputField(
///   controller: emailController,
///   onChanged: (value) => // Handle change
///   validator: (value) => // Custom validation
/// )
/// ```
class EmailInputField extends StatelessWidget {
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

  const EmailInputField({
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.labelText = 'E-Mail',
    this.hintText = 'beispiel@email.de',
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofocus: autofocus,
      enabled: enabled,
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSubmitted?.call(),
      validator: validator ?? _defaultValidator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Keine Leerzeichen
      ],
    );
  }

  /// Standard-Validator für E-Mail
  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bitte E-Mail eingeben';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ungültige E-Mail-Adresse';
    }

    return null;
  }
}
