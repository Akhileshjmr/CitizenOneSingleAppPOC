import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';

enum AppIconSize { xs, sm, md, lg, xl }

class AppIcon extends StatelessWidget {
  final IconData icon;
  final AppIconSize size;
  final Color? color;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppIconSize.md,
    this.color,
  });

  double get _px => switch (size) {
        AppIconSize.xs => 12,
        AppIconSize.sm => 16,
        AppIconSize.md => 20,
        AppIconSize.lg => 24,
        AppIconSize.xl => 32,
      };

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: _px,
      color: color ?? context.appTokens.textPrimary,
    );
  }
}
