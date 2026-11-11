// =============================================================================
// NotificationTile  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: AppAvatar/icon + title + message + timestamp + unread dot.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.timestampLabel,
    this.icon,
    this.iconBackground,
    this.iconColor,
    this.isUnread = false,
    this.onTap,
  });

  final String title;
  final String message;
  final String timestampLabel;
  final IconData? icon;
  final Color? iconBackground;
  final Color? iconColor;
  final bool isUnread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppSpacing.radiusMd);
    final body = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground ?? c.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: AppIcon(
              icon ?? Icons.notifications_none_rounded,
              color: iconColor ?? c.primary,
            ),
          ),
          const AppSpacer.md(axis: Axis.horizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(title,
                          variant: AppTextVariant.bodyStrong, maxLines: 1),
                    ),
                    AppText.caption(timestampLabel, color: c.textSecondary),
                  ],
                ),
                const AppSpacer.xs(),
                AppText(message, variant: AppTextVariant.body, maxLines: 2),
              ],
            ),
          ),
          if (isUnread) ...[
            const AppSpacer.sm(axis: Axis.horizontal),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
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
