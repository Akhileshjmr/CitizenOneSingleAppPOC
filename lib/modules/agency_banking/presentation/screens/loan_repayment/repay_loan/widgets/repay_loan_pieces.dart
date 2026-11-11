import 'package:flutter/material.dart';

import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../loan_account_selection/widgets/app_status_badge.dart';
import 'loan_repayment_details.dart';

/// Loan summary card — matches the screenshot exactly: loan type +
/// account number + "Due" badge up top, a divider, then a 2x2 grid
/// (Customer Name / EMI Amount, Outstanding Amount / Total Amount Due).
class LoanSummaryCard extends StatelessWidget {
  final LoanRepaymentDetails details;

  const LoanSummaryCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppThemeStyle.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(details.loanType,
                        fontSize: 12,
                        color: AppColors.secondaryText,
                        padding: EdgeInsets.zero),
                    const SizedBox(height: 2),
                    AppText(details.accountNumber,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                        padding: EdgeInsets.zero),
                  ],
                ),
              ),
              AppStatusBadge.amber(details.statusLabel),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailCell(
                  label: 'Customer Name',
                  value: details.customerName,
                ),
              ),
              Expanded(
                child: _DetailCell(
                  label: 'EMI Amount',
                  value: '${details.currencySymbol} '
                      '${formatAmount(details.emiAmount)}',
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailCell(
                  label: 'Outstanding Amount',
                  value: '${details.currencySymbol} '
                      '${formatAmount(details.outstandingAmount)}',
                ),
              ),
              Expanded(
                child: _DetailCell(
                  label: 'Total Amount Due',
                  value: '${details.currencySymbol} '
                      '${formatAmount(details.totalAmountDue)}',
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _DetailCell({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        AppText(label,
            fontSize: 12, color: AppColors.secondaryText, padding: EdgeInsets.zero),
        const SizedBox(height: 3),
        AppText(value,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
            padding: EdgeInsets.zero),
      ],
    );
  }
}

/// A selectable card with a leading radio circle — used for both
/// "Pay Total Due Amount" (title + subtitle + trailing amount, no
/// embedded field) and "Other Amount" (title only, with an embedded
/// child widget — the amount TextField — shown only while selected).
class RepaymentOptionCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final Widget? child;
  final VoidCallback onTap;

  const RepaymentOptionCard({
    super.key,
    required this.selected,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingText,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppThemeStyle.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppThemeStyle.cardRadius),
          border: Border.all(
            color:
            selected ? AppColors.primaryPurple : AppColors.inputBorder,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RadioCircle(selected: selected),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(title,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                          padding: EdgeInsets.zero),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        AppText(subtitle!,
                            fontSize: 12.5,
                            color: AppColors.secondaryText,
                            padding: EdgeInsets.zero),
                      ],
                    ],
                  ),
                ),
                if (trailingText != null)
                  AppText(trailingText!,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      padding: EdgeInsets.zero),
              ],
            ),
            if (child != null && selected) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: child,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  const _RadioCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
          selected ? AppColors.primaryPurple : AppColors.inputBorder,
          width: 1.6,
        ),
      ),
      child: selected
          ? Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryPurple,
          ),
        ),
      )
          : null,
    );
  }
}

