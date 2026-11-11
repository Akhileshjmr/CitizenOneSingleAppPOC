// =============================================================================
// LoginFormField  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: label + BaseTextField + visibility toggle (when password) +
// error display. Distinct from LabeledTextField because it owns the
// password-mode visibility behavior — encoding it once means every
// password input across the app behaves identically.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class LoginFormField extends StatefulWidget {
  const LoginFormField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.isPassword = false,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final bool isPassword;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AppText.label(widget.label),
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: AppText.label('*', color: context.colors.error),
            ),
          ],
        ),
        const AppSpacer.xs(),
        BaseTextField(
          controller: widget.controller,
          hint: widget.hint,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          obscureText: widget.isPassword && _obscure,
          suffixIcon: widget.isPassword
              ? (_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined)
              : null,
          onSuffixTap: widget.isPassword
              ? () => setState(() => _obscure = !_obscure)
              : null,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
        ),
      ],
    );
  }
}
