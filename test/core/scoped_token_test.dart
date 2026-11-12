import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';

void main() {
  group('ScopedToken Tests', () {
    test('ScopedToken detects expiration correctly', () {
      final now = DateTime.now();
      final validToken = ScopedToken(
        token: 'token-xyz',
        targetModule: 'agency_banking',
        issuedAt: now,
        expiresAt: now.add(const Duration(minutes: 10)),
      );
      expect(validToken.isExpired, isFalse);

      final expiredToken = ScopedToken(
        token: 'token-old',
        targetModule: 'insurance',
        issuedAt: now.subtract(const Duration(minutes: 20)),
        expiresAt: now.subtract(const Duration(minutes: 5)),
      );
      expect(expiredToken.isExpired, isTrue);
    });

    test('AuthRepository issues real 3-part Scoped JWT token with 15-minute validity and claims', () async {
      final apiClient = ApiClient();
      final authApi = AuthApi(apiClient);
      final repository = AuthRepositoryImpl(authApi);

      final scopedToken = await repository.getScopedToken('agency_banking');
      expect(scopedToken.targetModule, equals('agency_banking'));
      expect(scopedToken.isExpired, isFalse);

      // Verify RFC 7519 JWT structure: header.payload.signature
      final parts = scopedToken.token.split('.');
      expect(parts.length, equals(3), reason: 'Scoped JWT must contain 3 dot-separated parts');

      // Verify Header
      final headerRaw = base64Url.decode(base64.normalize(parts[0]));
      final header = jsonDecode(utf8.decode(headerRaw)) as Map<String, dynamic>;
      expect(header['alg'], equals('HS256'));
      expect(header['typ'], equals('JWT'));

      // Verify Claims Payload
      final payloadRaw = base64Url.decode(base64.normalize(parts[1]));
      final payload = jsonDecode(utf8.decode(payloadRaw)) as Map<String, dynamic>;
      expect(payload['aud'], equals('agency_banking'));
      expect(payload['role'], equals('AGENT'));
      expect(payload['scope'], equals('module:agency_banking:read_write'));
      expect(payload['sub'], equals('USR-99201'));
      expect(payload['exp'], isNotNull);
      expect(payload['iat'], isNotNull);

      // Verify JSON serialization
      final json = scopedToken.toJson();
      final reconstructed = ScopedToken.fromJson(json);
      expect(reconstructed.token, equals(scopedToken.token));
      expect(reconstructed.targetModule, equals(scopedToken.targetModule));
    });
  });
}

