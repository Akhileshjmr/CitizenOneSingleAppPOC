import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_store.dart';

class ThemeProvider {
  static ThemeMode _themeMode = ThemeMode.system;

  /// Get current theme mode
  static ThemeMode get themeMode => _themeMode;

  /// Set theme mode
  static Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    Get.changeThemeMode(mode);

    /// Store selected theme index safely
    LocalStore.theme(mode.index);
  }

  /// Load theme from storage
  static Future<void> loadThemeFromStore() async {
    final storedIndex = LocalStore.theme() ?? 0;

    /// Safe bounds check
    if (storedIndex >= 0 && storedIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[storedIndex];
    } else {
      _themeMode = ThemeMode.system;
    }

    Get.changeThemeMode(_themeMode);
  }

  /// Check if dark mode is active
  static bool get isDarkModeOn {
    if (_themeMode == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode == ThemeMode.dark;
  }
}
