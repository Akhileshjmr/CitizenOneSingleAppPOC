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

    test('AuthRepository issues scoped token with 15-minute validity', () async {
      final apiClient = ApiClient();
      final authApi = AuthApi(apiClient);
      final repository = AuthRepositoryImpl(authApi);

      final scopedToken = await repository.getScopedToken('agency_banking');
      expect(scopedToken.targetModule, equals('agency_banking'));
      expect(scopedToken.token, contains('scoped-jwt-agency_banking'));
      expect(scopedToken.isExpired, isFalse);
    });
  });
}

