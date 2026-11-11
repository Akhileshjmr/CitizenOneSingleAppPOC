import 'package:get/get.dart';

import '../controllers/otp_verification_controller.dart';

/// OTP Verification Binding
class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(() => OtpVerificationController());
  }
}
