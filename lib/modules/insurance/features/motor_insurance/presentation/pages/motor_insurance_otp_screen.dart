// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/utils/snack.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
// Payment screen removed and replaced by Bottom Sheet

class MotorInsuranceOtpScreen extends StatefulWidget {
  const MotorInsuranceOtpScreen({super.key});

  @override
  State<MotorInsuranceOtpScreen> createState() =>
      MotorInsuranceOtpScreenState();
}

class MotorInsuranceOtpScreenState extends State<MotorInsuranceOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _requestOtp();
    });
  }

  void _onOtpChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _otpController
      ..removeListener(_onOtpChanged)
      ..dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: bottomButton(context),
      appBar: const AppStatusBar(
          showBack: true,
          bgColor: AppColors.surface,
          centerTitle: false,
          title: 'One Time Verification'),
      body: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
        listenWhen: (previous, current) =>
            previous.otpStatus != current.otpStatus ||
            previous.otpMessage != current.otpMessage ||
            previous.otp != current.otp,
        listener: _handleOtpState,
        builder: (context, state) {
          final isBusy = state.otpStatus == MotorOtpStatus.generating ||
              state.otpStatus == MotorOtpStatus.verifying;
          final isLocked =
              state.isOtpLocked || state.otpStatus == MotorOtpStatus.locked;
          final isAlreadyVerified =
              state.otpStatus == MotorOtpStatus.alreadyVerified;
          final shouldShowOtpInput = !isAlreadyVerified;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const VSpace(20),
                if (isAlreadyVerified) ...[
                  const Icon(Icons.check_circle,
                      color: AppColors.success, size: 80),
                  const VSpace(24),
                  AppText(
                    state.otpMessage ?? 'Verification Successful',
                    style: AppTextStyle.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                    textAlign: TextAlign.center,
                  ),
                  const VSpace(12),
                  const AppText(
                    'Your identity has been successfully verified. Please click continue to proceed with your insurance policy.',
                    style: AppTextStyle.bodyMedium,
                    color: AppColors.serviceHeaderTitle,
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  const AppText(
                    'One Time Verification',
                    style: AppTextStyle.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  const VSpace(8),
                  const AppText(
                    'To help validate process, please enter the OTP sent to your registered mobile number.',
                    style: AppTextStyle.bodySmall,
                    color: AppColors.serviceHeaderTitle,
                    textAlign: TextAlign.center,
                  ),
                  const VSpace(20),
                  if (shouldShowOtpInput) ...[
                    AppButton(
                      text: state.otpStatus == MotorOtpStatus.expired ||
                              state.otpStatus == MotorOtpStatus.generated
                          ? 'Resend OTP'
                          : 'Get OTP',
                      isLoading: state.otpStatus == MotorOtpStatus.generating,
                      onPressed: isBusy || isLocked ? null : _requestOtp,
                      backgroundColor: isBusy || isLocked
                          ? AppColors.textMuted
                          : AppColors.primary,
                      height: 40,
                      width: 150,
                      isFullWidth: false,
                    ),
                    const VSpace(16),
                    if (state.otp != null && state.otp!.isNotEmpty) ...[
                      _DevelopmentOtpBanner(otp: state.otp!),
                      const VSpace(16),
                    ],
                    if (state.otpRemainingSeconds > 0)
                      AppText(
                        'OTP expires in ${state.otpRemainingSeconds}s',
                        style: AppTextStyle.bodySmall,
                        color: AppColors.serviceHeaderTitle,
                      ),
                    if (state.otpAttemptRemaining != null) ...[
                      const VSpace(6),
                      AppText(
                        'Attempts remaining: ${state.otpAttemptRemaining}',
                        style: AppTextStyle.bodySmall,
                        color: AppColors.serviceHeaderTitle,
                      ),
                    ],
                    const VSpace(22),
                    Form(
                      key: _formKey,
                      child: Pinput(
                        controller: _otpController,
                        focusNode: _otpFocusNode,
                        enabled: !isBusy && !isLocked,
                        errorTextStyle: TextStyle(
                          color: AppColors.primary,
                          fontSize: isMobile ? 12 : 8,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'OTP is required';
                          }
                          if (value.length != 6) {
                            return 'Please enter a valid OTP';
                          }
                          return null;
                        },
                        length: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        defaultPinTheme: PinTheme(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.serviceHeaderTitle),
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
                const VSpace(20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bottomButton(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        if (state.otpStatus == MotorOtpStatus.alreadyVerified) {
          return Container(
            height: 100,
            color: AppColors.surface,
            padding: const EdgeInsets.only(
              bottom: 30,
              right: 20,
              left: 20,
              top: 30,
            ),
            child: AppButton(
              text: 'Continue',
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: AppColors.primary,
              height: 40,
              width: 150,
            ),
          );
        }
        final isBusy = state.otpStatus == MotorOtpStatus.generating ||
            state.otpStatus == MotorOtpStatus.verifying;
        final canVerify = _otpController.text.length == 6 &&
            state.otpStatus != MotorOtpStatus.expired &&
            state.otpStatus != MotorOtpStatus.locked &&
            !state.isOtpLocked &&
            !isBusy;

        return Container(
          height: 100,
          color: AppColors.surface,
          padding: const EdgeInsets.only(
            bottom: 30,
            right: 20,
            left: 20,
            top: 30,
          ),
          child: AppButton(
            text: 'Verify',
            isLoading: state.otpStatus == MotorOtpStatus.verifying,
            onPressed: canVerify ? _verifyOtp : null,
            backgroundColor:
                canVerify ? AppColors.primary : AppColors.textMuted,
            height: 40,
            width: 150,
          ),
        );
      },
    );
  }

  void _requestOtp() {
    final state = context.read<MotorInsuranceBloc>().state;
    final destination = _resolveOtpDestination(state);
    context.read<MotorInsuranceBloc>().add(
          GenerateMotorOtpEvent(destination: destination),
        );
  }

  void _verifyOtp() {
    if (_formKey.currentState?.validate() != true) {
      _otpFocusNode.requestFocus();
      return;
    }
    context.read<MotorInsuranceBloc>().add(
          VerifyMotorOtpEvent(otp: _otpController.text),
        );
  }

  void _handleOtpState(
    BuildContext context,
    MotorInsuranceState state,
  ) {
    if (state.otpStatus == MotorOtpStatus.generated) {
      _otpController.clear();
      _otpFocusNode.requestFocus();
      Snack.show(
        context,
        type: AppAlertType.success,
        message: state.otpMessage ?? 'OTP sent successfully.',
      );
      return;
    }

    if (state.otpStatus == MotorOtpStatus.verified) {
      _otpController.clear();
      Snack.show(
        context,
        type: AppAlertType.success,
        message: state.otpMessage ?? 'OTP verified successfully.',
      );
      Navigator.of(context).pop();
      return;
    }

    if (state.otpStatus == MotorOtpStatus.alreadyVerified) {
      _otpController.clear();
      // Don't auto-navigate, just let the UI update to show the Continue button
      return;
    }

    if (state.otpStatus == MotorOtpStatus.verificationFailed ||
        state.otpStatus == MotorOtpStatus.error ||
        state.otpStatus == MotorOtpStatus.expired ||
        state.otpStatus == MotorOtpStatus.locked) {
      Snack.show(
        context,
        type: AppAlertType.error,
        message: state.otpMessage ?? 'Something went wrong.',
      );
      _otpFocusNode.requestFocus();
    }
  }

  String _resolveOtpDestination(MotorInsuranceState state) {
    final candidates = [
      state.mobileNumber,
      state.phNumber,
      state.driverPhone,
      state.agentMobileNumber,
    ];
    for (final candidate in candidates) {
      final value = candidate?.trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return '';
  }
}

class _DevelopmentOtpBanner extends StatelessWidget {
  final String otp;

  const _DevelopmentOtpBanner({required this.otp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const AppText(
            'Development OTP (Testing Only)',
            style: AppTextStyle.bodySmall,
            fontWeight: FontWeight.w600,
            color: AppColors.serviceHeaderTitle,
          ),
          const VSpace(8),
          AppText(
            otp,
            style: AppTextStyle.headlineMedium,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
