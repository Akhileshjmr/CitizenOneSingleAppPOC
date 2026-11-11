import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../data/model/common/option.dart';
import '../../theme/ag_text_styles.dart';
import '../../utils/ag_colors.dart';

class AgDropDownOption extends StatelessWidget {
  final String name;
  final String label;
  final List<Option> items;
  final Option? value;
  final Function(Option?)? onChanged;
  final String? hintText;
  final bool isRequired;
  final bool enabled;

  const AgDropDownOption({
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

          /// initialValue must match exactly one of the menu values
          initialValue: value?.id?.toString() ?? value?.type,

          decoration: InputDecoration(
            labelText: label,
            labelStyle: kw400Primary14,
            floatingLabelStyle: kw400Primary14,
            hintText: hintText ?? "Select $label",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                    (item) => DropdownMenuItem<String>(
                      /// Always use string value
                      value: item.id?.toString() ?? item.type,
                      child: Text(
                        item.friendlyType ?? "",
                        style: kw400Primary14,
                      ),
                    ),
                  )
                  .toList(),

          onChanged: (String? selectedValue) {
            if (onChanged == null) return;

            final selectedOption = items.firstWhereOrNull((e) {
              if (e.id != null) {
                return e.id.toString() == selectedValue;
              }
              return e.type == selectedValue;
            });

            onChanged!(selectedOption);
          },
        ),
      ],
    );
  }
}
