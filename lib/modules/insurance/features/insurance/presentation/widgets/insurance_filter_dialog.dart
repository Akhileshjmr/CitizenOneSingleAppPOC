import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InsuranceBloc>(),

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: BlocBuilder<InsuranceBloc, InsuranceState>(
          builder: (context, state) {
            final bloc = context.read<InsuranceBloc>();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        'Filters',
                        style: AppTextStyle.headlineSmall,
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.highlight_off,
                          color: AppColors.black,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  const AppText(
                    'Sort By',
                    style: AppTextStyle.bodyMedium,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      FilterChipWidget(
                        title: 'Popular (Default)',
                        selected: state.sortBy == 'Popular (Default)',
                        onTap: () {
                          bloc.add(
                            SelectSortByEvent(
                              'Popular (Default)',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Premium: Low to High',
                        selected: state.sortBy == 'Premium: Low to High',
                        onTap: () {
                          bloc.add(
                            SelectSortByEvent(
                              'Premium: Low to High',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Premium: High to Low',
                        selected: state.sortBy == 'Premium: High to Low',
                        onTap: () {
                          bloc.add(
                            SelectSortByEvent(
                              'Premium: High to Low',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Claim Ratio',
                        selected: state.sortBy == 'Claim Ratio',
                        onTap: () {
                          bloc.add(
                            SelectSortByEvent(
                              'Claim Ratio',
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const AppText(
                    'Premium Range',
                    style: AppTextStyle.bodyMedium,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      FilterChipWidget(
                        title: 'Any Premium',
                        selected: state.premiumRange == 'Any Premium',
                        onTap: () {
                          bloc.add(
                            SelectPremiumRangeEvent(
                              'Any Premium',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Budget (< ZMW 1,500)',
                        selected: state.premiumRange == 'Budget (< ZMW 1,500)',
                        onTap: () {
                          bloc.add(
                            SelectPremiumRangeEvent(
                              'Budget (< ZMW 1,500)',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Mid-Range (< ZMW 1,500 - 3,500)',
                        selected: state.premiumRange ==
                            'Mid-Range (< ZMW 1,500 - 3,500)',
                        onTap: () {
                          bloc.add(
                            SelectPremiumRangeEvent(
                              'Mid-Range (< ZMW 1,500 - 3,500)',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Premium (> ZMW 3,500)',
                        selected: state.premiumRange == 'Premium (> ZMW 3,500)',
                        onTap: () {
                          bloc.add(
                            SelectPremiumRangeEvent(
                              'Premium (> ZMW 3,500)',
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const AppText(
                    'Minimum Claim Settlement Ratio',
                    style: AppTextStyle.bodyMedium,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      FilterChipWidget(
                        title: 'Any Ratio',
                        selected: state.claimRatio == 'Any Ratio',
                        onTap: () {
                          bloc.add(
                            SelectClaimRatioEvent(
                              'Any Ratio',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'High Rated (>=95%)',
                        selected: state.claimRatio == 'High Rated (>=95%)',
                        onTap: () {
                          bloc.add(
                            SelectClaimRatioEvent(
                              'High Rated (>=95%)',
                            ),
                          );
                        },
                      ),
                      FilterChipWidget(
                        title: 'Ultra Reliable (>=98%)',
                        selected: state.claimRatio == 'Ultra Reliable (>=98%)',
                        onTap: () {
                          bloc.add(
                            SelectClaimRatioEvent(
                              'Ultra Reliable (>=98%)',
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: OutlinedButton(
                  //         onPressed: () {
                  //           bloc.add(
                  //             ResetFilterEvent(),
                  //           );
                  //         },
                  //         child: const Text('Reset'),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           Navigator.pop(
                  //             context,
                  //             state,
                  //           );
                  //         },
                  //         child: const Text('Apply'),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.surface,
                ),
              ),
            AppText(
              title,
              style: AppTextStyle.bodySmall,
              color: selected ? AppColors.surface : AppColors.black,
            )
          ],
        ),
      ),
    );
  }
}

Future<dynamic> openFilterBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FilterBottomSheet(),
  );
}
