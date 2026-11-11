import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/molecules/labeled_text_field.dart';

class AmountInputField extends StatelessWidget {
  final String label;
  final String currencySymbol;
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const AmountInputField({
    super.key,
    required this.label,
    this.currencySymbol = 'K',
    this.controller,
    this.hintText,
    this.onChanged,
    this.validator,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return LabeledTextField(
      label: label,
      controller: controller,
      hintText: hintText ?? '0.00',
      required: required,
      onChanged: onChanged,
      validator: validator,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      prefixIcon: null,
      suffixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          currencySymbol,
          style: AppTypography.bodyLarge(
            context,
          ).copyWith(fontWeight: FontWeight.w700, color: tokens.primary),
        ),
      ),
    );
  }
}
