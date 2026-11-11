// =============================================================================
// DesktopPaymentPanel — desktop-only "Choose Payment Method" right-rail card
// shown on the Insurance Details & Purchase step (step 6 of 7).
// -----------------------------------------------------------------------------
// Mirrors the same MotorInsuranceBloc state/events already used by the mobile
// payment bottom sheet (motor_insurance_payment_bottom_sheet.dart) — that
// file is left completely untouched. This is a new, desktop-specific
// presentation of the same payment flow, rendered inline instead of in a
// modal bottom sheet, matching the desktop SVG reference.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_breakdown_card.dart';

import '../../../../core/config/app_config.dart';

class DesktopPaymentPanel extends StatefulWidget {
  const DesktopPaymentPanel({super.key});

  @override
  State<DesktopPaymentPanel> createState() => _DesktopPaymentPanelState();
}

class _DesktopPaymentPanelState extends State<DesktopPaymentPanel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Choose Payment Method',
                  style: AppTextStyle.headlineSmall,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 20),
                _buildPaymentMethodTabs(context, state),
                const SizedBox(height: 20),
                if (state.selectedPaymentMethod == 'Mobile Money')
                  _buildMobileMoneyView(context, state),
                const SizedBox(height: 20),
                const PaymentBreakdownCard(),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Process Payment',
                  onPressed: state.isProcessing
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context
                                .read<MotorInsuranceBloc>()
                                .add(ProcessInsurancePayment());
                            context.push(AppRoutes.transactionProcessingPage);
                          }
                        },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodTabs(
      BuildContext context, MotorInsuranceState state) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: 'Mobile Money',
            onPressed: () => context.read<MotorInsuranceBloc>().add(
                const PaymentMethodChanged(
                    selectedPaymentMethod: 'Mobile Money')),
            height: 42,
            radius: 10,
            variant: state.selectedPaymentMethod == 'Mobile Money'
                ? AppButtonVariant.primary
                : AppButtonVariant.outline,
            backgroundColor: state.selectedPaymentMethod == 'Mobile Money'
                ? AppColors.primary
                : Colors.white,
            textColor: state.selectedPaymentMethod == 'Mobile Money'
                ? Colors.white
                : AppColors.textPrimary,
            borderColor: AppColors.borderGray,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: AppButton(
            text: 'Card Payment',
            onPressed: null,
            height: 42,
            radius: 10,
            variant: AppButtonVariant.outline,
            backgroundColor: Colors.white,
            textColor: AppColors.textPrimary,
            borderColor: AppColors.borderGray,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileMoneyView(
      BuildContext context, MotorInsuranceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Mobile Operators',
          style: AppTextStyle.bodyMedium,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ProviderCard(
                providerName: 'Airtel',
                imagePath: AppAssets.airtelLogo,
                borderColor: AppColors.kED1D24,
                isSelected: state.selectedMobileProvider == 'Airtel',
                onTap: () => context.read<MotorInsuranceBloc>().add(
                    const MobileProviderChanged(
                        selectedMobileProvider: 'Airtel')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ProviderCard(
                providerName: 'MTN',
                imagePath: AppAssets.mtnLogo,
                borderColor: AppColors.kF2C300,
                isSelected: state.selectedMobileProvider == 'MTN',
                onTap: () => context.read<MotorInsuranceBloc>().add(
                    const MobileProviderChanged(selectedMobileProvider: 'MTN')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ProviderCard(
                providerName: 'Zamtel',
                imagePath: AppAssets.zamtelLogo,
                borderColor: AppColors.k25B74D,
                isSelected: state.selectedMobileProvider == 'Zamtel',
                onTap: () => context.read<MotorInsuranceBloc>().add(
                    const MobileProviderChanged(
                        selectedMobileProvider: 'Zamtel')),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            AppText(
              'Phone Number',
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            AppText(
              ' *',
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textBorder),
              ),
              alignment: Alignment.center,
              child: const AppText(
                '+260',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                maxLength: 9,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                onChanged: (value) => context
                    .read<MotorInsuranceBloc>()
                    .add(PhoneNumberChanged(phoneNumber: value)),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return 'Please enter phone number';
                  if (text.length < 9) return 'Enter a valid 9-digit number';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.providerName,
    required this.imagePath,
    required this.borderColor,
    required this.isSelected,
    required this.onTap,
  });

  final String providerName;
  final String imagePath;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isSelected ? borderColor : borderColor.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Image.asset(
              imagePath,
              height: 24,
              package: AppConfig.packageName,
            )),
            const SizedBox(height: 8),
            AppText(
              providerName,
              style: AppTextStyle.caption,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
