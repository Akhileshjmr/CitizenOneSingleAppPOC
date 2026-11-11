import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_breakdown_card.dart';

class MotorInsurancePaymentBottomSheet extends StatefulWidget {
  const MotorInsurancePaymentBottomSheet({super.key});

  @override
  State<MotorInsurancePaymentBottomSheet> createState() =>
      _MotorInsurancePaymentBottomSheetState();
}

class _MotorInsurancePaymentBottomSheetState
    extends State<MotorInsurancePaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            top: 96,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const Divider(
                    color: Color(0xffE6E6E6),
                    thickness: 1,
                    height: 1,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPaymentMethodTabs(context, state),
                            const SizedBox(height: 24),
                            if (state.selectedPaymentMethod == 'Mobile Money')
                              _buildMobileMoneyView(context, state)
                            else
                              _buildCardPaymentView(context, state),
                            const SizedBox(height: 24),
                            const PaymentBreakdownCard(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildStickyBottomButton(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText(
            'Payment',
            style: AppTextStyle.bodyLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              iconSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTabs(
      BuildContext context, MotorInsuranceState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _SegmentTab(
            title: 'Mobile Money',
            isSelected: state.selectedPaymentMethod == 'Mobile Money',
            onTap: () {
              context.read<MotorInsuranceBloc>().add(
                    const PaymentMethodChanged(
                        selectedPaymentMethod: 'Mobile Money'),
                  );
            },
          ),
          const SizedBox(width: 16),
          _SegmentTab(
            disable: true,
            title: 'Card Payment',
            isSelected: state.selectedPaymentMethod == 'Card Payment',
            onTap: () {
              context.read<MotorInsuranceBloc>().add(
                    const PaymentMethodChanged(
                        selectedPaymentMethod: 'Card Payment'),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMoneyView(
      BuildContext context, MotorInsuranceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Mobile Money Services',
          style: AppTextStyle.bodyMedium,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MobileProviderCard(
                providerName: 'Airtel',
                imagePath: AppAssets.airtelLogo,
                borderColor: AppColors.kED1D24,
                backgroundColor: AppColors.kFFFCFC,
                isSelected: state.selectedMobileProvider == 'Airtel',
                onTap: () {
                  context.read<MotorInsuranceBloc>().add(
                        const MobileProviderChanged(
                          selectedMobileProvider: 'Airtel',
                        ),
                      );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MobileProviderCard(
                providerName: 'MTN',
                imagePath: AppAssets.mtnLogo,
                borderColor: AppColors.kF2C300,
                backgroundColor: AppColors.kFEFCE8,
                isSelected: state.selectedMobileProvider == 'MTN',
                onTap: () {
                  context.read<MotorInsuranceBloc>().add(
                        const MobileProviderChanged(
                          selectedMobileProvider: 'MTN',
                        ),
                      );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MobileProviderCard(
                providerName: 'Zamtel',
                imagePath: AppAssets.zamtelLogo,
                borderColor: AppColors.k25B74D,
                backgroundColor: AppColors.kFBFFFC,
                isSelected: state.selectedMobileProvider == 'Zamtel',
                onTap: () {
                  context.read<MotorInsuranceBloc>().add(
                        const MobileProviderChanged(
                          selectedMobileProvider: 'Zamtel',
                        ),
                      );
                },
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
                onChanged: (value) {
                  context.read<MotorInsuranceBloc>().add(
                        PhoneNumberChanged(phoneNumber: value),
                      );
                },
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (text.length < 9) {
                    return 'Enter a valid 9-digit phone number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _requiredFieldLabel(String label) {
    return Row(
      children: [
        AppText(label, style: AppTextStyle.bodySmall),
        const AppText(' *',
            style: AppTextStyle.bodySmall, color: AppColors.error),
      ],
    );
  }

  Widget _buildCardPaymentView(
      BuildContext context, MotorInsuranceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Card Details',
          style: AppTextStyle.bodyLarge,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        _requiredFieldLabel('Card Holder Name'),
        const SizedBox(height: 8),
        AppTextField(
          hintText: 'Enter name as on card',
          maxLength: 50,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            LengthLimitingTextInputFormatter(50),
          ],
          onChanged: (value) {
            context.read<MotorInsuranceBloc>().add(
                  CardHolderChanged(cardHolder: value),
                );
          },
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              return 'Please enter card holder name';
            }
            if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$').hasMatch(text)) {
              return 'Only letters and spaces are allowed';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _requiredFieldLabel('Card Number'),
        const SizedBox(height: 8),
        AppTextField(
          hintText: '0000 0000 0000 0000',
          keyboardType: TextInputType.number,
          maxLength: 16,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
          ],
          onChanged: (value) {
            context.read<MotorInsuranceBloc>().add(
                  CardNumberChanged(cardNumber: value),
                );
          },
          validator: (value) {
            final text = value ?? '';
            if (text.isEmpty) {
              return 'Please enter card number';
            }
            if (!RegExp(r'^\d{16}$').hasMatch(text)) {
              return 'Enter a valid 16-digit card number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredFieldLabel('Expiry Date'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: 'MM/YY',
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      ExpiryDateFormatter(),
                    ],
                    onChanged: (value) {
                      context.read<MotorInsuranceBloc>().add(
                            CardExpiryChanged(expiry: value),
                          );
                    },
                    validator: (value) {
                      final text = value ?? '';
                      if (text.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(text)) {
                        return 'Use MM/YY';
                      }
                      final month = int.parse(text.substring(0, 2));
                      if (month < 1 || month > 12) {
                        return 'Enter a valid month';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requiredFieldLabel('CVV'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: '123',
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: (value) {
                      context.read<MotorInsuranceBloc>().add(
                            CardCVVChanged(cvv: value),
                          );
                    },
                    validator: (value) {
                      final text = value ?? '';
                      if (text.isEmpty) {
                        return 'Please enter CVV';
                      }
                      if (!RegExp(r'^\d{3}$').hasMatch(text)) {
                        return 'Enter a valid CVV';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStickyBottomButton(
      BuildContext context, MotorInsuranceState state) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.only(
        bottom: 24,
        right: 16,
        left: 16,
        top: 16,
      ),
      child: AppButton(
        text: 'Process',
        isLoading: state.isProcessing,
        onPressed: state.isProcessing
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  context.read<MotorInsuranceBloc>().add(
                        ProcessInsurancePayment(),
                      );
                  Navigator.of(context).pop();
                  context.push(AppRoutes.transactionProcessingPage);
                }
              },
      ),
    );
  }
}

class _SegmentTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool? disable;

  const _SegmentTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.disable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppButton(
        disable: disable,
        text: title,
        onPressed: onTap,
        height: 42,
        radius: 10,
        variant:
            isSelected ? AppButtonVariant.primary : AppButtonVariant.outline,
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        textColor: isSelected ? Colors.white : AppColors.textPrimary,
        borderColor: isSelected ? AppColors.primary : AppColors.borderGray,
      ),
    );
  }
}

class _MobileProviderCard extends StatelessWidget {
  final String providerName;
  final String imagePath;
  final Color borderColor;
  final Color backgroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileProviderCard({
    required this.providerName,
    required this.imagePath,
    required this.borderColor,
    required this.backgroundColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSelected ? borderColor : borderColor.withValues(alpha: 0.35),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(imagePath,
                  // fit: BoxFit.contain,
                  height: 34,
                  package: AppConfig.packageName),
            ),
            const SizedBox(height: 12),
            AppText(
              providerName,
              style: AppTextStyle.bodyMedium,
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

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    if (text.isNotEmpty) {
      if (text.length == 1) {
        final first = int.parse(text);
        if (first > 1) {
          return oldValue;
        }
      }

      if (text.length >= 2) {
        final month = int.parse(text.substring(0, 2));
        if (month < 1 || month > 12) {
          return oldValue;
        }
      }
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
