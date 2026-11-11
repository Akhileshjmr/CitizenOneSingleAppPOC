import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/extensions/build_context_x.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({
    super.key,
    this.title,
    required this.items,
  });

  final String? title;
  final List<ServiceItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          AppText(
            title!,
            color: colors.textPrimary,
            style: AppTextStyle.titleSmall,
            fontSize: 16,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              items.length,
              (index) => items[index],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class ServiceItem extends StatelessWidget {
  const ServiceItem(
      {super.key,
      required this.icon,
      required this.label,
      this.iconColor,
      this.onTap,
      this.disable});

  final String icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool? disable;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F212121),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  package: AppConfig.packageName,
                  icon,
                  colorFilter: iconColor == null
                      ? null
                      : ColorFilter.mode(iconColor!, BlendMode.srcIn),
                  width: 26,
                  height: 26,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );

    if (disable == true) {
      return IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: 0.5,
          child: button,
        ),
      );
    }
    return button;
  }
}
