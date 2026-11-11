import 'package:flutter/material.dart';

export 'tokens/typography.dart';

@immutable
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final TextStyle body;

  const AppTextTheme({
    this.body = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
  });

  @override
  AppTextTheme copyWith({TextStyle? body}) {
    return AppTextTheme(body: body ?? this.body);
  }

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      body: TextStyle.lerp(body, other.body, t) ?? body,
    );
  }
}
