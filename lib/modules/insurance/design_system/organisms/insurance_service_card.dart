import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';

class BuyPolicyCard extends StatelessWidget {
  const BuyPolicyCard({
    super.key,
    required this.title,
    required this.planId,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.coverLimit,
    required this.claimRatio,
    required this.networkSize,
    required this.onCompareTap,
    required this.onBuyPlanTap,
    required this.onDetailsTap,
  });

  final String title;
  final String subtitle;
  final String planId;
  final String price;
  final IconData icon;
  final String coverLimit;
  final String claimRatio;
  final String networkSize;
  final VoidCallback onCompareTap;
  final VoidCallback onBuyPlanTap;
  final VoidCallback onDetailsTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsuranceBloc, InsuranceState>(
      builder: (context, state) {
        final isSelected = state.isSelected(planId);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color:
                    isSelected ? AppColors.serviceCommon : AppColors.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              /// TOP SECTION
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: AppColors.brandLavender,
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(package: AppConfig.packageName,
                        AppAssets.iconAccountBalanceProfile,
                        colorFilter: const ColorFilter.mode(
                          AppColors.serviceCommon,
                          BlendMode.srcIn,
                        ),
                      )),

                  const SizedBox(width: 16),

                  /// TITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          title,
                          style: AppTextStyle.bodyMedium,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          subtitle,
                          style: AppTextStyle.caption,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),

                  /// PRICE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        price,
                        style: AppTextStyle.bodyMedium,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                      const AppText(
                        '/yr',
                        style: AppTextStyle.bodyMedium,
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// DETAILS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoWidget(
                    title: 'Cover Limit',
                    value: coverLimit,
                  ),
                  _InfoWidget(
                    title: 'Claim Ratio',
                    value: claimRatio,
                  ),
                  _InfoWidget(
                    title: 'Network Size',
                    value: networkSize,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// CASHLESS BAR
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4.5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF3F8FF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xffB9D2FF),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(package: AppConfig.packageName,
                      AppAssets.magicButton,
                    ),
                    const SizedBox(width: 12),
                    const AppText(
                      '100% Cashless network coverage',
                      style: AppTextStyle.labelSmall,
                      color: AppColors.blue700,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<InsuranceBloc>()
                            .add(ToggleComparisonPlan(planId));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: AppText(
                            isSelected ? 'Remove' : 'Compare',
                            style: AppTextStyle.labelSmall,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onBuyPlanTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.blue700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: AppText(
                            'Buy Plan',
                            style: AppTextStyle.labelSmall,
                            fontWeight: FontWeight.bold,
                            color: AppColors.glassWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: onDetailsTap,
                child: const AppText(
                  'Details',
                  style: AppTextStyle.titleSmall,
                  color: AppColors.primary,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _InfoWidget extends StatelessWidget {
  final String title;
  final String value;

  const _InfoWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          title,
          style: AppTextStyle.labelSmall,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 2),
        AppText(
          value,
          style: AppTextStyle.bodyMedium,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}
