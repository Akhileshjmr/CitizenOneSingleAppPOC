import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F2),
      appBar: AgAppbar(title: "Otp"),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                const Text(
                  "You will receive an SMS shortly to verify your phone number.",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Did not receive an SMS? "),
                    GestureDetector(
                      onTap:
                          controller.resendCode, // existing functionality kept
                      child: const Text(
                        "Click here",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Display Server OTP (debug)
                Text(
                  controller.serverOtp.value,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Verification Code",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF415D36),
                  ),
                ),

                const SizedBox(height: 30),

                _otpFields(),

                const SizedBox(height: 40),

                AgButton(title: "VERIFY", onTap: controller.verifyOtp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// OTP TEXT FIELDS WITH AUTO-JUMP + AUTO-BACKSPACE
  Widget _otpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 45,
          height: 55,
          child: TextField(
            controller: controller.textControllers[index],
            focusNode: controller.focusNodes[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),

            /// AUTO-MOVE LOGIC
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Move to next field
                if (index < 5) {
                  controller.focusNodes[index + 1].requestFocus();
                } else {
                  FocusScope.of(Get.context!).unfocus();
                }
              } else {
                // Move to previous field
                if (index > 0) {
                  controller.focusNodes[index - 1].requestFocus();
                }
              }

              controller.rebuildOtp();
            },
          ),
        );
      }),
    );
  }
}
