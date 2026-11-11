class PasswordRule {
  final String label;
  final bool Function(String pwd) check;

  const PasswordRule({required this.label, required this.check});
}

class PasswordRules {
  static final RegExp _upper = RegExp(r'[A-Z]');
  static final RegExp _lower = RegExp(r'[a-z]');
  static final RegExp _digit = RegExp(r'[0-9]');
  static final RegExp _special = RegExp(r'[^A-Za-z0-9]');

  static final List<PasswordRule> all = [
    PasswordRule(
      label: '8–30 characters',
      check: (pwd) => pwd.length >= 8 && pwd.length <= 30,
    ),
    PasswordRule(
      label: 'Contains uppercase letter (A-Z)',
      check: (pwd) => _upper.hasMatch(pwd),
    ),
    PasswordRule(
      label: 'Contains lowercase letter (a-z)',
      check: (pwd) => _lower.hasMatch(pwd),
    ),
    PasswordRule(
      label: 'Contains a number (0-9)',
      check: (pwd) => _digit.hasMatch(pwd),
    ),
    PasswordRule(
      label: 'Contains a special character (!@#\$%^&*)',
      check: (pwd) => _special.hasMatch(pwd),
    ),
    PasswordRule(
      label: 'No successive identical characters over 3',
      check: (pwd) => !_hasSuccessiveRunOver(pwd, 3),
    ),
    PasswordRule(
      label: 'No character repeated more than 3 times anywhere',
      check: (pwd) => !_hasCharRepeatedMoreThan(pwd, 3),
    ),
  ];

  static bool isStrong(String pwd) {
    for (final rule in all) {
      if (!rule.check(pwd)) return false;
    }
    return true;
  }

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

