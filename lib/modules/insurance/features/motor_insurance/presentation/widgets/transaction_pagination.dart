import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

/// Bottom pagination bar for the desktop transactions table: "x-y of n
/// items" on the left, Previous/Next on the right. Purely presentational —
/// paging is driven by the screen, which reuses the existing bloc's
/// load-more/hasReachedMax pagination state.
class TransactionPagination extends StatelessWidget {
  final int startIndex;
  final int endIndex;
  final int totalItems;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const TransactionPagination({
    super.key,
    required this.startIndex,
    required this.endIndex,
    required this.totalItems,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          totalItems == 0
              ? '0 items'
              : '${startIndex + 1}-$endIndex of $totalItems items',
          style: AppTextStyle.bodySmall,
          color: AppColors.textSecondary,
        ),
        Row(
          children: [
            _PagerButton(label: 'Previous', onTap: onPrevious),
            const SizedBox(width: 12),
            _PagerButton(label: 'Next', onTap: onNext),
          ],
        ),
      ],
    );
  }
}

class _PagerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PagerButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: AppText(
              label,
              style: AppTextStyle.bodySmall,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
