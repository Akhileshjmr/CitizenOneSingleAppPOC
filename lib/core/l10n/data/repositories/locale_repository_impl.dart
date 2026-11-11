import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citizenone_app/core/l10n/domain/repositories/locale_repository.dart';

/// Concrete implementation of [LocaleRepository] backed by [SharedPreferences].
/// Lives in the Data layer — knows HOW to persist, but exposes the Domain abstraction.
class LocaleRepositoryImpl implements LocaleRepository {
  static const _key = 'citizenone_locale_language_code';

  final SharedPreferences _prefs;

  const LocaleRepositoryImpl(this._prefs);

  @override
  Future<Locale?> getLocale() async {
    final languageCode = _prefs.getString(_key);
    if (languageCode == null) return null;
    return Locale(languageCode);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_key, locale.languageCode);
  }

  @override
  Future<void> clearLocale() async {
    await _prefs.remove(_key);
  }
}
