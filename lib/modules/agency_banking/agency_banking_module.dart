import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/agency_banking/module/module_entry.dart';
import 'features/dashboard/agency_dashboard_screen.dart';
import 'features/cash_deposit/routes/cash_deposit_routes.dart';
import 'features/cash_withdrawal/presentation/screens/cash_withdrawal_screen.dart';
import 'features/customer_onboarding/presentation/screens/customer_onboarding_screen.dart';
import 'features/transactions/presentation/screens/agency_transactions_screen.dart';
import 'features/loans/presentation/screens/agency_micro_loans_screen.dart';
import 'theme/agency_banking_theme.dart';

class AgencyBankingModule implements AppModule {
  @override
  ApiClient? apiClient;

  @override
  String get id => 'agency_banking';

  @override
  String get title => 'Agency Banking';

  @override
  String get initialRoute => '/agency-banking';

  @override
  ThemeData? get theme => AgencyBankingTheme.theme;

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/agency-banking',
          builder: (context, state) => const AgencyDashboardScreen(),
        ),
        GoRoute(
          path: '/agency_banking',
          builder: (context, state) => const AgencyDashboardScreen(),
        ),
        GoRoute(
          path: '/agency-banking/portal',
          builder: (context, state) {
            final authState = context.read<AuthCubit>().state;
            final user = authState is AuthAuthenticated ? authState.user : null;
            final phone = user?.username ?? '0971234567';
            final token = user?.token ?? '';
            return AgencyBankingModuleEntry.start(
              agentMobileNumber: phone,
              agentPassword: token,
              onExit: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/agency-banking');
                }
              },
              onSignOut: () {
                context.go('/login');
              },
            );
          },
        ),
        GoRoute(
          path: '/agency-banking/cash-withdrawal',
          builder: (context, state) => const CashWithdrawalScreen(),
        ),
        GoRoute(
          path: '/agency-banking/customer-onboarding',
          builder: (context, state) => const CustomerOnboardingScreen(),
        ),
        GoRoute(
          path: '/agency-banking/transactions',
          builder: (context, state) => const AgencyTransactionsScreen(),
        ),
        GoRoute(
          path: '/agency-banking/micro-loans',
          builder: (context, state) => const AgencyMicroLoansScreen(),
        ),
        ...getCashDepositRoutes(apiClient),
      ];

  @override
  List<BlocProvider> get providers => [];

  @override
  FutureOr<void> initialize({ApiClient? apiClient}) async {
    if (apiClient != null) {
      this.apiClient = apiClient;
    }
    AppLogger.info('Initializing Agency Banking module with host client and scoped authorization', id);
    try {
      await AgencyBankingModuleEntry.initialize(
        gatewayBaseUrl: apiClient?.baseUrl ?? 'http://192.168.3.69:8082',
      );
    } catch (e) {
      AppLogger.warning('AgencyBankingModuleEntry initialization notice: $e', id);
    }
  }

  @override
  FutureOr<void> dispose() async {
    AppLogger.info('Disposing in-memory caches and session for Agency Banking', id);
    try {
      await AgencyBankingModuleEntry.clearSession();
    } catch (e) {
      AppLogger.warning('Error during Agency Banking session clear: $e', id);
    }
  }

  @override
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {
    if (!isAuthenticated) {
      AppLogger.info('Session cleared for Agency Banking. Wiping state.', id);
      dispose();
    }
  }
}
