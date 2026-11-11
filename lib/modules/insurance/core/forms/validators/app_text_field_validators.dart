

import 'package:citizenone_app/modules/insurance/core/forms/enums/app_text_input_type.dart';

class AppTextFieldValidators {
  static String? validate({
    required String? value,
    required AppTextInputType type,
    bool isRequired = false,
    String? requiredText,
    int? minLength,
    int? maxLength,
    bool validateIfNotEmpty = true,
    String? Function(String?)? customValidator,
  }) {
    final val = value?.trim();

    // Required
    if (isRequired && (val == null || val.isEmpty)) {
      return requiredText ?? 'This field is required';
    }

    // Min Length
    if (minLength != null && val!.length < minLength) {
      return 'Minimum $minLength characters required';
    }

    // Max Length
    if (maxLength != null && val!.length > maxLength) {
      return 'Maximum $maxLength characters allowed';
    }

    // Type-specific validation
    switch (type) {
      case AppTextInputType.email:
        final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
        if (!regex.hasMatch(val!)) {
          return 'Enter valid email';
        }
        break;

      case AppTextInputType.phone:
        if (val!.length != 9) {
          return 'Enter valid phone number';
        }
        break;

      case AppTextInputType.password:
        if (val!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;

      default:
        break;
    }

    return customValidator?.call(val);
  }
}