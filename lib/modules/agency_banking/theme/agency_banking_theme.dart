import 'package:flutter/material.dart';
import 'agency_banking_colors.dart';

class AgencyBankingTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AgencyBankingColors.primary,
        primary: AgencyBankingColors.primary,
        secondary: AgencyBankingColors.secondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AgencyBankingColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
