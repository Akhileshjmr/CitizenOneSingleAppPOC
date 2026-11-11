import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/personal_info/controllers/personal_info_controller.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/utils/app_snackbar.dart';
import '../../../data/config/logger.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/otp/otp_verification_response.dart';
import '../../../data/remote/provider/otp/otp_service.dart';

/// OTP Verification Controller
class OtpVerificationController extends GetxController {
  /// Convenience getter to determine if verify button should be enabled
  bool get canVerify =>
      otp.value.length == 6 &&
      !isVerifying.value &&
      !isLoading.value &&
      !isVerifiedSuccess.value;

  /// Verify OTP and return result to caller (e.g., navigation)
  Future<void> verifyAndSubmit() async {
    final success = await verifyOtp();
    if (success) {
      _timer?.cancel();
      timerSeconds.value = 0;
      generatedOtp.value = '';
      clearOtp();
      successMessage.value = 'OTP verified successfully';
      isVerifiedSuccess.value = true;

      await Future.delayed(const Duration(milliseconds: 900));
      if (!isClosed) {
        Get.back(result: true);
      }
    }
  }

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Loading state for verify button
  final RxBool isVerifying = false.obs;

  /// Inline success state before returning to caller
  final RxBool isVerifiedSuccess = false.obs;

  /// Inline success message shown on OTP verification
  final RxString successMessage = ''.obs;

  /// OTP input fields
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  /// OTP focus nodes
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  /// OTP value
  final RxString otp = ''.obs;

  /// Remaining attempts
  final RxInt attemptRemaining = 0.obs;

  /// Timer value in seconds
  final RxInt timerSeconds = 0.obs;

  /// Timer for countdown
  Timer? _timer;

  /// OTP response data
  OtpVerificationResponse? otpData;

  /// Generated OTP for display (debug / testing)
  final RxString generatedOtp = ''.obs;

  /// User contact info
  late String mobile;
  late String email;

  /// Channel from API response
  final RxString channel = ''.obs;

  /// Destination from API response
  final RxString destination = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserContact();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  /// Load user contact info from UserProvider
  Future<void> _loadUserContact() async {
    mobile = await UserProvider.getMobileNumber();
    email = Get.find<PersonalInfoController>().emailIdController.text;
    // Automatically generate OTP after loading contact info
    await generateOtp();
  }

  /// Generate OTP
  Future<bool> generateOtp() async {
    isLoading.value = true;

    try {
      final response = await OtpService.getOtp(
        purpose: 'LOAN',
        referenceType: 'LOAN',
        addiParams: [mobile, email],
      );

      if (response != null) {
        // Check for error messages in the response
        if (response.chMessage?.type != 'SUCCESS' &&
            response.chMessage?.isError == true) {
          // Show an error dialog for maintenance or other issues
          AgAlertDialog.show(
            title: response.chMessage?.subject ?? 'Error',
            message:
                response.chMessage?.message ??
                'An unexpected error occurred while generating OTP.',
            buttonText: 'OK',
          );
          return false;
        }
        otpData = response;
        attemptRemaining.value = response.attemptRemaining ?? 3;
        timerSeconds.value = response.validityTime ?? 60;
        channel.value = response.channel ?? 'SMS';
        destination.value = response.destination ?? mobile;
        generatedOtp.value = response.otp ?? '';
        startTimer();
        return true;
      }
    } catch (e) {
      logE(e);
    } finally {
      isLoading.value = false;
    }

    return false;
  }

  /// Start countdown timer
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        timer.cancel();
        _onTimerExpired();
      }
    });
  }

  /// Handle timer expired
  void _onTimerExpired() {
    appSnackbar(
      message: 'OTP has expired. Please request a new one.',
      snackbarState: SnackbarState.warning,
    );
  }

  /// Format timer as MM:SS
  String get formattedTime {
    final minutes = (timerSeconds.value / 60).floor();
    final seconds = timerSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    isLoading.value = true;

    try {
      final response = await OtpService.getOtp(
        purpose: 'LOAN',
        referenceType: 'LOAN',
        addiParams: [mobile, email],
      );

      if (response != null) {
        otpData = response;
        attemptRemaining.value = response.attemptRemaining ?? 3;
        timerSeconds.value = response.validityTime ?? 60;
        channel.value = response.channel ?? 'SMS';
        destination.value = response.destination ?? mobile;
        generatedOtp.value = response.otp ?? '';

        // Clear OTP input
        clearOtp();

        // Restart timer
        startTimer();

        appSnackbar(
          message: 'OTP has been resent successfully',
          snackbarState: SnackbarState.success,
        );
      }
    } catch (e) {
      logE(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp() async {
    if (otp.value.length != 6) {
      appSnackbar(
        message: 'Please enter complete OTP',
        snackbarState: SnackbarState.warning,
      );
      return false;
    }

    isVerifying.value = true;

    try {
      final response = await OtpService.verifyOtp(
        channel: 'SMS',
        destination: mobile,
        purpose: 'LOAN',
        referenceType: 'LOAN',
        otp: otp.value,
      );

      if (response != null) {
        otpData = response;

        // Update remaining attempts from response if available
        if (response.attemptRemaining != null) {
          attemptRemaining.value = response.attemptRemaining!;
        }

        // Success case check: Handles "VERIFIED" status and various success types
        final bool isVerified =
            response.status == 'VERIFIED' ||
            response.chMessage?.type == 'SUCCESS' ||
            response.chMessage?.type == 'OTP_VERIFIED' ||
            response.chMessage?.code == 'SUCCESS';

        if (isVerified) {
          return true;
        }

        // Handle specific error types like "OTP_INVALID"
        final String? errorType = response.chMessage?.type;
        final String? errorMessage = response.chMessage?.message;

        if (errorType == 'OTP_INVALID' || errorType == 'OTP_NOT_FOUND') {
          appSnackbar(
            message: errorMessage ?? 'Entered OTP is invalid.',
            snackbarState: SnackbarState.warning,
          );

          // Clear OTP fields for retry
          clearOtp();

          // Check if we should lock based on attempts remaining
          if (response.isLocked == true || attemptRemaining.value <= 0) {
            _handleLockedScenario();
          }
          return false;
        }

        // Explicit error from API for other failure cases
        if (response.chMessage?.isError == true) {
          AgAlertDialog.show(
            title: response.chMessage?.subject ?? 'Alert',
            message: errorMessage ?? 'OTP verification failed.',
            buttonText: 'OK',
          );

          if (response.isLocked == true || attemptRemaining.value <= 0) {
            _handleLockedScenario();
          }
          return false;
        }

        // General failure fallback
        if (response.isLocked == true || attemptRemaining.value <= 0) {
          _handleLockedScenario();
        } else {
          appSnackbar(
            message: errorMessage ?? 'Invalid OTP',
            snackbarState: SnackbarState.warning,
          );
        }
      }
    } catch (e) {
      logE(e);
    } finally {
      isVerifying.value = false;
    }

    return false;
  }

  /// Handle locked scenario
  void _handleLockedScenario() {
    _timer?.cancel();
    AgAlertDialog.show(
      title: 'OTP Locked',
      message:
          'You have exceeded the maximum attempts. Please try again later or contact support.',
      buttonText: 'OK',
      onOk: () {
        Get.back(result: false);
      },
    );
  }

  /// Handle OTP input change
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    // Update OTP value
    otp.value = otpControllers.map((c) => c.text).join();
  }

  /// Clear OTP input
  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    otp.value = '';
  }

  /// Check if timer is running
  bool get isTimerRunning => timerSeconds.value > 0;

  /// Check if OTP is locked
  bool get isOtpLocked =>
      (otpData?.isLocked ?? false) || attemptRemaining.value <= 0;
}
