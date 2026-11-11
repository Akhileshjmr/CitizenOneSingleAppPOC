import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/insurance/insurance.dart';
import 'package:citizenone_app/modules/agency_banking/features/cash_deposit/data/api/cash_deposit_api.dart';

void main() {
  group('Host ApiClient Propagation & Fail-Closed Tests', () {
    test('Module initialize() stores host-configured ApiClient instance', () {
      final env = AppEnv.dev(apiBaseUrl: 'https://custom-host.example.com');
      final hostClient = ApiClient(env: env);
      final insuranceModule = InsuranceModule();

      expect(insuranceModule.apiClient, isNull);

      insuranceModule.initialize(apiClient: hostClient);

      expect(insuranceModule.apiClient, isNotNull);
      expect(insuranceModule.apiClient!.baseUrl, equals('https://custom-host.example.com'));
      expect(insuranceModule.apiClient!.env, equals(env));
    });

    test('AuthApi fails closed in production when network fails', () async {
      // In production mode, network failure must rethrow instead of faking success
      final prodEnv = AppEnv.prod(apiBaseUrl: 'https://prod-api.citizenone.gov');
      final prodClient = ApiClient(env: prodEnv);
      final authApi = AuthApi(prodClient);

      expect(
        () => authApi.login(username: 'user', password: 'password'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('CashDepositApi fails closed in production when network fails', () async {
      final prodEnv = AppEnv.prod(apiBaseUrl: 'https://prod-api.citizenone.gov');
      final prodClient = ApiClient(env: prodEnv);
      final depositApi = CashDepositApi(prodClient);

      expect(
        () => depositApi.submitDeposit(
          accountNumber: '1234567890',
          amount: 100.0,
          depositorName: 'John Doe',
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('AuthApi provides transparent demo mock simulation in development mode', () async {
      final devEnv = AppEnv.dev();
      final devClient = ApiClient(env: devEnv);
      final authApi = AuthApi(devClient);

      // In dev mode, returns mock user after network failure
      final user = await authApi.login(username: 'dev_user', password: 'password');
      expect(user.username, equals('dev_user'));
      expect(user.token, isNotEmpty);
    });
  });
}

