import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';

class InformationBannerWidget extends StatelessWidget {
  const InformationBannerWidget({
    super.key,
    required this.title,
    required this.headerIcon,
    required this.iconBgColor,
    required this.points,
  });

  final String title;
  final String headerIcon;
  final Color iconBgColor;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: iconBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    package: AppConfig.packageName,
                    headerIcon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.glassWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppText(
                    title,
                    style: AppTextStyle.headlineSmall,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: points.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                final isLast = index == points.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0.0 : 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: iconBgColor.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: AppText(point, style: AppTextStyle.bodyLarge),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
