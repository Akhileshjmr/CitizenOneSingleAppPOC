import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

enum AppBadgeVariant { success, warning, error, info, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final bool dot;

  const AppBadge(
    this.label, {
    super.key,
    this.variant = AppBadgeVariant.neutral,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final (bg, fg) = _colors(tokens);

    return Container(
      padding: dot
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          AppText(label, style: AppTextStyle.labelSmall, fontWeight: FontWeight.w600, color: fg, letterSpacing: 0.2),
        ],
      ),
    );
  }

  (Color bg, Color fg) _colors(AppThemeTokens t) => switch (variant) {
        AppBadgeVariant.success => (t.success.withValues(alpha: 0.12), t.success),
        AppBadgeVariant.warning => (t.warning.withValues(alpha: 0.12), t.warning),
        AppBadgeVariant.error   => (t.error.withValues(alpha: 0.12), t.error),
        AppBadgeVariant.info    => (t.primary.withValues(alpha: 0.12), t.primary),
        AppBadgeVariant.neutral => (t.surfaceMuted, t.textSecondary),
      };
}
