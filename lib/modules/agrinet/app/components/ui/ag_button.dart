import 'package:flutter/material.dart';

import '../../utils/ag_colors.dart';

class AgButton extends StatelessWidget {
  const AgButton({
    required this.title,
    required this.onTap,
    super.key,
    this.width,
    this.height = 38,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.borderRadius = 6,
    this.backgroundColor = AgColors.buttonColor,
    this.textStyle = const TextStyle(color: Colors.white),
    this.isOutlined = false,
    this.outlineColor = AgColors.buttonColor,
    this.isTextButton = false,
  });

  final String title;
  final VoidCallback? onTap;

  /// Size
  final double? width;
  final double height; // now always has value

  /// UI
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? textStyle;

  /// Types
  final bool isOutlined;
  final Color outlineColor;
  final bool isTextButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: _buildButton());
  }

  Widget _buildButton() {
    if (isTextButton) {
      return _buildTextButton();
    } else if (isOutlined) {
      return _buildOutlinedButton();
    } else {
      return _buildElevatedButton();
    }
  }

  /// TEXT BUTTON
  Widget _buildTextButton() {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: padding,
        foregroundColor: AgColors.buttonColor,
        minimumSize: Size(width ?? 0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        title,
        style:
            textStyle ??
            const TextStyle(
              fontWeight: FontWeight.bold,
              color: AgColors.buttonColor,
            ),
      ),
    );
  }

  /// FILLED BUTTON
  Widget _buildElevatedButton() {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        minimumSize: Size(width ?? 0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(title, style: textStyle),
    );
  }

  /// OUTLINED BUTTON
  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: outlineColor, width: 1.4),
        padding: padding,
        minimumSize: Size(width ?? 0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        title,
        style:
            textStyle?.copyWith(color: outlineColor) ??
            TextStyle(color: outlineColor),
      ),
    );
  }
}
