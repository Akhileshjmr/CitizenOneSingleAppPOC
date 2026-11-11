import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/network/session_image_headers.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_network_image.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/policy_details_step_widget.dart';

class MotorInsuranceComparisonScreen extends StatefulWidget {
  const MotorInsuranceComparisonScreen({super.key});

  @override
  State<MotorInsuranceComparisonScreen> createState() =>
      _MotorInsuranceComparisonScreenState();
}

class _MotorInsuranceComparisonScreenState
    extends State<MotorInsuranceComparisonScreen> {
  String? _selectedIdv;
  static const _idvOptions = ['Select', 'Low', 'Medium', 'High'];
  @override
  void initState() {
    context.read<MotorInsuranceBloc>().add(const CompareQuotationEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadowCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle plate + Modify
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          '${state.vehicleData?.registrationNumber ?? ''} - ${state.vehicleData?.make ?? ''} ${state.vehicleData?.model ?? ''}',
                          style: AppTextStyle.bodyMedium,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     context
                      //         .read<MotorInsuranceBloc>()
                      //         .add(const CustomStepEvent(index: 0));
                      //   },
                      //   child: const AppText(
                      //     'Modify',
                      //     style: AppTextStyle.caption,
                      //     decoration: TextDecoration.underline,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Plan & IDV row
                  Row(
                    children: [
                      Expanded(
                        child: LabelledDropdown(
                          label: 'Plan',
                          value: state.selectedPlan?.value ??
                              state.planTypeList?.first.value,
                          items: state.planTypeList
                                  ?.map((e) => e.value ?? '')
                                  .toList() ??
                              [],
                          onChanged: (v) async {
                            if (v == null) return;

                            final selectedPlan = state.planTypeList!.firstWhere(
                              (plan) => plan.value == v,
                            );

                            context.read<MotorInsuranceBloc>().add(
                                MotorInsuranceSelectPlanEvent(selectedPlan));
                            context
                                .read<MotorInsuranceBloc>()
                                .add(const CompareQuotationEvent());
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Opacity(
                        opacity: 0.5,
                        child: IgnorePointer(
                          ignoring: true,
                          child: LabelledDropdown(
                            label: 'IDV',
                            value: _selectedIdv,
                            hint: 'Select',
                            items: _idvOptions,
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _selectedIdv = v);
                              }
                            },
                          ),
                        ),
                      )),
                    ],
                  ),

                  //

                  // const Divider(color: AppColors.border, height: 40),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: LabelledDropdown(
                  //         label: 'Plan',
                  //         value: 'Zero Depreciation',
                  //         items: const [
                  //           'Zero Depreciation',
                  //           'Roadside Assistance',
                  //           'Engine Protection',
                  //         ],
                  //         onChanged: (_) {},
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: ActionDropdown(
                  //         value: 'View all',
                  //         items: const ['View all', 'Add-ons'],
                  //         onChanged: (_) {},
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            if (state.quotationCompareStatus == QuotationCompareStatus.loading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              _buildSurfaceCard(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText('Insurance Quotes',
                        style: AppTextStyle.displaySmall),
                    const SizedBox(height: 10),
                    const AppText(
                        'Based on your details, here are insurance options for you',
                        style: AppTextStyle.bodyLarge),
                    const SizedBox(height: 22),
                    // const Row(
                    //   children: [
                    //     Icon(Icons.filter_list_sharp, size: 22),
                    //     SizedBox(width: 12),
                    //     AppText(
                    //       'Sort by',
                    //       style: AppTextStyle.bodyMedium,
                    //       color: AppColors.textSecondary,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 16),
                    // Wrap(
                    //   spacing: 14,
                    //   runSpacing: 12,
                    //   children: [
                    //     _buildSortChip(
                    //       label: 'Price : Low to High',
                    //       selected: _selectedSortIndex == 0,
                    //       onTap: () {
                    //         setState(() => _selectedSortIndex = 0);
                    //       },
                    //     ),
                    //     _buildSortChip(
                    //       label: 'Rating',
                    //       selected: _selectedSortIndex == 1,
                    //       onTap: () {
                    //         setState(() => _selectedSortIndex = 1);
                    //       },
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 18),
                    (state.quotationDataList != null &&
                            state.quotationDataList!.quotations.isEmpty)
                        ? Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const AppText(
                                'No data found',
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Column(children: [
                            ...List.generate(
                              state.quotationDataList != null
                                  ? state.quotationDataList!.quotations.length
                                  : 0,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: index ==
                                          state.quotationDataList!.quotations
                                                  .length -
                                              1
                                      ? 0
                                      : 18,
                                ),
                                child: _buildQuoteCard(
                                  option: state
                                      .quotationDataList!.quotations[index],
                                  isSelected: state.selectedInsuranceQuotation
                                          ?.product.id ==
                                      state.quotationDataList!.quotations[index]
                                          .product.id,
                                  coverageType: state.coverageType,
                                  onTap: () {
                                    context.read<MotorInsuranceBloc>().add(
                                        SelectInsuranceQuoteEvent(
                                            selectedInsuranceQuotation: state
                                                .quotationDataList!
                                                .quotations[index]));
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            _buildInfoBanner(),
                          ])
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSurfaceCard({
    required Widget child,
    required EdgeInsetsGeometry padding,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }

  // Widget _buildSortChip({
  //   required String label,
  //   required bool selected,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(999),
  //     child: AnimatedContainer(
  //       duration: const Duration(milliseconds: 180),
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
  //       decoration: BoxDecoration(
  //         color: selected ? AppColors.primary : AppColors.surface,
  //         borderRadius: BorderRadius.circular(999),
  //         border: Border.all(
  //           color: selected ? AppColors.primary : AppColors.primary,
  //           width: 1.4,
  //         ),
  //         boxShadow: selected
  //             ? [
  //                 BoxShadow(
  //                   color: AppColors.primary.withOpacity(0.16),
  //                   blurRadius: 10,
  //                   offset: const Offset(0, 5),
  //                 ),
  //               ]
  //             : const [],
  //       ),
  //       child: AppText(
  //         label,
  //         style: AppTextStyle.titleSmall,
  //         color: selected ? Colors.white : AppColors.textPrimary,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildQuoteCard({
    required Quotation option,
    required bool isSelected,
    required VoidCallback onTap,
    required String coverageType,
  }) {
    final borderColor = isSelected ? AppColors.primary : AppColors.border;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 3,
                spreadRadius: 1,
                offset: Offset(0, 2))
          ],
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: AppNetworkImage(
                option.insurer.logoUrl,
                headers: sessionImageHeaders(),
                width: 40,
                height: 40,
                errorWidget: SvgPicture.asset(
                  AppAssets.iconAccountBalance,
                  package: AppConfig.packageName,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF2793FF),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(option.insurer.shortName,
                      style: AppTextStyle.displaySmall,
                      fontSize: context.isMobile ? 12 : 22,
                      fontWeight:
                          context.isMobile ? FontWeight.w400 : FontWeight.w800,
                      color: AppColors.textPrimary),
                  const SizedBox(height: 4),
                  AppText(
                    coverageType,
                    style: AppTextStyle.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  '${option.currency} ${option.grossPremium.toStringAsFixed(2)}',
                  style: AppTextStyle.headlineMedium,
                  fontWeight:
                      context.isMobile ? FontWeight.w700 : FontWeight.w800,
                  fontSize: context.isMobile ? 14 : 24,
                ),
                /* AppText(
                  option.status.toString(),
                  style: AppTextStyle.caption,
                  fontWeight: FontWeight.w400,
                  color: AppColors.serviceHeaderTitle,
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF2F6EE8),
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Understanding Your Quotes',
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue700,
                ),
                SizedBox(height: 8),
                AppText(
                  'All quotes are based on the information you\'ve provided. Select a quote to proceed with your purchase.',
                  style: AppTextStyle.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blue700,
                  height: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // String _resolveVehicleTitle(MotorInsuranceState state) {
  //   final regNo = state.vehicleRegNo.trim().isNotEmpty
  //       ? state.vehicleRegNo.trim()
  //       : 'KA02ML3381';
  //   final make = state.vehicleMake.trim().isNotEmpty
  //       ? state.vehicleMake.trim()
  //       : 'Hyundai';
  //   final model = state.vehicleModel.trim().isNotEmpty
  //       ? state.vehicleModel.trim()
  //       : 'i20';
  //   return '$regNo- $make $model';
  // }

  // String _resolvePlanValue(String coverageType) {
  //   if (coverageType.toLowerCase().contains('comprehensive')) {
  //     return 'Comprehensive';
  //   }
  //   return 'Third-Party';
  // }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_lucide/flutter_lucide.dart';
// import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
// import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
// import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
// import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
// import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

// class AddonsStepWidget extends StatelessWidget {
//   const AddonsStepWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
//       builder: (context, state) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: Color(0x05000000),
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 'Optional Add-ons',
//                 style: AppTextStyle.headlineSmall,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//               const SizedBox(height: 8),
//               AppText(
//                 'Customize your policy with extra layers of protection',
//                 style: AppTextStyle.bodyMedium,
//                 color: AppColors.textSecondary,
//               ),
//               const SizedBox(height: 24),

//               _buildAddonCard(
//                 context: context,
//                 title: 'Zero Depreciation',
//                 description: 'Get full claim payouts without any reduction for vehicle parts depreciation.',
//                 price: '+\$45.00 / yr',
//                 icon: LucideIcons.shield_alert,
//                 isSelected: state.zeroDepSelected,
//                 onChanged: (val) {
//                   context.read<MotorInsuranceBloc>().add(
//                         UpdateAddonsEvent(
//                           zeroDepSelected: val,
//                           roadsideSelected: state.roadsideSelected,
//                           engineSelected: state.engineSelected,
//                         ),
//                       );
//                 },
//               ),
//               const SizedBox(height: 16),

//               _buildAddonCard(
//                 context: context,
//                 title: 'Roadside Assistance',
//                 description: '24/7 towing, emergency fuel, flat tire replacement, and minor repair support.',
//                 price: '+\$15.00 / yr',
//                 icon: LucideIcons.truck,
//                 isSelected: state.roadsideSelected,
//                 onChanged: (val) {
//                   context.read<MotorInsuranceBloc>().add(
//                         UpdateAddonsEvent(
//                           zeroDepSelected: state.zeroDepSelected,
//                           roadsideSelected: val,
//                           engineSelected: state.engineSelected,
//                         ),
//                       );
//                 },
//               ),
//               const SizedBox(height: 16),

//               _buildAddonCard(
//                 context: context,
//                 title: 'Engine Protection Cover',
//                 description: 'Covers damages to the engine resulting from water logging or oil leakage.',
//                 price: '+\$30.00 / yr',
//                 icon: LucideIcons.activity,
//                 isSelected: state.engineSelected,
//                 onChanged: (val) {
//                   context.read<MotorInsuranceBloc>().add(
//                         UpdateAddonsEvent(
//                           zeroDepSelected: state.zeroDepSelected,
//                           roadsideSelected: state.roadsideSelected,
//                           engineSelected: val,
//                         ),
//                       );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAddonCard({
//     required BuildContext context,
//     required String title,
//     required String description,
//     required String price,
//     required IconData icon,
//     required bool isSelected,
//     required ValueChanged<bool> onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
//           width: isSelected ? 1.5 : 1.0,
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               color: isSelected ? const Color(0xFF2563EB) : AppColors.textSecondary,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: AppText(
//                         title,
//                         style: AppTextStyle.bodyLarge,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     AppText(
//                       price,
//                       style: AppTextStyle.bodySmall,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF2563EB),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 AppText(
//                   description,
//                   style: AppTextStyle.caption,
//                   color: AppColors.textSecondary,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           Switch(
//             value: isSelected,
//             activeColor: const Color(0xFF2563EB),
//             onChanged: onChanged,
//           ),
//         ],
//       ),
//     );
//   }
// }
