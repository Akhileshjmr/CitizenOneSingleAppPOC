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
    this.hasBorder = true,
    this.hasUnderLineBorder = false,
    super.key,
  });

  final String name;

  final String? hintText;

  final String? labelText;

  final Color? borderColor;

  final bool hasUnderLineBorder;
  final bool hasBorder;

  // final Color borderColor;

  final double borderRadius;

  final TextStyle? labelStyle;

  final FormFieldValidator<T>? validator;

  final T? initialValue;

  final void Function(T?)? onChanged;

  final List<DropdownMenuItem<T>> items;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (labelText != null) ...<Widget>[
            labelText!.contains('*')
                ? RichText(
                    text: TextSpan(
                      style: labelStyle ?? kw400Black14,
                      children: [
                        TextSpan(text: labelText!.replaceAll('*', '')),
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  )
                : Text(labelText!, style: labelStyle ?? kw400Black14),
            4.verticalSpace,
          ],
          FormBuilderDropdown<T>(
            icon: const Icon(Icons.keyboard_arrow_down_rounded),

            decoration: InputDecoration(
                // labelText: labelText,
                hintText: hintText,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                enabledBorder: _buildOutlineInputBorder(),
                focusedBorder: _buildOutlineInputBorder(),
                fillColor: Colors.white,
                filled: true),
            name: name,
            validator: validator,
            items: items,
            initialValue: initialValue,
            onChanged: onChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            dropdownColor: Colors.white,

            // onChanged: onChanged,
          ),
        ],
      );
  InputBorder _buildOutlineInputBorder() => !hasBorder
      ? UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius.r),
        )
      : hasUnderLineBorder
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.kC6C6C6,
                width: 2.h,
              ),
            )
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              borderSide: BorderSide(color: borderColor ?? AppColors.kC6C6C6),
            );
}
