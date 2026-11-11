import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/insurance_transaction_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/transaction_status_chip.dart';

/// Desktop data-table rendering of insurance transactions: purple gradient
/// header, one row per [InsuranceTransactionEntity]. Reads the exact same
/// fields the mobile `ViewTransactionCard` already renders — no new
/// business logic or API calls.
class TransactionDataTable extends StatelessWidget {
  final List<InsuranceTransactionEntity> transactions;

  const TransactionDataTable({super.key, required this.transactions});

  static const List<_ColumnSpec> _columns = [
    _ColumnSpec('Insurance Name', 13),
    _ColumnSpec('TXN ID', 14),
    _ColumnSpec('Policy Holder', 10),
    _ColumnSpec('Ref No', 14),
    _ColumnSpec('Host Ref.No', 14),
    _ColumnSpec('Policy Number', 12),
    _ColumnSpec('Amount', 8),
    _ColumnSpec('Status', 9),
  ];

  static const double _actionsWidth = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HeaderRow(columns: _columns, actionsWidth: _actionsWidth),
          for (var i = 0; i < transactions.length; i++)
            _TransactionRow(
              transaction: transactions[i],
              columns: _columns,
              actionsWidth: _actionsWidth,
              isLast: i == transactions.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ColumnSpec {
  final String label;
  final int flex;

  const _ColumnSpec(this.label, this.flex);
}

class _HeaderRow extends StatelessWidget {
  final List<_ColumnSpec> columns;
  final double actionsWidth;

  const _HeaderRow({required this.columns, required this.actionsWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.brandPurple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          for (final column in columns)
            Expanded(
              flex: column.flex,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AppText(
                      column.label,
                      style: AppTextStyle.labelSmall,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_downward,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          SizedBox(width: actionsWidth),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final InsuranceTransactionEntity transaction;
  final List<_ColumnSpec> columns;
  final double actionsWidth;
  final bool isLast;

  const _TransactionRow({
    required this.transaction,
    required this.columns,
    required this.actionsWidth,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final amount = (transaction.policyGrossPremium ?? 0).toStringAsFixed(2);
    final dateTime = transaction.createdAt != null
        ? DateFormat('dd-MM-yyyy hh:mm a').format(transaction.createdAt!)
        : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.outline),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Expanded(
            flex: columns[0].flex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  'Motor Insurance',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 2),
                AppText(
                  dateTime,
                  style: AppTextStyle.caption,
                  color: AppColors.labelGrey,
                ),
              ],
            ),
          ),
          Expanded(
            flex: columns[1].flex,
            child: AppText(
              transaction.txnNumber,
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: columns[2].flex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  transaction.customerName,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodySmall,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                AppText(
                  ' +${transaction.customerPhone.substring(0, 3)}-${transaction.customerPhone.substring(3)}', // Formatting the currency code on the frontend to reduce unnecessary backend processing.
                  style: AppTextStyle.caption,
                  textAlign: TextAlign.center,
                  color: AppColors.labelGrey,
                ),
              ],
            ),
          ),
          Expanded(
            flex: columns[3].flex,
            child: AppText(
              transaction.referenceNumber ?? '-',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: columns[4].flex,
            child: AppText(
              transaction.hostReferenceNumber ?? '-',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: columns[5].flex,
            child: AppText(
              transaction.policyNumber ?? '-',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: columns[6].flex,
            child: AppText(
              'ZMW $amount',
              style: AppTextStyle.bodySmall,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            flex: columns[7].flex,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: TransactionStatusChip(
                  status: transaction.transactionStatusLabel,
                ),
              ),
            ),
          ),
          SizedBox(
            width: actionsWidth,
            child: _ActionsMenu(transaction: transaction),
          ),
        ],
      ),
    );
  }
}

class _ActionsMenu extends StatelessWidget {
  final InsuranceTransactionEntity transaction;

  const _ActionsMenu({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled =
        transaction.transactionStatusLabel.toLowerCase() == 'failed' ||
            transaction.transactionStatusLabel.toLowerCase() == 'in progress';
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        size: 20,
        color: AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => [
        const PopupMenuItem(
          enabled: false,
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined, size: 18, color: AppColors.primary),
              SizedBox(width: 10),
              AppText('Share', style: AppTextStyle.bodySmall),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'download',
          enabled:
              !(transaction.transactionStatusLabel.toLowerCase() == 'failed' ||
                  transaction.transactionStatusLabel.toLowerCase() ==
                      'in progress'),
          onTap: () {
            context
                .read<MotorInsuranceBloc>()
                .add(DownloadInvoice(policyId: transaction.policyId));
          },
          child: const Row(
            children: [
              Icon(
                Icons.download_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 10),
              AppText('Download', style: AppTextStyle.bodySmall),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Print Receipt',
          enabled: !isDisabled,
          onTap: () {
            context
                .read<MotorInsuranceBloc>()
                .add(PrintReceipt(policyId: transaction.policyId));
          },
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssets.doc,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                    isDisabled
                        ? AppColors.primary.withOpacity(0.38)
                        : AppColors.primary,
                    BlendMode.srcIn),
              ),
              const SizedBox(width: 10),
              const AppText('Print Receipt', style: AppTextStyle.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
