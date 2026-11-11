import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/atoms/press_scale_widget.dart';
import 'package:citizenone_app/design_system/molecules/section_header.dart';

class ServiceGridItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const ServiceGridItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

class ServiceGridSection extends StatelessWidget {
  final String title;
  final List<ServiceGridItem> items;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final int crossAxisCount;

  const ServiceGridSection({
    super.key,
    required this.title,
    required this.items,
    this.actionLabel,
    this.onActionTap,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, actionLabel: actionLabel, onActionTap: onActionTap),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
          children: items.map((item) => _GridCell(item: item, tokens: tokens)).toList(),
        ),
      ],
    );
  }
}

class _GridCell extends StatelessWidget {
  final ServiceGridItem item;
  final AppThemeTokens tokens;

  const _GridCell({required this.item, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return PressScaleWidget(
      onPressed: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(tokens.radiusMd),
            ),
            child: Icon(item.icon, size: 24, color: item.color),
          ),
          const SizedBox(height: 8),
          AppText(
            item.label,
            style: AppTextStyle.labelSmall,
            fontWeight: FontWeight.w600,
            color: tokens.textPrimary,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
