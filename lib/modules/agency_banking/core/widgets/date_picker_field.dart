import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/ag_textfield.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
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

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final TextEditingController _controller;

  String _fmt(DateTime? d) => d != null ? "${d.day}/${d.month}/${d.year}" : "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _fmt(widget.selectedDate));
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _controller.text = _fmt(widget.selectedDate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      selectableDayPredicate: widget.selectableDayPredicate,
    );

    if (pickedDate != null) {
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
        child: AppTextField(
          name: widget.label,
          controller: _controller,
          hintText: widget.label,
          hintStyle: const TextStyle(color: Colors.grey),
          inputTextStyle: const TextStyle(color: AppColors.black),
          suffixIcon: const Icon(
            Icons.calendar_month,
            color: AppColors.black,
          ),
          filled: true,
          isEnabled: false,
          fillColor: AppColors.white,
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
