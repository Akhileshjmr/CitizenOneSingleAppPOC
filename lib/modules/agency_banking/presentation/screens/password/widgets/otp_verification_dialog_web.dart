import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

/// Web-only (>=600px) OTP verification dialog content, styled to match the
/// Desktop-58 design. Purely presentational — the timer/attempt-count/resend
/// state machine lives in ForgotPasswordScreen's existing _showOtpDialog
/// (via StatefulBuilder), unchanged. This widget just renders the current
/// values it's handed and forwards taps to [onResend]/[onVerify], so it can
/// be swapped in without touching that logic. Kept in its own file so
/// mobile's OtpVerificationScreenMobile is never touched while editing this.
class OtpVerificationDialogWeb extends StatelessWidget {
  final TextEditingController otpController;
  final int resendSeconds;
  final bool canResendOtp;
  final bool showLimitMessage;
  final int remainingAttempts;
  final VoidCallback onResend;
  final VoidCallback onVerify;

  const OtpVerificationDialogWeb({
    super.key,
    required this.otpController,
    required this.resendSeconds,
    required this.canResendOtp,
    required this.showLimitMessage,
    required this.remainingAttempts,
    required this.onResend,
    required this.onVerify,
  });

  String get _formattedTime {
    final minutes = resendSeconds ~/ 60;
    final seconds = resendSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')} Sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: Stack(
        children: [
          Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.kEEF2FF,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gpp_good_outlined,
                  color: AppColors.k613AF5,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "One Time Verification",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "To verify your identity, enter the One-Time Password (OTP) sent to your registered mobile number.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Pinput(
                controller: otpController,
                length: 6,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                defaultPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.k613AF5, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 48,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k613AF5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.k613AF5),
                    color: AppColors.kEEF2FF,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (showLimitMessage || (remainingAttempts == 0))
                const Text(
                  "Resend OTP limit reached",
                  style: TextStyle(color: AppColors.appPrimaryRedColor),
                )
              else if (canResendOtp && remainingAttempts != 0)
                GestureDetector(
                  onTap: onResend,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, size: 16, color: AppColors.k613AF5),
                      SizedBox(width: 6),
                      Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: AppColors.k613AF5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  _formattedTime,
                  style: const TextStyle(
                    color: AppColors.k613AF5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                "Attempts Left $remainingAttempts",
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: otpController,
                builder: (context, value, _) {
                  final bool isEnabled = value.text.length == 6;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                        backgroundColor: isEnabled
                            ? AppColors.k613AF5
                            : AppColors.primaryButtonBackgroundInactiveColor,
                      ),
                      onPressed: isEnabled ? onVerify : null,
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? Colors.white
                              : AppColors.primaryButtonInactiveTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
                ],
              ),
            ),
          ),
        ),
          ),
          const GlobalLoader(),
        ],
      ),
    );
  }
}
