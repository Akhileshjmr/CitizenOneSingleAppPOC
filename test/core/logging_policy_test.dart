import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';

void main() {
  group('LoggingPolicy Redaction Tests', () {
    test('Redacts sensitive authorization and credential headers', () {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer secret-jwt-token-xyz',
        'X-Api-Key': 'key-12345',
        'Cookie': 'session=abc; token=123',
        'Custom-Header': 'public-value',
      };

      final sanitized = LoggingPolicy.redactHeaders(headers);

      expect(sanitized['Content-Type'], equals('application/json'));
      expect(sanitized['Authorization'], equals('[REDACTED]'));
      expect(sanitized['Cookie'], equals('[REDACTED]'));
      expect(sanitized['Custom-Header'], equals('public-value'));
    });

    test('Recursively redacts sensitive payload fields in maps and lists', () {
      final payload = {
        'username': 'agent_john',
        'password': 'SuperSecretPassword123!',
        'pin': '1234',
        'accountNumber': '9876543210',
        'meta': {
          'token': 'jwt.token.here',
          'clientSecret': 'shhh-secret',
          'publicData': 'visible',
        },
        'items': [
          {'secret': 'nested-secret', 'name': 'Item 1'},
        ],
      };

      final sanitized = LoggingPolicy.redactPayload(payload) as Map<String, dynamic>;

      expect(sanitized['username'], equals('agent_john'));
      expect(sanitized['password'], equals('[REDACTED]'));
      expect(sanitized['pin'], equals('[REDACTED]'));
      expect(sanitized['accountNumber'], equals('[REDACTED]'));

      final meta = sanitized['meta'] as Map<String, dynamic>;
      expect(meta['token'], equals('[REDACTED]'));
      expect(meta['clientSecret'], equals('[REDACTED]'));
      expect(meta['publicData'], equals('visible'));

      final items = sanitized['items'] as List<dynamic>;
      final firstItem = items[0] as Map<String, dynamic>;
      expect(firstItem['secret'], equals('[REDACTED]'));
      expect(firstItem['name'], equals('Item 1'));
    });

    test('Redacts inline sensitive strings and Bearer tokens', () {
      const rawLog =
          'Request dispatched with Bearer eyJhbGciOiJIUzI1NiI and password="my-secret-pw" to auth server';
      final sanitized = LoggingPolicy.redactString(rawLog);

      expect(sanitized, contains('Bearer [REDACTED]'));
      expect(sanitized, contains('password: "[REDACTED]"'));
      expect(sanitized, isNot(contains('my-secret-pw')));
    });
  });
}

