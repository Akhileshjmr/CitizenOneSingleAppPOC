// =============================================================================
// BaseTextField  —  ATOM
// -----------------------------------------------------------------------------
// The lowest-level text input building block. Configurable but contains
// ZERO screen-specific logic. Molecules (LabeledTextField, LoginFormField,
// AmountInputField, SearchBarMolecule) layer behavior on top of this atom.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
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
    this.onSubmitted,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
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
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      autofocus: autofocus,
      focusNode: focusNode,
      style: context.text.body,
      cursorColor: context.colors.primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 20, color: context.colors.textSecondary),
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                icon: Icon(suffixIcon,
                    size: 20, color: context.colors.textSecondary),
                onPressed: onSuffixTap,
              ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
      ),
    );
  }
}
