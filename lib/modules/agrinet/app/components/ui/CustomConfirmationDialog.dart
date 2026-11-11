// custom_confirmation_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'CustomTextButton.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const CustomConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  static const Color kGreen = Color(0xff4F6F39);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
          decoration: BoxDecoration(
            color: const Color(0xffF4FBF9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextButton(
                    title: cancelText,
                    color: Colors.grey,
                    onTap: onCancel ?? () => Get.back(),
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(width: 20),
                  CustomTextButton(
                    title: confirmText,
                    color: kGreen,
                    onTap: onConfirm,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
