import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/network/session_image_headers.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/assets.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/policy_key_facts_pdf_screen.dart';

class MotorInsurancePurchase extends StatelessWidget {
  const MotorInsurancePurchase({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Owns View Key Facts navigation exclusively. This listener is only
        // ever notified when keyFactsDocumentStatus itself changes, and only
        // ever inspects keyFactsDocumentStatus, so a stale/unrelated
        // sendSmsStatus can never be read here.
        BlocListener<MotorInsuranceBloc, MotorInsuranceState>(
          listenWhen: (previous, current) =>
              previous.keyFactsDocumentStatus != current.keyFactsDocumentStatus,
          listener: (context, state) {
            if (state.keyFactsDocumentStatus ==
                KeyFactsDocumentStatus.success) {
              context.push(
                AppRoutes.policyKeyFactsPdfPage,
                extra: PolicyKeyFactsPdfArgs(
                  url: state.keyFactsDocument?.url,
                  bytes: state.keyFactsDocument?.bytes,
                ),
              );
            } else if (state.keyFactsDocumentStatus ==
                KeyFactsDocumentStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to load Key Facts document'),
                ),
              );
            }
          },
        ),
        // Owns Send via SMS navigation exclusively. This listener is only
        // ever notified when sendSmsStatus itself changes, and only ever
        // inspects sendSmsStatus, so a stale/unrelated keyFactsDocumentStatus
        // can never be read here.
        BlocListener<MotorInsuranceBloc, MotorInsuranceState>(
          listenWhen: (previous, current) =>
              previous.sendSmsStatus != current.sendSmsStatus,
          listener: (context, state) {
            if (state.sendSmsStatus == SendSmsStatus.success) {
              final phone = (state.phNumber?.isNotEmpty == true)
                  ? state.phNumber!
                  : (state.mobileNumber?.isNotEmpty == true)
                      ? state.mobileNumber!
                      : '';
              context.push(
                AppRoutes.keyFactsSmsSuccessPage,
                extra: phone,
              );
            } else if (state.sendSmsStatus == SendSmsStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to send SMS. Please try again.'),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
        builder: (context, state) {
          return Column(
            children: [
              AdaptiveLayout.isDesktop(context)
                  ? _purchaseCardWeb(context, state)
                  : _purchaseCard(context, state),
              const SizedBox(height: 16),
              _policyKeyFactsCard(context, state)
              // _personalAccidentCoverCard(context, state),
              // const SizedBox(height: 16),
              // _priceBreakdownCard(state),
              // const SizedBox(height: 16),
              // _totalPremiumCard(state),
              // const SizedBox(height: 16),
              // _addOnsCard(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _policyKeyFactsCard(BuildContext context, MotorInsuranceState state) {
    const cardBorderColor = AppColors.primary;
    const cardBgColor = AppColors.primayBgLight;
    const iconBgColor = AppColors.kFDAD2FD;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cardBorderColor,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SvgPicture.asset(
                    AppAssets.iconDoc,
                    package: AppConfig.packageName,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.scaleDown,
                    width: 13,
                    height: 16,
                  )),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Policy key Facts Statements',
                      style: AppTextStyle.displaySmall,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: 6),
                    AppText(
                      'Review the key facts of your insurance policy.',
                      style: AppTextStyle.bodySmall,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: state.keyFactsDocumentStatus ==
                        KeyFactsDocumentStatus.loading
                    ? null
                    : () {
                        final productId =
                            state.selectedInsuranceQuotation?.product.id ?? '';
                        context.read<MotorInsuranceBloc>().add(
                              FetchKeyFactsDocumentEvent(productId: productId),
                            );
                      },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: state.keyFactsDocumentStatus ==
                          KeyFactsDocumentStatus.loading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cardBorderColor,
                          ),
                        )
                      : const AppText('View Key Facts',
                          style: AppTextStyle.labelSmall,
                          fontSize: 14,
                          color: cardBorderColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(width: 50),
              InkWell(
                onTap: state.sendSmsStatus == SendSmsStatus.loading
                    ? null
                    : () {
                        final phone = (state.phNumber?.isNotEmpty == true)
                            ? state.phNumber!
                            : (state.mobileNumber?.isNotEmpty == true)
                                ? state.mobileNumber!
                                : '';
                        context.read<MotorInsuranceBloc>().add(
                            SendSMSForPolicyKeyFactsEvent(
                                productId: state.selectedInsuranceQuotation
                                        ?.product.id ??
                                    '',
                                customerMobileNumber: phone));
                      },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: cardBorderColor,
                      width: 1.2,
                    ),
                  ),
                  child: state.sendSmsStatus == SendSmsStatus.loading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cardBorderColor,
                          ),
                        )
                      : const AppText(
                          'Send via SMS',
                          style: AppTextStyle.labelSmall,
                          fontSize: 14,
                          color: cardBorderColor,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _purchaseCard(BuildContext context, MotorInsuranceState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Complete Your Purchase',
              style: AppTextStyle.displaySmall),
          const SizedBox(height: 19),
          const AppText('Selected Plan', style: AppTextStyle.bodyLarge),
          const SizedBox(height: 19),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: AppNetworkImage(
                  state.selectedInsuranceQuotation?.insurer.logoUrl,
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                        state.selectedInsuranceQuotation?.insurer.shortName ??
                            '',
                        style: AppTextStyle.displaySmall,
                        fontSize: context.isMobile ? 14 : 22,
                        fontWeight: context.isMobile
                            ? FontWeight.w700
                            : FontWeight.w800,
                        color: AppColors.textPrimary),
                    const SizedBox(height: 4),
                    AppText(
                      state.coverageType,
                      style: AppTextStyle.bodySmall,
                    ),
                    /*const AppText(
                      'View Benefits',
                      style: AppTextStyle.labelSmall,
                      color: AppColors.surfaceLight,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),*/
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    '${state.selectedInsuranceQuotation?.currency} ${state.selectedInsuranceQuotation?.grossPremium.toStringAsFixed(2)}',
                    style: AppTextStyle.headlineMedium,
                    fontWeight:
                        context.isMobile ? FontWeight.w700 : FontWeight.w800,
                    fontSize: context.isMobile ? 14 : 24,
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      _showPremiumDetailsBottomSheet(context, state);
                    },
                    child: const AppText(
                      'Premium Details',
                      style: AppTextStyle.labelSmall,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Quote Summary',
                  style: AppTextStyle.headlineSmall,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 16),
                _buildQuoteSummaryRows(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _purchaseCardWeb(BuildContext context, MotorInsuranceState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Complete Your Purchase',
              style: AppTextStyle.displaySmall),
          const SizedBox(height: 19),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                border: Border.all(color: AppColors.primary)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: AppNetworkImage(
                    state.selectedInsuranceQuotation?.insurer.logoUrl,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                                state.selectedInsuranceQuotation?.insurer
                                        .shortName ??
                                    '',
                                style: AppTextStyle.displaySmall,
                                fontSize: context.isMobile ? 14 : 22,
                                fontWeight: context.isMobile
                                    ? FontWeight.w700
                                    : FontWeight.w800,
                                color: AppColors.textPrimary),
                            AppText(
                              '${state.selectedInsuranceQuotation?.currency} ${state.selectedInsuranceQuotation?.grossPremium.toStringAsFixed(2)}',
                              style: AppTextStyle.headlineMedium,
                              fontWeight: context.isMobile
                                  ? FontWeight.w700
                                  : FontWeight.w800,
                              fontSize: context.isMobile ? 14 : 24,
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AppText(
                                state.coverageType,
                                style: AppTextStyle.bodySmall,
                              ),
                              const SizedBox(width: 12),
                              const AppText(
                                'View Benefits',
                                style: AppTextStyle.labelSmall,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              _showPremiumDetailsBottomSheet(context, state);
                            },
                            child: const AppText(
                              'Premium Details',
                              style: AppTextStyle.labelSmall,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.doc,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const AppText(
                      'Quote Summary',
                      style: AppTextStyle.headlineSmall,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildQuoteSummaryRows(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteSummaryRows(
      BuildContext context, MotorInsuranceState state) {
    final summaryRows = <Widget>[
      _SummaryRow(
        label: 'Start Date',
        value:
            _fmtDate(DateTime.parse(state.createQuotationResponse!.startDate)),
      ),
      _SummaryRow(
        label: 'End Date',
        value: _fmtDate(DateTime.parse(state.createQuotationResponse!.endDate)),
      ),
      // _SummaryRow(
      //   label: 'Ref.No',
      //   value: state.createQuotationResponse?.referenceNumber ?? 'NA',
      // ),
      // _SummaryRow(
      //   label: 'Host Ref.No',
      //   value: state.createQuotationResponse?.hostRefNumber ?? 'NA',
      // ),
      _SummaryRow(
        label: 'Coverage',
        value: state.coverageType,
      ),
      _SummaryRow(
        label: 'Vehicle',
        value: '${state.vehicleData?.make} ${state.vehicleData?.model}'.trim(),
      ),
      _SummaryRow(
        label: 'Registration',
        value: state.vehicleRegNo,
      ),
      _SummaryRow(
        label: 'Color',
        value: state.vehicleData?.color ?? '-',
      ),
      _SummaryRow(
        label: 'Body Style',
        value: state.vehicleBodyStyle,
      ),
    ];

    if (!AdaptiveLayout.isDesktop(context)) {
      return Column(children: summaryRows);
    }

    final pairedRows = <Widget>[];
    for (var i = 0; i < summaryRows.length; i += 2) {
      final hasSecond = i + 1 < summaryRows.length;
      pairedRows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: summaryRows[i]),
            const SizedBox(width: 16),
            Expanded(
              child: hasSecond ? summaryRows[i + 1] : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }
    return Column(children: pairedRows);
  }

  // Widget _priceBreakdownCard(MotorInsuranceState state) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: _cardDecoration(),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const AppText(
  //           'Price Breakdown',
  //           style: AppTextStyle.headlineSmall,
  //           fontWeight: FontWeight.w500,
  //         ),
  //         const VSpace(16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const AppText('Gross Premium', style: AppTextStyle.bodyMedium),
  //             AppText(
  //                 'ZMW ${state.selectedInsuranceQuotation?.grossPremium.toStringAsFixed(2)}',
  //                 style: AppTextStyle.headlineSmall),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const AppText('Transaction Fee', style: AppTextStyle.bodyMedium),
  //             AppText(
  //                 'ZMW ${((state.createQuotationResponse?.gatewayCharge ?? 0) + (state.createQuotationResponse?.platformCharge ?? 0)).toStringAsFixed(2)}',
  //                 style: AppTextStyle.headlineSmall),
  //           ],
  //         ),
  //         const SizedBox(height: 16),
  //         const Divider(
  //           color: Color(0xffE6E6E6),
  //           thickness: 1,
  //           height: 1,
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             const AppText('Total Amount',
  //                 style: AppTextStyle.bodyMedium, color: AppColors.black),
  //             AppText(
  //                 'ZMW ${state.createQuotationResponse?.totalPayable.toStringAsFixed(2)}',
  //                 style: AppTextStyle.headlineSmall),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _totalPremiumCard(MotorInsuranceState state) {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: _cardDecoration(),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const AppText(
  //           'Total Payable Amount',
  //           style: AppTextStyle.bodyLarge,
  //           fontWeight: FontWeight.w600,
  //         ),
  //         AppText(
  //             'ZMW ${state.createQuotationResponse?.totalPayable.toStringAsFixed(2)}',
  //             style: AppTextStyle.displaySmall),
  //       ],
  //     ),
  //   );
  // }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xffE6E6E6),
      ),
    );
  }

  void _showPremiumDetailsBottomSheet(
    BuildContext context,
    MotorInsuranceState state,
  ) {
    final currency = state.selectedInsuranceQuotation?.currency ??
        state.createQuotationResponse?.currency ??
        'ZMW';

    final basicPremium = state.selectedInsuranceQuotation?.basicPremium ??
        state.createQuotationResponse?.basePremium ??
        0.0;

    final tax = state.selectedInsuranceQuotation?.premiumLevy ??
        state.createQuotationResponse?.levies ??
        0.0;

    final totalPremium = state.selectedInsuranceQuotation?.grossPremium ??
        state.createQuotationResponse?.totalPremium ??
        (basicPremium + tax);

    final formatter = NumberFormat('#,##0.00', 'en_US');

    Widget premiumDetails() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xffE6E6E6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Premium Details',
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Color(0xffE6E6E6),
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Basic Premium',
                  style: AppTextStyle.bodyMedium,
                  color: AppColors.textPrimary,
                ),
                AppText(
                  '$currency ${formatter.format(basicPremium)}',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Tax',
                  style: AppTextStyle.bodyMedium,
                  color: AppColors.textPrimary,
                ),
                AppText(
                  '$currency ${formatter.format(tax)}',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Color(0xffE6E6E6),
              height: 1,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Total Premium',
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                AppText(
                  '$currency ${formatter.format(totalPremium)}',
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget closeButton(BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 1.2,
            ),
          ),
          child: const Icon(
            Icons.close_rounded,
            size: 16,
            color: Colors.black,
          ),
        ),
      );
    }

    if (AdaptiveLayout.isDesktop(context)) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    premiumDetails(),
                    const SizedBox(height: 20),
                    AppButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      backgroundColor: AppColors.surface,
                      borderColor: AppColors.primary,
                      textColor: AppColors.primary,
                      text: 'Close',
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                closeButton(sheetContext),
                const SizedBox(height: 16),
                premiumDetails(),
              ],
            ),
          );
        },
      );
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(children: [
          AppText('$label :',
              style: AppTextStyle.bodyLarge,
              color: AppColors.serviceHeaderTitle),
          Flexible(
            child: AppText(' $value',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bodyLarge,
                fontWeight: FontWeight.w500),
          )
        ]));
  }
}

// Widget _personalAccidentCoverCard(
//   BuildContext context,
//   MotorInsuranceState state,
// ) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//     decoration: _cardDecoration(),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const AppText(
//           'Compulsory Personal Accident Cover',
//           style: AppTextStyle.caption,
//           fontSize: 16,
//         ),
//         const SizedBox(height: 8),
//         const AppText(
//             '15L Cover mandated by law. Skip if already covered or no valid license',
//             style: AppTextStyle.titleSmall,
//             fontWeight: FontWeight.w400,
//             color: AppColors.serviceHeaderTitle),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             const Icon(Icons.person_outline, size: 32),
//             const SizedBox(width: 16),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     '1 Year Cover',
//                     style: AppTextStyle.titleSmallBold,
//                     color: AppColors.textPrimary,
//                   ),
//                   SizedBox(height: 6),
//                   AppText(
//                     'Provided by GoDigit General Insurance',
//                     style: AppTextStyle.labelSmall,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.labelGrey,
//                   ),
//                 ],
//               ),
//             ),
//             const AppText('ZMW 800', style: AppTextStyle.headlineSmall),
//             Checkbox(
//               value: state.personalAccidentSelected,
//               onChanged: (value) {
//                 context.read<MotorInsuranceBloc>().add(
//                       ToggleAddonEvent(
//                         addonKey: 'personalAccident',
//                         value: value ?? false,
//                       ),
//                     );
//               },
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _addOnsCard(
//   BuildContext context,
//   MotorInsuranceState state,
// ) {
//   return Container(
//     padding: const EdgeInsets.all(20),
//     decoration: _cardDecoration(),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const AppText(
//           'Additional Add - ons',
//           style: AppTextStyle.headlineSmall,
//           fontWeight: FontWeight.w500,
//         ),
//         const SizedBox(height: 24),
//         _AddonTile(
//           icon: AppAssets.iconRoad,
//           title: 'Road Side Assistance',
//           amount: 'ZMW 500',
//           selected: state.roadsideSelected,
//           description:
//               'Get help immediately when your car has broken down or has been in an accident.',
//           onChanged: (value) {
//             context.read<MotorInsuranceBloc>().add(
//                   ToggleAddonEvent(
//                     addonKey: 'roadside',
//                     value: value,
//                   ),
//                 );
//           },
//         ),
//         const Divider(height: 32, color: AppColors.border),
//         _AddonTile(
//           icon: AppAssets.iconEngine,
//           title: 'Engine Protection',
//           amount: 'ZMW 500',
//           selected: state.engineSelected,
//           description:
//               'Repairing a damaged engine can be expensive. Extend coverage.',
//           onChanged: (value) {
//             context.read<MotorInsuranceBloc>().add(
//                   ToggleAddonEvent(
//                     addonKey: 'engine',
//                     value: value,
//                   ),
//                 );
//           },
//         ),
//       ],
//     ),
//   );
// }

// class _AddonTile extends StatelessWidget {
//   final String title;
//   final String icon;
//   final String description;
//   final String amount;
//   final bool selected;
//   final ValueChanged<bool> onChanged;

//   const _AddonTile({
//     required this.title,
//     required this.icon,
//     required this.description,
//     required this.amount,
//     required this.selected,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SvgPicture.asset(package: AppConfig.packageName, icon),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 title,
//                 style: AppTextStyle.titleSmallBold,
//                 color: AppColors.textPrimary,
//               ),
//               const SizedBox(height: 8),
//               AppText(description,
//                   style: AppTextStyle.bodyMedium,
//                   fontSize: 11,
//                   color: AppColors.labelGrey)
//             ],
//           ),
//         ),
//         const SizedBox(width: 16),
//         AppText(
//           amount,
//           style: AppTextStyle.headlineSmall,
//         ),
//         Checkbox(
//           value: selected,
//           side: const BorderSide(color: AppColors.textSecondary),
//           checkColor: AppColors.glassWhite,
//           activeColor: AppColors.primary,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//           onChanged: (value) {
//             onChanged(value ?? false);
//           },
//         ),
//       ],
//     );
//   }
// }
