import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

/// Canonical reusable text field, styled to match the CitizenOne mobile
/// design (soft-filled, rounded, purple-accented on focus).
///
/// Colors/radius are ported from the insurance project's design-system
/// AppTextField token values (primary #613AF5, outline #E2E8F0, radiusSm 12),
/// mapped onto this project's existing AppColors constants.
class AppTextField extends StatelessWidget {
  final String? label;
  final bool isMandatory;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final double borderRadius;

  const AppTextField({
    super.key,
    this.label,
    this.isMandatory = false,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedFill = fillColor ?? AppColors.primaryInputBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              children: isMandatory
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.appPrimaryRedColor),
                      ),
                    ]
                  : const [],
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          enabled: enabled,
          autofocus: autofocus,
          maxLines: obscureText ? 1 : maxLines,
          maxLength: maxLength,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          cursorColor: AppColors.k613AF5,
          decoration: InputDecoration(
            hintText: hintText,
            counterText: "",
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.textHint),
            filled: true,
            fillColor: enabled ? resolvedFill : resolvedFill.withOpacity(0.6),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(
                      prefixIcon!,
                      width: 18,
                      height: 18,
                    ),
                  )
                : null,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  const BorderSide(color: AppColors.k613AF5, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.appPrimaryRedColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                  color: AppColors.appPrimaryRedColor, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  BorderSide(color: AppColors.borderLight.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}
