import 'package:flutter/material.dart';
import 'package:citizenone_app/core/l10n/domain/repositories/locale_repository.dart';

/// Returns the persisted [Locale] preference, or null if none is saved.
/// Single-responsibility: only knows "how to retrieve" — not how to store.
class GetSavedLocaleUseCase {
  final LocaleRepository _repository;

  const GetSavedLocaleUseCase(this._repository);

  Future<Locale?> call() => _repository.getLocale();
}
