import 'package:flutter/material.dart';

import '../../theme/ag_text_styles.dart';
import '../../utils/app_colors.dart';

class AgButton extends StatelessWidget {
  const AgButton({
    required this.title,
    required this.onTap,
    super.key,
    this.width,
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.borderRadius = 8,
    this.backgroundColor,
    this.textStyle,

    /// NEW - Prefix Icon
    this.prefixIcon,

    /// Existing Suffix Icon
    this.icon,

    this.iconSpacing = 8,
    this.gradient,

    /// Types
    this.isOutlined = false,
    this.outlineColor,
    this.isTextButton = false,

    /// Enable / Disable
    this.isEnabled = true,
    this.disabledColor,
  });

  final String title;
  final VoidCallback? onTap;

  /// Size
  final double? width;
  final double height;

  /// UI
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  /// NEW - Prefix Icon
  final IconData? prefixIcon;

  /// Existing Suffix Icon
  final IconData? icon;

  final double iconSpacing;
  final Gradient? gradient;

  /// Types
  final bool isOutlined;
  final Color? outlineColor;
  final bool isTextButton;

  /// Enable / Disable
  final bool isEnabled;
  final Color? disabledColor;

  bool get _isClickable => isEnabled && onTap != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    if (isTextButton) return _buildTextButton();
    if (isOutlined) return _buildOutlinedButton();
    return _buildGradientButton();
  }

  /// ✅ GRADIENT BUTTON (Default)
  Widget _buildGradientButton() {
    final Color disabledBgColor = disabledColor ?? Colors.grey.shade400;

    return Opacity(
      opacity: isEnabled ? 1 : 0.7,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: _isClickable ? onTap : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: isEnabled ? null : disabledBgColor,
              gradient:
                  isEnabled
                      ? (gradient ??
                          LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.primary, AppColors.primary],
                          ))
                      : null,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              height: height,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Prefix Icon
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      size: 18,
                      color: isEnabled ? Colors.white : Colors.white70,
                    ),
                    SizedBox(width: iconSpacing),
                  ],

                  Text(
                    title,
                    style: (textStyle ?? kw500White16).copyWith(
                      color:
                          isEnabled
                              ? (textStyle?.color ?? Colors.white)
                              : Colors.white70,
                    ),
                  ),

                  /// Existing Suffix Icon
                  if (icon != null) ...[
                    SizedBox(width: iconSpacing),
                    Icon(
                      icon,
                      size: 18,
                      color: isEnabled ? Colors.white : Colors.white70,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// TEXT BUTTON
  Widget _buildTextButton() {
    return TextButton(
      onPressed: _isClickable ? onTap : null,
      style: TextButton.styleFrom(
        padding: padding,
        foregroundColor: isEnabled ? AppColors.primary : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Prefix Icon
          if (prefixIcon != null) ...[
            Icon(
              prefixIcon,
              size: 18,
              color: isEnabled ? AppColors.primary : Colors.grey,
            ),
            SizedBox(width: iconSpacing),
          ],

          Text(
            title,
            style:
                textStyle ??
                TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? AppColors.primary : Colors.grey,
                ),
          ),

          /// Existing Suffix Icon
          if (icon != null) ...[
            SizedBox(width: iconSpacing),
            Icon(
              icon,
              size: 18,
              color: isEnabled ? AppColors.primary : Colors.grey,
            ),
          ],
        ],
      ),
    );
  }

  /// OUTLINED BUTTON
  Widget _buildOutlinedButton() {
    final Color borderColor =
        isEnabled ? (outlineColor ?? AppColors.primary) : Colors.grey;

    return OutlinedButton(
      onPressed: _isClickable ? onTap : null,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 1.4),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Prefix Icon
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: 18, color: borderColor),
            SizedBox(width: iconSpacing),
          ],

          Text(
            title,
            style: textStyle ?? kw500Primary16.copyWith(color: borderColor),
          ),

          /// Existing Suffix Icon
          if (icon != null) ...[
            SizedBox(width: iconSpacing),
            Icon(icon, size: 18, color: borderColor),
          ],
        ],
      ),
    );
  }
}
