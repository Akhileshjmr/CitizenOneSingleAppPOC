import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';

class AppDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;
  final double thickness;
  final Color? color;

  const AppDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? context.appTokens.outline,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      height: thickness,
    );
  }
}
