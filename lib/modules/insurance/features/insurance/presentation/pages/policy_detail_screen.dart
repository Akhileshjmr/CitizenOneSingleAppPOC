import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';

class InsuranceDetailsScreen extends StatelessWidget {
  const InsuranceDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InsuranceBloc>(),

      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.surface,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
            ),
          ),
          title: const AppText(
            'Insurance',
            style: AppTextStyle.bodyMedium,
            color: AppColors.black,
          ),
        ),
        body: BlocBuilder<InsuranceBloc, InsuranceState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(top: 28, right: 16, left: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(
                            0,
                            2,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                color: AppColors.brandLavender,
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: const Icon(
                                Icons.account_balance_outlined,
                                color: AppColors.serviceLightBlue,
                                size: 20,
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            /// TITLE
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    'Health Shield Elite',
                                    style: AppTextStyle.bodyMedium,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_border,
                                        color: Colors.orange,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      AppText(
                                        '4.8 (1,450 Reviews)',
                                        style: AppTextStyle.bodySmall,
                                        color: Color(0xFF868686),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            /// TAG
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF93C5FD),
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: const AppText(
                                'Health',
                                style: AppTextStyle.bodySmall,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        /// TABS
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _tabButton(
                                context,
                                title: 'Benefits',
                                index: 0,
                                selected: state.selectedTab == 0,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              _tabButton(
                                context,
                                title: 'Cashless Network',
                                index: 1,
                                selected: state.selectedTab == 1,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              _tabButton(
                                context,
                                title: 'Terms & Exclusions',
                                index: 2,
                                selected: state.selectedTab == 2,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        const Divider(
                          color: AppColors.border,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        const AppText(
                          'PLAN BENEFITS & HIGHLIGHTS',
                          style: AppTextStyle.bodySmall,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        /// CONTENT
                        if (state.selectedTab == 0)
                          Column(
                            children: [
                              _benefitTile(
                                'Free annual health checkup',
                              ),
                              _benefitTile(
                                'Zero copay for senior citizens',
                              ),
                              _benefitTile(
                                'Maternity cover to ZMW 15,000',
                              ),
                              _benefitTile(
                                'No Claim bonus up to 50%',
                              ),
                            ],
                          ),

                        if (state.selectedTab == 1)
                          Column(
                            children: [
                              _benefitTile(
                                '650+ hospitals included',
                              ),
                              _benefitTile(
                                '24/7 emergency support',
                              ),
                              _benefitTile(
                                'Nationwide hospital access',
                              ),
                            ],
                          ),

                        if (state.selectedTab == 2)
                          Column(
                            children: [
                              _benefitTile(
                                'Cosmetic treatments excluded',
                              ),
                              _benefitTile(
                                '30 days waiting period',
                              ),
                              _benefitTile(
                                'Pre-existing conditions apply',
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<InsuranceBloc, InsuranceState>(
          builder: (context, state) {
            return bottomButtons(
              context,
              state,
            );
          },
        ),
      ),
    );
  }

  Widget _tabButton(
    BuildContext context, {
    required String title,
    required int index,
    required bool selected,
  }) {
    return SizedBox(
      width: 150,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          context.read<InsuranceBloc>().add(
                ChangeTabEvent(index),
              );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(
              23,
            ),
            border: Border.all(
              color: AppColors.primary,
            ),
          ),
          child: Center(
            child: AppText(
              title,
              style: AppTextStyle.bodySmall,
              color: selected
                  ? AppColors.surface
                  : AppColors.horizantalHeaderTitle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _benefitTile(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              text,
              style: AppTextStyle.bodySmall,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomButtons(
    BuildContext context,
    InsuranceState state,
  ) {
    return Container(
      height: 95,
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.20),
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ]),
      padding: const EdgeInsets.only(
        bottom: 20,
        right: 20,
        left: 20,
        top: 12,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  'COVER : ZMW 100,000',
                  style: AppTextStyle.bodySmall,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    AppText(
                      'ZMW 1800',
                      style: AppTextStyle.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    AppText(
                      '/yr',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const AppText(
                'Buy Policy',
                style: AppTextStyle.bodyMedium,
                color: AppColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
