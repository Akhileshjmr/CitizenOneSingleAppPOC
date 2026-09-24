import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/app_router.dart';
import 'package:citizenone_app/modules/agency_banking/agency_banking.dart';
import 'package:citizenone_app/modules/kyc/kyc.dart';

void main() {
  group('GoRouter Module Selection Tests', () {
    test('Router contains routes ONLY from enabled modules', () {
      final enabledModules = <AppModule>[
        AgencyBankingModule(),
        KycModule(),
      ];

      final router = createAppRouter(enabledModules);

      final registeredPaths = router.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(registeredPaths, contains('/'));
      expect(registeredPaths, contains('/agency-banking'));
      expect(registeredPaths, contains('/kyc'));

      expect(registeredPaths, isNot(contains('/citizen-one')));
      expect(registeredPaths, isNot(contains('/loans')));
      expect(registeredPaths, isNot(contains('/insurance')));
    });

    test('Router with Single Module Build (Build B: agency_banking)', () {
      final enabledModules = <AppModule>[
        AgencyBankingModule(),
      ];

      final router = createAppRouter(enabledModules);
      final registeredPaths = router.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(registeredPaths, contains('/agency-banking'));
      expect(registeredPaths, isNot(contains('/kyc')));
      expect(registeredPaths, isNot(contains('/citizen-one')));
    });
  });
}
