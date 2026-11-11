import 'dart:async';

import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../data/models/common_models/HeaderInfo.dart';
import '../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../data/services/AuthService.dart';
import '../../../utils/AESEncryption.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../blocs/forgot_password_bloc/forgot_password_event.dart';
import '../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../blocs/reset_password_bloc/reset_password_bloc.dart';
import 'reset_password_screen.dart';
import 'widgets/forgot_password_web_view.dart';
import 'widgets/otp_verification_dialog_web.dart';
import 'widgets/otp_verification_screen_mobile.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bool isPasswordExpiredFlow;

  const ForgotPasswordScreen({
    Key? key,
    this.isPasswordExpiredFlow = false,
  }) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AuthService authService;
  String? otpUniqueId;

  bool _dialogShownOnce = false;
  bool _isDialogOpen = false;

  /// ⏱ TIMER
  Timer? _resendTimer;
  int _resendSeconds = 30;
  bool _canResendOtp = false;

  /// 🔒 TOTAL OTP LIMIT (FIRST + RESENDS)
  static const int _maxOtpAttempts = 3;
  int _otpAttemptCount = 0;

  /// 👇 Controls when limit message is shown
  bool _showLimitMessage = false;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
  }

  // ---------------- SEND OTP ----------------
  void _sendOtp() {
    if (_otpAttemptCount >= _maxOtpAttempts) return;

    final mobileNumber = mobileController.text.trim();

    if (mobileNumber.isEmpty) {
      showCustomBottomPopup(context, "Mobile Number is required");
      return;
    }

    if (mobileNumber.length < 9) {
      showCustomBottomPopup(context, "Enter a valid mobile number");
      return;
    }

    _otpAttemptCount++;
    _showLimitMessage = false;

    UserOTPValidationInfo otpReq = UserOTPValidationInfo();
    otpReq.mobileNo = AESEncryptionService.encrypt(mobileNumber);
    otpReq.userName = AESEncryptionService.encrypt(mobileNumber);

    HeaderInfo header = HeaderInfo();
    header.message = "SKIP_SESSION";
    header.initialAccess = true;
    otpReq.headerInfo = header;

    context.read<ForgotPasswordBloc>().add(
          ForgotPasswordSubmitted(otpReq),
        );
  }

  // ---------------- TIMER ----------------
  void _startTimer(void Function(void Function()) setDialogState) {
    _resendTimer?.cancel();

    setDialogState(() {
      _resendSeconds = 30;
      _canResendOtp = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
        setDialogState(() {
          _canResendOtp = true;

          // ✅ show limit message ONLY after timer ends
          if (_otpAttemptCount >= _maxOtpAttempts) {
            _showLimitMessage = true;
          }
        });
      } else {
        setDialogState(() => _resendSeconds--);
      }
    });
  }

  // ---------------- OTP SCREEN (MOBILE) ----------------
  Future<void> _openOtpScreenMobile() async {
    if (_dialogShownOnce || _isDialogOpen) return;

    _dialogShownOnce = true;
    _isDialogOpen = true;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreenMobile(
          onSendOtp: () async => _sendOtp(),
          onVerifyOtp: (otp) => _verifyOtp(UserOTPValidationInfo(), otp),
          remainingAttempts: () => _maxOtpAttempts - _otpAttemptCount,
        ),
      ),
    );

    _isDialogOpen = false;
  }

  // ---------------- OTP DIALOG ----------------
  void _showOtpDialog() {
    if (_dialogShownOnce || _isDialogOpen) return;

    _dialogShownOnce = true;
    _isDialogOpen = true;

    final TextEditingController otpController = TextEditingController();
    bool timerStarted = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (!timerStarted) {
              timerStarted = true;
              _startTimer(setDialogState);
            }

            final int remainingAttempts = _maxOtpAttempts - _otpAttemptCount;

            return OtpVerificationDialogWeb(
              otpController: otpController,
              resendSeconds: _resendSeconds,
              canResendOtp: _canResendOtp,
              showLimitMessage: _showLimitMessage,
              remainingAttempts: remainingAttempts,
              onResend: () {
                _sendOtp();
                _startTimer(setDialogState);
                otpController.text = "";
              },
              onVerify: () {
                final otpInfo = UserOTPValidationInfo();
                _verifyOtp(otpInfo, otpController.text.trim());
              },
            );
          },
        );
      },
    ).then((_) {
      _isDialogOpen = false;
    });
  }

  // ---------------- VERIFY OTP ----------------
  Future<void> _verifyOtp(UserOTPValidationInfo otpInfo, String otp) async {
    if (otp.isEmpty) {
      showCustomBottomPopup(context, "OTP is required");
      return;
    }

    otpInfo.otp = otp;
    otpInfo.otpuniqueid = otpUniqueId!;
    otpInfo.mobileNo =
        AESEncryptionService.encrypt(mobileController.text.trim());
    otpInfo.userName =
        AESEncryptionService.encrypt(mobileController.text.trim());

    HeaderInfo header = HeaderInfo();
    header.message = "SKIP_SESSION";
    header.initialAccess = true;
    otpInfo.headerInfo = header;

    context.read<LoadingCubit>().show();
    final response = await authService.otpFailedValidation(otpInfo);
    if (!context.mounted) return;
    context.read<LoadingCubit>().hide();

    if (response != null && response.resMessage.errorCode == "AB-ATTEMPT-100") {
      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ResetPasswordBloc(authService),
            child: ResetPasswordScreen(
              mobileNumber: AESEncryptionService.decrypt(otpInfo.mobileNo),
            ),
          ),
        ),
      );
    } else {
      showCustomBottomPopup(context, response?.resMessage.errorDescription);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final bool isMobileScaffold = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: isMobileScaffold
          ? AppMobileColors.background
          : AppColors.loginBackground,
      appBar: null,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordLoading) {
                  context.read<LoadingCubit>().show();
                } else {
                  context.read<LoadingCubit>().hide();
                }
                if (state is ForgotPasswordSuccess) {
                  otpUniqueId = state.userOtp.otpuniqueid;
                  final bool isMobile = MediaQuery.of(context).size.width < 600;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (isMobile) {
                      _openOtpScreenMobile();
                    } else {
                      _showOtpDialog();
                    }
                  });
                }

                if (state is ForgotPasswordFailure) {
                  showCustomBottomPopup(context, state.error);
                }
              },
              builder: (context, state) {
                final bool isMobile = MediaQuery.of(context).size.width < 600;

                void handleSendOtp() {
                  _dialogShownOnce = false;
                  _otpAttemptCount = 0;
                  _showLimitMessage = false;
                  _sendOtp();
                }

                if (isMobile) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // const SizedBox(height: 16),
                              SizedBox(
                                height: 86,
                                width: 212,
                                child: Image.asset(
                                  'assets/icons/citizenLogo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 36),
                              Backgroundcomponent(
                                // Container(
                                //   width: double.infinity,
                                //   padding: const EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(20),
                                //   ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Enter your Mobile Number below — we'll verify your identity and guide you through resetting it.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      const Text(
                                        "Mobile Number",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Decorative only — the backend request
                                          // doesn't take a separate country code today.
                                          Container(
                                            height: 52,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.borderLight),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "+260",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                // Icon(Icons.keyboard_arrow_down,
                                                //     size: 18,
                                                //     color: AppColors.textSecondary),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: SizedBox(
                                              height: 52,
                                              child: TextField(
                                                controller: mobileController,
                                                maxLength: 9,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.textPrimary),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Enter Mobile Number",
                                                  hintStyle: const TextStyle(
                                                      color:
                                                          AppColors.textHint),
                                                  counterText: "",
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .borderLight),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .borderLight),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .k613AF5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.kEEF2FF,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.shield_outlined,
                                                size: 18,
                                                color: AppColors.k613AF5),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "Identity verified via your registered mobile number",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            shape: const StadiumBorder(),
                                            backgroundColor: AppColors.k613AF5,
                                          ),
                                          onPressed: handleSendOtp,
                                          child: const Text(
                                            "Continue",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ).paddingAll(16),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Remember your password? ",
                                    style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 14),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: AppColors.k613AF5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ForgotPasswordWebView(
                  mobileController: mobileController,
                  formKey: _formKey,
                  onSendOtp: handleSendOtp,
                );
              },
            ),
          ),
          const GlobalLoader(),
        ],
      ),
    );
  }

  // ---------------- DISPOSE ----------------
  @override
  void dispose() {
    _resendTimer?.cancel();
    mobileController.dispose();
    super.dispose();
  }
}
