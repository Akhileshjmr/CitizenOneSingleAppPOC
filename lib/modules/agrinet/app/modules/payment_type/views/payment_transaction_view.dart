import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/payment_type/controllers/payment_type_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentTransactionIdView extends GetView<PaymentTypeController> {
  const PaymentTransactionIdView({super.key});

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
          'To validate your payment, enter transaction ID from your receipt,e.g',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 8),
        const Text(
          '- Bank slip',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 16),
        AgTextField(
          name: 'Transaction ID',
          hintText: 'Enter Transaction ID here',
          keyboardType: TextInputType.number,
          maxLength: 6,
          controller: controller.transIdController,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              if (controller.transIdController.text.isEmpty) {
                agSnackbar(
                  title: 'Error',
                  msg: 'Please enter a Transaction ID',
                );
                return;
              } else {
                Get.toNamed(
                  Routes.SUCCESS_INFO,
                  arguments: {
                    "title": "Info",
                    "message": "The payment has been completed successfully.",
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
              'Submit',
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
