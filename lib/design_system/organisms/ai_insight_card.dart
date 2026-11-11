import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class AiInsightCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onActionTap;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? leadingIconBg;

  const AiInsightCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onActionTap,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconBg,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacingLg),
      decoration: BoxDecoration(
        color: tokens.surfaceSoft,
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        border: Border.all(color: tokens.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leadingIcon != null) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: leadingIconBg ?? tokens.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(leadingIcon, size: 12, color: leadingIconColor ?? tokens.primary),
                ),
                const SizedBox(width: 8),
              ] else ...[
                Icon(LucideIcons.sparkles, size: 12, color: tokens.accent),
                const SizedBox(width: 6),
              ],
              AppText(
                'CITIZEN AI ALERT',
                style: AppTextStyle.labelSmall,
                color: tokens.textMuted,
                letterSpacing: 0.6,
              ),
            ],
          ),
          SizedBox(height: tokens.spacingSm),
          AppText(title, style: AppTextStyle.headlineSmall, fontWeight: FontWeight.w700),
          const SizedBox(height: 4),
          AppText(description, style: AppTextStyle.bodyMedium, height: 1.4),
          SizedBox(height: tokens.spacingMd),
          AppButton(
            text: actionLabel,
            onPressed: onActionTap,
            size: AppButtonSize.sm,
            icon: LucideIcons.arrow_right,
          ),
        ],
      ),
    );
  }
}
