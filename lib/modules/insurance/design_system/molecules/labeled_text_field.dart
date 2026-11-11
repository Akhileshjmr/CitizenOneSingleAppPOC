// =============================================================================
// LabeledTextField  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: AppText (label) + BaseTextField (atom) + AppText (helper/error).
//
// Why a molecule? Because the *combination* (label-above + helper-below) is
// reusable across forms. It encodes a single visual and accessibility rule.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.enabled = true,
    this.isRequired = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool enabled;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AppText.label(label),
            if (isRequired)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.xs),
                child: AppText.label('*', color: context.colors.error),
              ),
          ],
        ),
        const AppSpacer.xs(),
        BaseTextField(
          controller: controller,
          hint: hint,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          onSuffixTap: onSuffixTap,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          enabled: enabled,
        ),
      ],
    );
  }
}
