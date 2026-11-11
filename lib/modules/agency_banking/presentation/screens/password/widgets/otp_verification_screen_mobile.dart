import 'dart:async';

import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

/// Mobile-only full-screen OTP verification UI. Purely presentational —
/// the actual OTP send/verify/attempt-count logic lives in the parent
/// (ForgotPasswordScreen) and is invoked here through [onSendOtp]/[onVerifyOtp]
/// so behavior stays identical to the existing web dialog flow.
class OtpVerificationScreenMobile extends StatefulWidget {
  final Future<void> Function() onSendOtp;
  final Future<void> Function(String otp) onVerifyOtp;
  final int Function() remainingAttempts;
  final int resendSeconds;

  const OtpVerificationScreenMobile({
    super.key,
    required this.onSendOtp,
    required this.onVerifyOtp,
    required this.remainingAttempts,
    this.resendSeconds = 30,
  });

  @override
  State<OtpVerificationScreenMobile> createState() =>
      _OtpVerificationScreenMobileState();
}

class _OtpVerificationScreenMobileState
    extends State<OtpVerificationScreenMobile> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _timer;
  late int _secondsLeft;
  bool _canResend = false;
  bool _isVerifying = false;
  String _otpValue = "";

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.resendSeconds;
    _startTimer();
    _otpController.addListener(() {
      setState(() => _otpValue = _otpController.text);
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = widget.resendSeconds;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _canResend = true;
        });
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _handleResend() async {
    _otpController.text = "";
    await widget.onSendOtp();
    if (mounted) _startTimer();
  }

  Future<void> _handleVerify() async {
    if (_otpValue.length != 6 || _isVerifying) return;
    setState(() => _isVerifying = true);
    await widget.onVerifyOtp(_otpValue);
    if (mounted) setState(() => _isVerifying = false);
  }

  String get _formattedTime {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')} Sec";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = _otpValue.length == 6 && !_isVerifying;

    return Scaffold(
      backgroundColor: AppMobileColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "OTP Verification",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Backgroundcomponent(
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(18),
            //   ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
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
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "One Time Verification",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
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
                    controller: _otpController,
                    length: 6,
                    autofocus: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    defaultPinTheme: PinTheme(
                      width: 44,
                      height: 52,
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
                      width: 44,
                      height: 52,
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
                      width: 44,
                      height: 52,
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
                  const SizedBox(height: 20),
                  if (widget.remainingAttempts() == 0)
                    const Text(
                      "Resend OTP limit reached",
                      style: TextStyle(color: AppColors.appPrimaryRedColor),
                    )
                  else if (_canResend && (widget.remainingAttempts() != 0))
                    GestureDetector(
                      onTap: _handleResend,
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
                    "Attempts Left ${widget.remainingAttempts()}",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
          ),
          const GlobalLoader(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
              backgroundColor: isEnabled
                  ? AppColors.k613AF5
                  : AppColors.primaryButtonBackgroundInactiveColor,
            ),
            onPressed: isEnabled ? _handleVerify : null,
            child: Text(
              _isVerifying ? "Verifying..." : "Verify OTP",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isEnabled
                    ? Colors.white
                    : AppColors.primaryButtonInactiveTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
