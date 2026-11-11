import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

class AppDropDown<T> extends StatelessWidget {
  const AppDropDown({
    required this.name,
    required this.items,
    this.hintText,
    this.labelText,
    this.borderRadius = 6,
    this.labelStyle,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.borderColor,
    Key? key,
  }) : super(key: key);

  /// Name
  final String name;

  /// Hint Text
  final String? hintText;

  /// Label Text
  final String? labelText;

  /// Border color
  final Color? borderColor;

  /// Border radius
  final double borderRadius;

  /// Label style
  final TextStyle? labelStyle;

  /// Validator
  final FormFieldValidator<T>? validator;

  /// Initial value
  final T? initialValue;

  /// On change callback
  final void Function(T?)? onChanged;

  /// Dropdown items
  final List<DropdownMenuItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// Label
        if (labelText != null) ...[
          labelText!.contains('*')
              ? RichText(
                text: TextSpan(
                  style: labelStyle ?? kw500Black14,
                  children: [
                    TextSpan(text: labelText!.replaceAll('*', '')),
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
              : Text(labelText!, style: labelStyle ?? kw500Black14),
          4.verticalSpace,
        ],

        /// Dropdown
        FormBuilderDropdown<T>(
          name: name,
          items: items,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          isExpanded: true,

          decoration: InputDecoration(
            hintText: hintText,

            isDense: true,
            contentPadding: const EdgeInsets.all(12),

            filled: true,
            fillColor: Colors.white,

            enabledBorder: _border(),
            focusedBorder: _border(isFocused: true),
            border: _border(),
            errorBorder: _border(),
            focusedErrorBorder: _border(isFocused: true),
          ),
        ),
      ],
    );
  }

  /// Common border (matches AppTextField)
  InputBorder _border({bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius.r),
      borderSide: BorderSide(
        color: borderColor ?? AppColors.kC6C6C6,
        width: isFocused ? 1.5 : 1.2,
      ),
    );
  }
}
