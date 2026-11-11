import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/session/session_manager.dart';

import '../../../data/remote/provider/auth_service.dart';
import '../../../session/services/session_api.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void onInit() {
    // phoneNumberController.text = "779562957";
    super.onInit();
  }

  Future<void> login() async {
    final phoneNumber = phoneNumberController.text.trim();

    if (phoneNumber.isEmpty) {
      appSnackbar(message: "Please enter phone number");
      return;
    }

    if (phoneNumber.length < 9) {
      appSnackbar(message: "Enter valid 9-digit phone number");
      return;
    }

    try {
      isLoading(true);
      final sessionManager = Get.find<SessionManager>();
      final shouldCreateSession = !sessionManager.hasActiveSession;

      if (shouldCreateSession) {
        SessionApi.sessionSecureKey = phoneNumber;
        await sessionManager.createSession(phoneNumber: phoneNumber);
      }

      final didLogin = await AuthService.login(phoneNumber: phoneNumber);
      if (!didLogin && shouldCreateSession) {
        await sessionManager.cleanupSession();
      }
    } finally {
      isLoading(false);
    }
  }

  /* Future<void> loginWithPhone() async {
    final phoneNumber = phoneNumberController.text.trim();

    if (phoneNumber.isEmpty) {
      agSnackbar(title: "Error", msg: "Please enter a phone number.");
      return;
    }

    if (phoneNumber.length < 9) {
      agSnackbar(
        title: "Error",
        msg: "Please enter a valid 9-digit phone number.",
      );
      return;
    }

    const countryCode = '971';

    try {
      isLoading(true);
      final encryptedOtp = await AuthService.getOtp(
        formData: {
          'filterHashKey': 0,
          'reqSecureKey': phoneNumber,
          'filterVal': countryCode,
          'hKey': 0,
        },
      );

      if (encryptedOtp == null || encryptedOtp.isEmpty) {
        logWTF('OTP is empty');
        agSnackbar(
          title: "Error",
          msg: "Failed to receive OTP. Please try again.",
        );
        return;
      }

      /// Login using OTP
      final LoginResponse response = await AuthService.loginWithOTP({
        'userName': phoneNumber,
        'otp': encryptedOtp,
        'filterVal': 'Customer',
        'countryCode': countryCode,
      });

      if (response.chMessage.isError) {
        agSnackbar(
          title: "Error",
          msg: response.chMessage.message ?? "Login failed. Please try again.",
        );
        return;
      }

      if (response.reqSecureKey == null) {
        agSnackbar(title: "Error", msg: "Invalid login response.");
        return;
      }

      await UserProvider.saveMobile(phoneNumber);
      await UserProvider.onLogin(response, response.reqSecureKey ?? '');

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      logE(e);
      agSnackbar(
        title: "Error",
        msg: "Something went wrong. Please try again.",
      );
    } finally {
      isLoading(false);
    }
  }*/
}
