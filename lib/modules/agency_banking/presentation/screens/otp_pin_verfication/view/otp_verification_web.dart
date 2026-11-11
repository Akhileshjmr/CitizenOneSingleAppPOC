import 'package:citizenone_app/modules/agency_banking/presentation/screens/otp_pin_verfication/view/widgets/otp_input_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/form/app_button.dart';
import '../../../../theme/app_theme_style.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../bloc/otp_verification_bloc.dart';
import '../bloc/otp_verification_event.dart';
import '../bloc/otp_verification_state.dart';

/// Web / desktop / tablet layout for the One Time Verification screen.
/// Same responsive approach as the loan search web layout: a branding
/// panel appears once there's enough width (>=1100px), otherwise the
/// form is just centered with a comfortable max width.
class OtpVerificationWebLayout extends StatelessWidget {
  final OtpVerificationBloc controller;
  final VoidCallback onBack;
  final Future<Map<String, dynamic>> Function(String otp) onVerify;
  final Future<void> Function() onResend;
  final String title;
  final String subtitle;
  final bool showResendOption;

  const OtpVerificationWebLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onVerify,
    required this.onResend,
    this.title = 'One Time Verification',
    this.subtitle =
        'To help validate process, please enter the OTP by pressing on the below button.',
    this.showResendOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _WebHeader(onBack: onBack),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool showBrandingPanel = constraints.maxWidth >= 1100;
                final double formMaxWidth = constraints.maxWidth >= 1100
                    ? 420
                    : constraints.maxWidth >= 700
                        ? 460
                        : double.infinity;

                final form = _FormColumn(
                  controller: controller,
                  title: title,
                  subtitle: subtitle,
                  showResendOption: showResendOption,
                  onVerify: onVerify,
                  onResend: onResend,
                  maxWidth: formMaxWidth,
                );

                if (!showBrandingPanel) {
                  return Center(
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                      child: form,
                    ),
                  );
                }

                return Row(
                  children: [
                    const Expanded(flex: 5, child: _BrandingPanel()),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
                        child: Center(child: form),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _WebHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: onBack,
          ),
          const SizedBox(width: 8),
          const Text('One Time Verification', style: AppThemeStyle.headerTitle),
        ],
      ),
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: const Color(0xFFEFF1F8),
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.verified_user_outlined,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 28),
          const Text(
            'Keep your account\nsecure',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We sent a one-time code to your registered mobile number. '
            'Enter it to confirm this is really you before we continue.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.secondaryText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared form column between the "centered only" and "branding + form"
/// wide-screen arrangements.
class _FormColumn extends StatelessWidget {
  final OtpVerificationBloc controller;
  final String title;
  final String subtitle;
  final bool showResendOption;
  final Future<Map<String, dynamic>> Function(String otp) onVerify;
  final Future<void> Function() onResend;
  final double maxWidth;

  const _FormColumn({
    required this.controller,
    required this.title,
    required this.subtitle,
    required this.showResendOption,
    required this.onVerify,
    required this.onResend,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
        bloc: controller,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppThemeStyle.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppThemeStyle.pageTitle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppThemeStyle.pageSubtitle,
                ),
                const SizedBox(height: 28),
                OtpInputRow(
                  length: controller.otpLength,
                  controllers: controller.digitControllers,
                  focusNodes: controller.focusNodes,
                  isValid: state.errorText == null,
                  onChanged: (_) => controller.add(const OtpFieldEdited()),
                ),
                if (state.errorText != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    state.errorText!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.appPrimaryRedColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                if (showResendOption) ...[
                  const SizedBox(height: 22),
                  _ResendRow(
                    controller: controller,
                    state: state,
                    onResend: onResend,
                  ),
                ],
                const SizedBox(height: 28),
                state.isSubmitting
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          ),
                        ),
                      )
                    : AppButton(
                        title: 'Verify',
                        fullWidth: true,
                        enabledColor: AppColors.primaryPurple,
                        disabledColor:
                            AppColors.primaryPurple.withOpacity(0.4),
                        isEnabled: state.isComplete,
                        onPressed: () => controller.add(
                          OtpSubmitted(onVerify: onVerify),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  final OtpVerificationBloc controller;
  final OtpVerificationState state;
  final Future<void> Function() onResend;

  const _ResendRow({
    required this.controller,
    required this.state,
    required this.onResend,
  });

  String _formatSeconds(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (!state.canResend) {
      return Text(
        "Didn't receive the code? Resend in ${_formatSeconds(state.resendSecondsRemaining)}",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.secondaryText,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return Center(
      child: GestureDetector(
        onTap: state.isResending
            ? null
            : () => controller.add(OtpResendRequested(onResend: onResend)),
        child: Text(
          state.isResending ? 'Resending...' : 'Resend OTP',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.primaryPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
