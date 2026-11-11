// =============================================================================
// InfoTile  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: AppIcon (leading) + title + subtitle + chevron (trailing).
// The "settings row" / "menu item" workhorse used in profile, support,
// notification preferences, etc.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.iconBackground,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusMd);
    final body = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground ?? context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: AppIcon(leadingIcon!, color: context.colors.primary),
            ),
            const AppSpacer.md(axis: Axis.horizontal),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, variant: AppTextVariant.bodyStrong, maxLines: 1),
                if (subtitle != null) ...[
                  const AppSpacer.xs(),
                  AppText.caption(subtitle!, maxLines: 2),
                ],
              ],
            ),
          ),
          trailing ??
              AppIcon(
                Icons.chevron_right_rounded,
                color: context.colors.textSecondary,
              ),
        ],
      ),
    );

    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(borderRadius: radius, onTap: onTap, child: body),
    );
  }
}
