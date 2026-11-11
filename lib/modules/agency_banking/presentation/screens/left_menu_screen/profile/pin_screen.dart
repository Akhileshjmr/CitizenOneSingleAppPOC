import 'dart:async';

import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommCustomerPin.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/UserOtpValidationInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/change_pin_bloc/change_pin_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/change_pin_bloc/change_pin_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/change_pin_bloc/change_pin_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_pin_bloc/reset_pin_bloc%20(1).dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_pin_bloc/reset_pin_event%20(1).dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_pin_bloc/reset_pin_state%20(1).dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../utils/AESEncryption.dart';
import '../../../../utils/CommDialog.dart';

class PinScreen extends StatefulWidget {
  final String managePin;
  final LoginUserReqResInfo loginResponse;
  final CommAgentDetails profileResponse;
  const PinScreen({
    required this.managePin,
    required this.loginResponse,
    required this.profileResponse,
  });

  @override
  _PinScreen createState() => _PinScreen();
}

class _PinScreen extends State<PinScreen> {
  Color myHexColor = Color(0xff5c7d33);
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  final TextEditingController oldPinController = TextEditingController();
  bool isOtpVisible = false;
  bool isNewPinVisible = false;
  bool isConfirmPinVisible = false;
  bool isOldPinVisible = false;
  bool isFormValid = false;
  UserOTPValidationInfo? otpInfo;
  Timer? _resendTimer;
  int _resendSeconds = 30;
  bool _canResendOtp = false;

  // 🔒 RESEND LIMIT
  static const int _maxResendAttempts = 3;
  int _resendAttemptCount = 0;

  @override
  void initState() {
    super.initState();
    // Add listeners to the controllers

    AppLogger.debug('PinScreen initState - managePin: ${widget.managePin}');
    otpController.addListener(_validateForm);
    oldPinController.addListener(_validateForm);
    newPinController.addListener(_validateForm);
    confirmPinController.addListener(_validateForm);
    if (widget.managePin == "Reset") {
      _resendAttemptCount = 1; // ✅ FIRST ATTEMPT USED
      _sendOtp();
      _startResendTimer();
    }
  }

  // ---------------- SEND / RESEND OTP ----------------
  void _sendOtp() {
    if (widget.managePin == "Reset") {
      UserOTPValidationInfo getOtp = UserOTPValidationInfo();
      getOtp.headerInfo = widget.loginResponse.headerInfo;
      getOtp.mobileNo = widget.loginResponse.loginUserInfo.userName ?? "";
      getOtp.userName = widget.loginResponse.loginUserInfo.userName ?? "";

      context.read<ForgotPasswordBloc>().add(
            ForgotPasswordSubmitted(getOtp),
          );
    }
  }

  void _submitOtp(BuildContext context) {
    final otp = otpController.text; // Null-safe trim

    if (otp.isEmpty) {
      showCustomBottomPopup(context, "Enter OTP");
      return;
    }
    if (otp.length != 6) {
      showCustomBottomPopup(context, "OTP must be exactly 6 digits");
      return;
    }
    UserOTPValidationInfo request = UserOTPValidationInfo();
    request.otpuniqueid = otpInfo?.otpuniqueid;
    request.otp = otpController.text;
    request.headerInfo = widget.loginResponse.headerInfo;
    request.mobileNo = widget.loginResponse.headerInfo.userName ?? " ";
    request.userName = widget.loginResponse.headerInfo.userName ?? "";
    context.read<ForgotPasswordBloc>().add(ValidateOtpSubmitted(request));
  }

  // ---------------- TIMER ----------------
  void _startResendTimer() {
    _resendTimer?.cancel();

    setState(() {
      _resendSeconds = 30;
      _canResendOtp = false;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
        setState(() => _canResendOtp = true);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    oldPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      if (widget.managePin == "Reset") {
        // Only validate OTP, new PIN, and confirm PIN for reset
        isFormValid = otpController.text.length == 6 &&
            newPinController.text.length == 6 &&
            confirmPinController.text.length == 6 &&
            newPinController.text == confirmPinController.text;
      } else if (widget.managePin == "Change") {
        // Validate old PIN, new PIN, and confirm PIN for change
        isFormValid = oldPinController.text.length == 6 &&
            newPinController.text.length == 6 &&
            confirmPinController.text.length == 6 &&
            newPinController.text == confirmPinController.text;
      } else {
        isFormValid = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "PIN"),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                setState(() {
                  otpInfo = state.userOtp;
                });
              } else if (state is ForgotPasswordFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<ResetPinBloc, ResetPinState>(
            listener: (context, state) {
              if (state is ResetPinSuccess) {
                showPinSuccessDialog(
                    context, widget.managePin, widget.loginResponse);
              } else if (state is ResetPinFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<ChangePinBloc, ChangePinState>(
            listener: (context, state) {
              if (state is ChangePinSuccess) {
                showPinSuccessDialog(
                    context, widget.managePin, widget.loginResponse);
              } else if (state is ChangePinFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            /// 🔹 Scrollable content
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    bottom: 120), // leave space for button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.managePin == "Reset"
                            ? "Reset PIN"
                            : "Change PIN",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// OTP or Old PIN Input
                    Center(
                      child: Text(
                        widget.managePin == "Reset"
                            ? "ENTER OTP"
                            : "ENTER OLD PIN",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Pinput(
                              autofocus: false,
                              length: 6,
                              obscureText: widget.managePin == "Reset"
                                  ? !isOtpVisible
                                  : !isOldPinVisible,
                              controller: widget.managePin == "Reset"
                                  ? otpController
                                  : oldPinController,
                              defaultPinTheme: PinTheme(
                                width: 40,
                                height: 40,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (widget.managePin == "Reset") {
                                  isOtpVisible = !isOtpVisible;
                                } else {
                                  isOldPinVisible = !isOldPinVisible;
                                }
                              });
                            },
                            child: Icon(
                              widget.managePin == "Reset"
                                  ? (isOtpVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)
                                  : (isOldPinVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (widget.managePin == "Reset") ...[
                      const SizedBox(height: 15),

                      // 🔁 RESEND OTP LOGIC (MAX 3)
                      /*Center(
                        child: _resendAttemptCount >= _maxResendAttempts
                            ? const Text(
                          "Resend OTP limit reached",
                          style: TextStyle(color: Colors.red),
                        )
                            : _canResendOtp
                            ? TextButton(
                          onPressed: () {
                            if (_resendAttemptCount < _maxResendAttempts) {
                              _resendAttemptCount++;
                              _sendOtp();
                              _startResendTimer();
                            }
                          },
                          child: Text(
                            "Resend OTP (${_maxResendAttempts - _resendAttemptCount} left)",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        )
                            : Text(
                          "Resend OTP in $_resendSeconds sec",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),*/
                      Center(
                        child: !_canResendOtp
                            ? Text(
                                "Resend OTP in $_resendSeconds sec",
                                style: const TextStyle(color: Colors.grey),
                              )
                            : _resendAttemptCount >= _maxResendAttempts
                                ? const Text(
                                    "Resend OTP limit reached",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      _resendAttemptCount++;
                                      _sendOtp();
                                      _startResendTimer();
                                    },
                                    child: Text(
                                      "Resend OTP (${_maxResendAttempts - _resendAttemptCount} attempts left)",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                      )
                    ],

                    const SizedBox(height: 20),

                    /// New PIN
                    Center(
                      child: const Text(
                        'ENTER NEW PIN',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Pinput(
                              autofocus: false,
                              length: 6,
                              obscureText: !isNewPinVisible,
                              controller: newPinController,
                              defaultPinTheme: const PinTheme(
                                width: 40,
                                height: 40,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(
                                  () => isNewPinVisible = !isNewPinVisible);
                            },
                            child: Icon(
                              isNewPinVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Confirm PIN
                    const Center(
                      child: Text(
                        'ENTER CONFIRM PIN',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Pinput(
                              autofocus: false,
                              length: 6,
                              obscureText: !isConfirmPinVisible,
                              controller: confirmPinController,
                              defaultPinTheme: const PinTheme(
                                width: 40,
                                height: 40,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() =>
                                  isConfirmPinVisible = !isConfirmPinVisible);
                            },
                            child: Icon(
                              isConfirmPinVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            /// 🔹 Fixed Submit button (SafeArea)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: buildActionButton(
                    label: 'Submit',
                    onPressed: isFormValid
                        ? () {
                            if (widget.managePin == "Reset") {
                              if (AESEncryptionService.decrypt(
                                      widget.profileResponse.userpin ?? '') ==
                                  newPinController.text) {
                                showCustomBottomPopup(context,
                                    'Old PIN and New PIN cannot be same');
                                return;
                              }
                              CommCustomerPin resetPin = CommCustomerPin();
                              resetPin.headerInfo =
                                  widget.loginResponse.headerInfo;
                              resetPin.customerPin =
                                  AESEncryptionService.encrypt(
                                      newPinController.text);
                              resetPin.otp = AESEncryptionService.encrypt(
                                  otpController.text);
                              resetPin.unique_id = otpInfo?.otpuniqueid ?? '';
                              resetPin.mobile_no =
                                  widget.loginResponse.headerInfo.userName;

                              context
                                  .read<ResetPinBloc>()
                                  .add(ResetPinSubmitted(resetPin));
                            } else {
                              // 1️⃣ Validate OLD PIN matches server PIN
                              if (oldPinController.text !=
                                  AESEncryptionService.decrypt(
                                      widget.profileResponse.userpin ?? '')) {
                                showCustomBottomPopup(
                                    context, 'Old PIN is Incorrect');
                                return;
                              }

// 2️⃣ Old PIN and New PIN cannot be same
                              if (AESEncryptionService.decrypt(
                                      widget.profileResponse.userpin ?? '') ==
                                  newPinController.text) {
                                showCustomBottomPopup(context,
                                    'Old PIN and New PIN cannot be same');
                                return;
                              }

// 3️⃣ Submit API call
                              CommCustomerPin changePin = CommCustomerPin();
                              changePin.headerInfo =
                                  widget.loginResponse.headerInfo;
                              changePin.customerPin =
                                  AESEncryptionService.encrypt(
                                      newPinController.text);
                              changePin.oldCustomerPin =
                                  AESEncryptionService.encrypt(
                                      oldPinController.text);
                              changePin.mobile_no =
                                  widget.loginResponse.headerInfo.userName;

                              context
                                  .read<ChangePinBloc>()
                                  .add(ChangePinSubmitted(changePin));
                            }
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
