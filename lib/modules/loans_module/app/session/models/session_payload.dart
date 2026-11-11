class SessionPayload {
  SessionPayload({
    required this.reqSecureKey,
    required this.sessionToken,
    required this.issuedAt,
    required this.expiresAt,
    required this.validitySeconds,
  });

  final String reqSecureKey;
  final String sessionToken;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final int validitySeconds;

  factory SessionPayload.fromJson(Map<String, dynamic> json) {
    final token = (json['sessionToken'] ?? '').toString().trim();
    final issuedAtRaw = (json['issuedAt'] ?? '').toString();
    final expiresAtRaw = (json['expiresAt'] ?? '').toString();

    if (token.isEmpty) {
      throw const SessionException('Session token is missing.');
    }

    final issuedAt = DateTime.tryParse(issuedAtRaw);
    final expiresAt = DateTime.tryParse(expiresAtRaw);

    if (issuedAt == null || expiresAt == null) {
      throw const SessionException('Session dates are invalid.');
    }

    return SessionPayload(
      reqSecureKey: (json['reqSecureKey'] ?? '').toString(),
      sessionToken: token,
      issuedAt: issuedAt.toUtc(),
      expiresAt: expiresAt.toUtc(),
      validitySeconds: (json['validitySeconds'] as num?)?.toInt() ?? 0,
    );
  }
}

class SessionException implements Exception {
  const SessionException(this.message);

  final String message;

  @override
  String toString() => message;
}
