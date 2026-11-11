import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? iconBgColor;
  final String? trend;
  final bool trendPositive;

  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.iconBgColor,
    this.trend,
    this.trendPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final fg = iconColor ?? tokens.primary;
    final bg = iconBgColor ?? tokens.primary.withValues(alpha: 0.1);

    return Container(
      padding: EdgeInsets.all(tokens.spacingMd),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        boxShadow: tokens.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: fg),
          ),
          const SizedBox(height: 12),
          AppText(value, style: AppTextStyle.displaySmall, fontWeight: FontWeight.w800),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: AppText(label, style: AppTextStyle.caption),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (trendPositive ? tokens.success : tokens.error).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: AppText(
                    trend!,
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w600,
                    color: trendPositive ? tokens.success : tokens.error,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
