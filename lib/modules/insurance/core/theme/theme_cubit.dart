import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/tokens/dimensions.dart';

/// Theme state holds the current design tokens, adapted per role.
class ThemeState {
  final Color primaryColor;
  final Color accentColor;
  final double spacingMd;
  final double spacingLg;
  final double radiusMd;

  const ThemeState({
    this.primaryColor = AppColors.primary,
    this.accentColor = AppColors.accent,
    this.spacingMd = AppDimensions.paddingMd,
    this.spacingLg = AppDimensions.paddingLg,
    this.radiusMd = AppDimensions.radiusMd,
  });

  ThemeState copyWith({
    Color? primaryColor,
    Color? accentColor,
    double? spacingMd,
    double? spacingLg,
    double? radiusMd,
  }) {
    return ThemeState(
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      radiusMd: radiusMd ?? this.radiusMd,
    );
  }
}

/// ThemeCubit per SKILL.md Section 9 — governs ThemeTokens and role-based colors.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  /// Apply role-specific primary colors (e.g., Purple for Agent, Green for Farmer).
  void setRoleTheme(String role) {
    switch (role) {
      case 'agent':
        emit(state.copyWith(primaryColor: AppColors.roleAgent)); // Purple
        break;
      case 'farmer':
        emit(state.copyWith(primaryColor: AppColors.roleFarmer)); // Green
        break;
      default:
        emit(state.copyWith(primaryColor: AppColors.primary)); // Emerald Green / Blue
    }
  }

  /// Apply service-specific primary colors dynamically.
  void setServiceTheme(String serviceId) {
    Color serviceColor;
    switch (serviceId) {
      case 'wealth':
        serviceColor = AppColors.serviceWealth;
        break;
      case 'health':
        serviceColor = AppColors.serviceHealth;
        break;
      case 'sport':
        serviceColor = AppColors.serviceSport;
        break;
      case 'bills':
        serviceColor = AppColors.serviceBills;
        break;
      case 'insurance':
        serviceColor = AppColors.serviceInsurance;
        break;
      case 'gov':
        serviceColor = AppColors.serviceGovt;
        break;
      case 'common':
        serviceColor = AppColors.serviceCommon;
        break;
      case 'banking':
        serviceColor = AppColors.serviceBanking;
        break;
      case 'mobile':
        serviceColor = AppColors.serviceMobile;
        break;
      case 'market':
        serviceColor = AppColors.serviceMarket;
        break;
      case 'agri':
        serviceColor = AppColors.serviceAgri;
        break;
      case 'logistics':
        serviceColor = AppColors.serviceLogistics;
        break;
      case 'sme':
        serviceColor = AppColors.serviceSme;
        break;
      default:
        serviceColor = AppColors.primary;
    }
    emit(state.copyWith(primaryColor: serviceColor));
  }

  void reset() => emit(const ThemeState());
}
