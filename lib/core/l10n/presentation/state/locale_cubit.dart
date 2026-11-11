import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/core/l10n/domain/usecases/get_saved_locale_usecase.dart';
import 'package:citizenone_app/core/l10n/domain/usecases/save_locale_usecase.dart';
import 'package:citizenone_app/core/l10n/presentation/state/locale_state.dart';

/// Governs the active [Locale] for the entire application.
///
/// Responsibilities (SRP):
/// - Hydrate locale from persistence on bootstrap.
/// - Emit new [LocaleState] when the user selects a different language.
/// - Delegate persistence to [SaveLocaleUseCase] — not to SharedPreferences directly.
///
/// Rule (DIP): depends on use-case abstractions, not data-layer classes.
class LocaleCubit extends Cubit<LocaleState> {
  final GetSavedLocaleUseCase _getSavedLocaleUseCase;
  final SaveLocaleUseCase _saveLocaleUseCase;

  LocaleCubit({
    required GetSavedLocaleUseCase getSavedLocaleUseCase,
    required SaveLocaleUseCase saveLocaleUseCase,
  })  : _getSavedLocaleUseCase = getSavedLocaleUseCase,
        _saveLocaleUseCase = saveLocaleUseCase,
        super(const LocaleState());

  /// Hydrate the saved locale at app startup.
  /// Called once in bootstrap — before [runApp].
  Future<void> hydrate() async {
    final savedLocale = await _getSavedLocaleUseCase();
    if (savedLocale != null) {
      final appLocale = AppLocale.fromLocale(savedLocale);
      emit(state.copyWith(appLocale: appLocale));
    }
  }

  /// Change the active locale and persist the preference.
  Future<void> setLocale(AppLocale appLocale) async {
    if (state.appLocale == appLocale) return; // No-op guard
    await _saveLocaleUseCase(appLocale.locale);
    emit(state.copyWith(appLocale: appLocale));
  }

  /// Reset to the system default (English) and clear persisted preference.
  void reset() => emit(const LocaleState());

  /// Convenience getter — list of all supported [AppLocale] entries.
  static List<AppLocale> get supportedAppLocales => AppLocale.values;

  /// Convenience getter — list of supported Flutter [Locale] objects for [MaterialApp].
  static List<Locale> get supportedLocales =>
      AppLocale.values.map((l) => l.locale).toList();
}
