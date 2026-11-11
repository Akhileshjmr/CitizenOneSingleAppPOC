import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';

class AgTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  const AgTextButton({
    super.key,
    required this.onTap,
    required this.title,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w600,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? AgColors.colorPrimary,
        ),
      ),
    );
  }
}
