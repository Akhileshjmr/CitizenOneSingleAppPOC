import 'package:flutter/material.dart';

/// Abstract contract for persisting and reading the user's locale preference.
/// Follows DIP: high-level modules (Presentation/Domain) depend on this
/// abstraction, not on a concrete implementation.
abstract class LocaleRepository {
  /// Returns the persisted locale, or null if none has been saved.
  Future<Locale?> getLocale();

  /// Persists [locale] for use across app restarts.
  Future<void> saveLocale(Locale locale);

  /// Resets the persisted locale to the system default.
  Future<void> clearLocale();
}
