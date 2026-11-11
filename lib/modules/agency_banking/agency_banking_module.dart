import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/agency_banking/module/module_entry.dart';
import 'features/dashboard/agency_dashboard_screen.dart';
import 'features/cash_deposit/routes/cash_deposit_routes.dart';
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
