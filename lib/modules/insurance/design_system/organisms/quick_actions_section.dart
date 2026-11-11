import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/extensions/build_context_x.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    super.key,
    required this.title,
    required this.items,
  });

  final List<ActionItem> items;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          color: colors.textPrimary,
          style: AppTextStyle.headlineSmall,
          fontSize: 16,
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingLg,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = AppSpacing.lg;
              final width = (constraints.maxWidth - (spacing * 3)) / 4;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: items
                    .map((item) => SizedBox(width: width, child: item))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.disable,
    this.onTap,
  });

  final String title;
  final String icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;
  final bool? disable;

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: SvgPicture.asset(
              package: AppConfig.packageName,
              icon,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
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
