import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';

/// A label + input field molecule. Use [AppTextField] directly for unlabeled inputs.
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool required;
  final String? helperText;
  final FocusNode? focusNode;
  final int? maxLines;

  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.required = false,
    this.helperText,
    this.focusNode,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: tokens.textPrimary,
              ),
            ),
            if (required)
              AppText(
                ' *',
                style: AppTextStyle.titleSmall,
                color: tokens.error,
                fontWeight: FontWeight.w600,
              ),
          ],
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: controller,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          focusNode: focusNode,
          maxLines: maxLines,
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: AppTypography.caption(
              context,
            ).copyWith(color: tokens.textMuted),
          ),
        ],
      ],
    );
  }
}
