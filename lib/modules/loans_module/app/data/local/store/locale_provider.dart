import 'dart:ui';

import 'package:get/get.dart';

import 'local_store.dart';

class LocaleProvider {
  static const Locale _fallbackLocale = Locale('en', 'US');

  static Locale _currentLocale = _fallbackLocale;

  /// Get current locale
  static Locale get currentLocale => _currentLocale;

  /// Load saved locale
  static void loadCurrentLocale() {
    final saved = LocalStore.currentLocale();

    if (saved == null || saved.isEmpty) {
      _currentLocale = _fallbackLocale;
    } else {
      _currentLocale = _parseLocale(saved);
    }

    Get.updateLocale(_currentLocale);
  }

  /// Change app language
  static Future<void> changeLocale(Locale locale) async {
    _currentLocale = locale;

    final localeCode =
        locale.countryCode != null
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;

    LocalStore.currentLocale(localeCode);

    await Get.updateLocale(locale);
  }

  /// Parse locale string like: en or en_US
  static Locale _parseLocale(String code) {
    final parts = code.split('_');

    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }

    return Locale(parts.first);
  }
}
