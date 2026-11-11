import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/EventDisplay/controllers/event_display_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventRescheduleDialog extends StatelessWidget {
  EventRescheduleDialog({
    super.key,
    required this.title,
    required this.startDate,
    required this.id,
    required this.description,
    required this.onSubmit,
    required this.remark
  });

  final String title;
  final String startDate;
  final String description;
  final String remark;
  final int id;
  final void Function(DateTime? rescheduleDate, String remarks, int id)
  onSubmit;

  final Rx<DateTime?> _rescheduleDate = Rx<DateTime?>(null);
  late TextEditingController _remarksCtrl;
  final eventdisplayController = Get.find<EventDisplayController>();
  @override
  Widget build(BuildContext context) {
    _remarksCtrl=  TextEditingController(text: remark);
    final amber = const Color(0xFFB8781B);
    final green = const Color(0xFF3E6A2A);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Event Reschedule',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: green,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title row
            const Text(
              'Title',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Start date row
            const Text(
              'Start Date',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(startDate, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // Reschedule date
            const Text(
              'Reschedule Date',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Obx(
              () => InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _rescheduleDate.value ?? now,
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
                  if (picked != null) {
                    _rescheduleDate.value = picked;
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _rescheduleDate.value == null
                          ? ''
                          : _formatDate(_rescheduleDate.value!),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Container(height: 1, color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Remarks
            const Text(
              'Remarks',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _remarksCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                isDense: true,
                border: UnderlineInputBorder(),
              ),
            ),

            // const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: AgButton(
                    title: 'Dismiss',
                    onTap: () => Get.back(),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AgButton(
                    title: 'Submit',
                    onTap: () {
                      onSubmit(
                        _rescheduleDate.value,
                        _remarksCtrl.text.trim(),
                        id,
                      );
                      Get.back();
                      eventdisplayController.onInit();
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

  String _formatDate(DateTime d) {
    // simple dd/MM/yyyy
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }
}
