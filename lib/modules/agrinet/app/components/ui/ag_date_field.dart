import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'agShowDatePicker.dart';
import 'ag_textfield.dart';

class AgDateField extends StatelessWidget {
  final String name;
  final String label;
  final Rxn<DateTime> rxDate;
  final String format;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final void Function(DateTime date)? onSelect;

  const AgDateField({
    super.key,
    required this.name,
    required this.label,
    required this.rxDate,
    this.format = "dd-MM-yyyy",
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = TextEditingController(
        text:
            rxDate.value != null
                ? DateFormat(format).format(rxDate.value!)
                : "",
      );

      return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();

          final DateTime intlDate =
              rxDate.value ?? initialDate ?? DateTime.now();

          DateTime? selected = await ShowDatePickerHelper().pickDate(
            initialDate: intlDate,
            firstDate: firstDate ?? DateTime(1900),
            lastDate: lastDate ?? DateTime(2125),
          );

          if (selected != null) {
            rxDate.value = selected;

            // Trigger callback
            if (onSelect != null) {
              onSelect!(selected);
            }
          }
        },
        child: AbsorbPointer(
          absorbing: true,
          child: AgTextField(
            name: name,
            label: label,
            controller: controller,
            isEnabled: true,
            readyOnly: true,
            suffixIcon: const Icon(Icons.calendar_month),
          ),
        ),
      );
    });
  }
}
