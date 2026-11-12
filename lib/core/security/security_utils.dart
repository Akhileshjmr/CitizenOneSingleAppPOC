import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  static String sha256Hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String hmacSha256(String key, String input) {
    final hmac = Hmac(sha256, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(input));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  static String encodeBase64(String input) {
    return base64.encode(utf8.encode(input));
  }

  static String decodeBase64(String encoded) {
    return utf8.decode(base64.decode(encoded));
  }

  static String maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '*' * (phone.length - 4) + visible;
  }

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '$name***@$domain';
    return '${name.substring(0, 2)}***@$domain';
  }

  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    final visiblePart = accountNumber.substring(accountNumber.length - 4);
    final maskedPart = '*' * (accountNumber.length - 4);
    return '$maskedPart$visiblePart';
  }

  static String generateNonce() {
    return 'NONCE-${DateTime.now().microsecondsSinceEpoch}';
  }
}
