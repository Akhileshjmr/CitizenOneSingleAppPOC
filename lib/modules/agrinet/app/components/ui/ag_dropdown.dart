import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../theme/ag_text_styles.dart';
import '../../utils/ag_colors.dart';

class AgDropdownField extends StatelessWidget {
  final String name;
  final String label;
  final List<String> items;
  final String? value;
  final Function(String?)? onChanged;
  final String? hintText;
  final bool isRequired;
  final bool enabled;

  const AgDropdownField({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    required this.value,
    this.onChanged,
    this.hintText,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderDropdown<String>(
          name: name,
          enabled: enabled,
          initialValue: (value != null && items.contains(value)) ? value : null,

          hint: Text(hintText ?? "Select $label", style: kw400Secondary14),

          decoration: InputDecoration(
            labelText: label,
            labelStyle: kw400Primary14,
            floatingLabelStyle: kw400Primary14,

            hintText: hintText ?? "Select $label",
            hintStyle: kw400Primary14,

            floatingLabelBehavior: FloatingLabelBehavior.auto,

            isDense: true,

            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AgColors.colorPrimaryDark,
                width: 1.2,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AgColors.colorPrimaryDark,
                width: 1.8,
              ),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AgColors.colorPrimaryDark,
                width: 1.2,
              ),
            ),
          ),

          icon: const Icon(Icons.arrow_drop_down, color: AgColors.kPrimaryText),

          items:
              items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item, style: kw400Primary14),
                    ),
                  )
                  .toList(),

          onChanged: onChanged,
        ),

        if (isRequired)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text("Required", style: kw400Primary14),
          ),
      ],
    );
  }
}
