import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/app_router.dart';
import 'package:citizenone_app/modules/common/common.dart';
import 'package:citizenone_app/modules/agency_banking/agency_banking.dart';
import 'package:citizenone_app/modules/kyc/kyc.dart';

void main() {
  List<String> getRegisteredPaths(GoRouter router) {
    final paths = <String>[];
    void extractRoutes(List<RouteBase> routes) {
      for (final route in routes) {
        if (route is GoRoute) {
          paths.add(route.path);
          extractRoutes(route.routes);
        } else if (route is ShellRoute) {
          extractRoutes(route.routes);
        }
      }
    }

    extractRoutes(router.configuration.routes);
    return paths;
  }

  group('GoRouter Module Selection Tests', () {
    test('Router contains routes ONLY from enabled modules', () {
      final enabledModules = <AppModule>[
        AgencyBankingModule(),
        KycModule(),
      ];

      final router = createAppRouter(enabledModules);
      final registeredPaths = getRegisteredPaths(router);

      expect(registeredPaths, contains('/'));
      expect(registeredPaths, contains('/agency-banking'));
      expect(registeredPaths, contains('/kyc'));

      expect(registeredPaths, isNot(contains('/common')));
      expect(registeredPaths, isNot(contains('/loans')));
      expect(registeredPaths, isNot(contains('/insurance')));
    });

    test('Router with Common Module enabled', () {
      final enabledModules = <AppModule>[
        CommonModule(),
      ];

      final router = createAppRouter(enabledModules);
      final registeredPaths = getRegisteredPaths(router);

      expect(registeredPaths, contains('/common'));
      expect(registeredPaths, contains('/login'));
      expect(registeredPaths, isNot(contains('/agency-banking')));
    });

    test('Router with Single Module Build (Build B: agency_banking)', () {
      final enabledModules = <AppModule>[
        AgencyBankingModule(),
      ];

      final router = createAppRouter(enabledModules);
      final registeredPaths = getRegisteredPaths(router);

      expect(registeredPaths, contains('/agency-banking'));
      expect(registeredPaths, isNot(contains('/kyc')));
      expect(registeredPaths, isNot(contains('/common')));
    });
  });
}
