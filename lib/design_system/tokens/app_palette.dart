import 'package:flutter/material.dart';

/// Single-color palette tokens for CitizenOne Application.
/// Defines a single, unified color definition for each role (Primary, Secondary, Dark Mode, and Semantic colors).
abstract class AppPalette {
  // Prevent instantiation
  AppPalette._();

  // ===========================================================================
  // BRAND COLORS (Single Color Definition for Each)
  // ===========================================================================
  static const Color primary = Color(0xFF7C3AED);        // Single Purple Primary
  static const Color primaryDark = Color(0xFF7C3AED);    // Single Purple Primary for Dark Mode
  static const Color secondary = Color(0xFF64748B);      // Single Matching Purple Secondary
  static const Color secondaryDark = Color(0xFF64748B);  // Single Matching Purple Secondary for Dark Mode

  // ===========================================================================
  // SEMANTIC & STATUS COLORS (Single Color for Each)
  // ===========================================================================
  static const Color success = Color(0xFF16A34A);  // Success Green
  static const Color warning = Color(0xFFF59E0B);  // Warning Amber
  static const Color danger = Color(0xFFDC2626);   // Danger / Error Red
  static const Color info = Color(0xFF0EA5E9);     // Info Blue

  // ===========================================================================
  // NEUTRALS & SURFACES (Slate & Cool Greys)
  // ===========================================================================
  static const Color bgMain = Color(0xFFF8FAFC);
  static const Color bgDarkMain = Color(0xFF0F172A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Cool Neutral Scale (Shared across themes)
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);

  // ===========================================================================
  // MODULE-SPECIFIC BRAND ACCENTS (Single Color Definition for Each)
  // ===========================================================================
  static const Color citizenOne = Color(0xFF7C3AED);    // Core App Deep Indigo
  static const Color agencyBanking = Color(0xFF0D9488); // Agency Banking Teal
  static const Color kyc = Color(0xFF2563EB);           // KYC Verification Cobalt Blue
  static const Color loans = Color(0xFFD97706);         // Micro Loans Warm Amber
  static const Color insurance = Color(0xFF059669);     // Insurance Emerald
}
