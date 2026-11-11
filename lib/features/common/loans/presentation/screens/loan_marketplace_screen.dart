import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/common/loans/presentation/state/loan_cubit.dart';
import 'package:citizenone_app/features/common/loans/presentation/widgets/compare_loans_sheet.dart';

class LoanMarketplaceScreen extends StatelessWidget {
  final String loanType;

  const LoanMarketplaceScreen({super.key, required this.loanType});

  @override
  Widget build(BuildContext context) {
    final loanCubit = context.watch<LoanCubit>();
    final loanState = loanCubit.state;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              loanType,
              style: AppTextStyle.bodyLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            AppText(
              l10n.loansMarketplaceSubtitle,
              style: AppTextStyle.labelSmall,
              color: const Color(0xFF64748B),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.sliders_horizontal, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    _FilterChip(
                      label: l10n.loansFilterAll,
                      isSelected: loanState.filterType == 'all',
                      onTap: () => loanCubit.setFilter('all'),
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: l10n.loansFilterLowestRate,
                      isSelected: loanState.filterType == 'lowest_rate',
                      onTap: () => loanCubit.setFilter('lowest_rate'),
                    ),
                    const SizedBox(width: 12),
                    _FilterChip(
                      label: l10n.loansFilterFastest,
                      isSelected: loanState.filterType == 'fastest',
                      onTap: () => loanCubit.setFilter('fastest'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: loanState.filteredOffers.length,
                  itemBuilder: (context, index) {
                    final offer = loanState.filteredOffers[index];
                    final isSelected = loanState.selectedOfferIds.contains(offer.id);
                    return _LoanOfferCard(
                      offer: offer,
                      isSelected: isSelected,
                      onSelect: () => loanCubit.toggleOfferSelection(offer.id),
                      onApply: () {
                        context.push(
                          '/application/flow?loanType=${Uri.encodeComponent(loanType)}&bankName=${Uri.encodeComponent(offer.bankName)}',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          if (loanState.selectedOfferIds.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              l10n.loansCompareBanksSelected(loanState.selectedOfferIds.length),
                              style: AppTextStyle.bodySmall,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 4),
                            AppText(
                              l10n.loansCompareOffersTitle,
                              style: AppTextStyle.bodyLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        text: l10n.loansActionViewComparison,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CompareLoansSheet(
                              offers: loanState.selectedOffers,
                            ),
                          );
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E293B),
                        width: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
        child: AppText(
          label,
          style: AppTextStyle.bodySmall,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _LoanOfferCard extends StatelessWidget {
  final dynamic offer;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onApply;

  const _LoanOfferCard({
    required this.offer,
    required this.isSelected,
    required this.onSelect,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          if (isSelected)
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Center(child: Text('🏦', style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      offer.bankName,
                      style: AppTextStyle.bodyMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    if (offer.isPreApproved) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.circle_check, size: 11, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            AppText(
                              l10n.loansPreApproved,
                              style: AppTextStyle.labelSmall,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF16A34A),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    '${offer.interestRate}%',
                    style: AppTextStyle.headlineSmall,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  AppText(
                    l10n.loansInterestRateLabel,
                    style: AppTextStyle.labelSmall,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(l10n.loansLabelTenure, style: AppTextStyle.labelSmall, color: const Color(0xFF94A3B8)),
                    const SizedBox(height: 2),
                    AppText(offer.tenure, style: AppTextStyle.bodySmall, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(l10n.loansLabelFee, style: AppTextStyle.labelSmall, color: const Color(0xFF94A3B8)),
                    const SizedBox(height: 2),
                    AppText('${offer.processingFee}%', style: AppTextStyle.bodySmall, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(l10n.loansLabelMonthlyEmi, style: AppTextStyle.labelSmall, color: const Color(0xFF94A3B8)),
                    const SizedBox(height: 2),
                    AppText(
                      'ZK ${offer.emi.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: AppTextStyle.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppButton(
                  text: isSelected ? l10n.loansActionSelected : l10n.loansActionCompare,
                  onPressed: onSelect,
                  variant: AppButtonVariant.outline,
                  foregroundColor: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                  backgroundColor: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                  height: 48,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: AppButton(
                  text: l10n.loansActionApply,
                  onPressed: onApply,
                  backgroundColor: const Color(0xFF6366F1),
                  height: 48,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
