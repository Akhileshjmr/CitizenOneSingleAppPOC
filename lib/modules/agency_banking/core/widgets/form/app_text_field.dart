/*import 'package:flutter/material.dart';

import '../../../theme/colors/Appcolors.dart';
import '../../../theme/app_theme_style.dart';

/// Labeled text field matching the design: label above, rounded input below.
class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppThemeStyle.fieldLabel),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 14.5,
            color: AppColors.primaryText,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: AppThemeStyle.fieldHint,
            filled: true,
            fillColor: AppColors.cardBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeStyle.inputRadius),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeStyle.inputRadius),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemeStyle.inputRadius),
              borderSide:
                  const BorderSide(color: AppColors.primaryPurple, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}*/



/*/// Full-width purple "Search Account" button with a loading state.
class SearchAccountButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SearchAccountButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          disabledBackgroundColor: AppColors.primaryPurple.withOpacity(0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeStyle.buttonRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text('Search Account', style: AppThemeStyle.buttonLabel),
      ),
    );
  }
}*/

import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_theme_style.dart';

enum IconPosition { left, right, none }

enum AppIconAlignment { top, center, bottom }

class AppTextField extends StatelessWidget {
  final String label;
  final bool isMandatory;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType inputType;
  final bool obscureText;
  final bool enabled;
  final bool isValid;
  final String? errorText;

  final Widget? icon;
  final IconPosition iconPosition;
  final AppIconAlignment iconAlignment;

  // Colors & styling
  final Color? labelColor;
  final Color? bgColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? cursorColor;
  final double borderRadius;
  final TextAlign textAlign;

  final ValueChanged<String>? onChanged;
  final TextCapitalization textCapitalization;

  final int? maxLength;
  final double? height;
  final double fieldSpacing;

  // Renamed NEW properties
  final bool isFocus; // true = focus/tap allowed, false = block focus & tap
  final bool isVisible; // true = show, false = hide

  /// NEW: lets a parent (Bloc/Cubit or StatefulWidget) own and control
  /// focus — e.g. move focus to the next field, or keep a stable
  /// FocusNode across rebuilds instead of Flutter creating one
  /// implicitly. If null, the field manages its own.
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.label,
    this.isMandatory = false,
    this.hintText,
    this.controller,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.isValid = true,
    this.errorText,
    this.icon,
    this.iconPosition = IconPosition.none,
    this.iconAlignment = AppIconAlignment.center,
    this.labelColor,
    this.bgColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.cursorColor,
    this.borderRadius =AppThemeStyle.inputRadius,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.height,
    this.fieldSpacing = 16.0,
    this.isVisible = true,
    this.focusedBorderColor,
    required this.isFocus,
    this.focusNode,
  });

  Alignment _align() {
    switch (iconAlignment) {
      case AppIconAlignment.top:
        return Alignment.topCenter;
      case AppIconAlignment.bottom:
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }

  Widget? _buildIcon(double size) {
    if (icon == null) return null;

    return Align(
      alignment: _align(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SizedBox(
          width: size,
          height: size,
          child: FittedBox(child: icon),
        ),
      ),
    );
  }

  EdgeInsets _adaptivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 480) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    } else if (width < 900) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    } else {
      return const EdgeInsets.symmetric(horizontal: 18, vertical: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    // isVisible = false → hide whole widget
    if (!isVisible) return const SizedBox.shrink();

    final minHeight = height ?? 52;

    // resolve colors
    final resolvedBg = bgColor ?? AppColors.cardBg;
    final resolvedLabel = labelColor ?? AppColors.textFieldPrimaryLabelColor;
    final resolvedText = textColor ?? AppColors.primaryText;
    final resolvedHint = hintColor ?? AppColors.textFieldPrimaryHintColor;
    final resolvedBorder = borderColor ?? AppColors.inputBorder;
    final resolvedFocusedBorder = focusedBorderColor ?? AppColors.textFieldPrimaryFocusedBorderColor;
    final resolvedCursor = cursorColor ?? resolvedText;

    return Padding(
      padding: EdgeInsets.only(bottom: fieldSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: resolvedLabel,
              ),
              children: [
                if (isMandatory)
                  const TextSpan(
                    text: " *",
                    style: TextStyle(
                        color: AppColors.appPrimaryRedColor,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Field
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: AbsorbPointer(
              // FIX: this was commented out, so `absorbing` fell back to
              // its default of `true` — meaning EVERY field blocked all
              // taps/focus/keyboard regardless of isFocus. Re-enabled so
              // isFocus actually does what its name says.
              absorbing: !isFocus,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: inputType,
                obscureText: obscureText,
                enabled: enabled,
                maxLength: maxLength,
                textCapitalization: textCapitalization,
                onChanged: onChanged,
                maxLines: null,
                minLines: 1,
                textAlign: textAlign,

                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.2,
                  color: resolvedText,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: resolvedCursor,

                decoration: InputDecoration(
                  filled: true,
                  fillColor: enabled ? resolvedBg : resolvedBg.withOpacity(0.6),
                  counterText: "",
                  hintText: hintText ?? "",
                  hintStyle:AppThemeStyle.fieldHint, /*TextStyle(
                    fontSize: 14,
                    color: resolvedHint,
                    fontWeight: FontWeight.w400,
                  ),*/
                  prefixIcon: iconPosition == IconPosition.left
                      ? _buildIcon(22)
                      : null,
                  suffixIcon: iconPosition == IconPosition.right
                      ? _buildIcon(22)
                      : null,
                  prefixIconConstraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                      maxWidth: 30,
                      maxHeight: 30),
                  suffixIconConstraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                      maxWidth: 30,
                      maxHeight: 30),
                  contentPadding: _adaptivePadding(context),
                  errorText: isValid ? null : errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: resolvedBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                        color: isValid
                            ? resolvedBorder
                            : AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: isValid
                          ? resolvedFocusedBorder
                          : AppColors.inputBorder,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




