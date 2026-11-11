// =============================================================================
// Validators  —  Pure validation functions
// -----------------------------------------------------------------------------
// Lives in core/utils because it is consumed by both the design system
// (BaseTextField helper) and feature presentation layers (LoginBloc).
// Pure functions — no Flutter dependency, fully unit-testable.
// =============================================================================

import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? email(String? value) {
    final required0 = required(value, field: 'Email');
    if (required0 != null) return required0;
    if (!AppConstants.emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final required0 = required(value, field: 'Password');
    if (required0 != null) return required0;
    if (value!.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    return null;
  }

  static String? amount(String? value) {
    final required0 = required(value, field: 'Amount');
    if (required0 != null) return required0;
    final parsed = double.tryParse(value!.replaceAll(',', ''));
    if (parsed == null) return 'Enter a valid amount';
    if (parsed <= 0) return 'Amount must be greater than zero';
    return null;
  }
}
