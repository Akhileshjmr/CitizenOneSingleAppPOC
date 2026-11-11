import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/tokens/app_palette.dart';

class CommonColors {
  static const Color primary = AppPalette.primary;
  static const Color secondary = AppPalette.secondary;
  static const Color accent = AppPalette.secondaryDark;
}

@Deprecated('Use CommonColors instead')
typedef CitizenOneColors = CommonColors;
