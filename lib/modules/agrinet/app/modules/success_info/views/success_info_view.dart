import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/success_info_controller.dart';

class SuccessInfoView extends GetView<SuccessInfoController> {
  const SuccessInfoView({super.key});

  static Future<void> show({
    required String title,
    required String message,
    required VoidCallback onOk,
  }) async {
    return Get.toNamed(
      Routes.SUCCESS_INFO,
      arguments: {"title": title, "message": message, "onOk": onOk},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kSuccessBg,

      body: Center(
        child: Container(
          width: Get.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AgColors.kWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                controller.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 16),

              /// Message
              Text(
                controller.message,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 28),

              /// OK Button aligned right
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.handleOk,
                  child: const Text(
                    "Okay",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AgColors.colorPrimaryDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
