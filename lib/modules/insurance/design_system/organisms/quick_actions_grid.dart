// =============================================================================
// QuickActionsGrid  —  ORGANISM
// -----------------------------------------------------------------------------
// Composes QuickActionTile molecules into a responsive grid. The number of
// columns adapts to the device class.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/responsive.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

class QuickActionItem {
  const QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.iconBackground,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackground;
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.title = 'Quick actions',
  });

  final List<QuickActionItem> actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive(phone: 4, tablet: 6, desktop: 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, variant: AppTextVariant.subtitle),
        const AppSpacer.sm(),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.85,
            children: actions
                .map((a) => QuickActionTile(
                      icon: a.icon,
                      label: a.label,
                      onTap: a.onTap,
                      iconColor: a.iconColor,
                      iconBackground: a.iconBackground,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
