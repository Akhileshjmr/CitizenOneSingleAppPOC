import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';

void main() {
  group('AppEnv Environment & Security Tests', () {
    test('Development environment initializes with logging enabled', () {
      final env = AppEnv.dev();
      expect(env.isDevelopment, isTrue);
      expect(env.isProduction, isFalse);
      expect(env.enableLogging, isTrue);
      expect(env.enableCertificatePinning, isFalse);
    });

    test('Staging environment initializes with certificate pinning enabled', () {
      final env = AppEnv.staging();
      expect(env.isStaging, isTrue);
      expect(env.isProduction, isFalse);
      expect(env.enableCertificatePinning, isTrue);
    });

    test('Production environment succeeds with valid HTTPS domain', () {
      final env = AppEnv.prod(
        apiBaseUrl: 'https://api.citizenone.gov',
      );
      expect(env.isProduction, isTrue);
      expect(env.enableCertificatePinning, isTrue);
      expect(env.enableLogging, isFalse);
    });

    test('Production rejects unencrypted HTTP endpoints (fail-closed)', () {
      expect(
        () => AppEnv.prod(apiBaseUrl: 'http://api.citizenone.gov'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Production endpoints must strictly use TLS'),
        )),
      );
    });

    test('Production rejects private IP addresses (fail-closed)', () {
      final privateIps = [
        'https://localhost:8080',
        'https://127.0.0.1:8080',
        'https://10.0.0.1/api',
        'https://192.168.1.50/api',
        'https://172.16.0.1/api',
        'https://172.31.255.255/api',
      ];

      for (final ip in privateIps) {
        expect(
          () => AppEnv.prod(apiBaseUrl: ip),
          throwsA(isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('cannot use localhost or private IP addresses'),
          )),
          reason: 'Failed to reject private endpoint $ip',
        );
      }
    });
  });
}

