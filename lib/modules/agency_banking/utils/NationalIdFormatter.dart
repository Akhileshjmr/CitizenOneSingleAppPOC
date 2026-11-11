import 'package:flutter/services.dart';

class NationalIdFormatter extends TextInputFormatter {
  static const String prefix = 'ZMW';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove prefix and slashes if present
    String digits = newValue.text
        .replaceAll(prefix, '')
        .replaceAll('/', '')
        .replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 9 digits
    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    String formatted = prefix;

    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];

      if ((i == 5 || i == 7) && i != digits.length - 1) {
        formatted += '/';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
