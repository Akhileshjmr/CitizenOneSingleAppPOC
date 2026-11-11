import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class ServiceListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBgColor;
  final Widget? trailing;

  const ServiceListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = LucideIcons.arrow_up_right,
    this.onTap,
    this.iconColor,
    this.iconBgColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      margin: EdgeInsets.only(bottom: tokens.spacingSm),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        border: Border.all(color: tokens.outline.withValues(alpha: 0.6)),
        boxShadow: [
          ...tokens.shadowSm,
          const BoxShadow(
            color: AppColors.shadowColor,
            offset: Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor ?? tokens.surfaceSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor ?? tokens.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: AppTextStyle.bodyLarge,
                        fontWeight: FontWeight.w700,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        AppText(subtitle!, style: AppTextStyle.bodySmall),
                      ],
                    ],
                  ),
                ),
                trailing ?? Icon(Icons.chevron_right, color: tokens.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
