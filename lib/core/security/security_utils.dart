import 'dart:convert';

class SecurityUtils {
  static String encodeBase64(String input) {
    return base64.encode(utf8.encode(input));
  }

  static String decodeBase64(String encoded) {
    return utf8.decode(base64.decode(encoded));
  }

  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    final visiblePart = accountNumber.substring(accountNumber.length - 4);
    final maskedPart = '*' * (accountNumber.length - 4);
    return '$maskedPart$visiblePart';
  }

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) return '$username***@$domain';
    return '${username[0]}***${username[username.length - 1]}@$domain';
  }

  static String generateNonce() {
    return 'NONCE-${DateTime.now().microsecondsSinceEpoch}';
  }
}
