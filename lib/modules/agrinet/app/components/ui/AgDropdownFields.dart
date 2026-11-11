import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../theme/ag_text_styles.dart';
import '../../utils/ag_colors.dart';

class AgDropdownField<T> extends StatelessWidget {
  final String name;
  final String label;
  final List<T> items;
  final T? value;
  final String Function(T)? itemLabel;
  final void Function(T?)? onChanged;
  final String? hintText;
  final bool isRequired;
  final bool enabled;

  const AgDropdownField({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    required this.value,
    this.itemLabel,
    this.onChanged,
    this.hintText,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown<T>(
      name: name,
      enabled: enabled,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: hintText ?? "Select $label",
      ),
      items: items.map((item) {
        final labelText =
        itemLabel != null ? itemLabel!(item) : item.toString();

        return DropdownMenuItem<T>(
          value: item,
          child: Text(labelText),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

