import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDatePickerHelper {
  Future<DateTime?> pickDate({
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2125),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AgColors.colorPrimary,
              onPrimary: AgColors.kffffff,
              onSurface: AgColors.k000000,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AgColors.colorPrimary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
