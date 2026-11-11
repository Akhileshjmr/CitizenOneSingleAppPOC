import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

class AppVerticalDivider extends StatelessWidget {
  final double? width;
  final double thickness;
  final Color? color;

  const AppVerticalDivider({
    super.key,
    this.width,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      color: color ?? context.appTokens.outline,
      thickness: thickness,
      width: width ?? 16,
    );
  }
}
