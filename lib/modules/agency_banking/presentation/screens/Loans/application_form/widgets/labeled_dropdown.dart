import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabeledDropdown<T> extends StatelessWidget {
  final String label;
  /// Can be either a list of plain values (e.g. List<String>)
  /// or a list of DropdownMenuItems<T>
  final dynamic items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isMandatory;
  /// Optional function to control how items are displayed
  final String Function(T)? display;
  final FormFieldValidator<T>? validator;
  final bool enabled;
  const LabeledDropdown({
    Key? key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.isMandatory = false,
    this.display,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Normalize items into DropdownMenuItem<T>
    List<DropdownMenuItem<T>> dropdownItems;

    if (items is List<DropdownMenuItem<T>>) {
      // Already proper DropdownMenuItems
      dropdownItems = items;
    } else if (items is List<T>) {
      // Convert plain values into DropdownMenuItems
      dropdownItems = (items as List<T>).map((e) {
        final text = display != null ? display!(e) : e.toString();
        return DropdownMenuItem<T>(
          value: e,
          child: Text(text),
        );
      }).toList();
    } else {
      throw ArgumentError(
        "items must be either List<T> or List<DropdownMenuItem<T>>",
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: isMandatory
                  ? const [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ]
                  : [],
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            value: value,
            items: dropdownItems,
            onChanged: enabled ? onChanged : null,
            dropdownColor: AppColors.white,
            validator: validator,
            decoration: InputDecoration(
              hintText: "Select $label",
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
