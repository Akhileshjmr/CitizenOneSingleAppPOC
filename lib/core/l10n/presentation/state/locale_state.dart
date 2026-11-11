import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents the supported locales in the application.
/// The enum doubles as the single source of truth for locale display metadata.
enum AppLocale {
  english(Locale('en'), 'English', 'English'),
  bemba(Locale('bem'), 'Bemba', 'iciBemba');

  final Locale locale;
  final String displayName;
  final String nativeName;

  const AppLocale(this.locale, this.displayName, this.nativeName);

  /// Resolve an [AppLocale] from a Flutter [Locale]. Falls back to [english].
  static AppLocale fromLocale(Locale locale) {
    return AppLocale.values.firstWhere(
      (l) => l.locale.languageCode == locale.languageCode,
      orElse: () => AppLocale.english,
    );
  }
}

/// Immutable state for [LocaleCubit].
final class LocaleState extends Equatable {
  final AppLocale appLocale;

  const LocaleState({this.appLocale = AppLocale.english});

  Locale get locale => appLocale.locale;

  LocaleState copyWith({AppLocale? appLocale}) =>
      LocaleState(appLocale: appLocale ?? this.appLocale);

  @override
  List<Object> get props => [appLocale];
}
