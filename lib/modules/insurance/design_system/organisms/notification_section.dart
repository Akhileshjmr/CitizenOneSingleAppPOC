// =============================================================================
// NotificationSection  —  ORGANISM
// -----------------------------------------------------------------------------
// Header + scrollable list of NotificationTile molecules + empty state.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

class NotificationDisplay {
  const NotificationDisplay({
    required this.id,
    required this.title,
    required this.message,
    required this.timestampLabel,
    required this.icon,
    this.isUnread = false,
    this.iconBackground,
    this.iconColor,
  });
  final String id;
  final String title;
  final String message;
  final String timestampLabel;
  final IconData icon;
  final bool isUnread;
  final Color? iconBackground;
  final Color? iconColor;
}

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.title,
    required this.notifications,
    this.onSeeAll,
    this.onItemTap,
    this.emptyText = 'No notifications',
  });

  final String title;
  final List<NotificationDisplay> notifications;
  final VoidCallback? onSeeAll;
  final ValueChanged<NotificationDisplay>? onItemTap;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: AppText(title, variant: AppTextVariant.subtitle)),
            if (onSeeAll != null)
              AppButton(
                label: 'See all',
                onPressed: onSeeAll,
                variant: AppButtonVariant.text,
                size: AppButtonSize.sm,
              ),
          ],
        ),
        const AppSpacer.sm(),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: notifications.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Center(
                    child: Column(
                      children: [
                        AppIcon(Icons.notifications_off_outlined,
                            size: AppIconSize.xl,
                            color: context.colors.textDisabled),
                        const AppSpacer.sm(),
                        AppText.caption(emptyText),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const AppDivider(
                      indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                  itemBuilder: (_, i) {
                    final n = notifications[i];
                    return NotificationTile(
                      title: n.title,
                      message: n.message,
                      timestampLabel: n.timestampLabel,
                      icon: n.icon,
                      iconBackground: n.iconBackground,
                      iconColor: n.iconColor,
                      isUnread: n.isUnread,
                      onTap: onItemTap == null ? null : () => onItemTap!(n),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
