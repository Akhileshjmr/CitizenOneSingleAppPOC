import 'package:citizenone_app/modules/agency_banking/presentation/screens/otp_pin_verfication/view/widgets/otp_input_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/form/app_button.dart';
import '../../../../theme/app_theme_style.dart';
import '../../../../theme/colors/Appcolors.dart';
import '../bloc/otp_verification_bloc.dart';
import '../bloc/otp_verification_event.dart';
import '../bloc/otp_verification_state.dart';

/// Mobile layout for the One Time Verification screen. Matches the
/// reference screenshot: back arrow + "One Time Verification" header,
/// centered title/subtitle, a row of OTP boxes, and a full-width
/// "Verify" button pinned to the bottom of the screen (not scrolling
/// away with the content above it).
class OtpVerificationMobileLayout extends StatelessWidget {
  final OtpVerificationBloc controller;
  final VoidCallback onBack;
  final Future<Map<String, dynamic>> Function(String otp) onVerify;
  final Future<void> Function() onResend;

  /// Configurable copy, so this same screen can be reused anywhere an
  /// OTP is needed (login, transaction confirm, KYC, ...) with
  /// different wording, without touching this file.
  final String title;
  final String subtitle;
  final bool showResendOption;

  const OtpVerificationMobileLayout({
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
      body: SafeArea(
        child: BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
          bloc: controller,
          builder: (context, state) {
            return Column(
              children: [
                _Header(onBack: onBack, title: 'One Time Verification'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppThemeStyle.pageTitle
                              .copyWith(fontSize: 18, height: 1.3),
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
                          onChanged: (_) =>
                              controller.add(const OtpFieldEdited()),
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: state.isSubmitting
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.4),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  final String title;
  const _Header({required this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          Text(title, style: AppThemeStyle.headerTitle),
        ],
      ),
    );
  }
}

/// "Didn't receive the code? Resend in 00:28" — becomes a tappable
/// "Resend OTP" link once the cooldown reaches zero.
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
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.secondaryText,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return GestureDetector(
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
    );
  }
}
