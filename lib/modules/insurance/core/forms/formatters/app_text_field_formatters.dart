import 'package:flutter/services.dart';
import 'package:citizenone_app/modules/insurance/core/forms/enums/app_text_input_type.dart';

class AppTextFieldFormatters {
  static List<TextInputFormatter> getFormatters(
    AppTextInputType type, {
    int? maxLength,
    int decimalRange = 2,
  }) {
    final formatters = <TextInputFormatter>[];

    switch (type) {
      case AppTextInputType.stringOnly:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        );
        break;

      case AppTextInputType.numberOnly:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;

      case AppTextInputType.decimal:
        formatters.add(
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + '}'),
          ),
        );
        break;

      case AppTextInputType.alphaNumeric:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
        );
        break;

      case AppTextInputType.phone:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;

      case AppTextInputType.email:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._%+\-@]')),
        );
        break;

      default:
        break;
    }

    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }

    return formatters;
  }
}

class SlashFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String digitsOnly = newValue.text.replaceAll('/', '');

    String formatted = '';

    for (int i = 0; i < digitsOnly.length; i++) {
      formatted += digitsOnly[i];

      // Add '/' after 6th and 8th digit
      if (i == 5 || i == 7) {
        if (i != digitsOnly.length - 1) {
          formatted += '/';
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ZambiaPlateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final uppercasedText = newValue.text.toUpperCase();
    final partialRegExp = RegExp(r'^[A-Z]{0,3}(\s?\d{0,4})?(\s?Z?M?)?$');

    if (partialRegExp.hasMatch(uppercasedText)) {
      return newValue.copyWith(
        text: uppercasedText,
        selection: newValue.selection,
      );
    }

    return oldValue;
  }
}
