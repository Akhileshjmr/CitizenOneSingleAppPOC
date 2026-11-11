import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class QuoteSummaryCard extends StatelessWidget {
  final String coverage;
  final String policyFor;
  final String period;
  final DateTime? policyStartDate;
  final DateTime? policyEndDate;
  final int? selectedQuarters;
  final int? selectedMonths;
  final VoidCallback? onTap;

  const QuoteSummaryCard({
    super.key,
    required this.coverage,
    required this.policyFor,
    this.period = '',
    this.policyStartDate,
    this.policyEndDate,
    this.selectedQuarters,
    this.selectedMonths,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _buildSummaryRow('Coverage', coverage),
      if (policyStartDate != null)
        _buildSummaryRow('Policy Start Date', _fmtDate(policyStartDate!)),
      if (selectedQuarters != null && selectedMonths != null) ...[
        _buildSummaryRow(
          'Duration',
          _formatTenure(selectedQuarters!, selectedMonths!,
              capitalizeMonths: false),
        ),
      ],
      if (period.isNotEmpty) _buildSummaryRow('Period', period),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.blueBorder,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                LucideIcons.file_text,
                color: AppColors.blue700,
                size: 24,
              ),
              SizedBox(width: 9),
              AppText(
                'Quote Summary',
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            rows[i],
          ],
        ],
      ),
    );
  }

  String _fmtDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  String _formatTenure(int quarters, int months,
      {required bool capitalizeMonths}) {
    final quarterWord = quarters == 1 ? 'Quarter' : 'Quarters';
    final monthsWord = capitalizeMonths ? 'Months' : 'months';
    return '$quarters $quarterWord ($months $monthsWord)';
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.blue700,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: '$label : ',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.serviceHeaderTitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
