import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/common/loans/domain/entities/loan_offer.dart';

class CompareLoansSheet extends StatelessWidget {
  final List<LoanOffer> offers;

  const CompareLoansSheet({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bestRate = offers.isEmpty
        ? 0.0
        : offers.map((e) => e.interestRate).reduce((a, b) => a < b ? a : b);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              children: [
                AppText(
                  l10n.loansComparePlansTitle,
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF8FAFC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: offers.map((offer) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(child: Text('🏦', style: TextStyle(fontSize: 20))),
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          offer.bankName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.labelSmall,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF334155),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _ComparisonSection(
                    label: l10n.loansCompareInterestRate,
                    values: offers.map((offer) {
                      return _ComparisonValue(
                        value: '${offer.interestRate}%',
                        subtitle: l10n.loansPerAnnum,
                        isBest: offer.interestRate == bestRate,
                      );
                    }).toList(),
                  ),
                  _ComparisonSection(
                    label: l10n.loansCompareProcessingFee,
                    values: offers.map((offer) {
                      return _ComparisonValue(value: '${offer.processingFee}%', subtitle: '');
                    }).toList(),
                  ),
                  _ComparisonSection(
                    label: l10n.loansLabelTenure.toUpperCase(),
                    values: offers.map((offer) {
                      return _ComparisonValue(value: offer.tenure, subtitle: '');
                    }).toList(),
                  ),
                  _ComparisonSection(
                    label: l10n.loansCompareMaxAmount,
                    values: offers.map((offer) {
                      return _ComparisonValue(
                        value: 'ZK ${(offer.maxAmount / 1000).toStringAsFixed(0)},000',
                        subtitle: '',
                      );
                    }).toList(),
                  ),
                  _ComparisonSection(
                    label: l10n.loansCompareFeatures,
                    values: offers.map((offer) {
                      return _ComparisonFeatures(features: offer.features);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: offers.map((offer) {
                  final isBest = offer.interestRate == bestRate;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AppButton(
                        text: l10n.loansActionApply,
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                            '/application/flow?loanType=Personal%20Loan&bankName=${Uri.encodeComponent(offer.bankName)}',
                          );
                        },
                        backgroundColor: isBest ? const Color(0xFF6366F1) : Colors.white,
                        foregroundColor: isBest ? Colors.white : const Color(0xFF6366F1),
                        variant: isBest ? AppButtonVariant.primary : AppButtonVariant.outline,
                        height: 48,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  final String label;
  final List<Widget> values;

  const _ComparisonSection({required this.label, required this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: const Color(0xFFF8FAFC),
          child: Row(
            children: [
              AppText(
                label,
                style: AppTextStyle.labelSmall,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: values.map((value) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: value,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComparisonValue extends StatelessWidget {
  final String value;
  final String subtitle;
  final bool isBest;

  const _ComparisonValue({
    required this.value,
    required this.subtitle,
    this.isBest = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isBest)
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: AppText(
              l10n.loansBestRate,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF16A34A),
            ),
          ),
        AppText(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyle.headlineSmall,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          AppText(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.labelSmall,
            color: const Color(0xFF94A3B8),
          ),
        ],
      ],
    );
  }
}

class _ComparisonFeatures extends StatelessWidget {
  final List<String> features;

  const _ComparisonFeatures({required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(LucideIcons.circle_check, size: 16, color: Color(0xFF16A34A)),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(
                  feature,
                  style: AppTextStyle.bodySmall,
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
