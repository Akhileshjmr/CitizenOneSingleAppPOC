
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;

  const DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      selectableDayPredicate: selectableDayPredicate,
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
        child: AppTextField(
          controller: TextEditingController(
            text: selectedDate != null
                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                : "",
          ),
          hintText: label,
          suffixIcon: const Icon(
            Icons.calendar_month,
            color: AppColors.black,
          ),
          enabled: false,
          fillColor: AppColors.surface,
        ),
      ),
    );
  }
}

bool isValidExpiry(DateTime? issueDate, DateTime date) {
  final today = DateTime.now();

  final current = DateTime(today.year, today.month, today.day);
  final selected = DateTime(date.year, date.month, date.day);

  if (selected.isBefore(current)) return false;

  if (issueDate != null) {
    final issue = DateTime(issueDate.year, issueDate.month, issueDate.day);
    if (selected.isBefore(issue)) return false;
  }

  return true;
}
