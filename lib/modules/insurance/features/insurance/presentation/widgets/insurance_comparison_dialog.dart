import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/data/models/insurance_plan.dart';

class InsuranceComparisonBottomSheet extends StatelessWidget {
  const InsuranceComparisonBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsuranceBloc, InsuranceState>(
      builder: (context, state) {
        final List<InsurancePlan> plans = mockInsurancePlans
            .where((plan) => state.selectedPlanIds.contains(plan.id))
            .toList();

        return Padding(
          padding: const EdgeInsets.only(top: 96),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  SizedBox(
                    height: 62,
                    width: 352,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          'Insurance Plan Comparison',
                          style: AppTextStyle.bodyLarge,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.deactivateBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.close),
                            iconSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.border,
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double columnWidth = (plans.length > 2)
                            ? 154.0
                            : (constraints.maxWidth - 48) / plans.length;
                        final double totalWidth = (plans.length > 2)
                            ? plans.length * 154.0 + 48.0
                            : constraints.maxWidth;

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: totalWidth,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: 122,
                                    padding: const EdgeInsets.only(
                                        left: 24, top: 20, bottom: 20, right: 24),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: plans
                                          .map(
                                            (plan) => SizedBox(
                                              height: 82,
                                              width: columnWidth,
                                              child: _planHeader(
                                                title: plan.title,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  _comparisonRow(
                                    title: 'COMPANY',
                                    values:
                                        plans.map((e) => e.company).toList(),
                                    columnWidth: columnWidth,
                                  ),
                                  _comparisonRow(
                                    title: 'PREMIUM RATE',
                                    values:
                                        plans.map((e) => e.premiumWithYr).toList(),
                                    columnWidth: columnWidth,
                                  ),
                                  _comparisonRow(
                                    title: 'COVER AMOUNT',
                                    values: plans.map((e) => e.cover).toList(),
                                    columnWidth: columnWidth,
                                  ),
                                  _comparisonRow(
                                    title: 'CLAIM RATIO',
                                    values: plans.map((e) => e.claim).toList(),
                                    columnWidth: columnWidth,
                                  ),
                                  _comparisonRow(
                                    title: 'NETWORK SIZE',
                                    values:
                                        plans.map((e) => e.network).toList(),
                                    columnWidth: columnWidth,
                                  ),
                                  _comparisonRow(
                                    title: 'KEY HIGHLIGHT',
                                    values:
                                        plans.map((e) => e.highlight).toList(),
                                    columnWidth: columnWidth,
                                  ),
                                  const Divider(
                                    color: AppColors.border,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 80,
                                    padding: const EdgeInsets.only(
                                        left: 24, bottom: 24, right: 24, top: 16),
                                    child: Row(
                                      children: plans
                                          .map(
                                            (_) => SizedBox(
                                                height: 40,
                                                width: columnWidth,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                                  child: _buyButton(),
                                                )),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _planHeader({
    required String title,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.brandLavender,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            color: AppColors.serviceLightBlue,
            size: 15,
          ),
        ),
        AppText(
          title,
          style: AppTextStyle.bodySmall,
          color: AppColors.black,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _comparisonRow({
    required String title,
    required List<String> values,
    required double columnWidth,
  }) {
    return SizedBox(
      height: 84,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: AppTextStyle.labelSmall,
            color: AppColors.serviceHeaderTitle,
          ),
          const SizedBox(height: 8),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(bottom: 20, top: 20, left: 24, right: 24),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: values
                  .map(
                    (value) => SizedBox(
                      width: columnWidth,
                      height: 20,
                      child: _valueCard(value),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _valueCard(String value) {
    return Center(
      child: AppText(
        value,
        style: AppTextStyle.bodySmall,
        color: AppColors.black,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buyButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {},
      child: const AppText(
        'Buy',
        style: AppTextStyle.bodyMedium,
        color: AppColors.surface,
      ),
    );
  }
}

void openInsuranceComparisonBottomSheet(BuildContext context) {
  final insuranceBloc = BlocProvider.of<InsuranceBloc>(context);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: insuranceBloc,
      child: const InsuranceComparisonBottomSheet(),
    ),
  );
}
