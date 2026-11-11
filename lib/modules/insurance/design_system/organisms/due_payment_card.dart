import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';

class DuePaymentCard extends StatelessWidget {
  final String title;
  final String policyProduct;
  final String dueType;
  final String daysLeft;
  final String dueAmount;
  final VoidCallback onPayPremiumTap;
  final VoidCallback? onViewMore;

  const DuePaymentCard({
    super.key,
    required this.title,
    required this.policyProduct,
    required this.dueType,
    required this.dueAmount,
    required this.onPayPremiumTap,
    this.daysLeft = '2d left',
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
                    color: AppColors.orangeBgLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    daysLeft,
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            AppText(
              policyProduct,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.labelGrey,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      dueType,
                      style: AppTextStyle.labelSmall,
                      fontWeight: FontWeight.w500,
                      color: AppColors.serviceHeaderTitle,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      dueAmount,
                      style: AppTextStyle.bodyMedium,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                AppButton(
                  onPressed: () => onPayPremiumTap(),
                  width: 150,
                  height: 32,
                  label: 'Pay Premium',
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
