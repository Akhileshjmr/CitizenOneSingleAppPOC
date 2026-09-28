import 'package:flutter/material.dart';

/// UX4G Design System Typography for CitizenOne Application.
/// Derived strictly from Typography.png guidelines (Display 1-6, Headline 1-6, Title 1-3, Label 1-3, Body 1-3).
abstract class AppTypography {
  // Prevent instantiation
  AppTypography._();

  /// Default font family for UX4G Design System
  static const String fontFamily = 'NotoSans';

  // ===========================================================================
  // DISPLAY STYLES (Display 1 - 6)
  // ===========================================================================

  /// Display 1: Size 80 | Line Height 100 | Weight Medium (w500) | Spacing 0
  static const TextStyle display1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 80.0,
    fontWeight: FontWeight.w500,
    height: 100.0 / 80.0,
    letterSpacing: 0.0,
  );

  /// Display 2: Size 72 | Line Height 88 | Weight Medium (w500) | Spacing 0
  static const TextStyle display2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 72.0,
    fontWeight: FontWeight.w500,
    height: 88.0 / 72.0,
    letterSpacing: 0.0,
  );

  /// Display 3: Size 64 | Line Height 80 | Weight Regular (w400) | Spacing 0
  static const TextStyle display3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 64.0,
    fontWeight: FontWeight.w400,
    height: 80.0 / 64.0,
    letterSpacing: 0.0,
  );

  /// Display 4: Size 56 | Line Height 72 | Weight Medium (w500) | Spacing 0
  static const TextStyle display4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56.0,
    fontWeight: FontWeight.w500,
    height: 72.0 / 56.0,
    letterSpacing: 0.0,
  );

  /// Display 5: Size 48 | Line Height 56 | Weight Medium (w500) | Spacing 0
  static const TextStyle display5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48.0,
    fontWeight: FontWeight.w500,
    height: 56.0 / 48.0,
    letterSpacing: 0.0,
  );

  /// Display 6: Size 40 | Line Height 48 | Weight Medium (w500) | Spacing 0
  static const TextStyle display6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40.0,
    fontWeight: FontWeight.w500,
    height: 48.0 / 40.0,
    letterSpacing: 0.0,
  );

  // ===========================================================================
  // HEADLINE STYLES (Headline 1 - 6)
  // ===========================================================================

  /// Headline 1: Size 40 | Line Height 48 | Weight Medium (w500) | Spacing 0
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40.0,
    fontWeight: FontWeight.w500,
    height: 48.0 / 40.0,
    letterSpacing: 0.0,
  );

  /// Headline 2: Size 32 | Line Height 40 | Weight Medium (w500) | Spacing 0
  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.0,
    fontWeight: FontWeight.w500,
    height: 40.0 / 32.0,
    letterSpacing: 0.0,
  );

  /// Headline 3: Size 28 | Line Height 32 | Weight Medium (w500) | Spacing 0
  static const TextStyle headline3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w500,
    height: 32.0 / 28.0,
    letterSpacing: 0.0,
  );

  /// Headline 4: Size 24 | Line Height 28 | Weight Medium (w500) | Spacing 0
  static const TextStyle headline4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    height: 28.0 / 24.0,
    letterSpacing: 0.0,
  );

  /// Headline 5: Size 20 | Line Height 24 | Weight Medium (w500) | Spacing 0
  static const TextStyle headline5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    height: 24.0 / 20.0,
    letterSpacing: 0.0,
  );

  /// Headline 6: Size 16 | Line Height 20 | Weight Medium (w500) | Spacing 0
  static const TextStyle headline6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 20.0 / 16.0,
    letterSpacing: 0.0,
  );

  // ===========================================================================
  // TITLE STYLES (Title 1 - 3)
  // ===========================================================================

  /// Title 1: Size 22 | Line Height 28 | Weight Medium (w500) | Spacing 0
  static const TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    height: 28.0 / 22.0,
    letterSpacing: 0.0,
  );

  /// Title 2: Size 16 | Line Height 24 | Weight Medium (w500) | Spacing +0.15
  static const TextStyle title2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 24.0 / 16.0,
    letterSpacing: 0.15,
  );

  /// Title 3: Size 14 | Line Height 20 | Weight Medium (w500) | Spacing +0.1
  static const TextStyle title3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
  );

  // ===========================================================================
  // LABEL STYLES (Label 1 - 3)
  // ===========================================================================

  /// Label 1: Size 14 | Line Height 20 | Weight Medium (w500) | Spacing +0.1
  static const TextStyle label1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
  );

  /// Label 2: Size 12 | Line Height 16 | Weight Medium (w500) | Spacing +0.5
  static const TextStyle label2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 16.0 / 12.0,
    letterSpacing: 0.5,
  );

  /// Label 3: Size 11 | Line Height 16 | Weight Medium (w500) | Spacing +0.5
  static const TextStyle label3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    height: 16.0 / 11.0,
    letterSpacing: 0.5,
  );

  // ===========================================================================
  // BODY STYLES (Body 1 - 3)
  // ===========================================================================

  /// Body 1: Size 16 | Line Height 24 | Weight Regular (w400) | Spacing +0.5
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 24.0 / 16.0,
    letterSpacing: 0.5,
  );

  /// Body 2: Size 14 | Line Height 20 | Weight Regular (w400) | Spacing +0.25
  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 20.0 / 14.0,
    letterSpacing: 0.25,
  );

  /// Body 3: Size 12 | Line Height 16 | Weight Regular (w400) | Spacing +0.4
  static const TextStyle body3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 16.0 / 12.0,
    letterSpacing: 0.4,
  );

  // ===========================================================================
  // BACKWARD COMPATIBILITY & CONVENIENCE ALIASES
  // ===========================================================================
  static const TextStyle display = display6;
  static const TextStyle title = headline5;
  static const TextStyle subtitle = title2;
  static const TextStyle body = body2;
  static const TextStyle caption = body3;

  static const TextStyle displayLarge = display1;
  static const TextStyle displayMedium = display2;
  static const TextStyle displaySmall = display3;

  static const TextStyle h1 = headline4;
  static const TextStyle h2 = headline5;
  static const TextStyle h3 = headline6;
  static const TextStyle h4 = title2;

  static const TextStyle bodyLarge = body1;
  static const TextStyle bodyMedium = body2;
  static const TextStyle bodySmall = body3;

  static const TextStyle buttonLarge = label1;
  static const TextStyle buttonMedium = label2;
  static const TextStyle buttonSmall = label3;

  static const TextStyle overline = label3;

  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
    decoration: TextDecoration.underline,
  );
}
