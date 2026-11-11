import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

Future<DateTime?> showAgCalendar({
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  DatePickerMode initialMode = DatePickerMode.year,
}) {
  return Get.dialog<DateTime>(
    Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: AppColors.primary,
      ),
      child: DatePickerDialog(
        initialDate: initialDate ?? DateTime.now(),
        firstDate: firstDate ?? DateTime(1960),
        lastDate: lastDate ?? DateTime.now(),
        initialCalendarMode: initialMode,
      ),
    ),
  );
}
