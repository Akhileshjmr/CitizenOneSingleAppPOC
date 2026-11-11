/// Centralized Logging Policy enforcing PII and credential redaction across all builds.
/// Fulfills Section 5 (Uncontrolled Logging & Centralized Redaction) of the Architecture Decision Proposal.
class LoggingPolicy {
  static const Set<String> sensitiveKeys = {
    'password',
    'pass',
    'pwd',
    'token',
    'accesstoken',
    'refreshtoken',
    'bearer',
    'authorization',
    'cookie',
    'secret',
    'clientsecret',
    'pin',
    'cvv',
    'ssn',
    'accountnumber',
    'cardnumber',
    'creditcard',
  };

  /// Redact sensitive request or response headers.
  static Map<String, String> redactHeaders(Map<String, String> headers) {
    final redacted = <String, String>{};
    for (final entry in headers.entries) {
      final normalizedKey =
          entry.key.toLowerCase().replaceAll(RegExp(r'[-_]'), '');
      if (sensitiveKeys.contains(normalizedKey) ||
          normalizedKey.contains('auth')) {
        redacted[entry.key] = '[REDACTED]';
      } else {
        redacted[entry.key] = entry.value;
      }
    }
    return redacted;
  }

  /// Recursively redacts sensitive payload structures (Maps, Lists, Strings).
  static dynamic redactPayload(dynamic payload) {
    if (payload is Map) {
      final sanitized = <String, dynamic>{};
      for (final entry in payload.entries) {
        final keyStr = entry.key.toString();
        final normalizedKey =
            keyStr.toLowerCase().replaceAll(RegExp(r'[-_]'), '');
        if (sensitiveKeys.contains(normalizedKey)) {
          sanitized[keyStr] = '[REDACTED]';
        } else {
          sanitized[keyStr] = redactPayload(entry.value);
        }
      }
      return sanitized;
    } else if (payload is List) {
      return payload.map(redactPayload).toList();
    } else if (payload is String) {
      return redactString(payload);
    }
    return payload;
  }

  /// Redacts sensitive patterns in raw log messages (e.g., Bearer tokens, passwords).
  static String redactString(String text) {
    var result = text;
    // Redact Bearer tokens
    result = result.replaceAll(
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', caseSensitive: false),
      'Bearer [REDACTED]',
    );
    // Redact key-value pairs matching password or token
    result = result.replaceAllMapped(
      RegExp(
        r'(password|token|secret|pin|authorization)["\s:=]+([^",\s}]+)',
        caseSensitive: false,
      ),
      (match) => '${match.group(1)}: "[REDACTED]"',
    );
    return result;
  }
}
