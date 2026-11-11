import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:flutter/widgets.dart';

/// Single password rule. Each rule knows its localized label and how
/// to verify a candidate password.
class PasswordRule {
  final String Function(BuildContext) label;
  final bool Function(String pwd) check;

  const PasswordRule({required this.label, required this.check});
}

/// Password rule set used by the Create Password screen. Mirrors the
/// 7 rules from the reference image:
///   1.  8–30 characters
///   2.  Contains uppercase letter
///   3.  Contains lowercase letter
///   4.  Contains a number
///   5.  Contains a special character
///   6.  No successive characters over 3 (e.g. "aaaa" is fine,
///       "aaaaa" is not)
///   7.  No character repeated more than 3 times anywhere
class PasswordRules {
  static final RegExp _upper = RegExp(r'[A-Z]');
  static final RegExp _lower = RegExp(r'[a-z]');
  static final RegExp _digit = RegExp(r'[0-9]');
  static final RegExp _special = RegExp(r'[^A-Za-z0-9]');

  static final List<PasswordRule> all = [
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleLength,
      check: (pwd) => pwd.length >= 8 && pwd.length <= 30,
    ),
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleUpper,
      check: (pwd) => _upper.hasMatch(pwd),
    ),
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleLower,
      check: (pwd) => _lower.hasMatch(pwd),
    ),
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleDigit,
      check: (pwd) => _digit.hasMatch(pwd),
    ),
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleSpecial,
      check: (pwd) => _special.hasMatch(pwd),
    ),
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleNoSuccessiveOver3,
      check: (pwd) => !_hasSuccessiveRunOver(pwd, 3),
    ),
    PasswordRule(
      label: (ctx) => ctx.l10n.passwordRuleNoCharMoreThan3,
      check: (pwd) => !_hasCharRepeatedMoreThan(pwd, 3),
    ),
  ];

  /// True when every rule passes.
  static bool isStrong(String pwd) {
    for (final rule in all) {
      if (!rule.check(pwd)) return false;
    }
    return true;
  }

  /// Returns true when the password contains a run of the same
  /// character longer than [limit] (e.g. limit=3 → "aaaaa" returns
  /// true because the run length is 5 > 3).
  static bool _hasSuccessiveRunOver(String pwd, int limit) {
    if (pwd.length <= limit) return false;
    int run = 1;
    for (int i = 1; i < pwd.length; i++) {
      if (pwd[i] == pwd[i - 1]) {
        run++;
        if (run > limit) return true;
      } else {
        run = 1;
      }
    }
    return false;
  }

  /// Returns true when any single character appears more than [limit]
  /// times in the password (anywhere, not just consecutively).
  static bool _hasCharRepeatedMoreThan(String pwd, int limit) {
    if (pwd.length <= limit) return false;
    final counts = <String, int>{};
    for (int i = 0; i < pwd.length; i++) {
      final c = pwd[i];
      final n = (counts[c] ?? 0) + 1;
      counts[c] = n;
      if (n > limit) return true;
    }
    return false;
  }
}
