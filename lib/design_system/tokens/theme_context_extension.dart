import 'package:flutter/material.dart';
import 'app_color_tokens.dart';
import '../theme/app_theme.dart';

/// Extension on BuildContext for quick, ergonomic access to Theme Tokens.
extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get typography => Theme.of(this).textTheme;

  /// Access semantic color tokens via BuildContext context.tokens
  AppColorTokens get tokens =>
      Theme.of(this).extension<AppColorTokens>() ?? AppTheme.lightColorTokens;
}
