import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/modules/common/features/agent/presentation/screens/agent_services_dashboard_screen.dart';
import 'package:citizenone_app/modules/common/features/auth/login/presentation/screens/login_screen.dart';

/// Helper that bridges a reactive stream (AuthCubit) to GoRouter's refresh listenable.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Creates the single root GoRouter for CitizenOne App.
/// Accepts the list of active enabled modules generated at build time
/// and an optional [authCubit] to enforce declarative authentication guards.
GoRouter createAppRouter(List<AppModule> modules, {AuthCubit? authCubit}) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable:
        authCubit != null ? GoRouterRefreshStream(authCubit.stream) : null,
    redirect: (context, state) {
      if (authCubit == null) return null;

      final isAuthenticated = authCubit.state is AuthAuthenticated;
      final path = state.uri.path;

      // Publicly accessible paths that guests can view without signing in
      final isPublic = path == '/' ||
          path == '/login' ||
          path.startsWith('/forgot-password') ||
          path.startsWith('/auth/forgot-password') ||
          path.startsWith('/forgot-username') ||
          path.startsWith('/auth/forgot-username') ||
          path == '/performance-yield' ||
          path == '/common' ||
          path == '/citizen-one';

      // If user is guest and attempts to access protected module route, redirect to login
      if (!isAuthenticated && !isPublic) {
        return '/login?redirect=${Uri.encodeComponent(path)}';
      }

      // If user is already authenticated and visits login, redirect to target or agent dashboard
      if (isAuthenticated && path == '/login') {
        final target = state.uri.queryParameters['redirect'];
        if (target != null && target.isNotEmpty) return target;
        return '/agent/dashboard';
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            location: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              final authState = authCubit?.state;
              if (authState is AuthAuthenticated) {
                return const AgentServicesDashboardScreen();
              }
              return const LoginScreen();
            },
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const AgentServicesDashboardScreen(),
          ),
          ...modules.expand((module) => module.routes),
        ],
      ),
    ],
    errorBuilder: (context, state) => AppShell(
      location: state.uri.path,
      child: Scaffold(
        body: Center(
          child: AppErrorView(
            title: '404 - Page Not Found',
            message:
                'The path "${state.uri.path}" is not available in the current build configuration.',
            onRetry: () => context.go('/login'),
          ),
        ),
      ),
    ),
  );
}
