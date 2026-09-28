import 'package:flutter/material.dart';

/// Raw Color Palette derived from Project Color Guidelines (Color Guide V2 & Frame 6-2).
/// Defines full 50-950 shade steps for Brand, Neutral, and Semantic colors.
abstract class AppPalette {
  // Prevent instantiation
  AppPalette._();

  // ===========================================================================
  // BRAND PRIMARY (Purple Palette)
  // ===========================================================================
  static const Color primary50  = Color(0xFFF5F3FF);
  static const Color primary100 = Color(0xFFEDE9FE);
  static const Color primary200 = Color(0xFFDDD6FE);
  static const Color primary300 = Color(0xFFC4B5FD);
  static const Color primary400 = Color(0xFFA78BFA);
  static const Color primary500 = Color(0xFF8B5CF6);
  static const Color primary600 = Color(0xFF7C3AED); // Main Primary Brand Color
  static const Color primary700 = Color(0xFF6D28D9); // Active / Hover Primary
  static const Color primary800 = Color(0xFF5B21B6);
  static const Color primary900 = Color(0xFF4C1D95);
  static const Color primary950 = Color(0xFF2E1065);

  // ===========================================================================
  // BRAND SECONDARY (Slate / Charcoal Palette)
  // ===========================================================================
  static const Color secondary50  = Color(0xFFF8FAFC);
  static const Color secondary100 = Color(0xFFF1F5F9);
  static const Color secondary200 = Color(0xFFE2E8F0);
  static const Color secondary300 = Color(0xFFCBD5E1);
  static const Color secondary400 = Color(0xFF94A3B8);
  static const Color secondary500 = Color(0xFF64748B);
  static const Color secondary600 = Color(0xFF475569);
  static const Color secondary700 = Color(0xFF334155);
  static const Color secondary800 = Color(0xFF1E293B);
  static const Color secondary900 = Color(0xFF0F172A);
  static const Color secondary950 = Color(0xFF020617);

  // ===========================================================================
  // NEUTRAL (Grey / Slate Tone Matrix)
  // ===========================================================================
  static const Color neutral50  = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);
  static const Color neutral950 = Color(0xFF020617);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color black      = Color(0xFF000000);

  // ===========================================================================
  // SEMANTIC - SUCCESS (Green Palette)
  // ===========================================================================
  static const Color success50  = Color(0xFFF0FDF4);
  static const Color success100 = Color(0xFFDCFCE7);
  static const Color success200 = Color(0xFFBBF7D0);
  static const Color success300 = Color(0xFF86EFAC);
  static const Color success400 = Color(0xFF4ADE80);
  static const Color success500 = Color(0xFF22C55E);
  static const Color success600 = Color(0xFF16A34A); // Main Success Color
  static const Color success700 = Color(0xFF15803D);
  static const Color success800 = Color(0xFF166534);
  static const Color success900 = Color(0xFF14532D);
  static const Color success950 = Color(0xFF052E16);

  // ===========================================================================
  // SEMANTIC - WARNING (Amber / Yellow Palette)
  // ===========================================================================
  static const Color warning50  = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning300 = Color(0xFFFCD34D);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFF59E0B); // Main Warning Color
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning900 = Color(0xFF78350F);
  static const Color warning950 = Color(0xFF451A03);

  // ===========================================================================
  // SEMANTIC - DANGER / ERROR (Red Palette)
  // ===========================================================================
  static const Color danger50  = Color(0xFFFEF2F2);
  static const Color danger100 = Color(0xFFFEE2E2);
  static const Color danger200 = Color(0xFFFECACA);
  static const Color danger300 = Color(0xFFFCA5A5);
  static const Color danger400 = Color(0xFFF87171);
  static const Color danger500 = Color(0xFFEF4444);
  static const Color danger600 = Color(0xFFDC2626); // Main Danger Color
  static const Color danger700 = Color(0xFFB91C1C);
  static const Color danger800 = Color(0xFF991B1B);
  static const Color danger900 = Color(0xFF7F1D1D);
  static const Color danger950 = Color(0xFF450A0A);

  // ===========================================================================
  // SEMANTIC - INFO (Sky / Blue Palette)
  // ===========================================================================
  static const Color info50  = Color(0xFFF0F9FF);
  static const Color info100 = Color(0xFFE0F2FE);
  static const Color info200 = Color(0xFFBAE6FD);
  static const Color info300 = Color(0xFF7DD3FC);
  static const Color info400 = Color(0xFF38BDF8);
  static const Color info500 = Color(0xFF0EA5E9); // Main Info Color
  static const Color info600 = Color(0xFF0284C7);
  static const Color info700 = Color(0xFF0369A1);
  static const Color info800 = Color(0xFF075985);
  static const Color info900 = Color(0xFF0C4A6E);
  static const Color info950 = Color(0xFF082F49);
}
