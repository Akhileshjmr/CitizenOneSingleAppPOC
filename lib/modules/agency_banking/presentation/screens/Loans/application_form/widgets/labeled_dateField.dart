import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'labeled_textField.dart';

class LabeledDateField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool isMandatory;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  const LabeledDateField({
    Key? key,
    required this.label,
    required this.controller,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.isMandatory = false,
    this.validator,
    this.enabled = true
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      label: label,
      hint: hint ?? "Select $label",
      controller: controller,
      readOnly: true,
      // onTap: () => _pickDate(context),
      onTap: enabled ? () => _pickDate(context) : null,
      suffixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
      isMandatory: true,
      validator: validator,
    );
  }
}