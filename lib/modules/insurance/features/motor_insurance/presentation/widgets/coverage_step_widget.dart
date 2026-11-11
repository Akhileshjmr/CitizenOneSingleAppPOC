import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';

class CoverageStepWidget extends StatefulWidget {
  const CoverageStepWidget({super.key});

  @override
  State<CoverageStepWidget> createState() => _CoverageStepWidgetState();
}

class _CoverageStepWidgetState extends State<CoverageStepWidget> {
  @override
  void initState() {
    super.initState();
    context
        .read<MotorInsuranceBloc>()
        .add(const GetMotorInsuranceMasterDataEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        final policyFor = state.masterData?.policyFor ?? [];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText('Who is this policy for?',
                  style: AppTextStyle.displaySmall),
              const VSpace(10),
              const AppText(
                'Tell us who will be the policy holder (or) \nSomeone else',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              const VSpace(19),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: policyFor.length,
                itemBuilder: (context, index) {
                  final item = policyFor[index];
                  return _buildSelectionCard(
                    context: context,
                    title: item.label,
                    subtitle: item.code == 'FOR_MYSELF'
                        ? 'I am insuring my own vehicle'
                        : 'Insuring a vehicle for another person',
                    isSelected: state.selectedPolicyFor == item.code,
                    onTap: () {
                      context.read<MotorInsuranceBloc>().add(
                            UpdatePolicyForEvent(code: item.code,label: item.label),
                          );
                    },
                  );
                },
                separatorBuilder: (context, index) => const VSpace(19),
              ),
              const VSpace(24),
              _buildInfoBox(context)
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandLavender : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.blue700 : AppColors.border,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.labelGrey,
                  width: 2,
                ),
              ),
              child: Center(
                child: isSelected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
            ),
            const HSpace(26),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyle.bodyLarge,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  AppText(
                    subtitle,
                    style: AppTextStyle.bodySmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.serviceHeaderTitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      key: const ValueKey('info_box'),
      decoration: BoxDecoration(
        color: AppColors.brandLavender,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.info,
            color: AppColors.blue700,
            size: 20,
          ),
          HSpace(16),
          Expanded(
            child: AppText(
              'Your account details will be used for the policy.\nPlease confirm your name.',
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.blue700,
            ),
          ),
        ],
      ),
    );
  }
}
