import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/app_router.dart';
import 'package:citizenone_app/modules/common/common.dart';
import 'package:citizenone_app/modules/agency_banking/agency_banking.dart';
import 'package:citizenone_app/modules/insurance/insurance.dart';
import 'package:citizenone_app/modules/kyc/kyc.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login({
    required String username,
    required String password,
    String? role,
  }) async {
    return UserModel(
      userId: 'U1',
      username: username,
      email: '$username@test.com',
      token: 'jwt-123',
      roles: [role ?? 'AGENT'],
    );
  }

  @override
  Future<void> requestPasswordReset(String emailOrUsername) async {}

  @override
  Future<String> requestRecoverUsername(String email) async => 'u***';

  @override
  Future<ScopedToken> getScopedToken(String targetModule, {String? userToken}) async {
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

    testWidgets('Guest deep linking to /agency-banking/portal is redirected to /login with redirect query', (tester) async {
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

      router.go('/agency-banking/portal');
      await tester.pumpAndSettle();

      final currentUri = router.routeInformationProvider.value.uri.toString();
      expect(currentUri, equals('/login?redirect=%2Fagency-banking%2Fportal'));
    });

    testWidgets('Guest deep linking to /agency-banking/cash-deposit is redirected to /login with redirect query', (tester) async {
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

      router.go('/agency-banking/cash-deposit');
      await tester.pumpAndSettle();

      final currentUri = router.routeInformationProvider.value.uri.toString();
      expect(currentUri, equals('/login?redirect=%2Fagency-banking%2Fcash-deposit'));
    });
  });

  group('Phase 4: Declarative Route Unification & Sub-Flow Registration', () {
    test('Router registers all Agency Banking & Insurance sub-routes declaratively', () {
      final enabledModules = <AppModule>[
        AgencyBankingModule(),
        InsuranceModule(),
        CommonModule(),
      ];

      final router = createAppRouter(enabledModules);
      final registeredPaths = getRegisteredPaths(router);

      // Declarative Agency Banking Routes
      expect(registeredPaths, contains('/agency-banking'));
      expect(registeredPaths, contains('/agency-banking/portal'));
      expect(registeredPaths, contains('/agency-banking/cash-deposit'));
      expect(registeredPaths, contains('/agency-banking/cash-withdrawal'));
      expect(registeredPaths, contains('/agency-banking/customer-onboarding'));
      expect(registeredPaths, contains('/agency-banking/transactions'));
      expect(registeredPaths, contains('/agency-banking/micro-loans'));

      // Declarative Insurance Routes
      expect(registeredPaths, contains('/insurance'));
      expect(registeredPaths, contains('/insurance/partners'));
      expect(registeredPaths, contains('/insurance/motor'));
      expect(registeredPaths, contains('/insurance/plans'));
      expect(registeredPaths, contains('/insurance/buy'));
      expect(registeredPaths, contains('/insurance/active-policies'));
      expect(registeredPaths, contains('/insurance/claims'));

      // Declarative Agent Dashboard Route & Unauthorized Route
      expect(registeredPaths, contains('/agent/dashboard'));
      expect(registeredPaths, contains('/unauthorized'));
    });

    testWidgets('Authenticated agent can navigate to /agency-banking and child screens declaratively', (tester) async {
      final authCubit = AuthCubit(MockAuthRepository());
      await authCubit.login(username: 'agent_user', password: 'password', role: 'AGENT');

      final enabledModules = <AppModule>[
        AgencyBankingModule(),
        InsuranceModule(),
        CommonModule(),
      ];
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
      expect(router.routeInformationProvider.value.uri.toString(), equals('/agency-banking'));

      router.go('/agency-banking/cash-deposit');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.toString(), equals('/agency-banking/cash-deposit'));

      router.go('/agency-banking/cash-withdrawal');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.toString(), equals('/agency-banking/cash-withdrawal'));

      router.go('/agency-banking/customer-onboarding');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.toString(), equals('/agency-banking/customer-onboarding'));

      router.go('/agency-banking/transactions');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.toString(), equals('/agency-banking/transactions'));

      router.go('/agency-banking/micro-loans');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.toString(), equals('/agency-banking/micro-loans'));
    });

    testWidgets('Non-agent user navigating to /agent/dashboard or /agency-banking is redirected to /unauthorized', (tester) async {
      final authCubit = AuthCubit(MockAuthRepository());
      // Log in as CITIZEN (non-agent)
      await authCubit.login(username: 'citizen_user', password: 'password', role: 'CITIZEN');

      final enabledModules = <AppModule>[
        AgencyBankingModule(),
        InsuranceModule(),
        CommonModule(),
      ];
      final router = createAppRouter(enabledModules, authCubit: authCubit);

      await tester.pumpWidget(
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      router.go('/agent/dashboard');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, equals('/unauthorized'));

      router.go('/agency-banking');
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, equals('/unauthorized'));
    });
  });
}
