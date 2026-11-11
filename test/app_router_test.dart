import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/app_router.dart';
import 'package:citizenone_app/modules/common/common.dart';
import 'package:citizenone_app/modules/agency_banking/agency_banking.dart';
import 'package:citizenone_app/modules/kyc/kyc.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    return UserModel(
      userId: 'U1',
      username: username,
      email: '$username@test.com',
      token: 'jwt-123',
      roles: const ['CITIZEN'],
    );
  }

  @override
  Future<void> requestPasswordReset(String emailOrUsername) async {}

  @override
  Future<String> requestRecoverUsername(String email) async => 'u***';

  @override
  Future<ScopedToken> getScopedToken(String targetModule) async {
    return ScopedToken(
      token: 'token-$targetModule',
      targetModule: targetModule,
      issuedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
    );
  }
}

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

  group('GoRouter Declarative Auth Route Guard Tests', () {
    testWidgets('Guest is redirected to /login when attempting to access protected route', (tester) async {
      final authCubit = AuthCubit(MockAuthRepository());
      final enabledModules = <AppModule>[AgencyBankingModule(), CommonModule()];
      final router = createAppRouter(enabledModules, authCubit: authCubit);

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      router.go('/agency-banking');
      await tester.pumpAndSettle();

      final currentUri = router.routeInformationProvider.value.uri.toString();
      expect(currentUri, equals('/login?redirect=%2Fagency-banking'));
    });

    testWidgets('Guest can access public routes without redirect', (tester) async {
      final authCubit = AuthCubit(MockAuthRepository());
      final enabledModules = <AppModule>[CommonModule()];
      final router = createAppRouter(enabledModules, authCubit: authCubit);

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      router.go('/');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.toString(), equals('/'));

      router.go('/performance-yield');
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.toString(),
        equals('/performance-yield'),
      );
    });

    testWidgets('Authenticated user is allowed direct access to protected module routes', (tester) async {
      final authCubit = AuthCubit(MockAuthRepository());
      await authCubit.login(username: 'agent_user', password: 'password');

      final enabledModules = <AppModule>[AgencyBankingModule(), CommonModule()];
      final router = createAppRouter(enabledModules, authCubit: authCubit);

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      router.go('/agency-banking');
      await tester.pumpAndSettle();

      expect(
        router.routeInformationProvider.value.uri.toString(),
        equals('/agency-banking'),
      );
    });
  });
}
