// =============================================================================
// DashboardHeader  —  ORGANISM
// -----------------------------------------------------------------------------
// Profile avatar + greeting + notification icon (optionally with unread
// badge) + search molecule. The search field is supplied as an opaque
// callback so the organism does not couple to any specific search store.
// =============================================================================

import 'package:flutter/material.dart';

import '../../core/extensions/build_context_x.dart';
import '../../core/network/session_image_headers.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.userName,
    required this.userInitials,
    this.profileImageUrl,
    this.greeting = 'Welcome back',
    this.unreadCount = 0,
    this.onProfileTap,
    this.onNotificationsTap,
    this.onSearchChanged,
    this.searchHint = 'Search transactions, beneficiaries...',
  });

  final String userName;
  final String userInitials;
  final String? profileImageUrl;
  final String greeting;
  final int unreadCount;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: AppAvatar(
                imageUrl: profileImageUrl,
                size: AppAvatarSize.md,
                headers: sessionImageHeaders(),
              ),
            ),
            const AppSpacer.md(axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.caption(greeting),
                  AppText(userName,
                      variant: AppTextVariant.subtitle, maxLines: 1),
                ],
              ),
            ),
            _NotificationButton(
              count: unreadCount,
              onTap: onNotificationsTap,
              color: c.textPrimary,
              badgeColor: c.error,
            ),
          ],
        ),
        const AppSpacer.lg(),
        SearchBarMolecule(hint: searchHint, onChanged: onSearchChanged),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.count,
    required this.color,
    required this.badgeColor,
    this.onTap,
  });
  final int count;
  final Color color;
  final Color badgeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: AppIcon(Icons.notifications_none_rounded, color: color),
          ),
          if (count > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs, vertical: 1),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: AppText(
                  count > 99 ? '99+' : '$count',
                  variant: AppTextVariant.label,
                  color: context.colors.onPrimary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
