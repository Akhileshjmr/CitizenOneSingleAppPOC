import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePadDialog extends StatelessWidget {
  final SignatureController controller;
  final VoidCallback onClear;
  final VoidCallback onSave;

  const SignaturePadDialog({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  "Draw Signature",
                  style: AppTextStyle.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Signature(
                controller: controller,
                backgroundColor: AppColors.surface,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: onClear, child: const Text("Clear")),
                TextButton(onPressed: onSave, child: const Text("Save")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
