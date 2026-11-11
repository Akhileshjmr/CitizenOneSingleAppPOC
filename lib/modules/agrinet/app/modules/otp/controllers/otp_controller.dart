import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_snackbar.dart';
import '../../../data/provider/my_profile_service.dart';
import '../../../routes/app_pages.dart';

class OtpController extends GetxController {
  var otp = "".obs;
  RxString serverOtp = "".obs;
  var mobile = "";
  RxBool isLoading = false.obs;

  /// Text controllers for 6 OTP fields
  final List<TextEditingController> textControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  /// Focus nodes for 6 OTP fields
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void onInit() {
    super.onInit();

    /// Read arguments passed from previous screen
    final args = Get.arguments ?? {};
    mobile = args["mobile"] ?? "";
    serverOtp.value = args["otp"] ?? "";

    debugPrint("📲 Mobile: $mobile");
    debugPrint("🔐 Server OTP: $serverOtp");
  }

  /// Build full OTP from 6 fields
  void rebuildOtp() {
    otp.value = textControllers.map((c) => c.text).join();
  }

  /// VERIFY OTP
  Future<void> verifyOtp() async {
    try {
      isLoading(true);
      final entered = otp.value.trim();
      final correct = serverOtp.trim();

      if (entered.length != 6) {
        agSnackbar(title: "Invalid", msg: "Please enter complete 6-digit OTP");
        return;
      }

      if (entered != correct) {
        agSnackbar(title: "Error", msg: "Incorrect OTP, please try again");
        return;
      }

      /// SUCCESS
      await Future.delayed(const Duration(milliseconds: 800), () {
        Get.offAllNamed(Routes.LOGIN);
      });

      agSnackbar(title: "Success", msg: "User registered Successfully!");
    } finally {
      isLoading(false);
    }
  }

  Future<void> resendCode() async {
    try {
      isLoading(true);

      final response = await ProfileService.getOtp(
        request: {
          "comReq": {},
          "secParam": {"userName": mobile},
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to get OTP");
        return;
      }

      serverOtp(response.reqSecureKey);
    } catch (e) {
      agSnackbar(title: "Error", msg: e.toString());
    } finally {
      isLoading(false);
    }
  }
}
