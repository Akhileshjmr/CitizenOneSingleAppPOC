import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';

class ActionListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final Color? iconColor;
  final Color? iconBgColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const ActionListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.subtitle,
    this.iconColor,
    this.iconBgColor,
    this.trailing,
    this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final bg = iconBgColor ?? tokens.primary.withValues(alpha: 0.08);
    final fg = iconColor ?? tokens.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(tokens.radiusSm),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spacingMd,
              vertical: tokens.spacingSm,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(leadingIcon, size: 18, color: fg),
                ),
                SizedBox(width: tokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(title, style: AppTextStyle.bodyLarge, fontWeight: FontWeight.w500),
                      if (subtitle != null)
                        AppText(subtitle!, style: AppTextStyle.bodySmall),
                    ],
                  ),
                ),
                trailing ?? Icon(Icons.chevron_right, size: 20, color: tokens.textMuted),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: tokens.spacingMd + 40 + tokens.spacingMd,
            color: tokens.outline,
          ),
      ],
    );
  }
}
