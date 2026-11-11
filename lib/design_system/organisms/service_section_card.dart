import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class ServiceSectionCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget child;
  final VoidCallback? onActionTap;
  final String? actionLabel;
  final bool showDivider;
  final Color? bgColor;

  const ServiceSectionCard({
    super.key,
    this.title,
    this.subTitle,
    required this.child,
    this.onActionTap,
    this.actionLabel,
    this.showDivider = false,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title!,
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.w700,
                color: tokens.textPrimary,
              ),
              if (onActionTap != null && actionLabel != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: AppText(
                    actionLabel!,
                    style: AppTextStyle.caption,
                    fontWeight: FontWeight.w600,
                    color: tokens.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
        ],
        if (subTitle != null && subTitle!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                subTitle!.toUpperCase(),
                style: AppTextStyle.headlineSmall,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.serviceHeaderTitle,
              ),
              if (onActionTap != null && actionLabel != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: AppText(
                    actionLabel!,
                    style: AppTextStyle.caption,
                    fontWeight: FontWeight.w600,
                    color: tokens.primary,
                  ),
                ),
            ],
          ),
        ],
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            color: bgColor,
            // boxShadow: tokens.shadowSm,
          ),

          child: child,
        ),
        // SizedBox(height: 20),
        if (showDivider) ...[
          Divider(color: AppColors.surfaceBg),
          SizedBox(height: 10),
        ],
      ],
    );
  }
}
