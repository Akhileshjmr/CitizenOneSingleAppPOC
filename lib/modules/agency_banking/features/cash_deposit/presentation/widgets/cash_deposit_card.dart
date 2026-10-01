import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/core.dart';
import '../../domain/entities/cash_deposit_entity.dart';

class CashDepositCard extends StatelessWidget {
  final CashDepositEntity entity;
  final VoidCallback onNewTransaction;

  const CashDepositCard({
    super.key,
    required this.entity,
    required this.onNewTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.teal,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Deposit Successful',
            style: AppTypography.title.copyWith(color: Colors.teal),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildRow('Transaction ID', entity.transactionId),
          _buildRow('Account Number',
              SecurityUtils.maskAccountNumber(entity.accountNumber)),
          _buildRow('Depositor', entity.depositorName),
          _buildRow('Amount', DateFormatter.formatCurrency(entity.amount)),
          _buildRow('Date', DateFormatter.formatShortDate(entity.timestamp)),
          _buildRow('Status', entity.status),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'New Cash Deposit',
            onPressed: onNewTransaction,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
