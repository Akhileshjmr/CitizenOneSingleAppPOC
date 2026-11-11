import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:flutter_svg/svg.dart';

class HeroRoleChip extends StatelessWidget {
  final String icon;
  final Color? iconColor;
  final String label;
  final bool isDark;
  final String date;

  const HeroRoleChip({
    super.key,
    required this.icon,
    this.iconColor,
    required this.label,
    required this.isDark,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    if (!isDark) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                iconColor ?? tokens.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          AppText(label, style: AppTextStyle.titleSmall),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              iconColor ?? Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 12),
        AppText(
          label,
          style: AppTextStyle.caption,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.9),
          letterSpacing: 0.5,
        ),
        const Spacer(),
        Container(
          width: 50,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: AppText(
            date,
            style: AppTextStyle.labelSmall,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
