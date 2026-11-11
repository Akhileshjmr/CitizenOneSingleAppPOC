import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/extensions/build_context_x.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

class ViewPolicyDetailsScreen extends StatelessWidget {
  const ViewPolicyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppStatusBar(
        title: 'View Details',
        showBack: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: AppButton(
          height: 40,
          label: 'Back',
          onPressed: () => context.pop(),
          variant: AppButtonVariant.primary,
          size: AppButtonSize.lg,
          backgroundColor: context.colors.primary,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
        child: Column(
          children: [
            _policyWidget(context),
          ],
        ),
      ),
    );
  }
}

Widget _policyWidget(BuildContext context) =>
    BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
        builder: (context, state) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                children: [
                  listData(
                    label: 'Client Name',
                    value: state
                            .issuePolicyByQuoteIdResponse?.data?.client?.name ??
                        'NA',
                  ),
                  listData(
                    label: 'Reference Number',
                    value: state.issuePolicyByQuoteIdResponse?.data
                            ?.transactionNumber ??
                        'NA',
                  ),
                  listData(
                    label: 'Policy Number',
                    value: state
                            .issuePolicyByQuoteIdResponse?.data?.policyNumber ??
                        'NA',
                  ),
                  listData(
                    label: 'Premium Amount',
                    value:
                        '${state.issuePolicyByQuoteIdResponse?.data?.currency} ${state.issuePolicyByQuoteIdResponse?.data?.totalPayable ?? 0}',
                  ),
                  listData(
                    label: 'Status',
                    value: state.issuePolicyByQuoteIdResponse?.data?.status ??
                        'NA',
                  ),
                  // listData(
                  //   label: 'Duration Type',
                  //   value: state
                  //           .issuePolicyByQuoteIdResponse?.data?.durationType ??
                  //       'NA',
                  // ),
                  // listData(
                  //     label: 'Quarters',
                  //     value:
                  //         state.issuePolicyByQuoteIdResponse?.data?.duration ??
                  //             'NA'),
                  // listData(
                  //     label: 'Months',
                  //     value: state.issuePolicyByQuoteIdResponse?.data
                  //             ?.durationMonth ??
                  //         'NA'),
                  // listData(
                  //   label: 'Coverage Period',
                  //   value: state.issuePolicyByQuoteIdResponse?.data
                  //           ?.coveragePeriod ??
                  //       'NA',
                  // ),
                  // listData(
                  //   label: 'Vehicle',
                  //   value: state.issuePolicyByQuoteIdResponse?.data?.vehicle ??
                  //       'NA',
                  // ),
                  listData(
                      label: 'Created At',
                      value: DateFormat('MMM dd yyyy, hh:mm a').format(
                          DateTime.parse(state.issuePolicyByQuoteIdResponse!
                                  .data!.createdAt ??
                              ''))),
                ],
              ),
            ),
          ],
        ),
      );
    });

Widget listData({
  required String label,
  required String value,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: AppText(
              label,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.serviceHeaderTitle,
            ),
          ),
          Expanded(
            flex: 5,
            child: AppText(
              value,
              style: AppTextStyle.bodyMedium,
              color: AppColors.black,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );

Widget buildOptionButton({
  required String iconPath,
  required String label,
  required VoidCallback onTap,
}) =>
    Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  package: AppConfig.packageName,
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.brandBlue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppText(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.labelSmall,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ],
      ),
    );
