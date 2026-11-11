import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
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
                const Text("Draw Signature",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  controller: controller, backgroundColor: AppColors.lightGray),
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
