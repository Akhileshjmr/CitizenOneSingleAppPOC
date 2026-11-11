import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

/// Desktop transactions table status pill — colored pill + dot derived from
/// the same `transactionStatusLabel` the mobile card already renders.
class TransactionStatusChip extends StatelessWidget {
  final String status;

  const TransactionStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final Color dotColor;
    final Color bgColor;
    final Color textColor;

    if (normalized.contains('fail') ||
        normalized.contains('reject') ||
        normalized.contains('cancel')) {
      dotColor = AppColors.error;
      bgColor = AppColors.errorBgLight;
      textColor = AppColors.error;
    } else if (normalized.contains('in progress') ||
        normalized.contains('process')) {
      dotColor = AppColors.warning;
      bgColor = AppColors.brandYellow;
      textColor = AppColors.warning;
    } else {
      dotColor = AppColors.statusCardGreen;
      bgColor = AppColors.statusGreen;
      textColor = AppColors.statusCardGreen;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          AppText(
            status,
            style: AppTextStyle.labelSmall,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
