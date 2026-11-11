import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ag_colors.dart';

class StartDateInputDialog extends StatelessWidget {
  StartDateInputDialog({super.key, required this.onProceed});

  /// Called when user taps Proceed
  final void Function(DateTime selectedDate) onProceed;

  // Rx date to control Proceed button state
  final Rx<DateTime?> _pickedDate = Rx<DateTime?>(null);

  // Controller for displaying date in the TextField
  final TextEditingController _textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              'Input Start Date for Scheduling of Crop',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AgColors.colorPrimary,
              ),
            ),
            const SizedBox(height: 16),

            /// Read-only date TextField (no Obx here)
            TextField(
              controller: _textCtrl,
              readOnly: true,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Input Here',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onTap: () async {
                final now = DateTime.now();

                final selected = await showDatePicker(
                  context: context,
                  initialDate: _pickedDate.value ?? now,
                  firstDate: DateTime(now.year - 2),
                  lastDate: DateTime(now.year + 3),
                  //THIS PART CHANGES COLORS
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(
                            0xFF3E6A2A,
                          ), // header background & selected date
                          onPrimary: Colors.white, // header text color
                          onSurface: Colors.black, // default text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Color(
                              0xFF3E6A2A,
                            ), // OK & CANCEL button colors
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (selected != null) {
                  _pickedDate.value = selected;
                  _textCtrl.text = _formatDate(selected);
                }
              },
            ),

            const SizedBox(height: 24),

            /// Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AgButton(
                  title: 'Dismiss',
                  onTap: () => Get.back(),
                  isOutlined: true,
                ),
                const SizedBox(width: 10),
                Obx(
                  () => AgButton(
                    title: 'Proceed',
                    backgroundColor:
                        _pickedDate.value == null
                            ? Colors.grey.shade400
                            : AgColors.buttonColor,
                    onTap:
                        _pickedDate.value == null
                            ? null
                            : () {
                              onProceed(_pickedDate.value!);
                              Get.back();
                            },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Format as dd/MM/yyyy
  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }
}
