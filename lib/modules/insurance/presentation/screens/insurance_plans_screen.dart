import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubits/insurance_plans_cubit.dart';
import '../../domain/entities/insurance_plan_entity.dart';

class InsurancePlansScreen extends StatefulWidget {
  final String? categoryCode;
  final String? vendorCode;

  const InsurancePlansScreen({
    super.key,
    this.categoryCode,
    this.vendorCode,
  });

  @override
  State<InsurancePlansScreen> createState() => _InsurancePlansScreenState();
}

class _InsurancePlansScreenState extends State<InsurancePlansScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InsurancePlansCubit>().loadPlans(categoryCode: widget.categoryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryCode != null
            ? '${widget.categoryCode} Insurance Plans'
            : 'Available Insurance Plans'),
      ),
      body: BlocBuilder<InsurancePlansCubit, InsurancePlansState>(
        builder: (context, state) {
          if (state is InsurancePlansLoading) {
            return const Center(child: AppLoader());
          }

          if (state is InsurancePlansError) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context
                  .read<InsurancePlansCubit>()
                  .loadPlans(categoryCode: widget.categoryCode),
            );
          }

          if (state is InsurancePlansLoaded) {
            if (state.plans.isEmpty) {
              return const Center(
                child: Text('No insurance plans found for this category.'),
              );
            }

            return Column(
              children: [
                if (state.comparedPlans.isNotEmpty)
                  _buildComparisonBar(context, state.comparedPlans),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.plans.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final plan = state.plans[index];
                      final isCompared =
                          state.comparedPlans.any((p) => p.id == plan.id);
                      return _PlanCard(
                        plan: plan,
                        isCompared: isCompared,
                        onCompareToggle: () {
                          context
                              .read<InsurancePlansCubit>()
                              .toggleComparison(plan);
                        },
                        onBuy: () {
                          context.push(
                            '/insurance/buy?planId=${plan.id}&title=${Uri.encodeComponent(plan.title)}&premium=${Uri.encodeComponent(plan.premium)}&cover=${Uri.encodeComponent(plan.cover)}',
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildComparisonBar(
      BuildContext context, List<InsurancePlanEntity> compared) {
    return Container(
      color: AppPalette.neutral100,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.compare_arrows, color: AppPalette.insurance, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Comparing ${compared.length}/2 plans: ${compared.map((p) => p.title).join(' vs ')}',
              style: AppTypography.label2.copyWith(
                color: AppPalette.neutral800,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (compared.length == 2)
            TextButton(
              onPressed: () => _showComparisonDialog(context, compared),
              child: const Text('View Comparison'),
            ),
        ],
      ),
    );
  }

  void _showComparisonDialog(
      BuildContext context, List<InsurancePlanEntity> compared) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Side-by-Side Comparison'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: compared.map((p) {
                    return Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        margin: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppPalette.neutral300),
                          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title,
                                style: AppTypography.title3.copyWith(
                                    fontWeight: FontWeight.bold)),
                            const Divider(),
                            Text('Company: ${p.company}'),
                            Text('Premium: ${p.premium}'),
                            Text('Cover: ${p.cover}'),
                            Text('Settlement: ${p.claimRatio}'),
                            Text('Network: ${p.network}'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _PlanCard extends StatelessWidget {
  final InsurancePlanEntity plan;
  final bool isCompared;
  final VoidCallback onCompareToggle;
  final VoidCallback onBuy;

  const _PlanCard({
    required this.plan,
    required this.isCompared,
    required this.onCompareToggle,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: AppTypography.title2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        plan.company,
                        style: AppTypography.body3.copyWith(
                          color: AppPalette.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.neutral200,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                  ),
                  child: Text(
                    plan.premium,
                    style: AppTypography.title3.copyWith(
                      color: AppPalette.insurance,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppPalette.neutral100,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricItem(label: 'Coverage', value: plan.cover),
                  _MetricItem(label: 'Claim Ratio', value: plan.claimRatio),
                  _MetricItem(label: 'Network', value: plan.network),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '★ ${plan.highlight}',
              style: AppTypography.label2.copyWith(
                color: AppPalette.insurance,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onCompareToggle,
                  icon: Icon(
                    isCompared
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 18,
                  ),
                  label: Text(isCompared ? 'Comparing' : 'Compare'),
                ),
                const Spacer(),
                AppButton(
                  label: 'Select & Buy',
                  onPressed: onBuy,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.label3.copyWith(color: AppPalette.neutral500),
        ),
        Text(
          value,
          style: AppTypography.label1.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
