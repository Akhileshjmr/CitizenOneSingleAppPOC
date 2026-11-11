import 'package:flutter/services.dart';

/// A [TextInputFormatter] that manually masks password input, replacing
/// Flutter's built-in `obscureText: true` behavior entirely.
///
/// Why: on some Android devices/keyboards, `obscureText: true` still briefly
/// flashes the last typed character (either due to Flutter's own animation,
/// or the keyboard app's own UI). This formatter avoids that class of bug
/// completely, because `obscureText` is never set to `true` — the field only
/// ever displays plain text characters (either the real password or mask
/// characters), which nothing "obscures" or "reveals".
///
/// Usage:
///   - Keep `obscureText: false` on the TextField/TextFormField always.
///   - Pass this formatter via `inputFormatters`.
///   - Read the real password from `formatter.realValue`, NOT from the
///     TextEditingController's `.text` (which holds the masked display).
class PasswordMaskingFormatter extends TextInputFormatter {
  PasswordMaskingFormatter({required this.getObscure, this.maskChar = '•'});

  /// Returns whether the field should currently show mask characters (true)
  /// or the real password (false). Typically wired to a `bool` state var
  /// via a closure, e.g. `getObscure: () => _obscurePassword`.
  final bool Function() getObscure;

  /// Character used to mask each real character. Default: '•'
  final String maskChar;

  /// The actual, unmasked password value. Always read this for login,
  /// validation, etc. — never read the controller's `.text`.
  String realValue = '';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cursor = newValue.selection.end;
    final lenDiff = newValue.text.length - oldValue.text.length;

    if (lenDiff > 0) {
      // Characters were inserted just before the cursor.
      final insertStart = (cursor - lenDiff).clamp(0, realValue.length);
      final inserted = newValue.text.substring(cursor - lenDiff, cursor);
      realValue = realValue.substring(0, insertStart) +
          inserted +
          realValue.substring(insertStart);
    } else if (lenDiff < 0) {
      // Characters were deleted ending at the cursor.
      final deleteStart = cursor.clamp(0, realValue.length);
      final deleteEnd = (deleteStart - lenDiff).clamp(0, realValue.length);
      realValue = realValue.substring(0, deleteStart) +
          realValue.substring(deleteEnd);
    }
    // If lenDiff == 0, it's likely a selection replace with same length,
    // or a formatter no-op; realValue is left as-is in that edge case.

    final display = getObscure() ? maskChar * realValue.length : realValue;

    return TextEditingValue(
      text: display,
      selection: TextSelection.collapsed(
        offset: cursor.clamp(0, display.length),
      ),
    );
  }

  /// Call this whenever you clear the controller (e.g. logout, form reset)
  /// so the real password doesn't linger in memory.
  void reset() {
    realValue = '';
  }
}
