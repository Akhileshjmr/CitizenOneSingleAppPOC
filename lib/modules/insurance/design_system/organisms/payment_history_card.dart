import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';

class PaymentHistoryCard extends StatelessWidget {
  final String title;
  final String paymentMethod;
  final String paidDate;
  final String dueAmount;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final VoidCallback? onViewMore;

  const PaymentHistoryCard({
    super.key,
    required this.title,
    required this.paymentMethod,
    required this.paidDate,
    required this.dueAmount,
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
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(0, 2))
            ],
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
                AppText(
                  dueAmount,
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            AppText(
              paymentMethod,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.labelGrey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Paid On: $paidDate',
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
