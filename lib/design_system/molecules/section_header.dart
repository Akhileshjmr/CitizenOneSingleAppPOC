import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onActionTap;
  final String? actionLabel;
  final Color? titleColor;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.onActionTap,
    this.actionLabel,
    this.titleColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final color = titleColor ?? AppColors.textPrimary;

    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
              ],
              AppText(
                title,
                style: AppTextStyle.headlineSmall,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          if (onActionTap != null && actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                foregroundColor: tokens.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Row(
                children: [
                  AppText(actionLabel!, style: AppTextStyle.titleSmall),
                  const SizedBox(width: 4),
                  Icon(
                    LucideIcons.arrow_right,
                    size: 14,
                    color: tokens.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
