import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/ag_textfield.dart';
import 'package:flutter/services.dart';

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
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")),
        );
        break;

      case AppTextInputType.numberOnly:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;

      case AppTextInputType.decimal:
        formatters.add(
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + '}')
          ),
        );
        break;

      case AppTextInputType.alphaNumeric:
        formatters.add(
          FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 ]")),
        );
        break;

      case AppTextInputType.phone:
        formatters.add(FilteringTextInputFormatter.digitsOnly);
        break;

      case AppTextInputType.email:
        formatters.add(
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9._%+\-@]'),
          ),
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