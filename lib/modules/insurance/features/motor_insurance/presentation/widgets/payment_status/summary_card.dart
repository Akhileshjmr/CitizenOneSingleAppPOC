// =============================================================================
// SummaryCard — reusable label/value list used for "Transaction details"
// (Payment Failed / Policy Issuance Failed) and the success receipt
// ("Insurance Company Policy Receipt"). Wraps the existing
// `transactionDetailRow` helper (transaction_detail_widgets.dart) instead of
// duplicating its row styling.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/transaction_detail_widgets.dart';

class SummaryRow {
  const SummaryRow(this.label, this.value);
  final String label;
  final String value;
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    this.title,
    required this.rows,
    this.totalLabel,
    this.totalValue,
    this.decorated = true,
  });

  final String? title;
  final List<SummaryRow> rows;
  final String? totalLabel;
  final String? totalValue;

  /// Whether this widget draws its own bordered container. Set to false
  /// when the caller already wraps it in a card.
  final bool decorated;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          AppText(
            title!,
            style: AppTextStyle.headlineSmall,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          const SizedBox(height: 4),
        ],
        for (final row in rows)
          transactionDetailRow(
              label: row.label, value: row.value, context: context),
        if (totalValue != null) ...[
          transactionDetailRow(
              label: totalLabel ?? 'Total Amount',
              value: totalValue!,
              emphasize: true,
              context: context),
        ],
      ],
    );

    if (!decorated) return content;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: content,
    );
  }
}
