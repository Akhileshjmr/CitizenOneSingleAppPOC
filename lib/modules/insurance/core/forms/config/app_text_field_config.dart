import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/forms/enums/app_text_input_type.dart';

class AppTextFieldConfig {
  static TextInputType getKeyboardType(AppTextInputType type) {
    switch (type) {
      case AppTextInputType.numberOnly:
        return TextInputType.number;
      case AppTextInputType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case AppTextInputType.email:
        return TextInputType.emailAddress;
      case AppTextInputType.phone:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  static int? getDefaultMaxLength(AppTextInputType type) {
    switch (type) {
      case AppTextInputType.phone:
        return 9;
      case AppTextInputType.password:
        return 20;
      case AppTextInputType.email:
        return 50;
      default:
        return null;
    }
  }
}