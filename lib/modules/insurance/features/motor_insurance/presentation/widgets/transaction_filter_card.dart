import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

/// Desktop-only filter bar for [InsuranceTransactionScreen]: search occupies
/// most of the width with From/To date fields aligned to the right, wrapping
/// to a stacked layout on narrower (tablet) widths. Reuses the same
/// controllers/callbacks the mobile `SearchTransactionCard` already wires to
/// the screen — no new business logic.
class TransactionFilterCard extends StatelessWidget {
  final TextEditingController searchController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final ValueChanged<String>? onSearch;

  const TransactionFilterCard({
    super.key,
    required this.searchController,
    required this.fromDate,
    required this.toDate,
    required this.onFromTap,
    required this.onToTap,
    this.onSearch,
  });

  static const double _fieldHeight = 46;
  static const double _labelHeight = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 720;

          final dateRow = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DesktopDateField(
                  title: 'From Date',
                  date: fromDate,
                  onTap: onFromTap,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DesktopDateField(
                  title: 'To Date',
                  date: toDate,
                  onTap: onToTap,
                ),
              ),
            ],
          );

          final search = _SearchField(
            controller: searchController,
            onChanged: onSearch,
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                search,
                const SizedBox(height: 16),
                dateRow,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: search),
              const SizedBox(width: 16),
              SizedBox(
                width: 170,
                child: _DesktopDateField(
                  title: 'From Date',
                  date: fromDate,
                  onTap: onFromTap,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 170,
                child: _DesktopDateField(
                  title: 'To Date',
                  date: toDate,
                  onTap: onToTap,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const _SearchField({required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TransactionFilterCard._fieldHeight +
          TransactionFilterCard._labelHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Search Ref No, Name, ...',
            hintStyle: const TextStyle(color: AppColors.labelGrey),
            prefixIcon: const Icon(Icons.search),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopDateField extends StatelessWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;

  const _DesktopDateField({
    required this.title,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          title,
          style: AppTextStyle.bodySmall,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: TransactionFilterCard._fieldHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    date == null
                        ? 'DD/MM/YYYY'
                        : DateFormat('dd/MM/yyyy').format(date!),
                    style: AppTextStyle.bodyMedium,
                    color: date == null
                        ? AppColors.labelGrey
                        : AppColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.labelGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
