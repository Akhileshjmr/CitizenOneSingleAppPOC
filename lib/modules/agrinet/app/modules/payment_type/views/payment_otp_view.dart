import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/payment_type/controllers/payment_type_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentOtpView extends GetView<PaymentTypeController> {
  const PaymentOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'AgriNET'),
      body: _body(),
      backgroundColor: const Color(0xFFF3FAF8), // light background like design
    );
  }

  Widget _body() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        const Text(
          'Enter the OTP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        AgTextField(
          name: 'OTP',
          hintText: 'Enter OTP',
          keyboardType: TextInputType.number,
          maxLength: 6,
          controller: controller.otpController,
        ),
        const SizedBox(height: 8),
        Text(
          'Pull down the drawer from top and find the OTP '
          'to be filled in the box. Highly confidential don’t '
          'share to any body',
          style: TextStyle(fontSize: 12, color: AgColors.FF4500),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if (controller.otpController.text.isEmpty ||
                  controller.otpController.text.length < 4) {
                agSnackbar(
                  title: 'Error',
                  msg: 'Please enter a valid 4-digit OTP',
                );
                return;
              } else {
                Get.toNamed(
                  Routes.SUCCESS_INFO,
                  arguments: {
                    "title": "Success",
                    "message": "Payment Successful",
                    "onOk": () {
                      Get.offAllNamed(Routes.HOME);
                    },
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB57A2A), // brown color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'VERIFY ME',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
