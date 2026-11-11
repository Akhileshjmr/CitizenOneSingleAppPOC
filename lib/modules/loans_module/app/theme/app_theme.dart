import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.kffffff,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.kffffff,
      surface: AppColors.kffffff,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.kffffff,
        fontFamily: 'Inter',
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textLight),
      bodyMedium: TextStyle(color: AppColors.textLight),
      bodySmall: TextStyle(color: AppColors.textLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: AppColors.kffffff,
        iconColor: AppColors.primary,
        textStyle: TextStyle(
          color: AppColors.kffffff,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.bgDark,
    // colorScheme: ColorScheme.light(
    //   primary: AppColors.primary,
    //   secondary: AppColors.white,
    //   surface: AppColors.bgDark,
    // ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.primaryDark,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.kffffff,
        fontFamily: 'Inter',
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDark),
      bodyMedium: TextStyle(color: AppColors.textDark),
      bodySmall: TextStyle(color: AppColors.textDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.kffffff,
        iconColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: TextStyle(
          color: AppColors.kffffff,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
  );
}
