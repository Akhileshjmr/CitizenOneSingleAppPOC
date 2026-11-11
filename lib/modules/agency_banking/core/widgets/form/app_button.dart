import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

/// ---------------- ENUMS ----------------
enum AppButtonShape { rounded, pill, rectangle }

enum AppButtonAlignment { left, center, right }

enum AppVisibility { visible, gone }

enum AppButtonIconPosition { left, center, right }

/// ---------------- WIDGET ----------------
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  // Colors
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? borderColor;
  final double borderWidth;

  // Style
  final AppButtonShape shape;
  final AppButtonAlignment alignment;

  // Size
  final double? width;
  final double? height;
  final bool fullWidth;

  // State
  final bool isEnabled;
  final AppVisibility visibility;

  // Icon / Image
  final IconData? icon;
  final String? imagePath;
  final AppButtonIconPosition iconPosition;
  final double iconSize;
  final Color? iconColor;

  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.enabledColor,
    this.disabledColor,
    this.textColor,
    this.disabledTextColor,
    this.borderColor,
    this.borderWidth = 2,
    this.shape = AppButtonShape.rounded,
    this.alignment = AppButtonAlignment.center,
    this.width,
    this.height,
    this.fullWidth = false,
    this.isEnabled = true,
    this.visibility = AppVisibility.visible,
    this.icon,
    this.imagePath,
    this.iconPosition = AppButtonIconPosition.left,
    this.iconSize = 20,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (visibility == AppVisibility.gone) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: _getAlignment(),
      child: SizedBox(
        width: fullWidth ? double.infinity : width,
        height: height ?? 58,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ButtonStyle(
            elevation: WidgetStateProperty.all(0),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return disabledColor ?? Colors.grey.shade400;
              }

              return enabledColor ?? AppColors.primaryButtonBackgroundColor;
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return disabledTextColor ?? Colors.white;
              }

              return textColor ?? AppColors.primaryButtonTextColor;
            }),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            shape: WidgetStateProperty.all(_buttonShape()),
            side: WidgetStateProperty.all(
              borderColor != null
                  ? BorderSide(
                      color: borderColor!,
                      width: borderWidth,
                    )
                  : BorderSide.none,
            ),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final Color resolvedTextColor = isEnabled
        ? (textColor ?? AppColors.primaryButtonTextColor)
        : (disabledTextColor ?? Colors.white);

    final Widget textWidget = Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: resolvedTextColor,
      ),
    );

    final Widget? iconWidget = _buildIcon(resolvedTextColor);

    if (iconWidget == null) {
      return textWidget;
    }

    switch (iconPosition) {
      case AppButtonIconPosition.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: textWidget),
            const SizedBox(width: 8),
            iconWidget,
          ],
        );

      case AppButtonIconPosition.center:
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0,
              child: textWidget,
            ),
            iconWidget,
          ],
        );

      case AppButtonIconPosition.left:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8),
            Flexible(child: textWidget),
          ],
        );
    }
  }

  Widget? _buildIcon(Color color) {
    if (icon != null) {
      return Icon(
        icon,
        size: iconSize,
        color: iconColor ?? color,
      );
    }

    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: iconSize,
        height: iconSize,
      );
    }

    return null;
  }

  OutlinedBorder _buttonShape() {
    switch (shape) {
      case AppButtonShape.pill:
        return const StadiumBorder();

      case AppButtonShape.rectangle:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        );

      case AppButtonShape.rounded:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        );
    }
  }

  Alignment _getAlignment() {
    switch (alignment) {
      case AppButtonAlignment.left:
        return Alignment.centerLeft;

      case AppButtonAlignment.right:
        return Alignment.centerRight;

      case AppButtonAlignment.center:
        return Alignment.center;
    }
  }
}
