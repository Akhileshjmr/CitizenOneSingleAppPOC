import 'package:flutter/material.dart';
import 'package:citizenone_app/core/l10n/domain/repositories/locale_repository.dart';

/// Persists the user-selected [Locale] for use across app restarts.
/// Single-responsibility: only handles "how to save" — not read or clear.
class SaveLocaleUseCase {
  final LocaleRepository _repository;

  const SaveLocaleUseCase(this._repository);

  Future<void> call(Locale locale) => _repository.saveLocale(locale);
}
