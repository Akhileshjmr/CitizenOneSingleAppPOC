import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';


class LabeledDropdownSearch<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isMandatory;
  final String Function(T)? display;
  final FormFieldValidator<T>? validator;
  final bool enabled;

  const LabeledDropdownSearch({
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
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
                  : [],
            ),
          ),
          const SizedBox(height: 6),
          DropdownSearch<T>(
            items: items,
            selectedItem: value,
            enabled: enabled,
            validator: validator,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: "Select $label",
                filled: true,
                fillColor: AppColors.white, // input box background white
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              menuProps: const MenuProps(
                backgroundColor: Colors.white, // 🔥 dropdown list white
              ),
              searchFieldProps: const TextFieldProps(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Search...",
                  filled: true,
                  fillColor: Colors.white, // 🔥 search box white
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            itemAsString: (T? item) =>
            item == null ? '' : (display != null ? display!(item) : item.toString()),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}