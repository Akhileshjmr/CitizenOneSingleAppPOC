import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/typography.dart';

/// Base text input atom. No label — compose with [LabeledTextField] for that.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? prefixIcon;
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
  final AutovalidateMode? autovalidateMode;
  final BoxConstraints? prefixIconConstraints;
  final int? errorMaxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
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
    this.autovalidateMode,
    this.prefixIconConstraints,
    this.errorMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return TextFormField(
      controller: controller,
      onTapOutside: (PointerDownEvent event) {
        FocusScope.of(context).unfocus();
      },
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
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        errorMaxLines: errorMaxLines ?? 2,
        hintStyle: AppTypography.bodyMedium(
          context,
        ).copyWith(color: tokens.textMuted),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 8),
                child: SvgPicture.asset(
                  prefixIcon!,
                  fit: BoxFit.scaleDown,
                  package: AppConfig.packageName,
                ),
              )
            : null,
        prefixIconConstraints: prefixIconConstraints ??
            const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            isEnabled ? (fillColor ?? tokens.surface) : AppColors.deactivateBg,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.textBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          borderSide: const BorderSide(color: AppColors.textBorder),
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
