import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/ag_colors.dart';

void agSnackbar({
  required String title,
  required String msg,
  backgroundColor = AgColors.colorPrimary,
}) {
  Get.snackbar(
    title,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor,
    colorText: AgColors.kWhite,
    margin: const EdgeInsets.all(12),
    borderRadius: 12,
    icon: const Icon(Icons.error_outline, color: AgColors.kWhite),
    duration: const Duration(seconds: 3),
  );
}
