import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/ag_text_styles.dart';

class AgAlertDialog {
  ///  DEFAULT ALERT
  static Future<void> show({
    required String title,
    required String message,
    String buttonText = "Ok",
    VoidCallback? onOk,
  }) {
    return Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: kw600Primary18),
                  const SizedBox(height: 14),
                  Text(message, style: kw400Primary14),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        if (onOk != null) onOk();
                      },
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF496C3A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  /// CONFIRMATION ALERT
  static Future<void> confirm({
    required String title,
    required String message,
    required String okText,
    required String cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return Get.dialog(
      Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0EE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 14),

                /// Message
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),

                const SizedBox(height: 20),

                /// Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// Cancel Button
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        if (onCancel != null) onCancel();
                      },
                      child: Text(cancelText, style: kw6003D5A2A18),
                    ),

                    const SizedBox(width: 25),

                    /// OK Button
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        if (onConfirm != null) onConfirm();
                      },
                      child: Text(okText, style: kw600Primary18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  static Widget confirmWidget({
    required String title,
    required String message,
    required String okText,
    required String cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0EE),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onCancel,
                    child: Text(cancelText, style: kw6003D5A2A18),
                  ),

                  const SizedBox(width: 25),

                  GestureDetector(
                    onTap: onConfirm,
                    child: Text(okText, style: kw600Primary18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
