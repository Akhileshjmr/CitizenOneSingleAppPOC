import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

/// Base text input atom. No label — compose with [LabeledTextField] for that.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? hint;
  final String? label;
  final dynamic prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isEnabled;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.contentPadding,
    this.fillColor,
    this.inputFormatters,
    this.maxLength,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    Widget? resolvedPrefix;
    if (prefixIcon is Widget) {
      resolvedPrefix = prefixIcon as Widget;
    } else if (prefixIcon is String) {
      resolvedPrefix = SvgPicture.asset(prefixIcon as String, fit: BoxFit.scaleDown);
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: isEnabled,
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      style: AppTypography.bodyLarge(context),
      inputFormatters: inputFormatters,
      maxLength: maxLength,   
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText ?? hint,
        counterText: "",
        hintStyle: AppTypography.bodyMedium(
          context,
        ).copyWith(color: tokens.textMuted),
        prefixIcon: resolvedPrefix,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? tokens.surface,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: BorderSide(color: tokens.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: BorderSide(color: tokens.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: BorderSide(color: tokens.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: BorderSide(color: tokens.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: BorderSide(color: tokens.error, width: 1.5),
        ), 
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: BorderSide(color: tokens.outline.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}
