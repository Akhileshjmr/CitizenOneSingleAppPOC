import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/colors/Appcolors.dart';

class Dropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final String? Function(T?)? validator;

  const Dropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        // ✅ Hint style
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: 14,
        ),

        filled: true,
        fillColor: Colors.white,

        contentPadding: EdgeInsets.symmetric(
          vertical: 13.h,
          horizontal: 16.w,
        ),

        // ✅ Same borders as InputTextFormField
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide:const BorderSide(
            color: Color(0xFFC6C6C6),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
          borderSide: const BorderSide(
            color: Color(0xFFC6C6C6),
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
      ),
      hint: Text(hintText ?? ''),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
