import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';

class ActivePolicyCard extends StatelessWidget {
  final String title;
  final String policyNumber;
  final String expiryDate;
  final String status;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onViewMore;

  const ActivePolicyCard({
    super.key,
    required this.title,
    required this.policyNumber,
    required this.expiryDate,
    this.status = 'Active',
    this.onDownload,
    this.onShare,
    this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(0, 2))
            ],
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBg)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  title,
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorBgLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    status,
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            AppText(
              policyNumber,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.labelGrey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Expires: $expiryDate',
                  style: AppTextStyle.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelGrey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(package: AppConfig.packageName,AppAssets.iconDownloadOutline),
                    const SizedBox(width: 16),
                    SvgPicture.asset(package: AppConfig.packageName,AppAssets.iconShare),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  'View More',
                  style: AppTextStyle.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                )
              ],
            )
          ],
        ));
  }
}
