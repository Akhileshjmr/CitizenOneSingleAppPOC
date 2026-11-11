// =============================================================================
// QuickActionTile  —  MOLECULE
// -----------------------------------------------------------------------------
// Combines: rounded-icon container + label + optional badge. Used by the
// QuickActionsGrid organism on the dashboard.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor,
    this.iconBackground,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(AppSpacing.radiusMd);

    return InkWell(
      borderRadius: radius,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBackground ?? c.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: AppIcon(icon,
                  color: iconColor ?? c.primary, size: AppIconSize.lg),
            ),
            const AppSpacer.sm(),
            AppText.caption(label, textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }
}
