import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/design_system/design_system.dart';

void main() {
  group('AppTheme Central vs Module Theme Configuration Flag Tests', () {
    tearDown(() {
      AppTheme.useCentralTheme = false;
    });

    test('Default configuration uses module-specific brand themes', () {
      expect(AppTheme.useCentralTheme, isFalse);

      final agencyTheme = AppTheme.getThemeForModule('agency_banking');
      final kycTheme = AppTheme.getThemeForModule('kyc');
      final loansTheme = AppTheme.getThemeForModule('loans');

      expect(agencyTheme.colorScheme.primary, equals(const Color(0xFF0F766E)));
      expect(kycTheme.colorScheme.primary, equals(const Color(0xFF6B21A8)));
      expect(loansTheme.colorScheme.primary, equals(const Color(0xFF1E40AF)));
    });

    test('When useCentralTheme flag is true, all modules return Central Theme', () {
      AppTheme.useCentralTheme = true;
      expect(AppTheme.useCentralTheme, isTrue);

      final agencyTheme = AppTheme.getThemeForModule('agency_banking');
      final kycTheme = AppTheme.getThemeForModule('kyc');
      final loansTheme = AppTheme.getThemeForModule('loans');
      final centralTheme = AppTheme.lightTheme;

      expect(agencyTheme.colorScheme.primary, equals(centralTheme.colorScheme.primary));
      expect(kycTheme.colorScheme.primary, equals(centralTheme.colorScheme.primary));
      expect(loansTheme.colorScheme.primary, equals(centralTheme.colorScheme.primary));
    });

    test('Toggling useCentralThemeNotifier notifies listeners and switches theme', () {
      bool notified = false;
      AppTheme.useCentralThemeNotifier.addListener(() {
        notified = true;
      });

      AppTheme.useCentralTheme = true;
      expect(notified, isTrue);
      expect(AppTheme.useCentralTheme, isTrue);

      final theme = AppTheme.getThemeForModule('insurance');
      expect(theme.colorScheme.primary, equals(AppTheme.lightTheme.colorScheme.primary));
    });
  });
}
