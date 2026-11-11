import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';

class ClaimStatusCard extends StatelessWidget {
  final String title;
  final String policyNumber;
  final String filedDate;
  final String status;
  final VoidCallback? onViewMore;

  const ClaimStatusCard({
    super.key,
    required this.title,
    required this.policyNumber,
    required this.filedDate,
    this.status = 'Approved',
    this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsetsDirectional.symmetric(vertical: 4),
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
                    color: const Color(0xFFBBF7D0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    status,
                    style: AppTextStyle.labelSmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.roleFarmer,
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
                  'Filed: $filedDate',
                  style: AppTextStyle.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelGrey,
                ),
                const AppText(
                  'AK 2,400',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w700,
                ),
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
