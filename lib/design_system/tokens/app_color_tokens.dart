import 'package:flutter/material.dart';

/// Comprehensive Semantic Design Tokens for CitizenOne Application.
/// Extends [ThemeExtension] to provide full light & dark theme token resolution.
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  // Brand Tokens
  final Color brandPrimary;
  final Color brandPrimaryHover;
  final Color brandPrimaryActive;
  final Color brandPrimaryContainer;

  final Color brandSecondary;
  final Color brandSecondaryHover;
  final Color brandSecondaryActive;
  final Color brandSecondaryContainer;

  // Status & Semantic Tokens
  final Color statusSuccess;
  final Color statusSuccessContainer;
  final Color statusWarning;
  final Color statusWarningContainer;
  final Color statusError;
  final Color statusDangerContainer;
  final Color statusInfo;
  final Color statusInfoContainer;

  // Background & Surface Tokens
  final Color bgMain;
  final Color bgCard;
  final Color bgInput;
  final Color bgModal;
  final Color bgDisabled;

  // Text Tokens
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;
  final Color textLink;

  // Border & Stroke Tokens
  final Color borderDefault;
  final Color borderOutline;
  final Color borderFocused;
  final Color borderSubtle;
  final Color divider;

  const AppColorTokens({
    required this.brandPrimary,
    required this.brandPrimaryHover,
    required this.brandPrimaryActive,
    required this.brandPrimaryContainer,
    required this.brandSecondary,
    required this.brandSecondaryHover,
    required this.brandSecondaryActive,
    required this.brandSecondaryContainer,
    required this.statusSuccess,
    required this.statusSuccessContainer,
    required this.statusWarning,
    required this.statusWarningContainer,
    required this.statusError,
    required this.statusDangerContainer,
    required this.statusInfo,
    required this.statusInfoContainer,
    required this.bgMain,
    required this.bgCard,
    required this.bgInput,
    required this.bgModal,
    required this.bgDisabled,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.textLink,
    required this.borderDefault,
    required this.borderOutline,
    required this.borderFocused,
    required this.borderSubtle,
    required this.divider,
  });

  /// Alias for backward compatibility
  Color get surfaceCard => bgCard;

  @override
  AppColorTokens copyWith({
    Color? brandPrimary,
    Color? brandPrimaryHover,
    Color? brandPrimaryActive,
    Color? brandPrimaryContainer,
    Color? brandSecondary,
    Color? brandSecondaryHover,
    Color? brandSecondaryActive,
    Color? brandSecondaryContainer,
    Color? statusSuccess,
    Color? statusSuccessContainer,
    Color? statusWarning,
    Color? statusWarningContainer,
    Color? statusError,
    Color? statusDangerContainer,
    Color? statusInfo,
    Color? statusInfoContainer,
    Color? bgMain,
    Color? bgCard,
    Color? bgInput,
    Color? bgModal,
    Color? bgDisabled,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textOnPrimary,
    Color? textLink,
    Color? borderDefault,
    Color? borderOutline,
    Color? borderFocused,
    Color? borderSubtle,
    Color? divider,
    Color? surfaceCard,
  }) {
    return AppColorTokens(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandPrimaryHover: brandPrimaryHover ?? this.brandPrimaryHover,
      brandPrimaryActive: brandPrimaryActive ?? this.brandPrimaryActive,
      brandPrimaryContainer: brandPrimaryContainer ?? this.brandPrimaryContainer,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandSecondaryHover: brandSecondaryHover ?? this.brandSecondaryHover,
      brandSecondaryActive: brandSecondaryActive ?? this.brandSecondaryActive,
      brandSecondaryContainer: brandSecondaryContainer ?? this.brandSecondaryContainer,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      statusSuccessContainer: statusSuccessContainer ?? this.statusSuccessContainer,
      statusWarning: statusWarning ?? this.statusWarning,
      statusWarningContainer: statusWarningContainer ?? this.statusWarningContainer,
      statusError: statusError ?? this.statusError,
      statusDangerContainer: statusDangerContainer ?? this.statusDangerContainer,
      statusInfo: statusInfo ?? this.statusInfo,
      statusInfoContainer: statusInfoContainer ?? this.statusInfoContainer,
      bgMain: bgMain ?? this.bgMain,
      bgCard: surfaceCard ?? bgCard ?? this.bgCard,
      bgInput: bgInput ?? this.bgInput,
      bgModal: bgModal ?? this.bgModal,
      bgDisabled: bgDisabled ?? this.bgDisabled,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textOnPrimary: textOnPrimary ?? this.textOnPrimary,
      textLink: textLink ?? this.textLink,
      borderDefault: borderDefault ?? this.borderDefault,
      borderOutline: borderOutline ?? this.borderOutline,
      borderFocused: borderFocused ?? this.borderFocused,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandPrimaryHover: Color.lerp(brandPrimaryHover, other.brandPrimaryHover, t)!,
      brandPrimaryActive: Color.lerp(brandPrimaryActive, other.brandPrimaryActive, t)!,
      brandPrimaryContainer: Color.lerp(brandPrimaryContainer, other.brandPrimaryContainer, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandSecondaryHover: Color.lerp(brandSecondaryHover, other.brandSecondaryHover, t)!,
      brandSecondaryActive: Color.lerp(brandSecondaryActive, other.brandSecondaryActive, t)!,
      brandSecondaryContainer: Color.lerp(brandSecondaryContainer, other.brandSecondaryContainer, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusSuccessContainer: Color.lerp(statusSuccessContainer, other.statusSuccessContainer, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusWarningContainer: Color.lerp(statusWarningContainer, other.statusWarningContainer, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusDangerContainer: Color.lerp(statusDangerContainer, other.statusDangerContainer, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      statusInfoContainer: Color.lerp(statusInfoContainer, other.statusInfoContainer, t)!,
      bgMain: Color.lerp(bgMain, other.bgMain, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
      bgInput: Color.lerp(bgInput, other.bgInput, t)!,
      bgModal: Color.lerp(bgModal, other.bgModal, t)!,
      bgDisabled: Color.lerp(bgDisabled, other.bgDisabled, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textOnPrimary: Color.lerp(textOnPrimary, other.textOnPrimary, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderOutline: Color.lerp(borderOutline, other.borderOutline, t)!,
      borderFocused: Color.lerp(borderFocused, other.borderFocused, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
